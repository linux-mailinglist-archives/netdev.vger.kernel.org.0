Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DAE294B56
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 12:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410029AbgJUKiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 06:38:07 -0400
Received: from regular1.263xmail.com ([211.150.70.203]:44574 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393418AbgJUKiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 06:38:06 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2020 06:38:02 EDT
Received: from localhost (unknown [192.168.167.13])
        by regular1.263xmail.com (Postfix) with ESMTP id 3427D8A5;
        Wed, 21 Oct 2020 18:30:41 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.70])
        by smtp.263.net (postfix) whith ESMTP id P1670T140083357271808S1603276236392023_;
        Wed, 21 Oct 2020 18:30:41 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <b346cdfd5b5fe8bb0d7b6df686e0b309>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: netdev@vger.kernel.org
X-SENDER-IP: 14.18.236.70
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
X-System-Flag: 0
From:   Yi Li <yili@winhong.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Yi Li <yili@winhong.com>
Subject: [PATCH] net treewide: Use skb_is_gso
Date:   Wed, 21 Oct 2020 18:30:30 +0800
Message-Id: <20201021103030.3432231-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the use of the inline func skb_is_gso in place of
tests for skb_shinfo(skb)->gso_size.

- if (skb_shinfo(skb)->gso_size)
+ if (skb_is_gso(skb))

- if (unlikely(skb_shinfo(skb)->gso_size))
+ if (unlikely(skb_is_gso(skb)))

- if (!skb_shinfo(skb)->gso_size)
+ if (!skb_is_gso(skb))

Signed-off-by: Yi Li <yili@winhong.com>
---
 drivers/net/ethernet/atheros/atlx/atl1.c               | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c        | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c        | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c     | 2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c     | 2 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c                | 2 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c               | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/sge.c               | 8 ++++----
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c             | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c        | 2 +-
 drivers/net/ethernet/ibm/ibmveth.c                     | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 4 ++--
 drivers/net/ethernet/qlogic/qede/qede_fp.c             | 2 +-
 drivers/net/ethernet/tehuti/tehuti.c                   | 2 +-
 drivers/net/usb/r8152.c                                | 2 +-
 drivers/net/xen-netfront.c                             | 2 +-
 net/core/dev.c                                         | 2 +-
 net/mac80211/tx.c                                      | 2 +-
 18 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index eaf96d002fa5..dc08cb38d4f8 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2101,7 +2101,7 @@ static int atl1_tso(struct atl1_adapter *adapter, struct sk_buff *skb,
 	u8 hdr_len, ip_off;
 	u32 real_len;
 
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		int err;
 
 		err = skb_cow_head(skb, 0);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 1a6ec1a12d53..af20884cd772 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -732,7 +732,7 @@ static void bnx2x_gro_receive(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 			       struct sk_buff *skb)
 {
 #ifdef CONFIG_INET
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		switch (be16_to_cpu(skb->protocol)) {
 		case ETH_P_IP:
 			bnx2x_gro_csum(bp, skb, bnx2x_gro_ip_csum);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7d00d3a8ded4..87f79f95a1bc 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2476,7 +2476,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 		tx_info = (union tx_info *)&ndata.cmd.cmd2.ossp[0];
 	}
 
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		tx_info->s.gso_size = skb_shinfo(skb)->gso_size;
 		tx_info->s.gso_segs = skb_shinfo(skb)->gso_segs;
 		stats->tx_gso++;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 103440f97bc8..39cbb3c9a2c7 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1571,7 +1571,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 	irh = (struct octeon_instr_irh *)&ndata.cmd.cmd3.irh;
 	tx_info = (union tx_info *)&ndata.cmd.cmd3.ossp[0];
 
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		tx_info->s.gso_size = skb_shinfo(skb)->gso_size;
 		tx_info->s.gso_segs = skb_shinfo(skb)->gso_segs;
 	}
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 7a141ce32e86..ee0701bfd9ca 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -1395,7 +1395,7 @@ nicvf_sq_add_hdr_subdesc(struct nicvf *nic, struct snd_queue *sq, int qentry,
 	}
 
 	/* Tx timestamping not supported along with TSO, so ignore request */
-	if (skb_shinfo(skb)->gso_size)
+	if (skb_is_gso(skb))
 		return;
 
 	/* HW supports only a single outstanding packet to timestamp */
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index 2d9c2b5a690a..49d5fe0a97cb 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -1799,7 +1799,7 @@ netdev_tx_t t1_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			return NETDEV_TX_OK;
 	}
 
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		int eth_type;
 		struct cpl_tx_pkt_lso *hdr;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index e18e9ce27f94..686705deee9d 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -949,7 +949,7 @@ static inline unsigned int calc_tx_descs(const struct sk_buff *skb)
 		return 1;
 
 	flits = sgl_len(skb_shinfo(skb)->nr_frags + 1) + 2;
-	if (skb_shinfo(skb)->gso_size)
+	if (skb_is_gso(skb))
 		flits++;
 	return flits_to_desc(flits);
 }
@@ -1333,7 +1333,7 @@ netdev_tx_t t3_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* update port statistics */
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		qs->port_stats[SGE_PSTAT_TX_CSUM]++;
-	if (skb_shinfo(skb)->gso_size)
+	if (skb_is_gso(skb))
 		qs->port_stats[SGE_PSTAT_TSO]++;
 	if (skb_vlan_tag_present(skb))
 		qs->port_stats[SGE_PSTAT_VLANINS]++;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index a9e9c7ae565d..91d382c94b52 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -778,7 +778,7 @@ static inline unsigned int calc_tx_flits(const struct sk_buff *skb,
 	 * with an embedded TX Packet Write CPL message.
 	 */
 	flits = sgl_len(skb_shinfo(skb)->nr_frags + 1);
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		if (skb->encapsulation && chip_ver > CHELSIO_T5) {
 			hdrlen = sizeof(struct fw_eth_tx_pkt_wr) +
 				 sizeof(struct cpl_tx_tnl_lso);
@@ -1373,7 +1373,7 @@ static void *write_eo_udp_wr(struct sk_buff *skb, struct fw_eth_tx_eo_wr *wr,
 	wr->u.udpseg.udplen = sizeof(struct udphdr);
 	wr->u.udpseg.rtplen = 0;
 	wr->u.udpseg.r4 = 0;
-	if (skb_shinfo(skb)->gso_size)
+	if (skb_is_gso(skb))
 		wr->u.udpseg.mss = cpu_to_be16(skb_shinfo(skb)->gso_size);
 	else
 		wr->u.udpseg.mss = cpu_to_be16(skb->len - hdr_len);
@@ -1693,7 +1693,7 @@ static inline unsigned int t4vf_calc_tx_flits(const struct sk_buff *skb)
 	 * with an embedded TX Packet Write CPL message.
 	 */
 	flits = sgl_len(skb_shinfo(skb)->nr_frags + 1);
-	if (skb_shinfo(skb)->gso_size)
+	if (skb_is_gso(skb))
 		flits += (sizeof(struct fw_eth_tx_pkt_vm_wr) +
 			  sizeof(struct cpl_tx_pkt_lso_core) +
 			  sizeof(struct cpl_tx_pkt_core)) / sizeof(__be64);
@@ -2258,7 +2258,7 @@ static int ethofld_hard_xmit(struct net_device *dev,
 				d->addr);
 	}
 
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 			eohw_txq->uso++;
 		else
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 95657da0aa4b..b4e7ad6a6b8d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -871,7 +871,7 @@ static inline unsigned int calc_tx_flits(const struct sk_buff *skb)
 	 * with an embedded TX Packet Write CPL message.
 	 */
 	flits = sgl_len(skb_shinfo(skb)->nr_frags + 1);
-	if (skb_shinfo(skb)->gso_size)
+	if (skb_is_gso(skb))
 		flits += (sizeof(struct fw_eth_tx_pkt_vm_wr) +
 			  sizeof(struct cpl_tx_pkt_lso_core) +
 			  sizeof(struct cpl_tx_pkt_core)) / sizeof(__be64);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a362516a3185..e694c99ee540 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2990,7 +2990,7 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 						    HNS3_RXD_GRO_SIZE_M,
 						    HNS3_RXD_GRO_SIZE_S);
 	/* if there is no HW GRO, do not set gro params */
-	if (!skb_shinfo(skb)->gso_size) {
+	if (!skb_is_gso(skb)) {
 		hns3_rx_checksum(ring, skb, l234info, bd_base_info, ol_info);
 		return 0;
 	}
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7ef3369953b6..9c264768f166 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1251,7 +1251,7 @@ static void ibmveth_rx_mss_helper(struct sk_buff *skb, u16 mss, int lrg_pkt)
 		tcph->check = 0;
 	}
 
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		hdr_len = offset + tcph->doff * 4;
 		skb_shinfo(skb)->gso_segs =
 				DIV_ROUND_UP(skb->len - hdr_len,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index d5d7a2f37493..c01d1cfada51 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -509,7 +509,7 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 
 	ext = (struct nix_sqe_ext_s *)(sq->sqe_base + *offset);
 	ext->subdc = NIX_SUBDC_EXT;
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		ext->lso = 1;
 		ext->lso_sb = skb_transport_offset(skb) + tcp_hdrlen(skb);
 		ext->lso_mps = skb_shinfo(skb)->gso_size;
@@ -813,7 +813,7 @@ static bool is_hw_tso_supported(struct otx2_nic *pfvf,
 
 static int otx2_get_sqe_count(struct otx2_nic *pfvf, struct sk_buff *skb)
 {
-	if (!skb_shinfo(skb)->gso_size)
+	if (!skb_is_gso(skb))
 		return 1;
 
 	/* HW TSO */
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index a2494bf85007..092e24893cb9 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -934,7 +934,7 @@ static void qede_gro_receive(struct qede_dev *edev,
 	}
 
 #ifdef CONFIG_INET
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		skb_reset_network_header(skb);
 
 		switch (skb->protocol) {
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index b8f4f419173f..1c4f4329850e 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -1613,7 +1613,7 @@ static netdev_tx_t bdx_tx_transmit(struct sk_buff *skb,
 	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL))
 		txd_checksum = 0;
 
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		txd_mss = skb_shinfo(skb)->gso_size;
 		txd_lgsnd = 1;
 		DBG("skb %p skb len %d gso size = %d\n", skb, skb->len,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b1770489aca5..b8220f50fe13 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1918,7 +1918,7 @@ static struct tx_agg *r8152_get_tx_agg(struct r8152 *tp)
 static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 				  struct sk_buff_head *list)
 {
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		netdev_features_t features = tp->netdev->features;
 		struct sk_buff *segs, *seg, *next;
 		struct sk_buff_head seg_list;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 3e9895bec15f..c68565fbb582 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -723,7 +723,7 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 		tx->flags |= XEN_NETTXF_data_validated;
 
 	/* Optional extra info after the first request. */
-	if (skb_shinfo(skb)->gso_size) {
+	if (skb_is_gso(skb)) {
 		struct xen_netif_extra_info *gso;
 
 		gso = (struct xen_netif_extra_info *)
diff --git a/net/core/dev.c b/net/core/dev.c
index 751e5264fd49..f2ddf08fb603 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3205,7 +3205,7 @@ int skb_checksum_help(struct sk_buff *skb)
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
 		goto out_set_summed;
 
-	if (unlikely(skb_shinfo(skb)->gso_size)) {
+	if (unlikely(skb_is_gso(skb))) {
 		skb_warn_bad_offload(skb);
 		return -EINVAL;
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8ba10a48ded4..21567ffe5683 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3403,7 +3403,7 @@ static void ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
 		sdata->sequence_number += 0x10;
 	}
 
-	if (skb_shinfo(skb)->gso_size)
+	if (skb_is_gso(skb))
 		sta->tx_stats.msdu[tid] +=
 			DIV_ROUND_UP(skb->len, skb_shinfo(skb)->gso_size);
 	else
-- 
2.25.3



