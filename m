Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444CB2F9330
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 16:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbhAQPBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 10:01:32 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45168 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729154AbhAQPBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 10:01:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 17 Jan 2021 17:00:15 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10HF0F7G029614;
        Sun, 17 Jan 2021 17:00:15 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V3 5/8] net/bonding: Implement TLS TX device offload
Date:   Sun, 17 Jan 2021 16:59:46 +0200
Message-Id: <20210117145949.8632-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210117145949.8632-1-tariqt@nvidia.com>
References: <20210117145949.8632-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement TLS TX device offload for bonding interfaces.
This allows kTLS sockets running on a bond to benefit from the
device offload on capable lower devices.

To allow a simple and fast maintenance of the TLS context in SW and
lower devices, we bind the TLS socket to a specific lower dev.
To achieve a behavior similar to SW kTLS, we support only balance-xor
and 802.3ad modes, with xmit_hash_policy=layer3+4. This is enforced
in bond_sk_check(), done in a previous patch.

For the above configuration, the SW implementation keeps picking the
same exact lower dev for all the socket's SKBs. The device offload
behaves similarly, making the decision once at the connection creation.

Per socket, the TLS module should work directly with the lowest netdev
in chain, to call the tls_dev_ops operations.

As the bond interface is being bypassed by the TLS module, interacting
directly against the lower devs, there is no way for the bond interface
to disable its device offload capabilities, as long as the mode/policy
config allows it.
Hence, the feature flag is not directly controllable, but just reflects
the current offload status based on the logic under bond_sk_check().

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 drivers/net/bonding/bond_main.c    | 29 +++++++++++++++++++++++++++++
 drivers/net/bonding/bond_options.c | 27 +++++++++++++++++++++++++--
 include/net/bonding.h              |  2 ++
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 09524f99c753..539c6bc218df 100644
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
 
@@ -1225,6 +1228,13 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 	struct slave *slave;
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if (bond_sk_check(bond))
+		features |= BOND_TLS_FEATURES;
+	else
+		features &= ~BOND_TLS_FEATURES;
+#endif
+
 	mask = features;
 
 	features &= ~NETIF_F_ONE_FOR_ALL;
@@ -4647,6 +4657,16 @@ static struct net_device *bond_sk_get_lower_dev(struct net_device *dev,
 	return lower;
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
@@ -4655,6 +4675,11 @@ static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev
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
@@ -4855,6 +4880,10 @@ void bond_setup(struct net_device *bond_dev)
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		bond_dev->features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if (bond_sk_check(bond))
+		bond_dev->features |= BOND_TLS_FEATURES;
+#endif
 }
 
 /* Destroy a bonding device.
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 7f0ad97926de..8fcbf7f9c7b2 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -758,6 +758,19 @@ static bool bond_set_xfrm_features(struct bonding *bond)
 	return true;
 }
 
+static bool bond_set_tls_features(struct bonding *bond)
+{
+	if (!IS_ENABLED(CONFIG_TLS_DEVICE))
+		return false;
+
+	if (bond_sk_check(bond))
+		bond->dev->wanted_features |= BOND_TLS_FEATURES;
+	else
+		bond->dev->wanted_features &= ~BOND_TLS_FEATURES;
+
+	return true;
+}
+
 static int bond_option_mode_set(struct bonding *bond,
 				const struct bond_opt_value *newval)
 {
@@ -784,9 +797,15 @@ static int bond_option_mode_set(struct bonding *bond,
 	bond->params.arp_validate = BOND_ARP_VALIDATE_NONE;
 	bond->params.mode = newval->value;
 
-	if (bond->dev->reg_state == NETREG_REGISTERED)
-		if (bond_set_xfrm_features(bond))
+	if (bond->dev->reg_state == NETREG_REGISTERED) {
+		bool update = false;
+
+		update |= bond_set_xfrm_features(bond);
+		update |= bond_set_tls_features(bond);
+
+		if (update)
 			netdev_update_features(bond->dev);
+	}
 
 	return 0;
 }
@@ -1220,6 +1239,10 @@ static int bond_option_xmit_hash_policy_set(struct bonding *bond,
 		   newval->string, newval->value);
 	bond->params.xmit_policy = newval->value;
 
+	if (bond->dev->reg_state == NETREG_REGISTERED)
+		if (bond_set_tls_features(bond))
+			netdev_update_features(bond->dev);
+
 	return 0;
 }
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 21497193c4a4..97fbec02df2d 100644
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

