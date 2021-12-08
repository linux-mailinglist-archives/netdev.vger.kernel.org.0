Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D76846DE67
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbhLHWgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:36:23 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:31041
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229533AbhLHWgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:36:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyfMD0tSpY1h8CL40o6zrnm+OXsse04N9NGkOvgqHTqQ0Ncf1J8liIrCXqwcXZ4GoT8ojGtlsB/LKtrvAVuWEfh+gmqXAFm/4TzeMw53qu1X4hFYrtrcsG+sBJJrVUsSyZDUgjGjoSTyM+HVh/wv3GuKrxEmIdIrBUHNQBg6gSQ6MBgVyt9RNfPmB+6nENsxL7nQGkmzVe5zTeEqF1sNSgSWa8Wlb+a+6VGS2ZPStBZ+JXQcAIzSVtf6/OWkM1joTNPRMunzc+IJTfSqS7RGnm+kPigmocLovL42M0DNPaTuUoHJar36Jitt18poFI9g07yB+EJk6qpK+wuG16KWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmW5EENGOvZh5DR8fMLTOI2KQO/ELi9AV1KyC273iOg=;
 b=A12DUg+cYOAwRPQ6aSCKus8fPAMihfKfN/lJiRBmKApFg1uIIItrbgFpw8hBSAEnbXVyeAQHLAbmcoOFfZnoG8MmRpX6CQizH91bx55+fBHNh6ma+le9Ncvot4OgzU1MmaYkLy0G/Yl8xxv69uwabA/aefnjDbpc6XRahg5iM+t1GF3adFogtQft5o78qa149daEYgfDdyHaG+Sd/zNm9JiQ8jRbYuLYw/JOpwbmqcNhWAMb78j/tCIr+YSbylyMHGRudMCfilzLwcjn9qOFRccnrW2bD8DQpLyqSnMys72cdkjEkWAQoXcxqgAw1tcS28mruvBIdNG8Qv1D3qLmAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmW5EENGOvZh5DR8fMLTOI2KQO/ELi9AV1KyC273iOg=;
 b=UvQTQXvVi7Xy+cayCWTedwbwg3eowVbg8I5x2JMmMze/3oLvuIFS4hyDHPXjFfsGsOv3aeOABzQbho0/0BWZUOsHgzfci2HWeInxvepIzyPJS9Po8TFJ5ko914t1NSk/ofvwiBHjTHa+t0L21YV4aqDwDDiPjOSA2ZRhL3krcF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 22:32:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 22:32:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next 2/7] net: dsa: refactor the NETDEV_GOING_DOWN master tracking into separate function
Date:   Thu,  9 Dec 2021 00:32:25 +0200
Message-Id: <20211208223230.3324822-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:207:2::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM3PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:207:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 22:32:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 286939c8-7145-4f60-d2cf-08d9ba9aa86e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34087A1B145A94133671A448E06F9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6JI/mdaCsOtCvABkENCLaXXorxmg+CyHVFSuCTGZvqb61xUp/Gdh0NN9u9OSNW4cL9z5fWoQK4C3TYEQM/BH0BsinUJ0AEgYnH/d/iLiUdQuWcgBQC9y4M0XDMFe+7z/WYWEMdl35iicx/gfyVftmkQJv5ZKfYolLjZJHgTrhMDAy494eESDScZZYjsZHJ2HPGnFpsbCvnqsifVXdN/NZbSF/1NDBo9c9eJY96nSDFBqQGrI01vtH+Z86BZ/dPHjSjXn5POn0y2yUrj9XTQ/npSSzfNUW3CLy0ISs29Rqk/2v5IPqooMucVLIgBCqbguRIrS8lCCwUO2YWJ307XtLj1oK86m1ZXIBpwBhSlc/xQgXmmB8UUoqjzvo13qBf8yp2DpWDh8N09UKacYQ1lAcaMzOXz7tz3ml830LMn51XSzVr4BQ2UQ/HrLbrCrYyVAeBIU2RBOl55tpfqwJcGaSDcizZSif79vic2PmirBm8dTN/sj3vsKherS6tbGApthATd+2siL4vcsPI7YWztiNWaN5ZJJ4lDkzD3Gh7x0SD6hYH9k76E7aLvVWrmJA1NGT4mibBO8IYxuj0xGQj/HvitTYEaT9FzRNVMBtoR1aLDkgJ6uvltrflbgyHV4oOhpiaDhf9h02M2PjFFADeqkDN3D1nJakOX827bRH0Ka5ZZkvnq+IEwVgzLxpEwnEKnIRlSwcejhsdQ1zfafGLuYNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(66946007)(83380400001)(86362001)(66476007)(1076003)(44832011)(956004)(2616005)(36756003)(6666004)(38350700002)(6486002)(66556008)(6916009)(26005)(5660300002)(186003)(38100700002)(8676002)(4326008)(8936002)(52116002)(54906003)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Ysphoyp/sfO9CS2G5zmhofbpFs6+QVnk15XGSzhMirazKtTtZAjSfhI7RmH?=
 =?us-ascii?Q?VPwpo6ACsHaMh8n8ldGIAr/n7ih9haaxDzvHB5/6ciO6ddYuAz9g1j5yRwq6?=
 =?us-ascii?Q?964pxYoJpIjWISDkOQfBqTi4sO47DIYNjOmQs1mVfIYvnJI3TRX+8q6qMBqn?=
 =?us-ascii?Q?D2a8klIUqTHFEPaAJuRGzLvUAzmHaCQAGrfTVjKobE+5mRg1XW6E9n1UDzF1?=
 =?us-ascii?Q?ht++oKl+vXVrea5XKjbi2tibKlWTNFq1Xfahmx6BJZSwBR6yv2hCcz3zN8sp?=
 =?us-ascii?Q?pB7aLfvzOYRGv9a0AQByu2ibq3VaPF1oo2S7yTvVgus2gl5HJGooGObJBROC?=
 =?us-ascii?Q?fbLcVaHRyxA8EebXYB8xQygGOtanuDQ7WvGA6slns7B/+kbQCZ3oa69FcQJY?=
 =?us-ascii?Q?f7lNgasIlbddaiL/jxTQudB07q0iFGEBpbUgE1Aivrd0GxjZexoY5K/GS687?=
 =?us-ascii?Q?lCT4gmMzo0N3T0oepjoq9LCe9DBznXt7REqwmKKJZG6coGVfF24rGeZL0ufF?=
 =?us-ascii?Q?Diia7rntfBgx2KDzW6Ejx8KPdb9v9MqhTMFQ9UxCdLiVMJTyLmtzasSWcrTD?=
 =?us-ascii?Q?FytZqIYDRFrIViWrM79eJrPmYy4ahDWhwAQX0Jr1dZxT1dOiOTwsCW7w/m0I?=
 =?us-ascii?Q?Q0ySpBfNf4Dni6N0QC0WuwhfnB3ujjpLLfDBmcGN2WyCGRZgK9QcVu0YH++u?=
 =?us-ascii?Q?9lCMurkISSVTm3QGNowjIqXQgZDivid0WD7IOQqXUIVnY2hMHcdkdxPZKavk?=
 =?us-ascii?Q?TaItlRyD+/IXFqMF71YjHy+Kl+8A37WoSRRHf9PpQe4iDzUzMJxrGsM0FvNP?=
 =?us-ascii?Q?GJKxbSTM80P0dJSQE+nNO+E1C08N5o2XGhvz7MYsYmp5LwIuE9+gXP2rAIIy?=
 =?us-ascii?Q?FBaP/KM2CAbWi4e+fbM6g5rQDBfcBDW90N1GsdlxZFycIOTJ8FZhtURGaGwr?=
 =?us-ascii?Q?D3GIuhuOvq3YF+b4V4z/8nXcEJXTp67QToySG07TrIT0lhZvbIe1+29b9ehv?=
 =?us-ascii?Q?mlHLrLz9PrfOnNAV0Xg+L7528oJmo0j2/UVtEQsbThkS0ufdbLCyuZJIOhSw?=
 =?us-ascii?Q?/SKtnjXuS/bZHH4rYCrYPohrgDBbfgJog9EeoondNSYTxIXD3r2DmA2IZEns?=
 =?us-ascii?Q?VnvVoHTxXFQ/s7iU9rVP5fwGUf+9ivabYGhkPeFE0CESD6T5Y0Wk7Dc/Gja1?=
 =?us-ascii?Q?vkZBxcm5TYVGHukfCyq++2bHopRoEDH8/zyKDjp/RywK6dElfDfRW31b6z98?=
 =?us-ascii?Q?oQqG6BZLWQDwfhecedjQBqGvOvEfPJ/UwCCdXrgUYvlezuzYEElGDqMj9NHs?=
 =?us-ascii?Q?s1tecIGOEyv0X/TQ41zZKtpb1aor4cVBeziq7wL9ZG4QRDeANHAvwBF1sD7B?=
 =?us-ascii?Q?mbSWbuuAk5WZce9Ey4AZyE4u/KMux+HH6fTAFLSKvA+bPwXeNSYsdVHuXEpO?=
 =?us-ascii?Q?BEAefZw/vcYz95aOgJwWzEdifOPYWocrkF/USIZqeWcY9X5jZKAst3F8pYKv?=
 =?us-ascii?Q?iMblCExwE7D/WkN3LC1IPvcxEqh3lH7onFgb4H3NtavE+CdgvSQYRd+Y6anP?=
 =?us-ascii?Q?gBYjdS73ZsBpEAiLS62ao2P3VPNGh09htAoagzQtzf7y3/SIWImHF5B1Sjkx?=
 =?us-ascii?Q?aPLr/LiFZ1ec2NHcG/7o+C8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 286939c8-7145-4f60-d2cf-08d9ba9aa86e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:32:46.4763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n2XFH0UPqF3WOXlv9kCKMo0avhj8F2l62GNOUP0ZIBC2fcfS+muYtTWuCM8hdpgI1QlNH7GPBDMHnQPlpbpnkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For symmetry with a yet-to-be-added function named dsa_tree_master_up,
move the logic that handles a NETDEV_GOING_DOWN netdev notifier on a DSA
master into a dedicated function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c     | 19 +++++++++++++++++++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/slave.c    | 25 ++++++-------------------
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8814fa0e44c8..438304a22e0f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1187,6 +1187,25 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	return err;
 }
 
+void dsa_tree_master_going_down(struct dsa_switch_tree *dst,
+				struct net_device *master)
+{
+	struct dsa_port *dp, *cpu_dp = master->dsa_ptr;
+	LIST_HEAD(close_list);
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (!dsa_port_is_user(dp))
+			continue;
+
+		if (dp->cpu_dp != cpu_dp)
+			continue;
+
+		list_add(&dp->slave->close_list, &close_list);
+	}
+
+	dev_close_many(&close_list, true);
+}
+
 static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 {
 	struct dsa_switch_tree *dst = ds->dst;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 38ce5129a33d..21bd11b9d706 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -506,6 +506,8 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
+void dsa_tree_master_going_down(struct dsa_switch_tree *dst,
+				struct net_device *master);
 unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
 void dsa_bridge_num_put(const struct net_device *bridge_dev,
 			unsigned int bridge_num);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f76c96e27868..4b91157790bb 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2350,29 +2350,16 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		return notifier_from_errno(err);
 	}
 	case NETDEV_GOING_DOWN: {
-		struct dsa_port *dp, *cpu_dp;
-		struct dsa_switch_tree *dst;
-		LIST_HEAD(close_list);
+		if (netdev_uses_dsa(dev)) {
+			struct dsa_port *cpu_dp = dev->dsa_ptr;
+			struct dsa_switch_tree *dst = cpu_dp->ds->dst;
 
-		if (!netdev_uses_dsa(dev))
-			return NOTIFY_DONE;
+			dsa_tree_master_going_down(dst, dev);
 
-		cpu_dp = dev->dsa_ptr;
-		dst = cpu_dp->ds->dst;
-
-		list_for_each_entry(dp, &dst->ports, list) {
-			if (!dsa_port_is_user(dp))
-				continue;
-
-			if (dp->cpu_dp != cpu_dp)
-				continue;
-
-			list_add(&dp->slave->close_list, &close_list);
+			return NOTIFY_OK;
 		}
 
-		dev_close_many(&close_list, true);
-
-		return NOTIFY_OK;
+		return NOTIFY_DONE;
 	}
 	default:
 		break;
-- 
2.25.1

