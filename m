Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1296EE1CF
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbjDYM0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjDYM0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:26:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69044C13
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:26:10 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PC9trp007707;
        Tue, 25 Apr 2023 05:26:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=YR/hth4SXqhjxww+/MaQxbm7eD9L2U3ssD6enOQVZnQ=;
 b=WtVFucHnfLA2j2fuAZGe3boefSE510Y3xePD00H8FO38/XXJl3+n7dhxvfEQqGoEIBiU
 N5cSqUvv9yPHnlcF9MqAojhuKM3euZEss/XV3mXtwbi0oDCD8o4935uvCPKZHwfxztZQ
 XBjVGLjG/5X9UqS4PZYKf00OID6p5Xv8ZghZA8wCzP7M/c7oAN2+tjv11UiZkGw+x9FY
 lNYwNNOB5/0KP0aUu1Zg44ko7hhxVqOwR5ZIIRqSAVYRCxAI5ANiKI29OKukouojONfQ
 JUk+pbSbxFbVNIvbl81dhZv7ejfGnZekpELcgRZIeMev5aU5he0f9ET0wq143ZU29vRa og== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pa0b6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 05:26:04 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 05:26:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 05:26:02 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DCE5C3F7096;
        Tue, 25 Apr 2023 05:26:02 -0700 (PDT)
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, Sudarsana Kalluru <skalluru@marvell.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] qed/qede: Fix scheduling while atomic
Date:   Tue, 25 Apr 2023 05:25:48 -0700
Message-ID: <20230425122548.32691-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: eL8S26-HKJANfgKal3HUNQFituFrHSf3
X-Proofpoint-GUID: eL8S26-HKJANfgKal3HUNQFituFrHSf3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_05,2023-04-25_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bonding module collects the statistics while holding
the spinlock, beneath that qede->qed driver statistics
flow gets scheduled out due to usleep_range() used in PTT
acquire logic which results into below bug and traces -

[ 3673.988874] Hardware name: HPE ProLiant DL365 Gen10 Plus/ProLiant DL365 Gen10 Plus, BIOS A42 10/29/2021
[ 3673.988878] Call Trace:
[ 3673.988891]  dump_stack_lvl+0x34/0x44
[ 3673.988908]  __schedule_bug.cold+0x47/0x53
[ 3673.988918]  __schedule+0x3fb/0x560
[ 3673.988929]  schedule+0x43/0xb0
[ 3673.988932]  schedule_hrtimeout_range_clock+0xbf/0x1b0
[ 3673.988937]  ? __hrtimer_init+0xc0/0xc0
[ 3673.988950]  usleep_range+0x5e/0x80
[ 3673.988955]  qed_ptt_acquire+0x2b/0xd0 [qed]
[ 3673.988981]  _qed_get_vport_stats+0x141/0x240 [qed]
[ 3673.989001]  qed_get_vport_stats+0x18/0x80 [qed]
[ 3673.989016]  qede_fill_by_demand_stats+0x37/0x400 [qede]
[ 3673.989028]  qede_get_stats64+0x19/0xe0 [qede]
[ 3673.989034]  dev_get_stats+0x5c/0xc0
[ 3673.989045]  netstat_show.constprop.0+0x52/0xb0
[ 3673.989055]  dev_attr_show+0x19/0x40
[ 3673.989065]  sysfs_kf_seq_show+0x9b/0xf0
[ 3673.989076]  seq_read_iter+0x120/0x4b0
[ 3673.989087]  new_sync_read+0x118/0x1a0
[ 3673.989095]  vfs_read+0xf3/0x180
[ 3673.989099]  ksys_read+0x5f/0xe0
[ 3673.989102]  do_syscall_64+0x3b/0x90
[ 3673.989109]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 3673.989115] RIP: 0033:0x7f8467d0b082
[ 3673.989119] Code: c0 e9 b2 fe ff ff 50 48 8d 3d ca 05 08 00 e8 35 e7 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[ 3673.989121] RSP: 002b:00007ffffb21fd08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 3673.989127] RAX: ffffffffffffffda RBX: 000000000100eca0 RCX: 00007f8467d0b082
[ 3673.989128] RDX: 00000000000003ff RSI: 00007ffffb21fdc0 RDI: 0000000000000003
[ 3673.989130] RBP: 00007f8467b96028 R08: 0000000000000010 R09: 00007ffffb21ec00
[ 3673.989132] R10: 00007ffffb27b170 R11: 0000000000000246 R12: 00000000000000f0
[ 3673.989134] R13: 0000000000000003 R14: 00007f8467b92000 R15: 0000000000045a05
[ 3673.989139] CPU: 30 PID: 285188 Comm: read_all Kdump: loaded Tainted: G        W  OE

Fix this by having caller (QEDE driver flows) to provide the context whether
it could be in atomic context flow or not when getting the vport stats from
QED driver. QED driver based on the context provided decide to schedule out
or not when acquiring the PTT BAR window.

Fixes: 133fac0eedc3 ("qede: Add basic ethtool support")
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h | 12 +++++++-
 drivers/net/ethernet/qlogic/qed/qed_hw.c      | 28 +++++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_l2.c      | 11 ++++----
 drivers/net/ethernet/qlogic/qed/qed_l2.h      |  3 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c    |  4 +--
 drivers/net/ethernet/qlogic/qede/qede.h       |  2 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  6 ++--
 include/linux/qed/qed_eth_if.h                |  2 +-
 9 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
index f8682356d0cf..5e15a6a506c8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev_api.h
@@ -182,7 +182,7 @@ int qed_hw_prepare(struct qed_dev *cdev,
 void qed_hw_remove(struct qed_dev *cdev);
 
 /**
- * qed_ptt_acquire(): Allocate a PTT window.
+ * qed_ptt_acquire(): Allocate a PTT window in sleepable context.
  *
  * @p_hwfn: HW device data.
  *
@@ -193,6 +193,16 @@ void qed_hw_remove(struct qed_dev *cdev);
  */
 struct qed_ptt *qed_ptt_acquire(struct qed_hwfn *p_hwfn);
 
+/**
+ *  @brief _qed_ptt_acquire - Allocate a PTT window based on the context
+ *
+ *  @param p_hwfn
+ *  @param is_atomic - acquire ptt based on this context (sleepable or unsleepable)
+ *
+ *  @return struct qed_ptt
+ */
+struct qed_ptt *_qed_ptt_acquire(struct qed_hwfn *p_hwfn, bool is_atomic);
+
 /**
  * qed_ptt_release(): Release PTT Window.
  *
diff --git a/drivers/net/ethernet/qlogic/qed/qed_hw.c b/drivers/net/ethernet/qlogic/qed/qed_hw.c
index 554f30b0cfd5..4e8bfa0194e7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hw.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_hw.c
@@ -23,7 +23,10 @@
 #include "qed_reg_addr.h"
 #include "qed_sriov.h"
 
-#define QED_BAR_ACQUIRE_TIMEOUT 1000
+#define QED_BAR_ACQUIRE_TIMEOUT_USLEEP_CNT	1000
+#define QED_BAR_ACQUIRE_TIMEOUT_USLEEP		1000
+#define QED_BAR_ACQUIRE_TIMEOUT_UDELAY_CNT	100000
+#define QED_BAR_ACQUIRE_TIMEOUT_UDELAY		10
 
 /* Invalid values */
 #define QED_BAR_INVALID_OFFSET          (cpu_to_le32(-1))
@@ -83,13 +86,18 @@ void qed_ptt_pool_free(struct qed_hwfn *p_hwfn)
 	p_hwfn->p_ptt_pool = NULL;
 }
 
-struct qed_ptt *qed_ptt_acquire(struct qed_hwfn *p_hwfn)
+struct qed_ptt *_qed_ptt_acquire(struct qed_hwfn *p_hwfn, bool is_atomic)
 {
 	struct qed_ptt *p_ptt;
-	unsigned int i;
+	unsigned int i, count;
+
+	if (is_atomic)
+		count = QED_BAR_ACQUIRE_TIMEOUT_UDELAY_CNT;
+	else
+		count = QED_BAR_ACQUIRE_TIMEOUT_USLEEP_CNT;
 
 	/* Take the free PTT from the list */
-	for (i = 0; i < QED_BAR_ACQUIRE_TIMEOUT; i++) {
+	for (i = 0; i < count; i++) {
 		spin_lock_bh(&p_hwfn->p_ptt_pool->lock);
 
 		if (!list_empty(&p_hwfn->p_ptt_pool->free_list)) {
@@ -105,13 +113,23 @@ struct qed_ptt *qed_ptt_acquire(struct qed_hwfn *p_hwfn)
 		}
 
 		spin_unlock_bh(&p_hwfn->p_ptt_pool->lock);
-		usleep_range(1000, 2000);
+
+		if (is_atomic)
+			udelay(QED_BAR_ACQUIRE_TIMEOUT_UDELAY);
+		else
+			usleep_range(QED_BAR_ACQUIRE_TIMEOUT_USLEEP,
+				     QED_BAR_ACQUIRE_TIMEOUT_USLEEP * 2);
 	}
 
 	DP_NOTICE(p_hwfn, "PTT acquire timeout - failed to allocate PTT\n");
 	return NULL;
 }
 
+struct qed_ptt *qed_ptt_acquire(struct qed_hwfn *p_hwfn)
+{
+	return _qed_ptt_acquire(p_hwfn, false);
+}
+
 void qed_ptt_release(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	spin_lock_bh(&p_hwfn->p_ptt_pool->lock);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 2edd6bf64a3c..46d8d35dc7ac 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -1863,7 +1863,7 @@ static void __qed_get_vport_stats(struct qed_hwfn *p_hwfn,
 }
 
 static void _qed_get_vport_stats(struct qed_dev *cdev,
-				 struct qed_eth_stats *stats)
+				 struct qed_eth_stats *stats, bool is_atomic)
 {
 	u8 fw_vport = 0;
 	int i;
@@ -1872,7 +1872,7 @@ static void _qed_get_vport_stats(struct qed_dev *cdev,
 
 	for_each_hwfn(cdev, i) {
 		struct qed_hwfn *p_hwfn = &cdev->hwfns[i];
-		struct qed_ptt *p_ptt = IS_PF(cdev) ? qed_ptt_acquire(p_hwfn)
+		struct qed_ptt *p_ptt = IS_PF(cdev) ? _qed_ptt_acquire(p_hwfn, is_atomic)
 						    :  NULL;
 		bool b_get_port_stats;
 
@@ -1899,7 +1899,8 @@ static void _qed_get_vport_stats(struct qed_dev *cdev,
 	}
 }
 
-void qed_get_vport_stats(struct qed_dev *cdev, struct qed_eth_stats *stats)
+void qed_get_vport_stats(struct qed_dev *cdev, struct qed_eth_stats *stats,
+			 bool is_atomic)
 {
 	u32 i;
 
@@ -1908,7 +1909,7 @@ void qed_get_vport_stats(struct qed_dev *cdev, struct qed_eth_stats *stats)
 		return;
 	}
 
-	_qed_get_vport_stats(cdev, stats);
+	_qed_get_vport_stats(cdev, stats, is_atomic);
 
 	if (!cdev->reset_stats)
 		return;
@@ -1960,7 +1961,7 @@ void qed_reset_vport_stats(struct qed_dev *cdev)
 	if (!cdev->reset_stats) {
 		DP_INFO(cdev, "Reset stats not allocated\n");
 	} else {
-		_qed_get_vport_stats(cdev, cdev->reset_stats);
+		_qed_get_vport_stats(cdev, cdev->reset_stats, false);
 		cdev->reset_stats->common.link_change_count = 0;
 	}
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.h b/drivers/net/ethernet/qlogic/qed/qed_l2.h
index a538cf478c14..2bb93c50a2e4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.h
@@ -249,7 +249,8 @@ qed_sp_eth_rx_queues_update(struct qed_hwfn *p_hwfn,
 			    enum spq_mode comp_mode,
 			    struct qed_spq_comp_cb *p_comp_data);
 
-void qed_get_vport_stats(struct qed_dev *cdev, struct qed_eth_stats *stats);
+void qed_get_vport_stats(struct qed_dev *cdev,
+			 struct qed_eth_stats *stats, bool is_atomic);
 
 void qed_reset_vport_stats(struct qed_dev *cdev);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index c91898be7c03..307856c4ed22 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -3101,7 +3101,7 @@ void qed_get_protocol_stats(struct qed_dev *cdev,
 
 	switch (type) {
 	case QED_MCP_LAN_STATS:
-		qed_get_vport_stats(cdev, &eth_stats);
+		qed_get_vport_stats(cdev, &eth_stats, false);
 		stats->lan_stats.ucast_rx_pkts =
 					eth_stats.common.rx_ucast_pkts;
 		stats->lan_stats.ucast_tx_pkts =
@@ -3161,7 +3161,7 @@ qed_fill_generic_tlv_data(struct qed_dev *cdev, struct qed_mfw_tlv_generic *tlv)
 		}
 	}
 
-	qed_get_vport_stats(cdev, &stats);
+	qed_get_vport_stats(cdev, &stats, false);
 	p_common = &stats.common;
 	tlv->rx_frames = p_common->rx_ucast_pkts + p_common->rx_mcast_pkts +
 			 p_common->rx_bcast_pkts;
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index f90dcfe9ee68..312b1c2484fe 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -569,7 +569,7 @@ void qede_set_udp_tunnels(struct qede_dev *edev);
 void qede_reload(struct qede_dev *edev,
 		 struct qede_reload_args *args, bool is_locked);
 int qede_change_mtu(struct net_device *dev, int new_mtu);
-void qede_fill_by_demand_stats(struct qede_dev *edev);
+void qede_fill_by_demand_stats(struct qede_dev *edev, bool is_atomic);
 void __qede_lock(struct qede_dev *edev);
 void __qede_unlock(struct qede_dev *edev);
 bool qede_has_rx_work(struct qede_rx_queue *rxq);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8034d812d5a0..7e40e35d990c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -408,7 +408,7 @@ static void qede_get_ethtool_stats(struct net_device *dev,
 	struct qede_fastpath *fp;
 	int i;
 
-	qede_fill_by_demand_stats(edev);
+	qede_fill_by_demand_stats(edev, false);
 
 	/* Need to protect the access to the fastpath array */
 	__qede_lock(edev);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 953f304b8588..6c4187e5faa5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -301,12 +301,12 @@ module_exit(qede_cleanup);
 static int qede_open(struct net_device *ndev);
 static int qede_close(struct net_device *ndev);
 
-void qede_fill_by_demand_stats(struct qede_dev *edev)
+void qede_fill_by_demand_stats(struct qede_dev *edev, bool is_atomic)
 {
 	struct qede_stats_common *p_common = &edev->stats.common;
 	struct qed_eth_stats stats;
 
-	edev->ops->get_vport_stats(edev->cdev, &stats);
+	edev->ops->get_vport_stats(edev->cdev, &stats, is_atomic);
 
 	p_common->no_buff_discards = stats.common.no_buff_discards;
 	p_common->packet_too_big_discard = stats.common.packet_too_big_discard;
@@ -413,7 +413,7 @@ static void qede_get_stats64(struct net_device *dev,
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qede_stats_common *p_common;
 
-	qede_fill_by_demand_stats(edev);
+	qede_fill_by_demand_stats(edev, true);
 	p_common = &edev->stats.common;
 
 	stats->rx_packets = p_common->rx_ucast_pkts + p_common->rx_mcast_pkts +
diff --git a/include/linux/qed/qed_eth_if.h b/include/linux/qed/qed_eth_if.h
index e1bf3219b4e6..f2893b6b4cb3 100644
--- a/include/linux/qed/qed_eth_if.h
+++ b/include/linux/qed/qed_eth_if.h
@@ -319,7 +319,7 @@ struct qed_eth_ops {
 				  struct eth_slow_path_rx_cqe *cqe);
 
 	void (*get_vport_stats)(struct qed_dev *cdev,
-				struct qed_eth_stats *stats);
+				struct qed_eth_stats *stats, bool is_atomic);
 
 	int (*tunn_config)(struct qed_dev *cdev,
 			   struct qed_tunn_params *params);
-- 
2.27.0

