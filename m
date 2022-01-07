Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39AA487975
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348032AbiAGPCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:02:02 -0500
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:26369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348014AbiAGPBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUnHPvJambJaXAqNXQtx5qRaaj9WYw7FZb0rvikVqDS3Bwm+fMnHI42XXNLStaUNZ9LuHnepp2DeaYLuMIdakbAMbaMqmoyqqaKe/6U4YGCkmBTmnQ7YclpyOBl6ob//DxYC7PV81xjd9WplmFypYj3lRouDmpQmeG/CloIXKB1JGS/2G+IWNxmMc50WuMbMB8sCmCe6KYqPkyq4woOyCoJOVhLuhDZS1Evog8WyPQOunrI+Bd5BxAFf2k3JMDNHxcEpCG2y25s/ONGpJZxq0GMb8y61cTa5kRKcwAUCkmDqFHVYtIUvPf0N4SqGiKr6KutRDbZvyCZoYhqJltTOJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRKFVKdtTYhM78ka8PlijW2twxbCOiSSdych1qEVrnY=;
 b=Ggp2TaHTGJjU/iWIPf8Z5Ih7Gl0oAZ1kfkCsf8Q1C4Q6QbOoomKANMlv8MzKheKXx0qXtoNIB/fKRRVztcpOCdLplK9LUI9YVIxXBzMl3LeT8N20PsOiS/50vxLyF1FG7QDl5le177gmLy/DyTShcqTCMq+IGcb8c4DOTf3Dx8Xxy0LnlyPTeI+aaMbWE0rKy5Aadn4Nr60QKz/g+yrd4f+Y9ly6q9xRLYceAtZlJp17ik0tL26pVV7pSBlBHR/RcNpw0crgbQCzw52c+7yeg7fud9XS+Ya++WEfCflcJ2OpcpAJHKv4ZS505FEb4XH8iucqtYmNjoJlA/yMnovYxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRKFVKdtTYhM78ka8PlijW2twxbCOiSSdych1qEVrnY=;
 b=XlRB/QVAITBcJt/KiRjfk6mcO8dIM2XjctAfd+Q3/jCldRCy//wo5BVKCepbriiCqj9yGPYUeuoq5JjLNTMN2+B137oBmn1y2URWQC7mm3QDePN8ibAnMijCbfdZ6odyS3LCSX2xi68WLorrAKrleEh/o9uSRoauJTRhskOJgX0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 09/12] net: dsa: move dsa_foreign_dev_check above dsa_slave_switchdev_event_work
Date:   Fri,  7 Jan 2022 17:00:53 +0200
Message-Id: <20220107150056.250437-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cdf0180-0540-4aa8-4d18-08d9d1ee8ce6
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408649B36FB5054B8AA99F4E04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p6XTwJ1NzZHMWIOMNtWRkz8HNofMrD/Tb7QfkYYWiITdX6BzSu5MEZigcBfu1+1mtA0eHGR9SN230dNWvK1FHBmqJj70a+fmQyKWsyJivykwSKAJLvmGPVMg60wV5om/NJW4QFl0gj61wSe42hoZV6xkmkcJojGgL9Et0I6Z2MaEtUrcyK5xSRCEgCsoWHQqVAm0MTVGO0xdk2IHi3jkGeEFNtpIy/Lp7RBvRd8fVzQ047rAwxeKz0O+3Nrm2eP7HBkGI1++BR7U4zx+g7oNpmmlmGVrBbOEreOkJ9kuZ7tvezXBfiRrkgwBxknWuD7wxhAmpgQin54llijIkke5G6OaJYMxo0VkKKYmXZD5WMWPoAZxyrL86R3mdbDiBQ5oDTuZYsaFe0d0ajyM01Qe1l5rZM2s4Xra6RqP0AZUtdzt80QqDb13Liy+0deHeanmDWcHJlp8IP99V16UnLZCyPsVHey/0cFDOJAck+ctUQBTTovMQCMMOGniqClRgvyOFhxoQ5ArxXKqZJ0c8f1j9aI2eqs/V9EV55sBv1/DOU/9lAWqNqnLC3bQ7YkgQcBQbt9tPxug04Vxe0bBeF0vWm4iYcVfahVBNL+l5G6AeOqVbjYWYvaZyCi/VpNX6EoK5zTa1D7Kvp4aYS8ZZ9GnzGiCLCQ81AKDnyboIpyE5itGWZ84r3U95FljgTa4TAOFmrZTJTxokYaShdC0SaOFTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8XpElAeo3/9jjRl/PLL3lmfZHEXP9+TiKHWcYXv2NWTIqBlqqCc1hul1kZf4?=
 =?us-ascii?Q?EcmVpKYX7TZhIABWPUik4ffkCG3TGrpath7qJNxuWQmbPSEoe+Al38gD7zYX?=
 =?us-ascii?Q?EvHfUIfxSaI3Conmbl+y2qOzoWlRyoHOZ36GtcXeIERvRDqtjYl7mUhbe8cs?=
 =?us-ascii?Q?4uAwbxaZ22YwGh/OutMuh5tFFD0TfZPu9aUBkDThM+ghn7uf08woM4tOD+DH?=
 =?us-ascii?Q?MPCwGGHTN/w7s774CFv8wnFrYH7KobRh0A+87OW0aE2NrrURJjP/DxNlStn+?=
 =?us-ascii?Q?6uSKjP7HtVrCrQFBd/AaqZiSMa64rfZ0vYxeHSR3/KsWscgJ0Arh46rpuff9?=
 =?us-ascii?Q?gsdQ96A83irPoSqc4SWxh/pgpzhKcbnMXWhO7eN3ZmXL0giM6Y/Au1nw/WbY?=
 =?us-ascii?Q?zzl/+EvvZ6bISnUBP/F4Jl0bzNlLjWwIuxw+EKBmBeIFU0stLkpbi/ncItrm?=
 =?us-ascii?Q?cJfUrFoFCwiSPgBRbuu8nUgtkOUwTRPNO8XO/SxFg+A/XH9VnvMUEX7r1a86?=
 =?us-ascii?Q?v5zrxG/kXbnqkSNudEMllAgAGWAsY5Q8apt+9/8GXVe+BjHDSo1gTpnQa/qt?=
 =?us-ascii?Q?pYEKWvv6s6nzCKeoEQSlng8IjgHal3yp85PRIHdyPugPTeims+R9CZLzLxEI?=
 =?us-ascii?Q?aw/tjm56tvbEO18BCDShO3XXBKIRBSstpgVVoqJ0aKP3tX5ofREjmIO7X9xr?=
 =?us-ascii?Q?Yz3QjaZUTHpIAKOteSdD+tYyw/E19FKjl/tGm5Il0buSUivK41zzaypqDbdw?=
 =?us-ascii?Q?ruTED0yUcqzjF1MEbooy6JtobEV9pxURYESKdswfncPK/xdz0tiYbzQMK5wJ?=
 =?us-ascii?Q?BjoDve7jfFQw39R6MFh75q/Ydn8PI+cW1VbOKeHuFlZrYNRBgmLtpeDBwdUA?=
 =?us-ascii?Q?uHN4k6HB2DsZKe7ZdXJ9jYunPh+s7jBH0pu3jfCWEPA1nBWfvjWRtOmP9xHW?=
 =?us-ascii?Q?KfHu7+rNecBZy70V4AXYToiGAarwzrpPEx3Mm6EVXw/cx1SwoZt1/zasdEdw?=
 =?us-ascii?Q?eqRDuKtj8gFg3Bmzjk3GoGGIKM3Nad+Uo36WKCBZFICPR29Cy3GwRZFidgxA?=
 =?us-ascii?Q?fgPAk5u9bOO6XwDIZ8YJitVhnviX74UGW6QoT0ZXue4XWAatOhvdgHul1QCS?=
 =?us-ascii?Q?Uo3nAeBA7U9Nea0kAck4e+RJm5ZDPbjM0AEWew2lYyyKPTZu+npBcEJXJLur?=
 =?us-ascii?Q?cZuXbw7M087Zhc3FX6qD9KYcFL3BUxM7FDBuo/2PQ6+eI7jWQFe83jKWBOSm?=
 =?us-ascii?Q?Xzg0Xdyx2dGRLZjBMuUwU2g3+cnGsbrW82VQz/r5gUZC+gVD45Et1pCB/k+G?=
 =?us-ascii?Q?pYdqvhZQcXMKNvCepPf3ubcazyzBdHWnBpK2EBKUf6/lk1vEkVQarq9P55gG?=
 =?us-ascii?Q?Xded+Kw0eG+bXaC1M2cKX2NTa1qhKmmjpPIFgVrySM+rxRsB4e7Ps7TOU8Fj?=
 =?us-ascii?Q?StX+Zw29Xp3BGHUET93m+C8RoiuU/T1P/EhYVau/P+O6q+nuqVebVkZRjenj?=
 =?us-ascii?Q?ySjM4Tbr3Oo4Dv4eY6lH9Zfa/0X6zRUkCKxVptxvM1M2MbZ9/A+AImh+FfzZ?=
 =?us-ascii?Q?TJe1/HraU6XkrVgI1cPQmJkwnR+DWnoJ5JTyLbv3CwvW0BXypBRigdj7NMQO?=
 =?us-ascii?Q?iZtV9lgrlaa2XdQ8iNG84So=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cdf0180-0540-4aa8-4d18-08d9d1ee8ce6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:14.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZlJ2etigwEo9QWUW0TASvcwRG/ckrH2LyddR17XvEWhg0LrY9NgioWDW9kUbI8lbSI+GWRmj980zFyuHapmwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of LAG FDB support, we'll need to call
switchdev_lower_dev_find in order to get a handle of a DSA user port
from a LAG interface. That function takes dsa_foreign_dev_check() as one
of its arguments. So to avoid forward declarations,
dsa_foreign_dev_check() needs to be moved above it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 257298da8f83..d087b0ae0a7d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2086,6 +2086,22 @@ bool dsa_slave_dev_check(const struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
 
+static bool dsa_foreign_dev_check(const struct net_device *dev,
+				  const struct net_device *foreign_dev)
+{
+	const struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch_tree *dst = dp->ds->dst;
+
+	if (netif_is_bridge_master(foreign_dev))
+		return !dsa_tree_offloads_bridge_dev(dst, foreign_dev);
+
+	if (netif_is_bridge_port(foreign_dev))
+		return !dsa_tree_offloads_bridge_port(dst, foreign_dev);
+
+	/* Everything else is foreign */
+	return true;
+}
+
 static int dsa_slave_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
@@ -2437,22 +2453,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	kfree(switchdev_work);
 }
 
-static bool dsa_foreign_dev_check(const struct net_device *dev,
-				  const struct net_device *foreign_dev)
-{
-	const struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct dsa_switch_tree *dst = dp->ds->dst;
-
-	if (netif_is_bridge_master(foreign_dev))
-		return !dsa_tree_offloads_bridge_dev(dst, foreign_dev);
-
-	if (netif_is_bridge_port(foreign_dev))
-		return !dsa_tree_offloads_bridge_port(dst, foreign_dev);
-
-	/* Everything else is foreign */
-	return true;
-}
-
 static int dsa_slave_fdb_event(struct net_device *dev,
 			       struct net_device *orig_dev,
 			       unsigned long event, const void *ctx,
-- 
2.25.1

