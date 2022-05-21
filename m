Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2648C52FFA2
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 23:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346622AbiEUViW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 17:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346690AbiEUViG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 17:38:06 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A78B53A60
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 14:38:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY99gHEw2vK89SytSOr4DXwFSlxiphnHZMxXNg0cSavxpU8upit0iSCi5bSpzBsg7Bf76mhTNWuI12r/LdcY23cAUqNE2BqSjrqg3Bsh3NLqCo0wCPxvrk3eNOoK9i7H2h2Xj5FnpktpiuUL0XEGZ86OQAWl99Ampq0l5akb94gI9UmgkgqUCqh2Ayy/Sz2Ys9K8PlmlH5bSHzqiUL5dmbTKfy5020pjb0MhQLKlkl1S8i3tWnr2S2ahFOXCg7YyA+XmXIs5C/LC932CKYb6ZnHwfiZ1hoA3Fj8qZlUwgMggighk+iUlCx3n2GdiN2O/T1dVheWVdXHB0zpJ2zp8pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWgeboLPkapGpcLVsPzMwhQYK6IS32scSxDdA/xGeFk=;
 b=FkSrdSA5b5d98yWlHrmyk7pVYfrefTVvwflJ72AoW1Y7n+K/W/Ycf/d7y9WuiFcWcx3JCkkNE+LDe2kq5RrHCsXkeokUrmYY7Kb+iLLOR73lqWSAWBr2GBEmmFkS4J/uq9MoG5e2TALe3IFhb5u/AGzZfpvtgldBGKqjy2YJgZtjwvcsPFg06f77hdXV7dNo3bGP1ssZD/qpx3+9mheoZi5mKb1kyVMZ3YgsfVfnxNkGH8/l7P0gOJPeYMpiOatbYVmXmvm9chvYrqL/ELTvZGlcB41mqSFUCfDuDKv0JFjRuoAFuFXFTvFQ2Dujbra4rxa//vD0bBjV0XPzg5EHNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWgeboLPkapGpcLVsPzMwhQYK6IS32scSxDdA/xGeFk=;
 b=ZIK9hFhUErtv0XudJn2ap2EfFsvrQYwSi3T0l/zqvNtcHudRyT3kGDqr2sxt3usUKmtK8weQUd8/iq9RKZUPECECprUEvC6yASB1wyiqvWnPPZzgxJvBP2+h3cIoBUacbpX2WCiCXzFOLuj0oGzMWRLG+OCOkR29+yTdLq1BhRw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6275.eurprd04.prod.outlook.com (2603:10a6:208:147::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 21:38:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 21 May 2022
 21:38:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 4/6] net: dsa: felix: directly call ocelot_port_{set,unset}_dsa_8021q_cpu
Date:   Sun, 22 May 2022 00:37:41 +0300
Message-Id: <20220521213743.2735445-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
References: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0079.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62708912-01f5-43f1-6393-08da3b722f51
X-MS-TrafficTypeDiagnostic: AM0PR04MB6275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB62758E939E08E2A1D599282AE0D29@AM0PR04MB6275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uzu5ir5IHO5+dIVeVVysef5mvhXaL4YZKJpqjRmX/kbUiq+dVWqVG6lnBp/TX1s/Rv1wo+Tua5GBBESfZPUmmnf6WWSSUE05r/KNr8n1sqmgO5A8YAoeW2sxzWZ/NzXmPfO/Rsmk/uLsfLasVhOezK8oKgdyzpD60wn3NDQ0k3OSNVeG+UpvjuTsVi/45c+xIta61LlCXQtTaehmL4FJzNlAkuETbh0qT1GkQYculuP6IStw1FTndqsBRkORtkr5n6xtxj+Tuype4ZJ/EUagvxR9h8aSXfzdmH/L8YHgoJB1/SZnT5Oq5ys9yWMSBjQW8FZwDEYOrPKFBi3Bqn9FatlocQmAlZojns1DIqLNIZrjAnR9Rr6W7XCfuuXD4hiv2ZTw29JQ7MD4EZ4fgsTAUU9TLcuml6/BO8+OrGl4XWwArQmWn9DFhPOxTZuVxOOkAnIGhmeZMUbiTVb8AEBeO2xTy27WpYnHSj4GbdeXvQjEywG/TjJSfhj42T/T39DboZvzRwwVraPntNm+NAzv6Fd3iKqb4MUMc4HHw1yT9blZ96zabU44QXLuLPHeeYVG9S+D65hdGC1Njjb2RfOVQYjc7TltpZ4eHY7akfwyYoZZYWL8zdqzBg0j5cy3QdEOmnJGzMJZtjaVTYR7DwCxK7WCb+q2kdD3z8mlI0lIdCDb8G5/0pXBO34U9j/zWyV98OG2ehCkIOjA/MZRIZgEdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(86362001)(26005)(6512007)(6506007)(52116002)(36756003)(2906002)(6486002)(8676002)(66946007)(4326008)(66476007)(66556008)(54906003)(44832011)(83380400001)(7416002)(2616005)(186003)(508600001)(38350700002)(8936002)(38100700002)(5660300002)(316002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g/0UfxqYSYLK4S5PiK++cVwqPOwWmxgAW7yGLeL5oqOiM6bMP9Bb6iznkkXO?=
 =?us-ascii?Q?1vuWgRHJO7g3VDBDlOZcKRfb1hN8DdEaBhLojr/WRn7gieblYcfJoawwWEEm?=
 =?us-ascii?Q?bkFTBfmjfNK9lNKpzWkjPWhx/XnxpdlubimdGv1qHDHrgxK1z7s9MaPwrK5L?=
 =?us-ascii?Q?Nlh+HeQtd7DjJfV0mTJ7pPz2az0vLSUnUhwEytOkYdlnsOSyBxt+Xsfx1IzX?=
 =?us-ascii?Q?IYw9Tz3GFBEr/yvQl9Y4uGhjls5nLyPetbhK0iVmSsLo5ExrP99QCNqvCR64?=
 =?us-ascii?Q?IU+D007cXq6DIQ/wYbbq269cGzPCTNjU+hia7pTk4c7q6MMRRAty4ndWn18h?=
 =?us-ascii?Q?uU+63ILOt+OurofZMXDb7JCdyTY/8BP3j9efW2GhmmyWNBp0o/gLasGnlbxT?=
 =?us-ascii?Q?NGEV9AF4Ab8HX8sAv/qWLybLo2obxLok0QRLcpyyA1raOh0flwxRyy+bVuvN?=
 =?us-ascii?Q?oUSKjSKFOf29sW+7mwsZ/h7RaqTI6j+XwcO0yEpNmf2dtUYjdwQ6hWHgvS/q?=
 =?us-ascii?Q?8BVHqbymMz0bMofk+ImtmTuIWmXU2KBnWmD7qjlfYk6gP6sCe0OztfGlNTF8?=
 =?us-ascii?Q?D98CUGHh+iRyIsYpyv4AYEyaEIwNvzCSbt/jFBnOUGqVz0JVJzAe2LwXiFlA?=
 =?us-ascii?Q?bSAPhnxhBFW8mN9agFYHVxEktFFdC1dFigI2dp6vI+ZZGwSVwA9JpuH2WOVv?=
 =?us-ascii?Q?mkTQESGWzqfKShn20cVOHqrq28+8Mwd/CQk1kJKTdi5FlBPyxY9lEE/gWj/7?=
 =?us-ascii?Q?PnzDQUIkYn9Ij7oO0L3OuKzwTvvG3XlVSQaD00rSHSs2Qcus0fdQgH8gMvrC?=
 =?us-ascii?Q?ND7LhFv+XCSm3Fv8iwuh9I2AJXm8FjOS8pa/AwWBtpvkKGGjfYK0Ag6T22dX?=
 =?us-ascii?Q?E6KHzoI1lYfYx7vBDJleqMiSYFmmeClESctf1vG5ITfiIpRv7Wal3wOtSGU0?=
 =?us-ascii?Q?mwlYJ7GIhdp6UTLw8SHEitYnbhXEUxJW0mEvjzloYKG/jDphapkgtbwARWYy?=
 =?us-ascii?Q?WQG/7DJsnfRZV0BFD+O6QY+NwwEwt6dxW0JekA7odUVmBkKB7qRdF/5/J03c?=
 =?us-ascii?Q?hCqy025Otv8NmsNRJee8WvtM8K5iuKwh0tLbeoceCtj24/+FidDvOoqpDFOr?=
 =?us-ascii?Q?BCTubFl4dHNNQpkqm6I23OKoYdDkNaNKVKaNYLPZnr2l07z5wKTw+zzcshVb?=
 =?us-ascii?Q?y34io3xgAHZdsLg+0Idq9dUYEbhc6H1lVHWDRnnuxGfBsEEeBxpV/K5goUgH?=
 =?us-ascii?Q?W2Gc9+JhPKAYX7r1yLD0KCcADNSJi+lOH22cc1+AtNDZrcgUgqO5A7ddCohI?=
 =?us-ascii?Q?c5h+sLmHenuM6+fpLrTMX4M/sP0582hdVASl+Ai09ulgODp01eOVz4reP5cy?=
 =?us-ascii?Q?IDD2yydCTzwbYD6Xv0oBXWSO3kdaP17s73VNf9XuDDe4ETWJuaoinNMsArcu?=
 =?us-ascii?Q?xyQKPWZAS0edsO8QOL69wTjfCeZAhq1cvFkz2dF5cbROFs0wEiVEbeLciHYI?=
 =?us-ascii?Q?s8rv14UiRH8neNGhNC33rU+fG+3HBPQ368nogvijPaGfadirHNlOPufBWllr?=
 =?us-ascii?Q?PCbNRCqGT/ijllZkgnB4SO3QTUgBkmQXzuedYUeSFZWx/zMxm23lo1qfB3OH?=
 =?us-ascii?Q?Bu2/geYPhMpaRrZhMubDdLcEiVrwvcvG7uCt4f7O3d8zKGK2RjvP0GGcz9CX?=
 =?us-ascii?Q?qvcfGVhaQk1kqPumPzwQfugmQAWOlZcABlLhgZsjfJjPsZiL//bpKmGbL9n4?=
 =?us-ascii?Q?/Emm9A4ehiFkMjqBFJNaIuizDqIWAvc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62708912-01f5-43f1-6393-08da3b722f51
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 21:38:03.4394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GxotQ2INWopBFw89EJz9VbPranL5gGkBI5gesALOAPccqMjo5A1GYkWvcBnHseRSsTgMQ/uzIb/jYUapG82k4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Absorb the final details of calling ocelot_port_{,un}set_dsa_8021q_cpu(),
i.e. the need to lock &ocelot->fwd_domain_lock, into the callee, to
simplify the caller and permit easier code reuse later.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 36 ++++++++----------------------
 drivers/net/ethernet/mscc/ocelot.c |  8 +++++++
 2 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b60d6e7295e1..033f7d5cc03d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -240,31 +240,6 @@ static int felix_tag_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
 	return 0;
 }
 
-/* Alternatively to using the NPI functionality, that same hardware MAC
- * connected internally to the enetc or fman DSA master can be configured to
- * use the software-defined tag_8021q frame format. As far as the hardware is
- * concerned, it thinks it is a "dumb switch" - the queues of the CPU port
- * module are now disconnected from it, but can still be accessed through
- * register-based MMIO.
- */
-static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
-{
-	mutex_lock(&ocelot->fwd_domain_lock);
-
-	ocelot_port_set_dsa_8021q_cpu(ocelot, port);
-
-	mutex_unlock(&ocelot->fwd_domain_lock);
-}
-
-static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
-{
-	mutex_lock(&ocelot->fwd_domain_lock);
-
-	ocelot_port_unset_dsa_8021q_cpu(ocelot, port);
-
-	mutex_unlock(&ocelot->fwd_domain_lock);
-}
-
 static int felix_trap_get_cpu_port(struct dsa_switch *ds,
 				   const struct ocelot_vcap_filter *trap)
 {
@@ -423,6 +398,13 @@ static unsigned long felix_tag_npi_get_host_fwd_mask(struct dsa_switch *ds)
 	return BIT(ocelot->num_phys_ports);
 }
 
+/* Alternatively to using the NPI functionality, that same hardware MAC
+ * connected internally to the enetc or fman DSA master can be configured to
+ * use the software-defined tag_8021q frame format. As far as the hardware is
+ * concerned, it thinks it is a "dumb switch" - the queues of the CPU port
+ * module are now disconnected from it, but can still be accessed through
+ * register-based MMIO.
+ */
 static const struct felix_tag_proto_ops felix_tag_npi_proto_ops = {
 	.setup			= felix_tag_npi_setup,
 	.teardown		= felix_tag_npi_teardown,
@@ -440,7 +422,7 @@ static int felix_tag_8021q_setup(struct dsa_switch *ds)
 		return err;
 
 	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		felix_8021q_cpu_port_init(ocelot, cpu_dp->index);
+		ocelot_port_set_dsa_8021q_cpu(ocelot, cpu_dp->index);
 
 		/* TODO we could support multiple CPU ports in tag_8021q mode */
 		break;
@@ -490,7 +472,7 @@ static void felix_tag_8021q_teardown(struct dsa_switch *ds)
 	}
 
 	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		felix_8021q_cpu_port_deinit(ocelot, cpu_dp->index);
+		ocelot_port_unset_dsa_8021q_cpu(ocelot, cpu_dp->index);
 
 		/* TODO we could support multiple CPU ports in tag_8021q mode */
 		break;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4011a7968be5..d208d57f4894 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2195,6 +2195,8 @@ void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 {
 	u16 vid;
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot->ports[port]->is_dsa_8021q_cpu = true;
 
 	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
@@ -2203,6 +2205,8 @@ void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 	ocelot_update_pgid_cpu(ocelot);
 
 	ocelot_apply_bridge_fwd_mask(ocelot, true);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL_GPL(ocelot_port_set_dsa_8021q_cpu);
 
@@ -2210,6 +2214,8 @@ void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 {
 	u16 vid;
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	ocelot->ports[port]->is_dsa_8021q_cpu = false;
 
 	for (vid = OCELOT_RSV_VLAN_RANGE_START; vid < VLAN_N_VID; vid++)
@@ -2218,6 +2224,8 @@ void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port)
 	ocelot_update_pgid_cpu(ocelot);
 
 	ocelot_apply_bridge_fwd_mask(ocelot, true);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 EXPORT_SYMBOL_GPL(ocelot_port_unset_dsa_8021q_cpu);
 
-- 
2.25.1

