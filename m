Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B8A20F58B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbgF3NYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:24:37 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:64317 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbgF3NYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:24:34 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05UDOTIp014286;
        Tue, 30 Jun 2020 06:24:30 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: [PATCH net-next v3 2/3] cxgb4: add support for mirror Rxqs
Date:   Tue, 30 Jun 2020 18:41:29 +0530
Message-Id: <bc4824d66e56ad6d71bb5efccdaaa30782eef643.1593521119.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1593521119.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593521119.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1593521119.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593521119.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mirror VI is enabled, allocate the mirror Rxqs and setup the
mirror VI RSS table. The mirror Rxqs are allocated/freed when
the mirror VI is created/destroyed or when underlying port is
brought up/down, respectively.

v3:
- Replace mirror VI refcount_t with normal u32 variable.

v2:
- Use mutex to protect all mirror VI data, instead of just
  mirror Rxqs.
- Remove the un-needed mirror Rxq mutex.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   9 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  66 ++++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 235 ++++++++++++++++--
 3 files changed, 288 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 2239d19a2ac4..980b64c7a411 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -711,6 +711,13 @@ enum {
 	ULP_CRYPTO_KTLS_INLINE  = 1 << 3,
 };
 
+#define CXGB4_MIRROR_RXQ_DEFAULT_DESC_NUM 1024
+#define CXGB4_MIRROR_RXQ_DEFAULT_DESC_SIZE 64
+#define CXGB4_MIRROR_RXQ_DEFAULT_INTR_USEC 5
+#define CXGB4_MIRROR_RXQ_DEFAULT_PKT_CNT 8
+
+#define CXGB4_MIRROR_FLQ_DEFAULT_DESC_NUM 72
+
 struct rx_sw_desc;
 
 struct sge_fl {                     /* SGE free-buffer queue state */
@@ -960,6 +967,8 @@ struct sge {
 	struct sge_eohw_txq *eohw_txq;
 	struct sge_ofld_rxq *eohw_rxq;
 
+	struct sge_eth_rxq *mirror_rxq[NCHAN];
+
 	u16 max_ethqsets;           /* # of available Ethernet queue sets */
 	u16 ethqsets;               /* # of active Ethernet queue sets */
 	u16 ethtxq_rover;           /* Tx queue to clean up next */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index b477b8842905..05f33b7e3677 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2742,6 +2742,58 @@ do { \
 	}
 
 	r -= eth_entries;
+	for_each_port(adap, j) {
+		struct port_info *pi = adap2pinfo(adap, j);
+		const struct sge_eth_rxq *rx;
+
+		mutex_lock(&pi->vi_mirror_mutex);
+		if (!pi->vi_mirror_count) {
+			mutex_unlock(&pi->vi_mirror_mutex);
+			continue;
+		}
+
+		if (r >= DIV_ROUND_UP(pi->nmirrorqsets, 4)) {
+			r -= DIV_ROUND_UP(pi->nmirrorqsets, 4);
+			mutex_unlock(&pi->vi_mirror_mutex);
+			continue;
+		}
+
+		rx = &s->mirror_rxq[j][r * 4];
+		n = min(4, pi->nmirrorqsets - 4 * r);
+
+		S("QType:", "Mirror-Rxq");
+		S("Interface:",
+		  rx[i].rspq.netdev ? rx[i].rspq.netdev->name : "N/A");
+		R("RspQ ID:", rspq.abs_id);
+		R("RspQ size:", rspq.size);
+		R("RspQE size:", rspq.iqe_len);
+		R("RspQ CIDX:", rspq.cidx);
+		R("RspQ Gen:", rspq.gen);
+		S3("u", "Intr delay:", qtimer_val(adap, &rx[i].rspq));
+		S3("u", "Intr pktcnt:", s->counter_val[rx[i].rspq.pktcnt_idx]);
+		R("FL ID:", fl.cntxt_id);
+		R("FL size:", fl.size - 8);
+		R("FL pend:", fl.pend_cred);
+		R("FL avail:", fl.avail);
+		R("FL PIDX:", fl.pidx);
+		R("FL CIDX:", fl.cidx);
+		RL("RxPackets:", stats.pkts);
+		RL("RxCSO:", stats.rx_cso);
+		RL("VLANxtract:", stats.vlan_ex);
+		RL("LROmerged:", stats.lro_merged);
+		RL("LROpackets:", stats.lro_pkts);
+		RL("RxDrops:", stats.rx_drops);
+		RL("RxBadPkts:", stats.bad_rx_pkts);
+		RL("FLAllocErr:", fl.alloc_failed);
+		RL("FLLrgAlcErr:", fl.large_alloc_failed);
+		RL("FLMapErr:", fl.mapping_err);
+		RL("FLLow:", fl.low);
+		RL("FLStarving:", fl.starving);
+
+		mutex_unlock(&pi->vi_mirror_mutex);
+		goto out;
+	}
+
 	if (!adap->tc_mqprio)
 		goto skip_mqprio;
 
@@ -3098,9 +3150,10 @@ do { \
 	return 0;
 }
 
-static int sge_queue_entries(const struct adapter *adap)
+static int sge_queue_entries(struct adapter *adap)
 {
 	int i, tot_uld_entries = 0, eohw_entries = 0, eosw_entries = 0;
+	int mirror_rxq_entries = 0;
 
 	if (adap->tc_mqprio) {
 		struct cxgb4_tc_port_mqprio *port_mqprio;
@@ -3123,6 +3176,15 @@ static int sge_queue_entries(const struct adapter *adap)
 		mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
 	}
 
+	for_each_port(adap, i) {
+		struct port_info *pi = adap2pinfo(adap, i);
+
+		mutex_lock(&pi->vi_mirror_mutex);
+		if (pi->vi_mirror_count)
+			mirror_rxq_entries += DIV_ROUND_UP(pi->nmirrorqsets, 4);
+		mutex_unlock(&pi->vi_mirror_mutex);
+	}
+
 	if (!is_uld(adap))
 		goto lld_only;
 
@@ -3137,7 +3199,7 @@ static int sge_queue_entries(const struct adapter *adap)
 	mutex_unlock(&uld_mutex);
 
 lld_only:
-	return DIV_ROUND_UP(adap->sge.ethqsets, 4) +
+	return DIV_ROUND_UP(adap->sge.ethqsets, 4) + mirror_rxq_entries +
 	       eohw_entries + eosw_entries + tot_uld_entries +
 	       DIV_ROUND_UP(MAX_CTRL_QUEUES, 4) + 1;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index e659af08e352..c7b9161d4326 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -822,6 +822,31 @@ static void adap_config_hpfilter(struct adapter *adapter)
 			"HP filter region isn't supported by FW\n");
 }
 
+static int cxgb4_config_rss(const struct port_info *pi, u16 *rss,
+			    u16 rss_size, u16 viid)
+{
+	struct adapter *adap = pi->adapter;
+	int ret;
+
+	ret = t4_config_rss_range(adap, adap->mbox, viid, 0, rss_size, rss,
+				  rss_size);
+	if (ret)
+		return ret;
+
+	/* If Tunnel All Lookup isn't specified in the global RSS
+	 * Configuration, then we need to specify a default Ingress
+	 * Queue for any ingress packets which aren't hashed.  We'll
+	 * use our first ingress queue ...
+	 */
+	return t4_config_vi_rss(adap, adap->mbox, viid,
+				FW_RSS_VI_CONFIG_CMD_IP6FOURTUPEN_F |
+				FW_RSS_VI_CONFIG_CMD_IP6TWOTUPEN_F |
+				FW_RSS_VI_CONFIG_CMD_IP4FOURTUPEN_F |
+				FW_RSS_VI_CONFIG_CMD_IP4TWOTUPEN_F |
+				FW_RSS_VI_CONFIG_CMD_UDPEN_F,
+				rss[0]);
+}
+
 /**
  *	cxgb4_write_rss - write the RSS table for a given port
  *	@pi: the port
@@ -833,10 +858,10 @@ static void adap_config_hpfilter(struct adapter *adapter)
  */
 int cxgb4_write_rss(const struct port_info *pi, const u16 *queues)
 {
-	u16 *rss;
-	int i, err;
 	struct adapter *adapter = pi->adapter;
 	const struct sge_eth_rxq *rxq;
+	int i, err;
+	u16 *rss;
 
 	rxq = &adapter->sge.ethrxq[pi->first_qset];
 	rss = kmalloc_array(pi->rss_size, sizeof(u16), GFP_KERNEL);
@@ -847,21 +872,7 @@ int cxgb4_write_rss(const struct port_info *pi, const u16 *queues)
 	for (i = 0; i < pi->rss_size; i++, queues++)
 		rss[i] = rxq[*queues].rspq.abs_id;
 
-	err = t4_config_rss_range(adapter, adapter->pf, pi->viid, 0,
-				  pi->rss_size, rss, pi->rss_size);
-	/* If Tunnel All Lookup isn't specified in the global RSS
-	 * Configuration, then we need to specify a default Ingress
-	 * Queue for any ingress packets which aren't hashed.  We'll
-	 * use our first ingress queue ...
-	 */
-	if (!err)
-		err = t4_config_vi_rss(adapter, adapter->mbox, pi->viid,
-				       FW_RSS_VI_CONFIG_CMD_IP6FOURTUPEN_F |
-				       FW_RSS_VI_CONFIG_CMD_IP6TWOTUPEN_F |
-				       FW_RSS_VI_CONFIG_CMD_IP4FOURTUPEN_F |
-				       FW_RSS_VI_CONFIG_CMD_IP4TWOTUPEN_F |
-				       FW_RSS_VI_CONFIG_CMD_UDPEN_F,
-				       rss[0]);
+	err = cxgb4_config_rss(pi, rss, pi->rss_size, pi->viid);
 	kfree(rss);
 	return err;
 }
@@ -1285,6 +1296,151 @@ static int setup_debugfs(struct adapter *adap)
 	return 0;
 }
 
+static void cxgb4_port_mirror_free_rxq(struct adapter *adap,
+				       struct sge_eth_rxq *mirror_rxq)
+{
+	if ((adap->flags & CXGB4_FULL_INIT_DONE) &&
+	    !(adap->flags & CXGB4_SHUTTING_DOWN))
+		cxgb4_quiesce_rx(&mirror_rxq->rspq);
+
+	if (adap->flags & CXGB4_USING_MSIX) {
+		cxgb4_clear_msix_aff(mirror_rxq->msix->vec,
+				     mirror_rxq->msix->aff_mask);
+		free_irq(mirror_rxq->msix->vec, &mirror_rxq->rspq);
+		cxgb4_free_msix_idx_in_bmap(adap, mirror_rxq->msix->idx);
+	}
+
+	free_rspq_fl(adap, &mirror_rxq->rspq, &mirror_rxq->fl);
+}
+
+static int cxgb4_port_mirror_alloc_queues(struct net_device *dev)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct sge_eth_rxq *mirror_rxq;
+	struct sge *s = &adap->sge;
+	int ret = 0, msix = 0;
+	u16 i, rxqid;
+	u16 *rss;
+
+	if (!pi->vi_mirror_count)
+		return 0;
+
+	if (s->mirror_rxq[pi->port_id])
+		return 0;
+
+	mirror_rxq = kcalloc(pi->nmirrorqsets, sizeof(*mirror_rxq), GFP_KERNEL);
+	if (!mirror_rxq)
+		return -ENOMEM;
+
+	s->mirror_rxq[pi->port_id] = mirror_rxq;
+
+	if (!(adap->flags & CXGB4_USING_MSIX))
+		msix = -((int)adap->sge.intrq.abs_id + 1);
+
+	for (i = 0, rxqid = 0; i < pi->nmirrorqsets; i++, rxqid++) {
+		mirror_rxq = &s->mirror_rxq[pi->port_id][i];
+
+		/* Allocate Mirror Rxqs */
+		if (msix >= 0) {
+			msix = cxgb4_get_msix_idx_from_bmap(adap);
+			if (msix < 0) {
+				ret = msix;
+				goto out_free_queues;
+			}
+
+			mirror_rxq->msix = &adap->msix_info[msix];
+			snprintf(mirror_rxq->msix->desc,
+				 sizeof(mirror_rxq->msix->desc),
+				 "%s-mirrorrxq%d", dev->name, i);
+		}
+
+		init_rspq(adap, &mirror_rxq->rspq,
+			  CXGB4_MIRROR_RXQ_DEFAULT_INTR_USEC,
+			  CXGB4_MIRROR_RXQ_DEFAULT_PKT_CNT,
+			  CXGB4_MIRROR_RXQ_DEFAULT_DESC_NUM,
+			  CXGB4_MIRROR_RXQ_DEFAULT_DESC_SIZE);
+
+		mirror_rxq->fl.size = CXGB4_MIRROR_FLQ_DEFAULT_DESC_NUM;
+
+		ret = t4_sge_alloc_rxq(adap, &mirror_rxq->rspq, false,
+				       dev, msix, &mirror_rxq->fl,
+				       t4_ethrx_handler, NULL, 0);
+		if (ret)
+			goto out_free_msix_idx;
+
+		/* Setup MSI-X vectors for Mirror Rxqs */
+		if (adap->flags & CXGB4_USING_MSIX) {
+			ret = request_irq(mirror_rxq->msix->vec,
+					  t4_sge_intr_msix, 0,
+					  mirror_rxq->msix->desc,
+					  &mirror_rxq->rspq);
+			if (ret)
+				goto out_free_rxq;
+
+			cxgb4_set_msix_aff(adap, mirror_rxq->msix->vec,
+					   &mirror_rxq->msix->aff_mask, i);
+		}
+
+		/* Start NAPI for Mirror Rxqs */
+		cxgb4_enable_rx(adap, &mirror_rxq->rspq);
+	}
+
+	/* Setup RSS for Mirror Rxqs */
+	rss = kcalloc(pi->rss_size, sizeof(u16), GFP_KERNEL);
+	if (!rss) {
+		ret = -ENOMEM;
+		goto out_free_queues;
+	}
+
+	mirror_rxq = &s->mirror_rxq[pi->port_id][0];
+	for (i = 0; i < pi->rss_size; i++)
+		rss[i] = mirror_rxq[i % pi->nmirrorqsets].rspq.abs_id;
+
+	ret = cxgb4_config_rss(pi, rss, pi->rss_size, pi->viid_mirror);
+	kfree(rss);
+	if (ret)
+		goto out_free_queues;
+
+	return 0;
+
+out_free_rxq:
+	free_rspq_fl(adap, &mirror_rxq->rspq, &mirror_rxq->fl);
+
+out_free_msix_idx:
+	cxgb4_free_msix_idx_in_bmap(adap, mirror_rxq->msix->idx);
+
+out_free_queues:
+	while (rxqid-- > 0)
+		cxgb4_port_mirror_free_rxq(adap,
+					   &s->mirror_rxq[pi->port_id][rxqid]);
+
+	kfree(s->mirror_rxq[pi->port_id]);
+	s->mirror_rxq[pi->port_id] = NULL;
+	return ret;
+}
+
+static void cxgb4_port_mirror_free_queues(struct net_device *dev)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct sge *s = &adap->sge;
+	u16 i;
+
+	if (!pi->vi_mirror_count)
+		return;
+
+	if (!s->mirror_rxq[pi->port_id])
+		return;
+
+	for (i = 0; i < pi->nmirrorqsets; i++)
+		cxgb4_port_mirror_free_rxq(adap,
+					   &s->mirror_rxq[pi->port_id][i]);
+
+	kfree(s->mirror_rxq[pi->port_id]);
+	s->mirror_rxq[pi->port_id] = NULL;
+}
+
 int cxgb4_port_mirror_alloc(struct net_device *dev)
 {
 	struct port_info *pi = netdev2pinfo(dev);
@@ -1307,6 +1463,20 @@ int cxgb4_port_mirror_alloc(struct net_device *dev)
 
 	pi->vi_mirror_count = 1;
 
+	if (adap->flags & CXGB4_FULL_INIT_DONE) {
+		ret = cxgb4_port_mirror_alloc_queues(dev);
+		if (ret)
+			goto out_free_vi;
+	}
+
+	mutex_unlock(&pi->vi_mirror_mutex);
+	return 0;
+
+out_free_vi:
+	pi->vi_mirror_count = 0;
+	t4_free_vi(adap, adap->mbox, adap->pf, 0, pi->viid_mirror);
+	pi->viid_mirror = 0;
+
 out_unlock:
 	mutex_unlock(&pi->vi_mirror_mutex);
 	return ret;
@@ -1326,6 +1496,8 @@ void cxgb4_port_mirror_free(struct net_device *dev)
 		goto out_unlock;
 	}
 
+	cxgb4_port_mirror_free_queues(dev);
+
 	pi->vi_mirror_count = 0;
 	t4_free_vi(adap, adap->mbox, adap->pf, 0, pi->viid_mirror);
 	pi->viid_mirror = 0;
@@ -2606,8 +2778,22 @@ int cxgb_open(struct net_device *dev)
 		return err;
 
 	err = link_start(dev);
-	if (!err)
-		netif_tx_start_all_queues(dev);
+	if (err)
+		return err;
+
+	if (pi->nmirrorqsets) {
+		mutex_lock(&pi->vi_mirror_mutex);
+		err = cxgb4_port_mirror_alloc_queues(dev);
+		if (err)
+			goto out_unlock;
+		mutex_unlock(&pi->vi_mirror_mutex);
+	}
+
+	netif_tx_start_all_queues(dev);
+	return 0;
+
+out_unlock:
+	mutex_unlock(&pi->vi_mirror_mutex);
 	return err;
 }
 
@@ -2625,7 +2811,16 @@ int cxgb_close(struct net_device *dev)
 	cxgb4_dcb_reset(dev);
 	dcb_tx_queue_prio_enable(dev, false);
 #endif
-	return ret;
+	if (ret)
+		return ret;
+
+	if (pi->nmirrorqsets) {
+		mutex_lock(&pi->vi_mirror_mutex);
+		cxgb4_port_mirror_free_queues(dev);
+		mutex_unlock(&pi->vi_mirror_mutex);
+	}
+
+	return 0;
 }
 
 int cxgb4_create_server_filter(const struct net_device *dev, unsigned int stid,
-- 
2.24.0

