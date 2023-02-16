Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2367669A23E
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjBPXWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjBPXVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:21:54 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C8E53838;
        Thu, 16 Feb 2023 15:21:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5awm80bMsBNMbD4evMw4RXpBy7DJ9dGuOmztyHV7pGbTMIwcPdG9nDC0x0PH/c0gRJdK4GUTnShiyMp1jYP6dyKHABRVOwFNfAN2h0ld6KeyB9fytz8CvSMo/FXCLqdylJuB6OU7+L9oH7Popwkha1CnC1orRA/vINCitqvZEaf2wAZBtzzfRPo7u/onwJ4INlItZqRU62e6hu7tE4vEISIzG/ZZN9DKetOj/rASjfBZ00NqeFfoyEp67Stf/endd/JrTq6LouK0u1X2WZg5ZLAYeXuoCZuZ6FO1+02BP0aeP9lWghxpzuWyFduEebLcRv7rXRCChmJ3Bzh5B4YKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBWnWGGLsOf9IfMcqZszFz2gB3H+yp0NtLUzVYAjprA=;
 b=XjLou+A+iShhXcOl9yCqKx2v4oTxiF7lmMjMVePD8PsvXlE5iu3ptlSV/MePj/g6Oltny5dSXYGBjUwuTawGYiqCO/aJdgZU6CjDl/GNbZxYQP/SEnR+o2Wvr6zQbQ056cTg4oy+C2au3pn+U7EKdjGRUTP5vNyruLp/pMuYqT4TQfeUCcEcwOSQHPR0DHRCv3/J8nbJqDYDv9W/0n/2HtY0kFSQl6TCnoScuhbTLhvn5lTcrQMWhJyfOqW7TJjvze2mrYGAqQHiLhiahyGDkplh2OY4av3DI9OtxgpJlQu2JLLyWEpJbVhdAGUBQ7mfiR//z9EYa2adCtBDf/SUqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBWnWGGLsOf9IfMcqZszFz2gB3H+yp0NtLUzVYAjprA=;
 b=MdikkotOMrwLJWjHHuBjaEDTzCwVi9nO2PMMNupIZbdSA8UnPqTKF48umlaMkl3qze9AROvnzOeQITqTc2Ry167iYMV0bwm1RcqQC0KNtg9PylceaUxGS3uFTWjFaafhfKXU55OjRrSNYfNiMA29pStDb4pUghxWtJJQ7e71L6Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/12] net: ethtool: create and export ethtool_dev_mm_supported()
Date:   Fri, 17 Feb 2023 01:21:19 +0200
Message-Id: <20230216232126.3402975-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: c9dc0b9f-162d-4194-0875-08db10749283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtzTP6scCk1Imh/yAXMposK4mVRmz6DJvmhQKqqvvEokYH0rwZhWqM1lwjq8Le+zF0Mv19/5tr43/4vsGsMDJ3UvLOvd6WEM3m2voQsfb24UISDtXGeITpkTT4Npm3W1QGskWaCbTvXnwSnLqlQSmW+I37e3n7paduQP7yT6ncbhCm+7LRy1le/Co2rLzX16bHHVkYlp0GI+6CoQQM7a0f9CyQh2NczvjBe/LF9AjY2jK/msPv/tAhokDjKSx3sR1whfc/GmImjAky5Oz4Q67WJJbpojnHEBVLmKnJ1jRj4DYIiqPRl6X/cqaF/NZrFkysB2rQTzoqYz6lZrqc3QYV36l4aPj70rx+b6rTAJbfY8hQusJlM2RTGsLukf7a6XUGvDzUX57OWXv0+ga1BCO7Lemk3p+h7jxP6ynWwv5XfPE2wPeWBmio0hKkouUikMZuapO0QN7ogJTNTdVfTZHygdw8c9uOt/xGc0M890ucF1lgFxwoVV7kOe1nBd7f27/GPwTVSHcTq3BBx5txuWbgTVQkDN7o9pQ6UGqixFXmbh9XXNdUSWFse9vkq8AP4lS1MEKbIN/R7rmViCm4vJ+HYus46BgbluBgRTs/BBxJOXgfQCSkG8iYFX2jnjI1/TotBW3oilGjT7471wgLAFHirJO3WADJZcIxcPjQX4RkKiv/5kCIO8fHIkqq9VXInnZGtb+ainpcFFQ9158mLJlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2wSA+VQm9o+P0E/RXpjDLfJyc64lBTj4TaWCpWJ1oRI0uZI3KoDbY5B0UCaJ?=
 =?us-ascii?Q?KioZSuNF4LQSNCucXbttsINIJ+3CfrGwGP3JfL3EXQjlV9wi2WuNm1H6/jMv?=
 =?us-ascii?Q?0f/TBylZ8bpa/P7QLpa86KeWfzvyqw6haZxj/C1eaL0gdQgeOGIEvEVoWqa2?=
 =?us-ascii?Q?JtAZRvxEo5Ym/tFvZ4rr1BM7EviYYHYiZJDMmwo1pXud0lZ0whEPmmSPPJ8/?=
 =?us-ascii?Q?LSaDBjue1G6yscFQ3EYour1PEHVLkY+UKSJeoG2TI1cm2TmZ+toZNYTDVa/u?=
 =?us-ascii?Q?e09nuQTOrUC9uX0iLmMn1cBMHlOHRrF3M9UltxKPFmmNKR7FJEuUu/SQOETZ?=
 =?us-ascii?Q?Gb1OdE/7Ew21v5eHA7/iiIz/Wk7X1E4/M/xBjuwungF/sMoLh+A+QO8LbWCo?=
 =?us-ascii?Q?QCnAxvtoZAHACxn8pi8RfmG/U4kyBjxnUjTiYdemcEVGKj2sNIxNeiEKHSEe?=
 =?us-ascii?Q?fjhEGkuc6YikphnlnKxRpN4/ZGurnI47JuRmHDjh50YQ4BFAd4qs9pA7ztfQ?=
 =?us-ascii?Q?DKif09XzOdPY6PN9OjUJYIf+6K2Z7hNkmzhDQ03kWZUc+HGdVcrv10Rptxrf?=
 =?us-ascii?Q?tMiOW3rIIVrXcu8JKTxuRPEY1iMjp3kddnHl1W4TkEqNjzjQMe/I3Rg1wOVD?=
 =?us-ascii?Q?vnpOykpjSyWIHZaM8YAnYaTHgIVsVcnvNiomAACdb3YL9MOnSlIy2CmUlU4L?=
 =?us-ascii?Q?KYhzo5ZreyWiTLkKlHZK/0WfxjCeYrOJB9UthuVVOgsCQINtAZAiyNk1BAW7?=
 =?us-ascii?Q?LzVHOZwdFkWbF8uMYwzmqjAKroHnBtVo5/ZBjaqyaP5ajaFSUdDlnupJ4sO9?=
 =?us-ascii?Q?J4tgJz5Sib4BMGQtc5483XxixyxJYEygmGn6DJt4DJIs/sW6qRICIphSKZu5?=
 =?us-ascii?Q?UpEo20Bj39TxI8/cTbN6Y3tV4gGt8+b1xHauDS/UnJt3NaktPBSMV/QTioCK?=
 =?us-ascii?Q?COJu/v9rBo3TYT23MO7SZe/YoS7uWBdNcqoKYfwkX/Rj1jbVKPh5lDj6Eozz?=
 =?us-ascii?Q?DSgzr8PZgjVGJvCmQb8SPjwVuPeH9DARhXoqruPc1LeXZSGTyWukCJbTeLvp?=
 =?us-ascii?Q?8NgU/i/GKPgipnngakSCoFJTpigpWSqHTrpLxoxOxQwgddsx831vWy3j5q7W?=
 =?us-ascii?Q?Gc0PCNcr7u849cNeO6z69eq/viiBLom/ZZBft/F9iVNTaj2JxsjALf9Df0Tj?=
 =?us-ascii?Q?2gVhHG1sL+Y4izgOoPV8TcJUgtBiUhKKc/Rzy3ybeuhoBhEZLEPSdgDYVZ0K?=
 =?us-ascii?Q?joQsin5Wb9TTMLVpF+OqUtzTC8YskEDziP5eNbBxzzHCrPvf8pansj4UqmEz?=
 =?us-ascii?Q?B6y3RSuHx6Sb+XjEym+Deq42C7s7gYokJeBLBfMslaUt20Sqr7xyudfL1lPL?=
 =?us-ascii?Q?+TXx+bMszg5U0e47huaYgpt1FL3r39k638W1CAkMGfVdtkezj6Q26k4BSCOw?=
 =?us-ascii?Q?NrFN2knA5OB/IGmMkb6aZPM2DuLYEUr7xyY/vXHrflCTu11QzXSjSBMr/kov?=
 =?us-ascii?Q?6+dLICXUugHTM5AiibFxppxY5PBUVKAWn8wrm6bxRhVLHMD4uTvF6zYQurIN?=
 =?us-ascii?Q?vbwwMmLda5DGbZ54gLf4lkgNOqqLUK5FpdkYkSQjhPcxO94Gh6v+9WN/ofRB?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9dc0b9f-162d-4194-0875-08db10749283
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:46.5087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DT5QGLsZWs1zCKvJBDC+AluQr+SeRJnE4pXzIezGTG83buNu2x/oSQ3ljVI48t+zL0FKuwAjNdV4PHxQ9RYKRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a wrapper over __ethtool_dev_mm_supported() which also calls
ethnl_ops_begin() and ethnl_ops_complete(). It can be used by other code
layers, such as tc, to make sure that preemptible TCs are supported
(this is true if an underlying MAC Merge layer exists).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/ethtool_netlink.h |  6 ++++++
 net/ethtool/mm.c                | 22 ++++++++++++++++++++++
 net/sched/sch_mqprio.c          |  1 +
 3 files changed, 29 insertions(+)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 17003b385756..fae0dfb9a9c8 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -39,6 +39,7 @@ void ethtool_aggregate_pause_stats(struct net_device *dev,
 				   struct ethtool_pause_stats *pause_stats);
 void ethtool_aggregate_rmon_stats(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats);
+bool ethtool_dev_mm_supported(struct net_device *dev);
 
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
@@ -112,5 +113,10 @@ ethtool_aggregate_rmon_stats(struct net_device *dev,
 {
 }
 
+static inline bool ethtool_dev_mm_supported(struct net_device *dev)
+{
+	return false;
+}
+
 #endif /* IS_ENABLED(CONFIG_ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index fce3cc2734f9..87d9682efadd 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -249,3 +249,25 @@ bool __ethtool_dev_mm_supported(struct net_device *dev)
 
 	return !ret;
 }
+
+bool ethtool_dev_mm_supported(struct net_device *dev)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	bool supported;
+	int ret;
+
+	ASSERT_RTNL();
+
+	if (!ops)
+		return false;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return false;
+
+	supported = __ethtool_dev_mm_supported(dev);
+
+	ethnl_ops_complete(dev);
+
+	return supported;
+}
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 48ed87b91086..f0232783ced7 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2010 John Fastabend <john.r.fastabend@intel.com>
  */
 
+#include <linux/ethtool_netlink.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
-- 
2.34.1

