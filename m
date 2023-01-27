Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D8167DA9A
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjA0ARy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjA0ARn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:17:43 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C06716AC9
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:17:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGFOkpnoC7S/b14SpKvP5bOsvksZXQuvpeOC115CNyN68HpjeEw9wSEN7ZFWLMf0N7BU9Cu3ptTpcz3XN4IDEBCKKoWaCsCbQy8ckXZt3EOs7GQ8A5nppAHXemiw7KGV4442On5G72MH0btobP3Y7AMIDQA7tGPm4715Kl3ncUN81o3u3bKlfzh1+eZTP5cFXLOWLyW06UkHWyaSPSFAAu62SHqsfgic+0erse9fZpSMV6FL8S+5ud25r+NDyo8bW43ArbDui2RMdb5x8IY0I/qyc3+Z0MXBKXxkbdlKvq17gwgp/vNJTQeHUWuo9YncDeD6b9PiXUZW6TWxWaJI2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lFTeqHFU6lleEUre86P3enXRU8Qi7neSml3N6ZLJS4=;
 b=e3s1wkpu2jeVvbMG5kyyT/q6p7BY22xKWii2ACHSGtjqR2Qj6w+/RuSyR3jdDXCF4IJW+EwPMCagbw80jgui/gp1zBdnD1Kk7x5nv1THkgkGrDBZhMu1ADPK6YwG2AzLJzjxHuzsN9+mtMmrId3Tat+bmQ//aCotDznrBZ6kB1fgdTlUOeOF3iCvR0oOxpq+BgJI9rpBmPd7wv0Q5f/9uP0+BHfrauo/lBOYK9TyywNq+Ss9CXPr1vpP737alld84Wyx5ifbLq8c9Igw4z/VnCw0ihCwfkhhiytfBSp+f4yzXHU5GSYRjzjrHFVN1+icGaln0daLMxMR2uDKdw8ACQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lFTeqHFU6lleEUre86P3enXRU8Qi7neSml3N6ZLJS4=;
 b=e+6UyxWzlrjdvbU6X2TtZ7u4dp6YLaHGjPovp97sFW10aUxjIyS3CdEG/USXW6yfrqNMI8pQvYttkwqhjHpUEI+vGdSGe+BN2LwFYXyI//c1m9vQNweNuQzcsYf7eM3hs+aZCVC7JXiH8c3JoCfWS4jpy/s7vtLYZtE+FtO08Mg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Igor Russkikh <irusskikh@marvell.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 07/15] net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
Date:   Fri, 27 Jan 2023 02:15:08 +0200
Message-Id: <20230127001516.592984-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: d1825a1f-ade7-4eab-47a4-08dafffbadce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5821wm+2QtytDOMFsa7/FmzFIbdiPdXOrQreSHe5Q55rsmMGT7RaBMLSKFPSlx3zRVboLPd3UldIl7YVq5fwRHSO4A3/l25XjuCjdYSjgqEYG9xSLXgWsTVFVbmUocfMgJlP3qJqXJyPicutrv/Izcy4g19TC6TNI4r22ua7XUy6d+9Bf03++uBvoQRL3vnIfi3YZcOK1anSXaOd0t1LLzeblN4dc9XGDa8bf6Lkr4c6vU9pdQY/Gm1nnfjoGgyVKwC3dnLiqTFzf+eBSI6wGBKCzGLxAUofA3jG21aUYUzmCcEqd5EUZt7/ZlhKmLSN90lUSrh5+nCh8gV2f5wgWhO58Q//Aug8rdmZyXoqHklnEsUiCmelpB+ui53kQR6iZr6RcoM4d4S4HH81MacTUIo/UcntMahxs57jG3cagG0AEKiofchitTw7iHqIzvBlF4x7oZ+Y2h63A1jC6DUggeEInXKjeQkEC/RHEWLJfMs/PhnWkypOU7yDE1two3EpFFU19nzhM5ifPBSs4Pp8gXaDArL2rimYv5/4bS0QuxQBw4q3qSVrlFBsvVHswyoiwmcSbneyi4OWx8GzEuC/6OIoZl+5d7kVuO9NeQztFDcUQRMtcFYetR19g3SYTTbx62Bz0qbKjrqlR2Zg+NnsvfQXDr99vRgswbmlmX43Lkvy+W6Sq46ge9K6FABj05oN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VJxNsKHOt3JDic1/j1uGRGc6kXNYBlwyWR2wD6aEPPhCgtAAF8nAQ/FxFU9q?=
 =?us-ascii?Q?gq8T5+Q0jUh+doHdBi9NsMu2v9l+1zC6JdTkg/TCtQhV3RVqyxtbB/MgxHtE?=
 =?us-ascii?Q?M6EulWk1ixXgriifWzPZI0L11i0OoUCNOX2j3op5pYARQPkErUVNUW51ecwz?=
 =?us-ascii?Q?ruc5KoB+QvVUhu5eGsSAjTtLKXmNZHdcd3D0I7CQCkQeoqyD/hvpYdDbQ1TQ?=
 =?us-ascii?Q?QRr9/H00OsgGln2G8HKa+oxnjZr/tnfyR/uLdluYvct4HPyOir+xuUC0TOzZ?=
 =?us-ascii?Q?bzzKmXRntRNH1OdvVLW/o/1D/HJmea46bG6a21/ay8UpzztNt8+YYSOCxY9C?=
 =?us-ascii?Q?w58FJRsMAwNiQhfcMHjVlBskHHD2PNwJzgMkJnOJokYPasBZoGcczU6usE7I?=
 =?us-ascii?Q?bXOW1gpe+wCSDJudyYKgxoeqx0iwFvoeLsIerJZrmrIXG8r1qBXVT8VHJYNI?=
 =?us-ascii?Q?KufVi2Cpph2JLm7T/TpTUCUSStHdlwEzadiM/2fSNSnBaB4zi/RlkArbouln?=
 =?us-ascii?Q?6ZpKifh7z30FCk16pu4eGf80PaKHbtZ5B9aEejorbX63ObyrCB9Q2EhRAGx5?=
 =?us-ascii?Q?jhxF/yusjKN8U4j5m9yewPw1/K0H6xLSt9Bt9KkTSRS+9ogCU62UTqw2ODh3?=
 =?us-ascii?Q?zFQMT9d1VdZOO58jPJXgZ/eZ0bjH8kktgq50Pc2eCldJiVZXnwFSszBI31uz?=
 =?us-ascii?Q?y2+Mk8e5IVaJ0VJqxfHWLR+7wmkRsUWF09Q2L7mXCYbve/uX6EG6S184h/rU?=
 =?us-ascii?Q?GaOja2xWKvPt0RNhRE3oFA0pv63NzJ/+i5SqkpqFXzpueDSl0rxg/OiB5+pr?=
 =?us-ascii?Q?kbEFDm1qzHmsg5iZtDIHMlx/N/QPV5yApurSyvZLpTbyelTdBNo5MNaRBTIw?=
 =?us-ascii?Q?GrnBvRklbLhhAryT/U9YG+9zTe3ajdGO04On88CTp8DcorYK/Ryg0qOS6eTT?=
 =?us-ascii?Q?PkEivJ405CpM0Fws3Tu++Vxq8mGh5CK+nVLw1n1U3GSnLGX+T8AnIVGLjZ90?=
 =?us-ascii?Q?EIBK3SzHUpDJIbScrCw/bRGgIR4Em9qOU2tLuiCU5cItDwA3ZaLuQX4Q96h7?=
 =?us-ascii?Q?Gff9K7ism2CJaqgeSP3xhbf0/KJ7zLA+vlQBFWwg/FYP5NToIe/c3S26h5mO?=
 =?us-ascii?Q?BXPw09Vs/Q5/A0wpprTBRrnuvt+BkRfrjYhdQkQjTCNiZC8JcrCXt0/gutfA?=
 =?us-ascii?Q?ZxC9pr8fNiy16HuNz1QHsAY8n2tVgaku9hv8Om8hG6pi5rbN55VjGDZZY/43?=
 =?us-ascii?Q?aiNKB0wfhdn3rSDmx1z3Sw/Ho49ek8DgTRpwcNGxP1GQX/RZHYLNfW8/O0Y/?=
 =?us-ascii?Q?1MiIdGR2EZkCsb07dViqWqF5RgwUiVXW1wIKvTIpOjIbs6g5sROHSR6QhRms?=
 =?us-ascii?Q?GKIgo8TLB99gTBCRFKOiaLhBscQL3oZ5trt0YntdT3n8QT+mbii1rkUCnO6h?=
 =?us-ascii?Q?FaduFUdz77pTdoIPBdusjOKqlVQRSpYO8GnJ5A+xkEnBLAx32w1uuZY8V5mM?=
 =?us-ascii?Q?5aI4bYAkQz1LJALDc6zvJMnjBYqUWtpUYrvkSuLUFYhx+sTKxjeCBfkN/NVY?=
 =?us-ascii?Q?FxoyTMoTRBotN1cCr4TPPwHNlXe9ZNR5RMD6VWVAgSlrq4tF9sZEBm8rB+JP?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1825a1f-ade7-4eab-47a4-08dafffbadce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:04.6697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VUcc81DZIYrpd1LBcvC1CpwUEGAPonTjY15r9pIDWmcbjL/267tjqw2Ph7wQISCWf9LY+0g2btiwjusmNPu7pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since mqprio is a scheduler and not a classifier, move its offload
structure to pkt_sched.h, where struct tc_taprio_qopt_offload also lies.

Also update some header inclusions in drivers that access this
structure, to the best of my abilities.

Cc: Igor Russkikh <irusskikh@marvell.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: Daniel Machon <daniel.machon@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2:
- update some header inclusions in drivers
- fix typo (said "taprio" instead of "mqprio")

 drivers/net/ethernet/aquantia/atlantic/aq_main.c     |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h          |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c      |  1 +
 drivers/net/ethernet/intel/i40e/i40e.h               |  1 +
 drivers/net/ethernet/intel/iavf/iavf.h               |  1 +
 drivers/net/ethernet/intel/ice/ice.h                 |  1 +
 drivers/net/ethernet/marvell/mvneta.c                |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  1 +
 drivers/net/ethernet/microchip/lan966x/lan966x_tc.c  |  1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_tc.c    |  1 +
 drivers/net/ethernet/ti/cpsw_priv.c                  |  2 +-
 include/net/pkt_cls.h                                | 10 ----------
 include/net/pkt_sched.h                              | 10 ++++++++++
 14 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 77609dc0a08d..0b2a52199914 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -21,6 +21,7 @@
 #include <linux/ip.h>
 #include <linux/udp.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <linux/filter.h>
 
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
index be96f1dc0372..d4a862a9fd7d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
@@ -4,7 +4,7 @@
 #ifndef __CXGB4_TC_MQPRIO_H__
 #define __CXGB4_TC_MQPRIO_H__
 
-#include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #define CXGB4_EOSW_TXQ_DEFAULT_DESC_NUM 128
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 17137de9338c..40f4306449eb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -32,6 +32,7 @@
 #include <linux/pkt_sched.h>
 #include <linux/types.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #define HNAE3_MOD_VERSION "1.0"
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b4c4fb873568..25be7f8ac7cd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -20,6 +20,7 @@
 #include <net/gro.h>
 #include <net/ip6_checksum.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tcp.h>
 #include <net/vxlan.h>
 #include <net/geneve.h>
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 60e351665c70..38c341b9f368 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -33,6 +33,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/udp_tunnel.h>
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 0d1bab4ac1b0..b2e1ca62ee62 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -30,6 +30,7 @@
 #include <linux/jiffies.h>
 #include <net/ip6_checksum.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/udp.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/tc_act/tc_mirred.h>
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index ae93ae488bc2..ef6b91abce70 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -41,6 +41,7 @@
 #include <linux/dim.h>
 #include <linux/gnss.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/ip.h>
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f8925cac61e4..a48588c80317 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -38,7 +38,7 @@
 #include <net/ipv6.h>
 #include <net/tso.h>
 #include <net/page_pool.h>
-#include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <linux/bpf_trace.h>
 
 /* Registers */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1e0afaa31dd0..54e66ebcf0c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -39,6 +39,7 @@
 #include <linux/if_bridge.h>
 #include <linux/filter.h>
 #include <net/page_pool.h>
+#include <net/pkt_sched.h>
 #include <net/xdp_sock_drv.h>
 #include "eswitch.h"
 #include "en.h"
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
index 01072121c999..384b6e6dc581 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #include "lan966x_main.h"
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
index 205246b5af82..e80f3166db7d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
@@ -5,6 +5,7 @@
  */
 
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #include "sparx5_tc.h"
 #include "sparx5_main.h"
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 758295c898ac..680b964bcb82 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -19,7 +19,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/skbuff.h>
 #include <net/page_pool.h>
-#include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #include "cpsw.h"
 #include "cpts.h"
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 4cabb32a2ad9..cd410a87517b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -788,16 +788,6 @@ struct tc_cls_bpf_offload {
 	bool exts_integrated;
 };
 
-struct tc_mqprio_qopt_offload {
-	/* struct tc_mqprio_qopt must always be the first element */
-	struct tc_mqprio_qopt qopt;
-	u16 mode;
-	u16 shaper;
-	u32 flags;
-	u64 min_rate[TC_QOPT_MAX_QUEUE];
-	u64 max_rate[TC_QOPT_MAX_QUEUE];
-};
-
 /* This structure holds cookie structure that is passed from user
  * to the kernel for actions and classifiers
  */
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 38207873eda6..6c5e64e0a0bb 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -160,6 +160,16 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_mqprio_qopt_offload {
+	/* struct tc_mqprio_qopt must always be the first element */
+	struct tc_mqprio_qopt qopt;
+	u16 mode;
+	u16 shaper;
+	u32 flags;
+	u64 min_rate[TC_QOPT_MAX_QUEUE];
+	u64 max_rate[TC_QOPT_MAX_QUEUE];
+};
+
 struct tc_taprio_caps {
 	bool supports_queue_max_sdu:1;
 };
-- 
2.34.1

