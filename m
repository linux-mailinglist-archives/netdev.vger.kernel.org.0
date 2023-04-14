Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8FE6E213F
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjDNKth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjDNKtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:49:32 -0400
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620D483CD
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 03:49:05 -0700 (PDT)
X-QQ-mid: bizesmtp74t1681469327t85icx85
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 14 Apr 2023 18:48:45 +0800 (CST)
X-QQ-SSF: 01400000000000N0R000000A0000000
X-QQ-FEAT: 2w1wQVt6itQdL8fwzpGum6lf16PDdfHMwI/2L81abvfVhx8gZXPVOkBV1Y+B4
        sSHmXOnYsS/Y6OjGgDHzsjIqhACRi32GlOQNSMu4C+HQQbxEcGa7JaXouo+7Zq/l3cNoYdY
        VfVkV4yEvyOsQDwD7G1OpjXpC3udW5yDieCGRSd+49AIJS3MYOGWUy4fSKPpVbfC21z/mKb
        xhh5YFTLsRpNVtutB+6YIqMqyA1Xo4Azs+BhNO095F/SAVQWw3ijERe3PpWnpWhuoXSl2Li
        /TvC4DbwPZx1o3Rtn7HBwm3YXpHz++itFzMU1LSL54fCzV/2z6x55cxqjFPxotiLMOjwbOY
        8iZ7IKQ6VtvpHGlKnw9OcVAolkSBjIm8b1mynvRvYZgL48RhaeWMKRDnPH1d7R+A2o6F+IF
        Omj0/paf/F/QHoJeGfpocg==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 16240479730292882327
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, mengyuanlou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 1/5] net: wangxun: libwx add tx offload functions
Date:   Fri, 14 Apr 2023 18:48:29 +0800
Message-Id: <20230414104833.42989-2-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230414104833.42989-1-mengyuanlou@net-swift.com>
References: <20230414104833.42989-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: mengyuanlou <mengyuanlou@net-swift.com>

Add tx offload functions for wx_xmit_frame_ring which
includes wx_encode_tx_desc_ptype, wx_tso and wx_tx_csum.
which supports ngbe and txgbe to implement tx offload
function.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 536 ++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h | 648 +++++++++++++++++++
 2 files changed, 1179 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index eb89a274083e..711673d5bcd1 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -3,8 +3,12 @@
 
 #include <linux/etherdevice.h>
 #include <net/page_pool.h>
+#include <net/inet_ecn.h>
 #include <linux/iopoll.h>
+#include <linux/sctp.h>
 #include <linux/pci.h>
+#include <net/tcp.h>
+#include <net/ip.h>
 
 #include "wx_type.h"
 #include "wx_lib.h"
@@ -707,11 +711,50 @@ static int wx_maybe_stop_tx(struct wx_ring *tx_ring, u16 size)
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
@@ -719,10 +762,9 @@ static void wx_tx_map(struct wx_ring *tx_ring,
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
@@ -838,12 +880,462 @@ static void wx_tx_map(struct wx_ring *tx_ring,
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
+static u8 wx_get_ipv6_proto(struct sk_buff *skb, int offset)
+{
+	struct ipv6hdr *hdr = (struct ipv6hdr *)(skb->data + offset);
+	u8 nexthdr = hdr->nexthdr;
+
+	offset += sizeof(struct ipv6hdr);
+
+	while (ipv6_ext_hdr(nexthdr)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+
+		if (nexthdr == NEXTHDR_NONE)
+			break;
+
+		hp = skb_header_pointer(skb, offset, sizeof(_hdr), &_hdr);
+		if (!hp)
+			break;
+
+		if (nexthdr == NEXTHDR_FRAGMENT)
+			break;
+		else if (nexthdr == NEXTHDR_AUTH)
+			offset +=  ipv6_authlen(hp);
+		else
+			offset +=  ipv6_optlen(hp);
+		nexthdr = hp->nexthdr;
+	}
+
+	return nexthdr;
+}
+
+union network_header {
+	struct iphdr *ipv4;
+	struct ipv6hdr *ipv6;
+	void *raw;
+};
+
+static wx_dptype wx_encode_tx_desc_ptype(const struct wx_tx_buffer *first)
+{
+	struct sk_buff *skb = first->skb;
+	u8 tun_prot = 0;
+	u8 l4_prot = 0;
+	u8 ptype = 0;
+
+	if (skb->encapsulation) {
+		union network_header hdr;
+
+		switch (first->protocol) {
+		case htons(ETH_P_IP):
+			tun_prot = ip_hdr(skb)->protocol;
+			if (ip_is_fragment(ip_hdr(skb)))
+				goto encap_frag;
+			ptype = WX_PTYPE_TUN_IPV4;
+			break;
+		case htons(ETH_P_IPV6):
+			tun_prot = wx_get_ipv6_proto(skb, skb_network_offset(skb));
+			if (tun_prot == NEXTHDR_FRAGMENT)
+				goto encap_frag;
+			ptype = WX_PTYPE_TUN_IPV6;
+			break;
+		default:
+			goto exit;
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
+			goto exit;
+		}
+
+		switch (hdr.ipv4->version) {
+		case IPVERSION:
+			l4_prot = hdr.ipv4->protocol;
+			if (ip_is_fragment(ip_hdr(skb))) {
+				ptype |= WX_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+		case 6:
+			l4_prot = wx_get_ipv6_proto(skb, skb_inner_network_offset(skb));
+			ptype |= WX_PTYPE_PKT_IPV6;
+			if (l4_prot == NEXTHDR_FRAGMENT) {
+				ptype |= WX_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+		default:
+			goto exit;
+		}
+	} else {
+encap_frag:
+		switch (first->protocol) {
+		case htons(ETH_P_IP):
+			l4_prot = ip_hdr(skb)->protocol;
+			ptype = WX_PTYPE_PKT_IP;
+			if (ip_is_fragment(ip_hdr(skb))) {
+				ptype |= WX_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+		case htons(ETH_P_IPV6):
+			l4_prot = wx_get_ipv6_proto(skb, skb_network_offset(skb));
+			ptype = WX_PTYPE_PKT_IP | WX_PTYPE_PKT_IPV6;
+			if (l4_prot == NEXTHDR_FRAGMENT) {
+				ptype |= WX_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+		case htons(ETH_P_1588):
+			ptype = WX_PTYPE_L2_TS;
+			goto exit;
+		case htons(ETH_P_FIP):
+			ptype = WX_PTYPE_L2_FIP;
+			goto exit;
+		case htons(WX_ETH_P_LLDP):
+			ptype = WX_PTYPE_L2_LLDP;
+			goto exit;
+		case htons(WX_ETH_P_CNM):
+			ptype = WX_PTYPE_L2_CNM;
+			goto exit;
+		case htons(ETH_P_PAE):
+			ptype = WX_PTYPE_L2_EAPOL;
+			goto exit;
+		case htons(ETH_P_ARP):
+			ptype = WX_PTYPE_L2_ARP;
+			goto exit;
+		default:
+			ptype = WX_PTYPE_L2_MAC;
+			goto exit;
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
+exit:
+	return wx_decode_ptype(ptype);
+}
+
+static int wx_tso(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
+		  u8 *hdr_len, wx_dptype dptype)
+{
+	u32 vlan_macip_lens, type_tucmd, mss_l4len_idx;
+	struct net_device *netdev = tx_ring->netdev;
+	struct sk_buff *skb = first->skb;
+	u32 l4len, tunhdr_eiplen_tunlen;
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
+						iph->daddr, 0,
+						IPPROTO_TCP,
+						0);
+		first->tx_flags |= WX_TX_FLAGS_TSO |
+				   WX_TX_FLAGS_CSUM |
+				   WX_TX_FLAGS_IPV4 |
+				   WX_TX_FLAGS_CC;
+	} else if (iph->version == 6 && skb_is_gso_v6(skb)) {
+		ipv6h = enc ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
+		tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
+		ipv6h->payload_len = 0;
+		tcph->check =
+		    ~csum_ipv6_magic(&ipv6h->saddr,
+				     &ipv6h->daddr,
+				     0, IPPROTO_TCP, 0);
+		first->tx_flags |= WX_TX_FLAGS_TSO |
+				   WX_TX_FLAGS_CSUM |
+				   WX_TX_FLAGS_CC;
+	}
+
+	/* compute header lengths */
+	l4len = enc ? inner_tcp_hdrlen(skb) : tcp_hdrlen(skb);
+	*hdr_len = enc ? (skb_inner_transport_header(skb) - skb->data)
+		       : skb_transport_offset(skb);
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
+	type_tucmd = dptype.ptype << 24;
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
+		       wx_dptype dptype)
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
+				if (unlikely(net_ratelimit())) {
+					dev_warn(tx_ring->dev,
+						 "partial checksum but version=%d\n",
+						 network_hdr.ipv4->version);
+				}
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
+			vlan_macip_lens |=
+				(transport_hdr.raw - network_hdr.raw) >> 1;
+			l4_prot = network_hdr.ipv4->protocol;
+			break;
+		case 6:
+			vlan_macip_lens |=
+				(transport_hdr.raw - network_hdr.raw) >> 1;
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
+	type_tucmd = dptype.ptype << 24;
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
+	__be16 protocol = skb->protocol;
 	struct wx_tx_buffer *first;
+	wx_dptype dptype;
 	unsigned short f;
+	u32 tx_flags = 0;
+	u8 hdr_len = 0;
+	int tso;
 
 	/* need: 1 descriptor per page * PAGE_SIZE/WX_MAX_DATA_PER_TXD,
 	 *       + 1 desc for skb_headlen/WX_MAX_DATA_PER_TXD,
@@ -864,7 +1356,41 @@ static netdev_tx_t wx_xmit_frame_ring(struct sk_buff *skb,
 	first->bytecount = skb->len;
 	first->gso_segs = 1;
 
-	wx_tx_map(tx_ring, first);
+	/* if we have a HW VLAN tag being added default to the HW one */
+	if (skb_vlan_tag_present(skb)) {
+		tx_flags |= skb_vlan_tag_get(skb) << WX_TX_FLAGS_VLAN_SHIFT;
+		tx_flags |= WX_TX_FLAGS_HW_VLAN;
+	/* else if it is a SW VLAN check the next protocol and store the tag */
+	} else if (protocol == htons(ETH_P_8021Q)) {
+		struct vlan_hdr *vhdr, _vhdr;
+
+		vhdr = skb_header_pointer(skb, ETH_HLEN, sizeof(_vhdr), &_vhdr);
+		if (!vhdr)
+			goto out_drop;
+
+		protocol = vhdr->h_vlan_encapsulated_proto;
+		tx_flags |= ntohs(vhdr->h_vlan_TCI) << WX_TX_FLAGS_VLAN_SHIFT;
+		tx_flags |= WX_TX_FLAGS_SW_VLAN;
+	}
+	protocol = vlan_get_protocol(skb);
+
+	/* record initial flags and protocol */
+	first->tx_flags = tx_flags;
+	first->protocol = protocol;
+
+	dptype = wx_encode_tx_desc_ptype(first);
+
+	tso = wx_tso(tx_ring, first, &hdr_len, dptype);
+	if (tso < 0)
+		goto out_drop;
+	else if (!tso)
+		wx_tx_csum(tx_ring, first, dptype);
+	wx_tx_map(tx_ring, first, hdr_len);
+
+	return NETDEV_TX_OK;
+out_drop:
+	dev_kfree_skb_any(first->skb);
+	first->skb = NULL;
 
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 32f952d93009..e227268a9518 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -6,6 +6,8 @@
 
 #include <linux/bitfield.h>
 #include <linux/netdevice.h>
+#include <linux/if_vlan.h>
+#include <net/ip.h>
 
 #define WX_NCSI_SUP                             0x8000
 #define WX_NCSI_MASK                            0x8000
@@ -64,6 +66,8 @@
 #define WX_CFG_PORT_CTL_QINQ         BIT(2)
 #define WX_CFG_PORT_CTL_D_VLAN       BIT(0) /* double vlan*/
 #define WX_CFG_TAG_TPID(_i)          (0x14430 + ((_i) * 4))
+#define WX_CFG_PORT_CTL_NUM_VT_MASK  GENMASK(13, 12) /* number of TVs */
+
 
 /* GPIO Registers */
 #define WX_GPIO_DR                   0x14800
@@ -87,6 +91,8 @@
 /* TDM CTL BIT */
 #define WX_TDM_CTL_TE                BIT(0) /* Transmit Enable */
 #define WX_TDM_PB_THRE(_i)           (0x18020 + ((_i) * 4))
+#define WX_TDM_RP_IDX                0x1820C
+#define WX_TDM_RP_RATE               0x18404
 
 /***************************** RDB registers *********************************/
 /* receive packet buffer */
@@ -296,6 +302,7 @@
 #define WX_MAX_TXD                   8192
 
 #define WX_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
+#define VMDQ_P(p)                    p
 
 /* Supported Rx Buffer Sizes */
 #define WX_RXBUFFER_256      256    /* Used for skb receive header */
@@ -326,6 +333,107 @@
 
 #define WX_RXD_ERR_RXE               BIT(29) /* Any MAC Error */
 
+/**
+ * receive packet type
+ * PTYPE:8 = TUN:2 + PKT:2 + TYP:4
+ **/
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
+#define WX_PTYPE_PKT_FCOE            0x30
+
+/* TYP for PKT=mac */
+#define WX_PTYPE_TYP_MAC             0x01
+#define WX_PTYPE_TYP_TS              0x02 /* time sync */
+#define WX_PTYPE_TYP_FIP             0x03
+#define WX_PTYPE_TYP_LLDP            0x04
+#define WX_PTYPE_TYP_CNM             0x05
+#define WX_PTYPE_TYP_EAPOL           0x06
+#define WX_PTYPE_TYP_ARP             0x07
+/* TYP for PKT=ip */
+#define WX_PTYPE_PKT_IPV6            0x08
+#define WX_PTYPE_TYP_IPFRAG          0x01
+#define WX_PTYPE_TYP_IP              0x02
+#define WX_PTYPE_TYP_UDP             0x03
+#define WX_PTYPE_TYP_TCP             0x04
+#define WX_PTYPE_TYP_SCTP            0x05
+/* TYP for PKT=fcoe */
+#define WX_PTYPE_PKT_VFT             0x08
+#define WX_PTYPE_TYP_FCOE            0x00
+#define WX_PTYPE_TYP_FCDATA          0x01
+#define WX_PTYPE_TYP_FCRDY           0x02
+#define WX_PTYPE_TYP_FCRSP           0x03
+#define WX_PTYPE_TYP_FCOTHER         0x04
+
+/* Packet type non-ip values */
+enum wx_l2_ptypes {
+	WX_PTYPE_L2_ABORTED = (WX_PTYPE_PKT_MAC),
+	WX_PTYPE_L2_MAC = (WX_PTYPE_PKT_MAC | WX_PTYPE_TYP_MAC),
+	WX_PTYPE_L2_TS = (WX_PTYPE_PKT_MAC | WX_PTYPE_TYP_TS),
+	WX_PTYPE_L2_FIP = (WX_PTYPE_PKT_MAC | WX_PTYPE_TYP_FIP),
+	WX_PTYPE_L2_LLDP = (WX_PTYPE_PKT_MAC | WX_PTYPE_TYP_LLDP),
+	WX_PTYPE_L2_CNM = (WX_PTYPE_PKT_MAC | WX_PTYPE_TYP_CNM),
+	WX_PTYPE_L2_EAPOL = (WX_PTYPE_PKT_MAC | WX_PTYPE_TYP_EAPOL),
+	WX_PTYPE_L2_ARP = (WX_PTYPE_PKT_MAC | WX_PTYPE_TYP_ARP),
+	WX_PTYPE_L2_IPV4_FRAG = (WX_PTYPE_PKT_IP | WX_PTYPE_TYP_IPFRAG),
+	WX_PTYPE_L2_IPV4 = (WX_PTYPE_PKT_IP | WX_PTYPE_TYP_IP),
+	WX_PTYPE_L2_IPV4_UDP = (WX_PTYPE_PKT_IP | WX_PTYPE_TYP_UDP),
+	WX_PTYPE_L2_IPV4_TCP = (WX_PTYPE_PKT_IP | WX_PTYPE_TYP_TCP),
+	WX_PTYPE_L2_IPV4_SCTP = (WX_PTYPE_PKT_IP | WX_PTYPE_TYP_SCTP),
+	WX_PTYPE_L2_IPV6_FRAG = (WX_PTYPE_PKT_IP |
+				 WX_PTYPE_PKT_IPV6 |
+				 WX_PTYPE_TYP_IPFRAG),
+	WX_PTYPE_L2_IPV6 = (WX_PTYPE_PKT_IP |
+			    WX_PTYPE_PKT_IPV6 |
+			    WX_PTYPE_TYP_IP),
+	WX_PTYPE_L2_IPV6_UDP = (WX_PTYPE_PKT_IP |
+				WX_PTYPE_PKT_IPV6 |
+				WX_PTYPE_TYP_UDP),
+	WX_PTYPE_L2_IPV6_TCP = (WX_PTYPE_PKT_IP |
+				WX_PTYPE_PKT_IPV6 |
+				WX_PTYPE_TYP_TCP),
+	WX_PTYPE_L2_IPV6_SCTP = (WX_PTYPE_PKT_IP |
+				 WX_PTYPE_PKT_IPV6 |
+				 WX_PTYPE_TYP_SCTP),
+	WX_PTYPE_L2_FCOE = (WX_PTYPE_PKT_FCOE | WX_PTYPE_TYP_FCOE),
+	WX_PTYPE_L2_FCOE_FCDATA = (WX_PTYPE_PKT_FCOE |
+				   WX_PTYPE_TYP_FCDATA),
+	WX_PTYPE_L2_FCOE_FCRDY = (WX_PTYPE_PKT_FCOE |
+				  WX_PTYPE_TYP_FCRDY),
+	WX_PTYPE_L2_FCOE_FCRSP = (WX_PTYPE_PKT_FCOE |
+				  WX_PTYPE_TYP_FCRSP),
+	WX_PTYPE_L2_FCOE_FCOTHER = (WX_PTYPE_PKT_FCOE |
+				    WX_PTYPE_TYP_FCOTHER),
+	WX_PTYPE_L2_FCOE_VFT = (WX_PTYPE_PKT_FCOE | WX_PTYPE_PKT_VFT),
+	WX_PTYPE_L2_FCOE_VFT_FCDATA = (WX_PTYPE_PKT_FCOE |
+				       WX_PTYPE_PKT_VFT |
+				       WX_PTYPE_TYP_FCDATA),
+	WX_PTYPE_L2_FCOE_VFT_FCRDY = (WX_PTYPE_PKT_FCOE |
+				      WX_PTYPE_PKT_VFT |
+				      WX_PTYPE_TYP_FCRDY),
+	WX_PTYPE_L2_FCOE_VFT_FCRSP = (WX_PTYPE_PKT_FCOE |
+				      WX_PTYPE_PKT_VFT |
+				      WX_PTYPE_TYP_FCRSP),
+	WX_PTYPE_L2_FCOE_VFT_FCOTHER = (WX_PTYPE_PKT_FCOE |
+					WX_PTYPE_PKT_VFT |
+					WX_PTYPE_TYP_FCOTHER),
+	WX_PTYPE_L2_TUN4_MAC = (WX_PTYPE_TUN_IPV4 | WX_PTYPE_PKT_IGM),
+	WX_PTYPE_L2_TUN6_MAC = (WX_PTYPE_TUN_IPV6 | WX_PTYPE_PKT_IGM),
+};
+
+/* Ether Types */
+#define WX_ETH_P_LLDP			0x88CC
+#define WX_ETH_P_CNM			0x22E7
+
 /*********************** Transmit Descriptor Config Masks ****************/
 #define WX_TXD_STAT_DD               BIT(0)  /* Descriptor Done */
 #define WX_TXD_DTYP_DATA             0       /* Adv Data Descriptor */
@@ -334,6 +442,470 @@
 #define WX_TXD_IFCS                  BIT(25) /* Insert FCS */
 #define WX_TXD_RS                    BIT(27) /* Report Status */
 
+/*********************** Adv Transmit Descriptor Config Masks ****************/
+#define WX_TXD_DTALEN_MASK           U16_MAX /* Data buf length(bytes) */
+#define WX_TXD_MAC_LINKSEC           BIT(18) /* Insert LinkSec */
+#define WX_TXD_MAC_TSTAMP            BIT(19) /* IEEE1588 time stamp */
+#define WX_TXD_IPSEC_SA_INDEX_MASK   GENMASK(9, 0) /* IPSec SA index */
+#define WX_TXD_IPSEC_ESP_LEN_MASK    GENMASK(8, 0) /* IPSec ESP length */
+#define WX_TXD_DTYP_MASK             GENMASK(23, 20) /* DTYP mask */
+#define WX_TXD_DTYP_CTXT             BIT(20) /* Adv Context Desc */
+#define WX_TXD_EOP                   BIT(24)  /* End of Packet */
+#define WX_TXD_IFCS                  BIT(25) /* Insert FCS */
+#define WX_TXD_LINKSEC               BIT(26) /* enable linksec */
+#define WX_TXD_RS                    BIT(27) /* Report Status */
+#define WX_TXD_ECU                   BIT(28) /* DDP hdr type or iSCSI */
+#define WX_TXD_QCN                   BIT(29) /* cntag insertion enable */
+#define WX_TXD_VLE                   BIT(30) /* VLAN pkt enable */
+#define WX_TXD_TSE                   BIT(31) /* TCP Seg enable */
+#define WX_TXD_STAT_DD               BIT(0) /* Descriptor Done */
+#define WX_TXD_IDX_SHIFT             4 /* Adv desc Index shift */
+#define WX_TXD_CC                    BIT(7) /* Check Context */
+#define WX_TXD_IPSEC                 BIT(8) /* enable ipsec esp */
+#define WX_TXD_L4CS                  BIT(9)
+#define WX_TXD_IIPCS                 BIT(10)
+#define WX_TXD_EIPCS                 BIT(11)
+#define WX_TXD_PAYLEN_SHIFT          13 /* Adv desc PAYLEN shift */
+#define WX_TXD_MACLEN_SHIFT          9  /* Adv ctxt desc mac len shift */
+#define WX_TXD_VLAN_SHIFT            16  /* Adv ctxt vlan tag shift */
+#define WX_TXD_TAG_TPID_SEL_SHIFT    11
+#define WX_TXD_IPSEC_TYPE_SHIFT      14
+#define WX_TXD_ENC_SHIFT             15
+
+#define WX_TXD_TUCMD_IPSEC_TYPE_ESP  BIT(14) /* IPSec Type ESP */
+#define WX_TXD_TUCMD_IPSEC_ENCRYPT_EN BIT(15)/* ESP Encrypt Enable */
+#define WX_TXD_TUCMD_FCOE            BIT(16) /* FCoE Frame Type */
+#define WX_TXD_FCOEF_EOF_MASK        GENMASK(11, 10) /* FC EOF index */
+#define WX_TXD_FCOEF_SOF             BIT(12) /* FC SOF index */
+#define WX_TXD_FCOEF_PARINC          BIT(13) /* Rel_Off in F_CTL */
+#define WX_TXD_FCOEF_ORIE            BIT(14) /* Orientation End */
+#define WX_TXD_FCOEF_ORIS            BIT(15) /* Orientation Start */
+#define WX_TXD_FCOEF_EOF_N           FIELD_PREP(WX_TXD_FCOEF_EOF_MASK, 0) /* 00: EOFn */
+#define WX_TXD_FCOEF_EOF_T           FIELD_PREP(WX_TXD_FCOEF_EOF_MASK, 1)  /* 01: EOFt */
+#define WX_TXD_FCOEF_EOF_NI          FIELD_PREP(WX_TXD_FCOEF_EOF_MASK, 2)  /* 10: EOFni */
+#define WX_TXD_FCOEF_EOF_A           FIELD_PREP(WX_TXD_FCOEF_EOF_MASK, 3)  /* 11: EOFa */
+#define WX_TXD_L4LEN_SHIFT           8  /* Adv ctxt L4LEN shift */
+#define WX_TXD_MSS_SHIFT             16  /* Adv ctxt MSS shift */
+
+#define WX_TXD_OUTER_IPLEN_SHIFT     12 /* Adv ctxt OUTERIPLEN shift */
+#define WX_TXD_TUNNEL_LEN_SHIFT      21 /* Adv ctxt TUNNELLEN shift */
+#define WX_TXD_TUNNEL_TYPE_SHIFT     11 /* Adv Tx Desc Tunnel Type shift */
+#define WX_TXD_TUNNEL_DECTTL_SHIFT   27 /* Adv ctxt DECTTL shift */
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
+
+	/* software defined flags */
+	WX_TX_FLAGS_SW_VLAN	= 0x40,
+	WX_TX_FLAGS_FCOE	= 0x80,
+};
+
+/* VLAN info */
+#define WX_TX_FLAGS_VLAN_MASK			GENMASK(31, 16)
+#define WX_TX_FLAGS_VLAN_PRIO_MASK		GENMASK(31, 29)
+#define WX_TX_FLAGS_VLAN_PRIO_SHIFT		29
+#define WX_TX_FLAGS_VLAN_SHIFT			16
+
+/**
+ * Packet Type decoding
+ **/
+/* wx_dec_ptype.mac: outer mac */
+enum wx_dec_ptype_mac {
+	WX_DEC_PTYPE_MAC_IP	= 0,
+	WX_DEC_PTYPE_MAC_L2	= 2,
+	WX_DEC_PTYPE_MAC_FCOE	= 3,
+};
+
+/* wx_dec_ptype.[e]ip: outer&encaped ip */
+#define WX_DEC_PTYPE_IP_FRAG	0x4
+enum wx_dec_ptype_ip {
+	WX_DEC_PTYPE_IP_NONE = 0,
+	WX_DEC_PTYPE_IP_IPV4 = 1,
+	WX_DEC_PTYPE_IP_IPV6 = 2,
+	WX_DEC_PTYPE_IP_FGV4 = WX_DEC_PTYPE_IP_FRAG | WX_DEC_PTYPE_IP_IPV4,
+	WX_DEC_PTYPE_IP_FGV6 = WX_DEC_PTYPE_IP_FRAG | WX_DEC_PTYPE_IP_IPV6,
+};
+
+/* wx_dec_ptype.etype: encaped type */
+enum wx_dec_ptype_etype {
+	WX_DEC_PTYPE_ETYPE_NONE	= 0,
+	WX_DEC_PTYPE_ETYPE_IPIP	= 1,	/* IP+IP */
+	WX_DEC_PTYPE_ETYPE_IG	= 2,	/* IP+GRE */
+	WX_DEC_PTYPE_ETYPE_IGM	= 3,	/* IP+GRE+MAC */
+	WX_DEC_PTYPE_ETYPE_IGMV	= 4,	/* IP+GRE+MAC+VLAN */
+};
+
+/* wx_dec_ptype.proto: payload proto */
+enum wx_dec_ptype_prot {
+	WX_DEC_PTYPE_PROT_NONE	= 0,
+	WX_DEC_PTYPE_PROT_UDP	= 1,
+	WX_DEC_PTYPE_PROT_TCP	= 2,
+	WX_DEC_PTYPE_PROT_SCTP	= 3,
+	WX_DEC_PTYPE_PROT_ICMP	= 4,
+	WX_DEC_PTYPE_PROT_TS	= 5,	/* time sync */
+};
+
+/* wx_dec_ptype.layer: payload layer */
+enum wx_dec_ptype_layer {
+	WX_DEC_PTYPE_LAYER_NONE = 0,
+	WX_DEC_PTYPE_LAYER_PAY2 = 1,
+	WX_DEC_PTYPE_LAYER_PAY3 = 2,
+	WX_DEC_PTYPE_LAYER_PAY4 = 3,
+};
+
+struct wx_dec_ptype {
+	u32 ptype:8;
+	u32 known:1;
+	u32 mac:2;	/* outer mac */
+	u32 ip:3;	/* outer ip*/
+	u32 etype:3;	/* encaped type */
+	u32 eip:3;	/* encaped ip */
+	u32 prot:4;	/* payload proto */
+	u32 layer:3;	/* payload layer */
+};
+
+typedef struct wx_dec_ptype wx_dptype;
+
+/* The wx_ptype_lookup is used to convert from the 8-bit ptype in the
+ * hardware to a bit-field that can be used by SW to more easily determine the
+ * packet type.
+ *
+ * Macros are used to shorten the table lines and make this table human
+ * readable.
+ *
+ * We store the PTYPE in the top byte of the bit field - this is just so that
+ * we can check that the table doesn't have a row missing, as the index into
+ * the table should be the PTYPE.
+ *
+ * Typical work flow:
+ *
+ * if not wx_ptype_lookup[ptype].known
+ * then
+ *      Packet is unknown
+ * else if wx_ptype_lookup[ptype].mac == WX_DEC_PTYPE_MAC_IP
+ *      Use the rest of the fields to look at the tunnels, inner protocols, etc
+ * else
+ *      Use the enum wx_l2_ptypes to decode the packet type
+ * endif
+ */
+
+/* macro to make the table lines short */
+#define WX_PTT(ptype, mac, ip, etype, eip, proto, layer)\
+	      {ptype, \
+	       1, \
+	       WX_DEC_PTYPE_MAC_##mac,		/* mac */\
+	       WX_DEC_PTYPE_IP_##ip,		/* ip */ \
+	       WX_DEC_PTYPE_ETYPE_##etype,	/* etype */\
+	       WX_DEC_PTYPE_IP_##eip,		/* eip */\
+	       WX_DEC_PTYPE_PROT_##proto,	/* proto */\
+	       WX_DEC_PTYPE_LAYER_##layer	/* layer */}
+
+#define WX_UKN(ptype) { ptype, 0, 0, 0, 0, 0, 0, 0 }
+
+/* Lookup table mapping the HW PTYPE to the bit field for decoding */
+/* for ((pt=0;pt<256;pt++)); do printf "macro(0x%02X),\n" $pt; done */
+static wx_dptype wx_ptype_lookup[256] = {
+	WX_UKN(0x00),
+	WX_UKN(0x01),
+	WX_UKN(0x02),
+	WX_UKN(0x03),
+	WX_UKN(0x04),
+	WX_UKN(0x05),
+	WX_UKN(0x06),
+	WX_UKN(0x07),
+	WX_UKN(0x08),
+	WX_UKN(0x09),
+	WX_UKN(0x0A),
+	WX_UKN(0x0B),
+	WX_UKN(0x0C),
+	WX_UKN(0x0D),
+	WX_UKN(0x0E),
+	WX_UKN(0x0F),
+
+	/* L2: mac */
+	WX_UKN(0x10),
+	WX_PTT(0x11, L2, NONE, NONE, NONE, NONE, PAY2),
+	WX_PTT(0x12, L2, NONE, NONE, NONE, TS,   PAY2),
+	WX_PTT(0x13, L2, NONE, NONE, NONE, NONE, PAY2),
+	WX_PTT(0x14, L2, NONE, NONE, NONE, NONE, PAY2),
+	WX_PTT(0x15, L2, NONE, NONE, NONE, NONE, NONE),
+	WX_PTT(0x16, L2, NONE, NONE, NONE, NONE, PAY2),
+	WX_PTT(0x17, L2, NONE, NONE, NONE, NONE, NONE),
+
+	/* L2: ethertype filter */
+	WX_PTT(0x18, L2, NONE, NONE, NONE, NONE, NONE),
+	WX_PTT(0x19, L2, NONE, NONE, NONE, NONE, NONE),
+	WX_PTT(0x1A, L2, NONE, NONE, NONE, NONE, NONE),
+	WX_PTT(0x1B, L2, NONE, NONE, NONE, NONE, NONE),
+	WX_PTT(0x1C, L2, NONE, NONE, NONE, NONE, NONE),
+	WX_PTT(0x1D, L2, NONE, NONE, NONE, NONE, NONE),
+	WX_PTT(0x1E, L2, NONE, NONE, NONE, NONE, NONE),
+	WX_PTT(0x1F, L2, NONE, NONE, NONE, NONE, NONE),
+
+	/* L3: ip non-tunnel */
+	WX_UKN(0x20),
+	WX_PTT(0x21, IP, FGV4, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x22, IP, IPV4, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x23, IP, IPV4, NONE, NONE, UDP,  PAY4),
+	WX_PTT(0x24, IP, IPV4, NONE, NONE, TCP,  PAY4),
+	WX_PTT(0x25, IP, IPV4, NONE, NONE, SCTP, PAY4),
+	WX_UKN(0x26),
+	WX_UKN(0x27),
+	WX_UKN(0x28),
+	WX_PTT(0x29, IP, FGV6, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x2A, IP, IPV6, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x2B, IP, IPV6, NONE, NONE, UDP,  PAY3),
+	WX_PTT(0x2C, IP, IPV6, NONE, NONE, TCP,  PAY4),
+	WX_PTT(0x2D, IP, IPV6, NONE, NONE, SCTP, PAY4),
+	WX_UKN(0x2E),
+	WX_UKN(0x2F),
+
+	/* L2: fcoe */
+	WX_PTT(0x30, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x31, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x32, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x33, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x34, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_UKN(0x35),
+	WX_UKN(0x36),
+	WX_UKN(0x37),
+	WX_PTT(0x38, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x39, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x3A, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x3B, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_PTT(0x3C, FCOE, NONE, NONE, NONE, NONE, PAY3),
+	WX_UKN(0x3D),
+	WX_UKN(0x3E),
+	WX_UKN(0x3F),
+
+	WX_UKN(0x40),
+	WX_UKN(0x41),
+	WX_UKN(0x42),
+	WX_UKN(0x43),
+	WX_UKN(0x44),
+	WX_UKN(0x45),
+	WX_UKN(0x46),
+	WX_UKN(0x47),
+	WX_UKN(0x48),
+	WX_UKN(0x49),
+	WX_UKN(0x4A),
+	WX_UKN(0x4B),
+	WX_UKN(0x4C),
+	WX_UKN(0x4D),
+	WX_UKN(0x4E),
+	WX_UKN(0x4F),
+	WX_UKN(0x50),
+	WX_UKN(0x51),
+	WX_UKN(0x52),
+	WX_UKN(0x53),
+	WX_UKN(0x54),
+	WX_UKN(0x55),
+	WX_UKN(0x56),
+	WX_UKN(0x57),
+	WX_UKN(0x58),
+	WX_UKN(0x59),
+	WX_UKN(0x5A),
+	WX_UKN(0x5B),
+	WX_UKN(0x5C),
+	WX_UKN(0x5D),
+	WX_UKN(0x5E),
+	WX_UKN(0x5F),
+	WX_UKN(0x60),
+	WX_UKN(0x61),
+	WX_UKN(0x62),
+	WX_UKN(0x63),
+	WX_UKN(0x64),
+	WX_UKN(0x65),
+	WX_UKN(0x66),
+	WX_UKN(0x67),
+	WX_UKN(0x68),
+	WX_UKN(0x69),
+	WX_UKN(0x6A),
+	WX_UKN(0x6B),
+	WX_UKN(0x6C),
+	WX_UKN(0x6D),
+	WX_UKN(0x6E),
+	WX_UKN(0x6F),
+	WX_UKN(0x70),
+	WX_UKN(0x71),
+	WX_UKN(0x72),
+	WX_UKN(0x73),
+	WX_UKN(0x74),
+	WX_UKN(0x75),
+	WX_UKN(0x76),
+	WX_UKN(0x77),
+	WX_UKN(0x78),
+	WX_UKN(0x79),
+	WX_UKN(0x7A),
+	WX_UKN(0x7B),
+	WX_UKN(0x7C),
+	WX_UKN(0x7D),
+	WX_UKN(0x7E),
+	WX_UKN(0x7F),
+
+	/* IPv4 --> IPv4/IPv6 */
+	WX_UKN(0x80),
+	WX_PTT(0x81, IP, IPV4, IPIP, FGV4, NONE, PAY3),
+	WX_PTT(0x82, IP, IPV4, IPIP, IPV4, NONE, PAY3),
+	WX_PTT(0x83, IP, IPV4, IPIP, IPV4, UDP,  PAY4),
+	WX_PTT(0x84, IP, IPV4, IPIP, IPV4, TCP,  PAY4),
+	WX_PTT(0x85, IP, IPV4, IPIP, IPV4, SCTP, PAY4),
+	WX_UKN(0x86),
+	WX_UKN(0x87),
+	WX_UKN(0x88),
+	WX_PTT(0x89, IP, IPV4, IPIP, FGV6, NONE, PAY3),
+	WX_PTT(0x8A, IP, IPV4, IPIP, IPV6, NONE, PAY3),
+	WX_PTT(0x8B, IP, IPV4, IPIP, IPV6, UDP,  PAY4),
+	WX_PTT(0x8C, IP, IPV4, IPIP, IPV6, TCP,  PAY4),
+	WX_PTT(0x8D, IP, IPV4, IPIP, IPV6, SCTP, PAY4),
+	WX_UKN(0x8E),
+	WX_UKN(0x8F),
+
+	/* IPv4 --> GRE/NAT --> NONE/IPv4/IPv6 */
+	WX_PTT(0x90, IP, IPV4, IG, NONE, NONE, PAY3),
+	WX_PTT(0x91, IP, IPV4, IG, FGV4, NONE, PAY3),
+	WX_PTT(0x92, IP, IPV4, IG, IPV4, NONE, PAY3),
+	WX_PTT(0x93, IP, IPV4, IG, IPV4, UDP,  PAY4),
+	WX_PTT(0x94, IP, IPV4, IG, IPV4, TCP,  PAY4),
+	WX_PTT(0x95, IP, IPV4, IG, IPV4, SCTP, PAY4),
+	WX_UKN(0x96),
+	WX_UKN(0x97),
+	WX_UKN(0x98),
+	WX_PTT(0x99, IP, IPV4, IG, FGV6, NONE, PAY3),
+	WX_PTT(0x9A, IP, IPV4, IG, IPV6, NONE, PAY3),
+	WX_PTT(0x9B, IP, IPV4, IG, IPV6, UDP,  PAY4),
+	WX_PTT(0x9C, IP, IPV4, IG, IPV6, TCP,  PAY4),
+	WX_PTT(0x9D, IP, IPV4, IG, IPV6, SCTP, PAY4),
+	WX_UKN(0x9E),
+	WX_UKN(0x9F),
+
+	/* IPv4 --> GRE/NAT --> MAC --> NONE/IPv4/IPv6 */
+	WX_PTT(0xA0, IP, IPV4, IGM, NONE, NONE, PAY3),
+	WX_PTT(0xA1, IP, IPV4, IGM, FGV4, NONE, PAY3),
+	WX_PTT(0xA2, IP, IPV4, IGM, IPV4, NONE, PAY3),
+	WX_PTT(0xA3, IP, IPV4, IGM, IPV4, UDP,  PAY4),
+	WX_PTT(0xA4, IP, IPV4, IGM, IPV4, TCP,  PAY4),
+	WX_PTT(0xA5, IP, IPV4, IGM, IPV4, SCTP, PAY4),
+	WX_UKN(0xA6),
+	WX_UKN(0xA7),
+	WX_UKN(0xA8),
+	WX_PTT(0xA9, IP, IPV4, IGM, FGV6, NONE, PAY3),
+	WX_PTT(0xAA, IP, IPV4, IGM, IPV6, NONE, PAY3),
+	WX_PTT(0xAB, IP, IPV4, IGM, IPV6, UDP,  PAY4),
+	WX_PTT(0xAC, IP, IPV4, IGM, IPV6, TCP,  PAY4),
+	WX_PTT(0xAD, IP, IPV4, IGM, IPV6, SCTP, PAY4),
+	WX_UKN(0xAE),
+	WX_UKN(0xAF),
+
+	/* IPv4 --> GRE/NAT --> MAC+VLAN --> NONE/IPv4/IPv6 */
+	WX_PTT(0xB0, IP, IPV4, IGMV, NONE, NONE, PAY3),
+	WX_PTT(0xB1, IP, IPV4, IGMV, FGV4, NONE, PAY3),
+	WX_PTT(0xB2, IP, IPV4, IGMV, IPV4, NONE, PAY3),
+	WX_PTT(0xB3, IP, IPV4, IGMV, IPV4, UDP,  PAY4),
+	WX_PTT(0xB4, IP, IPV4, IGMV, IPV4, TCP,  PAY4),
+	WX_PTT(0xB5, IP, IPV4, IGMV, IPV4, SCTP, PAY4),
+	WX_UKN(0xB6),
+	WX_UKN(0xB7),
+	WX_UKN(0xB8),
+	WX_PTT(0xB9, IP, IPV4, IGMV, FGV6, NONE, PAY3),
+	WX_PTT(0xBA, IP, IPV4, IGMV, IPV6, NONE, PAY3),
+	WX_PTT(0xBB, IP, IPV4, IGMV, IPV6, UDP,  PAY4),
+	WX_PTT(0xBC, IP, IPV4, IGMV, IPV6, TCP,  PAY4),
+	WX_PTT(0xBD, IP, IPV4, IGMV, IPV6, SCTP, PAY4),
+	WX_UKN(0xBE),
+	WX_UKN(0xBF),
+
+	/* IPv6 --> IPv4/IPv6 */
+	WX_UKN(0xC0),
+	WX_PTT(0xC1, IP, IPV6, IPIP, FGV4, NONE, PAY3),
+	WX_PTT(0xC2, IP, IPV6, IPIP, IPV4, NONE, PAY3),
+	WX_PTT(0xC3, IP, IPV6, IPIP, IPV4, UDP,  PAY4),
+	WX_PTT(0xC4, IP, IPV6, IPIP, IPV4, TCP,  PAY4),
+	WX_PTT(0xC5, IP, IPV6, IPIP, IPV4, SCTP, PAY4),
+	WX_UKN(0xC6),
+	WX_UKN(0xC7),
+	WX_UKN(0xC8),
+	WX_PTT(0xC9, IP, IPV6, IPIP, FGV6, NONE, PAY3),
+	WX_PTT(0xCA, IP, IPV6, IPIP, IPV6, NONE, PAY3),
+	WX_PTT(0xCB, IP, IPV6, IPIP, IPV6, UDP,  PAY4),
+	WX_PTT(0xCC, IP, IPV6, IPIP, IPV6, TCP,  PAY4),
+	WX_PTT(0xCD, IP, IPV6, IPIP, IPV6, SCTP, PAY4),
+	WX_UKN(0xCE),
+	WX_UKN(0xCF),
+
+	/* IPv6 --> GRE/NAT -> NONE/IPv4/IPv6 */
+	WX_PTT(0xD0, IP, IPV6, IG,   NONE, NONE, PAY3),
+	WX_PTT(0xD1, IP, IPV6, IG,   FGV4, NONE, PAY3),
+	WX_PTT(0xD2, IP, IPV6, IG,   IPV4, NONE, PAY3),
+	WX_PTT(0xD3, IP, IPV6, IG,   IPV4, UDP,  PAY4),
+	WX_PTT(0xD4, IP, IPV6, IG,   IPV4, TCP,  PAY4),
+	WX_PTT(0xD5, IP, IPV6, IG,   IPV4, SCTP, PAY4),
+	WX_UKN(0xD6),
+	WX_UKN(0xD7),
+	WX_UKN(0xD8),
+	WX_PTT(0xD9, IP, IPV6, IG,   FGV6, NONE, PAY3),
+	WX_PTT(0xDA, IP, IPV6, IG,   IPV6, NONE, PAY3),
+	WX_PTT(0xDB, IP, IPV6, IG,   IPV6, UDP,  PAY4),
+	WX_PTT(0xDC, IP, IPV6, IG,   IPV6, TCP,  PAY4),
+	WX_PTT(0xDD, IP, IPV6, IG,   IPV6, SCTP, PAY4),
+	WX_UKN(0xDE),
+	WX_UKN(0xDF),
+
+	/* IPv6 --> GRE/NAT -> MAC -> NONE/IPv4/IPv6 */
+	WX_PTT(0xE0, IP, IPV6, IGM,  NONE, NONE, PAY3),
+	WX_PTT(0xE1, IP, IPV6, IGM,  FGV4, NONE, PAY3),
+	WX_PTT(0xE2, IP, IPV6, IGM,  IPV4, NONE, PAY3),
+	WX_PTT(0xE3, IP, IPV6, IGM,  IPV4, UDP,  PAY4),
+	WX_PTT(0xE4, IP, IPV6, IGM,  IPV4, TCP,  PAY4),
+	WX_PTT(0xE5, IP, IPV6, IGM,  IPV4, SCTP, PAY4),
+	WX_UKN(0xE6),
+	WX_UKN(0xE7),
+	WX_UKN(0xE8),
+	WX_PTT(0xE9, IP, IPV6, IGM,  FGV6, NONE, PAY3),
+	WX_PTT(0xEA, IP, IPV6, IGM,  IPV6, NONE, PAY3),
+	WX_PTT(0xEB, IP, IPV6, IGM,  IPV6, UDP,  PAY4),
+	WX_PTT(0xEC, IP, IPV6, IGM,  IPV6, TCP,  PAY4),
+	WX_PTT(0xED, IP, IPV6, IGM,  IPV6, SCTP, PAY4),
+	WX_UKN(0xEE),
+	WX_UKN(0xEF),
+
+	/* IPv6 --> GRE/NAT -> MAC--> NONE/IPv */
+	WX_PTT(0xF0, IP, IPV6, IGMV, NONE, NONE, PAY3),
+	WX_PTT(0xF1, IP, IPV6, IGMV, FGV4, NONE, PAY3),
+	WX_PTT(0xF2, IP, IPV6, IGMV, IPV4, NONE, PAY3),
+	WX_PTT(0xF3, IP, IPV6, IGMV, IPV4, UDP,  PAY4),
+	WX_PTT(0xF4, IP, IPV6, IGMV, IPV4, TCP,  PAY4),
+	WX_PTT(0xF5, IP, IPV6, IGMV, IPV4, SCTP, PAY4),
+	WX_UKN(0xF6),
+	WX_UKN(0xF7),
+	WX_UKN(0xF8),
+	WX_PTT(0xF9, IP, IPV6, IGMV, FGV6, NONE, PAY3),
+	WX_PTT(0xFA, IP, IPV6, IGMV, IPV6, NONE, PAY3),
+	WX_PTT(0xFB, IP, IPV6, IGMV, IPV6, UDP,  PAY4),
+	WX_PTT(0xFC, IP, IPV6, IGMV, IPV6, TCP,  PAY4),
+	WX_PTT(0xFD, IP, IPV6, IGMV, IPV6, SCTP, PAY4),
+	WX_UKN(0xFE),
+	WX_UKN(0xFF),
+};
+
+static inline wx_dptype wx_decode_ptype(const u8 ptype)
+{
+	return wx_ptype_lookup[ptype];
+}
+
 /* Host Interface Command Structures */
 struct wx_hic_hdr {
 	u8 cmd;
@@ -412,6 +984,8 @@ struct wx_mac_info {
 	u32 mta_shadow[128];
 	s32 mc_filter_type;
 	u32 mcft_size;
+	u32 vft_shadow[128];
+	u32 vft_size;
 	u32 num_rar_entries;
 	u32 rx_pb_size;
 	u32 tx_pb_size;
@@ -456,6 +1030,11 @@ enum wx_reset_type {
 
 struct wx_cb {
 	dma_addr_t dma;
+	__be32  tsecr;           /* timestamp echo response */
+	u32     tsval;           /* timestamp value in host order */
+	u32     next_seq;        /* next expected sequence number */
+	u16     free;            /* 65521 minus total size */
+	u16     mss;             /* size of data portion of packet */
 	u16     append_cnt;      /* number of skb's appended */
 	bool    page_released;
 	bool    dma_released;
@@ -508,10 +1087,46 @@ union wx_rx_desc {
 	} wb;  /* writeback */
 };
 
+struct wx_tx_context_desc {
+	__le32 vlan_macip_lens;
+	__le32 seqnum_seed;
+	__le32 type_tucmd_mlhl;
+	__le32 mss_l4len_idx;
+};
+
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
+#define WX_LRO_MAX		32      /*Maximum number of LRO descriptors*/
+
+struct wx_lro_stats {
+	u32 flushed;
+	u32 coal;
+};
+
+struct wx_lrohdr {
+	struct iphdr iph;
+	struct tcphdr th;
+	__be32 ts[0];
+};
+
+static inline struct wx_lrohdr *wx_lro_hdr(struct sk_buff *skb)
+{
+	return (struct wx_lrohdr *)skb->data;
+}
+
+struct wx_lro_list {
+	struct sk_buff_head active;
+	struct wx_lro_stats stats;
+};
 
 /* wrapper around a pointer to a socket buffer,
  * so a DMA handle can be stored along with the buffer
@@ -523,6 +1138,8 @@ struct wx_tx_buffer {
 	unsigned short gso_segs;
 	DEFINE_DMA_UNMAP_ADDR(dma);
 	DEFINE_DMA_UNMAP_LEN(len);
+	__be16 protocol;
+	u32 tx_flags;
 };
 
 struct wx_rx_buffer {
@@ -539,6 +1156,22 @@ struct wx_queue_stats {
 	u64 bytes;
 };
 
+struct wx_tx_queue_stats {
+	u64 restart_queue;
+	u64 tx_busy;
+	u64 tx_done_old;
+};
+
+struct wx_rx_queue_stats {
+	u64 rsc_count;
+	u64 rsc_flush;
+	u64 non_eop_descs;
+	u64 alloc_rx_page_failed;
+	u64 alloc_rx_buff_failed;
+	u64 csum_good_cnt;
+	u64 csum_err;
+};
+
 /* iterator for handling rings in ring container */
 #define wx_for_each_ring(posm, headm) \
 	for (posm = (headm).ring; posm; posm = posm->next)
@@ -551,11 +1184,20 @@ struct wx_ring_container {
 	u8 itr;                         /* current ITR setting for ring */
 };
 
+struct wx_fwd_adapter {
+	struct net_device *vdev;
+	struct wx *wx;
+	unsigned int tx_base_queue;
+	unsigned int rx_base_queue;
+	int index; /* pool index on PF */
+};
+
 struct wx_ring {
 	struct wx_ring *next;           /* pointer to next ring in q_vector */
 	struct wx_q_vector *q_vector;   /* backpointer to host q_vector */
 	struct net_device *netdev;      /* netdev ring belongs to */
 	struct device *dev;             /* device for DMA mapping */
+	struct wx_fwd_adapter *accel;
 	struct page_pool *page_pool;
 	void *desc;                     /* descriptor ring memory */
 	union {
@@ -580,6 +1222,10 @@ struct wx_ring {
 
 	struct wx_queue_stats stats;
 	struct u64_stats_sync syncp;
+	union {
+		struct wx_tx_queue_stats tx_stats;
+		struct wx_rx_queue_stats rx_stats;
+	};
 } ____cacheline_internodealigned_in_smp;
 
 struct wx_q_vector {
@@ -595,6 +1241,8 @@ struct wx_q_vector {
 	struct napi_struct napi;
 	struct rcu_head rcu;    /* to avoid race with update stats on free */
 
+	struct wx_lro_list lrolist;   /* LRO list for queue vector*/
+	bool netpoll_rx;
 	char name[IFNAMSIZ + 17];
 
 	/* for dynamic allocation of rings associated with this q_vector */
-- 
2.40.0

