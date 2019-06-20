Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1DB4CFD7
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 16:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfFTOB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 10:01:56 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37660 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFTOB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 10:01:56 -0400
Received: by mail-lf1-f67.google.com with SMTP id d11so2535753lfb.4
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 07:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ilcmhlOn5o5aWtGRFIzvRxBk1G7cXwTgGUaB6hZT6O4=;
        b=mhRhtpfR+HdrVfgT/1NipQgDl2Pt6IWURMyH4TMO9BhZZQJqCzrxOQX1OCwoSqOw5z
         KgPFSuBBBpHoSDONczetzyrJWNz+IgjjoW3/TMQ6fB8aF9Xzjtrx1FkB49U6AY0bYemK
         JAWBVNf6UQ3ZuvzlTFcb8M4YFny1tLNaHpgN20yOXqbnqhwmDQFtEttHyPEv5WKNzXy3
         cPCDGtQJECt65RpuGYAmILTuJlcyBAamE6ngHwpwDM5PMJF2FtOeBIQuq6GqdDlyJhvt
         2O95WzvMP509wKihIbW2HAG9WQnikn1L/KgWrGLWHUvSZWvwGV1724NKfsb3+9bEWWRM
         lc+A==
X-Gm-Message-State: APjAAAVj6hoJXUlj3KGcwH4WLTIBvtcwd9TppXjtouQA2Pn4jN07fsyx
        4vbsgI10i3oxAwWagRPumguAiPZNQ3ozVtsppR9o2a6mo9s=
X-Google-Smtp-Source: APXvYqw+9n09HEFatFBxnOXK0XTy0vLeWgR958ZP2BewpnKNH3M7T4qJ9hwBVsAvPxKbVXjGob7lmEWchtZbxX4JsL8=
X-Received: by 2002:a19:dc0d:: with SMTP id t13mr39351113lfg.152.1561039314502;
 Thu, 20 Jun 2019 07:01:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <CA+FuTSe=kJSSvcYwCE9-omRF5Snd9AyesZac61PYyAHDStPt=A@mail.gmail.com>
In-Reply-To: <CA+FuTSe=kJSSvcYwCE9-omRF5Snd9AyesZac61PYyAHDStPt=A@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Thu, 20 Jun 2019 16:01:18 +0200
Message-ID: <CAGnkfhxWEOM5nXrN-fc7ywcxTXOTMSj83Vq6_NkDPowLy5=-EA@mail.gmail.com>
Subject: Re: [PATCH net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 3:42 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Jun 19, 2019 at 4:26 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > When an application is run that:
> > a) Sets its scheduler to be SCHED_FIFO
> > and
> > b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> > MSG_DONTWAIT flag cleared, its possible for the application to hang
> > forever in the kernel.  This occurs because when waiting, the code in
> > tpacket_snd calls schedule, which under normal circumstances allows
> > other tasks to run, including ksoftirqd, which in some cases is
> > responsible for freeing the transmitted skb (which in AF_PACKET calls a
> > destructor that flips the status bit of the transmitted frame back to
> > available, allowing the transmitting task to complete).
> >
> > However, when the calling application is SCHED_FIFO, its priority is
> > such that the schedule call immediately places the task back on the cpu,
> > preventing ksoftirqd from freeing the skb, which in turn prevents the
> > transmitting task from detecting that the transmission is complete.
> >
> > We can fix this by converting the schedule call to a completion
> > mechanism.  By using a completion queue, we force the calling task, when
> > it detects there are no more frames to send, to schedule itself off the
> > cpu until such time as the last transmitted skb is freed, allowing
> > forward progress to be made.
> >
> > Tested by myself and the reporter, with good results
> >
> > Appies to the net tree
> >
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > Reported-by: Matteo Croce <mcroce@redhat.com>
> > CC: "David S. Miller" <davem@davemloft.net>
> > ---
>
> This is a complex change for a narrow configuration. Isn't a
> SCHED_FIFO process preempting ksoftirqd a potential problem for other
> networking workloads as well? And the right configuration to always
> increase ksoftirqd priority when increasing another process's
> priority? Also, even when ksoftirqd kicks in, isn't some progress
> still made on the local_bh_enable reached from schedule()?

Hi Willem,

from my tests, it seems that when the application hangs, raising the
ksoftirqd priority doesn't help.
If the application priority is the same as ksoftirqd, it will loop
forever, the only workaround is to lower the application priority or
set it to SCHED_NORMAL

Regards,

-- 
Matteo Croce
per aspera ad upstream
