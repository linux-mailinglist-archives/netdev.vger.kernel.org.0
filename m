Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18ED56E4674
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjDQLaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjDQL36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:29:58 -0400
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E9B5261
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:29:02 -0700 (PDT)
X-QQ-mid: bizesmtp75t1681728919tsnnhjoz
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 17 Apr 2023 18:55:16 +0800 (CST)
X-QQ-SSF: 01400000000000N0R000000A0000000
X-QQ-FEAT: 3M0okmaRx3ipzhdgcpxp7GaQsWDBZlOosticIx2yU6u7Modr8p3YugSMHCSBn
        Oe17Y7cSvATcGaBiaCrMVfwbBGfXGosenYl/v1BcXHqQaK8MqWuKpBvGVS6L221W0dAxzvs
        4Z2vyPLHxIGrN/thlVlODOBdiLnoqC0w3ATUCFL3Yi+Sd6oxdmWRrRkGWaVM5h6PSPLZllC
        vcU7VEMzXOk07ceD4dD9uElfPUQ53z3rUCzLWbFPOcbd0VzgpFbWUpw+r2SvV9S1xEDYi6z
        4/FSS3QxnG7lUFA3D3CTZ6Xm+AxuV+bt7QEjhp2JAe2+KRVwfu0wrEzd+JhrATuJDuFbKt7
        zGFVH/W2Yw9wYUga4k5ciBoX/kepJeu1Q8yaDIlWtQokppudk6ntVVgpX6tQCgRdQybBV0Q
        KMDESgwsUr2xhVMQwQS6ew==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 496788117701865535
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2 2/5] net: wangxun: libwx add rx offload functions
Date:   Mon, 17 Apr 2023 18:54:54 +0800
Message-Id: <20230417105457.82127-3-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230417105457.82127-1-mengyuanlou@net-swift.com>
References: <20230417105457.82127-1-mengyuanlou@net-swift.com>
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

Add rx offload functions for wx_clean_rx_irq
which supports ngbe and txgbe to implement
rx offload function.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  |  99 ++++++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h | 263 +++++++++++++++++++
 2 files changed, 360 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 8cef1f53ffb2..3f1e905df542 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -424,6 +424,101 @@ static bool wx_cleanup_headers(struct wx_ring *rx_ring,
 	return false;
 }
 
+static inline void wx_rx_hash(struct wx_ring *ring,
+			      union wx_rx_desc *rx_desc,
+			      struct sk_buff *skb)
+{
+	u16 rss_type;
+
+	if (!(ring->netdev->features & NETIF_F_RXHASH))
+		return;
+
+	rss_type = le16_to_cpu(rx_desc->wb.lower.lo_dword.hs_rss.pkt_info) &
+			       WX_RXD_RSSTYPE_MASK;
+
+	if (!rss_type)
+		return;
+
+	skb_set_hash(skb, le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
+		     (WX_RSS_L4_TYPES_MASK & (1ul << rss_type)) ?
+		     PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3);
+}
+
+/**
+ * wx_rx_checksum - indicate in skb if hw indicated a good cksum
+ * @ring: structure containing ring specific data
+ * @rx_desc: current Rx descriptor being processed
+ * @skb: skb currently being received and modified
+ **/
+static inline void wx_rx_checksum(struct wx_ring *ring,
+				  union wx_rx_desc *rx_desc,
+				  struct sk_buff *skb)
+{
+	wx_dptype dptype = wx_decode_ptype(WX_RXD_PKTTYPE(rx_desc));
+
+	skb->ip_summed = CHECKSUM_NONE;
+	skb_checksum_none_assert(skb);
+	/* Rx csum disabled */
+	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+		return;
+
+	/* if IPv4 header checksum error */
+	if ((wx_test_staterr(rx_desc, WX_RXD_STAT_IPCS) &&
+	     wx_test_staterr(rx_desc, WX_RXD_ERR_IPE)) ||
+	    (wx_test_staterr(rx_desc, WX_RXD_STAT_OUTERIPCS) &&
+	     wx_test_staterr(rx_desc, WX_RXD_ERR_OUTERIPER))) {
+		ring->rx_stats.csum_err++;
+		return;
+	}
+
+	/* L4 checksum offload flag must set for the below code to work */
+	if (!wx_test_staterr(rx_desc, WX_RXD_STAT_L4CS))
+		return;
+
+	/*likely incorrect csum if IPv6 Dest Header found */
+	if (dptype.prot != WX_DEC_PTYPE_PROT_SCTP && WX_RXD_IPV6EX(rx_desc))
+		return;
+
+	/* if L4 checksum error */
+	if (wx_test_staterr(rx_desc, WX_RXD_ERR_TCPE)) {
+		ring->rx_stats.csum_err++;
+		return;
+	}
+
+	/* If there is an outer header present that might contain a checksum
+	 * we need to bump the checksum level by 1 to reflect the fact that
+	 * we are indicating we validated the inner checksum.
+	 */
+	if (dptype.etype >= WX_DEC_PTYPE_ETYPE_IG) {
+		skb->csum_level = 1;
+		skb->encapsulation = 1;
+	}
+
+	/* It must be a TCP or UDP or SCTP packet with a valid checksum */
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	ring->rx_stats.csum_good_cnt++;
+}
+
+/**
+ * wx_process_skb_fields - Populate skb header fields from Rx descriptor
+ * @rx_ring: rx descriptor ring packet is being transacted on
+ * @rx_desc: pointer to the EOP Rx descriptor
+ * @skb: pointer to current skb being populated
+ *
+ * This function checks the ring, descriptor, and packet information in
+ * order to populate the hash, checksum, VLAN, timestamp, protocol, and
+ * other fields within the skb.
+ **/
+static void wx_process_skb_fields(struct wx_ring *rx_ring,
+				  union wx_rx_desc *rx_desc,
+				  struct sk_buff *skb)
+{
+	wx_rx_hash(rx_ring, rx_desc, skb);
+	wx_rx_checksum(rx_ring, rx_desc, skb);
+	skb_record_rx_queue(skb, rx_ring->queue_index);
+	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
+}
+
 /**
  * wx_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @q_vector: structure containing interrupt and ring information
@@ -491,8 +586,8 @@ static int wx_clean_rx_irq(struct wx_q_vector *q_vector,
 		/* probably a little skewed due to removing CRC */
 		total_rx_bytes += skb->len;
 
-		skb_record_rx_queue(skb, rx_ring->queue_index);
-		skb->protocol = eth_type_trans(skb, rx_ring->netdev);
+		/* populate checksum, timestamp, VLAN, and protocol */
+		wx_process_skb_fields(rx_ring, rx_desc, skb);
 		napi_gro_receive(&q_vector->napi, skb);
 
 		/* update budget accounting */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 4981fc84a918..a1158466695a 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -322,8 +322,34 @@
 /******************* Receive Descriptor bit definitions **********************/
 #define WX_RXD_STAT_DD               BIT(0) /* Done */
 #define WX_RXD_STAT_EOP              BIT(1) /* End of Packet */
+#define WX_RXD_STAT_VP               BIT(5) /* IEEE VLAN Pkt */
+#define WX_RXD_STAT_L4CS             BIT(7) /* L4 xsum calculated */
+#define WX_RXD_STAT_IPCS             BIT(8) /* IP xsum calculated */
+#define WX_RXD_STAT_OUTERIPCS        BIT(10) /* Cloud IP xsum calculated*/
 
+#define WX_RXD_ERR_OUTERIPER         BIT(26) /* CRC IP Header error */
 #define WX_RXD_ERR_RXE               BIT(29) /* Any MAC Error */
+#define WX_RXD_ERR_TCPE              BIT(30) /* TCP/UDP Checksum Error */
+#define WX_RXD_ERR_IPE               BIT(31) /* IP Checksum Error */
+
+/* RSS Hash results */
+#define WX_RXD_RSSTYPE_MASK          GENMASK(3, 0)
+#define WX_RXD_RSSTYPE_IPV4_TCP      0x00000001U
+#define WX_RXD_RSSTYPE_IPV4          0x00000002U
+#define WX_RXD_RSSTYPE_IPV6_TCP      0x00000003U
+#define WX_RXD_RSSTYPE_IPV4_SCTP     0x00000004U
+#define WX_RXD_RSSTYPE_IPV6          0x00000005U
+#define WX_RXD_RSSTYPE_IPV6_SCTP     0x00000006U
+#define WX_RXD_RSSTYPE_IPV4_UDP      0x00000007U
+#define WX_RXD_RSSTYPE_IPV6_UDP      0x00000008U
+
+#define WX_RSS_L4_TYPES_MASK \
+	((1ul << WX_RXD_RSSTYPE_IPV4_TCP) | \
+	 (1ul << WX_RXD_RSSTYPE_IPV4_UDP) | \
+	 (1ul << WX_RXD_RSSTYPE_IPV4_SCTP) | \
+	 (1ul << WX_RXD_RSSTYPE_IPV6_TCP) | \
+	 (1ul << WX_RXD_RSSTYPE_IPV6_UDP) | \
+	 (1ul << WX_RXD_RSSTYPE_IPV6_SCTP))
 
 /**
  * receive packet type
@@ -422,6 +448,10 @@ enum wx_l2_ptypes {
 	WX_PTYPE_L2_TUN6_MAC = (WX_PTYPE_TUN_IPV6 | WX_PTYPE_PKT_IGM),
 };
 
+#define WX_RXD_PKTTYPE(_rxd) \
+	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 9) & 0xFF)
+#define WX_RXD_IPV6EX(_rxd) \
+	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 6) & 0x1)
 /*********************** Transmit Descriptor Config Masks ****************/
 #define WX_TXD_STAT_DD               BIT(0)  /* Descriptor Done */
 #define WX_TXD_DTYP_DATA             0       /* Adv Data Descriptor */
@@ -505,6 +535,237 @@ enum wx_tx_flags {
 #define WX_TX_FLAGS_VLAN_MASK			GENMASK(31, 16)
 #define WX_TX_FLAGS_VLAN_SHIFT			16
 
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
+#define WX_PTT(mac, ip, etype, eip, proto, layer)\
+	      {1, \
+	       WX_DEC_PTYPE_MAC_##mac,		/* mac */\
+	       WX_DEC_PTYPE_IP_##ip,		/* ip */ \
+	       WX_DEC_PTYPE_ETYPE_##etype,	/* etype */\
+	       WX_DEC_PTYPE_IP_##eip,		/* eip */\
+	       WX_DEC_PTYPE_PROT_##proto,	/* proto */\
+	       WX_DEC_PTYPE_LAYER_##layer	/* layer */}
+
+/* Lookup table mapping the HW PTYPE to the bit field for decoding */
+/* for ((pt=0;pt<256;pt++)); do printf "macro(0x%02X),\n" $pt; done */
+static wx_dptype wx_ptype_lookup[256] = {
+	/* L2: mac */
+	[0x11] = WX_PTT(L2, NONE, NONE, NONE, NONE, PAY2),
+	[0x12] = WX_PTT(L2, NONE, NONE, NONE, TS,   PAY2),
+	[0x13] = WX_PTT(L2, NONE, NONE, NONE, NONE, PAY2),
+	[0x14] = WX_PTT(L2, NONE, NONE, NONE, NONE, PAY2),
+	[0x15] = WX_PTT(L2, NONE, NONE, NONE, NONE, NONE),
+	[0x16] = WX_PTT(L2, NONE, NONE, NONE, NONE, PAY2),
+	[0x17] = WX_PTT(L2, NONE, NONE, NONE, NONE, NONE),
+
+	/* L2: ethertype filter */
+	[0x18 ... 0x1F] = WX_PTT(L2, NONE, NONE, NONE, NONE, NONE),
+
+	/* L3: ip non-tunnel */
+	[0x21] = WX_PTT(IP, FGV4, NONE, NONE, NONE, PAY3),
+	[0x22] = WX_PTT(IP, IPV4, NONE, NONE, NONE, PAY3),
+	[0x23] = WX_PTT(IP, IPV4, NONE, NONE, UDP,  PAY4),
+	[0x24] = WX_PTT(IP, IPV4, NONE, NONE, TCP,  PAY4),
+	[0x25] = WX_PTT(IP, IPV4, NONE, NONE, SCTP, PAY4),
+	[0x29] = WX_PTT(IP, FGV6, NONE, NONE, NONE, PAY3),
+	[0x2A] = WX_PTT(IP, IPV6, NONE, NONE, NONE, PAY3),
+	[0x2B] = WX_PTT(IP, IPV6, NONE, NONE, UDP,  PAY3),
+	[0x2C] = WX_PTT(IP, IPV6, NONE, NONE, TCP,  PAY4),
+	[0x2D] = WX_PTT(IP, IPV6, NONE, NONE, SCTP, PAY4),
+
+	/* L2: fcoe */
+	[0x30 ... 0x34] = WX_PTT(FCOE, NONE, NONE, NONE, NONE, PAY3),
+	[0x38 ... 0x3C] = WX_PTT(FCOE, NONE, NONE, NONE, NONE, PAY3),
+
+	/* IPv4 --> IPv4/IPv6 */
+	[0x81] = WX_PTT(IP, IPV4, IPIP, FGV4, NONE, PAY3),
+	[0x82] = WX_PTT(IP, IPV4, IPIP, IPV4, NONE, PAY3),
+	[0x83] = WX_PTT(IP, IPV4, IPIP, IPV4, UDP,  PAY4),
+	[0x84] = WX_PTT(IP, IPV4, IPIP, IPV4, TCP,  PAY4),
+	[0x85] = WX_PTT(IP, IPV4, IPIP, IPV4, SCTP, PAY4),
+	[0x89] = WX_PTT(IP, IPV4, IPIP, FGV6, NONE, PAY3),
+	[0x8A] = WX_PTT(IP, IPV4, IPIP, IPV6, NONE, PAY3),
+	[0x8B] = WX_PTT(IP, IPV4, IPIP, IPV6, UDP,  PAY4),
+	[0x8C] = WX_PTT(IP, IPV4, IPIP, IPV6, TCP,  PAY4),
+	[0x8D] = WX_PTT(IP, IPV4, IPIP, IPV6, SCTP, PAY4),
+
+	/* IPv4 --> GRE/NAT --> NONE/IPv4/IPv6 */
+	[0x90] = WX_PTT(IP, IPV4, IG, NONE, NONE, PAY3),
+	[0x91] = WX_PTT(IP, IPV4, IG, FGV4, NONE, PAY3),
+	[0x92] = WX_PTT(IP, IPV4, IG, IPV4, NONE, PAY3),
+	[0x93] = WX_PTT(IP, IPV4, IG, IPV4, UDP,  PAY4),
+	[0x94] = WX_PTT(IP, IPV4, IG, IPV4, TCP,  PAY4),
+	[0x95] = WX_PTT(IP, IPV4, IG, IPV4, SCTP, PAY4),
+	[0x99] = WX_PTT(IP, IPV4, IG, FGV6, NONE, PAY3),
+	[0x9A] = WX_PTT(IP, IPV4, IG, IPV6, NONE, PAY3),
+	[0x9B] = WX_PTT(IP, IPV4, IG, IPV6, UDP,  PAY4),
+	[0x9C] = WX_PTT(IP, IPV4, IG, IPV6, TCP,  PAY4),
+	[0x9D] = WX_PTT(IP, IPV4, IG, IPV6, SCTP, PAY4),
+
+	/* IPv4 --> GRE/NAT --> MAC --> NONE/IPv4/IPv6 */
+	[0xA0] = WX_PTT(IP, IPV4, IGM, NONE, NONE, PAY3),
+	[0xA1] = WX_PTT(IP, IPV4, IGM, FGV4, NONE, PAY3),
+	[0xA2] = WX_PTT(IP, IPV4, IGM, IPV4, NONE, PAY3),
+	[0xA3] = WX_PTT(IP, IPV4, IGM, IPV4, UDP,  PAY4),
+	[0xA4] = WX_PTT(IP, IPV4, IGM, IPV4, TCP,  PAY4),
+	[0xA5] = WX_PTT(IP, IPV4, IGM, IPV4, SCTP, PAY4),
+	[0xA9] = WX_PTT(IP, IPV4, IGM, FGV6, NONE, PAY3),
+	[0xAA] = WX_PTT(IP, IPV4, IGM, IPV6, NONE, PAY3),
+	[0xAB] = WX_PTT(IP, IPV4, IGM, IPV6, UDP,  PAY4),
+	[0xAC] = WX_PTT(IP, IPV4, IGM, IPV6, TCP,  PAY4),
+	[0xAD] = WX_PTT(IP, IPV4, IGM, IPV6, SCTP, PAY4),
+
+	/* IPv4 --> GRE/NAT --> MAC+VLAN --> NONE/IPv4/IPv6 */
+	[0xB0] = WX_PTT(IP, IPV4, IGMV, NONE, NONE, PAY3),
+	[0xB1] = WX_PTT(IP, IPV4, IGMV, FGV4, NONE, PAY3),
+	[0xB2] = WX_PTT(IP, IPV4, IGMV, IPV4, NONE, PAY3),
+	[0xB3] = WX_PTT(IP, IPV4, IGMV, IPV4, UDP,  PAY4),
+	[0xB4] = WX_PTT(IP, IPV4, IGMV, IPV4, TCP,  PAY4),
+	[0xB5] = WX_PTT(IP, IPV4, IGMV, IPV4, SCTP, PAY4),
+	[0xB9] = WX_PTT(IP, IPV4, IGMV, FGV6, NONE, PAY3),
+	[0xBA] = WX_PTT(IP, IPV4, IGMV, IPV6, NONE, PAY3),
+	[0xBB] = WX_PTT(IP, IPV4, IGMV, IPV6, UDP,  PAY4),
+	[0xBC] = WX_PTT(IP, IPV4, IGMV, IPV6, TCP,  PAY4),
+	[0xBD] = WX_PTT(IP, IPV4, IGMV, IPV6, SCTP, PAY4),
+
+	/* IPv6 --> IPv4/IPv6 */
+	[0xC1] = WX_PTT(IP, IPV6, IPIP, FGV4, NONE, PAY3),
+	[0xC2] = WX_PTT(IP, IPV6, IPIP, IPV4, NONE, PAY3),
+	[0xC3] = WX_PTT(IP, IPV6, IPIP, IPV4, UDP,  PAY4),
+	[0xC4] = WX_PTT(IP, IPV6, IPIP, IPV4, TCP,  PAY4),
+	[0xC5] = WX_PTT(IP, IPV6, IPIP, IPV4, SCTP, PAY4),
+	[0xC9] = WX_PTT(IP, IPV6, IPIP, FGV6, NONE, PAY3),
+	[0xCA] = WX_PTT(IP, IPV6, IPIP, IPV6, NONE, PAY3),
+	[0xCB] = WX_PTT(IP, IPV6, IPIP, IPV6, UDP,  PAY4),
+	[0xCC] = WX_PTT(IP, IPV6, IPIP, IPV6, TCP,  PAY4),
+	[0xCD] = WX_PTT(IP, IPV6, IPIP, IPV6, SCTP, PAY4),
+
+	/* IPv6 --> GRE/NAT -> NONE/IPv4/IPv6 */
+	[0xD0] = WX_PTT(IP, IPV6, IG, NONE, NONE, PAY3),
+	[0xD1] = WX_PTT(IP, IPV6, IG, FGV4, NONE, PAY3),
+	[0xD2] = WX_PTT(IP, IPV6, IG, IPV4, NONE, PAY3),
+	[0xD3] = WX_PTT(IP, IPV6, IG, IPV4, UDP,  PAY4),
+	[0xD4] = WX_PTT(IP, IPV6, IG, IPV4, TCP,  PAY4),
+	[0xD5] = WX_PTT(IP, IPV6, IG, IPV4, SCTP, PAY4),
+	[0xD9] = WX_PTT(IP, IPV6, IG, FGV6, NONE, PAY3),
+	[0xDA] = WX_PTT(IP, IPV6, IG, IPV6, NONE, PAY3),
+	[0xDB] = WX_PTT(IP, IPV6, IG, IPV6, UDP,  PAY4),
+	[0xDC] = WX_PTT(IP, IPV6, IG, IPV6, TCP,  PAY4),
+	[0xDD] = WX_PTT(IP, IPV6, IG, IPV6, SCTP, PAY4),
+
+	/* IPv6 --> GRE/NAT -> MAC -> NONE/IPv4/IPv6 */
+	[0xE0] = WX_PTT(IP, IPV6, IGM, NONE, NONE, PAY3),
+	[0xE1] = WX_PTT(IP, IPV6, IGM, FGV4, NONE, PAY3),
+	[0xE2] = WX_PTT(IP, IPV6, IGM, IPV4, NONE, PAY3),
+	[0xE3] = WX_PTT(IP, IPV6, IGM, IPV4, UDP,  PAY4),
+	[0xE4] = WX_PTT(IP, IPV6, IGM, IPV4, TCP,  PAY4),
+	[0xE5] = WX_PTT(IP, IPV6, IGM, IPV4, SCTP, PAY4),
+	[0xE9] = WX_PTT(IP, IPV6, IGM, FGV6, NONE, PAY3),
+	[0xEA] = WX_PTT(IP, IPV6, IGM, IPV6, NONE, PAY3),
+	[0xEB] = WX_PTT(IP, IPV6, IGM, IPV6, UDP,  PAY4),
+	[0xEC] = WX_PTT(IP, IPV6, IGM, IPV6, TCP,  PAY4),
+	[0xED] = WX_PTT(IP, IPV6, IGM, IPV6, SCTP, PAY4),
+
+	/* IPv6 --> GRE/NAT -> MAC--> NONE/IPv */
+	[0xF0] = WX_PTT(IP, IPV6, IGMV, NONE, NONE, PAY3),
+	[0xF1] = WX_PTT(IP, IPV6, IGMV, FGV4, NONE, PAY3),
+	[0xF2] = WX_PTT(IP, IPV6, IGMV, IPV4, NONE, PAY3),
+	[0xF3] = WX_PTT(IP, IPV6, IGMV, IPV4, UDP,  PAY4),
+	[0xF4] = WX_PTT(IP, IPV6, IGMV, IPV4, TCP,  PAY4),
+	[0xF5] = WX_PTT(IP, IPV6, IGMV, IPV4, SCTP, PAY4),
+	[0xF9] = WX_PTT(IP, IPV6, IGMV, FGV6, NONE, PAY3),
+	[0xFA] = WX_PTT(IP, IPV6, IGMV, IPV6, NONE, PAY3),
+	[0xFB] = WX_PTT(IP, IPV6, IGMV, IPV6, UDP,  PAY4),
+	[0xFC] = WX_PTT(IP, IPV6, IGMV, IPV6, TCP,  PAY4),
+	[0xFD] = WX_PTT(IP, IPV6, IGMV, IPV6, SCTP, PAY4),
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
@@ -801,6 +1062,7 @@ struct wx_ring {
 	struct u64_stats_sync syncp;
 	union {
 		struct wx_tx_queue_stats tx_stats;
+		struct wx_rx_queue_stats rx_stats;
 	};
 } ____cacheline_internodealigned_in_smp;
 
@@ -817,6 +1079,7 @@ struct wx_q_vector {
 	struct napi_struct napi;
 	struct rcu_head rcu;    /* to avoid race with update stats on free */
 
+	bool netpoll_rx;
 	char name[IFNAMSIZ + 17];
 
 	/* for dynamic allocation of rings associated with this q_vector */
-- 
2.40.0

