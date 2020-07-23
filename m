Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4EF22AFAF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 14:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgGWMuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 08:50:44 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:64736 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgGWMun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 08:50:43 -0400
Received: from vishal.asicdesigners.com (lakshmi-pc.asicdesigners.com [10.193.177.132] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06NCoVVn012480;
        Thu, 23 Jul 2020 05:50:32 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next v3] cxgb4: add loopback ethtool self-test
Date:   Thu, 23 Jul 2020 18:19:50 +0530
Message-Id: <20200723124950.21035-1-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this test, loopback pkt is created and sent on default queue.
The packet goes until the Multi Port Switch (MPS) just before
the MAC and based on the specified channel number, it either
goes outside the wire on one of the physical ports or looped
back to Rx path by MPS. In this case, we're specifying loopback
channel, instead of physical ports, so the packet gets looped
back to Rx path, instead of getting transmitted on the wire.

v3:
- Modify commit message to include test details.
v2:
- Add only loopback self-test.

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   8 ++
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  52 +++++++++
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 107 +++++++++++++++++-
 3 files changed, 166 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index c59e9ccc2f18..adbc0d088070 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -532,6 +532,12 @@ static inline struct mbox_cmd *mbox_cmd_log_entry(struct mbox_cmd_log *log,
 		FW_HDR_FW_VER_BUILD_G(chip##FW_VERSION_BUILD))
 #define FW_INTFVER(chip, intf) (FW_HDR_INTFVER_##intf)
 
+struct cxgb4_ethtool_lb_test {
+	struct completion completion;
+	int result;
+	int loopback;
+};
+
 struct fw_info {
 	u8 chip;
 	char *fs_name;
@@ -685,6 +691,7 @@ struct port_info {
 	u16 nmirrorqsets;
 	u32 vi_mirror_count;
 	struct mutex vi_mirror_mutex; /* Sync access to Mirror VI info */
+	struct cxgb4_ethtool_lb_test ethtool_lb;
 };
 
 struct dentry;
@@ -1595,6 +1602,7 @@ void t4_free_sge_resources(struct adapter *adap);
 void t4_free_ofld_rxqs(struct adapter *adap, int n, struct sge_ofld_rxq *q);
 irq_handler_t t4_intr_handler(struct adapter *adap);
 netdev_tx_t t4_start_xmit(struct sk_buff *skb, struct net_device *dev);
+int cxgb4_selftest_lb_pkt(struct net_device *netdev);
 int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 		     const struct pkt_gl *gl);
 int t4_mgmt_tx(struct adapter *adap, struct sk_buff *skb);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index b66a2e6cbbeb..12ef9ddd1e54 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -25,6 +25,15 @@ static void set_msglevel(struct net_device *dev, u32 val)
 	netdev2adap(dev)->msg_enable = val;
 }
 
+enum cxgb4_ethtool_tests {
+	CXGB4_ETHTOOL_LB_TEST,
+	CXGB4_ETHTOOL_MAX_TEST,
+};
+
+static const char cxgb4_selftest_strings[CXGB4_ETHTOOL_MAX_TEST][ETH_GSTRING_LEN] = {
+	"Loop back test",
+};
+
 static const char * const flash_region_strings[] = {
 	"All",
 	"Firmware",
@@ -166,6 +175,8 @@ static int get_sset_count(struct net_device *dev, int sset)
 		       ARRAY_SIZE(loopback_stats_strings);
 	case ETH_SS_PRIV_FLAGS:
 		return ARRAY_SIZE(cxgb4_priv_flags_strings);
+	case ETH_SS_TEST:
+		return ARRAY_SIZE(cxgb4_selftest_strings);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -228,6 +239,9 @@ static void get_strings(struct net_device *dev, u32 stringset, u8 *data)
 	} else if (stringset == ETH_SS_PRIV_FLAGS) {
 		memcpy(data, cxgb4_priv_flags_strings,
 		       sizeof(cxgb4_priv_flags_strings));
+	} else if (stringset == ETH_SS_TEST) {
+		memcpy(data, cxgb4_selftest_strings,
+		       sizeof(cxgb4_selftest_strings));
 	}
 }
 
@@ -2056,6 +2070,43 @@ static int cxgb4_set_priv_flags(struct net_device *netdev, u32 flags)
 	return 0;
 }
 
+static void cxgb4_lb_test(struct net_device *netdev, u64 *lb_status)
+{
+	int dev_state = netif_running(netdev);
+
+	if (dev_state) {
+		netif_tx_stop_all_queues(netdev);
+		netif_carrier_off(netdev);
+	}
+
+	*lb_status = cxgb4_selftest_lb_pkt(netdev);
+
+	if (dev_state) {
+		netif_tx_start_all_queues(netdev);
+		netif_carrier_on(netdev);
+	}
+}
+
+static void cxgb4_self_test(struct net_device *netdev,
+			    struct ethtool_test *eth_test, u64 *data)
+{
+	struct port_info *pi = netdev_priv(netdev);
+	struct adapter *adap = pi->adapter;
+
+	memset(data, 0, sizeof(u64) * CXGB4_ETHTOOL_MAX_TEST);
+
+	if (!(adap->flags & CXGB4_FW_OK)) {
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+		return;
+	}
+
+	if (eth_test->flags == ETH_TEST_FL_OFFLINE)
+		cxgb4_lb_test(netdev, &data[CXGB4_ETHTOOL_LB_TEST]);
+
+	if (data[CXGB4_ETHTOOL_LB_TEST])
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+}
+
 static const struct ethtool_ops cxgb_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_RX_MAX_FRAMES |
@@ -2090,6 +2141,7 @@ static const struct ethtool_ops cxgb_ethtool_ops = {
 	.get_rxfh_indir_size = get_rss_table_size,
 	.get_rxfh	   = get_rss_table,
 	.set_rxfh	   = set_rss_table,
+	.self_test	   = cxgb4_self_test,
 	.flash_device      = set_flash,
 	.get_ts_info       = get_ts_info,
 	.set_dump          = set_dump,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index f9c6f13d7c99..3f0fdffdb2b5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2537,6 +2537,80 @@ static void ctrlq_check_stop(struct sge_ctrl_txq *q, struct fw_wr_hdr *wr)
 	}
 }
 
+#define CXGB4_SELFTEST_LB_STR "CHELSIO_SELFTEST"
+
+int cxgb4_selftest_lb_pkt(struct net_device *netdev)
+{
+	struct port_info *pi = netdev_priv(netdev);
+	struct adapter *adap = pi->adapter;
+	struct cxgb4_ethtool_lb_test *lb;
+	int ret, i = 0, pkt_len, credits;
+	struct fw_eth_tx_pkt_wr *wr;
+	struct cpl_tx_pkt_core *cpl;
+	u32 ctrl0, ndesc, flits;
+	struct sge_eth_txq *q;
+	u8 *sgl;
+
+	pkt_len = ETH_HLEN + sizeof(CXGB4_SELFTEST_LB_STR);
+
+	flits = DIV_ROUND_UP(pkt_len + sizeof(struct cpl_tx_pkt) +
+			     sizeof(*wr), sizeof(__be64));
+	ndesc = flits_to_desc(flits);
+
+	lb = &pi->ethtool_lb;
+	lb->loopback = 1;
+
+	q = &adap->sge.ethtxq[pi->first_qset];
+
+	reclaim_completed_tx(adap, &q->q, -1, true);
+	credits = txq_avail(&q->q) - ndesc;
+	if (unlikely(credits < 0))
+		return -ENOMEM;
+
+	wr = (void *)&q->q.desc[q->q.pidx];
+	memset(wr, 0, sizeof(struct tx_desc));
+
+	wr->op_immdlen = htonl(FW_WR_OP_V(FW_ETH_TX_PKT_WR) |
+			       FW_WR_IMMDLEN_V(pkt_len +
+			       sizeof(*cpl)));
+	wr->equiq_to_len16 = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(flits, 2)));
+	wr->r3 = cpu_to_be64(0);
+
+	cpl = (void *)(wr + 1);
+	sgl = (u8 *)(cpl + 1);
+
+	ctrl0 = TXPKT_OPCODE_V(CPL_TX_PKT_XT) | TXPKT_PF_V(adap->pf) |
+		TXPKT_INTF_V(pi->tx_chan + 4);
+
+	cpl->ctrl0 = htonl(ctrl0);
+	cpl->pack = htons(0);
+	cpl->len = htons(pkt_len);
+	cpl->ctrl1 = cpu_to_be64(TXPKT_L4CSUM_DIS_F | TXPKT_IPCSUM_DIS_F);
+
+	eth_broadcast_addr(sgl);
+	i += ETH_ALEN;
+	ether_addr_copy(&sgl[i], netdev->dev_addr);
+	i += ETH_ALEN;
+
+	snprintf(&sgl[i], sizeof(CXGB4_SELFTEST_LB_STR), "%s",
+		 CXGB4_SELFTEST_LB_STR);
+
+	init_completion(&lb->completion);
+	txq_advance(&q->q, ndesc);
+	cxgb4_ring_tx_db(adap, &q->q, ndesc);
+
+	/* wait for the pkt to return */
+	ret = wait_for_completion_timeout(&lb->completion, 10 * HZ);
+	if (!ret)
+		ret = -ETIMEDOUT;
+	else
+		ret = lb->result;
+
+	lb->loopback = 0;
+
+	return ret;
+}
+
 /**
  *	ctrl_xmit - send a packet through an SGE control Tx queue
  *	@q: the control queue
@@ -3413,6 +3487,31 @@ static void t4_tx_completion_handler(struct sge_rspq *rspq,
 	t4_sge_eth_txq_egress_update(adapter, txq, -1);
 }
 
+static int cxgb4_validate_lb_pkt(struct port_info *pi, const struct pkt_gl *si)
+{
+	struct adapter *adap = pi->adapter;
+	struct cxgb4_ethtool_lb_test *lb;
+	struct sge *s = &adap->sge;
+	struct net_device *netdev;
+	u8 *data;
+	int i;
+
+	netdev = adap->port[pi->port_id];
+	lb = &pi->ethtool_lb;
+	data = si->va + s->pktshift;
+
+	i = ETH_ALEN;
+	if (!ether_addr_equal(data + i, netdev->dev_addr))
+		return -1;
+
+	i += ETH_ALEN;
+	if (strcmp(&data[i], CXGB4_SELFTEST_LB_STR))
+		lb->result = -EIO;
+
+	complete(&lb->completion);
+	return 0;
+}
+
 /**
  *	t4_ethrx_handler - process an ingress ethernet packet
  *	@q: the response queue that received the packet
@@ -3436,6 +3535,7 @@ int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 	struct port_info *pi;
 	int ret = 0;
 
+	pi = netdev_priv(q->netdev);
 	/* If we're looking at TX Queue CIDX Update, handle that separately
 	 * and return.
 	 */
@@ -3463,6 +3563,12 @@ int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 	if (err_vec)
 		rxq->stats.bad_rx_pkts++;
 
+	if (unlikely(pi->ethtool_lb.loopback && pkt->iff >= NCHAN)) {
+		ret = cxgb4_validate_lb_pkt(pi, si);
+		if (!ret)
+			return 0;
+	}
+
 	if (((pkt->l2info & htonl(RXF_TCP_F)) ||
 	     tnl_hdr_len) &&
 	    (q->netdev->features & NETIF_F_GRO) && csum_ok && !pkt->ip_frag) {
@@ -3476,7 +3582,6 @@ int t4_ethrx_handler(struct sge_rspq *q, const __be64 *rsp,
 		rxq->stats.rx_drops++;
 		return 0;
 	}
-	pi = netdev_priv(q->netdev);
 
 	/* Handle PTP Event Rx packet */
 	if (unlikely(pi->ptp_enable)) {
-- 
2.21.1

