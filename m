Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9C2E1FE1
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406940AbfJWPqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:46:22 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38346 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406934AbfJWPqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:46:21 -0400
Received: by mail-qk1-f194.google.com with SMTP id p4so20196274qkf.5
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zwE9Z3/9LcARux9+B76rcKwvDcmouV9c6zymdxIVL7A=;
        b=rp22pdO+QJHOU3Ho1UY7xorn4AuL580GE2ZqkiG4d0nMzXkU1MfXodmLe7hD1ECc7D
         IMC7Vvg31Z/tmSkTKeeEmklazG16Zz/DPdfshuBOKlhM66xv44LcaukLTPllAgDPxKh4
         W4x7z1ZcwGuVAvUiVdsJHQ9/Kvzfx/ygtO20SMcSux2IGgsogJHtQBXEIqbOsxDYt+Ky
         hjkl01/xYV9eQ/viklG2tHO7G/RInBKIybiOtsUrJHphXUicWp0fhuvXW8fxwJ4593/j
         vZWiwCQMkwTwVOTvxAwdaAXYBhqGp7zxO/3j8tKGXer3bofrn+ImDKl91U5K6RaR8+6T
         yTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zwE9Z3/9LcARux9+B76rcKwvDcmouV9c6zymdxIVL7A=;
        b=J8u+vZu+MgaoE2ckw+yk37UnsTAqBx8sjE5224hETIudoGOPG9z6FMLZr62KFOIwGr
         Rz0IoE0ipZnISlwGW5i8QQEiC+d/3vB/Ma4nebGaBUn+dbmH7AaW86d81VlnFfh8pJ32
         3Dt0ObpveQkC8OvssIaG++MpTdyfFfummKAl0FnSrrxVsBVIaB3JlbX5RUo/e+Ikft/x
         x6KS2zZ12Nh7N02psod2OBDhMCSVL4g8ugH1pguhYdygGsOuoZll/RIl2rdP/PaCwlwS
         cv6MsOX+VzHYaI+2iy7LiGHg5bBlKUpp8vvV2iZJx21mQpSiXwfQ5Rn/xrS3SJl1j0fy
         QGcA==
X-Gm-Message-State: APjAAAWhbPor14mX/OWASvnBhS6XKYTFpiLrDmjDKkjYRssbn3Nu1pia
        NN//rfLJ3IkCqJPkTYMQhzETBQ==
X-Google-Smtp-Source: APXvYqwpPwSqe1LKFk3kNgNKJTo9hCoU0ly3Tu3ZRRk/g8ZcsQfWZ5klMQOr6f4kbGjWBHGc2zlrRQ==
X-Received: by 2002:a37:4f88:: with SMTP id d130mr9187473qkb.168.1571845580395;
        Wed, 23 Oct 2019 08:46:20 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::2:c4de])
        by smtp.gmail.com with ESMTPSA id h23sm11237712qkk.128.2019.10.23.08.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 08:46:19 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:46:18 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] mm: memcontrol: fix network errors from failing
 __GFP_ATOMIC charges
Message-ID: <20191023154618.GA366316@cmpxchg.org>
References: <20191022233708.365764-1-hannes@cmpxchg.org>
 <20191023064012.GB754@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023064012.GB754@dhcp22.suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 08:40:12AM +0200, Michal Hocko wrote:
> On Tue 22-10-19 19:37:08, Johannes Weiner wrote:
> > While upgrading from 4.16 to 5.2, we noticed these allocation errors
> > in the log of the new kernel:
> > 
> > [ 8642.253395] SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
> > [ 8642.269170]   cache: tw_sock_TCPv6(960:helper-logs), object size: 232, buffer size: 240, default order: 1, min order: 0
> > [ 8642.293009]   node 0: slabs: 5, objs: 170, free: 0
> > 
> >         slab_out_of_memory+1
> >         ___slab_alloc+969
> >         __slab_alloc+14
> >         kmem_cache_alloc+346
> >         inet_twsk_alloc+60
> >         tcp_time_wait+46
> >         tcp_fin+206
> >         tcp_data_queue+2034
> >         tcp_rcv_state_process+784
> >         tcp_v6_do_rcv+405
> >         __release_sock+118
> >         tcp_close+385
> >         inet_release+46
> >         __sock_release+55
> >         sock_close+17
> >         __fput+170
> >         task_work_run+127
> >         exit_to_usermode_loop+191
> >         do_syscall_64+212
> >         entry_SYSCALL_64_after_hwframe+68
> > 
> > accompanied by an increase in machines going completely radio silent
> > under memory pressure.
> 
> This is really worrying because that suggests that something depends on
> GFP_ATOMIC allocation which is fragile and broken. 

I don't think that is true. You cannot rely on a *single instance* of
atomic allocations to succeed. But you have to be able to rely on that
failure is temporary and there is a chance of succeeding eventually.

Network is a good example. It retries transmits, but within reason. If
you aren't able to process incoming packets for minutes, you might as
well be dead.

> > One thing that changed since 4.16 is e699e2c6a654 ("net, mm: account
> > sock objects to kmemcg"), which made these slab caches subject to
> > cgroup memory accounting and control.
> > 
> > The problem with that is that cgroups, unlike the page allocator, do
> > not maintain dedicated atomic reserves. As a cgroup's usage hovers at
> > its limit, atomic allocations - such as done during network rx - can
> > fail consistently for extended periods of time. The kernel is not able
> > to operate under these conditions.
> > 
> > We don't want to revert the culprit patch, because it indeed tracks a
> > potentially substantial amount of memory used by a cgroup.
> > 
> > We also don't want to implement dedicated atomic reserves for cgroups.
> > There is no point in keeping a fixed margin of unused bytes in the
> > cgroup's memory budget to accomodate a consumer that is impossible to
> > predict - we'd be wasting memory and get into configuration headaches,
> > not unlike what we have going with min_free_kbytes. We do this for
> > physical mem because we have to, but cgroups are an accounting game.
> > 
> > Instead, account these privileged allocations to the cgroup, but let
> > them bypass the configured limit if they have to. This way, we get the
> > benefits of accounting the consumed memory and have it exert pressure
> > on the rest of the cgroup, but like with the page allocator, we shift
> > the burden of reclaimining on behalf of atomic allocations onto the
> > regular allocations that can block.
> 
> On the other hand this would allow to break the isolation by an
> unpredictable amount. Should we put a simple cap on how much we can go
> over the limit. If the memcg limit reclaim is not able to keep up with
> those overflows then even __GFP_ATOMIC allocations have to fail. What do
> you think?

I don't expect a big overrun in practice, and it appears that Google
has been letting even NOWAIT allocations pass through without
isolation issues. Likewise, we have been force-charging the skmem for
a while now and it hasn't been an issue for reclaim to keep up.

My experience from production is that it's a whole lot easier to debug
something like a memory.max overrun than it is to debug a machine that
won't respond to networking. So that's the side I would err on.
