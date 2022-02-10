Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8024B0DE7
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241813AbiBJMwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240538AbiBJMwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:33 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE6F2649
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fecmgode9DfuTR7D2mZ5j9NZ/pYqRISMGJGtg24nH1CkAcFOdUBVw1MX0KFx3Aoq31byCU4fz1jBBoi/rk/viC2z6aePrlNBxssk8BzcvIwnkR07hF9J3JGsbKiyEnDqeSFadh3e4x9NtepGVJD375SIGIJuoSWurjIWIveOCpu/IBriTATLkENmbvKhppLXIa5nzHYpdZ1m1QZP/7MpqP7hpSSbJb0+1+Px4xxqlpx0b735w1VimyxsoQnHV+LDW2BzrRTH2jzQrDiCiqL078oXFn2fQJnC/aD9N4Bv/MFqaM343VktjSVj74HgFwUGOYipEjkl7wxcgqJBHD53Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxXLAC10twlbXfzp+Z2Dwge10sPKtvK1xZqtxx9XcfY=;
 b=W1+85q9fUGxzlxRn1gp4tnxVGiyc5CODeyAhYLJCNN2pXI0braZQE+YmZauF3zn+ukBLmuamBIXA1Y8qDGpX8E7KmHkXUlNnw6s3e45WMRDQR1Lw2/92rg13JAT2lnHY3GlbBWiSLWo+pGCBRlcfFzr1wmxhqrA7PSTIK9/AX9h55kXcN/hWffkT4OtVkh7tb6u2kw5IEHLjbWNF6G5IWRxoSsGLyuJFcfvoVsdgc5nWyPdtBD62kh2yxYD8XtGxGS78TP0oFZynWD0WV2c6qDnWVW793FFw1oygIPCJr4LXdwko3GRPa38AC9YUXK8IErP8jzxnh2ZlAyBObNDp0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxXLAC10twlbXfzp+Z2Dwge10sPKtvK1xZqtxx9XcfY=;
 b=AjXiHCv3x5skRG/PesEyNPrb4D9YVt/V/VJPavjw4vReBUeSKreHNoFIZrH7HebINOG7ac1XrR70AsP0gMf1Vqd37bBPRUNW/3ePDjjmiV2RRNAj1mXRa3YHMidEREyeJ6WCKzDTfGYMozIn/kVGoS7ujldBPe3hb10C8vrsNXg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 07/12] net: switchdev: export switchdev_lower_dev_find
Date:   Thu, 10 Feb 2022 14:51:56 +0200
Message-Id: <20220210125201.2859463-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30fae19b-942c-4159-9e6f-08d9ec942f0d
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8806A781D098F51F2EFF4E05E02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fLpoyGl3wzZOCKA+/FG9w4ao4RPkK7ObM792m/19j089pHiujX2fPUxgVd+ewhJKMlUv2tIEwoOA2n6N8EabZAQAh4L8uuRztfjOLllGtyooJmIJVXuzlPlIeGxb2gsUSQFledeUuzkcM3trAd8vBOA7rV/sVAhDeFiL/3TTrX8l4BMsUk8hdMlq/F007M4VAGeEr9dNa7FG8hNrQsdNTxp9hNgE3oLHMZ+pum3mq/yM7QOKHoUFziZNtF+amTvoIZad3A1xbCzHBwBz45CxG9h9kYHiBHt6PlBGeoXQJKLfq0Jm6wpWG8+RCoybwl/854Ry1djLeUnw0IUto7VV52ABIP7yJ+4rT6IBcroWnjoDnRbGUgF+aH2jGCeAIE+iD1HtRDOxzhF9dJG4i1Jzkdb0FGYjPYZOj+Puc8wBaoIZtfCbRZQ0kTJoCAxBx6WOCSOIXdhOd3VBcBhnxgHMQAIGAW08Wimj9T4jHk6e24KUjoNzUK7uyj9Jwf7sMgRPm8muyBH0YUmbWJCpAuRkJDzPXsFX5hVBNghBOup36xiylzdgQiLpKOXSryeAdbgTWjZlxt6emqaBTCOF5q45yGpF6UQ1I2Q0YPqWj9E9ipSWY5o4FzXNWuCP+PQjMsJ6ph/pNOYsVv1zJFkxWM9NDSEJJGRjxdIupyg7Ee4xFrUhm3J4R4k00q9SEy1fMtfIHIYxECFVUZAXWsUN16vMEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FpJQMgKSiolLT05VCxbHxXSPa4JIxyWIta/gGzbrMZdlJYerdHQcj4D5yfsO?=
 =?us-ascii?Q?pp/c884dE8vLEnymf8QuWQlGocQOZHe2GUwD7fD4bLeU2T+REPHHKHxeNQoy?=
 =?us-ascii?Q?KGtKszbfpiyYVnR8vVK1fRoIp6t32mYT/HQNSEKnSuzAjIsXwL5XR27ACHcl?=
 =?us-ascii?Q?5XQJx5zyVI8YDDSqfHt+TpG/aQZwVz0/0l/V8vKB6o3fqogTK42z9a5r5hYD?=
 =?us-ascii?Q?52T2MX10n93PovKa+GG4awdF0d8aV1PB65kX7O45Zc1Ttm8YtFtPUiRuNWH3?=
 =?us-ascii?Q?q6NBO/Qj17G91BtB6EO++hYNNjCKnQBcGZYbpJthQTOBQ65LqkC+J4tH8dgv?=
 =?us-ascii?Q?aUk/rqIgZK3elOk8Dh4EnkCQ1DHJA0R+9W7KwL3OPCizbAUCvOHjYPAe8u0z?=
 =?us-ascii?Q?aKHzHYvbQjuDGgeQdg5KNWLQun7hTn5wgBIDInYhYEeQWCaC8Vn3IZTY21F7?=
 =?us-ascii?Q?fgiZEYRsaXUsLN8tKZK+lfmgiWoE0swrWT1fyMTSklmGVRET4sDzD6zQd/IE?=
 =?us-ascii?Q?bcOyB19aqaRUsghks1ipKlxGjajyu/2qjrJhCP8Z+Sz4AVUudxzZi0rWr5O8?=
 =?us-ascii?Q?yqfmILiiCRmEaLFNiKH7Dva891n/mYSY5Mabe296IcHwHqf1FT/2MnLbtIFN?=
 =?us-ascii?Q?yt0YVQ7udBXRD+j2T5GIb8zOmI4S5G138qEt4bzba/BtVHVS9OtKxTkZVO7e?=
 =?us-ascii?Q?JYTDzT/qLXKWI4bfD0dxdl2sDBooDyWWxSWznhBZ+lts6hSHUcxb2pb1JR/R?=
 =?us-ascii?Q?MAVsBaEOdWjFTA9jWcXkK5F1v4YtumP5Cfu7HerhCOhZFhkDV24nvhg2Amvy?=
 =?us-ascii?Q?L5TkkO0GxIyau5VMkTmnHJrmAlMMaqgH5oiYXvu1/TIXVpZKT4EJwjw4G+08?=
 =?us-ascii?Q?aSCa7fneJnawjjZ8bRQGblucZc1YDus4yv7plCz2UoVd9/pA4hZTgkSqBxLk?=
 =?us-ascii?Q?8I9meLmntBNkClk1cjvGjMvY1eU7XsxXBwoh7zFH4DG2wM1QtTP8Llu12qkq?=
 =?us-ascii?Q?pPyI+ceVGdytiG01BXnh8pCwYv2rOK64TM5DzAL55xsHdv5flMWHyRRN6Hjf?=
 =?us-ascii?Q?JxfYwKHyXw0Xl/kH40e+hCTUdfPRqnNkBEBeTbrgGpcoINsAWUtmiCTPE5/K?=
 =?us-ascii?Q?1SHMSVDKYuIxz+Q0HrcG9SZhGOG+vM9siYBa8mVWW/VTDJyalh7QhNyJfaeb?=
 =?us-ascii?Q?iCc200EF2qDQBdKjIm4JdXeMn3NUWoNaOAZUr48aFauysFMpei+O+3VfHEax?=
 =?us-ascii?Q?L4AE9h7R8lqoVurJmaB+n4zgf9PoVbsjSaQs5pIMeQBis/HC0fJetBFK67gt?=
 =?us-ascii?Q?MBIDF0G84jyoK4FoK/sVOaqO4sLbJc4xHtJtPccRzI2qp9G+x2AzauK1+Hqw?=
 =?us-ascii?Q?u3VkGBtpkMmk2yeab/b3AFEOTCb4CnwE61zu/TzVaWXZsslgj6TYUUZH+GiK?=
 =?us-ascii?Q?ltINhe8I+Jm/tNw+zbUreglYHL/KsGRioKF0ctjtqfhlsunc38YIOFMmyERj?=
 =?us-ascii?Q?05K/RfsdEYKLpR3UaR6EIgxVgF0J4nuRBXk8UWnDJ33wCXLdr1noCSugwJyD?=
 =?us-ascii?Q?Ql+l7JXYnr0QmE2EuQwQmg5iNnxlEj+HwoYjHeXfbhIht8GMnjHztQj89tRh?=
 =?us-ascii?Q?jbGED2c8vOAXjLu9KJojjGA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30fae19b-942c-4159-9e6f-08d9ec942f0d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:24.0403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OG5OptZYltFOl78Vcl/lZn4fzwrCOi/s2yAWUXGBJ9H0/f+EARitI1F458hHmG2k3b2VW2ikM3g4lJMUqv9i7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This little function that retrieves the first lower interface of @dev
that passes the @check_cb and @foreign_dev_check_cb criteria is useful
outside of the switchdev core, too. For example, drivers may use it to
retrieve a pointer to one of their own netdevices beneath a LAG.

Export it for driver use, to reduce code duplication.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h   | 6 ++++++
 net/switchdev/switchdev.c | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index d353793dfeb5..40b348f9898c 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -299,6 +299,12 @@ void switchdev_port_fwd_mark_set(struct net_device *dev,
 				 struct net_device *group_dev,
 				 bool joining);
 
+struct net_device *
+switchdev_lower_dev_find(struct net_device *dev,
+			 bool (*check_cb)(const struct net_device *dev),
+			 bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						      const struct net_device *foreign_dev));
+
 int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index b62565278fac..85a84fe6eff3 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -408,7 +408,7 @@ static int switchdev_lower_dev_walk(struct net_device *lower_dev,
 	return 0;
 }
 
-static struct net_device *
+struct net_device *
 switchdev_lower_dev_find(struct net_device *dev,
 			 bool (*check_cb)(const struct net_device *dev),
 			 bool (*foreign_dev_check_cb)(const struct net_device *dev,
@@ -428,6 +428,7 @@ switchdev_lower_dev_find(struct net_device *dev,
 
 	return switchdev_priv.lower_dev;
 }
+EXPORT_SYMBOL_GPL(switchdev_lower_dev_find);
 
 static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 		struct net_device *orig_dev, unsigned long event,
-- 
2.25.1

