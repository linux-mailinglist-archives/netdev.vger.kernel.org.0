Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315DD69CAC8
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjBTMYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjBTMYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:24:04 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D0C1BAFE;
        Mon, 20 Feb 2023 04:24:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mb58l6aotNSo5T4IgV3rwi/XYELoAm8C6w5eGH8OtN6uCWHWeRQyWQqVwgqF5lUDrs3l+S5LkZrTouDnn6XnbhJQZ1YC24+uYxS6JQrmDkATuICkN9y2+6aCGwmyTNeyL4QVCiYr1VmSfU+KThki3kVOcenMksoFyrv4r8CpFPXc9zIUESSvWV0hwUrlq1NnD49e/vxCRWDf8bwp4P7FH1mwZ89wh6nf6JhCGbq5epX/NpS9f+XdAliSJYOQzLwTZ/K9gaI0/bxDmq5qwMFZ0EhcEa+VuC+ZV3O6ZagPah05Slx5gvyL4WuO3FchaPs1sc2jCAJPD91cd6rcAzXTKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLHC8lf6x9GUPNeM2T6eLRz5ylPxg4Z4zvhGOMXOzvg=;
 b=DwftXMhzWvdh2N9xyJ3sMdgEE1npXLXgdo+67GcMjW7ekL5NB0wlgOzeO8iNbXwtu8PloPp7yeqBuqZnqyQ1WPc9FNLRxmlzgGNEojArkKYAgXtw3a7/ADoULb3xM3X1XzJ7VJyqAoj/ayKqrT1e0BOtqqo/Aw24MZa8Py3HtKr22I/KiX3l/E6wA7/jEYKy5We6T5SlDfSIQrLm57CKn+TWW+DH6/cgUIA79Z0Zn1FYmxF6rPShNfEw7XS4HqcYTAXUdjlgCbw8Fu4rhC+Av5qPLb3pFxA0zZItFc8B9CckHIlWBHj4lOvWL+yWXn1RfcQZKZg3D8qm5x7cvjbJTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLHC8lf6x9GUPNeM2T6eLRz5ylPxg4Z4zvhGOMXOzvg=;
 b=rWvu+e/R+ZchjxG8VeTF086k3d6PXvySMSnpOPMmetSIy1kcTkyoNMa6Wz6hUPbejSWw0u8nHVIARC4OCBeUW3DuXk8AcUaXKoJ2GRONLOBkzl6LbFXp5Hv/lDOOYL9zc7R4mq2tBKixXwSsmdvvIX11ewaeoaytI/O/schPmFE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:00 +0000
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
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 02/13] net: ethtool: create and export ethtool_dev_mm_supported()
Date:   Mon, 20 Feb 2023 14:23:32 +0200
Message-Id: <20230220122343.1156614-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 30e014fd-7528-4ac0-6ac0-08db133d58a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zkrJwLevwulBkYHyRB3tapuEin1YK7Jy3a/ky4Juh69VOqE+EfRF4RIxX/38UlYfXnAONDG85YBKZTNGwpLHoLq6xVLr/780e41uuTJEluOP7HhH5J1YZKdIC3oNBpIaWHrqDg/aQW/koKN9GS8fFcojwKcsvG9nUXR/bRlksTGY8/2S92XZ4VpBDIXYYGgq5hdIRdcq80EedPS966BIglMVtYyxdc+h8ROuMjuk2w+BT/rXajSeX+LphKec/KdLFToakNzcGnJFonA/4YQ67FI4eXyhmbRBqkY26XABmD26G4dOwhK+36SNPwAdr+rPiCVrHLc11PJaED+lpnFibeVvleXhPZJ2N9gxiK8c/YC22a6YtoWmftk1hrkpMPd0b4LxrD1n5rIIsaDojPh4/Pr8rmkRAgZ/0cH2Bl8daD3AVsylzvgVIC9p8qv5b6aiMYVil+F+CLNlmAq+4agbox0R0XSm/wwAvsPE7f0mUgjPI09ng+ncKQ1NIUT7HeKlqPjKUt+RKrIL8KJtLuk0JeYXBQMW+hmK7ak4TjqLmqAym2PKPoR1o66NzNUu3hQMwNahoHODiODmXZJi1tm/hYY7YrBm+xnDEVmvbSI6WbxIqE76NwOC10ZV46FHqfurSE3KLFULHBk/lzEm9by++rprvA+HgaGLM6/MIx4fgMW87sTBpTOUuZ37xUtw8zNxUms3TrXQMGGCT3j5rBtrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6qqPHthMlxQIaKfNZmPP8wZdOyG4OrrVrCsMDA0QDk6iSM4LvDDePIUrEO7A?=
 =?us-ascii?Q?h8tPlb7iUIPnqDrEjOu2vmlurmJbFFG04qwiCY2kklXSSgk32QfnAmqKBSVr?=
 =?us-ascii?Q?JA7J5sXjIeQwTFNxuKKpoN9bGXLvW0Tq4iMwIaDljcX8/4/LBJXsLV6GzY44?=
 =?us-ascii?Q?YuDiWWUX6FJxBQtiRhfB9SSc3V8MZexB7IhEl76vOwtP4GZxqYRCBLu6/a0Z?=
 =?us-ascii?Q?aed+pEqWF4SaWw1TSwW2zXS6L0RccOY3G4iybcYMtgimSMzpIRSOpt7K+/89?=
 =?us-ascii?Q?9V0oGiIQre2Jd+046OOq+ySIz8OMwabZlksUR2yMeJCEJvYb04DFpY2FCq+v?=
 =?us-ascii?Q?SN6w4HE9VO1lC9g71xgkvbFoqFlqbgtADElsd7xtlL6LVMFVYM8tdWupZJsw?=
 =?us-ascii?Q?ZJQb7bquIGA8rCqG5/GN0WWv5MddLnHe3bZ6xA4Hlpm9g3uIJLQdJnEIv7+V?=
 =?us-ascii?Q?H9+LLSbeQmaqDFGeF6vM67G/merHbljn5Wun6TzE8s7uaOhF09UVSSQ4lc9t?=
 =?us-ascii?Q?WIQHe0Kc9sHJUPniNLpDBQrtD/CBwc4HGpl3Duef46DgVsV3nPwhsxN/h/NN?=
 =?us-ascii?Q?Fswv+eA4DRkVgSG7/kY7WZ3I5Wtwxggl9taTs6zM6w1KcfJ6wAn3Gn4n/Acv?=
 =?us-ascii?Q?jv31N+lyc2XfAQo+XK+3u+Ma7aI5VaUjQgk4zllb4GQioZ3e0ZYqJ+epUg43?=
 =?us-ascii?Q?24tn0oIWIpWKy1jBRfhLmwGJY7vuXKXC7Zex655MKQ1+i0wZ85cyZCuNcePo?=
 =?us-ascii?Q?ZgjJNsEny68zJOfDtVmjTptq2F5CUndjsj6xo/MXqNF0GGwnayWN5CgsLU+t?=
 =?us-ascii?Q?MKOvxrP8KAv8wbL3fp+2wCHWlWhunx2TRHaY9eFF+rAk+dGuYh1+Hp4eTN5a?=
 =?us-ascii?Q?UqZwYzjF3Rc95o+qPFZQwwdJYVLCjE1PWfamC/bzPnIDyVYLQqJBE1zHS7Os?=
 =?us-ascii?Q?gFmTdv5SSc4ymNh+KwgfFa39imrehJcY0CzBeLezu0ziAEjEXsngtHFY1Lrq?=
 =?us-ascii?Q?bC3FS72L+7zxeEB9EMw3KBprIiHCENkA/pWm+64oN/vZ2ltMQSO0LTH4xEON?=
 =?us-ascii?Q?KmZvGjkQHvzkqpBXQC+JU8QvHrXak0hktruuS+SSb13t0Knn/vdPSFmJ0VPU?=
 =?us-ascii?Q?R3dVSyohnywv5q/Lo6M3xTZWO9diAF0zg41/xM+1dna2abC7JOpeWVQnRiLa?=
 =?us-ascii?Q?i/Y1GTbz42xianICj2TbkqSfq/VzctGgoRhkUKulIRY2mQ8LQlXAH6Da381z?=
 =?us-ascii?Q?34bNFdasukkxqmKx4E8TD6wLzPZsfEIiz/1fuqZR971PJzN/oGoG8nSD4wDh?=
 =?us-ascii?Q?zPQ+Ua+Uptqx9bNAUDGsW33Z3G3fkdnaCodG88yKlRNcVbxu1/kVSDNJmNFg?=
 =?us-ascii?Q?i15MjarRny33VM/1eV21tVFIxGIkPg2AZ+/ER3wpsaHM5maKm7g74ZwDc+86?=
 =?us-ascii?Q?dTqegE+gmqiFVee1uQgy4DI9Fs2xteJJK2rYcDrVEbK4neU1iJkF6cC2jRW5?=
 =?us-ascii?Q?zCnGtGgXjI7ZaJkpmxd5v1a/+ZQEfY0mJwJ/ID2aaGRNdO9i82T9BMA0q6Mu?=
 =?us-ascii?Q?nUzca4vPbs1D/3JZCtdkZ89IrsETcvCJyRNtj9C7DmQAVwstyPl+ANqyZ61z?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e014fd-7528-4ac0-6ac0-08db133d58a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:00.7441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XeiYf6nO3aU10/ehX+UpewjiObwScvPPei1m/C63lRtyJGnH+EHmP87x9mNqypW2QGox8YE1q9o74GQE9F9xKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
---
v2->v3: none
v1->v2:
- don't touch net/sched/sch_mqprio.c in this patch
- add missing EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported)

 include/linux/ethtool_netlink.h |  6 ++++++
 net/ethtool/mm.c                | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

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
index fce3cc2734f9..e00d7d5cea7e 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -249,3 +249,26 @@ bool __ethtool_dev_mm_supported(struct net_device *dev)
 
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
+EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported);
-- 
2.34.1

