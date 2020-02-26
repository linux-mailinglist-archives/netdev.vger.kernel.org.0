Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A636B170671
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgBZRrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:47:15 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32992 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgBZRrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:47:14 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay11so1580272plb.0
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NofkfjfaLA9LNBLTJrt7wvFh7bZZfLGeztgcSAupDvI=;
        b=eMseAdF2cwCOaID0ldxB5h2tD52848E+2k52gzG1Jx90nb0bXhtq6WZvfOJc/VMws6
         OTm+ZgE/+L4bviA6OJZi0S+3WQnmqOKBEQwrgeBAdY0DijMeLPfNXJzwxCV4WVjeU81u
         ULA8NWNf0JA3dRZaxabU8JV1OtU5zHQ94qoyVIWl2FfVF3jawxU73JCOcZG+aOnvAkeb
         DNzTYtxukdlitWPFMngWBOO0Drwjer8NQ/PCP00jYGsrcOJboWlA/Wm82JTW3TLu5hKU
         Qn8xmvTnauXt4dGMVHUQRgm15yp3HWECtiRV+s036DI2SRXBWiacwwEmQF8xOTMs78ji
         ZXlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NofkfjfaLA9LNBLTJrt7wvFh7bZZfLGeztgcSAupDvI=;
        b=nt8uDOAZ42IvATrzlh4KiXALSNg2gqArX/EfN0aweTWcpac03E0uz8rb2SNg7AG0aX
         A5AHPloPgkalmsbani3xUYKds2SIgdQAFpmFYsf5rFkiYa1a1kwEQnolKFbw/CLS3fh/
         l8M7Z1E2FMjyzXtYEyPYOU8Qw43grOtBUc3P+ygmxNGAecMiOFSzY8sbfOflqzAiOUUD
         /m4s+zCIf+AX7DHId6p7pE0y9LiLnWnKO1DdwqOrfKfBRn9FAbNyUgMGkwQ+i+NjV+SL
         CoB65NMUzmRY1bopfr57e9XrQPMhSFo8ScXFhPCWmLE13n9r/buIeSb5qcke3ziA6Gvy
         K9eQ==
X-Gm-Message-State: APjAAAUbQ+FfLLLzfK+ClJQVgU07RMT1joez3WBHZx/WmrDtKbm0X4So
        Y/lwQZ7Elg1J2C+UOgsf1Q8=
X-Google-Smtp-Source: APXvYqyWBYbWyZbuhDVu/9m/TJ9arUuvkrIdaQDadgOn1kwqYHSAlI0OxNqP4dV+JvVJ1ZfDcp7IgQ==
X-Received: by 2002:a17:90a:c78b:: with SMTP id gn11mr217468pjb.97.1582739232965;
        Wed, 26 Feb 2020 09:47:12 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id a10sm3450705pgk.71.2020.02.26.09.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:47:12 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 04/10] net: rmnet: fix suspicious RCU usage
Date:   Wed, 26 Feb 2020 17:47:06 +0000
Message-Id: <20200226174706.5334-1-ap420073@gmail.com>
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
[  339.775811][  T969] =============================
[  339.777204][  T969] WARNING: suspicious RCU usage
[  339.778188][  T969] 5.5.0+ #407 Not tainted
[  339.779123][  T969] -----------------------------
[  339.780100][  T969] drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c:389 suspicious rcu_dereference_check() usage!
[  339.781943][  T969]
[  339.781943][  T969] other info that might help us debug this:
[  339.781943][  T969]
[  339.783475][  T969]
[  339.783475][  T969] rcu_scheduler_active = 2, debug_locks = 1
[  339.784656][  T969] 5 locks held by ping/969:
[  339.785406][  T969]  #0: ffff88804cb897f0 (sk_lock-AF_INET){+.+.}, at: raw_sendmsg+0xab8/0x2980
[  339.786766][  T969]  #1: ffffffff92925460 (rcu_read_lock_bh){....}, at: ip_finish_output2+0x243/0x2150
[  339.788308][  T969]  #2: ffffffff92925460 (rcu_read_lock_bh){....}, at: __dev_queue_xmit+0x213/0x2e10
[  339.790662][  T969]  #3: ffff88805a924158 (&dev->qdisc_running_key#3){+...}, at: ip_finish_output2+0x714/0x2150
[  339.792072][  T969]  #4: ffff88805b4fdc98 (&dev->qdisc_xmit_lock_key#3){+.-.}, at: sch_direct_xmit+0x1e2/0x1020
[  339.793445][  T969]
[  339.793445][  T969] stack backtrace:
[  339.794691][  T969] CPU: 3 PID: 969 Comm: ping Not tainted 5.5.0+ #407
[  339.795946][  T969] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  339.797621][  T969] Call Trace:
[  339.798249][  T969]  dump_stack+0x96/0xdb
[  339.798847][  T969]  rmnet_get_port.part.9+0x76/0x80 [rmnet]
[  339.799583][  T969]  rmnet_egress_handler+0x107/0x420 [rmnet]
[  339.800350][  T969]  ? sch_direct_xmit+0x1e2/0x1020
[  339.801027][  T969]  rmnet_vnd_start_xmit+0x3d/0xa0 [rmnet]
[  339.801784][  T969]  dev_hard_start_xmit+0x160/0x740
[  339.802667][  T969]  sch_direct_xmit+0x265/0x1020
[ ... ]

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c  | 13 ++++++-------
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h  |  2 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c    |  4 ++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c     |  2 ++
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 7a7d0f521352..93642cdd3305 100644
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
+		return rcu_dereference(real_dev->rx_handler_data);
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
 
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 509dfc895a33..a26e76e9d382 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -50,7 +50,9 @@ static netdev_tx_t rmnet_vnd_start_xmit(struct sk_buff *skb,
 
 	priv = netdev_priv(dev);
 	if (priv->real_dev) {
+		rcu_read_lock();
 		rmnet_egress_handler(skb);
+		rcu_read_unlock();
 	} else {
 		this_cpu_inc(priv->pcpu_stats->stats.tx_drops);
 		kfree_skb(skb);
-- 
2.17.1

