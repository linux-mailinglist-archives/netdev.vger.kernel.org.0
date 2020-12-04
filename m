Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FBF2CF360
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbgLDRw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:52:27 -0500
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:47621
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726021AbgLDRw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:52:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeWsw2td73Zde+qmZMTXVpDZfDtIuqvybHZTsCwmfvuDKooLMDF9W7UIVE95XNMvbUTdAJ3d2XWf3WBev/McQeciA/bkRUYxEZJmw3LDZA1teN7iywjOj4ns/lKWxOQGz8CQlL1z+qYNmdUza0nfk6dRAevVCjAu2BMWdosC8k3x/iPNVEx7S7jeUjRsUwJSqBhOwBRSW5rcBzEmbyLw3PrmYFpo6Y0PSOCEXbfXjma2sRza04LFSVGW3PaTAh3+C8bvrv6UuN5IXU9P7kNA8VoFhQ2nSMQgttVwODzmjB8Su1OutDITc7CEb/bc/yKGFJwcgLv1NYt/mblPW3nD5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GpEbiycMe6GQ+t1x3l+V8ZBsF9m0svnrhfDucxGsHI=;
 b=R9J08hUcxJ+yefS6xtPLOcz0IbVELgBRY3XOkCybvUfVbpW+5ce7V8IQziE7YbJPWpSghIm9hoJjHxz8xgW9PU5/kllAxQxHwqRZvHmZvG36kYmiX4dAGyoFCAgcZzz+D09qL4dbc1FB5qBiHJlHw4cpZIvIs39SStqGXfZMRv9T0pgFsZ8j8WSAwpgZgug95hNVmupwRg5HDkss6WTcWIef5tTkquwOxwO3iaLXty9UKEf44IVn5kTYk0KhGsKVBE3RF3XgklLoC9DUPJkuNL4gIt0k6cwZBkhVd48VhwWJr7+S1k0hU+dnPEQy/xFx+q8wEQ52Ju6UwEf3tAkQ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GpEbiycMe6GQ+t1x3l+V8ZBsF9m0svnrhfDucxGsHI=;
 b=otIyIaWFcqI3VVkgHNVHchrOEj1UQAtZ3tq1zR7VMlfoYDJznkXhAdgBeY+GP1TTXe2DnbcFP4rhtnIRQsKe0R/aM7GfsHJGWYk+STBxPspdN8Hn1ikkxG+KncTk9VuzfrqVxY7hivM0qZAY36UFy/fcgxVepJQFdwsG0Afp1C4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5855.eurprd04.prod.outlook.com (2603:10a6:803:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Fri, 4 Dec
 2020 17:51:37 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 17:51:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in .ndo_set_rx_mode from process context
Date:   Fri,  4 Dec 2020 19:51:25 +0200
Message-Id: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM3PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:207::23)
 To VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM3PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:207::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 17:51:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bbdc17a7-c495-43c4-2e7e-08d8987d3f42
X-MS-TrafficTypeDiagnostic: VI1PR04MB5855:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB585502DBB4283FCEA371DB35E0F10@VI1PR04MB5855.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y77IzpuWPQKfbQuSp3/2xqFCLtauHrs1OrNjor18KFNeKsknnYZq1+U5vVn+42cWJVCVkQC6mVObKGwHCvWRz16G9l/jOCYoOGbsC6wr6VEvTrkRaJA3f+iLpRakQKQwZOdLi3cZtCM2/t0KcdRq/qQwoAX9kQG9ygjObw6j5AA0wDiUOPZRSv64c2ETnSnICv2aHmPlAKi45E9ozaqyIpRAKDX16K5UbCeEDpYrE5/X1e3mLIFAvMBFL2R0xH2WcBa+Pgxt/tl96K4h30luZBgKOzlRTZutO+V6d8kuqs8hhrbi4mFxwMTPbols/GhvDMKtvJJ4oUsSJ9o646BVSpKkp4bndUSGuf0mhVqF0/Qc5k6Yr7kIZS01blNK9BkW5JUEzyxd5jpULOJueZlXrYa8yM8qLWesQaUDRV0jOSY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(5660300002)(8936002)(54906003)(7416002)(110136005)(6666004)(6512007)(44832011)(52116002)(69590400008)(66946007)(6506007)(26005)(186003)(16526019)(66476007)(86362001)(66556008)(8676002)(36756003)(6486002)(2906002)(83380400001)(4326008)(956004)(316002)(478600001)(1076003)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hmJmCs94jzCVnKT4X/hq9n3dspggl3TbbUUptcIv+UFBZAYP87ntjFdaKQjL?=
 =?us-ascii?Q?cj+4oBdJgrAUydpeP5LTBz6yNO/zjohWSwmQQiW5guHjFTMymbqMUpk9Km3U?=
 =?us-ascii?Q?Sx5pTPCyVJfWgfKeJfyRs+65KTD2AuHvFIPIoFBV21H2eCol+ZDIdf/KLuE1?=
 =?us-ascii?Q?Itx27gXT+HHXY3cFHgx+kRA7plL/LFE/UWkthmnoeYnnRiMZ/8dUOUgi/tMV?=
 =?us-ascii?Q?1P0J/gz/z9qE/Qo3MatSwNdR0u1nJnhAZccps+fY9jeTyCkx7IgO26RtQPw6?=
 =?us-ascii?Q?EYCO6Hx85BPEyKT6CuTjC9m2R9XvUSTnybPgGWjVMk4oSMIvkdWkptWfIEhz?=
 =?us-ascii?Q?EOa20f57nzJneHRpoqryq/1XsGM71w02BSPEZOH9q7Lz/ZHr7tmS7T59ZK9x?=
 =?us-ascii?Q?yk1rNpTWi7SYrVagrFMQX0o+27yGU2/KZm7EkpTtNzdABQM2Cn7TBGtlkCtP?=
 =?us-ascii?Q?QnIKLMkxyD1CLqfpFUntqKdGqK/R1l6XbCQQL5qJ7cfmZVBwO7e0xNIfOI+G?=
 =?us-ascii?Q?ro+usPGaCV5YWtLKsLcJa5KGNsHEJqKznaFxQ+XnXuS8246Tto/X+jUkatok?=
 =?us-ascii?Q?b0o8VYsrjdqkg9QMgpw2Vw+yTLc3w/ak0mJs2u8rTIZE+Ix0D3oMRTIW9Tle?=
 =?us-ascii?Q?S8nTXVscHfVnQbaPxiWWSp1zoRo+cCfBKZVHDKIczsjJDpaYYh9n/punAT/W?=
 =?us-ascii?Q?9Gyt+1hsaLxAfCz2xtRy6yL+fspfoneEiuuDI4b9jrlo5YnHn9/McFJi/TL/?=
 =?us-ascii?Q?sGverHCVNyr1CVtIVBMJ6tJVsHMbZjBy+5AfNJFhLEgDrIiSb4OQL/2PSRKR?=
 =?us-ascii?Q?SHePvk+MRUFX8DyKzqZgmaM9ZTnb4i/AvSNDzlx1qcCnVNTFM9l70TLOVITW?=
 =?us-ascii?Q?qa85DZKbvem0i2nvQC4kCXhMGXc2vC/3pdlgX2I7omNkq6ATRp1VR4yFRnkR?=
 =?us-ascii?Q?FG69CRvJg1ARdvC3Zzc+SmixtPePXJv8oNseA+C5Y6TpRWccDAPVy3F9Myir?=
 =?us-ascii?Q?9imZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbdc17a7-c495-43c4-2e7e-08d8987d3f42
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 17:51:37.5469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOTgY7t5nMbPMRBfERPzYQITHihU8d0s/nVv8b96RhTDZd9dDla1lTyVvOnpOYvtO8bVFGJwoWDx/XXPPiehRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5855
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which has
a very nice ocelot_mact_wait_for_completion at the end. Introduced in
commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be
wall time not attempts"), this function uses readx_poll_timeout which
triggers a lot of lockdep warnings and is also dangerous to use from
atomic context, leading to lockups and panics.

Steen Hegelund added a poll timeout of 100 ms for checking the MAC
table, a duration which is clearly absurd to poll in atomic context.
So we need to defer the MAC table access to process context, which we do
via a dynamically allocated workqueue which contains all there is to
know about the MAC table operation it has to do.

Fixes: 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be wall time not attempts")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
- Added Fixes tag (it won't backport that far, but anyway)
- Using get_device and put_device to avoid racing with unbind

 drivers/net/ethernet/mscc/ocelot_net.c | 83 +++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index c65ae6f75a16..b621772de91e 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -414,13 +414,84 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+enum ocelot_action_type {
+	OCELOT_MACT_LEARN,
+	OCELOT_MACT_FORGET,
+};
+
+struct ocelot_mact_work_ctx {
+	struct work_struct work;
+	struct ocelot *ocelot;
+	enum ocelot_action_type type;
+	union {
+		/* OCELOT_MACT_LEARN */
+		struct {
+			int pgid;
+			enum macaccess_entry_type entry_type;
+			unsigned char addr[ETH_ALEN];
+			u16 vid;
+		} learn;
+		/* OCELOT_MACT_FORGET */
+		struct {
+			unsigned char addr[ETH_ALEN];
+			u16 vid;
+		} forget;
+	};
+};
+
+#define ocelot_work_to_ctx(x) \
+	container_of((x), struct ocelot_mact_work_ctx, work)
+
+static void ocelot_mact_work(struct work_struct *work)
+{
+	struct ocelot_mact_work_ctx *w = ocelot_work_to_ctx(work);
+	struct ocelot *ocelot = w->ocelot;
+
+	switch (w->type) {
+	case OCELOT_MACT_LEARN:
+		ocelot_mact_learn(ocelot, w->learn.pgid, w->learn.addr,
+				  w->learn.vid, w->learn.entry_type);
+		break;
+	case OCELOT_MACT_FORGET:
+		ocelot_mact_forget(ocelot, w->forget.addr, w->forget.vid);
+		break;
+	default:
+		break;
+	};
+
+	put_device(ocelot->dev);
+	kfree(w);
+}
+
+static int ocelot_enqueue_mact_action(struct ocelot *ocelot,
+				      const struct ocelot_mact_work_ctx *ctx)
+{
+	struct ocelot_mact_work_ctx *w = kmalloc(sizeof(*w), GFP_ATOMIC);
+
+	if (!w)
+		return -ENOMEM;
+
+	get_device(ocelot->dev);
+	memcpy(w, ctx, sizeof(*w));
+	w->ocelot = ocelot;
+	INIT_WORK(&w->work, ocelot_mact_work);
+	schedule_work(&w->work);
+
+	return 0;
+}
+
 static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_mact_work_ctx w;
+
+	ether_addr_copy(w.forget.addr, addr);
+	w.forget.vid = ocelot_port->pvid_vlan.vid;
+	w.type = OCELOT_MACT_FORGET;
 
-	return ocelot_mact_forget(ocelot, addr, ocelot_port->pvid_vlan.vid);
+	return ocelot_enqueue_mact_action(ocelot, &w);
 }
 
 static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
@@ -428,9 +499,15 @@ static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_mact_work_ctx w;
+
+	ether_addr_copy(w.learn.addr, addr);
+	w.learn.vid = ocelot_port->pvid_vlan.vid;
+	w.learn.pgid = PGID_CPU;
+	w.learn.entry_type = ENTRYTYPE_LOCKED;
+	w.type = OCELOT_MACT_LEARN;
 
-	return ocelot_mact_learn(ocelot, PGID_CPU, addr,
-				 ocelot_port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
+	return ocelot_enqueue_mact_action(ocelot, &w);
 }
 
 static void ocelot_set_rx_mode(struct net_device *dev)
-- 
2.25.1

