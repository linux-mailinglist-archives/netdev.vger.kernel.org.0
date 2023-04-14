Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5114E6E2143
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDNKw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjDNKw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:52:27 -0400
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46D32719
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 03:52:23 -0700 (PDT)
X-QQ-mid: bizesmtp74t1681469332t9c45llw
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 14 Apr 2023 18:48:50 +0800 (CST)
X-QQ-SSF: 01400000000000N0R000000A0000000
X-QQ-FEAT: lJ9dImo9GpfF1WU/zyEdH+0rpqZ16ax+2IvjtUVuML6s59wJ1ti7ZIYftoVS3
        ID5BYvov/5z1lIGm31jKVNilzYJZgCrWP1h4h3tczh+38lOlF4eQk1CMzrbiatYDijwtnm2
        uQcbyCXNYQKNh1BcOZIg9hcHVdvtg2OFrWNFBJ2U5Ncxv5HZVYh/sxtr+Jj45tD0n8MPYTH
        Z3DTY+xlH8MBCrJSKHEGjA/o7qrJPFnbNugBuf65YKaEm9atra5V01TCfwuezxvPvsWCco2
        zwmNjUSZwd7PxjwOXxFVgA6VnMHEdiPGDsRgGinC9fQVNPVQ04q+++NY/SzWgRQMyjICJ/t
        PlqeKxWzekFeFjv5RhPMiJNiuwqwgczd/J4VmZ6qEO8SfhkNWzeAs33TDsmy0vEUoRwHklz
        YZSfWaMdRGm7NYGo1ynuGgW0sRaPel9T
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 5596115537480803509
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 2/5] net: wangxun: libwx add rx offload functions
Date:   Fri, 14 Apr 2023 18:48:30 +0800
Message-Id: <20230414104833.42989-3-mengyuanlou@net-swift.com>
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

Add rx offload functions for wx_clean_rx_irq
which supports ngbe and txgbe to implement
rx offload function.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c  | 441 ++++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h |  31 ++
 2 files changed, 469 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 711673d5bcd1..d139f7c4c7d7 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -423,6 +423,441 @@ static bool wx_cleanup_headers(struct wx_ring *rx_ring,
 	return false;
 }
 
+static void wx_set_rsc_gso_size(struct wx_ring __maybe_unused *ring,
+				struct sk_buff *skb)
+{
+	u16 hdr_len = eth_get_headlen(skb->dev, skb->data, skb_headlen(skb));
+
+	/* set gso_size to avoid messing up TCP MSS */
+	skb_shinfo(skb)->gso_size = DIV_ROUND_UP((skb->len - hdr_len),
+						 WX_CB(skb)->append_cnt);
+	skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
+}
+
+static void wx_update_rsc_stats(struct wx_ring *rx_ring,
+				struct sk_buff *skb)
+{
+	/* if append_cnt is 0 then frame is not RSC */
+	if (!WX_CB(skb)->append_cnt)
+		return;
+
+	rx_ring->rx_stats.rsc_count += WX_CB(skb)->append_cnt;
+	rx_ring->rx_stats.rsc_flush++;
+
+	wx_set_rsc_gso_size(rx_ring, skb);
+	/* gso_size is computed using append_cnt so always clear it last */
+	WX_CB(skb)->append_cnt = 0;
+}
+
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
+	wx_update_rsc_stats(rx_ring, skb);
+	wx_rx_hash(rx_ring, rx_desc, skb);
+	wx_rx_checksum(rx_ring, rx_desc, skb);
+	skb_record_rx_queue(skb, rx_ring->queue_index);
+	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
+}
+
+/**
+ * wx_can_lro - returns true if packet is TCP/IPV4 and LRO is enabled
+ * @rx_ring: structure containing ring specific data
+ * @rx_desc: pointer to the rx descriptor
+ * @skb: pointer to the skb to be merged
+ *
+ **/
+static inline bool wx_can_lro(struct wx_ring *rx_ring,
+			      union wx_rx_desc *rx_desc,
+			      struct sk_buff *skb)
+{
+	struct iphdr *iph = (struct iphdr *)skb->data;
+	wx_dptype dec_ptype;
+
+	dec_ptype = wx_decode_ptype(WX_RXD_PKTTYPE(rx_desc));
+	/* verify hardware indicates this is IPv4/TCP */
+	if (!dec_ptype.known ||
+	    dec_ptype.etype != WX_DEC_PTYPE_ETYPE_NONE ||
+	    dec_ptype.ip != WX_DEC_PTYPE_IP_IPV4 ||
+	    dec_ptype.prot != WX_DEC_PTYPE_PROT_TCP)
+		return false;
+
+	/* .. and LRO is enabled */
+	if (!(rx_ring->netdev->features & NETIF_F_LRO))
+		return false;
+
+	/* .. and we are not in promiscuous mode */
+	if (rx_ring->netdev->flags & IFF_PROMISC)
+		return false;
+
+	/* .. and the header is large enough for us to read IP/TCP fields */
+	if (!pskb_may_pull(skb, sizeof(struct wx_lrohdr)))
+		return false;
+
+	/* .. and there are no VLANs on packet */
+	if (skb->protocol != htons(ETH_P_IP))
+		return false;
+
+	/* .. and we are version 4 with no options */
+	if (*(u8 *)iph != 0x45)
+		return false;
+
+	/* .. and the packet is not fragmented */
+	if (ip_is_fragment(ip_hdr(skb)))
+		return false;
+
+	/* .. and that next header is TCP */
+	if (iph->protocol != IPPROTO_TCP)
+		return false;
+
+	return true;
+}
+
+static void wx_lro_flush(struct wx_q_vector *q_vector,
+			 struct sk_buff *skb)
+{
+	struct wx_lro_list *lrolist = &q_vector->lrolist;
+
+	__skb_unlink(skb, &lrolist->active);
+
+	if (WX_CB(skb)->append_cnt) {
+		struct wx_lrohdr *lroh = wx_lro_hdr(skb);
+
+		/* incorporate ip header and re-calculate checksum */
+		lroh->iph.tot_len = (__force __be16)ntohs((__force __be16)skb->len);
+		lroh->iph.check = 0;
+
+		/* header length is 5 since we know no options exist */
+		lroh->iph.check = ip_fast_csum((u8 *)lroh, 5);
+
+		/* clear TCP checksum to indicate we are an LRO frame */
+		lroh->th.check = 0;
+
+		/* incorporate latest timestamp into the tcp header */
+		if (WX_CB(skb)->tsecr) {
+			lroh->ts[2] = WX_CB(skb)->tsecr;
+			lroh->ts[1] = htonl(WX_CB(skb)->tsval);
+		}
+#ifdef NAPI_GRO_CB
+		NAPI_GRO_CB(skb)->data_offset = 0;
+#endif
+		skb_shinfo(skb)->gso_size = WX_CB(skb)->mss;
+		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
+	}
+
+	napi_gro_receive(&q_vector->napi, skb);
+	lrolist->stats.flushed++;
+}
+
+static void wx_lro_header_ok(struct sk_buff *skb)
+{
+	struct wx_lrohdr *lroh = wx_lro_hdr(skb);
+	u16 opt_bytes, data_len;
+
+	WX_CB(skb)->tsecr = 0;
+	WX_CB(skb)->append_cnt = 0;
+	WX_CB(skb)->mss = 0;
+
+	/* ensure that the checksum is valid */
+	if (skb->ip_summed != CHECKSUM_UNNECESSARY)
+		return;
+
+	/* If we see CE codepoint in IP header, packet is not mergeable */
+	if (INET_ECN_is_ce(ipv4_get_dsfield(&lroh->iph)))
+		return;
+
+	/* ensure no bits set besides ack or psh */
+	if (lroh->th.fin || lroh->th.syn || lroh->th.rst ||
+	    lroh->th.urg || lroh->th.ece || lroh->th.cwr ||
+	    !lroh->th.ack)
+		return;
+
+	/* store the total packet length */
+	data_len = ntohs(lroh->iph.tot_len);
+
+	/* remove any padding from the end of the skb */
+	__pskb_trim(skb, data_len);
+
+	/* remove header length from data length */
+	data_len -= sizeof(struct wx_lrohdr);
+
+	/* check for timestamps. Since the only option we handle are timestamps,
+	 * we only have to handle the simple case of aligned timestamps
+	 */
+	opt_bytes = (lroh->th.doff << 2) - sizeof(struct tcphdr);
+	if (opt_bytes != 0) {
+		if (opt_bytes != TCPOLEN_TSTAMP_ALIGNED ||
+		    !pskb_may_pull(skb, sizeof(struct wx_lrohdr) +
+				   TCPOLEN_TSTAMP_ALIGNED) ||
+		    lroh->ts[0] != htonl((TCPOPT_NOP << 24) |
+					 (TCPOPT_NOP << 16) |
+					 (TCPOPT_TIMESTAMP << 8) |
+					 TCPOLEN_TIMESTAMP) ||
+		    lroh->ts[2] == 0)
+			return;
+
+		WX_CB(skb)->tsval = ntohl(lroh->ts[1]);
+		WX_CB(skb)->tsecr = lroh->ts[2];
+
+		data_len -= TCPOLEN_TSTAMP_ALIGNED;
+	}
+
+	/* record data_len as mss for the packet */
+	WX_CB(skb)->mss = data_len;
+	WX_CB(skb)->next_seq = ntohl(lroh->th.seq);
+}
+
+static void wx_merge_frags(struct sk_buff *lro_skb, struct sk_buff *new_skb)
+{
+	struct skb_shared_info *sh_info, *new_skb_info;
+	unsigned int data_len;
+
+	sh_info = skb_shinfo(lro_skb);
+	new_skb_info = skb_shinfo(new_skb);
+
+	/* copy frags into the last skb */
+	memcpy(sh_info->frags + sh_info->nr_frags,
+	       new_skb_info->frags,
+	       new_skb_info->nr_frags * sizeof(skb_frag_t));
+
+	/* copy size data over */
+	sh_info->nr_frags += new_skb_info->nr_frags;
+	data_len = WX_CB(new_skb)->mss;
+	lro_skb->len += data_len;
+	lro_skb->data_len += data_len;
+	lro_skb->truesize += data_len;
+
+	/* wipe record of data from new_skb and free it */
+	new_skb_info->nr_frags = 0;
+	new_skb->len = 0;
+	new_skb->data_len = 0;
+	dev_kfree_skb_any(new_skb);
+}
+
+/**
+ * wx_lro_receive - if able, queue skb into lro chain
+ * @q_vector: structure containing interrupt and ring information
+ * @new_skb: pointer to current skb being checked
+ *
+ * Checks whether the skb given is eligible for LRO and if that's
+ * fine chains it to the existing lro_skb based on flowid. If an LRO for
+ * the flow doesn't exist create one.
+ **/
+static void wx_lro_receive(struct wx_q_vector *q_vector,
+			   struct sk_buff *new_skb)
+{
+	struct wx_lro_list *lrolist = &q_vector->lrolist;
+	struct wx_lrohdr *lroh = wx_lro_hdr(new_skb);
+	__be32 tcp_ports = *(__be32 *)&lroh->th;
+	__be32 saddr = lroh->iph.saddr;
+	__be32 daddr = lroh->iph.daddr;
+	u16 vid = new_skb->vlan_tci;
+	struct sk_buff *lro_skb;
+
+	wx_lro_header_ok(new_skb);
+
+	/* we have a packet that might be eligible for LRO,
+	 * so see if it matches anything we might expect
+	 */
+	skb_queue_walk(&lrolist->active, lro_skb) {
+		u16 data_len;
+
+		if (*(__be32 *)&wx_lro_hdr(lro_skb)->th != tcp_ports ||
+		    wx_lro_hdr(lro_skb)->iph.saddr != saddr ||
+		    wx_lro_hdr(lro_skb)->iph.daddr != daddr)
+			continue;
+		if (lro_skb->vlan_tci != vid)
+			continue;
+
+		/* out of order packet */
+		if (WX_CB(lro_skb)->next_seq !=
+		    WX_CB(new_skb)->next_seq) {
+			wx_lro_flush(q_vector, lro_skb);
+			WX_CB(new_skb)->mss = 0;
+			break;
+		}
+
+		/* TCP timestamp options have changed */
+		if (!WX_CB(lro_skb)->tsecr != !WX_CB(new_skb)->tsecr) {
+			wx_lro_flush(q_vector, lro_skb);
+			break;
+		}
+
+		/* make sure timestamp values are increasing */
+		if (WX_CB(lro_skb)->tsecr &&
+		    WX_CB(lro_skb)->tsval > WX_CB(new_skb)->tsval) {
+			wx_lro_flush(q_vector, lro_skb);
+			WX_CB(new_skb)->mss = 0;
+			break;
+		}
+
+		data_len = WX_CB(new_skb)->mss;
+
+		/* Check for all of the above below
+		 *   malformed header
+		 *   no tcp data
+		 *   resultant packet would be too large
+		 *   new skb is larger than our current mss
+		 *   data would remain in header
+		 *   we would consume more frags then the sk_buff contains
+		 *   ack sequence numbers changed
+		 *   window size has changed
+		 */
+		if (data_len == 0 ||
+		    data_len > WX_CB(lro_skb)->mss ||
+		    data_len > WX_CB(lro_skb)->free ||
+		    data_len != new_skb->data_len ||
+		    skb_shinfo(new_skb)->nr_frags >=
+		    (MAX_SKB_FRAGS - skb_shinfo(lro_skb)->nr_frags) ||
+		    wx_lro_hdr(lro_skb)->th.ack_seq != lroh->th.ack_seq ||
+		    wx_lro_hdr(lro_skb)->th.window != lroh->th.window) {
+			wx_lro_flush(q_vector, lro_skb);
+			break;
+		}
+
+		/* Remove IP and TCP header */
+		skb_pull(new_skb, new_skb->len - data_len);
+
+		/* update timestamp and timestamp echo response */
+		WX_CB(lro_skb)->tsval = WX_CB(new_skb)->tsval;
+		WX_CB(lro_skb)->tsecr = WX_CB(new_skb)->tsecr;
+
+		/* update sequence and free space */
+		WX_CB(lro_skb)->next_seq += data_len;
+		WX_CB(lro_skb)->free -= data_len;
+
+		/* update append_cnt */
+		WX_CB(lro_skb)->append_cnt++;
+
+		/* if header is empty pull pages into current skb */
+		wx_merge_frags(lro_skb, new_skb);
+		if ((data_len < WX_CB(lro_skb)->mss) || lroh->th.psh ||
+		    skb_shinfo(lro_skb)->nr_frags == MAX_SKB_FRAGS) {
+			wx_lro_hdr(lro_skb)->th.psh |= lroh->th.psh;
+			wx_lro_flush(q_vector, lro_skb);
+		}
+
+		lrolist->stats.coal++;
+		return;
+	}
+
+	if (WX_CB(new_skb)->mss && !lroh->th.psh) {
+		/* if we are at capacity flush the tail */
+		if (skb_queue_len(&lrolist->active) >= WX_LRO_MAX) {
+			lro_skb = skb_peek_tail(&lrolist->active);
+			if (lro_skb)
+				wx_lro_flush(q_vector, lro_skb);
+		}
+
+		/* update sequence and free space */
+		WX_CB(new_skb)->next_seq += WX_CB(new_skb)->mss;
+		WX_CB(new_skb)->free = 65521 - new_skb->len;
+
+		/* .. and insert at the front of the active list */
+		__skb_queue_head(&lrolist->active, new_skb);
+
+		lrolist->stats.coal++;
+		return;
+	}
+
+	/* packet not handled by any of the above, pass it to the stack */
+	napi_gro_receive(&q_vector->napi, new_skb);
+}
+
+static void wx_rx_skb(struct wx_q_vector *q_vector, struct wx_ring *rx_ring,
+		      union wx_rx_desc *rx_desc, struct sk_buff *skb)
+{
+	if (wx_can_lro(rx_ring, rx_desc, skb))
+		wx_lro_receive(q_vector, skb);
+	else
+		napi_gro_receive(&q_vector->napi, skb);
+}
+
 /**
  * wx_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @q_vector: structure containing interrupt and ring information
@@ -490,9 +925,9 @@ static int wx_clean_rx_irq(struct wx_q_vector *q_vector,
 		/* probably a little skewed due to removing CRC */
 		total_rx_bytes += skb->len;
 
-		skb_record_rx_queue(skb, rx_ring->queue_index);
-		skb->protocol = eth_type_trans(skb, rx_ring->netdev);
-		napi_gro_receive(&q_vector->napi, skb);
+		/* populate checksum, timestamp, VLAN, and protocol */
+		wx_process_skb_fields(rx_ring, rx_desc, skb);
+		wx_rx_skb(q_vector, rx_ring, rx_desc, skb);
 
 		/* update budget accounting */
 		total_rx_packets++;
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index e227268a9518..cd1fb1f7b1a0 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -330,8 +330,34 @@
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
@@ -430,6 +456,11 @@ enum wx_l2_ptypes {
 	WX_PTYPE_L2_TUN6_MAC = (WX_PTYPE_TUN_IPV6 | WX_PTYPE_PKT_IGM),
 };
 
+#define WX_RXD_PKTTYPE(_rxd) \
+	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 9) & 0xFF)
+#define WX_RXD_IPV6EX(_rxd) \
+	((le32_to_cpu((_rxd)->wb.lower.lo_dword.data) >> 6) & 0x1)
+
 /* Ether Types */
 #define WX_ETH_P_LLDP			0x88CC
 #define WX_ETH_P_CNM			0x22E7
-- 
2.40.0

