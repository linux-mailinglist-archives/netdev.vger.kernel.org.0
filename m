Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618D4602E2E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiJROUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiJROT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:19:56 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00079.outbound.protection.outlook.com [40.107.0.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5475209B1;
        Tue, 18 Oct 2022 07:19:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPI5ytIKSR5ONuyjOydditwVyZFn6TqH68+jfjbObp5cg/MYW32WH14qgasYoGy8yKNLjzgGiryNZ8P4uoEH9pinJP2GN/NLdTciYP0PcwVtF/FmMlV21xO3mp2zdBcJruvKIxDhu0Y151vZ+j5ApVANEUyC5qc9iPz1zpwPdj82O6suqcX6Y03NineLYioVwWkA6uHpeUVh+eGlVr8O15FelyTWmb2BnE4tsM9LXJY9yymR/AQ/TKeblSCGda2kUkdvrkzd5YQVWbTVn/2V+/rNDUph4Cx36hfcg1g1RCZtocGIxIbyQcQy+3bQ5sn+8wqWsoBlGPwlht7u9x+U9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=om5/3Fa3Ngt/89BgxRVnuJSUI+YwVvLUV4H0kVUeAmU=;
 b=n1qSg9naPW0kV6yjjXBjXv4BfPLgFHsVeEStAbTQpXpqyRWkclpz0beSADWGtB/emDAM5Wb0/nKSnx+e2FhjxUecb2PdbYw2K4JbB7L/dJUyxmSBVfihjQs3K+nSRdxXPGwSsJrJPleB3OumNmQjUlI5YeVEjZtweWWZvU3ywLY6nkTY/IabISd8i+WduCmU8qY39Di9A/z6jcdmMhm0jYXV6YQXYzQI98qRs88hVGhx/U+AuLEekS4HaXiEHxti6+DTYF2QJXndZ9ljtr2AvaLzCMpF2W/tKULBesaU6YYa2prJ3XNOAoQKxfvCon8UK4VAnTiGNOsCEvZjjXMwtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=om5/3Fa3Ngt/89BgxRVnuJSUI+YwVvLUV4H0kVUeAmU=;
 b=dCanRQ8F7QJkeBS+WlZBsRTKMtkJL7qIwJNWt7Zy/V/fbosks76SSayDEx4AWgnD/PhFqj78lg5K9JYB45hEpvuKMbvGPijLWQvQ4SxjIOua/lrj1GVhY6whY4VuSbTP34COGo2DgY1fVycidYKtI6vnWqB27sFD24Xd3UGLmYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DU2PR04MB9145.eurprd04.prod.outlook.com (2603:10a6:10:2f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:35 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:34 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 05/12] net: dpaa2-eth: export buffer pool info into a new debugfs file
Date:   Tue, 18 Oct 2022 17:18:54 +0300
Message-Id: <20221018141901.147965-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|DU2PR04MB9145:EE_
X-MS-Office365-Filtering-Correlation-Id: ba211b2b-8596-42b2-e6aa-08dab113c81f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1Fpb6MbuuRjTXpJUJcFALldIl8b3cgt+K4ocu9bz6R3EyDW+yTsaa+xLrQAZ/Z4Iz4xQOI2p9oBdPJH6uvxTUWUelT0lmun1LVwoPyRYydYEG8c/eTE8Vv/CwFjT71ZMCmkYfZMgFki4yOOrSp9z82+x6gPO/zowHv/EkFYY2Bz+9P+64ezjk+HyrivNUXNyTikwwvRXrUZGJd07V3PhZtKDO5OCimj69CS25Rva8IfJfqmode9SEIpk9IvX17kneO4O6h3DHuKqZeQVa1WET4xupXZfFWbAg3kKnZ80S2w5026tR6Bk56+LLEwVTkkvUMzwNnPs9EGZQ4e7SnJgl9vBpJ2VWMYrtAQTCWPBGdFyFi8S+nP6U14k+Ree5YIShQW/avn12aRQ2/KzzKiY10H2kztLpvbahUTAv5mRnUIgj6r2R4Z0fQOX/OP6Cs61oV5wBMGTBlRx/tjsoHTQOFWL19UdPetujJdp1/dvL2ZSyg0nx65b7SsWf4jiTddSD6wjn/m9k6n2nF9snR+tKa3IGj49zisXv4iMMF0/4xroMD+lN4BI5r8nADlMXV47BTJshBewJu3iO77JaoQub9+vXF0PYjAaZ1YLQf1RuuIyxDSky6RI2xL/ah7sNkdSZFw/cRpxS5/MLRRqiqD+vsEGTyNlJwRadm+966luySdChg94NWV0fn3MSFgi5R6BNUskYvfj4ZtqHxnemkFnaSulAHsi5NgezYZKJd/l8MA+KHLOtE04bsHatMUN/c0FjpalQzqniiMKv+DB4ucJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199015)(110136005)(6486002)(54906003)(6506007)(478600001)(26005)(36756003)(2906002)(44832011)(6512007)(38350700002)(38100700002)(316002)(4326008)(6666004)(8676002)(186003)(66556008)(52116002)(7416002)(41300700001)(8936002)(5660300002)(2616005)(66476007)(86362001)(66946007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?piNOERr8Z2Ivwy84ZESCV8P+WuUjI5eF1JUhBw+68jX9cUAq1M+nBAFLjO6c?=
 =?us-ascii?Q?GMdDQ3ndbT9MIPUmBzbbW3HDHcKNrmx1G6QyJ60Qff8W+7kGKjJYHvSLRO3+?=
 =?us-ascii?Q?z6ek4jdOW2OaGd7J8fkl3vw28TYL5E3MMwTM0M6Buf5DgWuZOiZ4sTOLoS9L?=
 =?us-ascii?Q?eGE868NxPiH1CXNqHEbgD5Vizvgr1m8S0xm0vSTTCBKDhMFj/a0FbZ8e2AZw?=
 =?us-ascii?Q?H48+MsAWV/zTlzbM7mM+boAb3Zb/X32MpwJdwiqTrwextro2y/1RDUp1tc12?=
 =?us-ascii?Q?+AukLxxCtKtZsANtM5Y+z6wd58o+ycxV8cenNtA3Ua98Y9lGMyQX1EDy3rHM?=
 =?us-ascii?Q?7UVeJ5DqaiivlcswjEu0iQOJbTbtwQEJYByKZXXrB5IaRswZQRVtumSLLXCw?=
 =?us-ascii?Q?IzgEmejRkYELpAbf0Y9Gd/c0swigHMQ1tYb3UQY/2Jn1TCaX99LG+frGdSVx?=
 =?us-ascii?Q?jBhi00gpKmVmXfV+dP+3L8jQCs2x3qprFjW+lf1Pmny0SpLrgGH3IVCfSUFI?=
 =?us-ascii?Q?i3g9zLO2rrGUgRNi6n2SGupCGGEgaetkJXzvZQrOV5LfRMjgxn9gDnurkAzX?=
 =?us-ascii?Q?l3pG2t94xBBW3ReUOjRN4238HpwziHzIpRrRa1poc5+v91td1W3yuh6l8g3j?=
 =?us-ascii?Q?SVadAFB0QVsEUz3pv5Wu9+cxF0ynXUPgrMLQ+3b+QYCNd0UzmHCSoIxClLYA?=
 =?us-ascii?Q?geRvscaaORdkeLFVAvB8wo41mjak7swSM66+wvEFcAd5PEGbHLJJd0jcEMEL?=
 =?us-ascii?Q?4mF8eEnm834oRrM5oyIqpmyXtD4QGnwI93LQO0+zn77R0XoH7ttjnkSrFVl3?=
 =?us-ascii?Q?KjGHUAPJ2wRBP/CKnromTLuO93PEJOYEewOZNKS6zexggg2aKE2JFdmqRU0a?=
 =?us-ascii?Q?1jatfM2Q1c+gHV8yxdAkxR5LYCRU5YgynZQnGknJOwp/MJpOOA9oTuXlRh4+?=
 =?us-ascii?Q?BibgpbaTqZq09sIMG6IPRVi+q1ZsbufOKAVGL1/3valIniEL5457XGub4Qh9?=
 =?us-ascii?Q?kjqyThfHJ94MqB5YX6Om4PduYFjcoWthx4ge/IxnODbQZUtsp1iCqQ64v0Ml?=
 =?us-ascii?Q?Vvn/3c9zti/DrQ8pfU4Hdpm7vvcsfIGz1NdIzE6tIHDTEFTzbv/vVIYy9Vr1?=
 =?us-ascii?Q?IGmSzT/iwoJ3TMOHtDEdwhNvwXNmlF3xxNWBIA6gZHA5Nvld4vRTAFzQWEDh?=
 =?us-ascii?Q?GCWv/Av8TS+lDSK3x3fh5ufcdRLeNA/zjm7CYvT9m9L05BpwtuOTXkQHvwfZ?=
 =?us-ascii?Q?91lyFbnf8V/L+iqS5lfbTBQ1lgOoG8pP6yEVSWWo9U6HPwuGZkx5OMgQefB1?=
 =?us-ascii?Q?BQs7SU5ls6nwOLPfPc+hmlSms5MYe/mZlDsOhhuA02wStWDfy31ILCAlX5Gb?=
 =?us-ascii?Q?G9aVGq6TAvYAkcjSrCRBMDwgrU9ydnaHYiUUT+7k8ADqsc1aGuyui9Od/CyL?=
 =?us-ascii?Q?NHmL85QPFtvVdU6lv/FUGRu5OgYtK0s5qtQgL7iER/xA+788Bcs+Suy9N2AC?=
 =?us-ascii?Q?oHwT7U3tYoGNc54Nq8EpzstrYVE3UlvUA7TmWD2xLSQSu210YRQN2imUWjvC?=
 =?us-ascii?Q?9oX+mOeCBd8DQKzJ2/7S97wzgklKfcW/8s8jAPaS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba211b2b-8596-42b2-e6aa-08dab113c81f
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:34.8874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZEE5JSPn8C+zLyy3F6E/IA/OT9PqAnDvotoB99jFpDRDsS0Y7tyIvtW/vf4cU7/VzfSBaf5Ftka9REoDhrYDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9145
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
Changes in v3:
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

