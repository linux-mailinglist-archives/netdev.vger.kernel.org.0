Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E0B4FFD9A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 20:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiDMSQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 14:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbiDMSQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 14:16:00 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E47496BE
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:13:38 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s137so2512990pgs.5
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VdAR39GeJ30HYwCF1dGMPnCGrq/yFAelZKC0NnUWDa0=;
        b=Vcu8tpWZeL6WOIBAHz/pUd4lhEMwhThInep6MfL+T53R9u5ljISIKE803ivh+8BaVm
         tTyehauZM39STOqtam227qc+kKFARlnnObE7YXmHbSyYMMAxSR9WE6x1O7NkjuVR8vge
         9KwXM6YYF/qWUaWKqmSIfzjRLHUsPwGtTlrrH+/wzcJ8n2xEU1LEGj1QO2L8RoOIf/+C
         Zxwc+HHRwOc70+zYfhWygLX26C0HGbPnADDajutPjekqlWonwDNyhavc2c1GzjWC/UOO
         LsGEHnbaG3GX+kK/28wzMJ0Ta0XjPLADsADSt54vvJevGyaLdW/kuL6WNfsAQAYPqqY/
         kSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VdAR39GeJ30HYwCF1dGMPnCGrq/yFAelZKC0NnUWDa0=;
        b=ICGi9fuRqgiD9+MBCeUyQ2CXw/lSlW6ef+qA0zRVJ7s5iL63ANp/O12aEdBpq1RPvg
         dvJoVD6sQrsCpCqrjMq/eFqJc+kxk4gkDL/utBZ+lWo+JSqiMIB0XJUG/fy5Cd8j3pYX
         Q5OFeoxNKkrOMdJURw7G8M2rwyhGF2HI3SHuCNUIMD9axhXUUGp4Sz4yuS0cFJFFSD3y
         1LbkGOOZcVyXK3UmrNzZ558z81hNiFaTsu0+jZjL4xbuzfoMaL3Q07gqZhqV3HuyNnR9
         L9yRx3wZWi/SdFKgO5C3F6MRgDArfQByHrFSGjYGj8vZogGgxat/cIrt9IL6a6QR9Dkq
         KJgw==
X-Gm-Message-State: AOAM531wFVb1dr9EO7YtP+/KTLLi8vE18dkXlHyvH83umzgvynSa02XW
        uPaA8rV9y4skb7rtSHKdXiU=
X-Google-Smtp-Source: ABdhPJzhzgorl+BHdL51hkci7FNJ6yPb1P5Mk1b1bxwvhvq2DmPU+qDW+D+Wwfyvy5dzEThETvyqFg==
X-Received: by 2002:a63:6c0a:0:b0:398:6bd2:a16a with SMTP id h10-20020a636c0a000000b003986bd2a16amr36618869pgc.191.1649873617992;
        Wed, 13 Apr 2022 11:13:37 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bfb5:153b:b727:ea])
        by smtp.gmail.com with ESMTPSA id w60-20020a17090a6bc200b001cbc1a6963asm3800186pjj.29.2022.04.13.11.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 11:13:37 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] ipv6: make ip6_rt_gc_expire an atomic_t
Date:   Wed, 13 Apr 2022 11:13:33 -0700
Message-Id: <20220413181333.649424-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Reads and Writes to ip6_rt_gc_expire always have been racy,
as syzbot reported lately [1]

There is a possible risk of under-flow, leading
to unexpected high value passed to fib6_run_gc(),
although I have not observed this in the field.

Hosts hitting ip6_dst_gc() very hard are under pretty bad
state anyway.

[1]
BUG: KCSAN: data-race in ip6_dst_gc / ip6_dst_gc

read-write to 0xffff888102110744 of 4 bytes by task 13165 on cpu 1:
 ip6_dst_gc+0x1f3/0x220 net/ipv6/route.c:3311
 dst_alloc+0x9b/0x160 net/core/dst.c:86
 ip6_dst_alloc net/ipv6/route.c:344 [inline]
 icmp6_dst_alloc+0xb2/0x360 net/ipv6/route.c:3261
 mld_sendpack+0x2b9/0x580 net/ipv6/mcast.c:1807
 mld_send_cr net/ipv6/mcast.c:2119 [inline]
 mld_ifc_work+0x576/0x800 net/ipv6/mcast.c:2651
 process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
 worker_thread+0x618/0xa70 kernel/workqueue.c:2436
 kthread+0x1a9/0x1e0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30

read-write to 0xffff888102110744 of 4 bytes by task 11607 on cpu 0:
 ip6_dst_gc+0x1f3/0x220 net/ipv6/route.c:3311
 dst_alloc+0x9b/0x160 net/core/dst.c:86
 ip6_dst_alloc net/ipv6/route.c:344 [inline]
 icmp6_dst_alloc+0xb2/0x360 net/ipv6/route.c:3261
 mld_sendpack+0x2b9/0x580 net/ipv6/mcast.c:1807
 mld_send_cr net/ipv6/mcast.c:2119 [inline]
 mld_ifc_work+0x576/0x800 net/ipv6/mcast.c:2651
 process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
 worker_thread+0x618/0xa70 kernel/workqueue.c:2436
 kthread+0x1a9/0x1e0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30

value changed: 0x00000bb3 -> 0x00000ba9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 11607 Comm: kworker/0:21 Not tainted 5.18.0-rc1-syzkaller-00037-g42e7a03d3bad-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: mld mld_ifc_work

Fixes: 1da177e4c3 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/netns/ipv6.h |  4 ++--
 net/ipv6/route.c         | 11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 3d83b64471d32391fb632e8c25e12a8ec7d1b42e..b4af4837d80b4ed47d05474432d5b8ebb42322e7 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -75,8 +75,8 @@ struct netns_ipv6 {
 	struct list_head	fib6_walkers;
 	rwlock_t		fib6_walker_lock;
 	spinlock_t		fib6_gc_lock;
-	unsigned int		 ip6_rt_gc_expire;
-	unsigned long		 ip6_rt_last_gc;
+	atomic_t		ip6_rt_gc_expire;
+	unsigned long		ip6_rt_last_gc;
 	unsigned char		flowlabel_has_excl;
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	bool			fib6_has_custom_rules;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 169e9df6d172ead607cc20a108c3371a20dbc632..c4b6ce017d5e3bf63c66a53df3d46c08370aed23 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3292,6 +3292,7 @@ static int ip6_dst_gc(struct dst_ops *ops)
 	int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
 	int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
 	unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
+	unsigned int val;
 	int entries;
 
 	entries = dst_entries_get_fast(ops);
@@ -3302,13 +3303,13 @@ static int ip6_dst_gc(struct dst_ops *ops)
 	    entries <= rt_max_size)
 		goto out;
 
-	net->ipv6.ip6_rt_gc_expire++;
-	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
+	fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), net, true);
 	entries = dst_entries_get_slow(ops);
 	if (entries < ops->gc_thresh)
-		net->ipv6.ip6_rt_gc_expire = rt_gc_timeout>>1;
+		atomic_set(&net->ipv6.ip6_rt_gc_expire, rt_gc_timeout >> 1);
 out:
-	net->ipv6.ip6_rt_gc_expire -= net->ipv6.ip6_rt_gc_expire>>rt_elasticity;
+	val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
+	atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> rt_elasticity));
 	return entries > rt_max_size;
 }
 
@@ -6509,7 +6510,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
 	net->ipv6.sysctl.skip_notify_on_dev_down = 0;
 
-	net->ipv6.ip6_rt_gc_expire = 30*HZ;
+	atomic_set(&net->ipv6.ip6_rt_gc_expire, 30*HZ);
 
 	ret = 0;
 out:
-- 
2.35.1.1178.g4f1659d476-goog

