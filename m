Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC730E7A1D
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbfJ1Ubn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:31:43 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36707 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbfJ1Ubn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:31:43 -0400
Received: by mail-yb1-f194.google.com with SMTP id c13so3968912ybq.3
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 13:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dacaoOxH2WzD4bx0LIqEpnlBr9MqSH5lh6kHIJunATc=;
        b=l3CEGagQ9hBjBbEEQnotO1F93B6/CgPIkULjq66DkHnA+cI6gGnim6ylHs4HdKSYku
         GWvYut82A1+sgCBrQTbwfnLSg6rnmVtAkUxFv8eQRQhRMSzSw992HmYzgk/xRarYVSvx
         Wb9E1VaRHqQJEVOMMEWtI1c+sZeTQVFfUk5z9Gh92T5I/THl4RQr+AgxHNRJt76cOuPT
         +5T/fRXfINUobjeKaZwz8bGeYCncG2iWqqYXDrqGYA8mpJNP67mrWJ9P/mpBwY/zW4uz
         sHjySHNLMGwdJrIu9cBEUo5u9pC/lH+X3BuqMajtdgXXvs2sOzQavQl2xJkBi+cK+KHh
         2q7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dacaoOxH2WzD4bx0LIqEpnlBr9MqSH5lh6kHIJunATc=;
        b=EPjNUnIgN4bo3wuKqjmEncRNiF/ctBFzOZ0fG8EU4y7IjhjRgIC77+KMVE0vLvxQQT
         F9Ll+rr2Yt7AHL6mUgu44Czeke6EEl6zoPI0ISgE6Yl+L4e3PCzy6WTsYN/JOBnfLkq0
         b3SMSQSS3lH3g+f/RQi20Jt+o8OLrGaOFw95NldAFs+NQvvk5tF88uKFzBdeoJir4WIH
         Ce7adkDklz266eFnJwzcvcgUmSh1XUZIVgTAKRpyhJUffBaU5ba4bExloYgquRuNtrRa
         bKdUJbmDBe4U/2yaSCaYkUODA47CX/5qVbGtckgmZpYLG+65p7xJUkEBJSV+UooAhbjQ
         9/TA==
X-Gm-Message-State: APjAAAVrw9D/O1NoNr3Byte/PZcj7ToSLBby6bzI3u9pbjERfNvd5yF3
        3flBawGX2IPaF1z5RSbTyAXhR0Bz318HlNOF9YGznqh1
X-Google-Smtp-Source: APXvYqwM3/j4Gl6JrM80akLV3K1sujJp5IzToya2nVDOsGecvXDV+pWaRrASUp6mu2ZYb9bv4BmUqCS+pxg5MgB/ZBQ=
X-Received: by 2002:a25:26c9:: with SMTP id m192mr16764849ybm.274.1572294701436;
 Mon, 28 Oct 2019 13:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
 <20191028.112904.824821320861730754.davem@davemloft.net> <CANn89iKeB9+6xAyjQUZvtX3ioLNs3sBwCDq0QxmYEy5X_nF+LA@mail.gmail.com>
 <CAM_iQpU1oG8J9Nf-nZoZDf3wO9c4dHAaa0=HK0X-QMeHMtmrCQ@mail.gmail.com>
In-Reply-To: <CAM_iQpU1oG8J9Nf-nZoZDf3wO9c4dHAaa0=HK0X-QMeHMtmrCQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 28 Oct 2019 13:31:30 -0700
Message-ID: <CANn89iL1Fpn3g-SS3hYEhdKaZiMr0BP8WPJ7oM1Ta13xJHUFnw@mail.gmail.com>
Subject: Re: [Patch net-next 0/3] tcp: decouple TLP timer from RTO timer
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 1:13 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Oct 28, 2019 at 11:34 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Oct 28, 2019 at 11:29 AM David Miller <davem@davemloft.net> wrote:
> > >
> > > From: Cong Wang <xiyou.wangcong@gmail.com>
> > > Date: Tue, 22 Oct 2019 16:10:48 -0700
> > >
> > > > This patchset contains 3 patches: patch 1 is a cleanup,
> > > > patch 2 is a small change preparing for patch 3, patch 3 is the
> > > > one does the actual change. Please find details in each of them.
> > >
> > > Eric, have you had a chance to test this on a system with
> > > suitable CPU arity?
> >
> > Yes, and I confirm I could not repro the issues at all.
> >
> > I got a 100Gbit NIC, trying to increase the pressure a bit, and
> > driving this NIC at line rate was only using 2% of my 96 cpus host,
> > no spinlock contention of any sort.
>
> Please let me know if there is anything else I can provide to help
> you to make the decision.
>
> All I can say so far is this only happens on our hosts with 128
> AMD CPU's. I don't see anything here related to AMD, so I think
> only the number of CPU's (vs. number of TX queues?) matters.
>

I also have AMD hosts with 256 cpus, I can try them later (not today,
I am too busy)

But I feel you are trying to work around a more fundamental issue if
this problem only shows up on AMD hosts.
