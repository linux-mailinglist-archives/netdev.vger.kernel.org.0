Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0933766D934
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbjAQJEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbjAQJBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:42 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2042.outbound.protection.outlook.com [40.107.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38F53029D;
        Tue, 17 Jan 2023 01:00:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAlbjlhyCzPpTVs5N52+Atn+mH6WN2EsmTpvZPDyC4EAilTKx8QsmvFyjWQgkSEV+mCFWytGIS6UC6vvv8wZtxNKHyv8WIHXpd3HVhWowLqIk7iIquKZuRpt+RtLALBRLndhJquoRTUHt0ZbcqscHwNcYU0Z6l3P2K8PJxpEJV7z2ar79etwlzHr7M8odvHgj2aU34MGavZ0MRFtpYim6EVeljr4SG6367BiVfuxXFzO4ytaKy9uoNLDvOhRZasB5K+Fr1IDwt/dgiUArb3DH/d/ZcJVlQieDAtZRvjwndL/YcrjxwMdwqCL25hIFi1Nf284GYKtSihAVHMLCEI7JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJjB/37prwoVGpq8bg3p78876HXFSMiHPWlOj1JxWLM=;
 b=bb+Uwl+lkpqnOsrt+Vs/TvOlbUrIXqdCSTozrxM/2NsMk+y/7QeLqbmfgJC3tRq3pUKqD35GvBUlURXp/y9220Bt6T6a6DWC4X34h1/4zZPkld98XQjTKkeUNOi1tr9eyrVpEam5vGPC2Qz62+SqR0LWrBebS3XSz0KCTjqclh88Lsr8XFTt0Vi5FGdmNspe9mBoYv2hl81WqR1SLBcFw78DPkvyItwbog6g/Sc0KLrEwXwxp33hFmTvAP8HLlsbuPuN9X61QyC6PyICEoYk4TaLCy76l1hUovr2451YgCKsYZ0tQxzW/iHDdkL7Nnl3QVBHbdNdONqzuXUMsa4Nqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJjB/37prwoVGpq8bg3p78876HXFSMiHPWlOj1JxWLM=;
 b=g87WuVQyo1VcKy6qBFE6Q89sIERbuumO8rwklprHhk2F6vXzHLLEkhKDpML+cAdUa5mwSCS9FyZhi1HazJebqog7gPp/q65wbWZR0WL0p2wuiBkes4mGxowWEjlSf58UTVoKBbfnN2IZ5JtDV+WpOSjJ5VAjPqHj48tyRx3S1o0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9182.eurprd04.prod.outlook.com (2603:10a6:150:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Tue, 17 Jan
 2023 09:00:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:11 +0000
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
Subject: [PATCH v3 net-next 08/12] net: dsa: add plumbing for changing and getting MAC merge layer state
Date:   Tue, 17 Jan 2023 10:59:43 +0200
Message-Id: <20230117085947.2176464-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|GV1PR04MB9182:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d73961-d5ea-4f3b-6749-08daf8693d77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lkge7ksxy4RsbOwsKjfTKAtfODB1PPC2qEXEb/rJPyDXmw60lPWWxcVp1JeH8XmYP3M0OO+ELybXmWAeWRhMp4r485NmCYF5V7zXr8gzCox6IrhZOrrkHt9o2v/BkIqUgkuju95SyYzkKlFsA9kUyxO/CzaUOjO7aVmuwDB28BkRcnv2bTApBlLCCjUcRbxQo/yBwExMUVdjonbBkeQvKq6OtZ5QnKJ2g5Af2L+424DAlU73Nsxq112KVsY9gL4JE2oNRufh3hNoZ8j2Zfbb5n2VcsFydf7K3vWyWDWwfDgwI7YBrbhnTij8NJuGucYXQ7lBGOINl/ksw2PlKaJAuGMERbCZbYRdIIw0pxm5R1XqhbGIo/tTniCg9pj5mMOOKO/B0ZbtWARiVrcyZKx1i0oBErIsHP1PzzBC+3rde/uRvzIxdbC7iKS3GoZtqGmc4/r092M1AkIwo0IsZi5yuTyaBThC9mY5pJV04AhjwCODTwEky0ScEL4+/OkZpobwSuk+WNR/R9eTpNTw4ipW+RMVQrE177oLsruE7XDVvDjOHcJR4a9B6/1Cn/QD/GQSnQvaT8y9XEEynUsVDDd99ncnn+hlycN1TqAe/mJ9/lG2FaHtYcpAGFPyosmQ1+euVGP9edGd6/MtBYSpsg4mUY+rh0vIbGeCR2hZZj86x/Z/ubwDuhr9SEgIey5lWV0/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(52116002)(26005)(6512007)(186003)(478600001)(6486002)(66556008)(66476007)(316002)(1076003)(6666004)(54906003)(66946007)(2616005)(8676002)(6506007)(6916009)(4326008)(38350700002)(8936002)(38100700002)(5660300002)(7416002)(41300700001)(44832011)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DVzJVCHhJbHGu99hImrZqVliRIOJaR9cupMnhwDNHgqcMtEoHHrDPVi0uI3R?=
 =?us-ascii?Q?ikfpwf9r3KVdvyyPjgni2PXD9h6JcMLQTE3p7kTJur48OHT1kmvjPyzURN/l?=
 =?us-ascii?Q?dtNssk6lDm+hLgALjSl4BS/YlkTSCF8KVTmrjDd1WwZmPF88zQnhjpYb8vND?=
 =?us-ascii?Q?TwmDggkTs38etpY0qUyQsV7vKajAAHYMIdaRH5Cd9dg4RxZRtXDirNODWXTq?=
 =?us-ascii?Q?rNADZU/jRJqOCXsAySH7t9AJEsa8r2kjHGqIWhpUgyBg5F27KcC69vhw38P3?=
 =?us-ascii?Q?KnlGBnH1BvE69CBFvdpj0eciTWD9lqDML4suKt/sBXqGdmdSbflEKTEI1QV6?=
 =?us-ascii?Q?34glEBmS8ag2qxhwbjmAkKDDzv5ZkayqwETYbgS65JSYCDs04wusnSxabHY/?=
 =?us-ascii?Q?arEmbvrahNVFtjGb2nL4UmWbKqkyd6nUgxnbDy+r13+PbwZ3fYZSTl8hyTIq?=
 =?us-ascii?Q?KwO9uHFl01H1aBRMs2q9JyW3vsd6zIfcucmeNX0Kzess76rCoQ+9TkGxwq5a?=
 =?us-ascii?Q?Zay9revwIPBoOEs7H4MTH8qCpwCvfygEEHhTkuSoxkmZV2vUqfDF6iMOgYOa?=
 =?us-ascii?Q?Gk5A6+CswToOYKcIPvNwiWbx9CpZOyovseJI119UvHM1f95GsWeLkn2GxjmU?=
 =?us-ascii?Q?1kKPTdWzUVadFtRr+RCEEibol5fzv1ZPGzJ24VnW4FGJrM6frzH2ruN1LQDE?=
 =?us-ascii?Q?9xTgrfMfsUekPtoba3DxdlM0P3FBaXyR8TqsrkbECly9qDpADG4pBRLjFudN?=
 =?us-ascii?Q?GLHVrGMkFdj37SCtiEFix08RHWWCpf+uL4Jw2LTQA5qXGuH3E85ueNac8ObN?=
 =?us-ascii?Q?Bmss04X6VsrJKrtlrYZ2k92IVfoS21NQ0Tr0lnnO+ksdeOnGYoGdG+iLZbVu?=
 =?us-ascii?Q?zjlPp3Y6DkcXZmmUq4ow8h6KVpgJWsRmXEiEz1rs8EhpQz+zTCse59b+5bgn?=
 =?us-ascii?Q?4ETy4QdfjjNhS+VzONdXNPtQD7tFaKiQNBWXv4+9mP6bson6kkFr5v0ZCYRH?=
 =?us-ascii?Q?iwpWXYZnZZ0ZPXsFMba5XRGHsXyRXVNu0Q73IXXdfkvnzaNvVNwr+eoTF/6m?=
 =?us-ascii?Q?wbShrxA7jEf6AQhl1KXLrM0kZ0zGAqBe3KSHI8SoeU5r820KOn2YqyiOAmuY?=
 =?us-ascii?Q?shWSjxqgGHZrd/rbENE6hoiUEIEHFfAKBOcFcJfJR5ZfhnXBGdkxOM4Kylw+?=
 =?us-ascii?Q?4z/F24qXenSR/3yHKRw1bCjIzGW9DTb+QWZQN0inedACEZtKPHCxawWvrSgw?=
 =?us-ascii?Q?e8kmmnAZ1iLyVc1+bG1QKmIPk9b1gO1jX2Vhsaw8SeiUuLLjCpjEkj3Sv9KU?=
 =?us-ascii?Q?tipkTlCt4B7b79ZXGXgSO7J6QUmGf8fPJPMK531YNtJ7K+gC0w2eKABmm2pG?=
 =?us-ascii?Q?E2ANd3Q13v9alhwpDeHYZ3dwUymf3YulyOaGuw/qTQ52CRrwzOKqbSOu3NMV?=
 =?us-ascii?Q?UFxp8fngfbkfRhAxEOzZPC7RbYARGVYPGf9P2JsV5PxDCg1Wf6/POH4J05cP?=
 =?us-ascii?Q?cAty4GSe3bE0ocSKD3N+eeZfT0lXmcG+0MSfJbRjoCQasXP8/0gPgrY8BlWi?=
 =?us-ascii?Q?XKUX5v2o03Vz6tquXItYIXzR5wBk3o7UA5aEyP7j+x25oC69704XEgRZcRh8?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d73961-d5ea-4f3b-6749-08daf8693d77
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:11.7992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ye/Uce6xopEE9H+7PvGD8ltPJfAdmHKORK3GtDeywQVCXJIU6w4pfxc/Jo5ANkUQbKIz1Yr9lnulrf2x9+MzsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9182
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
v2->v3: get_mm now returns int
v1->v2: patch is new

 include/net/dsa.h | 11 +++++++++++
 net/dsa/slave.c   | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 96086289aa9b..a15f17a38eca 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -937,6 +937,17 @@ struct dsa_switch_ops {
 	int	(*get_ts_info)(struct dsa_switch *ds, int port,
 			       struct ethtool_ts_info *ts);
 
+	/*
+	 * ethtool MAC merge layer
+	 */
+	int	(*get_mm)(struct dsa_switch *ds, int port,
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
index aab79c355224..6014ac3aad34 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1117,6 +1117,40 @@ static void dsa_slave_net_selftest(struct net_device *ndev,
 	net_selftest(ndev, etest, buf);
 }
 
+static int dsa_slave_get_mm(struct net_device *dev,
+			    struct ethtool_mm_state *state)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->get_mm)
+		return -EOPNOTSUPP;
+
+	return ds->ops->get_mm(ds, dp->index, state);
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
@@ -2205,6 +2239,9 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
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

