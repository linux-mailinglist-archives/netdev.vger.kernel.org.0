Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0493F4B8F26
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbiBPRcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:32:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiBPRcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:32:45 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1F3171853
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:32:32 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso4755269pjs.1
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XSfoNSMcvW+JN1IUMU89UCFui4oHdukFq46ab0FPniA=;
        b=MmaFO0PKwzngkbaGrCLq+ZL1Un9cwImhxEfSY3IeHb9+UsrZPZ4TOjLPpgfvEZpMQJ
         CsktjuYtxAQgvhmnwQAqVazyq029zbOQNnYKcXHZrTR+cAW4YzBV/7DLNvJ9DHWUj8NI
         XLLDLxOboViRD74Hs5OHu1qEq2Q1pTVW+hrnZC/0FpdJ43ZUk8aErwUM8+zidCvK41zo
         49APh22BXWQnMmk47PSCVNOUNmNTZzHGBMua7SWCzL4NYNKnn7x5DwJzp3N6vLSAmEjX
         On/wz1NF39ELFJuAuUiS+jMObF1gFc4CPNCFqQJJlp9Z5wlC8MEQD/gEPxK9zltnnwJO
         F+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XSfoNSMcvW+JN1IUMU89UCFui4oHdukFq46ab0FPniA=;
        b=VqZxXU0YqFC4Ke+tOT/2+Z9otzMlgUB70Lb04hHG5u8cL7p/TTyaKsQ8i513yYiwYT
         ObQasovDZAAwfq1z1zxAodGZUpfQk1hWNQKGBxiBMQyXCGgRzh1RZnXvN+jqGrkzYbWX
         f1OHSSXHikEgSik8p5v8o+hv2CQSkv+TMQyfSODeVE0WTmbkqxk/vVKzcqelcondfTNJ
         lcKBCSkX2B5qDNcpaK7gLa//n2wzaGaHCXhm9ZaU3a/yQOtnCYQmxTPOaeXRfFJEwo94
         EAX0VlDHqOhnActfMMdg3ZpEzlJ99aKUWQ4/ZGf1BZzV72mLJmvBsyYQVMgBNFAvCsOf
         d30g==
X-Gm-Message-State: AOAM533DQ/xKbMbKAlxot4nAHqXVgA/ADhVmEaciJ6HyD5JdJOnNE1Ms
        plOOMRM042DxOWFqeuI7hv8=
X-Google-Smtp-Source: ABdhPJyqn1LF0P9rjdqLG6JomzcX2QhWFN0CVWqfvYfSQtBeQPcFxJvEyevqj5R2Yjl7qR2/R3YKdw==
X-Received: by 2002:a17:90b:e89:b0:1b9:19d0:432c with SMTP id fv9-20020a17090b0e8900b001b919d0432cmr2963584pjb.154.1645032752071;
        Wed, 16 Feb 2022 09:32:32 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b2d6:3f21:5f47:8e5a])
        by smtp.gmail.com with ESMTPSA id k4sm13794336pff.39.2022.02.16.09.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 09:32:31 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net 2/2] ipv6: fix data-race in fib6_info_hw_flags_set / fib6_purge_rt
Date:   Wed, 16 Feb 2022 09:32:17 -0800
Message-Id: <20220216173217.3792411-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220216173217.3792411-1-eric.dumazet@gmail.com>
References: <20220216173217.3792411-1-eric.dumazet@gmail.com>
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

Because fib6_info_hw_flags_set() is called without any synchronization,
all accesses to gi6->offload, fi->trap and fi->offload_failed
need some basic protection like READ_ONCE()/WRITE_ONCE().

BUG: KCSAN: data-race in fib6_info_hw_flags_set / fib6_purge_rt

read to 0xffff8881087d5886 of 1 bytes by task 13953 on cpu 0:
 fib6_drop_pcpu_from net/ipv6/ip6_fib.c:1007 [inline]
 fib6_purge_rt+0x4f/0x580 net/ipv6/ip6_fib.c:1033
 fib6_del_route net/ipv6/ip6_fib.c:1983 [inline]
 fib6_del+0x696/0x890 net/ipv6/ip6_fib.c:2028
 __ip6_del_rt net/ipv6/route.c:3876 [inline]
 ip6_del_rt+0x83/0x140 net/ipv6/route.c:3891
 __ipv6_dev_ac_dec+0x2b5/0x370 net/ipv6/anycast.c:374
 ipv6_dev_ac_dec net/ipv6/anycast.c:387 [inline]
 __ipv6_sock_ac_close+0x141/0x200 net/ipv6/anycast.c:207
 ipv6_sock_ac_close+0x79/0x90 net/ipv6/anycast.c:220
 inet6_release+0x32/0x50 net/ipv6/af_inet6.c:476
 __sock_release net/socket.c:650 [inline]
 sock_close+0x6c/0x150 net/socket.c:1318
 __fput+0x295/0x520 fs/file_table.c:280
 ____fput+0x11/0x20 fs/file_table.c:313
 task_work_run+0x8e/0x110 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x160/0x190 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:300
 do_syscall_64+0x50/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff8881087d5886 of 1 bytes by task 1912 on cpu 1:
 fib6_info_hw_flags_set+0x155/0x3b0 net/ipv6/route.c:6230
 nsim_fib6_rt_hw_flags_set drivers/net/netdevsim/fib.c:668 [inline]
 nsim_fib6_rt_add drivers/net/netdevsim/fib.c:691 [inline]
 nsim_fib6_rt_insert drivers/net/netdevsim/fib.c:756 [inline]
 nsim_fib6_event drivers/net/netdevsim/fib.c:853 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:886 [inline]
 nsim_fib_event_work+0x284f/0x2cf0 drivers/net/netdevsim/fib.c:1477
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x2c7/0x2e0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

value changed: 0x22 -> 0x2a

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 1912 Comm: kworker/1:3 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events nsim_fib_event_work

Fixes: 0c5fcf9e249e ("IPv6: Add "offload failed" indication to routes")
Fixes: bb3c4ab93e44 ("ipv6: Add "offload" and "trap" indications to routes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Amit Cohen <amcohen@nvidia.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/netdevsim/fib.c |  4 ++--
 include/net/ip6_fib.h       | 10 ++++++----
 net/ipv6/route.c            | 19 ++++++++++---------
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 4300261e2f9e78f56b6b009de09566596079f3f8..378ee779061c33ab1299f8949e571515a0c56bf2 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -623,14 +623,14 @@ static int nsim_fib6_rt_append(struct nsim_fib_data *data,
 		if (err)
 			goto err_fib6_rt_nh_del;
 
-		fib6_event->rt_arr[i]->trap = true;
+		WRITE_ONCE(fib6_event->rt_arr[i]->trap, true);
 	}
 
 	return 0;
 
 err_fib6_rt_nh_del:
 	for (i--; i >= 0; i--) {
-		fib6_event->rt_arr[i]->trap = false;
+		WRITE_ONCE(fib6_event->rt_arr[i]->trap, false);
 		nsim_fib6_rt_nh_del(fib6_rt, fib6_event->rt_arr[i]);
 	}
 	return err;
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 40ae8f1b18e502cece9f11b3a60c9cc30c2e1a5e..2048bc8748cb6f9b298b15335dfe25f9ff498369 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -190,14 +190,16 @@ struct fib6_info {
 	u32				fib6_metric;
 	u8				fib6_protocol;
 	u8				fib6_type;
+
+	u8				offload;
+	u8				trap;
+	u8				offload_failed;
+
 	u8				should_flush:1,
 					dst_nocount:1,
 					dst_nopolicy:1,
 					fib6_destroying:1,
-					offload:1,
-					trap:1,
-					offload_failed:1,
-					unused:1;
+					unused:4;
 
 	struct rcu_head			rcu;
 	struct nexthop			*nh;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f4884cda13b92e72d041680cbabfee2e07ec0f10..ea1cf414a92e770dbb9a10864a502a77de1b8e6c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5753,11 +5753,11 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 	}
 
 	if (!dst) {
-		if (rt->offload)
+		if (READ_ONCE(rt->offload))
 			rtm->rtm_flags |= RTM_F_OFFLOAD;
-		if (rt->trap)
+		if (READ_ONCE(rt->trap))
 			rtm->rtm_flags |= RTM_F_TRAP;
-		if (rt->offload_failed)
+		if (READ_ONCE(rt->offload_failed))
 			rtm->rtm_flags |= RTM_F_OFFLOAD_FAILED;
 	}
 
@@ -6215,19 +6215,20 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 	struct sk_buff *skb;
 	int err;
 
-	if (f6i->offload == offload && f6i->trap == trap &&
-	    f6i->offload_failed == offload_failed)
+	if (READ_ONCE(f6i->offload) == offload &&
+	    READ_ONCE(f6i->trap) == trap &&
+	    READ_ONCE(f6i->offload_failed) == offload_failed)
 		return;
 
-	f6i->offload = offload;
-	f6i->trap = trap;
+	WRITE_ONCE(f6i->offload, offload);
+	WRITE_ONCE(f6i->trap, trap);
 
 	/* 2 means send notifications only if offload_failed was changed. */
 	if (net->ipv6.sysctl.fib_notify_on_flag_change == 2 &&
-	    f6i->offload_failed == offload_failed)
+	    READ_ONCE(f6i->offload_failed) == offload_failed)
 		return;
 
-	f6i->offload_failed = offload_failed;
+	WRITE_ONCE(f6i->offload_failed, offload_failed);
 
 	if (!rcu_access_pointer(f6i->fib6_node))
 		/* The route was removed from the tree, do not send
-- 
2.35.1.265.g69c8d7142f-goog

