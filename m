Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9786FE21EB
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbfJWRiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 13:38:50 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:36501 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbfJWRit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 13:38:49 -0400
Received: by mail-yw1-f68.google.com with SMTP id p187so2171205ywg.3
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 10:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Bi+2W5kUDlO+k7pkd4SMkD58ATKfCEmQGZr4H+xJPM=;
        b=TQaMD3J9qnPc1FpDhFyVtjUhTMNNL4eoGM/FFuzByySHDayFX7hlHjG3Fz9+1iXoj7
         OSLk63Z/3xqGbK5iWLOlBWZbCUQuMQLd62BFVUDDoOU93XB2PoCXJz+ObFhAkKauKZAR
         TEz2N1dDaGIwXJQJDQiIYriWtcMGAGJ3nvhlpLrHsISm0OcAK5PjeW7T9sXbWavkFXLX
         AbtGBs1jBnuyKV+DuHRbSfzxcdmZazlES7VYzWzxljxEXcmAsIOOaizkMbz5O8x7HK1y
         36q1UaANoHSvv55XmitjKLEvggWvdQ4/OUwWQhg+HGzZRs0wJqlP+wH9fwcNpRtRAPjR
         A70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Bi+2W5kUDlO+k7pkd4SMkD58ATKfCEmQGZr4H+xJPM=;
        b=jZrYj4LH/Vgfr3z7UwwHxMNF5a34XQUc3OGdVOkbjH/7ogbF9CDcLCS7l8C+NFJ0RY
         Sk+UVrQZTvN1okw3HomziZshHXTVqS6FFcmictslTDCpeEMwk2rMfQrwjfEksX1c2I3y
         C50DJ5F3deUBKBMyC8mLcM3CA66QqLW7mDzZ/6tp/OGVRp+2Ff3hZ1Bohg2Y3jvuub7g
         jiGd1J+9poHR05hQV87VRcDba7YWrQcFp4/ONI0E8rHxOBUW8G/j21LQSajfmaFL84de
         LoNUuSp+GsGFWBVG4tEBuPUW8FjR9kE1u06LEckHfznAnoD6qG8mTq0/q1FftqVfxYox
         mn6Q==
X-Gm-Message-State: APjAAAU2YGUBB0lhEfi5s4VV9gzTbkhNG9n4tz9dVhFMM+aK3PvL8QWF
        jElSRsk6JPjpR3jQDpQ2QQ6KA1KwEWWvNtSXg/L+vw==
X-Google-Smtp-Source: APXvYqxPDgnO4F7FM/DKbwbOrP6fUOIoNCBxlVC7chzutLJVJ75WvH5s2XcrPn/dORZ7b8Py0UqwMWfvbb35n1+WHSI=
X-Received: by 2002:a81:1189:: with SMTP id 131mr3897888ywr.308.1571852328225;
 Wed, 23 Oct 2019 10:38:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191022233708.365764-1-hannes@cmpxchg.org> <20191023064012.GB754@dhcp22.suse.cz>
 <20191023154618.GA366316@cmpxchg.org>
In-Reply-To: <20191023154618.GA366316@cmpxchg.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 23 Oct 2019 10:38:36 -0700
Message-ID: <CALvZod6fDEqDrYmmVC42552Ej4Y47FVZUj_irSZNxKWRF4vPYw@mail.gmail.com>
Subject: Re: [PATCH] mm: memcontrol: fix network errors from failing
 __GFP_ATOMIC charges
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, netdev@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 8:46 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Wed, Oct 23, 2019 at 08:40:12AM +0200, Michal Hocko wrote:
> > On Tue 22-10-19 19:37:08, Johannes Weiner wrote:
> > > While upgrading from 4.16 to 5.2, we noticed these allocation errors
> > > in the log of the new kernel:
> > >
> > > [ 8642.253395] SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
> > > [ 8642.269170]   cache: tw_sock_TCPv6(960:helper-logs), object size: 232, buffer size: 240, default order: 1, min order: 0
> > > [ 8642.293009]   node 0: slabs: 5, objs: 170, free: 0
> > >
> > >         slab_out_of_memory+1
> > >         ___slab_alloc+969
> > >         __slab_alloc+14
> > >         kmem_cache_alloc+346
> > >         inet_twsk_alloc+60
> > >         tcp_time_wait+46
> > >         tcp_fin+206
> > >         tcp_data_queue+2034
> > >         tcp_rcv_state_process+784
> > >         tcp_v6_do_rcv+405
> > >         __release_sock+118
> > >         tcp_close+385
> > >         inet_release+46
> > >         __sock_release+55
> > >         sock_close+17
> > >         __fput+170
> > >         task_work_run+127
> > >         exit_to_usermode_loop+191
> > >         do_syscall_64+212
> > >         entry_SYSCALL_64_after_hwframe+68
> > >
> > > accompanied by an increase in machines going completely radio silent
> > > under memory pressure.
> >
> > This is really worrying because that suggests that something depends on
> > GFP_ATOMIC allocation which is fragile and broken.
>
> I don't think that is true. You cannot rely on a *single instance* of
> atomic allocations to succeed. But you have to be able to rely on that
> failure is temporary and there is a chance of succeeding eventually.
>
> Network is a good example. It retries transmits, but within reason. If
> you aren't able to process incoming packets for minutes, you might as
> well be dead.
>
> > > One thing that changed since 4.16 is e699e2c6a654 ("net, mm: account
> > > sock objects to kmemcg"), which made these slab caches subject to
> > > cgroup memory accounting and control.
> > >
> > > The problem with that is that cgroups, unlike the page allocator, do
> > > not maintain dedicated atomic reserves. As a cgroup's usage hovers at
> > > its limit, atomic allocations - such as done during network rx - can
> > > fail consistently for extended periods of time. The kernel is not able
> > > to operate under these conditions.
> > >
> > > We don't want to revert the culprit patch, because it indeed tracks a
> > > potentially substantial amount of memory used by a cgroup.
> > >
> > > We also don't want to implement dedicated atomic reserves for cgroups.
> > > There is no point in keeping a fixed margin of unused bytes in the
> > > cgroup's memory budget to accomodate a consumer that is impossible to
> > > predict - we'd be wasting memory and get into configuration headaches,
> > > not unlike what we have going with min_free_kbytes. We do this for
> > > physical mem because we have to, but cgroups are an accounting game.
> > >
> > > Instead, account these privileged allocations to the cgroup, but let
> > > them bypass the configured limit if they have to. This way, we get the
> > > benefits of accounting the consumed memory and have it exert pressure
> > > on the rest of the cgroup, but like with the page allocator, we shift
> > > the burden of reclaimining on behalf of atomic allocations onto the
> > > regular allocations that can block.
> >
> > On the other hand this would allow to break the isolation by an
> > unpredictable amount. Should we put a simple cap on how much we can go
> > over the limit. If the memcg limit reclaim is not able to keep up with
> > those overflows then even __GFP_ATOMIC allocations have to fail. What do
> > you think?
>
> I don't expect a big overrun in practice, and it appears that Google
> has been letting even NOWAIT allocations pass through without
> isolation issues.

We have been overcharging for __GFP_HIGH allocations for couple of
years and see no isolation issues in the production.

> Likewise, we have been force-charging the skmem for
> a while now and it hasn't been an issue for reclaim to keep up.
>
> My experience from production is that it's a whole lot easier to debug
> something like a memory.max overrun than it is to debug a machine that
> won't respond to networking. So that's the side I would err on.
