Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9CA59A52C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350168AbiHSSDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350324AbiHSSC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:26 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D707A346F
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:49:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OA+vwkP35wcJllP1BbPkMfMH1U8jiJXAlyfd2ayc4aTDspK4f+kK/h/iPQYLlOCo0lx0rBIOgo0JgfQtW2BsvuPD7YiF7Vt1LxPE/Pb4hzZnlzPzkLnEXbuVgaoWLtEy7bqJkUAViaDDJ5iHanmVZV7uz5Pb6afFafWh58sy7YFI+6Vol+9cLFEnMKKsmmld2qDmriXPXiNi1w4dqAiIuCvn2QiH1OuIW806yoPE5XISRWFyj5qKUOfBLhsXlbsC0o9/pIDiphoCxgBeYbbS2cbyx2hYa6+0fvdmCNEtHdQeKG0CaQcDLPTSeTDGXPAZjP3rdZlX6na6DE5ZO7WrYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJ9Iwy9XnaLcbayLGnYCeLzzozX1Ij2tnOHj5x7Xa8s=;
 b=eUwE6bBeU83CBz91tY1djAH0w+7dnTOtJLY4bSK5IgUuZJHb472EvA2RNaRKk0Xgc45UTNIu694TkS+OgMWAbTD4wG8zDRlw7vYK4pqmPtQeSBvZz7+8AWWCvvsf/V3SyvUz7JlggdR8OpXjA4Td5q2QpCbKJNwCX9101KinSHc+kCcSObVUMGziRX0Lmb2uQzXH1KSozQVL1lW9y2clTjd2Y37GJliW1nFayps4rToOa39tvrUn2uipZApiyH421qPfLkbS4c5t+Rik0kf4hvrcKJgB9Eo6zITNdr/94VyOwtJ2XDkFaCFbbKaB3UcL0lboIo1m+T+WuAM2o4ABfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJ9Iwy9XnaLcbayLGnYCeLzzozX1Ij2tnOHj5x7Xa8s=;
 b=VIBPbLZuelbyKjXZLN4NHdMuzx3Hg8qGpbxBTbKb7rnA8zU2ZAVfmyZe0bx3TEw0WqadAOCPEsR+JWaoJ712BSU8P0yzWoXVMfWaunTbZZsQD/PYLF9FhrC2z2e4dExj2BUOmSE9olXG/lL2IytiH09Q71ee+ezbFP/oAugSi6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 17:48:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v3 net-next 9/9] net: mscc: ocelot: adjust forwarding domain for CPU ports in a LAG
Date:   Fri, 19 Aug 2022 20:48:20 +0300
Message-Id: <20220819174820.3585002-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
References: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 060a7bea-7212-4078-968d-08da820b0e6d
X-MS-TrafficTypeDiagnostic: DU2PR04MB8551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wtU8+gyk/J/AtjqHOYRB1dGCMyhA1/8ANvHa2rSpAkBOKQHwp2rxffzimTpOs6wuq9Y3qmVR7p+RKAdgf6bwj3vEnLM0lUk4CC4Jtb/6OOW1g7ojHtEQhG66GguaKKqN9ExHtItKSRFvDlFu3SRdGJ/DZz8npcy+R1sYOVI631zbtZ9eOGrCNbVnEMOJN6uPrTVnHHtnm80Snd+iau2oy/jSX/vpYUwQZ8+DtOpSrByPJhHWCdaDI+0+jTXeN4JCUvKKyCEE2w8x+ieNUAgxylUa1bTnebDP2V9yuzyEMXt+TsdMVJW48Hy65DHdDIXZTVWfVAGM79EGMQ3Yk9OGTHL2OOm6kd5iLV8kqGSqajlZUXlmQU6U7Ls2CFQqJjdSaSfzZghaDdRCR0ZddL2VnfGlvoBVgNmilNhC0BfxYt0ecXaDSB6HE9YOnjyqshlPwgNn2UGKFYss6XCPpVwDEuyImWpbUSGOxCKVkFTVLoXdcQHi+/+SLVDHCdijKGxENQvCJtqom+2d2Yiuxj1nvfMdvQad8C8i08CcKnKjmAR5YneYmqMFuiGtMUnVnB2mdkEz7TfkjS33P4KFlNXXBf7VxU0oBkxKvEklQmT2tW0cguLWlifBx3F640K3xYnr28z7QiTk8BgO8m2qu3Refdm4bTZdZ1/C/Y1yStamva4wdZ5cKTCaJyyc7XYkQpux3YlmiY1OEdo02hxSAnea5idblMFJVhPJO32NvRkKXjWRD2HVlKjdQauhpJifauhjby4jEaq+QZscVnvvrMprlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(66556008)(8676002)(4326008)(7416002)(44832011)(66946007)(66476007)(316002)(6916009)(54906003)(5660300002)(36756003)(8936002)(2906002)(478600001)(6486002)(41300700001)(6506007)(6666004)(26005)(52116002)(6512007)(2616005)(86362001)(83380400001)(1076003)(38350700002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?twqfI2BF8AvTMi4uBxtN2W9NrbAAhbB1rXsYiTnppyiQsQ8IZQuKAngEmTHX?=
 =?us-ascii?Q?MJlg62dpIpR8cPniwMLGlx5sT9F9o6KMIvVPWWeEhKrGsUSPqAQHzRIr2a2T?=
 =?us-ascii?Q?7cEDvPr7AoAY5KNNAEjJ+3oXg5nANH2djpnUBJkdUcnBtP3b+PmNt1EABkqI?=
 =?us-ascii?Q?1PB3jIVugOsGOLvwrrILlR7TzLOPS05a85cw72H0wWQ/5JHUdMJx9zkyUF3e?=
 =?us-ascii?Q?l/EJg8ly1sf3a6A2cLfJNQiVmXh1BpnyD89V4HEwoa6EqTSn7z2RpFVj21PS?=
 =?us-ascii?Q?x8SE1vh5ccjf7BzQBy5O96g6m+1e4QxiNuCKBhF6LgT5BKPOmQ90w8+YsTrb?=
 =?us-ascii?Q?P8mYaNknnXMYJse6oIjHc7QEE1IHTuA+UAKFM1Oo//o//75zD7YbjNGluq9s?=
 =?us-ascii?Q?ncN+ChH/9vyGzRkx/XaexTfIImxf9Bncxmeq0VgtjJsjMYNfAM7Jt7TNrE68?=
 =?us-ascii?Q?I/PucS1z5DkFIEXvIEy6vsiYg2nrAp8LU4dEaoPcL3PsqT/G6S7qn3wXPKs1?=
 =?us-ascii?Q?HjsSCXRVKRabZRXvVUyu6FahJCfPAkLo3ZmH+xfOCf4O8p3FlbfaE+ve2cRn?=
 =?us-ascii?Q?zPt2vieOVaJlHp9r5Goy8PYoYBGe7fBWTUoum+Ul2DcOHM3Qg2NYzsHHpPBC?=
 =?us-ascii?Q?nPEfDfOnlk0kFOOhTZT9hPQJqQxiYEJw9zJ1E0YczF3bx89v5/n19VkXR8CU?=
 =?us-ascii?Q?F58e2ckc8RJI7kr30ndZafeX3agNvM6UO0EN2mvosBuIVi1LuYRIQirUlsfh?=
 =?us-ascii?Q?P0xXdGO8rpuLtDubN6ZKtKvriCtyOJ2qU12p8N4RNfssKM0NcHemsSmyDXQ/?=
 =?us-ascii?Q?b/MhsCoCe/tjLQLOGs/555K6VBqbRdK3aYu2sP6GJOixhkcGOuU2G5qACiBx?=
 =?us-ascii?Q?tupo4OYsSX3x0IsYvdeeJ62KpWjCVJixg5pb6+60z48ttSti+KDjYbue4iAW?=
 =?us-ascii?Q?whiHIRPGeDUjnd5Sf7R0GCK/enLlVxnD3xiN02dp/FtWJ2nW0Bz9l3QYxaLN?=
 =?us-ascii?Q?gmVts+pMpbiUiMw1Z1dYJ2dVsrM0VE4oJB58oGA4bbLNCZkajbRQAgRnhLxX?=
 =?us-ascii?Q?xM4QzaRKWLSbNpZ4hnUrxiCgo6vAlnbPRbRIhtx8sFa+rdxb6VDmqc8hbyZ4?=
 =?us-ascii?Q?aLwLy9VqJuXJ4erJW41w/UZ9K4Q+41HsJnwiCNOacLpdAgfErYAVKJHwyxuF?=
 =?us-ascii?Q?w4e95aG6L992LUP8TJq62cbHS/Fa/E+bmsXJmaBWaJaHd2P2EZgGVHZ2nNvg?=
 =?us-ascii?Q?tum+njMohjQDy5TsnQ2Y1i00hbDybC3qEx8U0dZv3nzmVZOQvGIhMJ7QUPFZ?=
 =?us-ascii?Q?gowtZ2c9LktHozc2P60zJYwLHnXgJK0B7MeP9XoKVd6dFHksHQ7kK//ma6M8?=
 =?us-ascii?Q?+uGbnIgep0zCBbZgOZt83PTM1PMuCWbIUi3wzwwNqBqDFktoS2OUC1Q8FQo4?=
 =?us-ascii?Q?wgovTkBrxYz6neNTl079kIzulIdx/k7rWPy43ioHFrhyj6DJgm0XbjE+tKPC?=
 =?us-ascii?Q?3tpPw2XDNMgU+3rGIFR5XNTuIgyO0VqiTAVlyWiImHztMv6z4FzrBXozBYol?=
 =?us-ascii?Q?Ip/4WN2IN9wSaekKtIfpunuQf8bKJTvPga56MDJyl5E9cJClXNNEgCiaZUJh?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060a7bea-7212-4078-968d-08da820b0e6d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:42.6066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5WJ1wLJnW7cwZdMDbNnXHx281F+SpSeKgWa3MF856K3ZShPwwo9YoYJWvBLzfrcX1y89xb7OeUqktLoqAT/hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when we have 2 CPU ports configured for DSA tag_8021q mode and
we put them in a LAG, a PGID dump looks like this:

PGID_SRC[0] = ports 4,
PGID_SRC[1] = ports 4,
PGID_SRC[2] = ports 4,
PGID_SRC[3] = ports 4,
PGID_SRC[4] = ports 0, 1, 2, 3, 4, 5,
PGID_SRC[5] = no ports

(ports 0-3 are user ports, ports 4 and 5 are CPU ports)

There are 2 problems with the configuration above:

- user ports should enable forwarding towards both CPU ports, not just 4,
  and the aggregation PGIDs should prune one CPU port or the other from
  the destination port mask, based on a hash computed from packet headers.

- CPU ports should not be allowed to forward towards themselves and also
  not towards other ports in the same LAG as themselves

The first problem requires fixing up the PGID_SRC of user ports, when
ocelot_port_assigned_dsa_8021q_cpu_mask() is called. We need to say that
when a user port is assigned to a tag_8021q CPU port and that port is in
a LAG, it should forward towards all ports in that LAG.

The second problem requires fixing up the PGID_SRC of port 4, to remove
ports 4 and 5 (in a LAG) from the allowed destinations.

After this change, the PGID source masks look as follows:

PGID_SRC[0] = ports 4, 5,
PGID_SRC[1] = ports 4, 5,
PGID_SRC[2] = ports 4, 5,
PGID_SRC[3] = ports 4, 5,
PGID_SRC[4] = ports 0, 1, 2, 3,
PGID_SRC[5] = no ports

Note that PGID_SRC[5] still looks weird (it should say "0, 1, 2, 3" just
like PGID_SRC[4] does), but I've tested forwarding through this CPU port
and it doesn't seem like anything is affected (it appears that PGID_SRC[4]
is being looked up on forwarding from the CPU, since both ports 4 and 5
have logical port ID 4). The reason why it looks weird is because
we've never called ocelot_port_assign_dsa_8021q_cpu() for any user port
towards port 5 (all user ports are assigned to port 4 which is in a LAG
with 5).

Since things aren't broken, I'm willing to leave it like that for now
and just document the oddity.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v3: patch is new

 drivers/net/ethernet/mscc/ocelot.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8468f0d4aa88..efb6eca24c7b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2046,6 +2046,16 @@ static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 	return __ffs(bond_mask);
 }
 
+/* Returns the mask of user ports assigned to this DSA tag_8021q CPU port.
+ * Note that when CPU ports are in a LAG, the user ports are assigned to the
+ * 'primary' CPU port, the one whose physical port number gives the logical
+ * port number of the LAG.
+ *
+ * We leave PGID_SRC poorly configured for the 'secondary' CPU port in the LAG
+ * (to which no user port is assigned), but it appears that forwarding from
+ * this secondary CPU port looks at the PGID_SRC associated with the logical
+ * port ID that it's assigned to, which *is* configured properly.
+ */
 static u32 ocelot_dsa_8021q_cpu_assigned_ports(struct ocelot *ocelot,
 					       struct ocelot_port *cpu)
 {
@@ -2062,9 +2072,15 @@ static u32 ocelot_dsa_8021q_cpu_assigned_ports(struct ocelot *ocelot,
 			mask |= BIT(port);
 	}
 
+	if (cpu->bond)
+		mask &= ~ocelot_get_bond_mask(ocelot, cpu->bond);
+
 	return mask;
 }
 
+/* Returns the DSA tag_8021q CPU port that the given port is assigned to,
+ * or the bit mask of CPU ports if said CPU port is in a LAG.
+ */
 u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -2073,6 +2089,9 @@ u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port)
 	if (!cpu_port)
 		return 0;
 
+	if (cpu_port->bond)
+		return ocelot_get_bond_mask(ocelot, cpu_port->bond);
+
 	return BIT(cpu_port->index);
 }
 EXPORT_SYMBOL_GPL(ocelot_port_assigned_dsa_8021q_cpu_mask);
-- 
2.34.1

