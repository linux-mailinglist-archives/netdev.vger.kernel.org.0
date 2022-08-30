Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C76C5A5C76
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiH3HGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiH3HGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:06:15 -0400
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC73A4048
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:06:04 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843159trd0jdwg
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:58 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: uGhnJwy6xZJRVG3PWHbvlHN2jSzZKAk1KE4cuvkPHOIEQGuZrVXSrZOK+5o0X
        cb86MYSrL1eRsksjv/A2xAYwqTY9SpX01956YtzzlFz09Y5TZk0eQN3XkC2GsoNdGjLt6ay
        gN0wiU0sC0UTAcr2pRr4GgCZcK65QwTwKEeqmW9d64Vg3ekfbSIA481FBio/4M1tSavn7e3
        RtgcvOBZ2lXwIQ8GyrKwtBfHpDhstNDJ9O721rhF8vtolVQgSEtIMzvMXburp0OghxDkQo/
        KsrQi9/RioQQcMHF+F1HTz6Y0Eq5imzxZTfUlYetwRdpSobJ6aji8ShAXg4Zs1uU7lSv2xj
        7VvYGiqnwmj4wapTl675zh/6mQ8BFj4CkDsFz1HnRZ7xn3y+c4sMpnVZZugBAh27k74kLVF
        r+uuBY0oAQA=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 14/16] net: txgbe: Add transmit path to process packets
Date:   Tue, 30 Aug 2022 15:04:52 +0800
Message-Id: <20220830070454.146211-15-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the full transmit path, which supports TSO, checksum, etc.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  48 ++
 .../net/ethernet/wangxun/txgbe/txgbe_lib.c    |  19 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 816 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 115 +++
 4 files changed, 996 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 4248e5ef7940..ef5f86261a45 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -11,6 +11,9 @@
 
 #include "txgbe_type.h"
 
+/* Ether Types */
+#define TXGBE_ETH_P_CNM                 0x22E7
+
 /* TX/RX descriptor defines */
 #define TXGBE_DEFAULT_TXD               512
 #define TXGBE_DEFAULT_TX_WORK           256
@@ -49,6 +52,35 @@
 #define TXGBE_RX_DMA_ATTR \
 	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
+enum txgbe_tx_flags {
+	/* cmd_type flags */
+	TXGBE_TX_FLAGS_HW_VLAN  = 0x01,
+	TXGBE_TX_FLAGS_TSO      = 0x02,
+	TXGBE_TX_FLAGS_TSTAMP   = 0x04,
+
+	/* olinfo flags */
+	TXGBE_TX_FLAGS_CC       = 0x08,
+	TXGBE_TX_FLAGS_IPV4     = 0x10,
+	TXGBE_TX_FLAGS_CSUM     = 0x20,
+	TXGBE_TX_FLAGS_OUTER_IPV4 = 0x100,
+	TXGBE_TX_FLAGS_LINKSEC	= 0x200,
+	TXGBE_TX_FLAGS_IPSEC    = 0x400,
+
+	/* software defined flags */
+	TXGBE_TX_FLAGS_SW_VLAN  = 0x40,
+};
+
+/* VLAN info */
+#define TXGBE_TX_FLAGS_VLAN_MASK        0xffff0000
+#define TXGBE_TX_FLAGS_VLAN_PRIO_MASK   0xe0000000
+#define TXGBE_TX_FLAGS_VLAN_PRIO_SHIFT  29
+#define TXGBE_TX_FLAGS_VLAN_SHIFT       16
+
+#define TXGBE_MAX_TXD_PWR       14
+#define TXGBE_MAX_DATA_PER_TXD  BIT(TXGBE_MAX_TXD_PWR)
+
+/* Tx Descriptors needed, worst case */
+#define TXD_USE_COUNT(S)        DIV_ROUND_UP((S), TXGBE_MAX_DATA_PER_TXD)
 #ifndef MAX_SKB_FRAGS
 #define DESC_NEEDED     4
 #elif (MAX_SKB_FRAGS < 16)
@@ -64,8 +96,11 @@ struct txgbe_tx_buffer {
 	union txgbe_tx_desc *next_to_watch;
 	struct sk_buff *skb;
 	unsigned int bytecount;
+	unsigned short gso_segs;
+	__be16 protocol;
 	DEFINE_DMA_UNMAP_ADDR(dma);
 	DEFINE_DMA_UNMAP_LEN(len);
+	u32 tx_flags;
 };
 
 struct txgbe_rx_buffer {
@@ -83,6 +118,7 @@ struct txgbe_queue_stats {
 
 struct txgbe_tx_queue_stats {
 	u64 restart_queue;
+	u64 tx_busy;
 };
 
 struct txgbe_rx_queue_stats {
@@ -232,6 +268,8 @@ static inline u16 txgbe_desc_unused(struct txgbe_ring *ring)
 	(&(((union txgbe_rx_desc *)((R)->desc))[i]))
 #define TXGBE_TX_DESC(R, i)     \
 	(&(((union txgbe_tx_desc *)((R)->desc))[i]))
+#define TXGBE_TX_CTXTDESC(R, i) \
+	(&(((struct txgbe_tx_context_desc *)((R)->desc))[i]))
 
 #define TXGBE_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
 
@@ -283,6 +321,11 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG2_RSC_CAPABLE                 BIT(6)
 #define TXGBE_FLAG2_RSC_ENABLED                 BIT(7)
 
+#define TXGBE_SET_FLAG(_input, _flag, _result) \
+	((_flag <= _result) ? \
+	 ((u32)(_input & _flag) * (_result / _flag)) : \
+	 ((u32)(_input & _flag) / (_flag / _result)))
+
 enum txgbe_isb_idx {
 	TXGBE_ISB_HEADER,
 	TXGBE_ISB_MISC,
@@ -413,6 +456,9 @@ int txgbe_init_interrupt_scheme(struct txgbe_adapter *adapter);
 void txgbe_reset_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter);
+netdev_tx_t txgbe_xmit_frame_ring(struct sk_buff *skb,
+				  struct txgbe_adapter *adapter,
+				  struct txgbe_ring *tx_ring);
 void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
 				      struct txgbe_tx_buffer *tx_buffer);
 void txgbe_alloc_rx_buffers(struct txgbe_ring *rx_ring, u16 cleaned_count);
@@ -422,6 +468,8 @@ void txgbe_configure_port(struct txgbe_adapter *adapter);
 void txgbe_clear_vxlan_port(struct txgbe_adapter *adapter);
 void txgbe_set_rx_mode(struct net_device *netdev);
 int txgbe_write_mc_addr_list(struct net_device *netdev);
+void txgbe_tx_ctxtdesc(struct txgbe_ring *tx_ring, u32 vlan_macip_lens,
+		       u32 fcoe_sof_eof, u32 type_tucmd, u32 mss_l4len_idx);
 void txgbe_do_reset(struct net_device *netdev);
 void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
 int txgbe_poll(struct napi_struct *napi, int budget);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
index 2315d521b915..b6c3036e89ca 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
@@ -442,3 +442,22 @@ void txgbe_clear_interrupt_scheme(struct txgbe_adapter *adapter)
 	txgbe_free_q_vectors(adapter);
 	txgbe_reset_interrupt_capability(adapter);
 }
+
+void txgbe_tx_ctxtdesc(struct txgbe_ring *tx_ring, u32 vlan_macip_lens,
+		       u32 fcoe_sof_eof, u32 type_tucmd, u32 mss_l4len_idx)
+{
+	struct txgbe_tx_context_desc *context_desc;
+	u16 i = tx_ring->next_to_use;
+
+	context_desc = TXGBE_TX_CTXTDESC(tx_ring, i);
+
+	i++;
+	tx_ring->next_to_use = (i < tx_ring->count) ? i : 0;
+
+	/* set bits to identify this as an advanced context descriptor */
+	type_tucmd |= TXGBE_TXD_DTYP_CTXT;
+	context_desc->vlan_macip_lens   = cpu_to_le32(vlan_macip_lens);
+	context_desc->seqnum_seed       = cpu_to_le32(fcoe_sof_eof);
+	context_desc->type_tucmd_mlhl   = cpu_to_le32(type_tucmd);
+	context_desc->mss_l4len_idx     = cpu_to_le32(mss_l4len_idx);
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 888cb5b9b2dd..63c396f8a42d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -6,6 +6,7 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/string.h>
+#include <linux/sctp.h>
 #include <linux/aer.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
@@ -226,6 +227,7 @@ static bool txgbe_clean_tx_irq(struct txgbe_q_vector *q_vector,
 
 		/* update the statistics for this packet */
 		total_bytes += tx_buffer->bytecount;
+		total_packets += tx_buffer->gso_segs;
 
 		/* free the skb */
 		dev_consume_skb_any(tx_buffer->skb);
@@ -3703,10 +3705,818 @@ static void txgbe_service_task(struct work_struct *work)
 	txgbe_service_event_complete(adapter);
 }
 
+static u8 get_ipv6_proto(struct sk_buff *skb, int offset)
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
+
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
+static struct txgbe_dptype encode_tx_desc_ptype(const struct txgbe_tx_buffer *first)
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
+			if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET))
+				goto encap_frag;
+			ptype = TXGBE_PTYPE_TUN_IPV4;
+			break;
+		case htons(ETH_P_IPV6):
+			tun_prot = get_ipv6_proto(skb, skb_network_offset(skb));
+			if (tun_prot == NEXTHDR_FRAGMENT)
+				goto encap_frag;
+			ptype = TXGBE_PTYPE_TUN_IPV6;
+			break;
+		default:
+			goto exit;
+		}
+
+		if (tun_prot == IPPROTO_IPIP) {
+			hdr.raw = (void *)inner_ip_hdr(skb);
+			ptype |= TXGBE_PTYPE_PKT_IPIP;
+		} else if (tun_prot == IPPROTO_UDP) {
+			hdr.raw = (void *)inner_ip_hdr(skb);
+			if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
+			    skb->inner_protocol != htons(ETH_P_TEB)) {
+				ptype |= TXGBE_PTYPE_PKT_IG;
+			} else {
+				if (((struct ethhdr *)skb_inner_mac_header(skb))->h_proto ==
+				    htons(ETH_P_8021Q)) {
+					ptype |= TXGBE_PTYPE_PKT_IGMV;
+				} else {
+					ptype |= TXGBE_PTYPE_PKT_IGM;
+				}
+			}
+		} else if (tun_prot == IPPROTO_GRE) {
+			hdr.raw = (void *)inner_ip_hdr(skb);
+			if (skb->inner_protocol == htons(ETH_P_IP) ||
+			    skb->inner_protocol == htons(ETH_P_IPV6)) {
+				ptype |= TXGBE_PTYPE_PKT_IG;
+			} else {
+				if (((struct ethhdr *)skb_inner_mac_header(skb))->h_proto ==
+				    htons(ETH_P_8021Q)) {
+					ptype |= TXGBE_PTYPE_PKT_IGMV;
+				} else {
+					ptype |= TXGBE_PTYPE_PKT_IGM;
+				}
+			}
+		} else {
+			goto exit;
+		}
+
+		switch (hdr.ipv4->version) {
+		case IPVERSION:
+			l4_prot = hdr.ipv4->protocol;
+			if (hdr.ipv4->frag_off & htons(IP_MF | IP_OFFSET)) {
+				ptype |= TXGBE_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+		case 6:
+			l4_prot = get_ipv6_proto(skb,
+						 skb_inner_network_offset(skb));
+			ptype |= TXGBE_PTYPE_PKT_IPV6;
+			if (l4_prot == NEXTHDR_FRAGMENT) {
+				ptype |= TXGBE_PTYPE_TYP_IPFRAG;
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
+			ptype = TXGBE_PTYPE_PKT_IP;
+			if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)) {
+				ptype |= TXGBE_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+		case htons(ETH_P_IPV6):
+			l4_prot = get_ipv6_proto(skb, skb_network_offset(skb));
+			ptype = TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6;
+			if (l4_prot == NEXTHDR_FRAGMENT) {
+				ptype |= TXGBE_PTYPE_TYP_IPFRAG;
+				goto exit;
+			}
+			break;
+		case htons(ETH_P_1588):
+			ptype = TXGBE_PTYPE_L2_TS;
+			goto exit;
+		case htons(ETH_P_FIP):
+			ptype = TXGBE_PTYPE_L2_FIP;
+			goto exit;
+		case htons(ETH_P_LLDP):
+			ptype = TXGBE_PTYPE_L2_LLDP;
+			goto exit;
+		case htons(TXGBE_ETH_P_CNM):
+			ptype = TXGBE_PTYPE_L2_CNM;
+			goto exit;
+		case htons(ETH_P_PAE):
+			ptype = TXGBE_PTYPE_L2_EAPOL;
+			goto exit;
+		case htons(ETH_P_ARP):
+			ptype = TXGBE_PTYPE_L2_ARP;
+			goto exit;
+		default:
+			ptype = TXGBE_PTYPE_L2_MAC;
+			goto exit;
+		}
+	}
+
+	switch (l4_prot) {
+	case IPPROTO_TCP:
+		ptype |= TXGBE_PTYPE_TYP_TCP;
+		break;
+	case IPPROTO_UDP:
+		ptype |= TXGBE_PTYPE_TYP_UDP;
+		break;
+	case IPPROTO_SCTP:
+		ptype |= TXGBE_PTYPE_TYP_SCTP;
+		break;
+	default:
+		ptype |= TXGBE_PTYPE_TYP_IP;
+		break;
+	}
+
+exit:
+	return txgbe_decode_ptype(ptype);
+}
+
+static int txgbe_tso(struct txgbe_ring *tx_ring,
+		     struct txgbe_tx_buffer *first,
+		     u8 *hdr_len, struct txgbe_dptype dptype)
+{
+	struct sk_buff *skb = first->skb;
+	u32 vlan_macip_lens, type_tucmd;
+	bool enc = skb->encapsulation;
+	u32 tunhdr_eiplen_tunlen = 0;
+	u32 mss_l4len_idx, l4len;
+	struct ipv6hdr *ipv6h;
+	struct tcphdr *tcph;
+	struct iphdr *iph;
+	u8 tun_prot = 0;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return 0;
+
+	if (!skb_is_gso(skb))
+		return 0;
+
+	if (skb_header_cloned(skb)) {
+		int err = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
+
+		if (err)
+			return err;
+	}
+
+	iph = enc ? inner_ip_hdr(skb) : ip_hdr(skb);
+
+	if (iph->version == 4) {
+		tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
+		iph->tot_len = 0;
+		iph->check = 0;
+		tcph->check = ~csum_tcpudp_magic(iph->saddr,
+						 iph->daddr, 0,
+						 IPPROTO_TCP,
+						 0);
+		first->tx_flags |= TXGBE_TX_FLAGS_TSO |
+				   TXGBE_TX_FLAGS_CSUM |
+				   TXGBE_TX_FLAGS_IPV4 |
+				   TXGBE_TX_FLAGS_CC;
+	} else if (iph->version == 6 && skb_is_gso_v6(skb)) {
+		ipv6h = enc ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
+		tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
+		ipv6h->payload_len = 0;
+		tcph->check = ~csum_ipv6_magic(&ipv6h->saddr,
+					       &ipv6h->daddr,
+					       0, IPPROTO_TCP, 0);
+		first->tx_flags |= TXGBE_TX_FLAGS_TSO |
+				   TXGBE_TX_FLAGS_CSUM |
+				   TXGBE_TX_FLAGS_CC;
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
+	mss_l4len_idx = l4len << TXGBE_TXD_L4LEN_SHIFT;
+	mss_l4len_idx |= skb_shinfo(skb)->gso_size << TXGBE_TXD_MSS_SHIFT;
+
+	/* vlan_macip_lens: HEADLEN, MACLEN, VLAN tag */
+
+	if (enc) {
+		switch (first->protocol) {
+		case htons(ETH_P_IP):
+			tun_prot = ip_hdr(skb)->protocol;
+			first->tx_flags |= TXGBE_TX_FLAGS_OUTER_IPV4;
+			break;
+		case htons(ETH_P_IPV6):
+			tun_prot = ipv6_hdr(skb)->nexthdr;
+			break;
+		default:
+			break;
+		}
+		switch (tun_prot) {
+		case IPPROTO_UDP:
+			tunhdr_eiplen_tunlen = TXGBE_TXD_TUNNEL_UDP;
+			tunhdr_eiplen_tunlen |=
+					((skb_network_header_len(skb) >> 2) <<
+					 TXGBE_TXD_OUTER_IPLEN_SHIFT) |
+					(((skb_inner_mac_header(skb) -
+					   skb_transport_header(skb)) >> 1) <<
+					 TXGBE_TXD_TUNNEL_LEN_SHIFT);
+			break;
+		case IPPROTO_GRE:
+			tunhdr_eiplen_tunlen = TXGBE_TXD_TUNNEL_GRE;
+			tunhdr_eiplen_tunlen |=
+					((skb_network_header_len(skb) >> 2) <<
+					 TXGBE_TXD_OUTER_IPLEN_SHIFT) |
+					(((skb_inner_mac_header(skb) -
+					   skb_transport_header(skb)) >> 1) <<
+					 TXGBE_TXD_TUNNEL_LEN_SHIFT);
+			break;
+		case IPPROTO_IPIP:
+			tunhdr_eiplen_tunlen = (((char *)inner_ip_hdr(skb) -
+						 (char *)ip_hdr(skb)) >> 2) <<
+						TXGBE_TXD_OUTER_IPLEN_SHIFT;
+			break;
+		default:
+			break;
+		}
+
+		vlan_macip_lens = skb_inner_network_header_len(skb) >> 1;
+	} else {
+		vlan_macip_lens = skb_network_header_len(skb) >> 1;
+	}
+
+	vlan_macip_lens |= skb_network_offset(skb) << TXGBE_TXD_MACLEN_SHIFT;
+	vlan_macip_lens |= first->tx_flags & TXGBE_TX_FLAGS_VLAN_MASK;
+
+	type_tucmd = dptype.ptype << 24;
+	txgbe_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
+			  type_tucmd, mss_l4len_idx);
+
+	return 1;
+}
+
+static void txgbe_tx_csum(struct txgbe_ring *tx_ring,
+			  struct txgbe_tx_buffer *first,
+			  struct txgbe_dptype dptype)
+{
+	struct sk_buff *skb = first->skb;
+	u32 tunhdr_eiplen_tunlen = 0;
+	u32 vlan_macip_lens = 0;
+	u32 mss_l4len_idx = 0;
+	u8 tun_prot = 0;
+	u32 type_tucmd;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		if (!(first->tx_flags & TXGBE_TX_FLAGS_HW_VLAN) &&
+		    !(first->tx_flags & TXGBE_TX_FLAGS_CC))
+			return;
+		vlan_macip_lens = skb_network_offset(skb) <<
+				  TXGBE_TXD_MACLEN_SHIFT;
+	} else {
+		u8 l4_prot = 0;
+
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
+					  TXGBE_TXD_MACLEN_SHIFT;
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
+				tunhdr_eiplen_tunlen = TXGBE_TXD_TUNNEL_UDP;
+				tunhdr_eiplen_tunlen |=
+					((skb_network_header_len(skb) >> 2) <<
+					 TXGBE_TXD_OUTER_IPLEN_SHIFT) |
+					(((skb_inner_mac_header(skb) -
+					   skb_transport_header(skb)) >> 1) <<
+					 TXGBE_TXD_TUNNEL_LEN_SHIFT);
+				break;
+			case IPPROTO_GRE:
+				tunhdr_eiplen_tunlen = TXGBE_TXD_TUNNEL_GRE;
+				tunhdr_eiplen_tunlen |=
+					((skb_network_header_len(skb) >> 2) <<
+					 TXGBE_TXD_OUTER_IPLEN_SHIFT) |
+					(((skb_inner_mac_header(skb) -
+					   skb_transport_header(skb)) >> 1) <<
+					 TXGBE_TXD_TUNNEL_LEN_SHIFT);
+				break;
+			case IPPROTO_IPIP:
+				tunhdr_eiplen_tunlen =
+					(((char *)inner_ip_hdr(skb) -
+					  (char *)ip_hdr(skb)) >> 2) <<
+					TXGBE_TXD_OUTER_IPLEN_SHIFT;
+				break;
+			default:
+				break;
+			}
+
+		} else {
+			network_hdr.raw = skb_network_header(skb);
+			transport_hdr.raw = skb_transport_header(skb);
+			vlan_macip_lens = skb_network_offset(skb) <<
+					  TXGBE_TXD_MACLEN_SHIFT;
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
+			mss_l4len_idx = (transport_hdr.tcphdr->doff * 4) <<
+					TXGBE_TXD_L4LEN_SHIFT;
+			break;
+		case IPPROTO_SCTP:
+			mss_l4len_idx = sizeof(struct sctphdr) <<
+					TXGBE_TXD_L4LEN_SHIFT;
+			break;
+		case IPPROTO_UDP:
+			mss_l4len_idx = sizeof(struct udphdr) <<
+					TXGBE_TXD_L4LEN_SHIFT;
+			break;
+		default:
+			break;
+		}
+
+		/* update TX checksum flag */
+		first->tx_flags |= TXGBE_TX_FLAGS_CSUM;
+	}
+	first->tx_flags |= TXGBE_TX_FLAGS_CC;
+	/* vlan_macip_lens: MACLEN, VLAN tag */
+	vlan_macip_lens |= first->tx_flags & TXGBE_TX_FLAGS_VLAN_MASK;
+
+	type_tucmd = dptype.ptype << 24;
+	txgbe_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
+			  type_tucmd, mss_l4len_idx);
+}
+
+static u32 txgbe_tx_cmd_type(u32 tx_flags)
+{
+	/* set type for advanced descriptor with frame checksum insertion */
+	u32 cmd_type = TXGBE_TXD_DTYP_DATA |
+		       TXGBE_TXD_IFCS;
+
+	/* set HW vlan bit if vlan is present */
+	cmd_type |= TXGBE_SET_FLAG(tx_flags, TXGBE_TX_FLAGS_HW_VLAN,
+				   TXGBE_TXD_VLE);
+
+	/* set segmentation enable bits for TSO/FSO */
+	cmd_type |= TXGBE_SET_FLAG(tx_flags, TXGBE_TX_FLAGS_TSO,
+				   TXGBE_TXD_TSE);
+
+	cmd_type |= TXGBE_SET_FLAG(tx_flags, TXGBE_TX_FLAGS_LINKSEC,
+				   TXGBE_TXD_LINKSEC);
+
+	return cmd_type;
+}
+
+static void txgbe_tx_olinfo_status(union txgbe_tx_desc *tx_desc,
+				   u32 tx_flags, unsigned int paylen)
+{
+	u32 olinfo_status = paylen << TXGBE_TXD_PAYLEN_SHIFT;
+
+	/* enable L4 checksum for TSO and TX checksum offload */
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_CSUM,
+					TXGBE_TXD_L4CS);
+
+	/* enable IPv4 checksum for TSO */
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_IPV4,
+					TXGBE_TXD_IIPCS);
+	/* enable outer IPv4 checksum for TSO */
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_OUTER_IPV4,
+					TXGBE_TXD_EIPCS);
+	/* Check Context must be set if Tx switch is enabled, which it
+	 * always is for case where virtual functions are running
+	 */
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_CC,
+					TXGBE_TXD_CC);
+
+	olinfo_status |= TXGBE_SET_FLAG(tx_flags,
+					TXGBE_TX_FLAGS_IPSEC,
+					TXGBE_TXD_IPSEC);
+
+	tx_desc->read.olinfo_status = cpu_to_le32(olinfo_status);
+}
+
+static int __txgbe_maybe_stop_tx(struct txgbe_ring *tx_ring, u16 size)
+{
+	netif_stop_subqueue(tx_ring->netdev, tx_ring->queue_index);
+
+	/* For the next check */
+	smp_mb();
+
+	/* We need to check again in a case another CPU has just
+	 * made room available.
+	 */
+	if (likely(txgbe_desc_unused(tx_ring) < size))
+		return -EBUSY;
+
+	/* A reprieve! - use start_queue because it doesn't call schedule */
+	netif_start_subqueue(tx_ring->netdev, tx_ring->queue_index);
+	++tx_ring->tx_stats.restart_queue;
+	return 0;
+}
+
+static int txgbe_maybe_stop_tx(struct txgbe_ring *tx_ring, u16 size)
+{
+	if (likely(txgbe_desc_unused(tx_ring) >= size))
+		return 0;
+
+	return __txgbe_maybe_stop_tx(tx_ring, size);
+}
+
+#define TXGBE_TXD_CMD (TXGBE_TXD_EOP | \
+		       TXGBE_TXD_RS)
+
+static int txgbe_tx_map(struct txgbe_ring *tx_ring,
+			struct txgbe_tx_buffer *first,
+			const u8 hdr_len)
+{
+	struct txgbe_tx_buffer *tx_buffer;
+	struct sk_buff *skb = first->skb;
+	u32 tx_flags = first->tx_flags;
+	union txgbe_tx_desc *tx_desc;
+	u16 i = tx_ring->next_to_use;
+	unsigned int data_len, size;
+	skb_frag_t *frag;
+	dma_addr_t dma;
+	u32 cmd_type;
+
+	cmd_type = txgbe_tx_cmd_type(tx_flags);
+	tx_desc = TXGBE_TX_DESC(tx_ring, i);
+
+	txgbe_tx_olinfo_status(tx_desc, tx_flags, skb->len - hdr_len);
+
+	size = skb_headlen(skb);
+	data_len = skb->data_len;
+
+	dma = dma_map_single(tx_ring->dev, skb->data, size, DMA_TO_DEVICE);
+
+	tx_buffer = first;
+
+	for (frag = &skb_shinfo(skb)->frags[0];; frag++) {
+		if (dma_mapping_error(tx_ring->dev, dma))
+			goto dma_error;
+
+		/* record length, and DMA address */
+		dma_unmap_len_set(tx_buffer, len, size);
+		dma_unmap_addr_set(tx_buffer, dma, dma);
+
+		tx_desc->read.buffer_addr = cpu_to_le64(dma);
+
+		while (unlikely(size > TXGBE_MAX_DATA_PER_TXD)) {
+			tx_desc->read.cmd_type_len =
+				cpu_to_le32(cmd_type ^ TXGBE_MAX_DATA_PER_TXD);
+
+			i++;
+			tx_desc++;
+			if (i == tx_ring->count) {
+				tx_desc = TXGBE_TX_DESC(tx_ring, 0);
+				i = 0;
+			}
+			tx_desc->read.olinfo_status = 0;
+
+			dma += TXGBE_MAX_DATA_PER_TXD;
+			size -= TXGBE_MAX_DATA_PER_TXD;
+
+			tx_desc->read.buffer_addr = cpu_to_le64(dma);
+		}
+
+		if (likely(!data_len))
+			break;
+
+		tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type ^ size);
+
+		i++;
+		tx_desc++;
+		if (i == tx_ring->count) {
+			tx_desc = TXGBE_TX_DESC(tx_ring, 0);
+			i = 0;
+		}
+		tx_desc->read.olinfo_status = 0;
+
+		size = skb_frag_size(frag);
+
+		data_len -= size;
+
+		dma = skb_frag_dma_map(tx_ring->dev, frag, 0, size,
+				       DMA_TO_DEVICE);
+
+		tx_buffer = &tx_ring->tx_buffer_info[i];
+	}
+
+	/* write last descriptor with RS and EOP bits */
+	cmd_type |= size | TXGBE_TXD_CMD;
+	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+
+	netdev_tx_sent_queue(txring_txq(tx_ring), first->bytecount);
+
+	/* Force memory writes to complete before letting h/w know there
+	 * are new descriptors to fetch.  (Only applicable for weak-ordered
+	 * memory model archs, such as IA-64).
+	 *
+	 * We also need this memory barrier to make certain all of the
+	 * status bits have been updated before next_to_watch is written.
+	 */
+	wmb();
+
+	/* set next_to_watch value indicating a packet is present */
+	first->next_to_watch = tx_desc;
+
+	i++;
+	if (i == tx_ring->count)
+		i = 0;
+
+	tx_ring->next_to_use = i;
+
+	txgbe_maybe_stop_tx(tx_ring, DESC_NEEDED);
+
+	if (netif_xmit_stopped(txring_txq(tx_ring)) || !netdev_xmit_more())
+		writel(i, tx_ring->tail);
+
+	return 0;
+dma_error:
+	dev_err(tx_ring->dev, "TX DMA map failed\n");
+
+	/* clear dma mappings for failed tx_buffer_info map */
+	for (;;) {
+		tx_buffer = &tx_ring->tx_buffer_info[i];
+		if (dma_unmap_len(tx_buffer, len))
+			dma_unmap_page(tx_ring->dev,
+				       dma_unmap_addr(tx_buffer, dma),
+				       dma_unmap_len(tx_buffer, len),
+				       DMA_TO_DEVICE);
+		dma_unmap_len_set(tx_buffer, len, 0);
+		if (tx_buffer == first)
+			break;
+		if (i == 0)
+			i += tx_ring->count;
+		i--;
+	}
+
+	dev_kfree_skb_any(first->skb);
+	first->skb = NULL;
+
+	tx_ring->next_to_use = i;
+
+	return -EPERM;
+}
+
+/**
+ * txgbe_skb_pad_nonzero - zero pad the tail of an skb
+ * @skb: buffer to pad
+ * @pad: space to pad
+ *
+ * Ensure that a buffer is followed by a padding area that is zero
+ * filled. Used by network drivers which may DMA or transfer data
+ * beyond the buffer end onto the wire.
+ *
+ * May return error in out of memory cases. The skb is freed on error.
+ */
+static int txgbe_skb_pad_nonzero(struct sk_buff *skb, int pad)
+{
+	int err, ntail;
+
+	/* If the skbuff is non linear tailroom is always zero. */
+	if (!skb_cloned(skb) && skb_tailroom(skb) >= pad) {
+		memset(skb->data + skb->len, 0x1, pad);
+		return 0;
+	}
+
+	ntail = skb->data_len + pad - (skb->end - skb->tail);
+	if (likely(skb_cloned(skb) || ntail > 0)) {
+		err = pskb_expand_head(skb, 0, ntail, GFP_ATOMIC);
+		if (unlikely(err))
+			goto free_skb;
+	}
+
+	/* The use of this function with non-linear skb's really needs
+	 * to be audited.
+	 */
+	err = skb_linearize(skb);
+	if (unlikely(err))
+		goto free_skb;
+
+	memset(skb->data + skb->len, 0x1, pad);
+	return 0;
+
+free_skb:
+	kfree_skb(skb);
+	return err;
+}
+
+netdev_tx_t txgbe_xmit_frame_ring(struct sk_buff *skb,
+				  struct txgbe_adapter __maybe_unused *adapter,
+				  struct txgbe_ring *tx_ring)
+{
+	u16 count = TXD_USE_COUNT(skb_headlen(skb));
+	__be16 protocol = skb->protocol;
+	struct txgbe_tx_buffer *first;
+	struct txgbe_dptype dptype;
+	u8 vlan_addlen = 0;
+	u32 tx_flags = 0;
+	unsigned short f;
+	u8 hdr_len = 0;
+	int tso;
+
+	/* work around hw errata 3 */
+	u16 _llclen, *llclen;
+
+	llclen = skb_header_pointer(skb, ETH_HLEN - 2, sizeof(u16), &_llclen);
+	if (*llclen == 0x3 || *llclen == 0x4 || *llclen == 0x5) {
+		if (txgbe_skb_pad_nonzero(skb, ETH_ZLEN - skb->len))
+			return -ENOMEM;
+		__skb_put(skb, ETH_ZLEN - skb->len);
+	}
+
+	/* need: 1 descriptor per page * PAGE_SIZE/TXGBE_MAX_DATA_PER_TXD,
+	 *       + 1 desc for skb_headlen/TXGBE_MAX_DATA_PER_TXD,
+	 *       + 2 desc gap to keep tail from touching head,
+	 *       + 1 desc for context descriptor,
+	 * otherwise try next time
+	 */
+	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
+		count += TXD_USE_COUNT(skb_frag_size(&skb_shinfo(skb)->
+						     frags[f]));
+
+	if (txgbe_maybe_stop_tx(tx_ring, count + 3)) {
+		tx_ring->tx_stats.tx_busy++;
+		return NETDEV_TX_BUSY;
+	}
+
+	/* record the location of the first descriptor for this packet */
+	first = &tx_ring->tx_buffer_info[tx_ring->next_to_use];
+	first->skb = skb;
+	first->bytecount = skb->len;
+	first->gso_segs = 1;
+
+	/* if we have a HW VLAN tag being added default to the HW one */
+	if (skb_vlan_tag_present(skb)) {
+		tx_flags |= skb_vlan_tag_get(skb) << TXGBE_TX_FLAGS_VLAN_SHIFT;
+		tx_flags |= TXGBE_TX_FLAGS_HW_VLAN;
+	/* else if it is a SW VLAN check the next protocol and store the tag */
+	} else if (protocol == htons(ETH_P_8021Q)) {
+		struct vlan_hdr *vhdr, _vhdr;
+
+		vhdr = skb_header_pointer(skb, ETH_HLEN, sizeof(_vhdr), &_vhdr);
+		if (!vhdr)
+			goto out_drop;
+
+		protocol = vhdr->h_vlan_encapsulated_proto;
+		tx_flags |= ntohs(vhdr->h_vlan_TCI) <<
+				  TXGBE_TX_FLAGS_VLAN_SHIFT;
+		tx_flags |= TXGBE_TX_FLAGS_SW_VLAN;
+	}
+
+	if (protocol == htons(ETH_P_8021Q) || protocol == htons(ETH_P_8021AD)) {
+		struct vlan_hdr *vhdr, _vhdr;
+
+		vhdr = skb_header_pointer(skb, ETH_HLEN, sizeof(_vhdr), &_vhdr);
+		if (!vhdr)
+			goto out_drop;
+
+		protocol = vhdr->h_vlan_encapsulated_proto;
+		tx_flags |= TXGBE_TX_FLAGS_SW_VLAN;
+		vlan_addlen += VLAN_HLEN;
+	}
+
+	/* record initial flags and protocol */
+	first->tx_flags = tx_flags;
+	first->protocol = protocol;
+
+	dptype = encode_tx_desc_ptype(first);
+
+	tso = txgbe_tso(tx_ring, first, &hdr_len, dptype);
+	if (tso < 0)
+		goto out_drop;
+	else if (!tso)
+		txgbe_tx_csum(tx_ring, first, dptype);
+
+	txgbe_tx_map(tx_ring, first, hdr_len);
+
+	return NETDEV_TX_OK;
+
+out_drop:
+	dev_kfree_skb_any(first->skb);
+	first->skb = NULL;
+
+	return NETDEV_TX_OK;
+}
+
 static netdev_tx_t txgbe_xmit_frame(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
-	return NETDEV_TX_OK;
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	unsigned int r_idx = skb->queue_mapping;
+	struct txgbe_ring *tx_ring;
+
+	if (!netif_carrier_ok(netdev)) {
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
+	/* The minimum packet size for olinfo paylen is 17 so pad the skb
+	 * in order to meet this minimum size requirement.
+	 */
+	if (skb_put_padto(skb, 17))
+		return NETDEV_TX_OK;
+
+	if (r_idx >= adapter->num_tx_queues)
+		r_idx = r_idx % adapter->num_tx_queues;
+	tx_ring = adapter->tx_ring[r_idx];
+
+	return txgbe_xmit_frame_ring(skb, adapter, tx_ring);
 }
 
 /**
@@ -4023,6 +4833,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	netdev->features = NETIF_F_SG |
 			   NETIF_F_LRO |
+			   NETIF_F_TSO |
+			   NETIF_F_TSO6 |
 			   NETIF_F_RXCSUM |
 			   NETIF_F_HW_CSUM |
 			   NETIF_F_SCTP_CRC;
@@ -4042,7 +4854,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
 	netdev->hw_enc_features |= netdev->vlan_features;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index ed0454758174..5a2b0183d94b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -960,8 +960,77 @@ enum {
 #define TXGBE_RXD_SPLITHEADER_EN        0x00001000U
 #define TXGBE_RXD_SPH                   0x8000
 
+/**
+ * receive packet type
+ * PTYPE:8 = TUN:2 + PKT:2 + TYP:4
+ **/
+/* TUN */
+#define TXGBE_PTYPE_TUN_IPV4            (0x80)
+#define TXGBE_PTYPE_TUN_IPV6            (0xC0)
+
+/* PKT for TUN */
+#define TXGBE_PTYPE_PKT_IPIP            (0x00) /* IP+IP */
+#define TXGBE_PTYPE_PKT_IG              (0x10) /* IP+GRE */
+#define TXGBE_PTYPE_PKT_IGM             (0x20) /* IP+GRE+MAC */
+#define TXGBE_PTYPE_PKT_IGMV            (0x30) /* IP+GRE+MAC+VLAN */
+/* PKT for !TUN */
+#define TXGBE_PTYPE_PKT_MAC             (0x10)
+#define TXGBE_PTYPE_PKT_IP              (0x20)
+
+/* TYP for PKT=mac */
+#define TXGBE_PTYPE_TYP_MAC             (0x01)
+#define TXGBE_PTYPE_TYP_TS              (0x02) /* time sync */
+#define TXGBE_PTYPE_TYP_FIP             (0x03)
+#define TXGBE_PTYPE_TYP_LLDP            (0x04)
+#define TXGBE_PTYPE_TYP_CNM             (0x05)
+#define TXGBE_PTYPE_TYP_EAPOL           (0x06)
+#define TXGBE_PTYPE_TYP_ARP             (0x07)
+/* TYP for PKT=ip */
+#define TXGBE_PTYPE_PKT_IPV6            (0x08)
+#define TXGBE_PTYPE_TYP_IPFRAG          (0x01)
+#define TXGBE_PTYPE_TYP_IP              (0x02)
+#define TXGBE_PTYPE_TYP_UDP             (0x03)
+#define TXGBE_PTYPE_TYP_TCP             (0x04)
+#define TXGBE_PTYPE_TYP_SCTP            (0x05)
+
+/* Packet type non-ip values */
+enum txgbe_l2_ptypes {
+	TXGBE_PTYPE_L2_ABORTED = (TXGBE_PTYPE_PKT_MAC),
+	TXGBE_PTYPE_L2_MAC = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_MAC),
+	TXGBE_PTYPE_L2_TS = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_TS),
+	TXGBE_PTYPE_L2_FIP = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_FIP),
+	TXGBE_PTYPE_L2_LLDP = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_LLDP),
+	TXGBE_PTYPE_L2_CNM = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_CNM),
+	TXGBE_PTYPE_L2_EAPOL = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_EAPOL),
+	TXGBE_PTYPE_L2_ARP = (TXGBE_PTYPE_PKT_MAC | TXGBE_PTYPE_TYP_ARP),
+
+	TXGBE_PTYPE_L2_IPV4_FRAG = (TXGBE_PTYPE_PKT_IP |
+				    TXGBE_PTYPE_TYP_IPFRAG),
+	TXGBE_PTYPE_L2_IPV4 = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_TYP_IP),
+	TXGBE_PTYPE_L2_IPV4_UDP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_TYP_UDP),
+	TXGBE_PTYPE_L2_IPV4_TCP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_TYP_TCP),
+	TXGBE_PTYPE_L2_IPV4_SCTP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_TYP_SCTP),
+	TXGBE_PTYPE_L2_IPV6_FRAG = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+				    TXGBE_PTYPE_TYP_IPFRAG),
+	TXGBE_PTYPE_L2_IPV6 = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+			       TXGBE_PTYPE_TYP_IP),
+	TXGBE_PTYPE_L2_IPV6_UDP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+				   TXGBE_PTYPE_TYP_UDP),
+	TXGBE_PTYPE_L2_IPV6_TCP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+				   TXGBE_PTYPE_TYP_TCP),
+	TXGBE_PTYPE_L2_IPV6_SCTP = (TXGBE_PTYPE_PKT_IP | TXGBE_PTYPE_PKT_IPV6 |
+				    TXGBE_PTYPE_TYP_SCTP),
+
+	TXGBE_PTYPE_L2_TUN4_MAC = (TXGBE_PTYPE_TUN_IPV4 | TXGBE_PTYPE_PKT_IGM),
+	TXGBE_PTYPE_L2_TUN6_MAC = (TXGBE_PTYPE_TUN_IPV6 | TXGBE_PTYPE_PKT_IGM),
+};
+
 #define TXGBE_RXD_PKTTYPE(_rxd) \
 	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 9) & 0xFF)
+#define TXGBE_PTYPE_TUN(_pt) ((_pt) & 0xC0)
+#define TXGBE_PTYPE_PKT(_pt) ((_pt) & 0x30)
+#define TXGBE_PTYPE_TYP(_pt) ((_pt) & 0x0F)
+#define TXGBE_PTYPE_TYPL4(_pt) ((_pt) & 0x07)
 
 #define TXGBE_RXD_IPV6EX(_rxd) \
 	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 6) & 0x1)
@@ -970,7 +1039,45 @@ enum {
 #define TXGBE_RXD_ERR_FRAME_ERR_MASK    TXGBE_RXD_ERR_RXE
 
 /*********************** Transmit Descriptor Config Masks ****************/
+#define TXGBE_TXD_DTALEN_MASK           0x0000FFFFU /* Data buf length(bytes) */
+#define TXGBE_TXD_MAC_LINKSEC           0x00040000U /* Insert LinkSec */
+#define TXGBE_TXD_MAC_TSTAMP            0x00080000U /* IEEE1588 time stamp */
+#define TXGBE_TXD_IPSEC_SA_INDEX_MASK   0x000003FFU /* IPSec SA index */
+#define TXGBE_TXD_IPSEC_ESP_LEN_MASK    0x000001FFU /* IPSec ESP length */
+#define TXGBE_TXD_DTYP_MASK             0x00F00000U /* DTYP mask */
+#define TXGBE_TXD_DTYP_CTXT             0x00100000U /* Adv Context Desc */
+#define TXGBE_TXD_DTYP_DATA             0x00000000U /* Adv Data Descriptor */
+#define TXGBE_TXD_EOP                   0x01000000U  /* End of Packet */
+#define TXGBE_TXD_IFCS                  0x02000000U /* Insert FCS */
+#define TXGBE_TXD_LINKSEC               0x04000000U /* Enable linksec */
+#define TXGBE_TXD_RS                    0x08000000U /* Report Status */
+#define TXGBE_TXD_ECU                   0x10000000U /* DDP hdr type or iSCSI */
+#define TXGBE_TXD_QCN                   0x20000000U /* cntag insertion enable */
+#define TXGBE_TXD_VLE                   0x40000000U /* VLAN pkt enable */
+#define TXGBE_TXD_TSE                   0x80000000U /* TCP Seg enable */
 #define TXGBE_TXD_STAT_DD               0x00000001U /* Descriptor Done */
+#define TXGBE_TXD_IDX_SHIFT             4 /* Desc Index shift */
+#define TXGBE_TXD_CC                    0x00000080U /* Check Context */
+#define TXGBE_TXD_IPSEC                 0x00000100U /* Enable ipsec esp */
+#define TXGBE_TXD_IIPCS                 0x00000400U
+#define TXGBE_TXD_EIPCS                 0x00000800U
+#define TXGBE_TXD_L4CS                  0x00000200U
+#define TXGBE_TXD_PAYLEN_SHIFT          13 /* Desc PAYLEN shift */
+#define TXGBE_TXD_MACLEN_SHIFT          9  /* ctxt desc mac len shift */
+#define TXGBE_TXD_VLAN_SHIFT            16 /* ctxt vlan tag shift */
+#define TXGBE_TXD_TAG_TPID_SEL_SHIFT    11
+#define TXGBE_TXD_IPSEC_TYPE_SHIFT      14
+#define TXGBE_TXD_ENC_SHIFT             15
+
+#define TXGBE_TXD_L4LEN_SHIFT           8  /* ctxt L4LEN shift */
+#define TXGBE_TXD_MSS_SHIFT             16  /* ctxt MSS shift */
+
+#define TXGBE_TXD_OUTER_IPLEN_SHIFT     12 /* ctxt OUTERIPLEN shift */
+#define TXGBE_TXD_TUNNEL_LEN_SHIFT      21 /* ctxt TUNNELLEN shift */
+#define TXGBE_TXD_TUNNEL_TYPE_SHIFT     11 /* Tx Desc Tunnel Type shift */
+#define TXGBE_TXD_TUNNEL_DECTTL_SHIFT   27 /* ctxt DECTTL shift */
+#define TXGBE_TXD_TUNNEL_UDP            (0x0ULL << TXGBE_TXD_TUNNEL_TYPE_SHIFT)
+#define TXGBE_TXD_TUNNEL_GRE            (0x1ULL << TXGBE_TXD_TUNNEL_TYPE_SHIFT)
 
 /* Transmit Descriptor */
 union txgbe_tx_desc {
@@ -1017,6 +1124,14 @@ union txgbe_rx_desc {
 	} wb;  /* writeback */
 };
 
+/* Context descriptors */
+struct txgbe_tx_context_desc {
+	__le32 vlan_macip_lens;
+	__le32 seqnum_seed;
+	__le32 type_tucmd_mlhl;
+	__le32 mss_l4len_idx;
+};
+
 /****************** Manageablility Host Interface defines ********************/
 #define TXGBE_HI_MAX_BLOCK_BYTE_LENGTH  256 /* Num of bytes in range */
 #define TXGBE_HI_MAX_BLOCK_DWORD_LENGTH 64 /* Num of dwords in range */
-- 
2.27.0

