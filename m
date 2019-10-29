Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4A4E7D9E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 01:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfJ2Att (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 20:49:49 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42357 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJ2Ats (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 20:49:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id f14so8227052pgi.9
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 17:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rbjv+0Gpbrf5P8/4TYl2ACIT3sF2IgpZBFpaTxjVPCM=;
        b=CXZfP1FxkBB09x9+OoCDBMceR3tyI0wLbWDZDtieTJ5HBBals+J8qqX/rAfi+yaur1
         ALe5B0znSCMZD/Bkz4sxnZXxqf8vsQF8e5PI1YlC+psaHMB2pmNCaipl7/drD9Ze+On8
         RtGbValaW7iyvz8fYxSXKHSnPWZvG5rdWcPVE5UnDfpWfVzTa1oBbLy9zFSeKOBSYQEE
         3s91tDJZTf9V6rnNWksZZ68qf0hfbylWzeo6N438O2ikRqxLTgp15hkwcUWs0fVwQlUN
         Z29t5/I1dWBSusln+Q1Rz029X4/YyJpmiqMl2/pRGUJkvnt2LHDCjjerjM/U76T6yq+I
         VWqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rbjv+0Gpbrf5P8/4TYl2ACIT3sF2IgpZBFpaTxjVPCM=;
        b=XVwE3Mmj7sY9Tnx12r1UNhO88z3jaHG87k/EdrvbsvcDrS3mYGi1X3Z0uUx17LghLx
         cGtEPad7OIX+rufM49J1uvcgBhq6Ha8l6+lKbSz/o0VfuAVMCJZ1he6fsBNGRAYuPeUy
         ChOpsJwiC81JGMKiGmx6Aj94ZN65a3HRS9WPNNVZav+TToU/CF+6tdR3VH8F2e2H//Z0
         03Lq8DCVie2yY35jr6m2Je9mChjyp2xeTOlEyQohfUhoM6BYqoCjrKE/1xJbGt7CMlur
         6KedBgacKqp4bScha8YXZO8N4mrzuQqVB1oioynJOMgMgyLVK64EK/Jmv2DdRrsmgHA/
         ikYA==
X-Gm-Message-State: APjAAAVxsd9dM/VdmARAkjDSjSnualCHphsOEtTn1y4BH93x+4HGBKa2
        e7+yveZmARa+oWvI5fHyHIVcQw6QeJ+dIxrcdPg2djXm
X-Google-Smtp-Source: APXvYqy/CyTh6VHl9lV5jCFgRlzDSeq/XBiyXuuuZabo33QYf6svVnfuNkUKYz576h9J197kpwEq3FHzZsaH8OcFHjU=
X-Received: by 2002:aa7:8dd9:: with SMTP id j25mr23312064pfr.94.1572310187711;
 Mon, 28 Oct 2019 17:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
 <20191028.112904.824821320861730754.davem@davemloft.net> <CANn89iKeB9+6xAyjQUZvtX3ioLNs3sBwCDq0QxmYEy5X_nF+LA@mail.gmail.com>
 <CAM_iQpU1oG8J9Nf-nZoZDf3wO9c4dHAaa0=HK0X-QMeHMtmrCQ@mail.gmail.com> <CANn89iL1Fpn3g-SS3hYEhdKaZiMr0BP8WPJ7oM1Ta13xJHUFnw@mail.gmail.com>
In-Reply-To: <CANn89iL1Fpn3g-SS3hYEhdKaZiMr0BP8WPJ7oM1Ta13xJHUFnw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 28 Oct 2019 17:49:35 -0700
Message-ID: <CAM_iQpW=VXDRbOkEuK+mr+4G2FgfmT11yYKt4DbhGB2QGqeeYA@mail.gmail.com>
Subject: Re: [Patch net-next 0/3] tcp: decouple TLP timer from RTO timer
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 1:31 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Oct 28, 2019 at 1:13 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Oct 28, 2019 at 11:34 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Mon, Oct 28, 2019 at 11:29 AM David Miller <davem@davemloft.net> wrote:
> > > >
> > > > From: Cong Wang <xiyou.wangcong@gmail.com>
> > > > Date: Tue, 22 Oct 2019 16:10:48 -0700
> > > >
> > > > > This patchset contains 3 patches: patch 1 is a cleanup,
> > > > > patch 2 is a small change preparing for patch 3, patch 3 is the
> > > > > one does the actual change. Please find details in each of them.
> > > >
> > > > Eric, have you had a chance to test this on a system with
> > > > suitable CPU arity?
> > >
> > > Yes, and I confirm I could not repro the issues at all.
> > >
> > > I got a 100Gbit NIC, trying to increase the pressure a bit, and
> > > driving this NIC at line rate was only using 2% of my 96 cpus host,
> > > no spinlock contention of any sort.
> >
> > Please let me know if there is anything else I can provide to help
> > you to make the decision.
> >
> > All I can say so far is this only happens on our hosts with 128
> > AMD CPU's. I don't see anything here related to AMD, so I think
> > only the number of CPU's (vs. number of TX queues?) matters.
> >
>
> I also have AMD hosts with 256 cpus, I can try them later (not today,
> I am too busy)
>
> But I feel you are trying to work around a more fundamental issue if
> this problem only shows up on AMD hosts.

I wish I have Intel hosts with the same number of CPU's, but I don't,
all Intel ones have less, probably 80 at max. This is why I think it
is related to the number of CPU's.

Also, IOMMU is turned off explicitly, I don't see anything else could
be AMD specific along the TCP path.

Thanks.
