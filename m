Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCF367CB56
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbjAZMyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbjAZMyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:02 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2059.outbound.protection.outlook.com [40.107.241.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC98134039
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FahNMYYbJLdmjJXQT5iG3q+iwEM23PD8zAvFt1Ma8W2Arn2hJNtnXaqdXZ9rM6XduRuN60Kf5RtL2D3VtY8CVUt17pP28EJsRUj49Zj7pktlrpfCby0D+31tQ8mjtsQMrME7G2QQWCrOdAYQX81y83a4jwYn/eQFRNGkT6cBbHw88LEUWhUYDeBkzHwS2aoVVj6YGv8B9RE3PTw66W5orwGcwQDYJroiCBNxigbrWYq4vtzOa3jGdRa5luK+9iRLhrn2KZRLMd6RtvdumplhbIIcuHwhBGOq/BTeEj/YS0WQOQbeR2wwJiIenlDSdkPiUv9637biFIXJMni+jeW1xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=duca6bIRqbU5QkHfvrPEfQzUvo4g/JT91RMtmkjwuuE=;
 b=SYXrIkPaPnws6DqeNWUdEIe3tFco/m0ryfpt2uywFSi399HAgffudIi8WGweGJ57s6j0JozoGKDSVw57hxSY5asrERi/WtqPQ01DEbos8ucNxkeABF353tuQ0ruzUL4hr3GKhb2+d21wVULuQ5o9sYtMD3A8g8PGa7/xGB6ZBMdg0Lkh3kwKNJOfwzv6PEj8RU/dAmtq10lvQjD0YUWQZfI6Osc3pexk0vaRLBwBllwGCLjnArKCWcs1lz+98WAZlhcGrUSc/o9G8sjDdxRkwPgYToQtX0LQ+zaZs/STHcd+Rjpx/LMI43OQS4vEOC9+n9M5EBGhjrTYAT+i7hB5YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duca6bIRqbU5QkHfvrPEfQzUvo4g/JT91RMtmkjwuuE=;
 b=iyUCHfenJh5alhhWDCycOI9N/ZZ29N3K0Q9ieJCaN+/RN4DdPx0qrGStvsymiiVV7Sw61LAR5HUaSjKNa+K7Sv+WKOEIdg1ZlTZJ3fexHmkaz1F9GzFa52nhXcR0a6HnRcxV+mzqRFn0M+NNiYigJ/e8FZUYUzMgSeApdbXpack=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:44 +0000
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
        Igor Russkikh <irusskikh@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
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
Subject: [PATCH v2 net-next 07/15] net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
Date:   Thu, 26 Jan 2023 14:53:00 +0200
Message-Id: <20230126125308.1199404-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 624b1570-e715-43aa-fc64-08daff9c5a3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zgbwmlbEI4MYfkWQcKXBSr7oXOd7c3Z5gc4geVToHadoRKkhdb+q130xyMN4JpwWff4KhsgOGTDp5Cpg0snA7HQGQ6l/be8JCEelAwzgoHz5U/NVUnjZH8XpIxX+KKYFU6atfILvKuPhDVqlnH9+2VOANtdVl/cwrHzOI/XAFmfQPSTdHCBiT3SCy0BtMoSvDlYjaFjg4v1MUqVeyJS5gx08KfG2xWwRxKQ0zFKajyiTkyhLMTG0nrSTmmoXFrMtsq8LtW8z//KmuI0iX9BeGRMsLkFhTUInjcwU4q9fFGSlRhOMUfeKbEiTD5rc0wiyQuq2T6HtP0RLNWH81+14ULiUW/1IJl0/R7rE21BU1g6nKrCWvMjl++YTvZxUsL94uYC7oIhlPFSPawZDR/jnBUkZQFnOUaOti+EPk/+qFrKoMHel5Oi1pzDgzhy4dhnFrclj5PiHY4ArYKkDSSfZmD/GOXVhM6E7tibi0ab9lFbcjPdtYfqmU3zOFSklCxtyoF+3Da7m1MzD3UdUYQx1aEZkChHtV1pxTM/IElR9NC8wjVOMaikgBGKPYrq9d6TlPsn9IHiWFkgacfHlHGJNlgnfshxCjyiRTFE/AEI7P7+XapxN2efdEwA3luob8dLQhFCLxIkIwAopGme+4QB2rEi6/LsjPnPRuvNDALjL2WZWin/yd+r7fA5rgB5uy4NG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(7416002)(6506007)(44832011)(2906002)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D8pxiYUb7wphylMGkMTnyEj0Q+nMVsHai5756JArR4HRQi+Vwx/H1czn6j5P?=
 =?us-ascii?Q?c0Wk0NllnMpGiPOBbGTzzQf1G4N5pyEAVETCd8MYkvITNCaKvXIkyJRtaG2N?=
 =?us-ascii?Q?+9HNBC8CsL9BHkFVJ9zBrAtq/JWcvKBbWmAl7ESpYxnCEczSV0b+bX4gn3vJ?=
 =?us-ascii?Q?wiE0CnNwqX3rr1kqNng7TTQBdEwvBlfnuUAeG920QIxS2J+7zR6mtEESn8wE?=
 =?us-ascii?Q?DhRbzUhmHEtABrMR7nZvI9QXmzYtihO/45TzFfe0gDWELYQ/BYg65em8GkzF?=
 =?us-ascii?Q?iHHWB8JtLMUzNzaVPd1YyqWG6BXN4JtiCBDftKDSgfsw4eUF1sljR3Nq9k/y?=
 =?us-ascii?Q?QHm7sULppRfCVnOiOdZ32/NZ2CMVFST7XlRfdq27+Zz8ahqhxomzTDtHG7p1?=
 =?us-ascii?Q?dCm4ZTyUFKQGd6gUSy1bjoSBfj2KTGDlrdjS/lWcZ5sGHFk6G60G3BLaqQvM?=
 =?us-ascii?Q?aNNj2n02HmffmIh6bLWZN8Nwi/5EJjY9Th1QYfP8TBB6mNwuM3DudFZibG7/?=
 =?us-ascii?Q?a1/GgfT+FtCwrZKvaN5P5KouUQKapSPcZfLEUJ82NO4I2FPi1YrdOs0nq++K?=
 =?us-ascii?Q?SpFdLqxlLA8uLIUVAb6PO2C7PQdJvACHDgXp3CrcwST7Hme5kFeRLSXkEOmi?=
 =?us-ascii?Q?g8ZCMlI3YyPwaroS3PdViQYsw9jlQFgTk+xUbrAJ4jxw4w62huSMgeXy737O?=
 =?us-ascii?Q?xs/zyaGoAa6O4U+0SJdpRw8y0u7WNlW/dj9pIX+43byJp+saLOcQ+yc66Y9Z?=
 =?us-ascii?Q?2eRJ/x36CYh/fFtWXZ2TADWYKGzBks/jvS/BVxoID/2X1e/JdjzRxXmRjcLG?=
 =?us-ascii?Q?ho1yZAOMHr47zPYCcGlgbVrTu+G9LPG1Xl5ds+nUOOFIPVUy50LW5Bc0JV/I?=
 =?us-ascii?Q?GWyabBHXIO6d0hqCEAbIBtvGAVkOlp16896gaCbkcjuSfTQEpeV79vblxOVJ?=
 =?us-ascii?Q?GKL53koFpIlukGjGXR0tr6K4U35rOYRArbWUTmc1taX+/LFgoHpS5f8Tp0eC?=
 =?us-ascii?Q?oNom/iIY2O3ynJq0hApotriRA1Suz2IlHFcVIGHmqpf2cuHm1IH7J6Edpt/f?=
 =?us-ascii?Q?E2kvob5Y1DnUeysR/+AR5L7CA4VYfH2s6H4U8IRMFdOEuTUvt789x64isVVY?=
 =?us-ascii?Q?q/ofZydmmug2RkAabU1MitSXlR7HXDGNX4nXKclOCjldmdQYZ6vvtPz0216C?=
 =?us-ascii?Q?/AwzFWbax1pN9v+BVXILzYagoqyf+hhWeSuxWnf8FCdVBuKukTnikAtH5N+O?=
 =?us-ascii?Q?YMQoNvF3KQyxUBhJgUoYVoji8cLKYXMMBcf2VNDejg5MwJOLdSnB+6vNv++h?=
 =?us-ascii?Q?CY6vctr1L1Bt2KcfS1rgvUgrZwBzJ6tgPaYKyGfDOYRIwgZTA3WNODIinmoz?=
 =?us-ascii?Q?kgiVqDM5CzwIu5oJES8lGn2lT7vuEZku/SXO7+39d15Uwc/imZJsB8lRrYOG?=
 =?us-ascii?Q?T3WvtDbQNqX3zH82CGhdiNrgrPps/RXj4oE8aFA6SW5SrR5S/16MIm0Wjb6d?=
 =?us-ascii?Q?UDzEJSdQeKEtkAN5X5oBMojqTwFjiqumP5FN+ciYEXzjubSkrQuILeIpK4b1?=
 =?us-ascii?Q?qXYjqv3iQQQ/xn1yfgQrejOqHaPisOpqDgTPOEzeLf/2Oc9DXypDAKDPE4fV?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 624b1570-e715-43aa-fc64-08daff9c5a3d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:42.2682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxGThyPnOgX6H02gN8V3U9f7lz8D6eq1RZPH+RaUw3MOzHKAFW1t9o5V31f61gxSLOVfC431I07I9DjBU38+lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
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
Cc: Raju Rangoju <rajur@chelsio.com>
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

