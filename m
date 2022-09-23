Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFCC5E7EE3
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiIWPr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiIWPqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:51 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A719DE8F;
        Fri, 23 Sep 2022 08:46:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgT+iIPFzSGGzznAS2tUd7KJ+BNSuEyF3PWpcJqw4rONmkvfqxK0/p47JkI8kQgHa4leq0cZsi9fQI5lDNYXHrYq50OSJhCqHlMGdzzDorrR3Nf7IFOZxJNC3Ee1xbX+Q6g2RF+njLyuB2/5bnqN0CzfpF+fyD4Xy7D1I4v7UT4Miw0qCZfo+7PoKMd+GwN5UEOFUCj4La9xVO8j3Ph0FcCexxyF4ksxhYFCgCjoRakQ1wOoo/Pj2fJMkCc64Dio+JawnVWYO3i7WQhmdHa4a3oIMT6CTaVO/E5fp2fQp20JxQvmFHcy/4qR7ngnq2aSSwD31Ooi7p3TUMKUEH5ryw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQLq0rYVbvSKT8gUe1nEJkdDIepuj0CC6eE1isPzDFE=;
 b=JmRpYChKPSgv/jmClDj3wXnBMB5VP4vsksvziJi6y3RmCyos3oV2eNo/mqNHkMx0kXnmF2vS2FgfYrgqpzajNR35ZL2jxmSCB7bHlkqnZBNUBitQIWZTpJT3Tg+/SFM5V/AzlphKZmEticf+8UdxsptP/ULE3P0b6ksAcJIGzNckFMgVgCQtGZE6wKAeGI2KYLrJS1mcpYDgqr0q25EF1yDyoeicZMGw6ob9HIhljx14OheCMpNLmfmcpQxVYEMPIJGpeKWNo7MNZ/4cSlbq8JrHCTlh9Zxdw/7hIIJtJm4dUHcbU1nQFzxLEkNThuVdvN1EHt7lEQXRv8CvptKo5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQLq0rYVbvSKT8gUe1nEJkdDIepuj0CC6eE1isPzDFE=;
 b=gY0wz8R23UyaLQR0xNU0/UVLVU+z3MKMKPmhwIyEak9lRAoUXjqSqjEUTmbBVd1bt+Mg6sEi72SOjsmAtoEbnIDepEsDEV27ZYDoIU/5vsWu/3+tMAaeuQAjih08jq6MnITm9ob0MnA3kDGnXJPZ3ZahgxPdR6Lwcw8P0tVWBqs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8996.eurprd04.prod.outlook.com (2603:10a6:20b:42f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:45 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:45 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 05/12] net: dpaa2-eth: export buffer pool info into a new debugfs file
Date:   Fri, 23 Sep 2022 18:45:49 +0300
Message-Id: <20220923154556.721511-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923154556.721511-1-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8996:EE_
X-MS-Office365-Filtering-Correlation-Id: ad503230-a736-4078-7c13-08da9d7ad13f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJaZ0ulF8/XYj+hHQ1zHg2KtnY+Z9DNKPp0o/jhGPn6s9a2K2Wr3PtslCyZdS8ZtJgKFpiofLp8ieUi/4zSR3iVhpdlDSbuMeyF3mGpUS4voA1Tznkr+1+v2/EJPpK5Ud+a1ZjhXC5tO22jrjU3BIVJO9fs7CygaBt7HJbKRrcT/zuzkGBXqwjfFADgLOiL2128qjt3DaX0OSX8cskcdH0v8iR7iX/HVQ4WuxjR7HRkUGFyfP4m0yzyk4lh6+y7dA76sYiEhdOdjuptlE/U56QYiYtBT5fjxT539nrZwSRAelYQIOGdU9lqWNS+agV0VhtHJOkPVwFsiNqc5OrYSy60eMRiWPnNxLPYx4sslDtZw7ZLGtW9NZ0j5fHzLRISo1qjqyxC/johBX825TI4+13AATc3CPj9Two5Plopi45HqKIiEYA+okvKhLH3LggEDLS3Pq+n6riSjeVe92keQzVSZZ8ATIFbRwVnTxRN+MYEnrs6NmYs+6IrSxvWxwCfJnnvRJpAiZm+15AgAfxNDymH2aW+oYpLdeenV/BWoRcY6weziUpskeK2aBnZIbaP909QOS78XQJrTOQpY0ngGJrlYB+SOucjf3EbshyBqQyVjhfJm+GzRE8jS4EXs7Coxa63fZztDD8hcqGwgZYClgmMWZbrdyPIFTpXb0AwIn+9kyo7kHDgqya0piJBg1GyeG7Z6Ugm+64MF9pCIjING/VIEVB4dIBdqq6tLToOsf53E95Syfh2l+BCc81pREWLIJLObXiKx5fns4otSf/PJtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(6486002)(36756003)(316002)(54906003)(2616005)(4326008)(38350700002)(1076003)(38100700002)(6512007)(26005)(86362001)(52116002)(66476007)(110136005)(186003)(6506007)(66946007)(2906002)(66556008)(478600001)(8676002)(41300700001)(5660300002)(44832011)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JNZEYIPpINXFLHnx2ervRMFh3xp/lCge282uMSXFzTFuus2QoT66eSOBRUts?=
 =?us-ascii?Q?AM4KcF/WHeOlEMorge8SreHsTFoWH0sYW13srgQMxX35fTwx1svl///+Uryw?=
 =?us-ascii?Q?5kzBXiyTBrgnA1KkdEQR6NFDVhIEo7/JSz2FszmL5oadSTUssneBhM+Y5GwG?=
 =?us-ascii?Q?mBrdtrhPj/TGSJL2gPIsKGNdzaM7erJmyepI6mLZqAG70uV8HZo2h6Q88LpZ?=
 =?us-ascii?Q?uX6A8I+ZdWN2Wti/ML49MmNSisA7Mxzoyd9kHJ0PUHPKK50VlyPelfrKkUuU?=
 =?us-ascii?Q?0oN/sxBdXxsZhhbzJDbpWKcX6JmEQuD6Vhh/GZ9EHbFg64YCJZwX19bcOAhU?=
 =?us-ascii?Q?M89b9PP0jUs31Em+kzNDJ8frayjjAtePUzm/GApsS1dkTvhLZEtSpKEvM7rv?=
 =?us-ascii?Q?rRRVaC/2TlewbvxuRSgUKqxpgASfScSXWZuRgbRWe+gkx2YmxhHdIjkJMY2o?=
 =?us-ascii?Q?+0rnzaltpCykdRsxeKQigJEORd5vNMGdGYAP1XRtoxmoBcFUa0JbYgonAimJ?=
 =?us-ascii?Q?n6oFQxrR7PukKDptfVvi1rUXDRLZhsq0CY5/SKKr6DijPn8JS+KR+WRsab8B?=
 =?us-ascii?Q?GNtXixvjSreRlwHu1Qw7LwWnOX3qzIfSDdYYoaJsPR1Q+RBk+bdq0tgigB4O?=
 =?us-ascii?Q?cddB/OnRcCEZbxPe11/d8jcU/cqpKqkTqhZ6iW7+wAoDRiPJILOB4D05EsaO?=
 =?us-ascii?Q?IeFtWvy+kG5A86wV3M1r+vjjfSlPrX2H8jkBBf61/drgdLCqgGlT4DZglVcR?=
 =?us-ascii?Q?Tr5gXVYG+L0L0W6Vfd8uuvaNJM8Y0AIACsVxU5PnAOwWES4MCE+hHO9wroYj?=
 =?us-ascii?Q?KD0aUh3lTqXGdT10W2699uyxIo/k4a/tqc26J8vFJiR7IAy2m6MKCwZvluwi?=
 =?us-ascii?Q?Vo2bd2B2eiuFMPNmRXs3CIMBnPjmrfE/Bqa2M+Hx8xjqvsMKRJ+lTMLGx/xa?=
 =?us-ascii?Q?3pcMnDCYmsDdVFssomG7ieef5po/BwBirsTRBwp5TTsttowtq3qgN6Ka0rfp?=
 =?us-ascii?Q?k+j44Luto38WkNYSIObyhW643k44zvx8WImw/+YMpFBvsR2bVJBSwrhtDr14?=
 =?us-ascii?Q?I0sRcgn4TlVMrrcXT7U+F23QyWtWi8Ysen5SQ2JmkZONDvM/pWQrMZw/Gbf+?=
 =?us-ascii?Q?NZ68mANK4NtO57cZZfFOX73JBFK7xGwFU2E5p1dlfoM/1LD7qaQFExFx8YVV?=
 =?us-ascii?Q?Hf/XKqMDi2XKzMFV8rtN1/gXCAOwCXGJGI321GNugKZRw7lkEp+pv4q9neq4?=
 =?us-ascii?Q?mRbvboTjfSCRUrt/BgrQ5TiPfJbDLXtO8QGfoYRuFStsCp9nXDu/sXJtI7iq?=
 =?us-ascii?Q?Zd5iOJgunJzCZtxrO+y1z/wncVOMfAll5PXu25pPgIHT/x57j0CNdcBtN+M2?=
 =?us-ascii?Q?4C1TnYUHqCI5qn35/zWS1ulH/pNC2M8CDvDZnrlg5KsK/+YRAQpj3Lvd25rq?=
 =?us-ascii?Q?dUFydn+8DcrsNuixftzClhvdBrznX43gCfqT7s5IauJNMNeNrflDtwYO5j5S?=
 =?us-ascii?Q?rugfJpmK+oG+1CQWAQqfoARTWfR5gaxTiGnARqCOhSZGrX15HuGx5bJSDjNq?=
 =?us-ascii?Q?K7hJe+bYTlQRwLenVaCFyWvVdF/3Z6FH5IOLNUZn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad503230-a736-4078-7c13-08da9d7ad13f
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:45.0078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKOG6YytOdWEP82BNI62IF5vTBWqEk5sG5xJMq3+Y8+FAyMRXFqU6Vi+Tg1HclpFdNneFKsjRzdlM+vSmGXT4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8996
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export the allocated buffer pools, the number of buffers that they have
currently and which channels are using which BP.

The output looks like below:

Buffer pool info for eth2:
IDX        BPID      Buf count      CH#0      CH#1      CH#2      CH#3
BP#0         1           5124         x         x         x         x

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../freescale/dpaa2/dpaa2-eth-debugfs.c       | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 54e7fcf95c89..1af254caeb0d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -119,6 +119,51 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 
 DEFINE_SHOW_ATTRIBUTE(dpaa2_dbg_ch);
 
+static int dpaa2_dbg_bp_show(struct seq_file *file, void *offset)
+{
+	struct dpaa2_eth_priv *priv = (struct dpaa2_eth_priv *)file->private;
+	int i, j, num_queues, buf_cnt;
+	struct dpaa2_eth_bp *bp;
+	char ch_name[10];
+	int err;
+
+	/* Print out the header */
+	seq_printf(file, "Buffer pool info for %s:\n", priv->net_dev->name);
+	seq_printf(file, "%s  %10s%15s", "IDX", "BPID", "Buf count");
+	num_queues = dpaa2_eth_queue_count(priv);
+	for (i = 0; i < num_queues; i++) {
+		snprintf(ch_name, sizeof(ch_name), "CH#%d", i);
+		seq_printf(file, "%10s", ch_name);
+	}
+	seq_printf(file, "\n");
+
+	/* For each buffer pool, print out its BPID, the number of buffers in
+	 * that buffer pool and the channels which are using it.
+	 */
+	for (i = 0; i < priv->num_bps; i++) {
+		bp = priv->bp[i];
+
+		err = dpaa2_io_query_bp_count(NULL, bp->bpid, &buf_cnt);
+		if (err) {
+			netdev_warn(priv->net_dev, "Buffer count query error %d\n", err);
+			return err;
+		}
+
+		seq_printf(file, "%3s%d%10d%15d", "BP#", i, bp->bpid, buf_cnt);
+		for (j = 0; j < num_queues; j++) {
+			if (priv->channel[j]->bp == bp)
+				seq_printf(file, "%10s", "x");
+			else
+				seq_printf(file, "%10s", "");
+		}
+		seq_printf(file, "\n");
+	}
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(dpaa2_dbg_bp);
+
 void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 {
 	struct fsl_mc_device *dpni_dev;
@@ -139,6 +184,10 @@ void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 
 	/* per-fq stats file */
 	debugfs_create_file("ch_stats", 0444, dir, priv, &dpaa2_dbg_ch_fops);
+
+	/* per buffer pool stats file */
+	debugfs_create_file("bp_stats", 0444, dir, priv, &dpaa2_dbg_bp_fops);
+
 }
 
 void dpaa2_dbg_remove(struct dpaa2_eth_priv *priv)
-- 
2.25.1

