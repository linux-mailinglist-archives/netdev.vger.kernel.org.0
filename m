Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1554D6A7D
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiCKWvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiCKWv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:51:26 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2041.outbound.protection.outlook.com [40.107.22.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F367C621F
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 14:25:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CN575QcGfqpMmgUHX7YL4Cl0cv/An+M6sgqbvP0v+adL2qxdihrNCadyJeOfUzGg7o89qdvAADs8iV+9XUFPtleGqgcR4ITMJOrZp069FGmgBQTxG5pO0bZ0oEjWwLNMT4kIBQvg4zMsNGw/92pE7dukcijpCKj02NQd9H7sIJ+jVxt9/jPQ1IFN4KgREr+0e1keU9SBuDjeCyv2yuGVv9Ws+Gfbb2d2Jf7hUSjqRYAx5URMquz+WaGkVeSuExK05/9EwciWR8mukgg6HzICfvV5dW3k3DgG+Q2P+TWMrhEEUAb4uPwmw77ykD89BQzA1hR5HY64Lpk+Fbw9wI+QQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7mtbvztN10iuto0I2csKpxH9NCE9XBtw1uY3uhXO/E=;
 b=V9xhDhmkMWN2BLuOQMA8BD2kIoGD+PRD77MSmK4r1RrivRHFLnjJGxIaF/51HHLexeW3KoVRi0kh89O1hlsbeIbeNma2jFr2JiIYyw4FnEl5QnuN0T3TXLE3IDADohxanmDWuec6b9Qj70hRgw0OQa9ZG23KSobx8G04aEzTrUQKKQD6DmHlEVh9HwS+MeimreGYBrRXvouw8sKql2BdUSTRYDyAuogqIllGgLbSfRP6geUpWM7w6/k/dXCwy9nXOFYnG7S6fPe6llQYAxYjErDY8+xmX4XMghBJudhzKO2gEWRglBVtozv4Kh3SpAz/2muIJI1jpb2ON0tUQYZMoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7mtbvztN10iuto0I2csKpxH9NCE9XBtw1uY3uhXO/E=;
 b=P5so67ih6Uy+vDNuBbSQv4l5Rtp7nvw7JIQbrIVQhpCUlxvsFPwrOwFEDnHiBIJfFuyClzR/Cxn5bekR/9tthhNtxdAdKxTaS5Yk7PCLpam63zvEFL50GqiX1UH9hesYyPj2sVwh7Xk/cISEmfzAPaxpDRgAWCimDAvI9mfEqIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8934.eurprd04.prod.outlook.com (2603:10a6:10:2e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 21:15:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 21:15:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 2/3] net: dsa: report and change port dscp priority using dcbnl
Date:   Fri, 11 Mar 2022 23:15:19 +0200
Message-Id: <20220311211520.2543260-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220311211520.2543260-1-vladimir.oltean@nxp.com>
References: <20220311211520.2543260-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0188.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de51fb9d-cfb1-46e2-1d6a-08da03a446da
X-MS-TrafficTypeDiagnostic: DU2PR04MB8934:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB893441C7155A981891D3A7B8E00C9@DU2PR04MB8934.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UtkpK2sNRfgvs0f/b7NaN0izmJ7yCvMoihwtuDhsdxvhndHnlPTN6EDbvpMC6WzMDmMnlcVXvp6SHCJWiadEURLzdXB049+89Rg0s+o4Uk2szQ4PMzcYn/gxSeLBRc2gWJBN+hvSdrypWoOsPgjgOQTKEgclwkvlzsPMPafCcPvky6rNo1aUJkzHchRuvG51suh65MIm0wf9T7iPOYaTvNVodw0lU4vZtY3a67MVsSiXWFuOaY6kGR0SY8+TtIEkhJl4IBeABSEdrD8kS+Y5Qk836XZE94xtrE4OeEogHpQBXhnnOleyn+179+pY4myS75quFbTik1UKAGG4B+XJB0cjt2epofO1kwwFFfFqKsmNF0v3sgr6PSxXWmqKUv8vMBvB9MAPNcJGJP39o0Et6G9MT06mfkIXzDNTonZYjLJKEt9lh7UJefFBB7ZiKFK8fZTi2qHAzkqrXLjvGgWMFC2aO7jcs9OgPRaijvwig1vP8AcxHKhN95tF6QJOZhOjOYPPJUbTTtqRk+EHwJW3T+uo6AMLoWI9nm09/aaEAs1uGa4shHKHwqRIVafVH1BK2vTxC0lVt/UsEodyG4n20MPT1KcIru8PMoe4FgDOIxqhSmAv1Gc5t1AfYGmwE9LlfO/+q0NeoQJfIgTyD3502PEhC3VNXL5BSlkX6mMQeT8BLW4KSlVAxTUzI7j0Ee43dCnFmwov5B06j13lcUjhmjhxUJdGxJZpoXvRDBqbi1U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(36756003)(38350700002)(1076003)(54906003)(38100700002)(316002)(66476007)(6512007)(83380400001)(86362001)(508600001)(2616005)(2906002)(8936002)(66556008)(7416002)(6666004)(26005)(6506007)(6486002)(4326008)(8676002)(66946007)(5660300002)(44832011)(186003)(52116002)(17423001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UJmXy0R/jYK1dlSkRzRELmcr2MY6Yfhv9n+GDiuXystcVGRR3AxaUI79O3ae?=
 =?us-ascii?Q?rAI97wIviC1YC/t1h3ulwozqOou8jUYNyQAJUV6poMnfGAbZYQXZzYc57EN+?=
 =?us-ascii?Q?xbprkno97FXa/whnIBOg7HrxPr1hrx1PK6nYW/V0W0e8R/XOCtzMkeOJy9vu?=
 =?us-ascii?Q?ALm3yhDVpKF7o8soYvRJDg5bC3VbMOi6ojidNjxs4Vk940MnLEo+eoj29g1M?=
 =?us-ascii?Q?dbXhSpbB2+5OmOoU1gHhAFMfsL0QPEdQVu8c7UY+L7INIrKHvv/qQwQ2ZEdG?=
 =?us-ascii?Q?EUHXVZBt0mQGy7PLIxwVM0LKvR3LQDsQ1n3Xb56Po8P/G3TTwG+7HzR6zFu3?=
 =?us-ascii?Q?7++25uCB2NDDaIiboX6QXsQjv3v4RubQM4aUKyN9TGkPlJRPai4ruFshkki9?=
 =?us-ascii?Q?iRTGBZ1j8YgaNGuHCDvfh5IdZzxQvDePDtoGoVTBxzBSCNnAMjE9IENIpkmt?=
 =?us-ascii?Q?lD0kyiPUCL8xw0se1ypCd3rfAcbISl3isTfjRa4xpkSShmoAfjR3bA2MnMZq?=
 =?us-ascii?Q?gOMBgbYhLrwDFUqS5fnMSvq1x1KGycD+IONNhWFqyf5UdOSQqDYufl2m0Lxw?=
 =?us-ascii?Q?dx2W8cMWh8iaXx0wzSILqlaYk+hEgrwuwKKcvft/xVpdmlt+MHK3Qo4tv8pm?=
 =?us-ascii?Q?6SgylJOmTjUEoNmrvs/aEdRixxkV6zQpOaR2kVU10+sbyJDF6cqhv77PJmfl?=
 =?us-ascii?Q?pKu+9r5OEp0tve08vgzM+abXWFZ6pXlcD4d4XIIeuf2wG4Ur8HAyxe/xBlYT?=
 =?us-ascii?Q?4Quhb3kETn1ANmfVBT8PbTxz/rQMwZxFK7LuXU+7wZQzVqkRSt/q3fk8m1Eg?=
 =?us-ascii?Q?dHpG9+mx+x5GuszffOqnc13Ze+2Nu1Y78X8BdBjhbA9NJwwLZVb4jDq7YVMu?=
 =?us-ascii?Q?C0CLKMiC4REBKee280KF1nRukXKtVIVETzvu75jbmM1bPL1MHKSJJp3d/+0x?=
 =?us-ascii?Q?rmoLs83etR8v4uky9JNs6+Hd7vjkdF/Uze11qnmHIfCTYGT4qaL72lN6193v?=
 =?us-ascii?Q?8mmdtKSFzZsLqDlk+sbEB/JJctbrPwHHphBsU4p74kPXHblFEk66YfnI1qkX?=
 =?us-ascii?Q?qGbpZRgOO/HwMZtaD9XBwStAtHNQaFxuDSvJ5xRFtKa8WZbNcNZZARKkjsvv?=
 =?us-ascii?Q?58COsfpXxdrBm1I5sWJMtYj8XGpOWzseU7Fa7oPfvUBPqJSz5sdGjM/0Tu9A?=
 =?us-ascii?Q?UBW2qfB+4XbFPJMdMGU69TPEOGu5Et5NhbzCcpuJZzIz5IOdpSZdLP+kRc7H?=
 =?us-ascii?Q?wwbFB/e7isTh6krjRPsjMrC+d7Myv9yXhoEc9WK105iTjflJOvIQxaHVw3uR?=
 =?us-ascii?Q?smYIhwKwskIRL0PE2nrpV42QduGXbAY8mc2qUKLDJSIooK0CA5BrhlVnXYoq?=
 =?us-ascii?Q?W5dgBKvQCKeGoPh+ax8ntwSUmap6mQjr+4eJeqD29uFnaWcCW+XUKbqH2SiK?=
 =?us-ascii?Q?ZhKVquMBt2OUUAxnURTpf4mALxCi7NJ1r5lv273fFukYqwdGxjSIgw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de51fb9d-cfb1-46e2-1d6a-08da03a446da
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:15:32.6128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmxvaW7GZ6M48z1DJHolRM7HABzOhPNIABCnKEGCl8mYjGStBkbDm13Xiphy9AuHawiUB6Ea7b+Xl8GHm69LUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8934
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the port-based default priority, IEEE 802.1Q-2018 allows the
Application Priority Table to define QoS classes (0 to 7) per IP DSCP
value (0 to 63).

In the absence of an app table entry for a packet with DSCP value X,
QoS classification for that packet falls back to other methods (VLAN PCP
or port-based default). The presence of an app table for DSCP value X
with priority Y makes the hardware classify the packet to QoS class Y.

As opposed to the default-prio where DSA exposes only a "set" in
dsa_switch_ops (because the port-based default is the fallback, it
always exists, either implicitly or explicitly), for DSCP priorities we
expose an "add" and a "del". The addition of a DSCP entry means trusting
that DSCP priority, the deletion means ignoring it.

Drivers that already trust (at least some) DSCP values can describe
their configuration in dsa_switch_ops :: port_get_dscp_prio(), which is
called for each DSCP value from 0 to 63.

Again, there can be more than one dcbnl app table entry for the same
DSCP value, DSA chooses the one with the largest configured priority.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  5 +++
 net/dsa/slave.c   | 86 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1220af73151b..9bfe984fcdbf 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -898,6 +898,11 @@ struct dsa_switch_ops {
 	int	(*port_get_default_prio)(struct dsa_switch *ds, int port);
 	int	(*port_set_default_prio)(struct dsa_switch *ds, int port,
 					 u8 prio);
+	int	(*port_get_dscp_prio)(struct dsa_switch *ds, int port, u8 dscp);
+	int	(*port_add_dscp_prio)(struct dsa_switch *ds, int port, u8 dscp,
+				      u8 prio);
+	int	(*port_del_dscp_prio)(struct dsa_switch *ds, int port, u8 dscp,
+				      u8 prio);
 
 	/*
 	 * Suspend and resume
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 97f5da81fe68..f9cecda791d5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1880,6 +1880,40 @@ dsa_slave_dcbnl_set_default_prio(struct net_device *dev, struct dcb_app *app)
 	return 0;
 }
 
+static int __maybe_unused
+dsa_slave_dcbnl_add_dscp_prio(struct net_device *dev, struct dcb_app *app)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	unsigned long mask, new_prio;
+	int err, port = dp->index;
+	u8 dscp = app->protocol;
+
+	if (!ds->ops->port_add_dscp_prio)
+		return -EOPNOTSUPP;
+
+	if (dscp >= 64) {
+		netdev_err(dev, "DSCP APP entry with protocol value %u is invalid\n",
+			   dscp);
+		return -EINVAL;
+	}
+
+	err = dcb_ieee_setapp(dev, app);
+	if (err)
+		return err;
+
+	mask = dcb_ieee_getapp_mask(dev, app);
+	new_prio = __fls(mask);
+
+	err = ds->ops->port_add_dscp_prio(ds, port, dscp, new_prio);
+	if (err) {
+		dcb_ieee_delapp(dev, app);
+		return err;
+	}
+
+	return 0;
+}
+
 static int __maybe_unused dsa_slave_dcbnl_ieee_setapp(struct net_device *dev,
 						      struct dcb_app *app)
 {
@@ -1892,6 +1926,8 @@ static int __maybe_unused dsa_slave_dcbnl_ieee_setapp(struct net_device *dev,
 			return -EOPNOTSUPP;
 		}
 		break;
+	case IEEE_8021QAZ_APP_SEL_DSCP:
+		return dsa_slave_dcbnl_add_dscp_prio(dev, app);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1924,6 +1960,30 @@ dsa_slave_dcbnl_del_default_prio(struct net_device *dev, struct dcb_app *app)
 	return 0;
 }
 
+static int __maybe_unused
+dsa_slave_dcbnl_del_dscp_prio(struct net_device *dev, struct dcb_app *app)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int err, port = dp->index;
+	u8 dscp = app->protocol;
+
+	if (!ds->ops->port_del_dscp_prio)
+		return -EOPNOTSUPP;
+
+	err = dcb_ieee_delapp(dev, app);
+	if (err)
+		return err;
+
+	err = ds->ops->port_del_dscp_prio(ds, port, dscp, app->priority);
+	if (err) {
+		dcb_ieee_setapp(dev, app);
+		return err;
+	}
+
+	return 0;
+}
+
 static int __maybe_unused dsa_slave_dcbnl_ieee_delapp(struct net_device *dev,
 						      struct dcb_app *app)
 {
@@ -1936,6 +1996,8 @@ static int __maybe_unused dsa_slave_dcbnl_ieee_delapp(struct net_device *dev,
 			return -EOPNOTSUPP;
 		}
 		break;
+	case IEEE_8021QAZ_APP_SEL_DSCP:
+		return dsa_slave_dcbnl_del_dscp_prio(dev, app);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1967,6 +2029,30 @@ static int dsa_slave_dcbnl_init(struct net_device *dev)
 			return err;
 	}
 
+	if (ds->ops->port_get_dscp_prio) {
+		int protocol;
+
+		for (protocol = 0; protocol < 64; protocol++) {
+			struct dcb_app app = {
+				.selector = IEEE_8021QAZ_APP_SEL_DSCP,
+				.protocol = protocol,
+			};
+			int prio;
+
+			prio = ds->ops->port_get_dscp_prio(ds, port, protocol);
+			if (prio == -EOPNOTSUPP)
+				continue;
+			if (prio < 0)
+				return prio;
+
+			app.priority = prio;
+
+			err = dcb_ieee_setapp(dev, &app);
+			if (err)
+				return err;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.25.1

