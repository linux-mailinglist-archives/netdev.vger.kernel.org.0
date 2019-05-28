Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A642BDB1
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 05:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfE1DYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 23:24:05 -0400
Received: from mail-eopbgr700064.outbound.protection.outlook.com ([40.107.70.64]:6776
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727342AbfE1DYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 23:24:04 -0400
Received: from DM5PR07CA0090.namprd07.prod.outlook.com (2603:10b6:4:ae::19) by
 MWHPR07MB2880.namprd07.prod.outlook.com (2603:10b6:300:1f::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Tue, 28 May 2019 03:24:02 +0000
Received: from DM3NAM05FT027.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::207) by DM5PR07CA0090.outlook.office365.com
 (2603:10b6:4:ae::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.16 via Frontend
 Transport; Tue, 28 May 2019 03:24:02 +0000
Authentication-Results: spf=fail (sender IP is 199.233.58.38)
 smtp.mailfrom=marvell.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=fail action=none
 header.from=marvell.com;
Received-SPF: Fail (protection.outlook.com: domain of marvell.com does not
 designate 199.233.58.38 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.233.58.38; helo=CAEXCH02.caveonetworks.com;
Received: from CAEXCH02.caveonetworks.com (199.233.58.38) by
 DM3NAM05FT027.mail.protection.outlook.com (10.152.98.138) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id
 15.20.1943.9 via Frontend Transport; Tue, 28 May 2019 03:24:01 +0000
Received: from dut1171.mv.qlogic.com (10.112.88.18) by
 CAEXCH02.caveonetworks.com (10.67.98.110) with Microsoft SMTP Server (TLS) id
 14.2.347.0; Mon, 27 May 2019 20:21:49 -0700
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])    by
 dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x4S3LpOi005792;    Mon, 27
 May 2019 20:21:51 -0700
Received: (from root@localhost) by dut1171.mv.qlogic.com
 (8.14.7/8.14.7/Submit) id x4S3Lpxv005791;      Mon, 27 May 2019 20:21:51 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 2/2] qede: Handle infinite driver spinning for Tx timestamp.
Date:   Mon, 27 May 2019 20:21:33 -0700
Message-ID: <20190528032133.5745-3-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190528032133.5745-1-skalluru@marvell.com>
References: <20190528032133.5745-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Matching-Connectors: 132034874419313032;(abac79dc-c90b-41ba-8033-08d666125e47);(abac79dc-c90b-41ba-8033-08d666125e47)
X-Forefront-Antispam-Report: CIP:199.233.58.38;IPV:CAL;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(39850400004)(136003)(2980300002)(1110001)(339900001)(199004)(189003)(476003)(50466002)(305945005)(126002)(36756003)(26826003)(498600001)(86362001)(87636003)(486006)(81156014)(81166006)(14444005)(4326008)(47776003)(11346002)(8936002)(446003)(1076003)(2616005)(70206006)(76130400001)(70586007)(68736007)(2906002)(50226002)(48376002)(316002)(42186006)(36906005)(69596002)(85426001)(356004)(51416003)(54906003)(76176011)(8676002)(6666004)(2351001)(5660300002)(26005)(80596001)(105606002)(53936002)(107886003)(16586007)(6862004)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR07MB2880;H:CAEXCH02.caveonetworks.com;FPR:;SPF:Fail;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f628843-38bc-4588-aaf1-08d6e31bee30
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:MWHPR07MB2880;
X-MS-TrafficTypeDiagnostic: MWHPR07MB2880:
X-Microsoft-Antispam-PRVS: <MWHPR07MB2880553A3F127643959F351AD31E0@MWHPR07MB2880.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 00514A2FE6
X-Microsoft-Antispam-Message-Info: k3ctPf0EEEtgbLD3iBJ7DYAmyiMVDzDqoBbOkdXqjZWc16jzx3FEkJ+kgstctsCQ8FECz+p8nXA1mnmSydpqSIbQ5/Q/JWOzG917QiKl689YdRgZ2zPXSWFV4E5d2g7RpQj+zoGe1OF81pbHGt+JlrSRa79M/PEqWw82CKNma4NnV3JiD0McEqceLa0YsXUEd5VzwhGDqw5S4jRJ2xlZAxGHCg5dZqiqZVU/Z98e6d/DxO/gOhGfxIsaEF2eqH4anob7dFzwiS/uua0L6hZ0s+MIaq6uXxl6uB5WcVl4TNPtYEgEUuRnGzc3s5xMnLNj+UD+nuUTw235+ffbkc7tsHH+LgPne0BMiL4Ex6vpTbxY77YXfPpBcfHynAm5QHJL+Ecx/KnpJqRVu9YOrD37NvEEDNvqLAfXg5PcrNlbzVA=
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2019 03:24:01.5089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f628843-38bc-4588-aaf1-08d6e31bee30
X-MS-Exchange-CrossTenant-Id: 5afe0b00-7697-4969-b663-5eab37d5f47e
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5afe0b00-7697-4969-b663-5eab37d5f47e;Ip=[199.233.58.38];Helo=[CAEXCH02.caveonetworks.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR07MB2880
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In PTP Tx implementation, driver kept scheduling a poll thread until the
timestamp is available. In the error scenarios (e.g. app requesting the
timestamp for non-ptp packet), this thread kept waiting for the timestamp
forever.  This patch add changes to report such scenario as an error and
terminate the thread. Added a timeout of 2 seconds i.e., max time to wait
for Tx timestamp. Added a stat value ptp_skip_txts for reporting the number
of packets for which Tx timestamping is skipped. 

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h         |  2 ++
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c |  1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c    |  3 ++
 drivers/net/ethernet/qlogic/qede/qede_ptp.c     | 37 ++++++++++++++++++++-----
 4 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 92fe226..b972ab0 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -92,6 +92,7 @@ struct qede_stats_common {
 	u64 non_coalesced_pkts;
 	u64 coalesced_bytes;
 	u64 link_change_count;
+	u64 ptp_skip_txts;
 
 	/* port */
 	u64 rx_64_byte_packets;
@@ -189,6 +190,7 @@ struct qede_dev {
 
 	const struct qed_eth_ops	*ops;
 	struct qede_ptp			*ptp;
+	u64				ptp_skip_txts;
 
 	struct qed_dev_eth_info dev_info;
 #define QEDE_MAX_RSS_CNT(edev)	((edev)->dev_info.num_queues)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8911a97..e85f9fe 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -174,6 +174,7 @@
 	QEDE_STAT(coalesced_bytes),
 
 	QEDE_STAT(link_change_count),
+	QEDE_STAT(ptp_skip_txts),
 };
 
 #define QEDE_NUM_STATS	ARRAY_SIZE(qede_stats_arr)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index a9684a8..741377b 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -390,6 +390,7 @@ void qede_fill_by_demand_stats(struct qede_dev *edev)
 	p_common->brb_discards = stats.common.brb_discards;
 	p_common->tx_mac_ctrl_frames = stats.common.tx_mac_ctrl_frames;
 	p_common->link_change_count = stats.common.link_change_count;
+	p_common->ptp_skip_txts = edev->ptp_skip_txts;
 
 	if (QEDE_IS_BB(edev)) {
 		struct qede_stats_bb *p_bb = &edev->stats.bb;
@@ -2232,6 +2233,8 @@ static void qede_unload(struct qede_dev *edev, enum qede_unload_mode mode,
 	if (mode != QEDE_UNLOAD_RECOVERY)
 		DP_NOTICE(edev, "Link is down\n");
 
+	edev->ptp_skip_txts = 0;
+
 	DP_INFO(edev, "Ending qede unload\n");
 }
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index bddb2b5..f815435 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 #include "qede_ptp.h"
+#define QEDE_PTP_TX_TIMEOUT (2 * HZ)
 
 struct qede_ptp {
 	const struct qed_eth_ptp_ops	*ops;
@@ -38,6 +39,7 @@ struct qede_ptp {
 	struct timecounter		tc;
 	struct ptp_clock		*clock;
 	struct work_struct		work;
+	unsigned long			ptp_tx_start;
 	struct qede_dev			*edev;
 	struct sk_buff			*tx_skb;
 
@@ -160,18 +162,30 @@ static void qede_ptp_task(struct work_struct *work)
 	struct qede_dev *edev;
 	struct qede_ptp *ptp;
 	u64 timestamp, ns;
+	bool timedout;
 	int rc;
 
 	ptp = container_of(work, struct qede_ptp, work);
 	edev = ptp->edev;
+	timedout = time_is_before_jiffies(ptp->ptp_tx_start +
+					  QEDE_PTP_TX_TIMEOUT);
 
 	/* Read Tx timestamp registers */
 	spin_lock_bh(&ptp->lock);
 	rc = ptp->ops->read_tx_ts(edev->cdev, &timestamp);
 	spin_unlock_bh(&ptp->lock);
 	if (rc) {
-		/* Reschedule to keep checking for a valid timestamp value */
-		schedule_work(&ptp->work);
+		if (unlikely(timedout)) {
+			DP_INFO(edev, "Tx timestamp is not recorded\n");
+			dev_kfree_skb_any(ptp->tx_skb);
+			ptp->tx_skb = NULL;
+			clear_bit_unlock(QEDE_FLAGS_PTP_TX_IN_PRORGESS,
+					 &edev->flags);
+			edev->ptp_skip_txts++;
+		} else {
+			/* Reschedule to keep checking for a valid TS value */
+			schedule_work(&ptp->work);
+		}
 		return;
 	}
 
@@ -514,19 +528,28 @@ void qede_ptp_tx_ts(struct qede_dev *edev, struct sk_buff *skb)
 	if (!ptp)
 		return;
 
-	if (test_and_set_bit_lock(QEDE_FLAGS_PTP_TX_IN_PRORGESS, &edev->flags))
+	if (test_and_set_bit_lock(QEDE_FLAGS_PTP_TX_IN_PRORGESS,
+				  &edev->flags)) {
+		DP_ERR(edev, "Timestamping in progress\n");
+		edev->ptp_skip_txts++;
 		return;
+	}
 
 	if (unlikely(!test_bit(QEDE_FLAGS_TX_TIMESTAMPING_EN, &edev->flags))) {
-		DP_NOTICE(edev,
-			  "Tx timestamping was not enabled, this packet will not be timestamped\n");
+		DP_ERR(edev,
+		       "Tx timestamping was not enabled, this packet will not be timestamped\n");
+		clear_bit_unlock(QEDE_FLAGS_PTP_TX_IN_PRORGESS, &edev->flags);
+		edev->ptp_skip_txts++;
 	} else if (unlikely(ptp->tx_skb)) {
-		DP_NOTICE(edev,
-			  "The device supports only a single outstanding packet to timestamp, this packet will not be timestamped\n");
+		DP_ERR(edev,
+		       "The device supports only a single outstanding packet to timestamp, this packet will not be timestamped\n");
+		clear_bit_unlock(QEDE_FLAGS_PTP_TX_IN_PRORGESS, &edev->flags);
+		edev->ptp_skip_txts++;
 	} else {
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		/* schedule check for Tx timestamp */
 		ptp->tx_skb = skb_get(skb);
+		ptp->ptp_tx_start = jiffies;
 		schedule_work(&ptp->work);
 	}
 }
-- 
1.8.3.1

