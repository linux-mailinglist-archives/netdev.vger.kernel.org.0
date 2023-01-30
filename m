Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18B06817A9
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbjA3Rcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbjA3Rch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:37 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2084.outbound.protection.outlook.com [40.107.21.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA3F35270
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WD0m+SVcJRgt1sMKWBS08SWz3lBonDmTR2T5oKqH/mw92dZv0hvfPGAnYj8BwZBv/QoWHOOdlYXmOwQc04veMHRKrxrFKD+RDf3EkNPkSh3cnzjw07yz/q6nUienzcJOwNS9enKUamfS2rGw83if1SAeVCLZHIIKDXuB6dnc30aHX1qFYDIMyrrS9ih/lCbNHfmMpRqxsxXbSVSCodgGvFj9rQXNXJuXAakRBe2MkFqsYv81CSllZi3HYs1bk4SFauY13mO+aXRSneX8JepgJwYIuR0NooJU2FkzX4aqMtrE7BlhoerxwHUitEgbSyYJXlnrP85bjbOVfy1XYbVPyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+5N86QH/bzogAMZ0deuCTPKUDEdSApuYZQpiFEdkGo=;
 b=ZGkQLlUw4GtDapIdgVvZYQFac9NdpZYcY3SVIB4NB20GCoHrSH2UGIdze7VwEkHba58hr5wN4Qw6r3QFCKFQ/3iGQU9pXjaPJfSW1LN2aiHyb8s6LOuCsI9e25mP3vAyO8uNBFzwkOStgOkmozPHgqmbMmU6Jd5IThO2bEKrpgXhR8/qLnqZc8eiSLFFLhf//Gya0/85BmArDq0iROnpS9AOsRIEhTvZu87kLQYt/lCJD7CfIT2z+2ZpdDTooK3vQDKk/Ktc9x/1Lr2G1F1FbkTgfvv3gX9TWVNHP6tLK/hd8t4oTsKmp3VRWTQupLHv+g7sWosVnqSJxK5XBHx6NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+5N86QH/bzogAMZ0deuCTPKUDEdSApuYZQpiFEdkGo=;
 b=ckonVia2U6WHsQ9u7aEzwezOCmUZkbkRIFn64fpvN/Yzm5QMviDkv2hQoD392RXhJoPoskmQe/E2hamOmMHg4vtsSu8Er0FDqWhVCvSFNWmKcsLJUStCBbh8UBIiwjfR+Wgpk7b/nWlGmNlyIFV7dEFFyDq2boDElGnCBcG8+X0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:17 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:17 +0000
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
Subject: [PATCH v4 net-next 07/15] net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
Date:   Mon, 30 Jan 2023 19:31:37 +0200
Message-Id: <20230130173145.475943-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: 1795bec6-22ff-4289-0cf7-08db02e7ee3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b4o0woD2QKdQEX+XBac8kSZISChNDYsQYBO0v2b6pE+tM9on3IuoGD/hsmUz4pV1EaR9rsz0o8S2HgeiCl1atd6o0bPSyrxK3T8Hp5RslldUEkIOGvkdOMKM2GSKFbTJa48RqHqxNEEqcH0SXA61pBXPVcy4FyEmbP1JoPGzfU0BClqbv55c3jjktqv2weNA4mv4+niEC1yTe4H4cMbLw5sLuU0lwaETYowjxwDAfqpqv5HKDgbCM44yWBNsFiMl8xRSe4nc8MW1J70OEhLCV1Hl69GyNqwoSigvy54jCup4WWkc6RFhL+dGgD85Dr7qbnWv9w6oDKqk8bGll1ScBflXaCJwxwkvbqJvqQOHo6cL29TB+HX28GyNWN1yBtf2QkF6ovT4VtfvIeKIdNqVBZG8jIJ1c6j5LIDZk+yDmSOlFEE2mMeiWWKokwvCIlR9JQdU423fsM449BjVz2SOvvrArhbzrUTDMWoIGpk3SflCBi4s2QICm9fMwQtavpQI/lP55YMpwbPF59g8CN6C/mgl/ap/ptW2yh/D2z9NYOtowDSxHrzFWCfW4Qb1pls11ClR2awS9OVSC2yE9N1JOHnhgKqZpZzrA48LoVqqlR2dodisRa1vFhnUK/pLPE4zE71f145+8c5yp5QrfOKRhwBHvpx67q7mo4VIWrPYm0QsZ5l2Ykd9b8l4w7tzUWV/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XHc9N8UJ3gxAiNyQwbSCXWIJ41iF4et/es5WUSoOzfy7GJkGNMpunipbVdle?=
 =?us-ascii?Q?IXE1bA1igT5t22oRgnj8nnYiMfV077l/t8GA0smWV8n1Ouxh33/ZSVSjNR8i?=
 =?us-ascii?Q?nDByG9hXjDD65WsEQCbfWXbLkZYvPxeI7x2oVhnpzsAvsB0aU6EBQOIVUsxC?=
 =?us-ascii?Q?MXZSc11XSLYWtQphCICI259jWmiByN9GKPKr20hvM49/vNCYi6EPwd/W8xzs?=
 =?us-ascii?Q?wdYYDc/LdUQxx3+nLdzssS/t2HOLYsL86QBBvnHV+CCySJtivcLIYlJt1/gn?=
 =?us-ascii?Q?A5HDHMqaDHaY8bk5lFYqMxBezuLAMWmoup1I3ePSCl1OY6B8jvmosxQmO29b?=
 =?us-ascii?Q?upUdsbtCjn+iKIWB8iAEtLjsAZ3ummM8xfRCKNY4v5n4zh++UKr1taWc9r8F?=
 =?us-ascii?Q?oiKexQoLc2Or/U7uPW55ZMaeR46elGu9HqeyFQFkxICBXxZmGSkSrOKKcOgp?=
 =?us-ascii?Q?iyIlt/9vAaSYl/IaMpUiPeMkU8UzMWHfR/NPX7udeSixJAWCzdZUz/0HaCKM?=
 =?us-ascii?Q?P0GSK+ZXyx9oH+LBcdeTIfHNBov+bqydXKUpIuqkIfzHyCgHMqeSMG9bchya?=
 =?us-ascii?Q?l6U1sA8F9QYbJ3oXCjQT+/7Y8Sa2QwMfyjDCEddfCVLc3tc/91qriwVm3UPX?=
 =?us-ascii?Q?CiuI8g453liqoQPZBZpTurrr1/JTq1pB2x51PRlIDPPCv8+SAvM9xl3T/PB4?=
 =?us-ascii?Q?L+YH+85uJRRz9V6RT0bmOU0m5hs4UYZSaciNl+Es30mH9b6JZRFbOh3wphnp?=
 =?us-ascii?Q?cp6bcibFQKogbdaSv1bvWqbxuRaCrDZMdDbYofjl1hHfBj6VjEIAbVnxjssl?=
 =?us-ascii?Q?GZrSIzYVjOoLjdE6zjw2X54QbFw0yb3YMM7lHrsfCczoZBuCjgMYv4CHAqdH?=
 =?us-ascii?Q?cA92qhYASUHmT5qZfGP5EFzzyR6nsnhPPskBM8ICZzAF8HBW89Xpb1ulWP4g?=
 =?us-ascii?Q?FCRFRmD3oAMaUeoyBKd60ou8ekjLaj6y3Mx6PEzTn3Q7GzNwb21QrK+bim8s?=
 =?us-ascii?Q?zSlupz3WWJJQSHiK0pyEMm8NuKzRQnovgIngxxgLoniK9iM2N54wxD7yPo5B?=
 =?us-ascii?Q?ct5p+1m8vF8Vcfu+MClcena15o08Gx6RSeZDU7eL3hysg02lWccE9GE22pjo?=
 =?us-ascii?Q?hlGCa62n13LzQPzOb+4xYT3GGMaR5K7z4UHIIvgvj5+L6fGY+OjiwF1LLnN9?=
 =?us-ascii?Q?Mugfg656AlntZ6pxifKiwCNj4QHS1eBlrscTGXL9qOxziQNVbk8t79ePEmLU?=
 =?us-ascii?Q?RlEhX61ZdEHFDbOe2nsnOlFYUe58MJgaAUanZyr1zcT2WFAqRk1Gsntemc11?=
 =?us-ascii?Q?ewS3fyXWS7EYI5U+R7pl0d283hl6kqr31e7hqFjWEMOBmMQirDaDEeQJ5zhO?=
 =?us-ascii?Q?R6zwTfF7y0Ishuy9wAhdJU4Ev4I4BHlBcIe+lidX3W4uD+ju6aN+2O5aBLta?=
 =?us-ascii?Q?i35efFmzoFxuN3PesDc2FEO/PAqZZykVJBJhL9Iz37lEOk3kVo4qw4jFlWAb?=
 =?us-ascii?Q?4ThfFURaJUEgihUqoZ5TqJOLblOJr30hoSc+WLWX22tBxVMYiunCPQpOBuy4?=
 =?us-ascii?Q?oZD99v3Bj2tUVKfPD2Nl8hn5ia0xQ5/P9JT29FRQGxTR3khIQI0l+3xMJ6Fz?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1795bec6-22ff-4289-0cf7-08db02e7ee3a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:17.0539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AVZWhOL5ByrpmSyDxRNRVOaiQ7d3sinw3I0LCFB5noYpgnyxSxXzHziOhFHtuyyLBznsy2iO154DYdNDvJly2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
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
---
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

