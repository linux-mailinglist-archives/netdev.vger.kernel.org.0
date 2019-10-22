Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 754B0E0E91
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 01:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389724AbfJVXhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 19:37:16 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42397 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732805AbfJVXhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 19:37:15 -0400
Received: by mail-qk1-f193.google.com with SMTP id m4so1135078qke.9
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 16:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SxDH2MC3dIvDcpX5lxZ6Q3L+W2CwFb0BSjYPclNc+5s=;
        b=sPfa/q/byWY2+7Hn+C2BJi79zjdBqk3v2vpzotcKzKWgvz/US699VypLShsR1FE0xn
         HoSmnl4W1yx0Zg47VhWYFvSxTicaWE5BsQJKzqWGxCS5sqBcpBKu38tBh+a8FL1O5Z0+
         3tl9QFtVs00aX65Mhrj0USlCsm5tksvq0eWdsoCIGZslYTpUs0DkWlf5BXiidjEmyFfm
         issgcyUzjYqXPY7d9XNi84i8pwmyT+O2TegVTRdypqWP9B/Ez6s+YXxt9mPLHp850Kfr
         BUlQ0aF4EKpaXoTjtH4a0bxg0KoBU8pZhDHayYemwEEhZZWw74ZaXu38Cqz5THcyfRIm
         vxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SxDH2MC3dIvDcpX5lxZ6Q3L+W2CwFb0BSjYPclNc+5s=;
        b=Vt2Ke9fJwqYTwZUlvD0jqghyECvwCOKbRCOOXrvvG7JoQWMGaOp7G/Yl2j5KB9cEAL
         116MTNFPs5n8BTwdYK9cHcSzo6w0viJF6A843fh9Mvd4DvlcnQTU2I/8MEX1gxW2vWUA
         RA3PWi/0p1zSVVtlLUZNMYUJ5oT9DhW4n7vxCMxidbAXViBgmNVx87T4976QuSFIRHth
         WEV6i9hGGq/1A4BKVzM1j6UM64USm31q1Ox9NBNc9uR6f2bFAuvELal+1WUFrSW1VVMk
         HJMfR91P53zf+CKKolFKRYFfr7LCdZzX9sD/zr6PzYVKT/OwCPuE9tYAMEyd9AXYyRAW
         wbwA==
X-Gm-Message-State: APjAAAVEuvRGGZ6HiDooZRsOM/wqNY6DwdPJVxCWSEowQOxnrPI+FSgS
        achERtgSiUXvVW6Gx0zQyQBrx3d1dwQ=
X-Google-Smtp-Source: APXvYqyGXnv0taqbCbCiK836ll+xYl7pcxtoIWqynv3sh+hDGIqgBnHcejuxoHJWIeEKtwYT3q/BLA==
X-Received: by 2002:a37:6212:: with SMTP id w18mr6001419qkb.204.1571787430558;
        Tue, 22 Oct 2019 16:37:10 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::3:869e])
        by smtp.gmail.com with ESMTPSA id r7sm10300827qkf.124.2019.10.22.16.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 16:37:09 -0700 (PDT)
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH] mm: memcontrol: fix network errors from failing __GFP_ATOMIC charges
Date:   Tue, 22 Oct 2019 19:37:08 -0400
Message-Id: <20191022233708.365764-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While upgrading from 4.16 to 5.2, we noticed these allocation errors
in the log of the new kernel:

[ 8642.253395] SLUB: Unable to allocate memory on node -1, gfp=0xa20(GFP_ATOMIC)
[ 8642.269170]   cache: tw_sock_TCPv6(960:helper-logs), object size: 232, buffer size: 240, default order: 1, min order: 0
[ 8642.293009]   node 0: slabs: 5, objs: 170, free: 0

        slab_out_of_memory+1
        ___slab_alloc+969
        __slab_alloc+14
        kmem_cache_alloc+346
        inet_twsk_alloc+60
        tcp_time_wait+46
        tcp_fin+206
        tcp_data_queue+2034
        tcp_rcv_state_process+784
        tcp_v6_do_rcv+405
        __release_sock+118
        tcp_close+385
        inet_release+46
        __sock_release+55
        sock_close+17
        __fput+170
        task_work_run+127
        exit_to_usermode_loop+191
        do_syscall_64+212
        entry_SYSCALL_64_after_hwframe+68

accompanied by an increase in machines going completely radio silent
under memory pressure.

One thing that changed since 4.16 is e699e2c6a654 ("net, mm: account
sock objects to kmemcg"), which made these slab caches subject to
cgroup memory accounting and control.

The problem with that is that cgroups, unlike the page allocator, do
not maintain dedicated atomic reserves. As a cgroup's usage hovers at
its limit, atomic allocations - such as done during network rx - can
fail consistently for extended periods of time. The kernel is not able
to operate under these conditions.

We don't want to revert the culprit patch, because it indeed tracks a
potentially substantial amount of memory used by a cgroup.

We also don't want to implement dedicated atomic reserves for cgroups.
There is no point in keeping a fixed margin of unused bytes in the
cgroup's memory budget to accomodate a consumer that is impossible to
predict - we'd be wasting memory and get into configuration headaches,
not unlike what we have going with min_free_kbytes. We do this for
physical mem because we have to, but cgroups are an accounting game.

Instead, account these privileged allocations to the cgroup, but let
them bypass the configured limit if they have to. This way, we get the
benefits of accounting the consumed memory and have it exert pressure
on the rest of the cgroup, but like with the page allocator, we shift
the burden of reclaimining on behalf of atomic allocations onto the
regular allocations that can block.

Cc: stable@kernel.org # 4.18+
Fixes: e699e2c6a654 ("net, mm: account sock objects to kmemcg")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8090b4c99ac7..c7e3e758c165 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2528,6 +2528,15 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
+	/*
+	 * Memcg doesn't have a dedicated reserve for atomic
+	 * allocations. But like the global atomic pool, we need to
+	 * put the burden of reclaim on regular allocation requests
+	 * and let these go through as privileged allocations.
+	 */
+	if (gfp_mask & __GFP_ATOMIC)
+		goto force;
+
 	/*
 	 * Unlike in global OOM situations, memcg is not in a physical
 	 * memory shortage.  Allow dying and OOM-killed tasks to
-- 
2.23.0

