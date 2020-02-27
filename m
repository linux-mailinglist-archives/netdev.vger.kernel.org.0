Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F51B171714
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgB0MYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:24:55 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55580 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgB0MYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:24:55 -0500
Received: by mail-pj1-f65.google.com with SMTP id a18so1063619pjs.5
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 04:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Hd0ZbJ/jgoPIR1VF33oaTk0U4UZku3XF23faOWf/9E8=;
        b=WNdIZwGHv/QtXB7dvkDaM4+iQhWGGVwkQ4aba/0Iy6Gio2/6Aq1JqhkHLVQNuSlt7a
         +/kf0JmIU3iz77ebS+JWP+zWORCg1UsfwW2N8ctf50PAGIgGJChKm2gbra6HhbsyXH4e
         Cib/P0NKXTOwZ3zzZMpTu1GzW91p19RleSbNbnuVRRr1bbBoagi2pmN9EobOEFuXmQ4i
         vXr65iC6u8kmEGnVwKlCh11ikx1uTvFZTKx88ClQKOvPeGvDUjOvffRII1Rwr0XPSS0Y
         hsmPxE7AtzSphm15M30wjIVzk79tZnvGHSfgeABcMB65jf0ezU9eNaYTdjL6gVma/Dzm
         oC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Hd0ZbJ/jgoPIR1VF33oaTk0U4UZku3XF23faOWf/9E8=;
        b=ED4PoiPQyFyVbdxaZpslyIJS8owtzAIc24FOK5X8I/pT24Ki606uUGLgznVNDvIVaW
         GTlKVHiwHyE9XzQH4EnAAvcHlImj2fVpvq4cmWm0PlhAWi882zDWNBV3N79bzNfN1sjc
         wwFly/1zJ2yQY8I6Oj4uDp4cn3150TVil1LNSB7ieZew2jylpbDEWKTko08bbm9rU6rq
         2h4pIyeRtBOwbsWr/aVGiajz2AteQ02FWyvejhmNzaEhfkCC3oWIYjZ+jBpfuPmBTMtX
         GAUHX3DtwM2nHqzvjrmIkOqzMGbX7Vqwhal5ng9P4ZA95x1+/tj0/Rs+BIxIzKKei853
         aLAg==
X-Gm-Message-State: APjAAAUiA3XrEn7tHozaiRPia+cfYjGNdFiIsbqxlmN6Y6OGQndmCP42
        E0Tqz3hBs0WWEOdwrAMstt4=
X-Google-Smtp-Source: APXvYqzN9SqtyJrW3QTaJTUDfCjSwFewpoMcpHLTTl+xdZur25uGIccKMg7fbI+zaYorXmh+1M00JA==
X-Received: by 2002:a17:90a:bd89:: with SMTP id z9mr4521141pjr.13.1582806293369;
        Thu, 27 Feb 2020 04:24:53 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 190sm6590913pga.85.2020.02.27.04.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 04:24:52 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 3/8] net: rmnet: fix suspicious RCU usage
Date:   Thu, 27 Feb 2020 12:24:45 +0000
Message-Id: <20200227122445.19169-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rmnet_get_port() internally calls rcu_dereference_rtnl(),
which checks RTNL.
But rmnet_get_port() could be called by packet path.
The packet path is not protected by RTNL.
So, the suspicious RCU usage problem occurs.

Test commands:
    modprobe rmnet
    ip netns add nst
    ip link add veth0 type veth peer name veth1
    ip link set veth1 netns nst
    ip link add rmnet0 link veth0 type rmnet mux_id 1
    ip netns exec nst ip link add rmnet1 link veth1 type rmnet mux_id 1
    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip link set rmnet1 up
    ip netns exec nst ip a a 192.168.100.2/24 dev rmnet1
    ip link set veth0 up
    ip link set rmnet0 up
    ip a a 192.168.100.1/24 dev rmnet0
    ping 192.168.100.2

Splat looks like:
[  146.630958][ T1174] WARNING: suspicious RCU usage
[  146.631735][ T1174] 5.6.0-rc1+ #447 Not tainted
[  146.632387][ T1174] -----------------------------
[  146.633151][ T1174] drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c:386 suspicious rcu_dereference_check() !
[  146.634742][ T1174]
[  146.634742][ T1174] other info that might help us debug this:
[  146.634742][ T1174]
[  146.645992][ T1174]
[  146.645992][ T1174] rcu_scheduler_active = 2, debug_locks = 1
[  146.646937][ T1174] 5 locks held by ping/1174:
[  146.647609][ T1174]  #0: ffff8880c31dea70 (sk_lock-AF_INET){+.+.}, at: raw_sendmsg+0xab8/0x2980
[  146.662463][ T1174]  #1: ffffffff93925660 (rcu_read_lock_bh){....}, at: ip_finish_output2+0x243/0x2150
[  146.671696][ T1174]  #2: ffffffff93925660 (rcu_read_lock_bh){....}, at: __dev_queue_xmit+0x213/0x2940
[  146.673064][ T1174]  #3: ffff8880c19ecd58 (&dev->qdisc_running_key#7){+...}, at: ip_finish_output2+0x714/0x2150
[  146.690358][ T1174]  #4: ffff8880c5796898 (&dev->qdisc_xmit_lock_key#3){+.-.}, at: sch_direct_xmit+0x1e2/0x1020
[  146.699875][ T1174]
[  146.699875][ T1174] stack backtrace:
[  146.701091][ T1174] CPU: 0 PID: 1174 Comm: ping Not tainted 5.6.0-rc1+ #447
[  146.705215][ T1174] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  146.706565][ T1174] Call Trace:
[  146.707102][ T1174]  dump_stack+0x96/0xdb
[  146.708007][ T1174]  rmnet_get_port.part.9+0x76/0x80 [rmnet]
[  146.709233][ T1174]  rmnet_egress_handler+0x107/0x420 [rmnet]
[  146.710492][ T1174]  ? sch_direct_xmit+0x1e2/0x1020
[  146.716193][ T1174]  rmnet_vnd_start_xmit+0x3d/0xa0 [rmnet]
[  146.717012][ T1174]  dev_hard_start_xmit+0x160/0x740
[  146.717854][ T1174]  sch_direct_xmit+0x265/0x1020
[  146.718577][ T1174]  ? register_lock_class+0x14d0/0x14d0
[  146.719429][ T1174]  ? dev_watchdog+0xac0/0xac0
[  146.723738][ T1174]  ? __dev_queue_xmit+0x15fd/0x2940
[  146.724469][ T1174]  ? lock_acquire+0x164/0x3b0
[  146.725172][ T1174]  __dev_queue_xmit+0x20c7/0x2940
[ ... ]

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
  - update commit log.
  - remove unnecessary rcu_read_lock().
  - use rcu_dereference_bh() instead of rcu_dereference().

 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c  | 13 ++++++-------
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h  |  2 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c    |  4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index ac58f584190b..fc68ecdd804b 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -382,11 +382,10 @@ struct rtnl_link_ops rmnet_link_ops __read_mostly = {
 	.fill_info	= rmnet_fill_info,
 };
 
-/* Needs either rcu_read_lock() or rtnl lock */
-struct rmnet_port *rmnet_get_port(struct net_device *real_dev)
+struct rmnet_port *rmnet_get_port_rcu(struct net_device *real_dev)
 {
 	if (rmnet_is_real_dev_registered(real_dev))
-		return rcu_dereference_rtnl(real_dev->rx_handler_data);
+		return rcu_dereference_bh(real_dev->rx_handler_data);
 	else
 		return NULL;
 }
@@ -412,7 +411,7 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	struct rmnet_port *port, *slave_port;
 	int err;
 
-	port = rmnet_get_port(real_dev);
+	port = rmnet_get_port_rtnl(real_dev);
 
 	/* If there is more than one rmnet dev attached, its probably being
 	 * used for muxing. Skip the briding in that case
@@ -427,7 +426,7 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
 	if (err)
 		return -EBUSY;
 
-	slave_port = rmnet_get_port(slave_dev);
+	slave_port = rmnet_get_port_rtnl(slave_dev);
 	slave_port->rmnet_mode = RMNET_EPMODE_BRIDGE;
 	slave_port->bridge_ep = real_dev;
 
@@ -445,11 +444,11 @@ int rmnet_del_bridge(struct net_device *rmnet_dev,
 	struct net_device *real_dev = priv->real_dev;
 	struct rmnet_port *port, *slave_port;
 
-	port = rmnet_get_port(real_dev);
+	port = rmnet_get_port_rtnl(real_dev);
 	port->rmnet_mode = RMNET_EPMODE_VND;
 	port->bridge_ep = NULL;
 
-	slave_port = rmnet_get_port(slave_dev);
+	slave_port = rmnet_get_port_rtnl(slave_dev);
 	rmnet_unregister_real_device(slave_dev, slave_port);
 
 	netdev_dbg(slave_dev, "removed from rmnet as slave\n");
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index cd0a6bcbe74a..0d568dcfd65a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -65,7 +65,7 @@ struct rmnet_priv {
 	struct rmnet_priv_stats stats;
 };
 
-struct rmnet_port *rmnet_get_port(struct net_device *real_dev);
+struct rmnet_port *rmnet_get_port_rcu(struct net_device *real_dev);
 struct rmnet_endpoint *rmnet_get_endpoint(struct rmnet_port *port, u8 mux_id);
 int rmnet_add_bridge(struct net_device *rmnet_dev,
 		     struct net_device *slave_dev,
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 1b74bc160402..074a8b326c30 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -184,7 +184,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 
 	dev = skb->dev;
-	port = rmnet_get_port(dev);
+	port = rmnet_get_port_rcu(dev);
 
 	switch (port->rmnet_mode) {
 	case RMNET_EPMODE_VND:
@@ -217,7 +217,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
 	skb->dev = priv->real_dev;
 	mux_id = priv->mux_id;
 
-	port = rmnet_get_port(skb->dev);
+	port = rmnet_get_port_rcu(skb->dev);
 	if (!port)
 		goto drop;
 
-- 
2.17.1

