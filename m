Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A0951CF1D
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388372AbiEFCza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 22:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243235AbiEFCz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 22:55:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB10A5E162
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 19:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3306FB832C1
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 02:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580A5C385AF;
        Fri,  6 May 2022 02:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651805504;
        bh=zPL2kPW41rbQwjoGRdbCAN1TDpy3Utm9A6lHwEvHUmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzieemSm668s2jPt31qSjN5o29eS+DHwgzqkhIyvp+leA4BvsUp8WNZc0ThTaJjJT
         qYMTsc1gQbKwkRaP4PU4dG9YP3DJeazppN8dp20Wb/S+IgJjttMkVtNt9cD/pgogj0
         d/RBcthIrr7TGL4ckDFlwmcYlq6UAgjj8zEhTOarpvLfPc380dDB0HQ1nuUc2+7lI/
         MQf4XPfpXicOazT/n2MgtMQzB6YIbpHi2Z2w7qfKSA9YySsSeNIa2vkFfJ7XLcC82/
         6ZXF0XHFSPMKhJ7RhFy7GXYg+ESh9bvC7aZGwQIOEVgEPJv7bUxzjwtmFC3v6sLgZK
         tY33/OFpat/pg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        alexander.duyck@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>, simon.horman@corigine.com,
        gustavoars@kernel.org, roopa@nvidia.com, keescook@chromium.org,
        william.xuanziyang@huawei.com, lucien.xin@gmail.com,
        oss-drivers@corigine.com
Subject: [PATCH net-next 1/4] net: add netif_inherit_tso_max()
Date:   Thu,  5 May 2022 19:51:31 -0700
Message-Id: <20220506025134.794537-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506025134.794537-1-kuba@kernel.org>
References: <20220506025134.794537-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make later patches smaller create a helper for inheriting
the TSO limitations of a lower device. The TSO in the name
is not an accident, subsequent patches will replace GSO
with TSO in more names.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: simon.horman@corigine.com
CC: gustavoars@kernel.org
CC: roopa@nvidia.com
CC: keescook@chromium.org
CC: william.xuanziyang@huawei.com
CC: lucien.xin@gmail.com
CC: oss-drivers@corigine.com
---
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c |  3 +--
 drivers/net/ipvlan/ipvlan_main.c                  |  6 ++----
 drivers/net/macvlan.c                             |  6 ++----
 drivers/net/veth.c                                |  3 +--
 drivers/net/vxlan/vxlan_core.c                    |  3 +--
 include/linux/netdevice.h                         |  3 +++
 net/8021q/vlan.c                                  |  3 +--
 net/8021q/vlan_dev.c                              |  3 +--
 net/core/dev.c                                    | 12 ++++++++++++
 9 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index ba3fa7eac98d..790e1d5e4b4a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -286,8 +286,7 @@ nfp_repr_transfer_features(struct net_device *netdev, struct net_device *lower)
 	if (repr->dst->u.port_info.lower_dev != lower)
 		return;
 
-	netif_set_gso_max_size(netdev, lower->gso_max_size);
-	netif_set_gso_max_segs(netdev, lower->gso_max_segs);
+	netif_inherit_tso_max(netdev, lower);
 
 	netdev_update_features(netdev);
 }
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 696e245f6d00..aa28a29e228c 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -139,8 +139,7 @@ static int ipvlan_init(struct net_device *dev)
 	dev->vlan_features = phy_dev->vlan_features & IPVLAN_FEATURES;
 	dev->vlan_features |= IPVLAN_ALWAYS_ON_OFLOADS;
 	dev->hw_enc_features |= dev->features;
-	netif_set_gso_max_size(dev, phy_dev->gso_max_size);
-	netif_set_gso_max_segs(dev, phy_dev->gso_max_segs);
+	netif_inherit_tso_max(dev, phy_dev);
 	dev->hard_header_len = phy_dev->hard_header_len;
 
 	netdev_lockdep_set_classes(dev);
@@ -762,8 +761,7 @@ static int ipvlan_device_event(struct notifier_block *unused,
 
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
-			netif_set_gso_max_size(ipvlan->dev, dev->gso_max_size);
-			netif_set_gso_max_segs(ipvlan->dev, dev->gso_max_segs);
+			netif_inherit_tso_max(ipvlan->dev, dev);
 			netdev_update_features(ipvlan->dev);
 		}
 		break;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index b00bc8173abe..0017bd0fe3bb 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -904,8 +904,7 @@ static int macvlan_init(struct net_device *dev)
 	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
 	dev->vlan_features	|= ALWAYS_ON_OFFLOADS;
 	dev->hw_enc_features    |= dev->features;
-	netif_set_gso_max_size(dev, lowerdev->gso_max_size);
-	netif_set_gso_max_segs(dev, lowerdev->gso_max_segs);
+	netif_inherit_tso_max(dev, lowerdev);
 	dev->hard_header_len	= lowerdev->hard_header_len;
 	macvlan_set_lockdep_class(dev);
 
@@ -1763,8 +1762,7 @@ static int macvlan_device_event(struct notifier_block *unused,
 		break;
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(vlan, &port->vlans, list) {
-			netif_set_gso_max_size(vlan->dev, dev->gso_max_size);
-			netif_set_gso_max_segs(vlan->dev, dev->gso_max_segs);
+			netif_inherit_tso_max(vlan->dev, dev);
 			netdev_update_features(vlan->dev);
 		}
 		break;
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 3592014e50cc..f474e79a7745 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1758,8 +1758,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	if (ifmp && (dev->ifindex != 0))
 		peer->ifindex = ifmp->ifi_index;
 
-	netif_set_gso_max_size(peer, dev->gso_max_size);
-	netif_set_gso_max_segs(peer, dev->gso_max_segs);
+	netif_inherit_tso_max(peer, dev);
 
 	err = register_netdevice(peer);
 	put_net(net);
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 8a5e3a6d32d7..2bda692f70c5 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3683,8 +3683,7 @@ static void vxlan_config_apply(struct net_device *dev,
 	if (lowerdev) {
 		dst->remote_ifindex = conf->remote_ifindex;
 
-		netif_set_gso_max_size(dev, lowerdev->gso_max_size);
-		netif_set_gso_max_segs(dev, lowerdev->gso_max_segs);
+		netif_inherit_tso_max(dev, lowerdev);
 
 		needed_headroom = lowerdev->hard_header_len;
 		needed_headroom += lowerdev->needed_headroom;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf66e57d891..006bb5c0e413 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4895,6 +4895,9 @@ static inline void netif_set_gro_max_size(struct net_device *dev,
 	WRITE_ONCE(dev->gro_max_size, size);
 }
 
+void netif_inherit_tso_max(struct net_device *to,
+			   const struct net_device *from);
+
 static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
 					int pulled_hlen, u16 mac_offset,
 					int mac_len)
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 788076b002b3..e40aa3e3641c 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -319,8 +319,7 @@ static void vlan_transfer_features(struct net_device *dev,
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
 
-	netif_set_gso_max_size(vlandev, dev->gso_max_size);
-	netif_set_gso_max_segs(vlandev, dev->gso_max_segs);
+	netif_inherit_tso_max(vlandev, dev);
 
 	if (vlan_hw_offload_capable(dev->features, vlan->vlan_proto))
 		vlandev->hard_header_len = dev->hard_header_len;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e5d23e75572a..839f2020b015 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -573,8 +573,7 @@ static int vlan_dev_init(struct net_device *dev)
 			   NETIF_F_ALL_FCOE;
 
 	dev->features |= dev->hw_features | NETIF_F_LLTX;
-	netif_set_gso_max_size(dev, real_dev->gso_max_size);
-	netif_set_gso_max_segs(dev, real_dev->gso_max_segs);
+	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
 
diff --git a/net/core/dev.c b/net/core/dev.c
index c2d73595a7c3..eef1d19b130f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2992,6 +2992,18 @@ int netif_set_real_num_queues(struct net_device *dev,
 }
 EXPORT_SYMBOL(netif_set_real_num_queues);
 
+/**
+ * netif_inherit_tso_max() - copy all TSO limits from a lower device to an upper
+ * @to:		netdev to update
+ * @from:	netdev from which to copy the limits
+ */
+void netif_inherit_tso_max(struct net_device *to, const struct net_device *from)
+{
+	netif_set_gso_max_size(to, from->gso_max_size);
+	netif_set_gso_max_segs(to, from->gso_max_segs);
+}
+EXPORT_SYMBOL(netif_inherit_tso_max);
+
 /**
  * netif_get_num_default_rss_queues - default number of RSS queues
  *
-- 
2.34.1

