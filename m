Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F22B27809D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 08:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgIYG0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 02:26:47 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:57931 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbgIYG0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 02:26:47 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2020 02:26:46 EDT
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 24 Sep 2020 23:11:41 -0700
Received: from ubuntu.eng.vmware.com (unknown [10.20.113.240])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id C95B42026A;
        Thu, 24 Sep 2020 23:11:45 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net] vmxnet3: fix cksum offload issues for non-udp tunnels
Date:   Thu, 24 Sep 2020 23:11:29 -0700
Message-ID: <20200925061130.9017-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, the inner
offload capability is to be restrictued to UDP tunnels.

This patch fixes the issue for non-udp tunnels by adding features
check capability and filtering appropriate features for non-udp tunnels.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c     |  5 ++---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 28 ++++++++++++++++++++++++++++
 drivers/net/vmxnet3/vmxnet3_int.h     |  4 ++++
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 2818015324b8..336504b7531d 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1032,7 +1032,6 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 	/* Use temporary descriptor to avoid touching bits multiple times */
 	union Vmxnet3_GenericDesc tempTxDesc;
 #endif
-	struct udphdr *udph;
 
 	count = txd_estimate(skb);
 
@@ -1135,8 +1134,7 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 			gdesc->txd.om = VMXNET3_OM_ENCAP;
 			gdesc->txd.msscof = ctx.mss;
 
-			udph = udp_hdr(skb);
-			if (udph->check)
+			if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM)
 				gdesc->txd.oco = 1;
 		} else {
 			gdesc->txd.hlen = ctx.l4_offset + ctx.l4_hdr_size;
@@ -3371,6 +3369,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		.ndo_change_mtu = vmxnet3_change_mtu,
 		.ndo_fix_features = vmxnet3_fix_features,
 		.ndo_set_features = vmxnet3_set_features,
+		.ndo_features_check = vmxnet3_features_check,
 		.ndo_get_stats64 = vmxnet3_get_stats64,
 		.ndo_tx_timeout = vmxnet3_tx_timeout,
 		.ndo_set_rx_mode = vmxnet3_set_mc,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 1014693a5ceb..7ec8652f2c26 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -267,6 +267,34 @@ netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
 	return features;
 }
 
+netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
+					 struct net_device *netdev,
+					 netdev_features_t features)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+
+	/* Validate if the tunneled packet is being offloaded by the device */
+	if (VMXNET3_VERSION_GE_4(adapter) &&
+	    skb->encapsulation && skb->ip_summed == CHECKSUM_PARTIAL) {
+		u8 l4_proto = 0;
+
+		switch (vlan_get_protocol(skb)) {
+		case htons(ETH_P_IP):
+			l4_proto = ip_hdr(skb)->protocol;
+			break;
+		case htons(ETH_P_IPV6):
+			l4_proto = ipv6_hdr(skb)->nexthdr;
+			break;
+		default:
+			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		}
+
+		if (l4_proto != IPPROTO_UDP)
+			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	}
+	return features;
+}
+
 static void vmxnet3_enable_encap_offloads(struct net_device *netdev)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 5d2b062215a2..d958b92c9429 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -470,6 +470,10 @@ vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 netdev_features_t
 vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
 
+netdev_features_t
+vmxnet3_features_check(struct sk_buff *skb,
+		       struct net_device *netdev, netdev_features_t features);
+
 int
 vmxnet3_set_features(struct net_device *netdev, netdev_features_t features);
 
-- 
2.11.0

