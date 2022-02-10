Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B334B13F4
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245066AbiBJRNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:13:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245065AbiBJRNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:13:35 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6181CD1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:13:35 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y7so2388378plp.2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBJMUL38zXn4E1IFRNV+Rj2SDrR6oMD8c6F46AoSdS8=;
        b=dZocyfih4srAO1yx+iVzC9FnwwnMvCWwqTl0KAAvD2vXdRDZ2hcxjJfh6BeU9d1TU2
         F4EBRPINeVvD0Uk3Wm9+aVOPOARlGNR3QPV933XmkhaNKltezAYRNHKZTbhpAlhmWh7G
         NhAEeXV7eTcat1v8qa8bLLWxI0W598oSSm5lat+3A9nRfQqZofd22IfjqT20MjCkeFs/
         5HmbH3eclvENLfoFca4QuE0+4VCI9li5sVr1tD0Z1tGgY8JnP/mAiYwBDeO+EGaJ33NF
         2Cr/2jd6z0zDemQhY+rGWSQGbk/BVGIbRjhOtgaHlX7HaCrvOt51k07e5BkunmLLO9fn
         0J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBJMUL38zXn4E1IFRNV+Rj2SDrR6oMD8c6F46AoSdS8=;
        b=hpHiFCnQYGubcdp7E6o5AmCF52RrHSsIsGcAkh/Y0iH/LVBqM3wLheaWD45OIKBsXK
         EdqWgoUGqMSxYGkTnX7yYxQA7tSyfl9Su0tuzf6uFpP0p5HWciMt8fCeE/U3q5tXCWF/
         Sf9goPVChyIrWQWpRDZcxNEQXPmv0OdzvhJPAoGKA0JVmh47NQkEx1C/xDBvJSrletwu
         UVnC/8nLyesfqnanQcEr2Dx9g0KTIUoBpkWwMGj791JSCUt+p0Nd7E4eRX6Kfp06BwtS
         pvR0He0lNx++65iNrMq0HY9yozsb1ZfwRtSJr87F4coTQ7Qrn1uaj/9Dbe9SjlXqh0pu
         30+A==
X-Gm-Message-State: AOAM531yd6T0beCDbCmTwIsm4S8lBO4fzaW6TA+yWA83SOnw3goAD3MI
        tEbR0JhM9k5QVitFkhuzK3s=
X-Google-Smtp-Source: ABdhPJwJN/oCrLWay+fZz1BBEfuimdKX3Z1e/Hsa1akJUqd9A0y6dQCUgKAJA9Semga4I1gIAMwZ5g==
X-Received: by 2002:a17:902:dac9:: with SMTP id q9mr8033148plx.164.1644513215347;
        Thu, 10 Feb 2022 09:13:35 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c3d8:67ff:656a:cfd9])
        by smtp.gmail.com with ESMTPSA id q1sm7468470pfs.112.2022.02.10.09.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:13:34 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] drop_monitor: fix data-race in dropmon_net_event / trace_napi_poll_hit
Date:   Thu, 10 Feb 2022 09:13:31 -0800
Message-Id: <20220210171331.1458807-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
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

trace_napi_poll_hit() is reading stat->dev while another thread can write
on it from dropmon_net_event()

Use READ_ONCE()/WRITE_ONCE() here, RCU rules are properly enforced already,
we only have to take care of load/store tearing.

BUG: KCSAN: data-race in dropmon_net_event / trace_napi_poll_hit

write to 0xffff88816f3ab9c0 of 8 bytes by task 20260 on cpu 1:
 dropmon_net_event+0xb8/0x2b0 net/core/drop_monitor.c:1579
 notifier_call_chain kernel/notifier.c:84 [inline]
 raw_notifier_call_chain+0x53/0xb0 kernel/notifier.c:392
 call_netdevice_notifiers_info net/core/dev.c:1919 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
 call_netdevice_notifiers net/core/dev.c:1945 [inline]
 unregister_netdevice_many+0x867/0xfb0 net/core/dev.c:10415
 ip_tunnel_delete_nets+0x24a/0x280 net/ipv4/ip_tunnel.c:1123
 vti_exit_batch_net+0x2a/0x30 net/ipv4/ip_vti.c:515
 ops_exit_list net/core/net_namespace.c:173 [inline]
 cleanup_net+0x4dc/0x8d0 net/core/net_namespace.c:597
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

read to 0xffff88816f3ab9c0 of 8 bytes by interrupt on cpu 0:
 trace_napi_poll_hit+0x89/0x1c0 net/core/drop_monitor.c:292
 trace_napi_poll include/trace/events/napi.h:14 [inline]
 __napi_poll+0x36b/0x3f0 net/core/dev.c:6366
 napi_poll net/core/dev.c:6432 [inline]
 net_rx_action+0x29e/0x650 net/core/dev.c:6519
 __do_softirq+0x158/0x2de kernel/softirq.c:558
 do_softirq+0xb1/0xf0 kernel/softirq.c:459
 __local_bh_enable_ip+0x68/0x70 kernel/softirq.c:383
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:167 [inline]
 _raw_spin_unlock_bh+0x33/0x40 kernel/locking/spinlock.c:210
 spin_unlock_bh include/linux/spinlock.h:394 [inline]
 ptr_ring_consume_bh include/linux/ptr_ring.h:367 [inline]
 wg_packet_decrypt_worker+0x73c/0x780 drivers/net/wireguard/receive.c:506
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

value changed: 0xffff88815883e000 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 26435 Comm: kworker/0:1 Not tainted 5.17.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-crypt-wg2 wg_packet_decrypt_worker

Fixes: 4ea7e38696c7 ("dropmon: add ability to detect when hardware dropsrxpackets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/drop_monitor.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 7b288a121a41a7b3f3e19e275d1da3ce50579b01..d5dc6be2522cbe50e53532a9a85f5bbb58b18f4f 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -283,13 +283,17 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(new_stat, &hw_stats_list, list) {
+		struct net_device *dev;
+
 		/*
 		 * only add a note to our monitor buffer if:
 		 * 1) this is the dev we received on
 		 * 2) its after the last_rx delta
 		 * 3) our rx_dropped count has gone up
 		 */
-		if ((new_stat->dev == napi->dev)  &&
+		/* Paired with WRITE_ONCE() in dropmon_net_event() */
+		dev = READ_ONCE(new_stat->dev);
+		if ((dev == napi->dev)  &&
 		    (time_after(jiffies, new_stat->last_rx + dm_hw_check_delta)) &&
 		    (napi->dev->stats.rx_dropped != new_stat->last_drop_val)) {
 			trace_drop_common(NULL, NULL);
@@ -1576,7 +1580,10 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 		mutex_lock(&net_dm_mutex);
 		list_for_each_entry_safe(new_stat, tmp, &hw_stats_list, list) {
 			if (new_stat->dev == dev) {
-				new_stat->dev = NULL;
+
+				/* Paired with READ_ONCE() in trace_napi_poll_hit() */
+				WRITE_ONCE(new_stat->dev, NULL);
+
 				if (trace_state == TRACE_OFF) {
 					list_del_rcu(&new_stat->list);
 					kfree_rcu(new_stat, rcu);
-- 
2.35.0.263.gb82422642f-goog

