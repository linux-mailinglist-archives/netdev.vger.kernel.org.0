Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42A54F9DED
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 22:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbiDHUHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 16:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbiDHUHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 16:07:07 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87571350498
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 13:05:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjDYQKNayM2K3PcqvJvCSLALDkMh7nS0loWgtxBFLtvAktc8VyghefqXAtusHBozd1pxDbbTNdX6DMOn4zBUFCcpmIbVL7ppVWb67gS4weNagxx+H6+cAFXHItBmqIehBsJ3uMw5WsKIAxuueuI3WAVwA3v1skCccrZRjjzjqfAsRD09xA5zPniA40iIOrIKX7F+vNfaYfzqXCYtlEQxGveZbD61J/LPHfleFTQBpDf5vJoUMlNE4rW8EnmyYmt7cjcPkcFIOgSg8LNtxLVoqUEUlZXGJ34DjpoVzX2aJ0q5QG5gj9iwdPk6U/xX8TCM+WqLCYrFjDld9x0DAA6K7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVoxXaI4Uu2it3O/izgC2f0vnwlPsBGO7zf9QXgDNZQ=;
 b=SPTzgevAbna56QtnVar8BafLOz9FULMplGv/5yQQAyiENIEhzYrZHU18Mt8kHwRkND30+rqlImjhwvPWo+WudQmXYAGy+7A81jIjdy5HFd95kjsaVYH7jjypVVaau2R4t/YtY435Rf8Ho7L9mzABWKe8p0wps5IxgMWxRgw+ZEQqLtn9yPrf7FzYBheYsujvZGtLu1V0Po/B1br3n5NOOJHFVIxmXztKClMxIp2+4yURue5Mmw9U3JD7cnrhJxO9krICPvQixBJOeZFbpL00nZKrgz4x8rm7BHvSP2BVyU5ZlHt3UPfYHLa8oHNAN/FVEMe+QvVzCNtsLgM9AjlLXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVoxXaI4Uu2it3O/izgC2f0vnwlPsBGO7zf9QXgDNZQ=;
 b=mZGfBqjMlyr/WU5vNz5e5M14gXL1zG9BjV5sFtAqMlW0D+7PzgvqbrsbppaIJ87nUWe2+hb/yXCA8y5VEkQTrhWEnl23y3NGcMakECcoAFZY3wEIXIp260AKOmSyaXMNnyX5qhUrS1x6X4loGsE0uuZKVV/8/tX0g68EGMYyq14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4275.eurprd04.prod.outlook.com (2603:10a6:208:58::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 20:04:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 20:04:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next 3/6] net: dsa: walk through all changeupper notifier functions
Date:   Fri,  8 Apr 2022 23:03:34 +0300
Message-Id: <20220408200337.718067-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408200337.718067-1-vladimir.oltean@nxp.com>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7c3e123-940c-4f16-3497-08da199b0f39
X-MS-TrafficTypeDiagnostic: AM0PR04MB4275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4275B56805EC852BC8DCB04CE0E99@AM0PR04MB4275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PiXZIGv039RReHmQmdHxVAPmYwh1a2hyyE7ZRgdM7wNL7ktgsZPhEZzqoJq3cgO/HCqwPJjazOLDl/5ssx3LvhyexDJt70r6miSjKMuCKuV5YZDXWb2izVb0iFaHnNhGF7N5sLGf0VvVJgV8aLFzIY/DIBRzp9wBEmrB8m3GGRpw1fyeKwmaJKpKmDxqg3n2jlYcWb8mvY4PKeTkjyfe04AWmtAW0Hm8YcQ68YWAB2cpxhalg0dbnGSloxcVp18k5j6u/DoHO+8bpIypmxZBlxfJzc8WzMq5khEYeDDqGPXGPsktgfbpx5P7HYZ8HDmJwWTZETZJ50656hrp50BLMJoEPlZ0PSTwi7dZkMuHILj5U6Jfif7Yu2/yyksuOqWTFKOzWu+JngP30cIbWD15yEpUbJCruc9qfVPg5WWYKC4/eaFFHvFm+77CAKKjVFZrFBvWkkBHkJ70Mku6sGtCuLhv5lGNmSL6jI7NVeNpjN95AU1dbj7lmpGU4RU687tsGkvLTLE/OGRVOyscJyE5oZC2/xPUI19P5xPKAXQ/Y7LrZHi9ppHfXSrP83fPoNQh4dm92ayq4AKmM122qR1F/GgjI45JTTT0Bt3SzP7ivNAOYVaeZ6zGgSIA4qXMLBtQXr9qiR2ADjcNWOTnPa5byQLDxwl/fCKyamrsc3PWeZ/QPYD7shojh6ltV5Syo4aPmrnqm1aLZXoGDuByfkGrpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(44832011)(54906003)(66476007)(66556008)(7416002)(6916009)(5660300002)(86362001)(6486002)(508600001)(4326008)(52116002)(38100700002)(6512007)(66946007)(6666004)(6506007)(26005)(38350700002)(186003)(36756003)(2906002)(1076003)(316002)(2616005)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gsemPkNJAL7Z44+R2J9wr2g8QsaB8Vz8W2N/Y9RnfjtaP1gCny0RXkPxi5D2?=
 =?us-ascii?Q?tnV0Jv/uSmv168YiqYKim4LvhmySfMTCvEQAGsSHHQ6H9v2mxezSvKvok54q?=
 =?us-ascii?Q?1ruDaL2GJfJzep1FPsphfHHOWk/CYKAuNNUayMxZ8L6Bq4iL55mhS9HER6ws?=
 =?us-ascii?Q?HI3Fs2Ynih4RD7YjOGxYafD077OiFZCLODqdRItpiCEWn8TEzWisImVojm/f?=
 =?us-ascii?Q?cKyebFOl+Hh7KNCf6aQAuupNd00ucy5idQeue4l2k2TpT1+hXIljvqbFjAKW?=
 =?us-ascii?Q?lFrDMQsHj1qnzWqCAqXyYNggrmcjKnC+TpNxolbESUc4yIDBw9GxcOAdiCzS?=
 =?us-ascii?Q?Wd7bkXmgeit11ZADnvanchVK+iQN/0CPqaYIGC0V0lpBl9ZxFQUFAT0zljrR?=
 =?us-ascii?Q?uKHB5Nb5/k9Y8eUvkIG+8R0wdzbbvpNt6SwhrqSPv2J8yfHL/410DQV0te26?=
 =?us-ascii?Q?9+1kK0UA+wbNKVma9NAlPpHVVUTZMV2NTYYSkU9qy0JwOUovjWVUjzUc41FW?=
 =?us-ascii?Q?KSuU4dmq5ebHHsDHIrM+ePMFuUVXSUUnFOMm3D7nXCJHx83Xwbr1ZPWmEJV+?=
 =?us-ascii?Q?2znB82JRpubZIXQxz7YhywbYdhVUdS6v5Dk43HYXIzsT8u2q9+k9k9HJ39zb?=
 =?us-ascii?Q?9hdVq0GqX1CkmzsbivmAuqA6mX1tNOVI0xTW6Rgc4M3LMhvuIRxwnbWyw+21?=
 =?us-ascii?Q?rZT2kVGFgpw1NWDcLTKDEAEpXJlGUz+gN8nuYObg62wzS5/PARdFyWFg5kTb?=
 =?us-ascii?Q?KKJdMbSg3Pao8zIEq3x7GNiTWGUH63i7JXCAs5QJ3xLCUQfTSuM7crywpfrH?=
 =?us-ascii?Q?pSANmPBu5BAyO0cqJYcj+jziz1qyB4TYtLRTdXVv3KR/dyF2UaxlVqk5LbGk?=
 =?us-ascii?Q?pdu7hfkmA7AEfLUY46zKm+19vgQzSzJI3dHcKycdsvGG0REIvJJ4H6qQgVUm?=
 =?us-ascii?Q?ZStjRMwBs9VIYr9rJNJPEDRtD+1Zs6LW6Fr9vosJa2jl0l3/b6oCj5AfjYQI?=
 =?us-ascii?Q?0AybALLlUr/iKUMqao8HRv8bfT5PwUzstJXmLa7nPUSskwd48kgHCm4JR7Jt?=
 =?us-ascii?Q?598afwCB96X5w/Ieu9S37IUsTtTqgWBSPGFX30zFi9By9jzNJXY9D5tob7Bd?=
 =?us-ascii?Q?616MAa58ie1iw472pjTm5p1CvS41BAhHmjfBxbyLwhkzXJZExE6GlmQ3rlo0?=
 =?us-ascii?Q?yiPedtw/Q7EsQBfSOH1whdIDH7rUOnKgQ8/MjzLwyq31kUhEVHLf6vtW8yko?=
 =?us-ascii?Q?efgFtZpjmEefSruxf0K8f0nY8zRDh6z2+PLqsPbTwC2yhAbOu8gY1NZNLH5k?=
 =?us-ascii?Q?xx+saij7uqIfvZaq/jm3VXI8o66zt7AKJutnxKG2deUD+yX5RyK/OoErsG1B?=
 =?us-ascii?Q?3zi2AqFGbnizHFZND37dH/v/BFV+znqRrguLKUIm+8212Bwc/fI6KB+qIfZk?=
 =?us-ascii?Q?M8evvyrRvpqBAEG2mOfiFMc/pnyT3PQxgrEPMvS3RQo2RrVD3zYS2m7Bs4xR?=
 =?us-ascii?Q?+XwmTuS3rlLIgoV5uPVzEGiwoMiLKDfpQh9CZ/3OIHub9NjwyXGS1vwJcxBA?=
 =?us-ascii?Q?TO1+B6K20zByqK+tA/i0Qd/bEtnpBuh/8sd/Gf1fN5hLsGjYSL9yeY4Jl7/B?=
 =?us-ascii?Q?7eddDpjBWPp7ntBGw4voRUR0keAzGZbbBic7jqKQ+zWB9ru0L+CbMc0/QTxZ?=
 =?us-ascii?Q?02NQzqa6P9HHGdlcsmgpnvpRnnD1xQu2ZJthv+IMwwE9nL6+iWM13Df2DpgI?=
 =?us-ascii?Q?AspcHMIsCZW1q9FqyKLLnl4sPjH19vE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c3e123-940c-4f16-3497-08da199b0f39
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 20:04:59.4410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egMPj4XbXa7FiXkFKLfORfwGcyDFb+9Sxr4jgeQYHwhfoU14xgkEF8JEdgg1ZjO2jqDEsAP/72iz4RS5YNrSQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Traditionally, DSA has had a single netdev notifier handling function
for each device type.

For the sake of code cleanliness, we would like to introduce more
handling functions which do one thing, but the conditions for entering
these functions start to overlap. Example: a handling function which
tracks whether any bridges contain both DSA and non-DSA interfaces.
Either this is placed before dsa_slave_changeupper(), case in which it
will prevent that function from executing, or we place it after
dsa_slave_changeupper(), case in which we will prevent it from
executing. The other alternative is to ignore errors from the new
handling function (not ideal).

To support this usage, we need to change the pattern. In the new model,
we enter all notifier handling sub-functions, and exit with NOTIFY_DONE
if there is nothing to do. This allows the sub-functions to be
relatively free-form and independent from each other.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f47048a624fb..f87109e7696d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2463,6 +2463,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
 
+	if (!dsa_slave_dev_check(dev))
+		return err;
+
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (netif_is_bridge_master(info->upper_dev)) {
@@ -2517,6 +2520,9 @@ static int dsa_slave_prechangeupper(struct net_device *dev,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
+	if (!dsa_slave_dev_check(dev))
+		return NOTIFY_DONE;
+
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		dsa_port_pre_bridge_leave(dp, info->upper_dev);
 	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
@@ -2537,6 +2543,9 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2566,6 +2575,9 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2687,22 +2699,29 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (err != NOTIFY_DONE)
 			return err;
 
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_prechangeupper(dev, ptr);
+		err = dsa_slave_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_prechangeupper(dev, ptr);
+		err = dsa_slave_lag_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
 	}
-	case NETDEV_CHANGEUPPER:
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_changeupper(dev, ptr);
+	case NETDEV_CHANGEUPPER: {
+		int err;
+
+		err = dsa_slave_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_changeupper(dev, ptr);
+		err = dsa_slave_lag_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
+	}
 	case NETDEV_CHANGELOWERSTATE: {
 		struct netdev_notifier_changelowerstate_info *info = ptr;
 		struct dsa_port *dp;
-- 
2.25.1

