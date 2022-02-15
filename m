Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0FF4B763B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242089AbiBORCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:02:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242100AbiBORCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:43 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10075.outbound.protection.outlook.com [40.107.1.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE8411ACDA
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofzKpOGDhuAnIZMiWkgXOamdd3QIb1rWf9p0NXDmQhbC20bUm9Wgklb5BxzFpASqTuYDkwZDFic62GPODGYy/MU9I1ZhhgcedBnNY09xMC6x2se/0lzuUzrE7g05H2VUSn2bqMAWa9O662WDgNFxc58lbz6flwFLSofFO/zNN38fdL6kS4tIgr3uxg5pmyPKhhWzmu1QTfGh6QvkQIYgVsRFVpaNNepXCEQzjNoWOzv4awDhhXftTiH5cMIBzQAtwOXJVrP8Mni9FcQAFJeLO0aITlKgTcpGgaEu9mnHdPgSoACBghZ/3T+G9pQUDvEQZRJa1zrq5uj8M12ccZdf5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XrQJrI4qWEOTlfvDq3QOHLxGyxBJaPjl84rOwo8CoaM=;
 b=M+W2dZjYG5cqbiizEeUtsg9lUGD+QRVqgTwm2OEjYKYdGEM44JJ/NXU/6pkAj4Q77jaVSnMt+TahXFyNsaw8znuO16bRKpy87nmPjHbEATvtLiTPt3KWjVBrmsuaGGzNoJ6Oec4R6EJM28bbzPnYE2yveU7CFxGj6HN52X1fxxLMoKJTcMohu1Hr90h2brFsjZWA6EdHzbfKb7bl0jQYqNKA0u3o/9vjbT4UlobBMuqdqsNkOTa/GQWUI/RRTeGIgrn/BfdnAxqMv2f6ct7s9390nHulmhhh+yl3ohvLJfPBvpicimjMO83jZAnqYZuOggfPRnFprR97wUPWtqSnaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XrQJrI4qWEOTlfvDq3QOHLxGyxBJaPjl84rOwo8CoaM=;
 b=i3wZrMdomBTKzVaAWOfzbmdws4pRZ0hU0gGyc+SGVorhxs0+BXRplPSgPlf2DeaSmEnNsg1cned/2zLj79PhpW1LgmxtPfsOFH3mj1XjiwgAhCQ7dmH4Wp72lBnMtnX7yFFcEzf5FqR+qtPXhrOBWfExBeDpYAoOuqJqfV0TUp0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 01/11] net: bridge: vlan: check early for lack of BRENTRY flag in br_vlan_add_existing
Date:   Tue, 15 Feb 2022 19:02:08 +0200
Message-Id: <20220215170218.2032432-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa49f18e-e8d7-4e72-2d84-08d9f0a4f201
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5342DFE4B3BA9BD58A05883DE0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cq5K4gsdnlQGMwW6qmIoBt/h/PjPLNoQobHOrOjTlEu5OOFct08s0tseKpoSkZdxEz4tx9Ok6N2b7fw0UsJOOx5fCVIcyafJOncr3kYwn8YSurDzNHPbbtZLJOpz+43RrrzqyRhlJOoegOYA19OOZhnNNwl9t/11L4GBVSxAZd9cvlErm5ucyQspKoc1UOTy8OAS/ZsL/0Ptn/yTa0IOfT4pmQvVGfJxO+Bdpnjq9UDkViAM8wM0bONHXw/23a/bq1FUPeVuYqyVxy11YT2IXBurpU/o9Q5Jf+ARgp4WmrUYLG3fGoxg/P3OnZiBo0AMQjpS/6eGgAJoDmh+kCf6FCzjhCPrx+9TDXhnRtH438tG0rUsKxDIYyKEvZtjGRnN830X5KFC/hFOc2b9UAmHB0ipgaWedCWK4Gdz1Iq4zqte24/3GKpREDayeOgrQFKwQdKn0TxHUUUVatceC3/OHeuc5JYH0Rj0/H4x1UunlE7wAThi7rI7k8BqV5U90Egs24BXQPXC0gRp0X+LDiwIkQZXAxCtrUSHjN10e5kDgrq2d3rG0DfgVtisZwdS8D05cRMwYg8pEvqy5p4F+OS2LCZ1Bhr45Z8V7Yn2urxcR3zcuy7nw/m7W2zeIOCvQ6u0cxeEHAjqH6WofKKERLyviJPT24NQWlPKAFsIXdo5sPR4YRonwj+m3uC4naoiygcJbYgMpPgde/dzURIKG+xffw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y83gv+vYHLzdUupPLWaxj+S7rb1XZ9EL5z8XiJljSvrixc9GWG94lElEaWh2?=
 =?us-ascii?Q?RMyWwQ76QIC0Zvg5K5wQZFVNx2PjpWdFJlvTjheX2F7UOG7KRqqcdxL23g4h?=
 =?us-ascii?Q?XjjuavmShF+Y3LwUoa0rjG/FSvEqScsh8OTqCoraf4oa8c78T3Fu1u4mQsXr?=
 =?us-ascii?Q?lnzde5gOsDzDL0YD2FmYlHKFTnlSjnPRVMwiMjWWPfb1JfYQd5MHFK8HUTOh?=
 =?us-ascii?Q?DxUPnFIykK7FlHy0e0xmXx8yQxAopQIJRFwdln3q4Fl5pglNmNkfvJQqjx4T?=
 =?us-ascii?Q?W8c1eAXxVN7w6v/pWcdWrDD4Jk+9x9jN/oKUVWCiv5ZG0CMdwugBEel/kKE0?=
 =?us-ascii?Q?e585ry6dpsSwHK+t/51cdH7/nI3vjTejX0/r/ILzT+hDSoo/B/c2JFrO+HfO?=
 =?us-ascii?Q?3br/5I0W64EhuF/AahfHNoFn2o6ABli6RstlOhrHECBX7uwZnCkuS8yadf79?=
 =?us-ascii?Q?ZR4rzsTEQkG5S/mNBZD6FtolzU9XGP9FNVNGDM6pwb3mH+ChQyyeXZNFTcLC?=
 =?us-ascii?Q?RVm9WjNJcpilluQbwhbPMTQVnM4iblnbjnR1AmOMWvWirgX65dmMofSyzY8W?=
 =?us-ascii?Q?IV/vQRkjo083zH3sByHuYMQyP7HfPFc6a0PSWTOAzVwS4WguWY/4Udz+sypL?=
 =?us-ascii?Q?UL8QNfs1HXwRgQLZqTiiOqCP1QBJsrQM+24KEqppPfOrIIwXnJyRX7Znys//?=
 =?us-ascii?Q?sdYrixFK0RN4Qsl0JyRAlAELPz3z5mqPqANtcYOwsaNUGItG9gabd05u4Ji2?=
 =?us-ascii?Q?58lrdIg3ZZNg6uaiGlItfknfEXYSy3OvkaVhC8EMUvjjcOjE3xS+J10meGUi?=
 =?us-ascii?Q?11hbNb19GPlzgB8mdJ3WDu6abDVwhovOBJiFDgN6Ji7P9wc/gilJ9JJJnfq9?=
 =?us-ascii?Q?cXfJX318nbDqyWPmdmOV16SAfucwpFCn48q8WSvl409/1wk3HTmn+E3rdjMA?=
 =?us-ascii?Q?nHHZPHNYAblSe2KmBISjAOXl2vUs/K0xc/7ijY7WCakzYQor2AoVAI/m4jb4?=
 =?us-ascii?Q?8ZpNtnt54oX7rb1I+UwBOwaJL4PKS8ukDsrMdU5aGfD1uBxj7ZfnCOM7Izs+?=
 =?us-ascii?Q?yt0NFufivxvUUAJKhenAG2OmIx/2B429ZT60fgR3G0paavrZGyo/NTD9gOkj?=
 =?us-ascii?Q?/E64t0Iw1xI9SGkUN2jFiV8z47UPsVFSi9SPxrpqbSPSuKTrwMWaZwVUu0sx?=
 =?us-ascii?Q?9DYhB03gB2smSGAJiJ8iH9Z6N37iubfyfaMv7t3zmEeYEu42lVvczMehA6u1?=
 =?us-ascii?Q?R0c5BVSyMH++r2TSlCaRq4C6l3xbV8h5nQzXirxrPysioXqUMVsTkOvRC8um?=
 =?us-ascii?Q?FUBB3WmW7mYYK2hT9fgoH1DqLoWggn4Mwmb7ZOI/lpQlbrQWTNBvWaBT/ORd?=
 =?us-ascii?Q?0xyamxC/ftIpPaKPN3HmuEH7fYhis7RPqfk1EoaO45Pt0PkWpz+pS0hG/+OH?=
 =?us-ascii?Q?3iFv2Jj/KLInPiWVTEuS6sDtsAQ6fqUxG2ujcwLYUksfV1rUkZHpgUWpINqs?=
 =?us-ascii?Q?OYoePiQ96DdXuADyajHM1lTsnIRhVpvwkkbU0wsa0zWz//rQvnuL8znkccDK?=
 =?us-ascii?Q?p9xkJ2IZ8J8oXU1PcNjMGQJLKbiK22dSFv2lxSYYlgyyeP5S7067/y5UclIa?=
 =?us-ascii?Q?vGyfO6XxNbo5+UgpJsEi57A=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa49f18e-e8d7-4e72-2d84-08d9f0a4f201
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:27.7133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LI8OI8ajMj+N3k8whYsIUzKfw72C/XgeSSWAxxrUd0tKTSAKI78FekwkPc0jSOM2KpHtdcMZsQmRtKjYfE0T2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a VLAN is added to a bridge port, a master VLAN gets created on the
bridge for context, but it doesn't have the BRENTRY flag.

Then, when the same VLAN is added to the bridge itself, that enters
through the br_vlan_add_existing() code path and gains the BRENTRY flag,
thus it becomes "existing".

It seems natural to check for this condition early, because the current
code flow is to notify switchdev of the addition of a VLAN that isn't a
brentry, just to delete it immediately afterwards.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 net/bridge/br_vlan.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 1402d5ca242d..efefeaf1a26e 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -672,16 +672,15 @@ static int br_vlan_add_existing(struct net_bridge *br,
 {
 	int err;
 
+	/* Trying to change flags of non-existent bridge vlan */
+	if (!br_vlan_is_brentry(vlan) && !(flags & BRIDGE_VLAN_INFO_BRENTRY))
+		return -EINVAL;
+
 	err = br_switchdev_port_vlan_add(br->dev, vlan->vid, flags, extack);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
 	if (!br_vlan_is_brentry(vlan)) {
-		/* Trying to change flags of non-existent bridge vlan */
-		if (!(flags & BRIDGE_VLAN_INFO_BRENTRY)) {
-			err = -EINVAL;
-			goto err_flags;
-		}
 		/* It was only kept for port vlans, now make it real */
 		err = br_fdb_add_local(br, NULL, br->dev->dev_addr, vlan->vid);
 		if (err) {
@@ -702,7 +701,6 @@ static int br_vlan_add_existing(struct net_bridge *br,
 	return 0;
 
 err_fdb_insert:
-err_flags:
 	br_switchdev_port_vlan_del(br->dev, vlan->vid);
 	return err;
 }
-- 
2.25.1

