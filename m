Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047264B5CC6
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiBNVYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 16:24:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiBNVYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 16:24:36 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D7CEF79A
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 13:24:27 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v4so15751135pjh.2
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 13:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KQVbBZjcSPgWwP/zptkNGOj0ad1QXUQpTOLzAP1u1ys=;
        b=FakRHnK/4+DrzPbG2Xy5j06cKABngOTYDNExlQY6WtXSgBHZanJJRAB+/C4IuRabtr
         eFf7tlPofTpU05C9viEfqH9i4fmXOUBbKQOB2RUnlSEchsLr4kQHQNkq1Kz9G7BLEF+c
         KAMK5enLGdsGCeCNmvCrgRyNBMbHi0SC0RfkaClrkKL7dSK7dcs7WYVvQFPJHIJogoRM
         0Zr7CMVsjeXHOOPaqC0rYCxRg4Z8k9jx75D9xcwLueP4wGGaDbqJTdokxdAwXbtis1G+
         pRsGyVJdhUUWNj0+PmTOPtELv+EOJsuvRVdU1+5GATWiWxFj2sSlwJ6i0VgdT27f2D7v
         2/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KQVbBZjcSPgWwP/zptkNGOj0ad1QXUQpTOLzAP1u1ys=;
        b=ei3CkOdUnNsghmKBNiCavsjqEP1hMGRq1TfXDgOIraP0o8hU2e+U6OGQ5roESnfWvQ
         0AcEOFwmmTDb3oequRg4smcDk4NxOqq2J+Xuueg+wssLO5HRRNOM1k5pa/YiSIwk2u5i
         V+1JM1vP/PbhjNuj0A595gwhEM2bgRT0JMySPnGrCp1yLz6qwmcFC3hIUxt7EhrLodwN
         n6dSQvEXqPOVOFky0QxUQIdBK8cIoeKEcRRClwe/B5wS9h6LG+CFawqbreeVtLFap3BY
         gxVC2EthlDP4ntKEEzCrkrvB9Cv1IEFCgcs1NrY/QUfo4VfkwACAEjQWYmflagwDiBQo
         kYoA==
X-Gm-Message-State: AOAM530cRW4M+SKAsksv1JQwfmxKndrAOQqIcNWbMQI3hgZlmaKBQHR1
        JKnvRVnsOJNdtoOK2MVVCc73/hBim+Y=
X-Google-Smtp-Source: ABdhPJxMqpC2DBXwvOg1RssOkJCwD7xtxw346sIfr+3J2+FFX+h/GtrU6sMgHtZFq/8QbaMzNzohrQ==
X-Received: by 2002:aa7:9110:: with SMTP id 16mr112616pfh.41.1644866157180;
        Mon, 14 Feb 2022 11:15:57 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ff52:228f:b44e:a40b])
        by smtp.gmail.com with ESMTPSA id z13sm280055pga.84.2022.02.14.11.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 11:15:56 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: [PATCH net] bonding: fix data-races around agg_select_timer
Date:   Mon, 14 Feb 2022 11:15:53 -0800
Message-Id: <20220214191553.806285-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

syzbot reported that two threads might write over agg_select_timer
at the same time. Make agg_select_timer atomic to fix the races.

BUG: KCSAN: data-race in bond_3ad_initiate_agg_selection / bond_3ad_state_machine_handler

read to 0xffff8881242aea90 of 4 bytes by task 1846 on cpu 1:
 bond_3ad_state_machine_handler+0x99/0x2810 drivers/net/bonding/bond_3ad.c:2317
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

write to 0xffff8881242aea90 of 4 bytes by task 25910 on cpu 0:
 bond_3ad_initiate_agg_selection+0x18/0x30 drivers/net/bonding/bond_3ad.c:1998
 bond_open+0x658/0x6f0 drivers/net/bonding/bond_main.c:3967
 __dev_open+0x274/0x3a0 net/core/dev.c:1407
 dev_open+0x54/0x190 net/core/dev.c:1443
 bond_enslave+0xcef/0x3000 drivers/net/bonding/bond_main.c:1937
 do_set_master net/core/rtnetlink.c:2532 [inline]
 do_setlink+0x94f/0x2500 net/core/rtnetlink.c:2736
 __rtnl_newlink net/core/rtnetlink.c:3414 [inline]
 rtnl_newlink+0xfeb/0x13e0 net/core/rtnetlink.c:3529
 rtnetlink_rcv_msg+0x745/0x7e0 net/core/rtnetlink.c:5594
 netlink_rcv_skb+0x14e/0x250 net/netlink/af_netlink.c:2494
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:5612
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x602/0x6d0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x728/0x850 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmsg+0x195/0x230 net/socket.c:2496
 __do_sys_sendmsg net/socket.c:2505 [inline]
 __se_sys_sendmsg net/socket.c:2503 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2503
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000050 -> 0x0000004f

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 25910 Comm: syz-executor.1 Tainted: G        W         5.17.0-rc4-syzkaller-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
---
 drivers/net/bonding/bond_3ad.c | 30 +++++++++++++++++++++++++-----
 include/net/bond_3ad.h         |  2 +-
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 9fd1d6cba3cdaa22df34a2a4e2cb0e85863f853b..a86b1f71762ea455dddd8a879f7770aca32e67ad 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -225,7 +225,7 @@ static inline int __check_agg_selection_timer(struct port *port)
 	if (bond == NULL)
 		return 0;
 
-	return BOND_AD_INFO(bond).agg_select_timer ? 1 : 0;
+	return atomic_read(&BOND_AD_INFO(bond).agg_select_timer) ? 1 : 0;
 }
 
 /**
@@ -1995,7 +1995,7 @@ static void ad_marker_response_received(struct bond_marker *marker,
  */
 void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
 {
-	BOND_AD_INFO(bond).agg_select_timer = timeout;
+	atomic_set(&BOND_AD_INFO(bond).agg_select_timer, timeout);
 }
 
 /**
@@ -2278,6 +2278,28 @@ void bond_3ad_update_ad_actor_settings(struct bonding *bond)
 	spin_unlock_bh(&bond->mode_lock);
 }
 
+/**
+ * bond_agg_timer_advance - advance agg_select_timer
+ * @bond:  bonding structure
+ *
+ * Return true when agg_select_timer reaches 0.
+ */
+static bool bond_agg_timer_advance(struct bonding *bond)
+{
+	int val, nval;
+
+	while (1) {
+		val = atomic_read(&BOND_AD_INFO(bond).agg_select_timer);
+		if (!val)
+			return false;
+		nval = val - 1;
+		if (atomic_cmpxchg(&BOND_AD_INFO(bond).agg_select_timer,
+				   val, nval) == val)
+			break;
+	}
+	return nval == 0;
+}
+
 /**
  * bond_3ad_state_machine_handler - handle state machines timeout
  * @work: work context to fetch bonding struct to work on from
@@ -2313,9 +2335,7 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 	if (!bond_has_slaves(bond))
 		goto re_arm;
 
-	/* check if agg_select_timer timer after initialize is timed out */
-	if (BOND_AD_INFO(bond).agg_select_timer &&
-	    !(--BOND_AD_INFO(bond).agg_select_timer)) {
+	if (bond_agg_timer_advance(bond)) {
 		slave = bond_first_slave_rcu(bond);
 		port = slave ? &(SLAVE_AD_INFO(slave)->port) : NULL;
 
diff --git a/include/net/bond_3ad.h b/include/net/bond_3ad.h
index 38785d48baff99da65d97ce974a831b77a8adc16..184105d682942c2b2a50b023bf6be3441fbf7a21 100644
--- a/include/net/bond_3ad.h
+++ b/include/net/bond_3ad.h
@@ -262,7 +262,7 @@ struct ad_system {
 struct ad_bond_info {
 	struct ad_system system;	/* 802.3ad system structure */
 	struct bond_3ad_stats stats;
-	u32 agg_select_timer;		/* Timer to select aggregator after all adapter's hand shakes */
+	atomic_t agg_select_timer;		/* Timer to select aggregator after all adapter's hand shakes */
 	u16 aggregator_identifier;
 };
 
-- 
2.35.1.265.g69c8d7142f-goog

