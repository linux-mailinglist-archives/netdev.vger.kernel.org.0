Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77F53D5862
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhGZKg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:36:26 -0400
Received: from mail-bn8nam12on2137.outbound.protection.outlook.com ([40.107.237.137]:14689
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232813AbhGZKgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 06:36:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRGVxkGr4C1Q4tE1t5mEhkINER0MsnHeWmgE8a3SmLTyI01pL3Xk9GEvn0E5RwYH9kHNvcOuYiSYoywRFFYZqNAt8WHxhFH7EnkR2MVqovTv8iYpGN9E8sydoD91FAeS8jbftg1W+jxB0NM8XxIkxiYvHQASv0TE0BP0mlD3ISWubVOHJwujY9Xo8baxl3oqGo2F4auOeDaGcQbF/X4uR6PkUN4XFft+JPp3KmQkq7pC6m5ayJqLTLGuQllMXx8ErRZmyRrHT9uL7Yrv2Lrt5Qn+GGwmAN7Lp12GwQCiKmZf/us5yK6KpxwJUcDY56PaAnoZ54Avp1CCxSpxIJ+amg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HndNRk+mnJqj72BXgT6ILbSzIJc5RvVdA3Jx9j3TsjE=;
 b=Hf/jVXoegGXrFGaQdDig/PrAve18lJCe4a/wJUGB2NSKXdvsPXBF88hMY0Y2GhnfgQOXmh0W6IufGRBov6cUMMKaCmegcF5m6PLB5xXL+MN8SWUMmGKQtDUmED+grPsJm4wqFOIE/uc6f12QLm4MdRwF1sJx1YzGK+W6DfgrTePw6YJ2kJbl+HcDfjf5M/ocVLd6HCAMW2zai9FG4CgAnqBCwYGZI29UAO3ywKqr16cdhQoQvq1qHX9OXIMK6nzZJa0CxBwypBMzZHcu4iHHMdk/qm00rThKIRbCEOoWv3XGvCpDhge8V+oWCpLnDEQDTLHFHq2XhyMaHwV/jWHhxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HndNRk+mnJqj72BXgT6ILbSzIJc5RvVdA3Jx9j3TsjE=;
 b=mBKxuvN/JscZ81VDywq5dXJ3046WcuFdhKXwWWtbFiQebj0FFj2czsS3DejKcF1X8OJECJdMZwtrq5J+36ZbVkN8pUDUHiNCKMIBoAu6D3lU89mMb3Kt/UZzIH1Jasy+n/lYwOEeQ76DGokfOn4dep+DJM+3feyiev2b/7V9+W8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5051.namprd13.prod.outlook.com (2603:10b6:510:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.12; Mon, 26 Jul
 2021 11:16:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.016; Mon, 26 Jul 2021
 11:16:52 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Yu Xiao <yu.xiao@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: add support for coalesce adaptive feature
Date:   Mon, 26 Jul 2021 13:16:34 +0200
Message-Id: <20210726111634.24524-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0015.eurprd03.prod.outlook.com
 (2603:10a6:205:2::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM4PR0302CA0015.eurprd03.prod.outlook.com (2603:10a6:205:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Mon, 26 Jul 2021 11:16:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb69ceb0-c058-4d63-70cb-08d95026de5f
X-MS-TrafficTypeDiagnostic: PH0PR13MB5051:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB50513F05E3A1887598A3B604E8E89@PH0PR13MB5051.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iHy+jNwP7+juuuGTbuk8JWwidmMpIN+lsv7klHB8ZLecKInizF4Vv/0MFyesw0+0ewX7ImiDxrINrYKWxFRX8OxX99Vz0r7YTK4idN4jviWBHA1vgtiiz+bd78SjDGFBEx52qv19Bxp4st+3oeGP3c5Lz9xFRAaMsxn+Mf7rsYgf5kD/MW7ye0sOwXWmK8P4Nohh2WEgK4LYOMJd5Zt78v5JkXkpE5auPS1eChgNyRdqTITr8jD7usq8wvM5XNF3Ykc0HpWFbkeasvqigDoxvieF548to5VcjJpTR1EMjmh20Nz9Z5SDcnS5iuyaz/BfggNHAU1Dl2XMF4AhLG1DtJmaxvmwnv076mjB9jClwIPkBGHXz1xY6F1Wau00V1wyTraNMR7ec4z6fN3w5QYyjD1ESCbryCl0JA8/OrGLwRuk4wPrPCsYv/jqRY7N7/SRG8HZFMaNlsIJRHcfKt2aKMARxFSD2qUGl7yimjfC6qxrC3uGplMXRu0LFz9ay2kdC/1eH9SoRWIxisiwQGDjEHC8KKdVHUIO9mwWT4lzh874kxVoIJMQ5kZzw+Jhli3EN1/WrwDb50OYquoJA0gkm4ERuD03ewf9R4XjqrDzI6MoJZzS/IAekumHF+Y5AHy1pCli5lE9TPiAFH/RiLdR4nULAsou+Mqj7YIhzoEGuUrAWS3iG2t6mK10+6Af5G8U+sDo2SfRGJvDxvbaB/+FnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39830400003)(366004)(136003)(5660300002)(38100700002)(66476007)(66946007)(66556008)(186003)(86362001)(4326008)(8676002)(478600001)(6512007)(2616005)(83380400001)(6666004)(6486002)(8936002)(36756003)(107886003)(110136005)(30864003)(44832011)(2906002)(54906003)(6506007)(52116002)(316002)(1076003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UIa+LGoHSTdiyJfKCu33znQqtbWRUI5hg9nJYcRlvQXyHtLQw5Gj0RRq9/fA?=
 =?us-ascii?Q?GLPKb1unzNlVXUqyHTKYewmiRFkbLq8pQ3iJPI+GtqXsdZpypw0gnsni3TwB?=
 =?us-ascii?Q?MChBPfFCHr6/lS7fUDe/a5/1u7ml3ofM9wZl2afUvhmuoEHKl+0rIKrUYGh7?=
 =?us-ascii?Q?3Pec6NypDa2i2GPXAJLHeissmNGoeXWvbH974xUIGvtEqj3Hfp5AkL0/nOIc?=
 =?us-ascii?Q?YgM2PZpB1SATVC/92JngFEMKjBtjmyX7qG8VAGN4ZSs3s3R+jWcAx7kk85Sh?=
 =?us-ascii?Q?EArKjgY0QtdcGYH6sZXILPII4KO22bqaKcWR/+4XVXnNTwR0VBhzV19P6F6Q?=
 =?us-ascii?Q?quo0L0uAB9H2i9g1xP2dAgfYkPW/9kY4NrUe5vrFHNX+QSTkwuQHo/w99F7o?=
 =?us-ascii?Q?7Li5MtjuBS8UqCzXcGHUOYrJRLlQrZR7MA6luPPA/+eOR9m0lVZcgMXW1byI?=
 =?us-ascii?Q?zWNgQGxVaaFda+ACqtos/7Tx+FX5yVltJyMimBgiilmhUyiA5UgOxdGlwVxF?=
 =?us-ascii?Q?ATDsDickCP+EqWyLfYWZZ0yyJGemd9OuI4bzh4fFFz8cIzhB5GV8bM1VO0e1?=
 =?us-ascii?Q?7y4UUEgfIZ8sqSRGnmXYXVeoRVj/hJC/DySkBbOiJkX2rvM1qNaU+aHgEXwT?=
 =?us-ascii?Q?pusHxdbTp0SlPTAFvjOOBQEUep3j+69jkDIhzJfbRDI36ltARz8m/K/mCReS?=
 =?us-ascii?Q?kJ1CzTjeGsPbF9uEx+NHjDQUCBmRk61Jw0Gvq3AZtIrYGpZIHv1moJa4EK6E?=
 =?us-ascii?Q?xNWjuZcOI6BNH4003YgGZxUsl68N2f88U0vgNLCtX3lhklJowDV1fWs2KQUk?=
 =?us-ascii?Q?NYJcbwM2l6iJuFCGaCYGvZNbY84z3hr5SfXeeCZFlF6W+FTvMnn5i1uKADK6?=
 =?us-ascii?Q?4OrQrv+rIA7H4V0H5J0b9ngLdEEKs4hDBPf2yRYwOkj7L79U2dy4JqRZohbq?=
 =?us-ascii?Q?2JgyORGRoV7BmKY6GkJDg+6UbKVrzWRyJn9/becIziuax5uX55XA0DFvsOZF?=
 =?us-ascii?Q?Bwwlqi0+VA3b/ctCHKiyc39Zup0Z0DJBjefM08YAwHRcbmrpJXmEMCcopuQL?=
 =?us-ascii?Q?A1wQ/Mg0XRYK7vux49p7p7fb4Y7bfX5THgADTVYVGxR4MRZYbcdjDar0AUnY?=
 =?us-ascii?Q?P9vPA5ngq2SJAp2/EtaVdljWWOa0M3jvflToEcVHXHWDyz7SUleJMctku0w6?=
 =?us-ascii?Q?Ruq1b1aGg5HkMtGwaumOC2gXc3tv5ON/tD0IxP2qBtZj7slkiZT2Wi58WOvA?=
 =?us-ascii?Q?wJBnRfOS8EOwr1Rc3q62jFzVzrTPR6MNRFWeNLbQeFjcesVytv/vM9e5Sqt4?=
 =?us-ascii?Q?qLukj7ZQUEj3454a50vX6FXQZhBsycFTPIlhs/XGXt4cY5DN9wlOQsacUNWF?=
 =?us-ascii?Q?snIVlqWnS/jf+VujrDT8afq6xqdT?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb69ceb0-c058-4d63-70cb-08d95026de5f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 11:16:52.0835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8DbYzkaHo2hEan9SUd0xM89fNJNhsjU0mlH/a66QpZMdClrp1494HjPlsgZVdYVUe5FDAGQdRqhlVzbPMyHsVxT6DOzoGaGD4mMxrkF+5+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Use dynamic interrupt moderation library to implement coalesce
adaptive feature for nfp driver.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/Kconfig        |   1 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  20 +++
 .../ethernet/netronome/nfp/nfp_net_common.c   | 131 +++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  21 +--
 4 files changed, 160 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index b82758d5beed..8844d1ac053a 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -23,6 +23,7 @@ config NFP
 	depends on TLS && TLS_DEVICE || TLS_DEVICE=n
 	select NET_DEVLINK
 	select CRC32
+	select DIMLIB
 	help
 	  This driver supports the Netronome(R) NFP4000/NFP6000 based
 	  cards working as a advanced Ethernet NIC.  It works with both
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index df5b748be068..df203738511b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -17,6 +17,7 @@
 #include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
+#include <linux/dim.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/semaphore.h>
 #include <linux/workqueue.h>
@@ -360,6 +361,9 @@ struct nfp_net_rx_ring {
  * @rx_ring:        Pointer to RX ring
  * @xdp_ring:	    Pointer to an extra TX ring for XDP
  * @irq_entry:      MSI-X table entry (use for talking to the device)
+ * @event_ctr:	    Number of interrupt
+ * @rx_dim:	    Dynamic interrupt moderation structure for RX
+ * @tx_dim:	    Dynamic interrupt moderation structure for TX
  * @rx_sync:	    Seqlock for atomic updates of RX stats
  * @rx_pkts:        Number of received packets
  * @rx_bytes:	    Number of received bytes
@@ -410,6 +414,10 @@ struct nfp_net_r_vector {
 
 	u16 irq_entry;
 
+	u16 event_ctr;
+	struct dim rx_dim;
+	struct dim tx_dim;
+
 	struct u64_stats_sync rx_sync;
 	u64 rx_pkts;
 	u64 rx_bytes;
@@ -571,6 +579,8 @@ struct nfp_net_dp {
  *			mailbox area, crypto TLV
  * @link_up:            Is the link up?
  * @link_status_lock:	Protects @link_* and ensures atomicity with BAR reading
+ * @rx_coalesce_adapt_on:   Is RX interrupt moderation adaptive?
+ * @tx_coalesce_adapt_on:   Is TX interrupt moderation adaptive?
  * @rx_coalesce_usecs:      RX interrupt moderation usecs delay parameter
  * @rx_coalesce_max_frames: RX interrupt moderation frame count parameter
  * @tx_coalesce_usecs:      TX interrupt moderation usecs delay parameter
@@ -654,6 +664,8 @@ struct nfp_net {
 
 	struct semaphore bar_lock;
 
+	bool rx_coalesce_adapt_on;
+	bool tx_coalesce_adapt_on;
 	u32 rx_coalesce_usecs;
 	u32 rx_coalesce_max_frames;
 	u32 tx_coalesce_usecs;
@@ -919,6 +931,14 @@ static inline bool nfp_netdev_is_nfp_net(struct net_device *netdev)
 	return netdev->netdev_ops == &nfp_net_netdev_ops;
 }
 
+static inline int nfp_net_coalesce_para_check(u32 usecs, u32 pkts)
+{
+	if ((usecs >= ((1 << 16) - 1)) || (pkts >= ((1 << 16) - 1)))
+		return -EINVAL;
+
+	return 0;
+}
+
 /* Prototypes */
 void nfp_net_get_fw_version(struct nfp_net_fw_version *fw_ver,
 			    void __iomem *ctrl_bar);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index ed2ade2a4f04..15078f9dc9f1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -474,6 +474,12 @@ static irqreturn_t nfp_net_irq_rxtx(int irq, void *data)
 {
 	struct nfp_net_r_vector *r_vec = data;
 
+	/* Currently we cannot tell if it's a rx or tx interrupt,
+	 * since dim does not need accurate event_ctr to calculate,
+	 * we just use this counter for both rx and tx dim.
+	 */
+	r_vec->event_ctr++;
+
 	napi_schedule_irqoff(&r_vec->napi);
 
 	/* The FW auto-masks any interrupt, either via the MASK bit in
@@ -2061,6 +2067,36 @@ static int nfp_net_poll(struct napi_struct *napi, int budget)
 		if (napi_complete_done(napi, pkts_polled))
 			nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
 
+	if (r_vec->nfp_net->rx_coalesce_adapt_on) {
+		struct dim_sample dim_sample = {};
+		unsigned int start;
+		u64 pkts, bytes;
+
+		do {
+			start = u64_stats_fetch_begin(&r_vec->rx_sync);
+			pkts = r_vec->rx_pkts;
+			bytes = r_vec->rx_bytes;
+		} while (u64_stats_fetch_retry(&r_vec->rx_sync, start));
+
+		dim_update_sample(r_vec->event_ctr, pkts, bytes, &dim_sample);
+		net_dim(&r_vec->rx_dim, dim_sample);
+	}
+
+	if (r_vec->nfp_net->tx_coalesce_adapt_on) {
+		struct dim_sample dim_sample = {};
+		unsigned int start;
+		u64 pkts, bytes;
+
+		do {
+			start = u64_stats_fetch_begin(&r_vec->tx_sync);
+			pkts = r_vec->tx_pkts;
+			bytes = r_vec->tx_bytes;
+		} while (u64_stats_fetch_retry(&r_vec->tx_sync, start));
+
+		dim_update_sample(r_vec->event_ctr, pkts, bytes, &dim_sample);
+		net_dim(&r_vec->tx_dim, dim_sample);
+	}
+
 	return pkts_polled;
 }
 
@@ -2873,6 +2909,7 @@ static int nfp_net_set_config_and_enable(struct nfp_net *nn)
  */
 static void nfp_net_close_stack(struct nfp_net *nn)
 {
+	struct nfp_net_r_vector *r_vec;
 	unsigned int r;
 
 	disable_irq(nn->irq_entries[NFP_NET_IRQ_LSC_IDX].vector);
@@ -2880,8 +2917,16 @@ static void nfp_net_close_stack(struct nfp_net *nn)
 	nn->link_up = false;
 
 	for (r = 0; r < nn->dp.num_r_vecs; r++) {
-		disable_irq(nn->r_vecs[r].irq_vector);
-		napi_disable(&nn->r_vecs[r].napi);
+		r_vec = &nn->r_vecs[r];
+
+		disable_irq(r_vec->irq_vector);
+		napi_disable(&r_vec->napi);
+
+		if (r_vec->rx_ring)
+			cancel_work_sync(&r_vec->rx_dim.work);
+
+		if (r_vec->tx_ring)
+			cancel_work_sync(&r_vec->tx_dim.work);
 	}
 
 	netif_tx_disable(nn->dp.netdev);
@@ -2948,17 +2993,92 @@ void nfp_ctrl_close(struct nfp_net *nn)
 	rtnl_unlock();
 }
 
+static void nfp_net_rx_dim_work(struct work_struct *work)
+{
+	struct nfp_net_r_vector *r_vec;
+	unsigned int factor, value;
+	struct dim_cq_moder moder;
+	struct nfp_net *nn;
+	struct dim *dim;
+
+	dim = container_of(work, struct dim, work);
+	moder = net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
+	r_vec = container_of(dim, struct nfp_net_r_vector, rx_dim);
+	nn = r_vec->nfp_net;
+
+	/* Compute factor used to convert coalesce '_usecs' parameters to
+	 * ME timestamp ticks.  There are 16 ME clock cycles for each timestamp
+	 * count.
+	 */
+	factor = nn->tlv_caps.me_freq_mhz / 16;
+	if (nfp_net_coalesce_para_check(factor * moder.usec, moder.pkts))
+		return;
+
+	/* copy RX interrupt coalesce parameters */
+	value = (moder.pkts << 16) | (factor * moder.usec);
+	rtnl_lock();
+	nn_writel(nn, NFP_NET_CFG_RXR_IRQ_MOD(r_vec->rx_ring->idx), value);
+	(void)nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_IRQMOD);
+	rtnl_unlock();
+
+	dim->state = DIM_START_MEASURE;
+}
+
+static void nfp_net_tx_dim_work(struct work_struct *work)
+{
+	struct nfp_net_r_vector *r_vec;
+	unsigned int factor, value;
+	struct dim_cq_moder moder;
+	struct nfp_net *nn;
+	struct dim *dim;
+
+	dim = container_of(work, struct dim, work);
+	moder = net_dim_get_tx_moderation(dim->mode, dim->profile_ix);
+	r_vec = container_of(dim, struct nfp_net_r_vector, tx_dim);
+	nn = r_vec->nfp_net;
+
+	/* Compute factor used to convert coalesce '_usecs' parameters to
+	 * ME timestamp ticks.  There are 16 ME clock cycles for each timestamp
+	 * count.
+	 */
+	factor = nn->tlv_caps.me_freq_mhz / 16;
+	if (nfp_net_coalesce_para_check(factor * moder.usec, moder.pkts))
+		return;
+
+	/* copy TX interrupt coalesce parameters */
+	value = (moder.pkts << 16) | (factor * moder.usec);
+	rtnl_lock();
+	nn_writel(nn, NFP_NET_CFG_TXR_IRQ_MOD(r_vec->tx_ring->idx), value);
+	(void)nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_IRQMOD);
+	rtnl_unlock();
+
+	dim->state = DIM_START_MEASURE;
+}
+
 /**
  * nfp_net_open_stack() - Start the device from stack's perspective
  * @nn:      NFP Net device to reconfigure
  */
 static void nfp_net_open_stack(struct nfp_net *nn)
 {
+	struct nfp_net_r_vector *r_vec;
 	unsigned int r;
 
 	for (r = 0; r < nn->dp.num_r_vecs; r++) {
-		napi_enable(&nn->r_vecs[r].napi);
-		enable_irq(nn->r_vecs[r].irq_vector);
+		r_vec = &nn->r_vecs[r];
+
+		if (r_vec->rx_ring) {
+			INIT_WORK(&r_vec->rx_dim.work, nfp_net_rx_dim_work);
+			r_vec->rx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+		}
+
+		if (r_vec->tx_ring) {
+			INIT_WORK(&r_vec->tx_dim.work, nfp_net_tx_dim_work);
+			r_vec->tx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+		}
+
+		napi_enable(&r_vec->napi);
+		enable_irq(r_vec->irq_vector);
 	}
 
 	netif_tx_wake_all_queues(nn->dp.netdev);
@@ -3893,6 +4013,9 @@ static void nfp_net_irqmod_init(struct nfp_net *nn)
 	nn->rx_coalesce_max_frames = 64;
 	nn->tx_coalesce_usecs      = 50;
 	nn->tx_coalesce_max_frames = 64;
+
+	nn->rx_coalesce_adapt_on   = true;
+	nn->tx_coalesce_adapt_on   = true;
 }
 
 static void nfp_net_netdev_init(struct nfp_net *nn)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 1b482446536d..a213784ffa54 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1083,6 +1083,9 @@ static int nfp_net_get_coalesce(struct net_device *netdev,
 	if (!(nn->cap & NFP_NET_CFG_CTRL_IRQMOD))
 		return -EINVAL;
 
+	ec->use_adaptive_rx_coalesce = nn->rx_coalesce_adapt_on;
+	ec->use_adaptive_tx_coalesce = nn->tx_coalesce_adapt_on;
+
 	ec->rx_coalesce_usecs       = nn->rx_coalesce_usecs;
 	ec->rx_max_coalesced_frames = nn->rx_coalesce_max_frames;
 	ec->tx_coalesce_usecs       = nn->tx_coalesce_usecs;
@@ -1359,19 +1362,18 @@ static int nfp_net_set_coalesce(struct net_device *netdev,
 	if (!ec->tx_coalesce_usecs && !ec->tx_max_coalesced_frames)
 		return -EINVAL;
 
-	if (ec->rx_coalesce_usecs * factor >= ((1 << 16) - 1))
-		return -EINVAL;
-
-	if (ec->tx_coalesce_usecs * factor >= ((1 << 16) - 1))
+	if (nfp_net_coalesce_para_check(ec->rx_coalesce_usecs * factor,
+					ec->rx_max_coalesced_frames))
 		return -EINVAL;
 
-	if (ec->rx_max_coalesced_frames >= ((1 << 16) - 1))
-		return -EINVAL;
-
-	if (ec->tx_max_coalesced_frames >= ((1 << 16) - 1))
+	if (nfp_net_coalesce_para_check(ec->tx_coalesce_usecs * factor,
+					ec->tx_max_coalesced_frames))
 		return -EINVAL;
 
 	/* configuration is valid */
+	nn->rx_coalesce_adapt_on = !!ec->use_adaptive_rx_coalesce;
+	nn->tx_coalesce_adapt_on = !!ec->use_adaptive_tx_coalesce;
+
 	nn->rx_coalesce_usecs      = ec->rx_coalesce_usecs;
 	nn->rx_coalesce_max_frames = ec->rx_max_coalesced_frames;
 	nn->tx_coalesce_usecs      = ec->tx_coalesce_usecs;
@@ -1443,7 +1445,8 @@ static int nfp_net_set_channels(struct net_device *netdev,
 
 static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-				     ETHTOOL_COALESCE_MAX_FRAMES,
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo		= nfp_net_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_ringparam		= nfp_net_get_ringparam,
-- 
2.20.1

