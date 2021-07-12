Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE44C3C5F0A
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbhGLPZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:09 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235443AbhGLPZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNsx2FSEe6AnAKEBVGb1ZhMS3hRyl9QSPg6W5hh87zt8pTzPrU6x6ggdiYrLnGHTmzJatG+0/BL5T1GqlJWB1P481QT5RquTbQDJOVjNF4bHHh4Ir3HIt0bKGXTENnT//l1WdEPJk5b3ZlDhwgMsNgnYPEfTcfulhO7SG36BU1YRzHMsfNwZViC7IqQ1SPb4XRsMShgGPWg220KRpHGrMI9C/UcTuHw2iJa5AseDmif4HSE8BLab0koPSJu9FrjyQqB0S7YuMJXU0ghlKn1txzf1fvhdpcqK/jidrwGhVgdVPci0CkquI4b58fQMYeItB0L0FhPy3KDh9UfzYrvmiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1D061jnBAD0XbtV38n3i24VJY2RK3DQPlT/pABNFSo=;
 b=MrBrLu8dlKeg4/tZ8ylRa44B/quey6Jaw3R08ISaVfwvc1qxlmMeW6gu3tHAzWACErPDO6bwbxZUFSip1ydO//g27lWerc/N64Fvmtf6/C24X5otas9mLE00TMJKczo1KYo7AG86rAllDx6wM9mu5Yi4ghu4R7D9X2CvUVRxwR2Ggod/5MsT8hJO3PzeR2XHNMdJmwqaoQdi2IZPkUCOpanbwrE4RA3qohchU63lzO78tuNfHUCNabclcXLAGOfukMhOXVrjkD9FlR66gO0m0pDS8bavC5IWVrQswYdJs+8y/coAI80cn2Tlky9FumhL1kj1B81YNgfgBJzz3onxsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1D061jnBAD0XbtV38n3i24VJY2RK3DQPlT/pABNFSo=;
 b=IHY0Lks8Npr9kpjSCNbxzrmpftBieLO7O1RTHtgJwc31TMWP8zjAEH6N8DzeKX6DTcuNarBL0GDEiGt6FO2DNCKjPkFkzCkoADOLQVqWHL0/PUVKXkal6JxrMZhkvnkZ85pD0qDhGa25i8virHRSHEldndXb4u7pLmi6RpdKeFc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 06/24] net: prestera: refactor prechangeupper sanity checks
Date:   Mon, 12 Jul 2021 18:21:24 +0300
Message-Id: <20210712152142.800651-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3382ae1-9e7e-4924-5dc1-08d94548d41b
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6271AE89161BA331E12CABD5E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cr0/QzpnOYGpLYvQVUJ4XFg+cXw8WRFPJyTklUYhu61Rh2aggZ+Kp6W7A/Gi30yWmjtvI7CIhPUIbg07xAkgfM+XnhSOSZh2wVfLmuCcY2KBxl5JMtLJUMEIg2FqyVixQ5B2gZ9dMo7Ywm4Ko56DUZl3SkA9kkY3XnBDS4IVGLajcAXLRG5F0+u7yrj0DHTnl6Qi+W+GcuHUY+glOjGCMfSHvaRWdI4PPw+a5s5TsfiMNnHUX2sc5tkSQVrVqLgU/Dnp0mL3lmtqGAji25wnHFxTmhEjDZ26MKwZNLJ404WCiDgII5yDaonQW1voHLQDgjlGDGmnRpSCi25N8XZ0ZtayHLYM8gt/+FUH3vtPdOuuc7zbjkRKjJP9GLiTdXdIzGOFx3FbTWmAcBJU7IRRaRuobPXyNs4G1wP/ThxRcpfG9ynoPayGlXQ7Ei9f2DiaDzpi8mgVNa01v65Mbj4ZvcW3UJ04pPaO2WsummH5GMKIQ5dWKXptam+vaO1l/gSTkCdn7JK2LMSjNHaXbPfeQW/CrdTbmtn+2Q5ykaAWhrK7tjYyYW9XQAfcXnYcNyXsz52Cji0RWUl6Vqah+nIHWg53GERcGvmZbTFpnQmwcCmb4Zgon8n90YJWO2+1YKJg/mlVA4bCtAx13hLqiRuS/GRDOliwvmoXwWvvWHcqTd3QBwfdEIYHCCvdXpM8FU0Yj/MnrOz9fQYK2b6iGel3rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9HifCo3iT7c27gMfFuECXVZvZpdd+nRW0HpnjGuRLmRDaIIZ+noUC7rYx7q8?=
 =?us-ascii?Q?kalofVWZjipiiWu94mP054WFMObo+dsXhRA55eNKXIPSyO0gETQBHySIPMBQ?=
 =?us-ascii?Q?oHOqEhRrUJOOIqN/uOuRzVoZO33Y0MiE5v1HpwMNyxCDyml70KgxrOGyQBiQ?=
 =?us-ascii?Q?Xw2J5Ux8scc5vHCjDU59xnnMtVKYppXbntChOZGa6kgS0Mie1hWSk/u+McQz?=
 =?us-ascii?Q?4QKCyOuLuFjO8SPQhqdW6/fNqoZuf/2jvIullh2f1EQYWH3PmtDEwEkYdA7+?=
 =?us-ascii?Q?fHMRaEN3cnlhaaD2iOMhT4t/Um65fioXVaaqVzc8HDgJVL+VScxowk05qqA6?=
 =?us-ascii?Q?UE145dXpbv44a7bL1mcYzA52sbxNm2Wa5TL9nxJGia9fecRfONEy/4Nsn259?=
 =?us-ascii?Q?NMwIBLiSDu0ACMqlmoDSvbDikg36ExoWjPiUMNlvt7+JXfEQiee6JjtdH3PY?=
 =?us-ascii?Q?mhzg60WkRwXr8lq77sHiCKK/QNt5XPtC6LN6q8dHSDZmaAFRHTjgybZZdhiS?=
 =?us-ascii?Q?HF54nepMH+vHKGK6GYjqu4NFDkvnWwFdSKLXND8s2GGfQRoc8q/jYXy5JUvA?=
 =?us-ascii?Q?u2npCo+YpWemk48SIPu05rqo5wrNXd6Fa8bGWnL1eszkx9T1bjui0YLkVps9?=
 =?us-ascii?Q?GreAqBgCVib1J7yFwWbLZkuD3kmolkOLSoTqqpdiAmc/7aQRwZwh81r5cWRw?=
 =?us-ascii?Q?LD+Kr3rlmZ/VN0BC01jCsEH5ssO5Sc726iFyoU+OFMWJEbNwjDf0gVfqtIw4?=
 =?us-ascii?Q?8CtTtRthaASvlI8LTP4wxEKwOjrqHClabdqwpg8T092A/+lCrxI3fr5xVRfR?=
 =?us-ascii?Q?cEzdnyLGvcOzmYJSLVDj6DuXfLpD4Fl5semmA3n/AKITRSVIH7HFtRY41ASL?=
 =?us-ascii?Q?PFTSLNSTW/ccne5pZtNczatG66aJ7h3aHjufBel1DM/pFH36wWBiPPK3W8HZ?=
 =?us-ascii?Q?BJgs58V2GVA5HAzj4pjU1rASuTFhRpSpu5PeP4A0JCu1YC7/i2l94P18NwKf?=
 =?us-ascii?Q?ii+MXjvesFpx8//hl8pySGYa6VdgIfbDEfYB+dOgmtgxJRiCTCbwXBtQdMTY?=
 =?us-ascii?Q?VWZZrtpqOusByXkKZSmmTlWlcEWJYxr4X6KILuNhQdkmACP+81D/aXwvPT0a?=
 =?us-ascii?Q?uYHF+PtaVSYobU78wZ9/2/LXwWmFPXtrisTYv9j0vmp/aucHee82ZJHoD1Mb?=
 =?us-ascii?Q?Rdj8lcaR6G2XG4uOVr6YWam2KUdEMY3wJIRzp4P9r/gVega8d9UK37XUHrIM?=
 =?us-ascii?Q?s+dcGq2iN7TCpkElteAnPcaBTsMrEDLjkS+SnGSe+15CYdTnfbfC4e/FwQAH?=
 =?us-ascii?Q?cuISwJDRMAwMDQE4Pywcr88h?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3382ae1-9e7e-4924-5dc1-08d94548d41b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:14.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdACpMhwIrkmqWiDROYONBDFBZih0m5D+yLrWweg3g1bt/UzLX8Ez7dc/sT0U4jFLDNRepGOiSPckltrxUQ9hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of adding more code to the NETDEV_PRECHANGEUPPER handler,
move the existing sanity checks into a dedicated function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/marvell/prestera/prestera_main.c | 71 ++++++++++++-------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 979214ce1952..508c03cc8edb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -707,6 +707,45 @@ static bool prestera_lag_master_check(struct net_device *lag_dev,
 	return true;
 }
 
+static int prestera_prechangeupper_sanity_checks(struct net_device *dev,
+						 struct net_device *upper,
+						 struct netdev_notifier_changeupper_info *info,
+						 struct netlink_ext_ack *extack)
+{
+	if (!netif_is_bridge_master(upper) &&
+	    !netif_is_lag_master(upper)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+		return -EINVAL;
+	}
+
+	if (!info->linking)
+		return 0;
+
+	if (netdev_has_any_upper_dev(upper)) {
+		NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
+		return -EINVAL;
+	}
+
+	if (netif_is_lag_master(upper) &&
+	    !prestera_lag_master_check(upper, info->upper_info, extack))
+		return -EOPNOTSUPP;
+
+	if (netif_is_lag_master(upper) && vlan_uses_dev(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Master device is a LAG master and port has a VLAN");
+		return -EINVAL;
+	}
+
+	if (netif_is_lag_port(dev) && is_vlan_dev(upper) &&
+	    !netif_is_lag_master(vlan_dev_real_dev(upper))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can not put a VLAN on a LAG port");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int prestera_netdev_port_event(struct net_device *lower,
 				      struct net_device *dev,
 				      unsigned long event, void *ptr)
@@ -715,40 +754,18 @@ static int prestera_netdev_port_event(struct net_device *lower,
 	struct prestera_port *port = netdev_priv(dev);
 	struct netlink_ext_ack *extack;
 	struct net_device *upper;
+	int err;
 
 	extack = netdev_notifier_info_to_extack(&info->info);
 	upper = info->upper_dev;
 
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
-		if (!netif_is_bridge_master(upper) &&
-		    !netif_is_lag_master(upper)) {
-			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
-			return -EINVAL;
-		}
-
-		if (!info->linking)
-			break;
-
-		if (netdev_has_any_upper_dev(upper)) {
-			NL_SET_ERR_MSG_MOD(extack, "Upper device is already enslaved");
-			return -EINVAL;
-		}
+		err = prestera_prechangeupper_sanity_checks(dev, upper, info,
+							    extack);
+		if (err)
+			return err;
 
-		if (netif_is_lag_master(upper) &&
-		    !prestera_lag_master_check(upper, info->upper_info, extack))
-			return -EOPNOTSUPP;
-		if (netif_is_lag_master(upper) && vlan_uses_dev(dev)) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Master device is a LAG master and port has a VLAN");
-			return -EINVAL;
-		}
-		if (netif_is_lag_port(dev) && is_vlan_dev(upper) &&
-		    !netif_is_lag_master(vlan_dev_real_dev(upper))) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Can not put a VLAN on a LAG port");
-			return -EINVAL;
-		}
 		break;
 
 	case NETDEV_CHANGEUPPER:
-- 
2.25.1

