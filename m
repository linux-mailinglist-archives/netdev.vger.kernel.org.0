Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699BD4D1D9
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfFTPQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:16:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42017 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfFTPQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 11:16:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id z25so5221613edq.9
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 08:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J6CJXpXQVKtLeIxea44Tf+MH9YKRXsfmntTga0FhotM=;
        b=uXBe29WiqvSI8pa7UxAW5VIa1vhQtHzojdDSBEaCIrEG8+R8FexI6dKVAouG1eSWAP
         gHVDzC2TxRbQ3FHrmb5Ofovxt9jUUD4UMFnE3mZ/gLu/1UdnOA65ptqKTB8AeKizsh9w
         GFOspquucoNnwigpr/+6hyZUPivcwkhYKGJnqqGTM1iSlDp4ApUdnpw+rrZ4k6zYDivC
         2Chf9vCbETggdal8TUJzGCZlt4VIyY413yVl+9uXFI/UOcK7CNnI064Uqv1i1AafCpkU
         96aYnTy0E3hnxI/d+6AvYnF0aY9QE2SCZb29nA1QJ4vsCRLoEGaVbmqIbtsLulcDEqMW
         8gNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J6CJXpXQVKtLeIxea44Tf+MH9YKRXsfmntTga0FhotM=;
        b=mjfndWFvSp5Ej3EXqBxkJt/IzO3jHCy6gzdBuHK1UplW63PuRSXb1eUZXpYo7vFIfW
         +zSL8MEMHj+1RzXNf3TbAHRLo+2BvOcsiZGy1VpXXTCiBT6yyX4NpKVl9+qT8XTyX2Zv
         LfUsZBjNlsVdjAV+Wcdgoa0etou73rK5gWM+jIn6h2fEHeJEbDBGwgxUi4VfBxzhjqLF
         VmY3LpyZH2FTsYDXg49cCfmms69NpYIXsy83cmfoFSKbH8rm1wh4lL/f/PhrD9YTz/FO
         abZYKr+Zz/boN7j1uoVmHreYDf8aBp4+JwYaQhvKVBuSAz9VzSHGccZ3nKXE47Z0nVJy
         rOrA==
X-Gm-Message-State: APjAAAUMjJkSVXqxl3zbOFVt9FD+iEozyY4nou0QEHrg35KUukrzBiJX
        0EyUhAa1cmn+C+SSs0Lth7rGMy0IwK5Qp7pmS2OKRg==
X-Google-Smtp-Source: APXvYqzfftVq/Unbx6yJPCJZv4AIh3fHRbBV+i/XE8mmlK6TiotmgpIsKh/j4ri1mh7OhkqWsCCUW5Vst7eiTV/DDw4=
X-Received: by 2002:a17:906:76c8:: with SMTP id q8mr107523612ejn.229.1561043810643;
 Thu, 20 Jun 2019 08:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <CA+FuTSe=kJSSvcYwCE9-omRF5Snd9AyesZac61PYyAHDStPt=A@mail.gmail.com>
 <20190620142354.GB18890@hmswarspite.think-freely.org>
In-Reply-To: <20190620142354.GB18890@hmswarspite.think-freely.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 20 Jun 2019 11:16:13 -0400
Message-ID: <CAF=yD-KFZBS7PpvvBkHS5jQdjRr4tWpeHmb7=9QPmvD-RTcpYw@mail.gmail.com>
Subject: Re: [PATCH net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 10:24 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Thu, Jun 20, 2019 at 09:41:30AM -0400, Willem de Bruijn wrote:
> > On Wed, Jun 19, 2019 at 4:26 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > When an application is run that:
> > > a) Sets its scheduler to be SCHED_FIFO
> > > and
> > > b) Opens a memory mapped AF_PACKET socket, and sends frames with the
> > > MSG_DONTWAIT flag cleared, its possible for the application to hang
> > > forever in the kernel.  This occurs because when waiting, the code in
> > > tpacket_snd calls schedule, which under normal circumstances allows
> > > other tasks to run, including ksoftirqd, which in some cases is
> > > responsible for freeing the transmitted skb (which in AF_PACKET calls a
> > > destructor that flips the status bit of the transmitted frame back to
> > > available, allowing the transmitting task to complete).
> > >
> > > However, when the calling application is SCHED_FIFO, its priority is
> > > such that the schedule call immediately places the task back on the cpu,
> > > preventing ksoftirqd from freeing the skb, which in turn prevents the
> > > transmitting task from detecting that the transmission is complete.
> > >
> > > We can fix this by converting the schedule call to a completion
> > > mechanism.  By using a completion queue, we force the calling task, when
> > > it detects there are no more frames to send, to schedule itself off the
> > > cpu until such time as the last transmitted skb is freed, allowing
> > > forward progress to be made.
> > >
> > > Tested by myself and the reporter, with good results
> > >
> > > Appies to the net tree
> > >
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > > Reported-by: Matteo Croce <mcroce@redhat.com>
> > > CC: "David S. Miller" <davem@davemloft.net>
> > > ---
> >
> > This is a complex change for a narrow configuration. Isn't a
> > SCHED_FIFO process preempting ksoftirqd a potential problem for other
> > networking workloads as well? And the right configuration to always
> > increase ksoftirqd priority when increasing another process's
> > priority? Also, even when ksoftirqd kicks in, isn't some progress
> > still made on the local_bh_enable reached from schedule()?
> >
>
> A few questions here to answer:

Thanks for the detailed explanation.

> Regarding other protocols having this problem, thats not the case, because non
> packet sockets honor the SK_SNDTIMEO option here (i.e. they sleep for a period
> of time specified by the SNDTIMEO option if MSG_DONTWAIT isn't set.  We could
> certainly do that, but the current implementation doesn't (opting instead to
> wait indefinately until the respective packet(s) have transmitted or errored
> out), and I wanted to maintain that behavior.  If there is consensus that packet
> sockets should honor SNDTIMEO, then I can certainly do that.
>
> As for progress made by calling local_bh_enable, My read of the code doesn't
> have the scheduler calling local_bh_enable at all.  Instead schedule uses
> preempt_disable/preempt_enable_no_resched() to gain exlcusive access to the cpu,
> which ignores pending softirqs on re-enablement.

Ah, I'm mistaken there, then.

>  Perhaps that needs to change,
> but I'm averse to making scheduler changes for this (the aforementioned concern
> about complex changes for a narrow use case)
>
> Regarding raising the priority of ksoftirqd, that could be a solution, but the
> priority would need to be raised to a high priority SCHED_FIFO parameter, and
> that gets back to making complex changes for a narrow problem domain
>
> As for the comlexity of the of the solution, I think this is, given your
> comments the least complex and intrusive change to solve the given problem.

Could it be simpler to ensure do_softirq() gets run here? That would
allow progress for this case.

>  We
> need to find a way to force the calling task off the cpu while the asynchronous
> operations in the transmit path complete, and we can do that this way, or by
> honoring SK_SNDTIMEO.  I'm fine with doing the latter, but I didn't want to
> alter the current protocol behavior without consensus on that.

In general SCHED_FIFO is dangerous with regard to stalling other
progress, incl. ksoftirqd. But it does appear that this packet socket
case is special inside networking in calling schedule() directly here.

If converting that, should it convert to logic more akin to other
sockets, like sock_wait_for_wmem? I haven't had a chance to read up on
the pros and cons of completion here yet, sorry. Didn't want to delay
responding until after I get a chance.
