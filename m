Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E9D687262
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjBBAhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjBBAg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:36:59 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2345728FB
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:36:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UssMj6n0jYvs2aBa/Xtacvya53Uax0ZzwoZb6tvJJ8bm0pX877BoE+fUB85VsxQVtlv8+zMshxR2bmKrfcrO9QnlPkd+VQT9+Qve8rHX4OH7SmyjduV7wpcz7jD8L0HlIQvGbNJVxTSARIlTbmAo79OxbtotPC4rckI1JEh5B2/dGNExLnWcJywDGPi1qhjYknWIOMGNPevXwyko+mRrsKoJGNrfE9bSMyEY/6i3rz7aw2+QGC7c0KHWL+R7jXPKojjGGzK1JmVxTh8JqFzFye7GI03Zw/cdFhUAqC2u+gM3CKqE6lPG9gBgNvka58OJ7FBe6Yk26RaX98R7H5ze6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiVDKvg8Ribmwtk80xku02iHmEjFPvv0A1ckS7YcwCs=;
 b=AmxtlUgM5q2+fIEv7nxPnJEH4lHiXx7dfrAkiYq/UIB3RtUVdr1xXhdjVd5DcPmZ7hEL9vUuf4g89Wwhr14HY6BD6A2Uph0j8z0MWO81ov2WTjrrhrgVk83u8JzT8MchxCck7He9dqGMBVd4p6yRY80nRl/lWFUPmruMLSmOXyEgzUZMEs1gwIkYuPBJmyBiV+JCblNueDFRY9pmhNb2TC8oeyxT1ukLS6GjEVSi125t8T4652X+ZVPf0j5D/wgWFygIh66EqqVPRtVol4yqOFHaJKFzV1J8eL2829vfq/wGr5cYcHZcHe8tuOo6R4/AwbYSZxgtc/vfDiWf4EErtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiVDKvg8Ribmwtk80xku02iHmEjFPvv0A1ckS7YcwCs=;
 b=dedH4IqbksjrdL2SUygg2LkCCE9yQHbHIvo6IAOa0hE28Pkr9qaF+vPOLevz5MpgnBgEWksStAnNrAt5NTr+B1yVJMuDHmWwEv7kmg9x/vYstPHgT4ZLSfXygWQKxeCuCuWPckQ0Jsu3cG3naap6EPb1qBHRl2A9Jv1EK+b7xdQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:54 +0000
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
        Simon Horman <simon.horman@corigine.com>,
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
Subject: [PATCH v5 net-next 07/17] net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
Date:   Thu,  2 Feb 2023 02:36:11 +0200
Message-Id: <20230202003621.2679603-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: a0a9ca9f-5500-49ca-f7a9-08db04b594e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfM1mKLGvpFOsJ0WaZeDzW3hFsxm8RaWeijEmjvJ4U+zVY1IDTUVAlP4mH6gIip5LFoUT06zKeyrWlGM4B36SiIziBrcGvs9Zw8kZn6W0K3QqZh5tl5SDlgp6Fo481kFGsMtsqq7om4lw73x9G8yvMk+PO7qBEPg1fqa9DHvq87rZujr9EnfxVwuW88tqRdki9Xi4dpvY9LQCba+spbz3M+j73upCp8c1BqyfSWDr9V378XEyCtOov9d5gIjnhJuH5elSFFVhFPz1xkaL39IULWP95eIgcXXLFXDLE8d1cY6ki/5QtN/G06SF5320TS/owuldAC6NhsturUJYi/y2joN3bREhuVEmARFN406vZDfz+JukT/lwjOGUJZMJGpO/pTvjfkHpNca1L8xOU7O6nsOrdXkqV4ubuAKxX6u2GOSz6k1fH4cnIrQ7l2G2fFUR7OHyKdzLpqYFWqr5Wz/U7dxI82dd+DYK6L8/XCK64T+2MASuA3S5nj5c0CGfdHq9cHEC4CmLLiowvXfUjgzST2lY6szlGEtZz4xn3A8cybCtFaz1iVJK2fDJX9BSokYMzkQWglwB1RqccipJnZx1qFpuPFbF4IdzMm2hJCUSq+TZ4pJUEI3VR+iHYBgVjq5aD+6jl4eGnEtbnUtVZHwiztX4pg46t00oO8LagDc9Xaj5R1mIq64c2/8ndZXsxLw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OpoKdRwiOsIZ/Zs5r27wx/Sd9e6w9pvT98JaK/KWEczAXvK4FQkXtxBS79mJ?=
 =?us-ascii?Q?3AlZqdP5yxodY9cr2rgM35RXDRr8uB5Ks5y5l643w8gCUgKwkif5ELBiJ2bL?=
 =?us-ascii?Q?qz5MhUlAdSl2uftWxodr8vsrtVCibxtDT7KajtvqlsU/nmq582Eql0UskD7m?=
 =?us-ascii?Q?sk5/SJaPHqTKbzOHVVp3bUIjt0XLu20MyBXp/E46QflNPDl0xd7sBs23qXoS?=
 =?us-ascii?Q?Y4Tips9KEXjjD+uoneqvgrBF2d/qhJju2WgtNMlnG9oFjY96s38ewCDEH3GK?=
 =?us-ascii?Q?nK6tIFdXV3j4HjrQtPD/XKBoxySkAaOMGmzEL2NHpUHDlB/1EbAeaV8Vmy8c?=
 =?us-ascii?Q?GX57MF55EQq206zSG1am7+5/j/c5pSwxMtkpHXDrAjG1B5zc9ZqLEmwIZr+u?=
 =?us-ascii?Q?PJi55sOYBk2THKYwrr2K3S4x/pG9px5ATJ2P+qL32We34VqZUgRAQQLcEonC?=
 =?us-ascii?Q?6EgGU0bMtI0o2PfX/tpmFpIrNDOh9fYbiuF+wykizqMa7OSCXzkAtd6PHGPq?=
 =?us-ascii?Q?zB5L0/gycAMF4IYuK5x0VihH+YRx3gDVrfU0MrN8m4w30Ebex2DSNqBdtNJk?=
 =?us-ascii?Q?OViUD8J8EM2xCNZQqicQj0+1wSDfmIvq4RK5/AXub/pbg7qxJKpEYJeLWQfs?=
 =?us-ascii?Q?50d6DWhdUWtKf4tz/GCmz5CzwUhLGp8ymaM3PpGxCg2n4VwrnV1/JVSWzOk+?=
 =?us-ascii?Q?5UzJ2DwTpikYkHiAjZPrEmBG0lL+kedupZrAiFJW/4IZ9R1i3fnNCEkxsKWJ?=
 =?us-ascii?Q?o90dia8Nd/RPS0uiFVjjBEXgzVw9BbANsV+eaGXPMR8dWHIM1AuG2rXumLmu?=
 =?us-ascii?Q?OOnnYC7O5U+lLMk3ZmW5lHRAIpzzHazN7zppLo1LdlAME/4RqZMRfxTYqDJE?=
 =?us-ascii?Q?O4u4SZeqjGG2gRo1WqkpuZDOHjhwmbwN9FRZemho5T4ZBbP5EK+wchKCjoxq?=
 =?us-ascii?Q?dlBd73YslSdL+wFRlNnZnY4ZIuIzIMu0Vu81jd5b8nWW3nSvnxXiL54Wj/F+?=
 =?us-ascii?Q?UXVJlWY9U2H9jCGwLSO+di8gYLd9wPqM/Djtr7U1Dm5GYZtGynmU4p3MBxF9?=
 =?us-ascii?Q?uAil6TZrSriRdpIDcUljg2rSv8BZUKxH2+nmHVGnR5zC+MhRlxxHBR2GLCgE?=
 =?us-ascii?Q?zCpc1gE0o51nGYRAytZg55CYiYZnc5JbFP5a0lEIlvM+SaPJAk03li2zT98i?=
 =?us-ascii?Q?ZfU0X/H6NYLkWWEYjVT3wOwfUPD6gPju+7oCtjE3eZzjf7yarv4Vp/UJzO+1?=
 =?us-ascii?Q?DgITtBiPDDK/NWDtbV0nNQdMz+DPMnYWVYqSRJ6elUjTtU+HoEsMbSQyMCtd?=
 =?us-ascii?Q?PrAtNJTMQIs4Sjcb9XUfCGq9H7Vv0j02pBf86OCJOYihdR8sZGD3HngaQy72?=
 =?us-ascii?Q?s/jOgdBZTxzoYOHs6IlG04H/q9zKWGQlnlHd6elY8A/ZWHCpoP2mKrDY8CIk?=
 =?us-ascii?Q?CoAB3FV3vBAp4FJXI/j4M/a3fJU2qoLFvvj5NNxhXqz9/MrM3usef6pROOdD?=
 =?us-ascii?Q?6goazYJ1JYOXO5txM9utgmx5eFuwL4aQR/0Zejjm2Jl7YwpYe5SpE5mQsXaE?=
 =?us-ascii?Q?3ZFk6oBeIu0Oaba9u7Peg6HEUnqDyC+A9jI9YrekCj/luy30Kt19x8kcctWB?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a9ca9f-5500-49ca-f7a9-08db04b594e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:53.9197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZraIYmpIkGqwvt6MsgFUGipXZxHDpnxt+5SKLKkytdnsF5n7zHNYpIesdCErZOA8eruv3j0sBtSwh9xxALI2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v4->v5: none
v3->v4: shouldn't have removed "#include <net/pkt_sched.h>" from ti cpsw
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
 drivers/net/ethernet/ti/cpsw_priv.c                  |  1 +
 include/net/pkt_cls.h                                | 10 ----------
 include/net/pkt_sched.h                              | 10 ++++++++++
 14 files changed, 22 insertions(+), 12 deletions(-)

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
index 23bc000e77b8..232bc61d9eee 100644
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
index 0e87432ec6f1..7de21a1ef009 100644
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
index 80625ba0b354..cf0cc7562d04 100644
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
index 758295c898ac..e966dd47e2db 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -20,6 +20,7 @@
 #include <linux/skbuff.h>
 #include <net/page_pool.h>
 #include <net/pkt_cls.h>
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

