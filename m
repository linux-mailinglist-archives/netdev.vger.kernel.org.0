Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CD15ED140
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbiI0XuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiI0Xta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:49:30 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD04D1D983D;
        Tue, 27 Sep 2022 16:48:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyElL/FF/jhyYo9RT1WG6v+gRk/hBnySyMlK6XSrlOKXFUToLoKhUR4aGw0xsMLimUrP24uVTm/V+rF0HLj2kvbGkcd9OvkQ0P1u63IvTMJ7i1IaOm/70PXdgXzLk3ALuJemzc9l9npoyLUYhvtuk/EKkh6ZPq+penWmZsSsuORl0dsbYRXk7Qp7SHzPmmYd8dwxNbcDjGXbhLH3EZPA7Mxe2iyEUHgASrxKIM8vMr9IrSQmhCSnkDdumUb7FOfkbt0DzcmmzK1WWvVPQdLZc8ZQcH75Qai+/m6TUHz6ezBo8J7fzljetf/iMGPmrZcLmNMU2KKIxzA4vBrhAKWkKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhjdW8+kQiEUx8E/PIKOnug/ItS5WoqfM30DiT7cNTY=;
 b=NzZopajgWizMhgL4KjthZcn8kPXUfvctUoRPJfJghbs000vKX6q//AtJA0MWb5GWU7OWLeAz150UCcPjR9/q7IJBFbHhobfeXmKfkQb2q5wu3GUCqgmujXTlfFt4tIKZsOrDNsInJNQUuF9IPggh7tirWyhum4W2DHUZP0l1IjgoLt75cXhGMj5ibLIYRX24Ma1a5dBx6mHVLXr6PdKVwIO0bDi2QxlwecfGo1TnWkFAqsJB4IGHU8U7zfhKO4k0x3C+p+OQTLgK6eQl7MlQgIiUQ2NLsMyursws7PHMdRI9gyzq9nxpc/OhYuwA9ZfpozgTIUmXqUmjUVs907/5Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhjdW8+kQiEUx8E/PIKOnug/ItS5WoqfM30DiT7cNTY=;
 b=Dx1RRyWQAwkYFEZnQIgfwMBm8kiD9UfD1oeRe7xOZcBcOfexFwkAzJ1aRJ8FICJOm3Yz2B1IXd8Ja7L/7dymAj0hiQOIU3e5s8bcMUfcKs1a0rxMpnzd5t6tYhAxxFo6Ce/+926mPEF3Q+fsjS4u8i4IMjAQSEcyGPYjRvWnSoA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9444.eurprd04.prod.outlook.com (2603:10a6:10:35c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 23:48:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 23:48:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 7/8] net: enetc: use common naming scheme for PTGCR and PTGCAPR registers
Date:   Wed, 28 Sep 2022 02:47:45 +0300
Message-Id: <20220927234746.1823648-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
References: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0025.eurprd05.prod.outlook.com
 (2603:10a6:800:60::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: 0277a776-efca-49c2-e21d-08daa0e2baf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pxu3V4lGZTLCFpJ6jk715voF0pnucqs9b+rnj85MIJJ5PQ0GhPN8jeWBTzcxOpfap5c+PsyMvOI4KSC/xvecdigXJQtkyj6u4ZXnCmQuz+958CqsZfaCGrqo6NI95GCaNch65BM2W7pua8F7RcpHX/kqZ7dX6jO/8kLfP0tcQK/BFypBK5hTTNnRPfGFq3INOdZ3ugkRtm/UmADxs4jwvHGzpVqa+TxlInVHoI3nlCpuB7jx/dfoUU9OHLF48QDzpGYIFBddjxBW5Toz+VsKl8djwlpViWsPE7JAGdt6/iVjl3GqvFd5q0kG9MA6woo6gRaycnIJLoe9eDzGEtxPdhpFOtrsbNAgy89eVdt75NpYSYsPH10EdGM8ZPSsxE/oM6QD+R7pyD77OZS3YRGA7P8otVKtogOub7w2Qk1ouW9GHZAG+1/MfOMvtFns2eDeBGkP/iKwtugGj73ou3sMj8AUYrknZiN4HPSclL9M73uzvoHl79SfW1F7rIA2s84O8uNf8D4GryMx2L4s1szOREkN0M2OzEOTB/I3AryFkDp9okMGjFnd0hHMSdLtU5GPvXIwfRBJaURgdq1B6c/GRiC+7N/uC57jSI5LV0WKlN2zvzqrlJEjb39wN4MyW/vwGh6onlEZp3eybjjst19xarned9Ix+gXi6cpuacfQdXbOBA62rJl0dESI1lfrztH2NTKWxMfJFH0zDjQ0FY5PsEVJDaHOC3UfW1qxc1vBM0xhiM35ojTaq3IdDiR808iPCYvbkIAj/Sl8kIkHii4XaPFl3aNnBnruIo1IE0o24u0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(7416002)(6512007)(966005)(41300700001)(6666004)(36756003)(6486002)(38350700002)(6506007)(6916009)(8676002)(86362001)(66476007)(4326008)(26005)(52116002)(8936002)(66946007)(83380400001)(38100700002)(316002)(54906003)(186003)(1076003)(2906002)(5660300002)(66556008)(478600001)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E+KlFIdwRx+uP7z2WYzUzP6YCYqDLU6bdFQwxdF5KENOGYFEdtXn6yuAnnuC?=
 =?us-ascii?Q?CiL0kU44bm/En9H6akWDtdR+H5lSoznwdkWRDOXEy4jUIweOEnwAj2mcmZQl?=
 =?us-ascii?Q?gJgvqeFtXka+D9SQn5wxFTArDUvIp+uPcJ9wTzP9/UBCObNqyvhT3BVahxRN?=
 =?us-ascii?Q?9Y4Sv0O5CkVJLFVLgiZP330mliR3zatc6uKmyxWkStZFZAkWfka2Y+heNQD+?=
 =?us-ascii?Q?HNK/DbCthkpK8AbgaUgsvWkD80JoFn8xojWfyYlfiRmBUOpdZCXwPVMAkohW?=
 =?us-ascii?Q?ff3oElFgamlUzMbpDtnqiFK90bhuPJTAEM/MS8k4MHRjbBpCFbUrbQl8vOkc?=
 =?us-ascii?Q?Hj5H9vinHaVsYdjrxSuM1aD6P/jQ9PHdb9hOvKWlIrD80lF7zXRZjk1DkvhY?=
 =?us-ascii?Q?BTCs+g56htMue1ajT6nIk9Bnkv9PO54+otmqtX6hORc2k7kPqgyL4u+F6jVD?=
 =?us-ascii?Q?Yu9ppMW8pxd6lzQbfvcOtic4D9cY1tWHtkuO2QCsMQ/kQgk7gsowx9BTNLZy?=
 =?us-ascii?Q?/JwtQIvqRMJuEn2FjfHV3MHfX8D9/3yWS0F82MN16W8bcGpjQyWPBoyh1Idm?=
 =?us-ascii?Q?tO7kAVXKbgI/Vp8TViUShEdTNv9aMGeybJ66SPrhTTZmE8yTq/6WAqxBQMoh?=
 =?us-ascii?Q?CJXjmnbMEhdDEr9OOTk6DUMyuYaseq/hYzhk6YLDlxD58SCYOuaLJO400DLZ?=
 =?us-ascii?Q?UzE63ISNhjmjfoyJTSDgd4lnqHHRrIrUk3OnDOuNP5B+Ss29mvzn1c6W221f?=
 =?us-ascii?Q?ne6R4I//504H6TitYHuAgz0eVBCFmBrJQBxXIwQojN2gR/cqHo/BXA+Z7DCg?=
 =?us-ascii?Q?/65Bl8FwwKB2uu1L5/4fTDr9gya86lnY/EY1G9a0d8x4DTcvpEeNwzD4HU7Q?=
 =?us-ascii?Q?REp7WxK+1Zw3wtjY3agqUmpe1/y4nKlEppItw3qtC9zqLaj3qcm6TLj8NVsM?=
 =?us-ascii?Q?FnBpgyfKdorQKdUfqtr9Gkd2+Qa7p9MyCIxKzs27gH6PtXVbWkTK+qdsRXiG?=
 =?us-ascii?Q?++LxQPEfdaaDQpOdtvI3oWE4Nqn2Z5CDfai1nGpNmOAJYnrK0uMt8jiCqsOE?=
 =?us-ascii?Q?uLT0P9SQXSQaT2DbvMhU5SiybvdJpce+BNaEDpoWsYzv/Qx4eXynfe1cpAMO?=
 =?us-ascii?Q?wvIHNLJUxabdPrHybZ65nNfU53n+CMWanE16cNniBTpN34qFPJXJw/QO3g8a?=
 =?us-ascii?Q?SHpMSeUj9Gl8YR/OysQeT+TBGScJnA3/p0e6rKT+tqovf4+OjQb+wbc65suY?=
 =?us-ascii?Q?L9nFMViA4MKGuzldm+4g9WaW6BG2rmDYsjXAH7DdXnJ9Yd19k41cZy3K7XgG?=
 =?us-ascii?Q?oaS4GF63GRY4OkypOBCrMYZbN0dRbHZWWIxWIpAw0u/IGrWs+Xl0LjknPzr1?=
 =?us-ascii?Q?9gT+SyRFo0EvHEty713J3+aBOTs+inWRT2P7SM7+kXMS7YlExRWZdCWetC4G?=
 =?us-ascii?Q?SArMKslFWvwrRcHxqUKT326pocfyyOVI/LStmFfzK3vOuVhZSe0xvNtT/F69?=
 =?us-ascii?Q?lheoz2X2o7UtWnHfTYAd0FaE6nB4eUCYFOuEvrp/Pud8mFKULVjVvEBJzZhL?=
 =?us-ascii?Q?JJhHn8VkkQO1QwFyoNAe6GE14H4zIqLkadQxmjxJK6NYpvaxv1OLT4r8NHs4?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0277a776-efca-49c2-e21d-08daa0e2baf4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 23:48:08.7572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UY8LsPvSYY1/qhuH6XIR/kA3JzVAOEIxjxteB2uBofysK+KESwx96i9shlxyR5N0H4cU8rU4jEyEO79IJFnSVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Port Time Gating Control Register (PTGCR) and Port Time Gating
Capability Register (PTGCAPR) have definitions in the driver which
aren't in line with the other registers. Rename these.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new (actually taken from the separate preliminary
series at https://patchwork.kernel.org/project/netdevbpf/patch/20220921144349.1529150-2-vladimir.oltean@nxp.com/)
v2->v3: none

 drivers/net/ethernet/freescale/enetc/enetc_hw.h  | 10 +++++-----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 13 ++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 0b85e37a00eb..18ca1f42b1f7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -945,13 +945,13 @@ static inline u32 enetc_usecs_to_cycles(u32 usecs)
 }
 
 /* port time gating control register */
-#define ENETC_QBV_PTGCR_OFFSET		0x11a00
-#define ENETC_QBV_TGE			BIT(31)
-#define ENETC_QBV_TGPE			BIT(30)
+#define ENETC_PTGCR			0x11a00
+#define ENETC_PTGCR_TGE			BIT(31)
+#define ENETC_PTGCR_TGPE		BIT(30)
 
 /* Port time gating capability register */
-#define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
-#define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
+#define ENETC_PTGCAPR			0x11a08
+#define ENETC_PTGCAPR_MAX_GCL_LEN_MASK	GENMASK(15, 0)
 
 /* Port time specific departure */
 #define ENETC_PTCTSDR(n)	(0x1210 + 4 * (n))
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 2e783ef73690..ee28cb62afe8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -11,8 +11,7 @@
 
 static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 {
-	return enetc_rd(hw, ENETC_QBV_PTGCAPR_OFFSET)
-		& ENETC_QBV_MAX_GCL_LEN_MASK;
+	return enetc_rd(hw, ENETC_PTGCAPR) & ENETC_PTGCAPR_MAX_GCL_LEN_MASK;
 }
 
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
@@ -65,9 +64,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		return -EINVAL;
 	gcl_len = admin_conf->num_entries;
 
-	tge = enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET);
+	tge = enetc_rd(hw, ENETC_PTGCR);
 	if (!admin_conf->enable) {
-		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -115,11 +114,11 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
-	enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge | ENETC_QBV_TGE);
+	enetc_wr(hw, ENETC_PTGCR, tge | ENETC_PTGCR_TGE);
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
-		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
 
 	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
@@ -299,7 +298,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
-	if (enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
+	if (enetc_rd(hw, ENETC_PTGCR) & ENETC_PTGCR_TGE)
 		return -EBUSY;
 
 	priv->tx_ring[tc]->tsd_enable = qopt->enable;
-- 
2.34.1

