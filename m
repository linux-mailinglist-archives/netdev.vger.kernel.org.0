Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33FCE4CAE68
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244970AbiCBTP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244913AbiCBTPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:53 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6AA4D9D4
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:15:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBpab8KkRWat6K6T4u+MlSpTmDgNlr3FEelEuNitmvAdvJNw/yEjRBhQv58cUhLWRn0fzk+Vug8kHlXSXMlqTMWcrEyihvVqY3Q1AVQhd55hkgYaa3sMvkCX3VXSMFl/Mc55r+vHWAU/7IPqERdlc41E5fZmRPDnHQR3aEwvOTN1CRAWBIuUb98+vPkA/L04wGUx+7au9xtKldBOcUY2vSaS9mGQnrdrslWH3t6jpxzPbKU2Kg8dgi8gu1e02oDsrA272mXuUUn+47AZrr7j+a/a0DUfvmOxi6nzvHUreR0rGtRkxra2FXsr8SjqfHO25fyP0tOAQqwGcHcXbW6TIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QbrTwuO00E2xzeqv/DSK5wcVZVx8ycrE7S5TX/lSEPY=;
 b=Cj73xwoFZRjaY6FmQ9mFFtxJXaaW2z3tuYm0niPBKkwCgeODEIzUNJzvIuWfKEGoQQZoDQirZR95eQk2bQ14ycMRAij4KChX/Q/cPDMKiu3difr3UinKPhW7h0PUIKh9bM96MWTJhy6ZnbBBhkZCEK1rEIGJK/o5ED3I22tFZfIMp0q4ZEmaxvRj8WrDcSq6RbhgR54pxJFH2T3gJJuiKlbjM6wzaq0YuTLrF2xI+N9CsiSefpTvWBaabvt9wToJnqbwPYA2cYM3KgfufWYTSEtNnlXgHJLEKZlv136X9wL4C7DvmQQTo8jK4G0HjZ4aWgxTq4hUNOVpyBYQzspYoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbrTwuO00E2xzeqv/DSK5wcVZVx8ycrE7S5TX/lSEPY=;
 b=Ec1JuVutBicFVwp6GooRaLzB5Ofaq0Ea00X3kRSnEnoyoI3fi7HRgdY22wdZ5HzHcK8edXbHcj97ZKnXmq/QHvyfk8F27BpOrzKS5hsgM44xHDvWljN6HyIVEqHyf7BjjMavng7Yban6+tT+u8NM98N3c7SUxjF0Fjzt32Uw7jQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:14:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:14:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 05/10] net: dsa: manage flooding on the CPU ports
Date:   Wed,  2 Mar 2022 21:14:12 +0200
Message-Id: <20220302191417.1288145-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60951445-67ab-4507-2888-08d9fc80f094
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB291176B86B2E362AD9127F10E0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K5pLARjWynJ9exEJ6nvsTc3PHc9aCyhFuVuc1IH0KEHuU2zm0JF3zW6cQiFCpcaR0R5RDmyqIHpc7RKE4GhJ3oauU2qQMNINu+GiW5LyjQUz5Pbpsh7zQ1OALXWwyrHREfOn7ul2kp9k1NibhP992Ye10VhIp67mXiO1vYCoXOsjqeg+mfe17lWeYnl7F9Kd/lDXArjWx3ToPsbLBZsPt4/m8NIqx+h6r9nn7F1I5ttsOqa4AVSOEbOswb5VlSqwqLLwsh9tk89LubkLqdQWRv7+LXH3uRehFK0qLNt3GdbBSs4lZCHZLGO3+In5/oGmrNOJcvonJrbgOui95xAqGnNhop9OxUxiCVJqjITq3LqH5FnC+409FwaPLFun1K9HglACrWki9jJG+OG9Whvv5NoACsnfm3LJLPxtbN5GAngxslR1Fu03X7kEdKVxucabSFoV+tZXbM0/g3gD4XQV0ECReTyPU/uyc/4tu5xgO6cPcW3T6gktF9RBiqQVI0xIGtlpMXt1oSczgexgfDjIjEFfxm1FKUZTpUfoDYDlYxGA6cne6jxOCYd8M6er3mn7OzhEZKZeeZtwhuEJUnsEAYPjgVXMvtvjzIFXESyz5W9oEo22zM79yQNA9//t9p9t/cLo+7MR/EUyjOhTpdU3ymHPGPlvOljcm2vEqsMP8LBOD+sD10WtBl5KmOlJ9qF/5ZKySy7K7WsCKLGHzFX3Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5OKLByPjjyUPV38H6ZAu4RvvynZ5I8D3f6nSPm3gsQZyZLAY6q/RSwARHbgD?=
 =?us-ascii?Q?Osw+BXOjbr9yz3Z1Y3YH40u1kuZgxIAwPN9cNe3FzzkyOLk191tH+Wg4mWEc?=
 =?us-ascii?Q?EsAJBwfxupqtREVEK4VzFiep4DfLOfcjlIScV1OIYS3jvRFaorQkB4KyEZwd?=
 =?us-ascii?Q?Q/y0aYmnWoIRCRuY3iZQ8J10CYp/uR902KzPV6umP7I+Xnbiz4rVuyu0OdaA?=
 =?us-ascii?Q?4CLGkAaEWugJWdr+LChON5yCUFhNUek+CyvbB+4fy3MxwRyerpuuAvWqRMgN?=
 =?us-ascii?Q?Gw2ilrT4QXSPzNedGPeqd4oHKUqMZc2yrXOjDC+242IIstYbrGezRPorqnmG?=
 =?us-ascii?Q?EgwbuaLrbyXGPIX6OTVE9gIXtz4R+icsZgGelDX90QSbcS7sULChFT1YAHpB?=
 =?us-ascii?Q?jERVuEKxT7rKq7uHo5me9n+NlHi31CdhJ8KnZ/JeNe+WIL3uHxqdO1Qr8tc7?=
 =?us-ascii?Q?Xh54R8W1iWzJQIYGDlcNUhjOFiaYIsKgsPjs0Fw9ekQ9sZkVO7SEQ7/xKLWS?=
 =?us-ascii?Q?FnoO8lSo0ENJpILfACq8V1jqQ8NM+mPgfGemsD0msFxTj5V8LM8mEg/EmL5G?=
 =?us-ascii?Q?fnQ4KLbivJT5SPvYDsfzFaL9mgWNfq8cGqC09GusK5qHCAn5ojyuLsYI2xHy?=
 =?us-ascii?Q?PKy5dtsoa5U3q0YYyJp7ZVqP1WGfvYECsRByEWXhr7bJnoaaWftGhu/HBHBL?=
 =?us-ascii?Q?gO7hMEg0b2IX5dG5I6mRuA7v0ZCv2BypkqoIEnU3Ny4BiLf/ePesGSPxfheF?=
 =?us-ascii?Q?ytIvKiYef6sdtGmdcRTcVaihD51weMzxtHp9mtgaD5fcaJMm5o/dxlcoAuME?=
 =?us-ascii?Q?E/m+HNrcueOuIGzIGBU0RtR44OP7O9oUjV0OkWcpui8RSxSBvoN1udS1gVeV?=
 =?us-ascii?Q?mRMi6S+DZB0HMBtyGGWNx0nXVp+GKdehUPslI10VtjTPR8O2NNuGQpBkXywz?=
 =?us-ascii?Q?ThYi+7AlYrIjGF/7d51YwfF4j3//ezHxv78H94pXM36NZVwuPv7TJdnbx/ht?=
 =?us-ascii?Q?objWbrihfAOpu3/a546F56KvrV/9C7J5/WlmAh6YqJc79/ho2oziUGy8rsDW?=
 =?us-ascii?Q?V0U14Qph2wUZV8MFYg0bZLlOhSrao1vIIrxH85ZPBstHz2OIgQYOBM7KvG8w?=
 =?us-ascii?Q?7p0BMonQ+4HQA7od1fyQqeMZa2Lz7nfqJAvaBdJQE4ZAtFU0gHSPIQ2Cq2Fb?=
 =?us-ascii?Q?/7aqDrgQnZ1RiJMPv/rzU145GA48Nbic4NH167DHNW3Z0OZYi1LlqFjHdwD5?=
 =?us-ascii?Q?+8WlFzs2CyfbgE38lBSTrXyRbzK9E/Xz1u8IZfL5+VMw8f4MUcgGjsVCH1kP?=
 =?us-ascii?Q?ZLp94VDMBpmyu7DFjcqSN2SGKPnz4tUFGyef4gHpT+VUoLe2HVXIQYwtk31I?=
 =?us-ascii?Q?F3gx8j7Pp3rW1avC7R4yA/eaOQ3IileJgI8JhjLGQu0yLKfA0/Q+jLL9m3KM?=
 =?us-ascii?Q?nsFbvim/FilTwlqEyhjnShWe6Xm2o4xqBCXxNcIYGLnd/J0Yg2Qt5168PbRp?=
 =?us-ascii?Q?3QLarKyaSDkekhs5Y+cB1ICFiLs/O7BeqJAtM2K8AHllgfHku70/FA+lRX2y?=
 =?us-ascii?Q?pMAFUbPccQ+MAavDDWl/zToMGF93DfXUdlDBA8DV1Bqo+3gCeRhRNo6xDwRH?=
 =?us-ascii?Q?dZlj6XsCRDBfYBrfBeRVqQk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60951445-67ab-4507-2888-08d9fc80f094
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:14:57.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IqmFs/G54+gtzqxVpkUOuC4wuah8/nr0UY1BiaRw5IGwpq3vfQAI+5iCFKngufQlgKmDS4UFSBw+AKbtvN6LNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA can treat IFF_PROMISC and IFF_ALLMULTI on standalone user ports as
signifying whether packets with an unknown MAC DA will be received or
not. Since known MAC DAs are handled by FDB/MDB entries, this means that
promiscuity is analogous to including/excluding the CPU port from the
flood domain of those packets.

There are two ways to signal CPU flooding to drivers.

The first (chosen here) is to synthesize a call to
ds->ops->port_bridge_flags() for the CPU port, with a mask of
BR_FLOOD | BR_MCAST_FLOOD. This has the effect of turning on egress
flooding on the CPU port regardless of source.

The alternative would be to create a new ds->ops->port_host_flood()
which is called per user port. Some switches (sja1105) have a flood
domain that is managed per {ingress port, egress port} pair, so it would
make more sense for this kind of switch to not flood the CPU from port A
if just port B requires it. Nonetheless, the sja1105 has other quirks
that prevent it from making use of unicast filtering, and without a
concrete user making use of this feature, I chose not to implement it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6eb728efac43..42436ac6993b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -229,9 +229,44 @@ static int dsa_slave_close(struct net_device *dev)
 	return 0;
 }
 
+/* Keep flooding enabled towards this port's CPU port as long as it serves at
+ * least one port in the tree that requires it.
+ */
+static void dsa_port_manage_cpu_flood(struct dsa_port *dp)
+{
+	struct switchdev_brport_flags flags = {
+		.mask = BR_FLOOD | BR_MCAST_FLOOD,
+	};
+	struct dsa_switch_tree *dst = dp->ds->dst;
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_port *other_dp;
+	int err;
+
+	list_for_each_entry(other_dp, &dst->ports, list) {
+		if (!dsa_port_is_user(other_dp))
+			continue;
+
+		if (other_dp->cpu_dp != cpu_dp)
+			continue;
+
+		if (other_dp->slave->flags & IFF_ALLMULTI)
+			flags.val |= BR_MCAST_FLOOD;
+		if (other_dp->slave->flags & IFF_PROMISC)
+			flags.val |= BR_FLOOD;
+	}
+
+	err = dsa_port_pre_bridge_flags(dp, flags, NULL);
+	if (err)
+		return;
+
+	dsa_port_bridge_flags(cpu_dp, flags, NULL);
+}
+
 static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
 
 	if (change & IFF_ALLMULTI)
 		dev_set_allmulti(master,
@@ -239,6 +274,10 @@ static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 	if (change & IFF_PROMISC)
 		dev_set_promiscuity(master,
 				    dev->flags & IFF_PROMISC ? 1 : -1);
+
+	if (dsa_switch_supports_uc_filtering(ds) &&
+	    dsa_switch_supports_mc_filtering(ds))
+		dsa_port_manage_cpu_flood(dp);
 }
 
 static void dsa_slave_set_rx_mode(struct net_device *dev)
-- 
2.25.1

