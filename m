Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9B06E32B6
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjDORGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjDORGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:06:14 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E40530D5;
        Sat, 15 Apr 2023 10:06:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4xnY2W2lac+68Oc+zq+ZN8E8joQ9kdHtFEF9M93Efz4mSow5cLP/KB0JA/nm7ke3WmTdwtcu/Hpu70QsSegbh10xTFG73Hvbtl3E4vMWnhDIRSmIO++1XUKC4r4DEacJQ+5cGINTzojmm3WENjRBoO/g+bmrc0oBCBfMg1LPkM/53aTOgOcVVTYE25BDCTKV/PVumUyC2+YOYkk3XEYfVGfCHUR5ny9nf4LEgiKJZRHMgQ92TUw7tphuHjdDgFJTF+96xLkn06GtS/0ysAzkZTv6Mq6D30+XF6GPMhEVPMGi7JmCLJ6P9ypWo3JTpoofsMeXGvfiUJ8SOWk5XvV6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHYWICrN++t+4NDeVIhoNCgLnsjyZGWOvhLKRK1tvuc=;
 b=DK9hj2XT4o2cknVQj3VDeDnpmjdXdq7Am8T48blHv4BsOkW9z8bxFI4y2vk5z2eJXm0PlxIZb5oXPVGSObUL/k1kLgAo6/8zvtodPDqVM4LLOOLCucnxtbWlz3KTSwfkagDg8NknRYOfgupoPjIR3NNx01teTP7xelP/1rSBdPJtd95o+50m5lHerqzP3WBVVs2OUdPsIx1h5JUXdQT4jyr+qjnIMJzpxwv//bx3bMCBBqVnjTIKBS776RUzf9sVrDm0VRomlia1P+v75zQ7HT8YUZgWLzDUllcoYdXkEcDjFsgs6A37FTn2BPT+AJc7NMyWEW7G9mhG3P1sTXgxHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHYWICrN++t+4NDeVIhoNCgLnsjyZGWOvhLKRK1tvuc=;
 b=bw+nXiTMs94CwZgcSxReRwfi3JZulM+2ksC8pJv0Ig60dTKBaCAAscsw1jGYYiNvXQqECaccwKNoL8WSq9+3etBenC/87lmcL5wf8XQPT+5emkXfW1dbWkfp3EOUULO5NxloxurnjucWGbxehVHKShgGnXOfgQAYG+d2VT8dXUQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:06:06 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:06:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] net: mscc: ocelot: optimize ocelot_mm_irq()
Date:   Sat, 15 Apr 2023 20:05:47 +0300
Message-Id: <20230415170551.3939607-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::6) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 1964630c-6ecf-40f2-9070-08db3dd3b367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O2DxOi4cqodzgocdt+CkfNTRejsYb55gEhnM6MnF+iWU2s24Rkiy2l+COlB1EaXay5xPCgiSvXLMdLLzc4+gaou6OYO2+oTyDsV64dJOteGiIXbT5KYsMZ86m+AK0LENrekI7w3bAflnFT5fN1PSERanP1qrJSmOnk1xK7DP2lue2mFiXgYOiGoXsN3L48h/6Wv+w/a8F9GxXcxuOx4KLLRoMe0+0vJiBsA4oQkMnj/Apw4MfQygnDq93CPa0WpzaQYQTSYqSCWMAhztAbBkOhzDbjDIA+z8TPIlQG97nwi/AR6B00aUGM7VMZZrBpK4mQNdfURn7XBa422rIEjctdogQBfW5s2f2eRDEwtP8ZsTpUSzNFKh4R8Z2KpDFpwCCOaUopsmWWAb7oZS/Qeu1nXExmUUV+UrH7A39fpRa0NWcbALj6+fznZ14Ip/6C8uKTOgAtvKj+O43UEMRuuXIe6lrafvf49vFZTNAEI9HdvEQ3pNiCKGccmjRFunxQQ//Gal9iEbkQ0Z0d/wwz3KXwUl+BYh0isDwZCiweJFCanrEeLnjD64ROMnC1DeTVAC2FkwRCA74tcY6oalRXPknmVLPSzbx3fv4zYpsrEa1l/0LwnNAgFlrm6oeBNKEfEU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(316002)(4326008)(38100700002)(38350700002)(6916009)(66556008)(66946007)(66476007)(5660300002)(44832011)(2616005)(6666004)(52116002)(36756003)(86362001)(6486002)(41300700001)(54906003)(1076003)(186003)(6506007)(26005)(6512007)(2906002)(8676002)(7416002)(8936002)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hTuE0BZgUf6+v3VoA6t5+N87BmE0kh5d8TgYaEPbN+TSrvSi6kyo9Gmqw6Zr?=
 =?us-ascii?Q?2XnQvvE4gt02jhPYRzCpGqEl6DTk6UWkMq6nzFB9QT9e/oP3hTmbI94nVIF9?=
 =?us-ascii?Q?ndRDTqAlIyXg3qnHGbmN/msaAWKQmBWdzRihvoKHOIetyP0DosLl1C2xzS+J?=
 =?us-ascii?Q?f8SG/6EowbE0ujUOp3zZ1Y88+/XYxhYkkAr6UFBwVCFohz8n6J8jzQbuLjrX?=
 =?us-ascii?Q?EDe7yynvD9oH2jqo7OXF4CkAbPF9zZLbTBHHFrKgTJ2YI2lnpe82i8ipvVe7?=
 =?us-ascii?Q?4VDzscxw40+bhar+yBXPtKFZ0mGXwYc7NbAFczbRr8M1MFqPLWHT0j1jue5e?=
 =?us-ascii?Q?KTbhl8yBYKA2qFMIuUU5TrMC/CHHvd4EeE4qCWa4J1/5QVDEOWMA6YntK1p0?=
 =?us-ascii?Q?qTob122intSgLIMhdflHxq1BGOoP0jDqU9nseUTGDX3383bySgVxuRf3WCuD?=
 =?us-ascii?Q?B2YG7KUd023IUd8kILsqki8qfDQtAuVBD14qtDNJCj5Sc8hFIVe04x/M/GIB?=
 =?us-ascii?Q?TK4mEkBKBeDrWoFIJwFATTena5vT/JhsivIjErP0vfX7eSwz4W/xr4E5zYQP?=
 =?us-ascii?Q?Xml04HGZVYRjc69YfbcDm336W3t68pD15QI4w5ujNygMU+qG9msh2ZmkoL3B?=
 =?us-ascii?Q?Jk2KPQ10xVp9Jjli01jCkMzimnqv8PJQ5VgZ/nz2IuPSXk1NFv08qt5dP1W3?=
 =?us-ascii?Q?tRqL93ZtEWFdrM/4UimKbkDjIc/k7xgS8kAHpttsZzjDNLaF6x9POa3ICNhE?=
 =?us-ascii?Q?AM6SXPK0n84/8l0XneH+/ac6fIRencNHsU0kmLOg9CBd70IkwdbVgd//HNVD?=
 =?us-ascii?Q?ZQUazc+uIZHEZ2TDXPAjYYnUTdOCy5k1Szkvkg6nWzV409DoXNORdcLJqKjg?=
 =?us-ascii?Q?SvBmRpdZUV6PSzqKrfu/SIm5x6TF165E+RCSgx6yrUH7Gfr5Ig48b+iqhvB+?=
 =?us-ascii?Q?zBCTFgMgrtHLnaFAcaOe1O9T3KXnnuOkLnpbpb44KXK9ubRYfpgXMGadDw3X?=
 =?us-ascii?Q?N694BSMKTzeQBffax8ZeH1A7q0SApzWWexGWMIQXRwiKAcGuXItlr0RSQ8Y5?=
 =?us-ascii?Q?frpEu0wL3dD18j3n37tWAf2uSUW7f5PgO6rUaXVaTZckP3bfB1Q+bqalFrrd?=
 =?us-ascii?Q?VYt7/Cirz4AylKO9LNDDZM1n5ZEobHOs2RUEFjWLOFdUPOC0VOUE5q8D4pJQ?=
 =?us-ascii?Q?cLwjVcJi/lYHIX0LDNDWqOTCiJzTAAIR+bet2M4o/08aSb1sCgzPbW1uqumQ?=
 =?us-ascii?Q?OlTvBvuU+/dp1y25N+avUWHMTn3L0za7mnfViAKQF+QAnR96Dvz+Qf32wfcx?=
 =?us-ascii?Q?NnLXP3mOSNlIj2BEKU8q6aKkwg25cGDCbT+uNGKBvTibgcBYwv2/u9P7ryrt?=
 =?us-ascii?Q?RpuYKnlwJF64nnRNCTxHQ+zynJ4XwMWiOQoKMdtATcbiFT0OT2K4MQyULtJu?=
 =?us-ascii?Q?2qNEunM59JLKxGPloonX78cgcuUr5UkuA3Jkv6wclBoGQhjABYTsMpkYdsb/?=
 =?us-ascii?Q?hltUsfcf7loX+NpKioKu50+nEp7FR22eMrj5mB+5zAX7LXMLu52wIcrKsztH?=
 =?us-ascii?Q?H/2caX7jlthuBqrqX03glLPffWv6e4h6NY0VOGor52X6kziQXjIcHlBGXivY?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1964630c-6ecf-40f2-9070-08db3dd3b367
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:06:06.2274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EpUNu+osm/wurnvX0BU4653BeH08X+2A1IfuH/xAsLecSmz3UbPFDz+8xqepo9N++sKqy+4fmYV3nd27uDa+kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC Merge IRQ of all ports is shared with the PTP TX timestamp IRQ
of all ports, which means that currently, when a PTP TX timestamp is
generated, felix_irq_handler() also polls for the MAC Merge layer status
of all ports, looking for changes. This makes the kernel do more work,
and under certain circumstances may make ptp4l require a
tx_timestamp_timeout argument higher than before.

Changes to the MAC Merge layer status are only to be expected under
certain conditions - its TX direction needs to be enabled - so we can
check early if that is the case, and omit register access otherwise.

Make ocelot_mm_update_port_status() skip register access if
mm->tx_enabled is unset, and also call it once more, outside IRQ
context, from ocelot_port_set_mm(), when mm->tx_enabled transitions from
true to false, because an IRQ is also expected in that case.

Also, a port may have its MAC Merge layer enabled but it may not have
generated the interrupt. In that case, there's no point in writing to
DEV_MM_STATUS to acknowledge that IRQ. We can reduce the number of
register writes per port with MM enabled by keeping an "ack" variable
which writes the "write-one-to-clear" bits. Those are 3 in number:
PRMPT_ACTIVE_STICKY, UNEXP_RX_PFRM_STICKY and UNEXP_TX_PFRM_STICKY.
The other fields in DEV_MM_STATUS are read-only and it doesn't matter
what is written to them, so writing zero is just fine.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Diff: patch is new.

 drivers/net/ethernet/mscc/ocelot_mm.c | 30 +++++++++++++++++++++++++--
 include/soc/mscc/ocelot.h             |  1 +
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_mm.c b/drivers/net/ethernet/mscc/ocelot_mm.c
index d2df47e6f8f6..ce6429d46814 100644
--- a/drivers/net/ethernet/mscc/ocelot_mm.c
+++ b/drivers/net/ethernet/mscc/ocelot_mm.c
@@ -54,7 +54,10 @@ static void ocelot_mm_update_port_status(struct ocelot *ocelot, int port)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_mm_state *mm = &ocelot->mm[port];
 	enum ethtool_mm_verify_status verify_status;
-	u32 val;
+	u32 val, ack = 0;
+
+	if (!mm->tx_enabled)
+		return;
 
 	val = ocelot_port_readl(ocelot_port, DEV_MM_STATUS);
 
@@ -71,21 +74,28 @@ static void ocelot_mm_update_port_status(struct ocelot *ocelot, int port)
 
 		dev_dbg(ocelot->dev, "Port %d TX preemption %s\n",
 			port, mm->tx_active ? "active" : "inactive");
+
+		ack |= DEV_MM_STAT_MM_STATUS_PRMPT_ACTIVE_STICKY;
 	}
 
 	if (val & DEV_MM_STAT_MM_STATUS_UNEXP_RX_PFRM_STICKY) {
 		dev_err(ocelot->dev,
 			"Unexpected P-frame received on port %d while verification was unsuccessful or not yet verified\n",
 			port);
+
+		ack |= DEV_MM_STAT_MM_STATUS_UNEXP_RX_PFRM_STICKY;
 	}
 
 	if (val & DEV_MM_STAT_MM_STATUS_UNEXP_TX_PFRM_STICKY) {
 		dev_err(ocelot->dev,
 			"Unexpected P-frame requested to be transmitted on port %d while verification was unsuccessful or not yet verified, or MM_TX_ENA=0\n",
 			port);
+
+		ack |= DEV_MM_STAT_MM_STATUS_UNEXP_TX_PFRM_STICKY;
 	}
 
-	ocelot_port_writel(ocelot_port, val, DEV_MM_STATUS);
+	if (ack)
+		ocelot_port_writel(ocelot_port, ack, DEV_MM_STATUS);
 }
 
 void ocelot_mm_irq(struct ocelot *ocelot)
@@ -107,11 +117,14 @@ int ocelot_port_set_mm(struct ocelot *ocelot, int port,
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 mm_enable = 0, verify_disable = 0, add_frag_size;
+	struct ocelot_mm_state *mm;
 	int err;
 
 	if (!ocelot->mm_supported)
 		return -EOPNOTSUPP;
 
+	mm = &ocelot->mm[port];
+
 	err = ethtool_mm_frag_size_min_to_add(cfg->tx_min_frag_size,
 					      &add_frag_size, extack);
 	if (err)
@@ -145,6 +158,19 @@ int ocelot_port_set_mm(struct ocelot *ocelot, int port,
 		       QSYS_PREEMPTION_CFG,
 		       port);
 
+	/* The switch will emit an IRQ when TX is disabled, to notify that it
+	 * has become inactive. We optimize ocelot_mm_update_port_status() to
+	 * not bother processing MM IRQs at all for ports with TX disabled,
+	 * but we need to ACK this IRQ now, while mm->tx_enabled is still set,
+	 * otherwise we get an IRQ storm.
+	 */
+	if (mm->tx_enabled && !cfg->tx_enabled) {
+		ocelot_mm_update_port_status(ocelot, port);
+		WARN_ON(mm->tx_active);
+	}
+
+	mm->tx_enabled = cfg->tx_enabled;
+
 	mutex_unlock(&ocelot->fwd_domain_lock);
 
 	return 0;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9599be6a0a39..ee8d43dc5c06 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -745,6 +745,7 @@ struct ocelot_mirror {
 
 struct ocelot_mm_state {
 	enum ethtool_mm_verify_status verify_status;
+	bool tx_enabled;
 	bool tx_active;
 };
 
-- 
2.34.1

