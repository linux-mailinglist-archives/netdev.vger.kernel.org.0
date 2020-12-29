Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6F02E7004
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 12:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgL2LmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 06:42:13 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55469 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726190AbgL2LmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 06:42:13 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 29 Dec 2020 13:41:21 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0BTBfKQk031596;
        Tue, 29 Dec 2020 13:41:21 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>, andy@greyhouse.net,
        vfalico@gmail.com, j.vosburgh@gmail.com,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH RFC net-next 6/6] net/bonding: Support TLS TX device offload
Date:   Tue, 29 Dec 2020 13:41:04 +0200
Message-Id: <20201229114104.7120-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201229114104.7120-1-tariqt@nvidia.com>
References: <20201229114104.7120-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement TLS TX device offload for bonding interfaces.
This allows kTLS sockets running on a bond to benefit from the
device offload on capable slaves.

To allow a simple and fast maintenance of the TLS context in SW and
slaves devices, we bind the TLS socket to a specific slave.
We ask the bond device for the socket's slave, and work with the lowest
in chain to call the tls_dev_ops operations.

To achieve a behavior similar to SW kTLS, we support only balance-xor
and 802.3ad modes, with xmit_hash_policy=layer3+4.
For the above configuration, the SW implementation keeps picking the
same exact slave for all the socket's SKBs.

We keep the bond feature bit independent from the slaves bits.
In case a non-capable slave is picked, the socket falls-back to
SW kTLS.

netdev_update_features() is taken out of the XFRM function so it
is called only once (if needed).

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/bonding/bond_main.c    | 28 ++++++++++++++++++++++++++++
 drivers/net/bonding/bond_options.c | 27 ++++++++++++++++++++++-----
 include/net/bonding.h              |  2 ++
 3 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0303e43e5fcf..574ffb147623 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -83,6 +83,9 @@
 #include <net/bonding.h>
 #include <net/bond_3ad.h>
 #include <net/bond_alb.h>
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+#include <net/tls.h>
+#endif
 
 #include "bonding_priv.h"
 
@@ -1225,6 +1228,11 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 	struct slave *slave;
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if ((features & BOND_TLS_FEATURES) && !bond_sk_check(bond))
+		features &= ~BOND_TLS_FEATURES;
+#endif
+
 	mask = features;
 
 	features &= ~NETIF_F_ONE_FOR_ALL;
@@ -4642,6 +4650,16 @@ static struct net_device *bond_sk_get_slave(struct net_device *master_dev,
 	return NULL;
 }
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+static netdev_tx_t bond_tls_device_xmit(struct bonding *bond, struct sk_buff *skb,
+					struct net_device *dev)
+{
+	if (likely(bond_get_slave_by_dev(bond, tls_get_ctx(skb->sk)->netdev)))
+		return bond_dev_queue_xmit(bond, skb, tls_get_ctx(skb->sk)->netdev);
+	return bond_tx_drop(dev, skb);
+}
+#endif
+
 static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
@@ -4650,6 +4668,11 @@ static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev
 	    !bond_slave_override(bond, skb))
 		return NETDEV_TX_OK;
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if (skb->sk && tls_is_sk_tx_device_offloaded(skb->sk))
+		return bond_tls_device_xmit(bond, skb, dev);
+#endif
+
 	switch (BOND_MODE(bond)) {
 	case BOND_MODE_ROUNDROBIN:
 		return bond_xmit_roundrobin(skb, dev);
@@ -4850,6 +4873,11 @@ void bond_setup(struct net_device *bond_dev)
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		bond_dev->features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	bond_dev->hw_features |= BOND_TLS_FEATURES;
+	if (bond_sk_check(bond))
+		bond_dev->features |= BOND_TLS_FEATURES;
+#endif
 }
 
 /* Destroy a bonding device.
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index a4e4e15f574d..8e5851289380 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -745,17 +745,22 @@ const struct bond_option *bond_opt_get(unsigned int option)
 	return &bond_opts[option];
 }
 
-static void bond_set_xfrm_features(struct net_device *bond_dev, u64 mode)
+static bool bond_set_xfrm_features(struct net_device *bond_dev, u64 mode)
 {
 	if (!IS_ENABLED(CONFIG_XFRM_OFFLOAD))
-		return;
+		return false;
 
 	if (mode == BOND_MODE_ACTIVEBACKUP)
 		bond_dev->wanted_features |= BOND_XFRM_FEATURES;
 	else
 		bond_dev->wanted_features &= ~BOND_XFRM_FEATURES;
 
-	netdev_update_features(bond_dev);
+	return true;
+}
+
+static bool bond_set_tls_features(struct net_device *bond_dev, u64 mode)
+{
+	return IS_ENABLED(CONFIG_TLS_DEVICE);
 }
 
 static int bond_option_mode_set(struct bonding *bond,
@@ -780,8 +785,15 @@ static int bond_option_mode_set(struct bonding *bond,
 	if (newval->value == BOND_MODE_ALB)
 		bond->params.tlb_dynamic_lb = 1;
 
-	if (bond->dev->reg_state == NETREG_REGISTERED)
-		bond_set_xfrm_features(bond->dev, newval->value);
+	if (bond->dev->reg_state == NETREG_REGISTERED) {
+		bool update = false;
+
+		update |= bond_set_xfrm_features(bond->dev, newval->value);
+		update |= bond_set_tls_features(bond->dev, newval->value);
+
+		if (update)
+			netdev_update_features(bond->dev);
+	}
 
 	/* don't cache arp_validate between modes */
 	bond->params.arp_validate = BOND_ARP_VALIDATE_NONE;
@@ -1219,6 +1231,11 @@ static int bond_option_xmit_hash_policy_set(struct bonding *bond,
 		   newval->string, newval->value);
 	bond->params.xmit_policy = newval->value;
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if (bond->dev->reg_state == NETREG_REGISTERED)
+		netdev_change_features(bond->dev);
+#endif
+
 	return 0;
 }
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index adc3da776970..60d91d7fdc3a 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -89,6 +89,8 @@
 #define BOND_XFRM_FEATURES (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
 			    NETIF_F_GSO_ESP)
 
+#define BOND_TLS_FEATURES (NETIF_F_HW_TLS_TX)
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 extern atomic_t netpoll_block_tx;
 
-- 
2.21.0

