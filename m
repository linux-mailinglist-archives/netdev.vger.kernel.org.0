Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE8A4C14F6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241335AbiBWOBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236610AbiBWOBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:01:40 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140050.outbound.protection.outlook.com [40.107.14.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D00B0D31
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0A39RTpBzN8gn6F6/WDodMXeSPwEMJDhuGnFgEbH57S4TIqRej3WEVw1MWHBA/KNRrRvIZ6KGVDOzJsytpt/3NDyL3LtDdLPUVEJJBTOt1mDluvQiLVUG+No3sQd+VodzkJrtWS+dAi6PeyQ9vbrUIjdcQAoWmiPVAtezItlqWUrWfvfeC5GuEsoRYV6Di69vKpuCk+4AqnVLWbxDu7S8AV/QDcNQgzyzanb7gAfjGqejQVaJPO6nkKTQsm8gHZ4XjPG8zAMcRo7V8OP8df2trKYogijd4PxsRdPaFD4h/jeXvwFIImNcm1lHNUcAuMOjQOtBb8iH68pwG2PtSFPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z80iS/Ga3/kM722L1JqhodaeO5MIT9Cq5nbqUTsaknI=;
 b=YGVaf8WIzUb6r5tUTnFuBlP+9ja1ljyvNDMxdMXcqvfqniS25ExBgBC/jhwJqVqyDFh/JB2/TTYOzs9VUN7Ums7jiwnvcoW4MavKWfbSOgh3QEaODFCx/bbOF6bcUE+6XaEY0mZmMYthLN8GPiqL7I6a5M9/9mMbO26qD8h28iXBcs3DXyPNBVVjKwHfOpT1V/se0JnSoXx81GCoeKgGdEeww/MY5yUSXTidS2aUxip4WXa9iRo2k2DMqr8wmd3pI0E46OgIP8TzRwsDoUlOozCYSsYz23lXPiN2qIqkL7OFs7pTwp3d00rUF5rrYrkAdM5oYgWNh31YsxuCQJKgLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z80iS/Ga3/kM722L1JqhodaeO5MIT9Cq5nbqUTsaknI=;
 b=GQyIds/hljtObdeNL+ZbcMSPc62X9DqIR72wOkuRL9NcZ606IYr4i5swv0C7hz6psvFFGrJgNpPswLVOWwc4neKzseT+tEW9UKyp8rDYe8bdpe91EMzbGGAO05atPwbNNlSrKuQ8fibABiwp5uhcOvpCUx6UJ/ca+UeGQoKytXI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8701.eurprd04.prod.outlook.com (2603:10a6:102:21c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 03/11] net: dsa: qca8k: rename references to "lag" as "lag_dev"
Date:   Wed, 23 Feb 2022 16:00:46 +0200
Message-Id: <20220223140054.3379617-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96e63a9e-2404-4f9d-2114-08d9f6d4f0d8
X-MS-TrafficTypeDiagnostic: PAXPR04MB8701:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8701CC7DB87054CEADB7A440E03C9@PAXPR04MB8701.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sVOcOlswJ2nXduPnlPEh7YwltWcZoAMphpvc0ZhhL0PehcPdjEFulRIfrDBNACrd+KJHmMt0canLXA5vbtHEJPCHm5EqG4xFMVBZBV3x8knkN39vKFFbJ1Qk3KYw5zktE27xWLcuwWj2R8S1eEsZ6DTh9xNY7NKILNWxDVDu5D/6FhPqOW/4NxTJ1A1iRLrjCpr5UnvAzWXXwhkDUAallVcOXKpbO+wjxmzTxlpb5zNvmYjJxNTGmIbBsyj3zj/LLj9Z4mtB/rqpPJGGisH02lRpv2gMpRI/Xmy8LfS/umy2ym3oniXF/7nOFSKmHZZVEMXTCAtoYWN9vaKLI0lxVWWkv3FL6C5ZaiRRf8+7RGdJdBifhraeWr5fgjxIJgH8u1awN/hGI6H8uZ3mqWlfnOly/4c2xLUCwJbgO2qX71NUJpIPlo/dfxoTIHmZqsQeZSqwdhYacS78h4c6WwQ0JCTxnUs0KF0iLfFvXIiGOuNj+wnxHJd2x9QQWZDZIe5ATvwxjOSIzSwYkZu8AaRNxGqgjB3XlVtaXCerfK7Y0X9kfFefVX/lKG6vIon30UcxcBHy311dxTXZTVd4w5DHtbk/z0XN9d4I7p32XG72anzqQsz3UoTQXXZeehec4SKHi+doq0mQ1YK/vgU23PkaNqAW+5bjSsmHJIF256ToU9ZONzGvgyh4HcKF2XyenFgjEnTZUuKQKcoMRapsfEqEO7DH/kMSuuKBilDhOhN1vUg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(83380400001)(38100700002)(38350700002)(6506007)(508600001)(52116002)(6512007)(6666004)(66946007)(6486002)(2616005)(4326008)(7416002)(44832011)(54906003)(66476007)(1076003)(6916009)(2906002)(316002)(66556008)(8676002)(26005)(5660300002)(86362001)(186003)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0CuU2F/3R5HjPh9nczbupyQvVjOF7FSZG/jmQJLqrh8au8cOdOmFgB802pb2?=
 =?us-ascii?Q?E2D6zPc11fHGVo0upqqS8vhVvjqUSKvS759z9EJe36HF9pKAH5Maapjv7u45?=
 =?us-ascii?Q?3GLvo53FS58KvQo+o3qw1rx7y8Cp8wmsStrNHzTJgv0L4vG20VXk8mweYJSt?=
 =?us-ascii?Q?p0x4t8jg95Q4NgzvwhMcNzsI1K2UY3+TEFMs+aY3rhm/Lo7KPzTvSvcFV6QL?=
 =?us-ascii?Q?zL4N2NwN6AkqdLZrmpcMFFhTUNNf7yrDHh8LGSH/jvw16yufkFAYEc7muRf3?=
 =?us-ascii?Q?TkcCd1Wthlh2FXSxekWmm0QwMg1VmZrr8lgxbX1p8He6Ri5sHZM7cszMm7+S?=
 =?us-ascii?Q?D5Uw/GFXO9VOX7N3F90D7QfeaopmONtIB4Gk6nwA2Hyu1MYwsSih2g2Jv7xx?=
 =?us-ascii?Q?Lbnk2sycMxYVuaMAqu4ed4vH2U/vxr8ijQ1+1/eDONMM/V25fqd3hS2CSubK?=
 =?us-ascii?Q?uFfXRlTGJMLVt9ffrc/CFKh7Z4lm2vtdxbcGP8pVUjMKnDAqoaaa0s0hdn3b?=
 =?us-ascii?Q?Km3hFjAQa/Do00NSl5YduNh42kU/8fodLROApLoie5EKeouvZVG9u8BXfboF?=
 =?us-ascii?Q?9LibitbcgCxmTxgeSn+RgljKSOa62dlkhikncf860lOvrSdpYNR/qchpskvJ?=
 =?us-ascii?Q?6oMYiisdA46UQZJ3qk4RAJt5g3WsMB+pSODsn60OHVhXbuFh47VgrLEF+lKR?=
 =?us-ascii?Q?s+wzatDuNXzWLBdIpg5UUw/ijvUhbSTqNjwmDK2jz2F5bVUistjPqdLgGFkb?=
 =?us-ascii?Q?k/Tpb9chV/PFzWUYjGVf5qKAQO2Rfk4LwgvFjv5bUXypPhumtsHHKsRRW1r2?=
 =?us-ascii?Q?snqQ4cnFRGGZPugGeJKd+qJ8dO/a8KbLsCpfiXN3KMKBAuFcWi5llMzdTm7z?=
 =?us-ascii?Q?MNPhfy/UxborAEhQaIkjil5eqYKpLLA0cEXUv+xxquu/r07ybobmJ1qoWPa5?=
 =?us-ascii?Q?dxBsBwkesB0ITPhH4gNLTP9NRKiUKq6paI43x01qN3f7qbzTRlsIy5qstq5J?=
 =?us-ascii?Q?ZkxIzGC4MydDFwLzYN0HXHyhDv+tR4soTaPKiDZF4Xlu0vORn+u7o3QFEUWm?=
 =?us-ascii?Q?dXFk9TwXIZnDAgivhbKqIpnJmjvbZvyP9JeRaen9ea7MEL90cBttT3jd8Pzu?=
 =?us-ascii?Q?96v/BbC3gnfEq1CJLfqPp5fnq0uU8RGVH5unnlfbGV0PDxowvK+c1LKyXOeA?=
 =?us-ascii?Q?30urp88FBSBer0uRLqhYtShzOAKOKLmBpweDwgaTT6cYAmK07ndg6gGWyBDX?=
 =?us-ascii?Q?2gBbJ3MJ1tHlioS97f6XSXqJ4PVGBrhJOqK+qN0UbvPvyLkxLilp1kvZ1RT/?=
 =?us-ascii?Q?eCU2z+IZ7UH5ytampRDubAoJebzuUnc2yQLGJ+gOGX6dHfL2f4nTu5ZYnJ6e?=
 =?us-ascii?Q?OTSPk8BcyMd4J7vpYsf3yGmNY+NuTRiccJ5SqUPn2gXcAz4UVPnuYIyvml7D?=
 =?us-ascii?Q?ImqQb3MCEcynvccnun/NPjochsZkwfgWM7zdfY9kZ9+jpZ4iDrMS0VjgLBXS?=
 =?us-ascii?Q?9LD/yKETOmR/TrqGZ/hhShptER6ty96+cdrWegqZLcgplHYGHNizozZ9x6RV?=
 =?us-ascii?Q?RQTJ923vmwTSqAH6+DFyTzF6hk3EEyxVSRVMCD/ojHvvOktNwDOtc6jc++l4?=
 =?us-ascii?Q?suyeGBDRia8oLQRHVggC4fs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e63a9e-2404-4f9d-2114-08d9f6d4f0d8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:08.5081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Dw8Ck8nKTZ6VzWX63gSilngG1TRm9NZuPjHa/bQrTT2DJKX9ccrkd6ezQIEa/nApXK+jEb+PgjgkNUlTvWk/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8701
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in qca8k to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v5: none

 drivers/net/dsa/qca8k.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 04fa21e37dfa..5691d193aa71 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2647,17 +2647,17 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 
 static bool
 qca8k_lag_can_offload(struct dsa_switch *ds,
-		      struct net_device *lag,
+		      struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *info)
 {
 	struct dsa_port *dp;
 	int id, members = 0;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 	if (id < 0 || id >= ds->num_lag_ids)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -2676,7 +2676,7 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 
 static int
 qca8k_lag_setup_hash(struct dsa_switch *ds,
-		     struct net_device *lag,
+		     struct net_device *lag_dev,
 		     struct netdev_lag_upper_info *info)
 {
 	struct qca8k_priv *priv = ds->priv;
@@ -2684,7 +2684,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	u32 hash = 0;
 	int i, id;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	switch (info->hash_type) {
 	case NETDEV_LAG_HASH_L23:
@@ -2716,7 +2716,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 	if (unique_lag) {
 		priv->lag_hash_mode = hash;
 	} else if (priv->lag_hash_mode != hash) {
-		netdev_err(lag, "Error: Mismatched Hash Mode across different lag is not supported\n");
+		netdev_err(lag_dev, "Error: Mismatched Hash Mode across different lag is not supported\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -2726,13 +2726,13 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
 static int
 qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
-			  struct net_device *lag, bool delete)
+			  struct net_device *lag_dev, bool delete)
 {
 	struct qca8k_priv *priv = ds->priv;
 	int ret, id, i;
 	u32 val;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	/* Read current port member */
 	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
@@ -2795,26 +2795,26 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 
 static int
 qca8k_port_lag_join(struct dsa_switch *ds, int port,
-		    struct net_device *lag,
+		    struct net_device *lag_dev,
 		    struct netdev_lag_upper_info *info)
 {
 	int ret;
 
-	if (!qca8k_lag_can_offload(ds, lag, info))
+	if (!qca8k_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
-	ret = qca8k_lag_setup_hash(ds, lag, info);
+	ret = qca8k_lag_setup_hash(ds, lag_dev, info);
 	if (ret)
 		return ret;
 
-	return qca8k_lag_refresh_portmap(ds, port, lag, false);
+	return qca8k_lag_refresh_portmap(ds, port, lag_dev, false);
 }
 
 static int
 qca8k_port_lag_leave(struct dsa_switch *ds, int port,
-		     struct net_device *lag)
+		     struct net_device *lag_dev)
 {
-	return qca8k_lag_refresh_portmap(ds, port, lag, true);
+	return qca8k_lag_refresh_portmap(ds, port, lag_dev, true);
 }
 
 static void
-- 
2.25.1

