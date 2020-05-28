Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B2E1E6DB1
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436648AbgE1Vc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:32:26 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:18879 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436505AbgE1VcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 17:32:17 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 28 May 2020 14:32:11 -0700
Received: from ubuntu.eng.vmware.com (unknown [10.20.113.240])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id A0DB3B245F;
        Thu, 28 May 2020 17:32:15 -0400 (EDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 3/4] vmxnet3: add geneve and vxlan tunnel offload support
Date:   Thu, 28 May 2020 14:32:02 -0700
Message-ID: <20200528213204.29803-4-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200528213204.29803-1-doshir@vmware.com>
References: <20200528213204.29803-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vmxnet3 version 3 device supports checksum/TSO offload. Thus, vNIC to
pNIC traffic can leverage hardware checksum/TSO offloads. However,
vmxnet3 does not support checksum/TSO offload for Geneve/VXLAN
encapsulated packets. Thus, for a vNIC configured with an overlay, the
guest stack must first segment the inner packet, compute the inner
checksum for each segment and encapsulate each segment before
transmitting the packet via the vNIC. This results in significant
performance penalty.

This patch will enhance vmxnet3 to support Geneve/VXLAN TSO as well as
checksum offload.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/upt1_defs.h       |   3 +
 drivers/net/vmxnet3/vmxnet3_defs.h    |  17 +++--
 drivers/net/vmxnet3/vmxnet3_drv.c     | 120 +++++++++++++++++++++++++++-------
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  42 +++++++++++-
 drivers/net/vmxnet3/vmxnet3_int.h     |  12 +++-
 5 files changed, 161 insertions(+), 33 deletions(-)

diff --git a/drivers/net/vmxnet3/upt1_defs.h b/drivers/net/vmxnet3/upt1_defs.h
index 65a203c842b2..8c014c98471c 100644
--- a/drivers/net/vmxnet3/upt1_defs.h
+++ b/drivers/net/vmxnet3/upt1_defs.h
@@ -92,5 +92,8 @@ enum {
 	UPT1_F_RSS		= cpu_to_le64(0x0002),
 	UPT1_F_RXVLAN		= cpu_to_le64(0x0004),   /* VLAN tag stripping */
 	UPT1_F_LRO		= cpu_to_le64(0x0008),
+	UPT1_F_RXINNEROFLD      = cpu_to_le64(0x00010),  /* Geneve/Vxlan rx csum
+							  * offloading
+							  */
 };
 #endif
diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index aac97fac1186..a8d5ebd47c71 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -103,14 +103,14 @@ enum {
 /*
  *	Little Endian layout of bitfields -
  *	Byte 0 :	7.....len.....0
- *	Byte 1 :	rsvd gen 13.len.8
+ *	Byte 1 :	oco gen 13.len.8
  *	Byte 2 : 	5.msscof.0 ext1  dtype
  *	Byte 3 : 	13...msscof...6
  *
  *	Big Endian layout of bitfields -
  *	Byte 0:		13...msscof...6
  *	Byte 1 : 	5.msscof.0 ext1  dtype
- *	Byte 2 :	rsvd gen 13.len.8
+ *	Byte 2 :	oco gen 13.len.8
  *	Byte 3 :	7.....len.....0
  *
  *	Thus, le32_to_cpu on the dword will allow the big endian driver to read
@@ -125,13 +125,13 @@ struct Vmxnet3_TxDesc {
 	u32 msscof:14;  /* MSS, checksum offset, flags */
 	u32 ext1:1;
 	u32 dtype:1;    /* descriptor type */
-	u32 rsvd:1;
+	u32 oco:1;
 	u32 gen:1;      /* generation bit */
 	u32 len:14;
 #else
 	u32 len:14;
 	u32 gen:1;      /* generation bit */
-	u32 rsvd:1;
+	u32 oco:1;
 	u32 dtype:1;    /* descriptor type */
 	u32 ext1:1;
 	u32 msscof:14;  /* MSS, checksum offset, flags */
@@ -157,9 +157,10 @@ struct Vmxnet3_TxDesc {
 };
 
 /* TxDesc.OM values */
-#define VMXNET3_OM_NONE		0
-#define VMXNET3_OM_CSUM		2
-#define VMXNET3_OM_TSO		3
+#define VMXNET3_OM_NONE         0
+#define VMXNET3_OM_ENCAP        1
+#define VMXNET3_OM_CSUM         2
+#define VMXNET3_OM_TSO          3
 
 /* fields in TxDesc we access w/o using bit fields */
 #define VMXNET3_TXD_EOP_SHIFT	12
@@ -226,6 +227,8 @@ struct Vmxnet3_RxDesc {
 #define VMXNET3_RXD_BTYPE_SHIFT  14
 #define VMXNET3_RXD_GEN_SHIFT    31
 
+#define VMXNET3_RCD_HDR_INNER_SHIFT  13
+
 struct Vmxnet3_RxCompDesc {
 #ifdef __BIG_ENDIAN_BITFIELD
 	u32		ext2:1;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 4ea7a40ada88..b764f24b646b 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -842,12 +842,22 @@ vmxnet3_parse_hdr(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 	u8 protocol = 0;
 
 	if (ctx->mss) {	/* TSO */
-		ctx->eth_ip_hdr_size = skb_transport_offset(skb);
-		ctx->l4_hdr_size = tcp_hdrlen(skb);
-		ctx->copy_size = ctx->eth_ip_hdr_size + ctx->l4_hdr_size;
+		if (VMXNET3_VERSION_GE_4(adapter) && skb->encapsulation) {
+			ctx->l4_offset = skb_inner_transport_offset(skb);
+			ctx->l4_hdr_size = inner_tcp_hdrlen(skb);
+			ctx->copy_size = ctx->l4_offset + ctx->l4_hdr_size;
+		} else {
+			ctx->l4_offset = skb_transport_offset(skb);
+			ctx->l4_hdr_size = tcp_hdrlen(skb);
+			ctx->copy_size = ctx->l4_offset + ctx->l4_hdr_size;
+		}
 	} else {
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
-			ctx->eth_ip_hdr_size = skb_checksum_start_offset(skb);
+			/* For encap packets, skb_checksum_start_offset refers
+			 * to inner L4 offset. Thus, below works for encap as
+			 * well as non-encap case
+			 */
+			ctx->l4_offset = skb_checksum_start_offset(skb);
 
 			if (ctx->ipv4) {
 				const struct iphdr *iph = ip_hdr(skb);
@@ -871,10 +881,10 @@ vmxnet3_parse_hdr(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 				break;
 			}
 
-			ctx->copy_size = min(ctx->eth_ip_hdr_size +
+			ctx->copy_size = min(ctx->l4_offset +
 					 ctx->l4_hdr_size, skb->len);
 		} else {
-			ctx->eth_ip_hdr_size = 0;
+			ctx->l4_offset = 0;
 			ctx->l4_hdr_size = 0;
 			/* copy as much as allowed */
 			ctx->copy_size = min_t(unsigned int,
@@ -930,6 +940,25 @@ vmxnet3_copy_hdr(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 
 
 static void
+vmxnet3_prepare_inner_tso(struct sk_buff *skb,
+			  struct vmxnet3_tx_ctx *ctx)
+{
+	struct tcphdr *tcph = inner_tcp_hdr(skb);
+	struct iphdr *iph = inner_ip_hdr(skb);
+
+	if (ctx->ipv4) {
+		iph->check = 0;
+		tcph->check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, 0,
+						 IPPROTO_TCP, 0);
+	} else if (ctx->ipv6) {
+		struct ipv6hdr *iph = inner_ipv6_hdr(skb);
+
+		tcph->check = ~csum_ipv6_magic(&iph->saddr, &iph->daddr, 0,
+					       IPPROTO_TCP, 0);
+	}
+}
+
+static void
 vmxnet3_prepare_tso(struct sk_buff *skb,
 		    struct vmxnet3_tx_ctx *ctx)
 {
@@ -987,6 +1016,7 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 	/* Use temporary descriptor to avoid touching bits multiple times */
 	union Vmxnet3_GenericDesc tempTxDesc;
 #endif
+	struct udphdr *udph;
 
 	count = txd_estimate(skb);
 
@@ -1003,7 +1033,11 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 			}
 			tq->stats.copy_skb_header++;
 		}
-		vmxnet3_prepare_tso(skb, &ctx);
+		if (skb->encapsulation) {
+			vmxnet3_prepare_inner_tso(skb, &ctx);
+		} else {
+			vmxnet3_prepare_tso(skb, &ctx);
+		}
 	} else {
 		if (unlikely(count > VMXNET3_MAX_TXD_PER_PKT)) {
 
@@ -1026,14 +1060,14 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 		BUG_ON(ret <= 0 && ctx.copy_size != 0);
 		/* hdrs parsed, check against other limits */
 		if (ctx.mss) {
-			if (unlikely(ctx.eth_ip_hdr_size + ctx.l4_hdr_size >
+			if (unlikely(ctx.l4_offset + ctx.l4_hdr_size >
 				     VMXNET3_MAX_TX_BUF_SIZE)) {
 				tq->stats.drop_oversized_hdr++;
 				goto drop_pkt;
 			}
 		} else {
 			if (skb->ip_summed == CHECKSUM_PARTIAL) {
-				if (unlikely(ctx.eth_ip_hdr_size +
+				if (unlikely(ctx.l4_offset +
 					     skb->csum_offset >
 					     VMXNET3_MAX_CSUM_OFFSET)) {
 					tq->stats.drop_oversized_hdr++;
@@ -1080,16 +1114,34 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 #endif
 	tx_num_deferred = le32_to_cpu(tq->shared->txNumDeferred);
 	if (ctx.mss) {
-		gdesc->txd.hlen = ctx.eth_ip_hdr_size + ctx.l4_hdr_size;
-		gdesc->txd.om = VMXNET3_OM_TSO;
-		gdesc->txd.msscof = ctx.mss;
+		if (VMXNET3_VERSION_GE_4(adapter) && skb->encapsulation) {
+			gdesc->txd.hlen = ctx.l4_offset + ctx.l4_hdr_size;
+			gdesc->txd.om = VMXNET3_OM_ENCAP;
+			gdesc->txd.msscof = ctx.mss;
+
+			udph = udp_hdr(skb);
+			if (udph->check)
+				gdesc->txd.oco = 1;
+		} else {
+			gdesc->txd.hlen = ctx.l4_offset + ctx.l4_hdr_size;
+			gdesc->txd.om = VMXNET3_OM_TSO;
+			gdesc->txd.msscof = ctx.mss;
+		}
 		num_pkts = (skb->len - gdesc->txd.hlen + ctx.mss - 1) / ctx.mss;
 	} else {
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
-			gdesc->txd.hlen = ctx.eth_ip_hdr_size;
-			gdesc->txd.om = VMXNET3_OM_CSUM;
-			gdesc->txd.msscof = ctx.eth_ip_hdr_size +
-					    skb->csum_offset;
+			if (VMXNET3_VERSION_GE_4(adapter) &&
+			    skb->encapsulation) {
+				gdesc->txd.hlen = ctx.l4_offset +
+						  ctx.l4_hdr_size;
+				gdesc->txd.om = VMXNET3_OM_ENCAP;
+				gdesc->txd.msscof = 0;		/* Reserved */
+			} else {
+				gdesc->txd.hlen = ctx.l4_offset;
+				gdesc->txd.om = VMXNET3_OM_CSUM;
+				gdesc->txd.msscof = ctx.l4_offset +
+						    skb->csum_offset;
+			}
 		} else {
 			gdesc->txd.om = 0;
 			gdesc->txd.msscof = 0;
@@ -1168,13 +1220,21 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		    (le32_to_cpu(gdesc->dword[3]) &
 		     VMXNET3_RCD_CSUM_OK) == VMXNET3_RCD_CSUM_OK) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp));
-			BUG_ON(gdesc->rcd.frg);
+			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
+			       !(le32_to_cpu(gdesc->dword[0]) &
+				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
+			BUG_ON(gdesc->rcd.frg &&
+			       !(le32_to_cpu(gdesc->dword[0]) &
+				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
 		} else if (gdesc->rcd.v6 && (le32_to_cpu(gdesc->dword[3]) &
 					     (1 << VMXNET3_RCD_TUC_SHIFT))) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp));
-			BUG_ON(gdesc->rcd.frg);
+			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
+			       !(le32_to_cpu(gdesc->dword[0]) &
+				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
+			BUG_ON(gdesc->rcd.frg &&
+			       !(le32_to_cpu(gdesc->dword[0]) &
+				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
 		} else {
 			if (gdesc->rcd.csum) {
 				skb->csum = htons(gdesc->rcd.csum);
@@ -2429,6 +2489,10 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 	if (adapter->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
 		devRead->misc.uptFeatures |= UPT1_F_RXVLAN;
 
+	if (adapter->netdev->features & (NETIF_F_GSO_UDP_TUNNEL |
+					 NETIF_F_GSO_UDP_TUNNEL_CSUM))
+		devRead->misc.uptFeatures |= UPT1_F_RXINNEROFLD;
+
 	devRead->misc.mtu = cpu_to_le32(adapter->netdev->mtu);
 	devRead->misc.queueDescPA = cpu_to_le64(adapter->queue_desc_pa);
 	devRead->misc.queueDescLen = cpu_to_le32(
@@ -2561,8 +2625,8 @@ vmxnet3_init_rssfields(struct vmxnet3_adapter *adapter)
 	union Vmxnet3_CmdInfo *cmdInfo = &shared->cu.cmdInfo;
 	unsigned long flags;
 
-		if (!VMXNET3_VERSION_GE_4(adapter))
-			return;
+	if (!VMXNET3_VERSION_GE_4(adapter))
+		return;
 
 	spin_lock_irqsave(&adapter->cmd_lock, flags);
 
@@ -3073,6 +3137,18 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter, bool dma64)
 		NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
 		NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
 		NETIF_F_LRO;
+
+	if (VMXNET3_VERSION_GE_4(adapter)) {
+		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
+				NETIF_F_GSO_UDP_TUNNEL_CSUM;
+
+		netdev->hw_enc_features = NETIF_F_SG | NETIF_F_RXCSUM |
+			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
+			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
+			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
+			NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	}
+
 	if (dma64)
 		netdev->hw_features |= NETIF_F_HIGHDMA;
 	netdev->vlan_features = netdev->hw_features &
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 57460cf1967f..bfdda0f34b97 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -267,14 +267,43 @@ netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
 	return features;
 }
 
+static void vmxnet3_enable_encap_offloads(struct net_device *netdev)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+
+	if (VMXNET3_VERSION_GE_4(adapter)) {
+		netdev->hw_enc_features |= NETIF_F_SG | NETIF_F_RXCSUM |
+			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
+			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
+			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
+			NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	}
+}
+
+static void vmxnet3_disable_encap_offloads(struct net_device *netdev)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+
+	if (VMXNET3_VERSION_GE_4(adapter)) {
+		netdev->hw_enc_features &= ~(NETIF_F_SG | NETIF_F_RXCSUM |
+			NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_CTAG_TX |
+			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_TSO | NETIF_F_TSO6 |
+			NETIF_F_LRO | NETIF_F_GSO_UDP_TUNNEL |
+			NETIF_F_GSO_UDP_TUNNEL_CSUM);
+	}
+}
+
 int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	unsigned long flags;
 	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t tun_offload_mask = NETIF_F_GSO_UDP_TUNNEL |
+					     NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	u8 udp_tun_enabled = (netdev->features & tun_offload_mask) != 0;
 
 	if (changed & (NETIF_F_RXCSUM | NETIF_F_LRO |
-		       NETIF_F_HW_VLAN_CTAG_RX)) {
+		       NETIF_F_HW_VLAN_CTAG_RX | tun_offload_mask)) {
 		if (features & NETIF_F_RXCSUM)
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXCSUM;
@@ -297,6 +326,17 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 			adapter->shared->devRead.misc.uptFeatures &=
 			~UPT1_F_RXVLAN;
 
+		if ((features & tun_offload_mask) != 0 && !udp_tun_enabled) {
+			vmxnet3_enable_encap_offloads(netdev);
+			adapter->shared->devRead.misc.uptFeatures |=
+			UPT1_F_RXINNEROFLD;
+		} else if ((features & tun_offload_mask) == 0 &&
+			   udp_tun_enabled) {
+			vmxnet3_disable_encap_offloads(netdev);
+			adapter->shared->devRead.misc.uptFeatures &=
+			~UPT1_F_RXINNEROFLD;
+		}
+
 		spin_lock_irqsave(&adapter->cmd_lock, flags);
 		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
 				       VMXNET3_CMD_UPDATE_FEATURE);
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index d52ccc3eeba2..86db809c7592 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -219,10 +219,16 @@ struct vmxnet3_tx_ctx {
 	bool   ipv4;
 	bool   ipv6;
 	u16 mss;
-	u32 eth_ip_hdr_size; /* only valid for pkts requesting tso or csum
-				 * offloading
+	u32    l4_offset;	/* only valid for pkts requesting tso or csum
+				 * offloading. For encap offload, it refers to
+				 * inner L4 offset i.e. it includes outer header
+				 * encap header and inner eth and ip header size
+				 */
+
+	u32	l4_hdr_size;	/* only valid if mss != 0
+				 * Refers to inner L4 hdr size for encap
+				 * offload
 				 */
-	u32 l4_hdr_size;     /* only valid if mss != 0 */
 	u32 copy_size;       /* # of bytes copied into the data ring */
 	union Vmxnet3_GenericDesc *sop_txd;
 	union Vmxnet3_GenericDesc *eop_txd;
-- 
2.11.0

