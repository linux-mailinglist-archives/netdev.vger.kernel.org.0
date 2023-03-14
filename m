Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78326B8A58
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCNFbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCNFbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:31:10 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2CD56781D;
        Mon, 13 Mar 2023 22:30:55 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1134)
        id 4B0442056B4A; Mon, 13 Mar 2023 22:30:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4B0442056B4A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1678771855;
        bh=C5J3FaqbEAYH7wT0wff5nHEPVDjVfGOplfQ4kyDngYY=;
        h=From:To:Cc:Subject:Date:From;
        b=VrjrJCJdJB2jR1+ntoqy7uOdgg4TROvecitdXf/2uv24RlYHFfjrhTUrDgk8+D9U2
         n67ga9z8sFKVmsOaJHWXppmpGPMrPKWOUzf4pX7vVdwjg/IuQW+gHxHh+oUJ5sAlM2
         7g8urrc//IwJIAmvQNU0A+TG3yEqMiYuREroiHKA=
From:   Shradha Gupta <shradhagupta@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Shradha Gupta <shradhagupta@linux.microsoft.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        Leon Romanovsky <leon@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Long Li <longli@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH] net: mana: Add new MANA VF performance counters for easier troubleshooting
Date:   Mon, 13 Mar 2023 22:30:10 -0700
Message-Id: <1678771810-21050-1-git-send-email-shradhagupta@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extended performance counter stats in 'ethtool -S <interface>' output
for MANA VF to facilitate troubleshooting.

Tested-on: Ubuntu22
Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 67 ++++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    | 52 +++++++++++++-
 include/net/mana/mana.h                       | 18 +++++
 3 files changed, 133 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 6120f2b6684f..9762bdda6df1 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -156,6 +156,8 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	struct mana_txq *txq;
 	struct mana_cq *cq;
 	int err, len;
+	u16 ihs;
+	int hopbyhop = 0;
 
 	if (unlikely(!apc->port_is_up))
 		goto tx_drop;
@@ -166,6 +168,7 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	txq = &apc->tx_qp[txq_idx].txq;
 	gdma_sq = txq->gdma_sq;
 	cq = &apc->tx_qp[txq_idx].tx_cq;
+	tx_stats = &txq->stats;
 
 	pkg.tx_oob.s_oob.vcq_num = cq->gdma_id;
 	pkg.tx_oob.s_oob.vsq_frame = txq->vsq_frame;
@@ -179,10 +182,17 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	pkg.tx_oob.s_oob.pkt_fmt = pkt_fmt;
 
-	if (pkt_fmt == MANA_SHORT_PKT_FMT)
+	if (pkt_fmt == MANA_SHORT_PKT_FMT) {
 		pkg.wqe_req.inline_oob_size = sizeof(struct mana_tx_short_oob);
-	else
+		u64_stats_update_begin(&tx_stats->syncp);
+		tx_stats->short_pkt_fmt++;
+		u64_stats_update_end(&tx_stats->syncp);
+	} else {
 		pkg.wqe_req.inline_oob_size = sizeof(struct mana_tx_oob);
+		u64_stats_update_begin(&tx_stats->syncp);
+		tx_stats->long_pkt_fmt++;
+		u64_stats_update_end(&tx_stats->syncp);
+	}
 
 	pkg.wqe_req.inline_oob_data = &pkg.tx_oob;
 	pkg.wqe_req.flags = 0;
@@ -232,9 +242,37 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 						 &ipv6_hdr(skb)->daddr, 0,
 						 IPPROTO_TCP, 0);
 		}
+
+		if (skb->encapsulation) {
+			ihs = skb_inner_tcp_all_headers(skb);
+			u64_stats_update_begin(&tx_stats->syncp);
+			tx_stats->tso_inner_packets++;
+			tx_stats->tso_inner_bytes += skb->len - ihs;
+			u64_stats_update_end(&tx_stats->syncp);
+		} else {
+			if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+				ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
+			} else {
+				ihs = skb_tcp_all_headers(skb);
+				if (ipv6_has_hopopt_jumbo(skb)) {
+					hopbyhop = sizeof(struct hop_jumbo_hdr);
+					ihs -= sizeof(struct hop_jumbo_hdr);
+				}
+			}
+
+			u64_stats_update_begin(&tx_stats->syncp);
+			tx_stats->tso_packets++;
+			tx_stats->tso_bytes += skb->len - ihs - hopbyhop;
+			u64_stats_update_end(&tx_stats->syncp);
+		}
+
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		csum_type = mana_checksum_info(skb);
 
+		u64_stats_update_begin(&tx_stats->syncp);
+		tx_stats->csum_partial++;
+		u64_stats_update_end(&tx_stats->syncp);
+
 		if (csum_type == IPPROTO_TCP) {
 			pkg.tx_oob.s_oob.is_outer_ipv4 = ipv4;
 			pkg.tx_oob.s_oob.is_outer_ipv6 = ipv6;
@@ -254,8 +292,12 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		}
 	}
 
-	if (mana_map_skb(skb, apc, &pkg))
+	if (mana_map_skb(skb, apc, &pkg)) {
+		u64_stats_update_begin(&tx_stats->syncp);
+		tx_stats->mana_map_err++;
+		u64_stats_update_end(&tx_stats->syncp);
 		goto free_sgl_ptr;
+	}
 
 	skb_queue_tail(&txq->pending_skbs, skb);
 
@@ -1038,6 +1080,8 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	if (comp_read < 1)
 		return;
 
+	apc->eth_stats.tx_cqes = comp_read;
+
 	for (i = 0; i < comp_read; i++) {
 		struct mana_tx_comp_oob *cqe_oob;
 
@@ -1064,6 +1108,7 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 		case CQE_TX_VLAN_TAGGING_VIOLATION:
 			WARN_ONCE(1, "TX: CQE error %d: ignored.\n",
 				  cqe_oob->cqe_hdr.cqe_type);
+			apc->eth_stats.tx_cqe_err++;
 			break;
 
 		default:
@@ -1072,6 +1117,7 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 			 */
 			WARN_ONCE(1, "TX: Unexpected CQE type %d: HW BUG?\n",
 				  cqe_oob->cqe_hdr.cqe_type);
+			apc->eth_stats.tx_cqe_unknown_type++;
 			return;
 		}
 
@@ -1118,6 +1164,8 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 		WARN_ON_ONCE(1);
 
 	cq->work_done = pkt_transmitted;
+
+	apc->eth_stats.tx_cqes -= pkt_transmitted;
 }
 
 static void mana_post_pkt_rxq(struct mana_rxq *rxq)
@@ -1255,9 +1303,12 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	struct device *dev = gc->dev;
 	void *new_buf, *old_buf;
 	struct page *new_page;
+	struct mana_port_context *apc;
 	u32 curr, pktlen;
 	dma_addr_t da;
 
+	apc = netdev_priv(ndev);
+
 	switch (oob->cqe_hdr.cqe_type) {
 	case CQE_RX_OKAY:
 		break;
@@ -1270,6 +1321,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 
 	case CQE_RX_COALESCED_4:
 		netdev_err(ndev, "RX coalescing is unsupported\n");
+		apc->eth_stats.rx_coalesced_err++;
 		return;
 
 	case CQE_RX_OBJECT_FENCE:
@@ -1279,6 +1331,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	default:
 		netdev_err(ndev, "Unknown RX CQE type = %d\n",
 			   oob->cqe_hdr.cqe_type);
+		apc->eth_stats.rx_cqe_unknown_type++;
 		return;
 	}
 
@@ -1341,11 +1394,17 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 {
 	struct gdma_comp *comp = cq->gdma_comp_buf;
 	struct mana_rxq *rxq = cq->rxq;
+	struct net_device *ndev;
+	struct mana_port_context *apc;
 	int comp_read, i;
 
+	ndev = rxq->ndev;
+	apc = netdev_priv(ndev);
+
 	comp_read = mana_gd_poll_cq(cq->gdma_cq, comp, CQE_POLLING_BUFFER);
 	WARN_ON_ONCE(comp_read > CQE_POLLING_BUFFER);
 
+	apc->eth_stats.rx_cqes = comp_read;
 	rxq->xdp_flush = false;
 
 	for (i = 0; i < comp_read; i++) {
@@ -1357,6 +1416,8 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 			return;
 
 		mana_process_rx_cqe(rxq, cq, &comp[i]);
+
+		apc->eth_stats.rx_cqes--;
 	}
 
 	if (rxq->xdp_flush)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 5b776a33a817..a64c81410dc1 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -13,6 +13,15 @@ static const struct {
 } mana_eth_stats[] = {
 	{"stop_queue", offsetof(struct mana_ethtool_stats, stop_queue)},
 	{"wake_queue", offsetof(struct mana_ethtool_stats, wake_queue)},
+	{"tx_cqes", offsetof(struct mana_ethtool_stats, tx_cqes)},
+	{"tx_cq_err", offsetof(struct mana_ethtool_stats, tx_cqe_err)},
+	{"tx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
+					tx_cqe_unknown_type)},
+	{"rx_cqes", offsetof(struct mana_ethtool_stats, rx_cqes)},
+	{"rx_coalesced_err", offsetof(struct mana_ethtool_stats,
+					rx_coalesced_err)},
+	{"rx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
+					rx_cqe_unknown_type)},
 };
 
 static int mana_get_sset_count(struct net_device *ndev, int stringset)
@@ -23,7 +32,8 @@ static int mana_get_sset_count(struct net_device *ndev, int stringset)
 	if (stringset != ETH_SS_STATS)
 		return -EINVAL;
 
-	return ARRAY_SIZE(mana_eth_stats) + num_queues * 8;
+	return ARRAY_SIZE(mana_eth_stats) + num_queues *
+				(MANA_STATS_RX_COUNT + MANA_STATS_TX_COUNT);
 }
 
 static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
@@ -61,6 +71,22 @@ static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 		p += ETH_GSTRING_LEN;
 		sprintf(p, "tx_%d_xdp_xmit", i);
 		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_tso_packets", i);
+		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_tso_bytes", i);
+		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_tso_inner_packets", i);
+		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_tso_inner_bytes", i);
+		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_long_pkt_fmt", i);
+		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_short_pkt_fmt", i);
+		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_csum_partial", i);
+		p += ETH_GSTRING_LEN;
+		sprintf(p, "tx_%d_mana_map_err", i);
+		p += ETH_GSTRING_LEN;
 	}
 }
 
@@ -78,6 +104,14 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	u64 xdp_xmit;
 	u64 xdp_drop;
 	u64 xdp_tx;
+	u64 tso_packets;
+	u64 tso_bytes;
+	u64 tso_inner_packets;
+	u64 tso_inner_bytes;
+	u64 long_pkt_fmt;
+	u64 short_pkt_fmt;
+	u64 csum_partial;
+	u64 mana_map_err;
 	int q, i = 0;
 
 	if (!apc->port_is_up)
@@ -113,11 +147,27 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 			packets = tx_stats->packets;
 			bytes = tx_stats->bytes;
 			xdp_xmit = tx_stats->xdp_xmit;
+			tso_packets = tx_stats->tso_packets;
+			tso_bytes = tx_stats->tso_bytes;
+			tso_inner_packets = tx_stats->tso_inner_packets;
+			tso_inner_bytes = tx_stats->tso_inner_bytes;
+			long_pkt_fmt = tx_stats->long_pkt_fmt;
+			short_pkt_fmt = tx_stats->short_pkt_fmt;
+			csum_partial = tx_stats->csum_partial;
+			mana_map_err = tx_stats->mana_map_err;
 		} while (u64_stats_fetch_retry(&tx_stats->syncp, start));
 
 		data[i++] = packets;
 		data[i++] = bytes;
 		data[i++] = xdp_xmit;
+		data[i++] = tso_packets;
+		data[i++] = tso_bytes;
+		data[i++] = tso_inner_packets;
+		data[i++] = tso_inner_bytes;
+		data[i++] = long_pkt_fmt;
+		data[i++] = short_pkt_fmt;
+		data[i++] = csum_partial;
+		data[i++] = mana_map_err;
 	}
 }
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 3bb579962a14..bb11a6535d80 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -48,6 +48,10 @@ enum TRI_STATE {
 
 #define MAX_PORTS_IN_MANA_DEV 256
 
+/* Update this count whenever the respective structures are changed */
+#define MANA_STATS_RX_COUNT 5
+#define MANA_STATS_TX_COUNT 11
+
 struct mana_stats_rx {
 	u64 packets;
 	u64 bytes;
@@ -61,6 +65,14 @@ struct mana_stats_tx {
 	u64 packets;
 	u64 bytes;
 	u64 xdp_xmit;
+	u64 tso_packets;
+	u64 tso_bytes;
+	u64 tso_inner_packets;
+	u64 tso_inner_bytes;
+	u64 short_pkt_fmt;
+	u64 long_pkt_fmt;
+	u64 csum_partial;
+	u64 mana_map_err;
 	struct u64_stats_sync syncp;
 };
 
@@ -331,6 +343,12 @@ struct mana_tx_qp {
 struct mana_ethtool_stats {
 	u64 stop_queue;
 	u64 wake_queue;
+	u64 tx_cqes;
+	u64 tx_cqe_err;
+	u64 tx_cqe_unknown_type;
+	u64 rx_cqes;
+	u64 rx_coalesced_err;
+	u64 rx_cqe_unknown_type;
 };
 
 struct mana_context {
-- 
2.37.2

