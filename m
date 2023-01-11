Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD70C666040
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbjAKQSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbjAKQRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:52 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455901C417;
        Wed, 11 Jan 2023 08:17:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+LrA46cWmJIYTvaofI8uCWmszO5ej6gNLrYYVYTH8lbsZ1SS4KmsoMJcsKfU/aNjBrI4c8HvK3RPI5U0m5Kdlj2dJ1tTfSHI2dAVqlOJxuZ4uuioRu7Rk+bPALJfqIA4qOm+MGqgBmDrry9Fl3HK55Rvq224x7X5s3iH46XYcW7TuE3s3agrPIe6Fyad00Gh3HE4pd0gjq4PUq+Aju/io1xqPWBQdSOiQpug/1b5yIitPzmsbk470T1/ndWZ8WWyJZ36LC+Wtm25mNdmJzkLLcPZpMfljicWHokMmsynWvNn4HEYVXjbWo1Ho6H/xgP/tdGzkExoe2c6rhdtjv4WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8IzBKz5jWFU9nf2/snHShZyCuIq8lzBpN5hXtoMhRY8=;
 b=kHCmzf6PFGTEyvBkalMbBPuYZK/JlNZcK++EDg3y6hbsqYY6zPVofHwzd5H8milW3R5qaHVN4SXWBVpNqAoWjknBraMMhkzyEdwB58oEq2H1uXgmXAfqlZxD6CV6pVR8Hc23iWz2xoASMQGvqXzs83d9d7aSsjVv+E2M38zRcibC3nuBnwhE7F7PPHrW8W8I/yC+cZH1ebYUEJlP6e6MUYeTL2MMqurV1dptwQIyxfFeHHj9kv9OXtkha6FzEb6fJl2OVE8y4wI5u4071xo/e4FhacvgX/1GDkpshV8MVUMMUW4uLNfXTegECG+njXD1nTrhvmrEC5CFpX8kKI5fXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8IzBKz5jWFU9nf2/snHShZyCuIq8lzBpN5hXtoMhRY8=;
 b=FkAbDuoi17FkaAUT2PtpDMAQWMIMASZAvxjTiejt9stQqxQomZ1I1d3Ig1eO8WljZwLL+uzdCz/oifj9WFLUKFUXlT7+d+OnlPqfa87yFk2gwWczntYXF79ArdUmRKiTgoB5FLRJVhG78OQrVKPDMTpP8ZubRmLjv2xj6hznjiI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 08/12] net: dsa: add plumbing for changing and getting MAC merge layer state
Date:   Wed, 11 Jan 2023 18:17:02 +0200
Message-Id: <20230111161706.1465242-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5a17c7-1d10-42c0-8302-08daf3ef5570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMwtvm9L33IwEO4gZFcXn0L1NiYDVg9uqLHvopRLaFGGxHa+PeGeWkzzStov4/jVKXZ0nCfI4+6yw62hXKZI8VNsW5AI9ItOA8Tg6wBCoVC2B0262MwvQ5wiQflNeaQaQGs6BAkEtIDdTjNBnSKyqUmP2u+b6mu7bjTc3e7t30weFuEjwdSpIjdiAFQEE4cI5J5/YWtnrjO5e+bLDliAEUBRZxzDRHAvXBJcaIInpYmvtERvKlhWczoMSOD5MpuhwW2UkqAec0dDZQV0rGm+FPa5yM//wht8VQCmFXDLXLIwIiOSXvYq6iXM+H1L61DbobKDVKxK9zxpBgh2T4J6B5i57+ovKNHMZ7BjaiWLPIqr3zittpIIB+zRx2VKlXeMzohVGXeNaHmK7pNAqd3EqSU0dlTrfbLfA5GG2uoGcfZzK43tPZrK1wXYVM1gG80q5vSk4mF+jLBvSp1O6knd0WAcESbVT8yAn4sEraa8itBiycgMT0wNMqj5Xha5WnE5Fc8DSg3O0YV5qBuy6/55Fer568pJGE8/lz4Vqjy72E62sQ2vTxkq09t3gWHqwOnzgjhnR5yNlhUE0JXItvJQ8Kj1jiCMIJ79ACSyb30/kIioJp83lDuSOUPLP+QkAs3r3uX45ITuSZKm5hNUszfB+SOugT2ufX5gH0so2et70LQsM1muGR9cvR6yDeDW6TSa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(36756003)(26005)(186003)(8936002)(6666004)(6512007)(6486002)(6506007)(1076003)(2616005)(66946007)(5660300002)(66476007)(66556008)(52116002)(7416002)(6916009)(316002)(4326008)(86362001)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(8676002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2SL44taS+m8GWwHx/El9TiPxZEmTGTmFWOJM+KyivRsdkD9DDg4Nbie7pVVF?=
 =?us-ascii?Q?jQtqE5BHKAOIn4CNpI+bigAJyTdJYtqaOqSJ5+OwPdaWMINX9EZCOsPY1B1f?=
 =?us-ascii?Q?mdTNME6FVJ92Dj5KPlndtoWx7As7tS1mIo4ebwKWwthAPALNoVink04GrdIb?=
 =?us-ascii?Q?Tea9V/Gk4KxS7dumwPY9Yeeai4k7LLPaTrqkN+Kn9FGc4hmIRPo4UuHvBFEA?=
 =?us-ascii?Q?VMJhFLJK9r0J53EIO1eWydfuIt0qe/5tyEiIew5O9A/ezOHfvy4ODvhZnUuM?=
 =?us-ascii?Q?iQ7N37F1VN9Ac7h8YE6WFnmAJOTBZXUfnDHba3c96WkaFS9R7bMUOchhYHrU?=
 =?us-ascii?Q?x6F+Nt8xBaP7ZGfLAKjuhDcwb9dJxlx9sEuCJrojOUJZWKzrVcwwysD3Apoy?=
 =?us-ascii?Q?mas4uM2EDqAFtyk73UjrK+ZcVhDqZPfZv924JpqjshpiS606OIv7VDhxjc6A?=
 =?us-ascii?Q?8SqxlETytLskPlVs6K2hQORwNu8LW+k7LWTGg/ldTjctzLC0E9tMdSufyPZm?=
 =?us-ascii?Q?LR3CWlEueb95PDnMdmi6hNIAG26//929sh4VbALbxIIdRKlRjFLI9qK6OuyI?=
 =?us-ascii?Q?6P7DyybMZ759IqtUSappgVE1VzdAdjrskE7t71YZFgwm5xc7H+O/6h3d0fi9?=
 =?us-ascii?Q?fqQXt74oBVS2mjMVPRYpyl2jULV/R5LpJ8UwjDJBawWMPKLuXOYqY0uZ88st?=
 =?us-ascii?Q?utSaltvoORoRhuW8l3NuXRtLNhF3bIgUmdZQTYVMB2LtFnja9gfMqb87jxZJ?=
 =?us-ascii?Q?SzG+H+i3IiOGHQWgcwKA4caUNIKTjkXwqS8t7CsMhljPHBq85FR4niRsgvov?=
 =?us-ascii?Q?tClQoqM3oe2uxEgby/I9tO47atN3gnoWDsjvxN4ck0PXC4Q5gwuHCjkzST4b?=
 =?us-ascii?Q?/ztzMaB4H+ly3TTsGoCNYU8r12kycTjPvxXPwuFVl9lPyRwAwQTrsOZDzmdW?=
 =?us-ascii?Q?aFZ9psIEIzPYW/oJ3yjLpI+PPtD/M5QFvNJx3iJMFJNeZ4bAf1K+uXJSbFNW?=
 =?us-ascii?Q?K3wo4A2IveqQ+jLMohypG2pMrplVU8fmHBgjsoONLMMUjuvAZ/4DqQuEi2WW?=
 =?us-ascii?Q?3dAQNsBLb13GdFUrPfL41qmS7AujspQm9TLWTnF9GEM153OvcXM59+OX3bif?=
 =?us-ascii?Q?DT+vza08pgSRg6+AWWaSoRjjYntt8uRmdBT3aRm7scjx0SQmq+KxglINrDvF?=
 =?us-ascii?Q?+39zdOINZ1h1sRx3v7pIkUzyQ6cDhqYNXlfdkvSTz20D6Y4VqwF9Ppe9ofYe?=
 =?us-ascii?Q?wZ/lpxOQGZavBtnCX76CH9sKAw1DS62dXYolfGfUkEuu9yG9SkYGAxr64Dmr?=
 =?us-ascii?Q?sv10wx6De4bTu/iVgVgI4Zzy6koZTH7Y/WHQzgKVonYFplDkb2b8E+C0w6Cy?=
 =?us-ascii?Q?7bpeJdiP37c49wO0D0JyHylScLRpD5Bp0CH+7+1u5APCK4MXZ3xne9xXs0tx?=
 =?us-ascii?Q?6ME+2dL6tMNj3TLGULPZ2av1Ngxo+sXirurV5ipx+plNCVAyGHKgav2CV6bV?=
 =?us-ascii?Q?7Lxr0asyhK2oQjkKqX9tfoAYWR2VQEH4j2BpG9TapebfPAxbQfNuMGvJ4zKd?=
 =?us-ascii?Q?3DHBSTSdDsWziiuDl1oMjl/3q9AVs/QtiFSXuJ67EMuW3kIXPTlgM+/LxS4D?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5a17c7-1d10-42c0-8302-08daf3ef5570
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:28.4391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULk1GWLB3EQep2+r3xqLDkHw5kZme90fnZ3/gyUHYRKFCB1OBt1VRONP+N7pYYaF6rDKu7ODe/znVLrqWKddAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA core is in charge of the ethtool_ops of the net devices
associated with switch ports, so in case a hardware driver supports the
MAC merge layer, DSA must pass the callbacks through to the driver.
Add support for precisely that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 include/net/dsa.h | 11 +++++++++++
 net/dsa/slave.c   | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 96086289aa9b..51b0dc0d0bc1 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -937,6 +937,17 @@ struct dsa_switch_ops {
 	int	(*get_ts_info)(struct dsa_switch *ds, int port,
 			       struct ethtool_ts_info *ts);
 
+	/*
+	 * ethtool MAC merge layer
+	 */
+	void	(*get_mm)(struct dsa_switch *ds, int port,
+			  struct ethtool_mm_state *state);
+	int	(*set_mm)(struct dsa_switch *ds, int port,
+			  struct ethtool_mm_cfg *cfg,
+			  struct netlink_ext_ack *extack);
+	void	(*get_mm_stats)(struct dsa_switch *ds, int port,
+				struct ethtool_mm_stats *stats);
+
 	/*
 	 * DCB ops
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index aab79c355224..b6ed0f40a0ef 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1117,6 +1117,38 @@ static void dsa_slave_net_selftest(struct net_device *ndev,
 	net_selftest(ndev, etest, buf);
 }
 
+static void dsa_slave_get_mm(struct net_device *dev,
+			     struct ethtool_mm_state *state)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->get_mm)
+		ds->ops->get_mm(ds, dp->index, state);
+}
+
+static int dsa_slave_set_mm(struct net_device *dev, struct ethtool_mm_cfg *cfg,
+			    struct netlink_ext_ack *extack)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->set_mm)
+		return -EOPNOTSUPP;
+
+	return ds->ops->set_mm(ds, dp->index, cfg, extack);
+}
+
+static void dsa_slave_get_mm_stats(struct net_device *dev,
+				   struct ethtool_mm_stats *stats)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->get_mm_stats)
+		ds->ops->get_mm_stats(ds, dp->index, stats);
+}
+
 static void dsa_slave_get_wol(struct net_device *dev, struct ethtool_wolinfo *w)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -2205,6 +2237,9 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.set_rxnfc		= dsa_slave_set_rxnfc,
 	.get_ts_info		= dsa_slave_get_ts_info,
 	.self_test		= dsa_slave_net_selftest,
+	.get_mm			= dsa_slave_get_mm,
+	.set_mm			= dsa_slave_set_mm,
+	.get_mm_stats		= dsa_slave_get_mm_stats,
 };
 
 static const struct dcbnl_rtnl_ops __maybe_unused dsa_slave_dcbnl_ops = {
-- 
2.34.1

