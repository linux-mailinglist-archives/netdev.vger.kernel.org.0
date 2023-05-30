Return-Path: <netdev+bounces-6212-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E37547153A3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 785DB1C20B49
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 02:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8767E20E2;
	Tue, 30 May 2023 02:27:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7698846A0
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:27:12 +0000 (UTC)
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEA8C9
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:27:07 -0700 (PDT)
X-QQ-mid: bizesmtp68t1685413619tgd9awsl
Received: from localhost.localdomain ( [183.159.96.128])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 30 May 2023 10:26:56 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: ILHsT53NKPjd4NONaStNiPLELc2tIdJ0056wUQ5tQEffMoGsin6NRjQ31LT1i
	qTSZEoffyArzjXJv2eYRyRMDHPWChGbYs2Hl2RdrYagRF0yBjJecMso04nmuxC+ITTRcbyr
	W/3ajORosrDZ6zVyTArf8RCLnfm1y4JzFfKS/CHinrYYZ2TKgAJinfcED7Af5IakTiF24zm
	YS8/mlixVPVrxSLnEp7orlidKxZIvas5vl/gGyzi6JtY3LNmgohU4DiRAepQcMxDOTRqLJN
	lEOhgM43wCbn58i2glnI/CaZPdf7R01DWqetOOb/zQobwqqRbQSvjCfqy5fQ+UG5gjBVQiP
	2/O14mKuq718KsKWtWxxzr7lAm+G5/W0f6/PL+Y8RFz0GxSSLQgR8sxTGS9icOigFZRM79l
	pN4vdkqlZLQ=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 4169797285428959047
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RESEND,PATCH net-next v7 1/8] net: wangxun: libwx add tx offload functions
Date: Tue, 30 May 2023 10:26:25 +0800
Message-Id: <20230530022632.17938-2-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530022632.17938-1-mengyuanlou@net-swift.com>
References: <20230530022632.17938-1-mengyuanlou@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add tx offload functions for wx_xmit_frame_ring which
includes wx_encode_tx_desc_ptype, wx_tso and wx_tx_csum.
which supports ngbe and txgbe to implement tx offload
function.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 462 ++++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h |  87 +++-
 2 files changed, 541 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 1e8d8b7b0c62..34ac30e87b7c 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -2,9 +2,14 @@
 /* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
 
 #include <linux/etherdevice.h>
+#include <net/ip6_checksum.h>
 #include <net/page_pool.h>
+#include <net/inet_ecn.h>
 #include <linux/iopoll.h>
+#include <linux/sctp.h>
 #include <linux/pci.h>
+#include <net/tcp.h>
+#include <net/ip.h>
 
 #include "wx_type.h"
 #include "wx_lib.h"
@@ -707,11 +712,50 @@ static int wx_maybe_stop_tx(struct wx_ring *tx_ring, u16 size)
 	return 0;
 }
 
+static u32 wx_tx_cmd_type(u32 tx_flags)
+{
+	/* set type for advanced descriptor with frame checksum insertion */
+	u32 cmd_type = WX_TXD_DTYP_DATA | WX_TXD_IFCS;
+
+	/* set HW vlan bit if vlan is present */
+	cmd_type |= WX_SET_FLAG(tx_flags, WX_TX_FLAGS_HW_VLAN, WX_TXD_VLE);
+	/* set segmentation enable bits for TSO/FSO */
+	cmd_type |= WX_SET_FLAG(tx_flags, WX_TX_FLAGS_TSO, WX_TXD_TSE);
+	/* set timestamp bit if present */
+	cmd_type |= WX_SET_FLAG(tx_flags, WX_TX_FLAGS_TSTAMP, WX_TXD_MAC_TSTAMP);
+	cmd_type |= WX_SET_FLAG(tx_flags, WX_TX_FLAGS_LINKSEC, WX_TXD_LINKSEC);
+
+	return cmd_type;
+}
+
+static void wx_tx_olinfo_status(union wx_tx_desc *tx_desc,
+				u32 tx_flags, unsigned int paylen)
+{
+	u32 olinfo_status = paylen << WX_TXD_PAYLEN_SHIFT;
+
+	/* enable L4 checksum for TSO and TX checksum offload */
+	olinfo_status |= WX_SET_FLAG(tx_flags, WX_TX_FLAGS_CSUM, WX_TXD_L4CS);
+	/* enable IPv4 checksum for TSO */
+	olinfo_status |= WX_SET_FLAG(tx_flags, WX_TX_FLAGS_IPV4, WX_TXD_IIPCS);
+	/* enable outer IPv4 checksum for TSO */
+	olinfo_status |= WX_SET_FLAG(tx_flags, WX_TX_FLAGS_OUTER_IPV4,
+				     WX_TXD_EIPCS);
+	/* Check Context must be set if Tx switch is enabled, which it
+	 * always is for case where virtual functions are running
+	 */
+	olinfo_status |= WX_SET_FLAG(tx_flags, WX_TX_FLAGS_CC, WX_TXD_CC);
+	olinfo_status |= WX_SET_FLAG(tx_flags, WX_TX_FLAGS_IPSEC,
+				     WX_TXD_IPSEC);
+	tx_desc->read.olinfo_status = cpu_to_le32(olinfo_status);
+}
+
 static void wx_tx_map(struct wx_ring *tx_ring,
-		      struct wx_tx_buffer *first)
+		      struct wx_tx_buffer *first,
+		      const u8 hdr_len)
 {
 	struct sk_buff *skb = first->skb;
 	struct wx_tx_buffer *tx_buffer;
+	u32 tx_flags = first->tx_flags;
 	u16 i = tx_ring->next_to_use;
 	unsigned int data_len, size;
 	union wx_tx_desc *tx_desc;
@@ -719,10 +763,9 @@ static void wx_tx_map(struct wx_ring *tx_ring,
 	dma_addr_t dma;
 	u32 cmd_type;
 
-	cmd_type = WX_TXD_DTYP_DATA | WX_TXD_IFCS;
+	cmd_type = wx_tx_cmd_type(tx_flags);
 	tx_desc = WX_TX_DESC(tx_ring, i);
-
-	tx_desc->read.olinfo_status = cpu_to_le32(skb->len << WX_TXD_PAYLEN_SHIFT);
+	wx_tx_olinfo_status(tx_desc, tx_flags, skb->len - hdr_len);
 
 	size = skb_headlen(skb);
 	data_len = skb->data_len;
@@ -838,12 +881,399 @@ static void wx_tx_map(struct wx_ring *tx_ring,
 	tx_ring->next_to_use = i;
 }
 
+static void wx_tx_ctxtdesc(struct wx_ring *tx_ring, u32 vlan_macip_lens,
+			   u32 fcoe_sof_eof, u32 type_tucmd, u32 mss_l4len_idx)
+{
+	struct wx_tx_context_desc *context_desc;
+	u16 i = tx_ring->next_to_use;
+
+	context_desc = WX_TX_CTXTDESC(tx_ring, i);
+	i++;
+	tx_ring->next_to_use = (i < tx_ring->count) ? i : 0;
+
+	/* set bits to identify this as an advanced context descriptor */
+	type_tucmd |= WX_TXD_DTYP_CTXT;
+	context_desc->vlan_macip_lens   = cpu_to_le32(vlan_macip_lens);
+	context_desc->seqnum_seed       = cpu_to_le32(fcoe_sof_eof);
+	context_desc->type_tucmd_mlhl   = cpu_to_le32(type_tucmd);
+	context_desc->mss_l4len_idx     = cpu_to_le32(mss_l4len_idx);
+}
+
+static void wx_get_ipv6_proto(struct sk_buff *skb, int offset, u8 *nexthdr)
+{
+	struct ipv6hdr *hdr = (struct ipv6hdr *)(skb->data + offset);
+
+	*nexthdr = hdr->nexthdr;
+	offset += sizeof(struct ipv6hdr);
+	while (ipv6_ext_hdr(*nexthdr)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+
+		if (*nexthdr == NEXTHDR_NONE)
+			return;
+		hp = skb_header_pointer(skb, offset, sizeof(_hdr), &_hdr);
+		if (!hp)
+			return;
+		if (*nexthdr == NEXTHDR_FRAGMENT)
+			break;
+		*nexthdr = hp->nexthdr;
+	}
+}
+
+union network_header {
+	struct iphdr *ipv4;
+	struct ipv6hdr *ipv6;
+	void *raw;
+};
+
+static u8 wx_encode_tx_desc_ptype(const struct wx_tx_buffer *first)
+{
+	u8 tun_prot = 0, l4_prot = 0, ptype = 0;
+	struct sk_buff *skb = first->skb;
+
+	if (skb->encapsulation) {
+		union network_header hdr;
+
+		switch (first->protocol) {
+		case htons(ETH_P_IP):
+			tun_prot = ip_hdr(skb)->protocol;
+			ptype = WX_PTYPE_TUN_IPV4;
+			break;
+		case htons(ETH_P_IPV6):
+			wx_get_ipv6_proto(skb, skb_network_offset(skb), &tun_prot);
+			ptype = WX_PTYPE_TUN_IPV6;
+			break;
+		default:
+			return ptype;
+		}
+
+		if (tun_prot == IPPROTO_IPIP) {
+			hdr.raw = (void *)inner_ip_hdr(skb);
+			ptype |= WX_PTYPE_PKT_IPIP;
+		} else if (tun_prot == IPPROTO_UDP) {
+			hdr.raw = (void *)inner_ip_hdr(skb);
+			if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
+			    skb->inner_protocol != htons(ETH_P_TEB)) {
+				ptype |= WX_PTYPE_PKT_IG;
+			} else {
+				if (((struct ethhdr *)skb_inner_mac_header(skb))->h_proto
+				     == htons(ETH_P_8021Q))
+					ptype |= WX_PTYPE_PKT_IGMV;
+				else
+					ptype |= WX_PTYPE_PKT_IGM;
+			}
+
+		} else if (tun_prot == IPPROTO_GRE) {
+			hdr.raw = (void *)inner_ip_hdr(skb);
+			if (skb->inner_protocol ==  htons(ETH_P_IP) ||
+			    skb->inner_protocol ==  htons(ETH_P_IPV6)) {
+				ptype |= WX_PTYPE_PKT_IG;
+			} else {
+				if (((struct ethhdr *)skb_inner_mac_header(skb))->h_proto
+				    == htons(ETH_P_8021Q))
+					ptype |= WX_PTYPE_PKT_IGMV;
+				else
+					ptype |= WX_PTYPE_PKT_IGM;
+			}
+		} else {
+			return ptype;
+		}
+
+		switch (hdr.ipv4->version) {
+		case IPVERSION:
+			l4_prot = hdr.ipv4->protocol;
+			break;
+		case 6:
+			wx_get_ipv6_proto(skb, skb_inner_network_offset(skb), &l4_prot);
+			ptype |= WX_PTYPE_PKT_IPV6;
+			break;
+		default:
+			return ptype;
+		}
+	} else {
+		switch (first->protocol) {
+		case htons(ETH_P_IP):
+			l4_prot = ip_hdr(skb)->protocol;
+			ptype = WX_PTYPE_PKT_IP;
+			break;
+		case htons(ETH_P_IPV6):
+			wx_get_ipv6_proto(skb, skb_network_offset(skb), &l4_prot);
+			ptype = WX_PTYPE_PKT_IP | WX_PTYPE_PKT_IPV6;
+			break;
+		default:
+			return WX_PTYPE_PKT_MAC | WX_PTYPE_TYP_MAC;
+		}
+	}
+	switch (l4_prot) {
+	case IPPROTO_TCP:
+		ptype |= WX_PTYPE_TYP_TCP;
+		break;
+	case IPPROTO_UDP:
+		ptype |= WX_PTYPE_TYP_UDP;
+		break;
+	case IPPROTO_SCTP:
+		ptype |= WX_PTYPE_TYP_SCTP;
+		break;
+	default:
+		ptype |= WX_PTYPE_TYP_IP;
+		break;
+	}
+
+	return ptype;
+}
+
+static int wx_tso(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
+		  u8 *hdr_len, u8 ptype)
+{
+	u32 vlan_macip_lens, type_tucmd, mss_l4len_idx;
+	struct net_device *netdev = tx_ring->netdev;
+	u32 l4len, tunhdr_eiplen_tunlen = 0;
+	struct sk_buff *skb = first->skb;
+	bool enc = skb->encapsulation;
+	struct ipv6hdr *ipv6h;
+	struct tcphdr *tcph;
+	struct iphdr *iph;
+	u8 tun_prot = 0;
+	int err;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return 0;
+
+	if (!skb_is_gso(skb))
+		return 0;
+
+	err = skb_cow_head(skb, 0);
+	if (err < 0)
+		return err;
+
+	/* indicates the inner headers in the skbuff are valid. */
+	iph = enc ? inner_ip_hdr(skb) : ip_hdr(skb);
+	if (iph->version == 4) {
+		tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
+		iph->tot_len = 0;
+		iph->check = 0;
+		tcph->check = ~csum_tcpudp_magic(iph->saddr,
+						 iph->daddr, 0,
+						 IPPROTO_TCP, 0);
+		first->tx_flags |= WX_TX_FLAGS_TSO |
+				   WX_TX_FLAGS_CSUM |
+				   WX_TX_FLAGS_IPV4 |
+				   WX_TX_FLAGS_CC;
+	} else if (iph->version == 6 && skb_is_gso_v6(skb)) {
+		ipv6h = enc ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
+		tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
+		ipv6h->payload_len = 0;
+		tcph->check = ~csum_ipv6_magic(&ipv6h->saddr,
+					       &ipv6h->daddr, 0,
+					       IPPROTO_TCP, 0);
+		first->tx_flags |= WX_TX_FLAGS_TSO |
+				   WX_TX_FLAGS_CSUM |
+				   WX_TX_FLAGS_CC;
+	}
+
+	/* compute header lengths */
+	l4len = enc ? inner_tcp_hdrlen(skb) : tcp_hdrlen(skb);
+	*hdr_len = enc ? (skb_inner_transport_header(skb) - skb->data) :
+			 skb_transport_offset(skb);
+	*hdr_len += l4len;
+
+	/* update gso size and bytecount with header size */
+	first->gso_segs = skb_shinfo(skb)->gso_segs;
+	first->bytecount += (first->gso_segs - 1) * *hdr_len;
+
+	/* mss_l4len_id: use 0 as index for TSO */
+	mss_l4len_idx = l4len << WX_TXD_L4LEN_SHIFT;
+	mss_l4len_idx |= skb_shinfo(skb)->gso_size << WX_TXD_MSS_SHIFT;
+
+	/* vlan_macip_lens: HEADLEN, MACLEN, VLAN tag */
+	if (enc) {
+		switch (first->protocol) {
+		case htons(ETH_P_IP):
+			tun_prot = ip_hdr(skb)->protocol;
+			first->tx_flags |= WX_TX_FLAGS_OUTER_IPV4;
+			break;
+		case htons(ETH_P_IPV6):
+			tun_prot = ipv6_hdr(skb)->nexthdr;
+			break;
+		default:
+			break;
+		}
+		switch (tun_prot) {
+		case IPPROTO_UDP:
+			tunhdr_eiplen_tunlen = WX_TXD_TUNNEL_UDP;
+			tunhdr_eiplen_tunlen |= ((skb_network_header_len(skb) >> 2) <<
+						 WX_TXD_OUTER_IPLEN_SHIFT) |
+						(((skb_inner_mac_header(skb) -
+						skb_transport_header(skb)) >> 1) <<
+						WX_TXD_TUNNEL_LEN_SHIFT);
+			break;
+		case IPPROTO_GRE:
+			tunhdr_eiplen_tunlen = WX_TXD_TUNNEL_GRE;
+			tunhdr_eiplen_tunlen |= ((skb_network_header_len(skb) >> 2) <<
+						 WX_TXD_OUTER_IPLEN_SHIFT) |
+						(((skb_inner_mac_header(skb) -
+						skb_transport_header(skb)) >> 1) <<
+						WX_TXD_TUNNEL_LEN_SHIFT);
+			break;
+		case IPPROTO_IPIP:
+			tunhdr_eiplen_tunlen = (((char *)inner_ip_hdr(skb) -
+						(char *)ip_hdr(skb)) >> 2) <<
+						WX_TXD_OUTER_IPLEN_SHIFT;
+			break;
+		default:
+			break;
+		}
+		vlan_macip_lens = skb_inner_network_header_len(skb) >> 1;
+	} else {
+		vlan_macip_lens = skb_network_header_len(skb) >> 1;
+	}
+
+	vlan_macip_lens |= skb_network_offset(skb) << WX_TXD_MACLEN_SHIFT;
+	vlan_macip_lens |= first->tx_flags & WX_TX_FLAGS_VLAN_MASK;
+
+	type_tucmd = ptype << 24;
+	if (skb->vlan_proto == htons(ETH_P_8021AD) &&
+	    netdev->features & NETIF_F_HW_VLAN_STAG_TX)
+		type_tucmd |= WX_SET_FLAG(first->tx_flags,
+					  WX_TX_FLAGS_HW_VLAN,
+					  0x1 << WX_TXD_TAG_TPID_SEL_SHIFT);
+	wx_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
+		       type_tucmd, mss_l4len_idx);
+
+	return 1;
+}
+
+static void wx_tx_csum(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
+		       u8 ptype)
+{
+	u32 tunhdr_eiplen_tunlen = 0, vlan_macip_lens = 0;
+	struct net_device *netdev = tx_ring->netdev;
+	u32 mss_l4len_idx = 0, type_tucmd;
+	struct sk_buff *skb = first->skb;
+	u8 tun_prot = 0;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		if (!(first->tx_flags & WX_TX_FLAGS_HW_VLAN) &&
+		    !(first->tx_flags & WX_TX_FLAGS_CC))
+			return;
+		vlan_macip_lens = skb_network_offset(skb) <<
+				  WX_TXD_MACLEN_SHIFT;
+	} else {
+		u8 l4_prot = 0;
+		union {
+			struct iphdr *ipv4;
+			struct ipv6hdr *ipv6;
+			u8 *raw;
+		} network_hdr;
+		union {
+			struct tcphdr *tcphdr;
+			u8 *raw;
+		} transport_hdr;
+
+		if (skb->encapsulation) {
+			network_hdr.raw = skb_inner_network_header(skb);
+			transport_hdr.raw = skb_inner_transport_header(skb);
+			vlan_macip_lens = skb_network_offset(skb) <<
+					  WX_TXD_MACLEN_SHIFT;
+			switch (first->protocol) {
+			case htons(ETH_P_IP):
+				tun_prot = ip_hdr(skb)->protocol;
+				break;
+			case htons(ETH_P_IPV6):
+				tun_prot = ipv6_hdr(skb)->nexthdr;
+				break;
+			default:
+				return;
+			}
+			switch (tun_prot) {
+			case IPPROTO_UDP:
+				tunhdr_eiplen_tunlen = WX_TXD_TUNNEL_UDP;
+				tunhdr_eiplen_tunlen |=
+					((skb_network_header_len(skb) >> 2) <<
+					WX_TXD_OUTER_IPLEN_SHIFT) |
+					(((skb_inner_mac_header(skb) -
+					skb_transport_header(skb)) >> 1) <<
+					WX_TXD_TUNNEL_LEN_SHIFT);
+				break;
+			case IPPROTO_GRE:
+				tunhdr_eiplen_tunlen = WX_TXD_TUNNEL_GRE;
+				tunhdr_eiplen_tunlen |= ((skb_network_header_len(skb) >> 2) <<
+							 WX_TXD_OUTER_IPLEN_SHIFT) |
+							 (((skb_inner_mac_header(skb) -
+							    skb_transport_header(skb)) >> 1) <<
+							  WX_TXD_TUNNEL_LEN_SHIFT);
+				break;
+			case IPPROTO_IPIP:
+				tunhdr_eiplen_tunlen = (((char *)inner_ip_hdr(skb) -
+							(char *)ip_hdr(skb)) >> 2) <<
+							WX_TXD_OUTER_IPLEN_SHIFT;
+				break;
+			default:
+				break;
+			}
+
+		} else {
+			network_hdr.raw = skb_network_header(skb);
+			transport_hdr.raw = skb_transport_header(skb);
+			vlan_macip_lens = skb_network_offset(skb) <<
+					  WX_TXD_MACLEN_SHIFT;
+		}
+
+		switch (network_hdr.ipv4->version) {
+		case IPVERSION:
+			vlan_macip_lens |= (transport_hdr.raw - network_hdr.raw) >> 1;
+			l4_prot = network_hdr.ipv4->protocol;
+			break;
+		case 6:
+			vlan_macip_lens |= (transport_hdr.raw - network_hdr.raw) >> 1;
+			l4_prot = network_hdr.ipv6->nexthdr;
+			break;
+		default:
+			break;
+		}
+
+		switch (l4_prot) {
+		case IPPROTO_TCP:
+		mss_l4len_idx = (transport_hdr.tcphdr->doff * 4) <<
+				WX_TXD_L4LEN_SHIFT;
+			break;
+		case IPPROTO_SCTP:
+			mss_l4len_idx = sizeof(struct sctphdr) <<
+					WX_TXD_L4LEN_SHIFT;
+			break;
+		case IPPROTO_UDP:
+			mss_l4len_idx = sizeof(struct udphdr) <<
+					WX_TXD_L4LEN_SHIFT;
+			break;
+		default:
+			break;
+		}
+
+		/* update TX checksum flag */
+		first->tx_flags |= WX_TX_FLAGS_CSUM;
+	}
+	first->tx_flags |= WX_TX_FLAGS_CC;
+	/* vlan_macip_lens: MACLEN, VLAN tag */
+	vlan_macip_lens |= first->tx_flags & WX_TX_FLAGS_VLAN_MASK;
+
+	type_tucmd = ptype << 24;
+	if (skb->vlan_proto == htons(ETH_P_8021AD) &&
+	    netdev->features & NETIF_F_HW_VLAN_STAG_TX)
+		type_tucmd |= WX_SET_FLAG(first->tx_flags,
+					  WX_TX_FLAGS_HW_VLAN,
+					  0x1 << WX_TXD_TAG_TPID_SEL_SHIFT);
+	wx_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
+		       type_tucmd, mss_l4len_idx);
+}
+
 static netdev_tx_t wx_xmit_frame_ring(struct sk_buff *skb,
 				      struct wx_ring *tx_ring)
 {
 	u16 count = TXD_USE_COUNT(skb_headlen(skb));
 	struct wx_tx_buffer *first;
+	u8 hdr_len = 0, ptype;
 	unsigned short f;
+	u32 tx_flags = 0;
+	int tso;
 
 	/* need: 1 descriptor per page * PAGE_SIZE/WX_MAX_DATA_PER_TXD,
 	 *       + 1 desc for skb_headlen/WX_MAX_DATA_PER_TXD,
@@ -864,7 +1294,29 @@ static netdev_tx_t wx_xmit_frame_ring(struct sk_buff *skb,
 	first->bytecount = skb->len;
 	first->gso_segs = 1;
 
-	wx_tx_map(tx_ring, first);
+	/* if we have a HW VLAN tag being added default to the HW one */
+	if (skb_vlan_tag_present(skb)) {
+		tx_flags |= skb_vlan_tag_get(skb) << WX_TX_FLAGS_VLAN_SHIFT;
+		tx_flags |= WX_TX_FLAGS_HW_VLAN;
+	}
+
+	/* record initial flags and protocol */
+	first->tx_flags = tx_flags;
+	first->protocol = vlan_get_protocol(skb);
+
+	ptype = wx_encode_tx_desc_ptype(first);
+
+	tso = wx_tso(tx_ring, first, &hdr_len, ptype);
+	if (tso < 0)
+		goto out_drop;
+	else if (!tso)
+		wx_tx_csum(tx_ring, first, ptype);
+	wx_tx_map(tx_ring, first, hdr_len);
+
+	return NETDEV_TX_OK;
+out_drop:
+	dev_kfree_skb_any(first->skb);
+	first->skb = NULL;
 
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 32f952d93009..d2e0584e3b44 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -6,6 +6,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/netdevice.h>
+#include <net/ip.h>
 
 #define WX_NCSI_SUP                             0x8000
 #define WX_NCSI_MASK                            0x8000
@@ -315,9 +316,6 @@
 #define TXD_USE_COUNT(S)     DIV_ROUND_UP((S), WX_MAX_DATA_PER_TXD)
 #define DESC_NEEDED          (MAX_SKB_FRAGS + 4)
 
-/* Ether Types */
-#define WX_ETH_P_CNM                 0x22E7
-
 #define WX_CFG_PORT_ST               0x14404
 
 /******************* Receive Descriptor bit definitions **********************/
@@ -326,6 +324,29 @@
 
 #define WX_RXD_ERR_RXE               BIT(29) /* Any MAC Error */
 
+/* TUN */
+#define WX_PTYPE_TUN_IPV4            0x80
+#define WX_PTYPE_TUN_IPV6            0xC0
+
+/* PKT for TUN */
+#define WX_PTYPE_PKT_IPIP            0x00 /* IP+IP */
+#define WX_PTYPE_PKT_IG              0x10 /* IP+GRE */
+#define WX_PTYPE_PKT_IGM             0x20 /* IP+GRE+MAC */
+#define WX_PTYPE_PKT_IGMV            0x30 /* IP+GRE+MAC+VLAN */
+/* PKT for !TUN */
+#define WX_PTYPE_PKT_MAC             0x10
+#define WX_PTYPE_PKT_IP              0x20
+
+/* TYP for PKT=mac */
+#define WX_PTYPE_TYP_MAC             0x01
+/* TYP for PKT=ip */
+#define WX_PTYPE_PKT_IPV6            0x08
+#define WX_PTYPE_TYP_IPFRAG          0x01
+#define WX_PTYPE_TYP_IP              0x02
+#define WX_PTYPE_TYP_UDP             0x03
+#define WX_PTYPE_TYP_TCP             0x04
+#define WX_PTYPE_TYP_SCTP            0x05
+
 /*********************** Transmit Descriptor Config Masks ****************/
 #define WX_TXD_STAT_DD               BIT(0)  /* Descriptor Done */
 #define WX_TXD_DTYP_DATA             0       /* Adv Data Descriptor */
@@ -334,6 +355,49 @@
 #define WX_TXD_IFCS                  BIT(25) /* Insert FCS */
 #define WX_TXD_RS                    BIT(27) /* Report Status */
 
+/*********************** Adv Transmit Descriptor Config Masks ****************/
+#define WX_TXD_MAC_TSTAMP            BIT(19) /* IEEE1588 time stamp */
+#define WX_TXD_DTYP_CTXT             BIT(20) /* Adv Context Desc */
+#define WX_TXD_LINKSEC               BIT(26) /* enable linksec */
+#define WX_TXD_VLE                   BIT(30) /* VLAN pkt enable */
+#define WX_TXD_TSE                   BIT(31) /* TCP Seg enable */
+#define WX_TXD_CC                    BIT(7) /* Check Context */
+#define WX_TXD_IPSEC                 BIT(8) /* enable ipsec esp */
+#define WX_TXD_L4CS                  BIT(9)
+#define WX_TXD_IIPCS                 BIT(10)
+#define WX_TXD_EIPCS                 BIT(11)
+#define WX_TXD_PAYLEN_SHIFT          13 /* Adv desc PAYLEN shift */
+#define WX_TXD_MACLEN_SHIFT          9  /* Adv ctxt desc mac len shift */
+#define WX_TXD_TAG_TPID_SEL_SHIFT    11
+
+#define WX_TXD_L4LEN_SHIFT           8  /* Adv ctxt L4LEN shift */
+#define WX_TXD_MSS_SHIFT             16  /* Adv ctxt MSS shift */
+
+#define WX_TXD_OUTER_IPLEN_SHIFT     12 /* Adv ctxt OUTERIPLEN shift */
+#define WX_TXD_TUNNEL_LEN_SHIFT      21 /* Adv ctxt TUNNELLEN shift */
+#define WX_TXD_TUNNEL_TYPE_SHIFT     11 /* Adv Tx Desc Tunnel Type shift */
+#define WX_TXD_TUNNEL_UDP            FIELD_PREP(BIT(WX_TXD_TUNNEL_TYPE_SHIFT), 0)
+#define WX_TXD_TUNNEL_GRE            FIELD_PREP(BIT(WX_TXD_TUNNEL_TYPE_SHIFT), 1)
+
+enum wx_tx_flags {
+	/* cmd_type flags */
+	WX_TX_FLAGS_HW_VLAN	= 0x01,
+	WX_TX_FLAGS_TSO		= 0x02,
+	WX_TX_FLAGS_TSTAMP	= 0x04,
+
+	/* olinfo flags */
+	WX_TX_FLAGS_CC		= 0x08,
+	WX_TX_FLAGS_IPV4	= 0x10,
+	WX_TX_FLAGS_CSUM	= 0x20,
+	WX_TX_FLAGS_OUTER_IPV4	= 0x100,
+	WX_TX_FLAGS_LINKSEC	= 0x200,
+	WX_TX_FLAGS_IPSEC	= 0x400,
+};
+
+/* VLAN info */
+#define WX_TX_FLAGS_VLAN_MASK			GENMASK(31, 16)
+#define WX_TX_FLAGS_VLAN_SHIFT			16
+
 /* Host Interface Command Structures */
 struct wx_hic_hdr {
 	u8 cmd;
@@ -508,10 +572,25 @@ union wx_rx_desc {
 	} wb;  /* writeback */
 };
 
+struct wx_tx_context_desc {
+	__le32 vlan_macip_lens;
+	__le32 seqnum_seed;
+	__le32 type_tucmd_mlhl;
+	__le32 mss_l4len_idx;
+};
+
+/* if _flag is in _input, return _result */
+#define WX_SET_FLAG(_input, _flag, _result) \
+	(((_flag) <= (_result)) ? \
+	 ((u32)((_input) & (_flag)) * ((_result) / (_flag))) : \
+	 ((u32)((_input) & (_flag)) / ((_flag) / (_result))))
+
 #define WX_RX_DESC(R, i)     \
 	(&(((union wx_rx_desc *)((R)->desc))[i]))
 #define WX_TX_DESC(R, i)     \
 	(&(((union wx_tx_desc *)((R)->desc))[i]))
+#define WX_TX_CTXTDESC(R, i) \
+	(&(((struct wx_tx_context_desc *)((R)->desc))[i]))
 
 /* wrapper around a pointer to a socket buffer,
  * so a DMA handle can be stored along with the buffer
@@ -523,6 +602,8 @@ struct wx_tx_buffer {
 	unsigned short gso_segs;
 	DEFINE_DMA_UNMAP_ADDR(dma);
 	DEFINE_DMA_UNMAP_LEN(len);
+	__be16 protocol;
+	u32 tx_flags;
 };
 
 struct wx_rx_buffer {
-- 
2.40.1


