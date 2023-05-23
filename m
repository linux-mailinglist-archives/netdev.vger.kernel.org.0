Return-Path: <netdev+bounces-4707-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0554970DF8D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEEEB28137D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59011F189;
	Tue, 23 May 2023 14:42:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59B61F183
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:42:55 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A36E9
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:42:51 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NBkCX0029572;
	Tue, 23 May 2023 07:42:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=99eyv8CE7SX9Cg8+kZkx7RC+58duW+DZXPVbH10r3sk=;
 b=OPJchz/TxKn98B4aa2g82g1Jgi45Lw20sgPBTriDbbNCZs2oXwz29i4FIiIc2BzR3FLX
 S97L9QyzOqh+oN9/fg/yGbDV2J2SwPbP3kSb17ybibUmwCBVfLqZTwFZE4ftmQS3JtIE
 ReGNub5VZ7ghtDnDhsx1vB6IDKcFjd4MBZ67/on61mGky/GrSvSHboTtrA55UcFwHFjV
 gXaFIVjmW7/3Mh2mS4RWn/bncceXo55r727cTGPoMzndpHw2hSGX0IHAVz7VKsCbPWDf
 XRZ99pmTiX6gn68XM+hpts3NyCbVfwyfSTBOdqEkAPLy1sFjpsggRJmN1h4I1Qgg0obB Wg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3qrm46jscg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 07:42:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 23 May
 2023 07:42:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 23 May 2023 07:42:40 -0700
Received: from falcon.marvell.com (unknown [10.30.46.95])
	by maili.marvell.com (Postfix) with ESMTP id DE1E53F7074;
	Tue, 23 May 2023 07:42:38 -0700 (PDT)
From: Manish Chopra <manishc@marvell.com>
To: <kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <aelior@marvell.com>, <palok@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH v5 net] qede: Fix scheduling while atomic
Date: Tue, 23 May 2023 20:12:35 +0530
Message-ID: <20230523144235.672290-1-manishc@marvell.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: zWRlYDDEQiWOccWtgyUyoGalKzlwzY42
X-Proofpoint-GUID: zWRlYDDEQiWOccWtgyUyoGalKzlwzY42
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_10,2023-05-23_02,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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

Fix this by collecting the statistics asynchronously from a periodic
delayed work scheduled at default stats coalescing interval and return
the recent copy of statisitcs from .ndo_get_stats64(), also add ability
to configure/retrieve stats coalescing interval using below commands -

ethtool -C ethx stats-block-usecs <val>
ethtool -c ethx

Fixes: 133fac0eedc3 ("qede: Add basic ethtool support")
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Manish Chopra <manishc@marvell.com>
---
v1->v2:
 - Fixed checkpatch and kdoc warnings.
v2->v3:
 - Moving the changelog after tags.
v3->v4:
 - Changes to collect stats periodically using delayed work
   and add ability to configure/retrieve stats coalescing
   interval using ethtool
 - Modified commit description to reflect the changes
v4->v5:
 - Renamed the variables (s/ticks/usecs and s/interval/ticks)
 - Relaxed the stats usecs coalescing configuration to allow
   user to set any range of values and also while getting return
   the exact value configured
 - Usage of usecs_to_jiffies() wherever applicable
 - Cosmetic change for logs/comments
---
 drivers/net/ethernet/qlogic/qede/qede.h       |  4 +++
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 26 ++++++++++++--
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 35 ++++++++++++++++++-
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index f90dcfe9ee68..8a63f99d499c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -271,6 +271,10 @@ struct qede_dev {
 #define QEDE_ERR_WARN			3
 
 	struct qede_dump_info		dump_info;
+	struct delayed_work		periodic_task;
+	unsigned long			stats_coal_ticks;
+	u32				stats_coal_usecs;
+	spinlock_t			stats_lock; /* lock for vport stats access */
 };
 
 enum QEDE_STATE {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8284c4c1528f..a6498eb7cbd7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -426,6 +426,8 @@ static void qede_get_ethtool_stats(struct net_device *dev,
 		}
 	}
 
+	spin_lock(&edev->stats_lock);
+
 	for (i = 0; i < QEDE_NUM_STATS; i++) {
 		if (qede_is_irrelevant_stat(edev, i))
 			continue;
@@ -435,6 +437,8 @@ static void qede_get_ethtool_stats(struct net_device *dev,
 		buf++;
 	}
 
+	spin_unlock(&edev->stats_lock);
+
 	__qede_unlock(edev);
 }
 
@@ -817,6 +821,7 @@ static int qede_get_coalesce(struct net_device *dev,
 
 	coal->rx_coalesce_usecs = rx_coal;
 	coal->tx_coalesce_usecs = tx_coal;
+	coal->stats_block_coalesce_usecs = edev->stats_coal_usecs;
 
 	return rc;
 }
@@ -830,6 +835,21 @@ int qede_set_coalesce(struct net_device *dev, struct ethtool_coalesce *coal,
 	int i, rc = 0;
 	u16 rxc, txc;
 
+	if (edev->stats_coal_usecs != coal->stats_block_coalesce_usecs) {
+		bool stats_coal_enabled;
+
+		stats_coal_enabled = edev->stats_coal_usecs ? true : false;
+
+		edev->stats_coal_usecs = coal->stats_block_coalesce_usecs;
+		edev->stats_coal_ticks = usecs_to_jiffies(coal->stats_block_coalesce_usecs);
+
+		if (!stats_coal_enabled)
+			schedule_delayed_work(&edev->periodic_task, 0);
+
+		DP_INFO(edev, "Configured stats coal ticks=%lu jiffies\n",
+			edev->stats_coal_ticks);
+	}
+
 	if (!netif_running(dev)) {
 		DP_INFO(edev, "Interface is down\n");
 		return -EINVAL;
@@ -2236,7 +2256,8 @@ static int qede_get_per_coalesce(struct net_device *dev,
 }
 
 static const struct ethtool_ops qede_ethtool_ops = {
-	.supported_coalesce_params	= ETHTOOL_COALESCE_USECS,
+	.supported_coalesce_params	= ETHTOOL_COALESCE_USECS |
+					  ETHTOOL_COALESCE_STATS_BLOCK_USECS,
 	.get_link_ksettings		= qede_get_link_ksettings,
 	.set_link_ksettings		= qede_set_link_ksettings,
 	.get_drvinfo			= qede_get_drvinfo,
@@ -2287,7 +2308,8 @@ static const struct ethtool_ops qede_ethtool_ops = {
 };
 
 static const struct ethtool_ops qede_vf_ethtool_ops = {
-	.supported_coalesce_params	= ETHTOOL_COALESCE_USECS,
+	.supported_coalesce_params	= ETHTOOL_COALESCE_USECS |
+					  ETHTOOL_COALESCE_STATS_BLOCK_USECS,
 	.get_link_ksettings		= qede_get_link_ksettings,
 	.get_drvinfo			= qede_get_drvinfo,
 	.get_msglevel			= qede_get_msglevel,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 06c6a5813606..61cc10968988 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -308,6 +308,8 @@ void qede_fill_by_demand_stats(struct qede_dev *edev)
 
 	edev->ops->get_vport_stats(edev->cdev, &stats);
 
+	spin_lock(&edev->stats_lock);
+
 	p_common->no_buff_discards = stats.common.no_buff_discards;
 	p_common->packet_too_big_discard = stats.common.packet_too_big_discard;
 	p_common->ttl0_discard = stats.common.ttl0_discard;
@@ -405,6 +407,8 @@ void qede_fill_by_demand_stats(struct qede_dev *edev)
 		p_ah->tx_1519_to_max_byte_packets =
 		    stats.ah.tx_1519_to_max_byte_packets;
 	}
+
+	spin_unlock(&edev->stats_lock);
 }
 
 static void qede_get_stats64(struct net_device *dev,
@@ -413,9 +417,10 @@ static void qede_get_stats64(struct net_device *dev,
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qede_stats_common *p_common;
 
-	qede_fill_by_demand_stats(edev);
 	p_common = &edev->stats.common;
 
+	spin_lock(&edev->stats_lock);
+
 	stats->rx_packets = p_common->rx_ucast_pkts + p_common->rx_mcast_pkts +
 			    p_common->rx_bcast_pkts;
 	stats->tx_packets = p_common->tx_ucast_pkts + p_common->tx_mcast_pkts +
@@ -435,6 +440,8 @@ static void qede_get_stats64(struct net_device *dev,
 		stats->collisions = edev->stats.bb.tx_total_collisions;
 	stats->rx_crc_errors = p_common->rx_crc_errors;
 	stats->rx_frame_errors = p_common->rx_align_errors;
+
+	spin_unlock(&edev->stats_lock);
 }
 
 #ifdef CONFIG_QED_SRIOV
@@ -1000,6 +1007,21 @@ static void qede_unlock(struct qede_dev *edev)
 	rtnl_unlock();
 }
 
+static void qede_periodic_task(struct work_struct *work)
+{
+	struct qede_dev *edev = container_of(work, struct qede_dev,
+					     periodic_task.work);
+
+	if (test_bit(QEDE_SP_DISABLE, &edev->sp_flags))
+		return;
+
+	if (edev->stats_coal_usecs) {
+		qede_fill_by_demand_stats(edev);
+		schedule_delayed_work(&edev->periodic_task,
+				      edev->stats_coal_ticks);
+	}
+}
+
 static void qede_sp_task(struct work_struct *work)
 {
 	struct qede_dev *edev = container_of(work, struct qede_dev,
@@ -1208,7 +1230,9 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 		 * from there, although it's unlikely].
 		 */
 		INIT_DELAYED_WORK(&edev->sp_task, qede_sp_task);
+		INIT_DELAYED_WORK(&edev->periodic_task, qede_periodic_task);
 		mutex_init(&edev->qede_lock);
+		spin_lock_init(&edev->stats_lock);
 
 		rc = register_netdev(edev->ndev);
 		if (rc) {
@@ -1233,6 +1257,11 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 	edev->rx_copybreak = QEDE_RX_HDR_SIZE;
 
 	qede_log_probe(edev);
+
+	edev->stats_coal_usecs = USEC_PER_SEC;
+	edev->stats_coal_ticks = usecs_to_jiffies(USEC_PER_SEC);
+	schedule_delayed_work(&edev->periodic_task, 0);
+
 	return 0;
 
 err4:
@@ -1301,6 +1330,7 @@ static void __qede_remove(struct pci_dev *pdev, enum qede_remove_mode mode)
 		unregister_netdev(ndev);
 
 		cancel_delayed_work_sync(&edev->sp_task);
+		cancel_delayed_work_sync(&edev->periodic_task);
 
 		edev->ops->common->set_power_state(cdev, PCI_D0);
 
@@ -2571,6 +2601,9 @@ static void qede_recovery_handler(struct qede_dev *edev)
 
 	DP_NOTICE(edev, "Starting a recovery process\n");
 
+	/* disable periodic stats */
+	edev->stats_coal_usecs = 0;
+
 	/* No need to acquire first the qede_lock since is done by qede_sp_task
 	 * before calling this function.
 	 */
-- 
2.27.0


