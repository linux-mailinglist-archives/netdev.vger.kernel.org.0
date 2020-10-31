Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2F12A153F
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgJaK3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:29:38 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:21857
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726708AbgJaK3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 06:29:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhVKWYez6KhmcEq0pFq7FN9r5itUBEennWDln00a7LdE8NeGWStJ379hxG0iNx2UysItG706hjsOKwnAw3f3UBS+7YOhSMHQaV0SJ/1dm2Gtdn9TFu5pvuT3YCqjVDVamslTLL221ND9dmh696DjIe4D2sa9neZ9IouxTns0klQ400zgRD2i1TXou3vZTjYXnSQXwv5YkivVEfrqW4OarbtdksfJunbDxc571Hw8yNTcqDjh6D9Wqw2tI6CcZ5Q97D+dxr3Zm/yIfZo44wqbOnVhnQME9T+oaGPUkdmzRH6yHbF9plvafl+Mg47gCytnvHLOrp2cPPAsOxi5B8cUvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKHNZOYVq3p8t98e3+obLAU+JKFfX/yPZDZyROFTsqc=;
 b=JG4+eGlDZSMd/c6NIF39CGEYrFeeZY9LZlDjNbb5aKcngC5AevZ8wnSQtMB65ER4B3ky8YpBBJCQeI4A8X9RH2r9Yn3+/ZdqK+OnJyaYv8ce8Q7MrXtU1wHU2YHhg5BQAwEZnUe/9RUZ0+5SrOvNJW+PaRNi/ZPop3xBR1Ee+6hTO5fGmJ4KH8QYkO8D3rSrHPUXSCJTwZWtfi2V//qBI4kGKJeZf3AcFJmZvOVDVOTBiGeTPLg9gDYslmDJaJBjYorX/t8OCiBMlrCpU4pxDprTerQKt5N5ooR940JvpZTcRoIPKVghtfb6KlPSYNoVXSRAorGycDHwAERxqAax9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKHNZOYVq3p8t98e3+obLAU+JKFfX/yPZDZyROFTsqc=;
 b=b1KGduYKUH0Gw2oNnYEvV2GBpdvjQC8IVfKwvENv8QI6q6b7/K0Q1Ugnm9Dc5b8GH/TpMI6fKDCzCpUnl6IBgMsYMbjfqE+ayvKJJotEwMAqFvgMgdLlRXSA5QvlAg6z4qhvd4gw0OSuMq1tzrZO0Cc5mTU9lAtdqaMdw66TEXE=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sat, 31 Oct
 2020 10:29:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sat, 31 Oct 2020
 10:29:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: mscc: ocelot: use the pvid of zero when bridged with vlan_filtering=0
Date:   Sat, 31 Oct 2020 12:29:10 +0200
Message-Id: <20201031102916.667619-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201031102916.667619-1-vladimir.oltean@nxp.com>
References: <20201031102916.667619-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR08CA0170.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR08CA0170.eurprd08.prod.outlook.com (2603:10a6:800:d1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 31 Oct 2020 10:29:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a6847a1-e30f-4486-8fcd-08d87d87d854
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB66376101C38832B13D61576EE0120@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /eUF5k7u39ES7PL/O+AsQ3naLk+5FB4UflfTtZrp6GjCVwRBDTCmUIX6qLbW0pFqMuoBQectjaL3Im8w9pcxG0Vcvz+bYbZhKd703YhZrF1AYCg+gppnzs0/8YEgC8MYpy7l/AP//DUUXBZFSB5MsrvQU45qDSet5wC+XV5hmeWBwPBglp14SfLOeRKkerVp+lIUOVkfzyR3PwefbGcSXgh1tStbCFATYgolLMZAHfQqzr+ZvonONWWZRAFrcN6rtLajdL2UevZqYqcwmZgdsNOA8nBs/GoZP5/F3z2DdJoHl6HqtLRRS6wR2W96W+F1YaSwuhNE7zrRH3aiPGMGbuOB22TXzrdm5PZi41dictE+DCWvq24+8cvErCO2l/Cy3Gv61K1cBGX+jGnOrJ6I3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(66556008)(1076003)(316002)(956004)(86362001)(66476007)(8936002)(83380400001)(2906002)(110136005)(66946007)(8676002)(36756003)(6512007)(6666004)(16526019)(186003)(52116002)(6506007)(44832011)(26005)(6486002)(69590400008)(478600001)(2616005)(5660300002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Rlky80xXLqX2ZrYnWU3fDY7mppvocySCxT9M+YtjqO+SpNGLcB/kHJR7AQtVfFKyar09Gbtu08h7uM5raK+Upeg3cyggt8EFZd0XeW3fBh6HXBIkzNoO/Kb0cz8Yx+uIWWBJpOrJcuSmQklnTns7HLe29472iTdN06nt+8Eo/zyjn45ZKQsffbzn2yOWQY9YKCv/jgSgAnS9rMegUXMHT43K0InEnssslaY9FbSO9WwLjAfdQtgdXiZMe06J1TUF3/WIt7UOtkfEq+Wvvn1AJDhVL+gSf3N06KHSzonrgkiOjFqmcDOwr5vd6p+10RKWqykEIzQ8PnUuIQXszmH+g4ZX5XQwnB4SNbUIQGyzPhs/AqOf0ffC/WIHpTwRwfT2dFgmymcNuv85XbqLdDVOGIl9HDU9cAiP/KBuRWNXnjSXz09J3QHqTHRhfXtgoogmB2MUs1gNMtmVXExrinFEQF1neiGXklqQrxxcZbk/7jWJd533H+yqI6RATRbwL19rpEWwxAgZVjVYSX/NYIk7OIuflgOmrWkFY9DosKdmVcCZje8R1uvVSiQkcqFUHVndDmAex8bAVTGp8uqIXsQ1Mx/rr5zf8UMhRRN0UYGp1PdtdyReEC3Vs3IfHwSiOj3rtVmD+pYFDQAg+27TWLXWlA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6847a1-e30f-4486-8fcd-08d87d87d854
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2020 10:29:27.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFgy/KGn26zjyZ27kMHTkU1p8fBh89NsKBj/KB9QDlECV6lBICsG5lSAWPFDqAVfG6RJjPAIu4G9+WTbsekb9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, mscc_ocelot ports configure pvid=0 in standalone mode, and
inherit the pvid from the bridge when one is present.

When the bridge has vlan_filtering=0, the software semantics are that
packets should be received regardless of whether there's a pvid
configured on the ingress port or not. However, ocelot does not observe
those semantics today.

Moreover, changing the PVID is also a problem with vlan_filtering=0.
We are privately remapping the VID of FDB, MDB entries to the port's
PVID when those are VLAN-unaware (i.e. when the VID of these entries
comes to us as 0). But we have no logic of adjusting that remapping when
the user changes the pvid and vlan_filtering is 0. So stale entries
would be left behind, and untagged traffic will stop matching on them.

And even if we were to solve that, there's an even bigger problem. If
swp0 has pvid 1, and swp1 has pvid 2, and both are under a vlan_filtering=0
bridge, they should be able to forward traffic between one another.
However, with ocelot they wouldn't do that.

The simplest way of fixing this is to never configure the pvid based on
what the bridge is asking for, when vlan_filtering is 0. Only if there
was a VLAN that the bridge couldn't mangle, that we could use as pvid....
So, turns out, there's 0 just for that. And for a reason: IEEE
802.1Q-2018, page 247, Table 9-2-Reserved VID values says:

	The null VID. Indicates that the tag header contains only
	priority information; no VID is present in the frame.
	This VID value shall not be configured as a PVID or a member
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	of a VID Set, or configured in any FDB entry, or used in any
	Management operation.

So, aren't we doing exactly what 802.1Q says not to? Well, in a way, but
what we're doing here is just driver-level bookkeeping, all for the
better. The fact that we're using a pvid of 0 is not observable behavior
from the outside world: the network stack does not see the classified
VLAN that the switch uses, in vlan_filtering=0 mode. And we're also more
consistent with the standalone mode now.

And now that we use the pvid of 0 in this mode, there's another advantage:
we don't need to perform any VID remapping for FDB and MDB entries either,
we can just use the VID of 0 that the bridge is passing to us.

The only gotcha is that every time we change the vlan_filtering setting,
we need to reapply the pvid (either to 0, or to the value from the bridge).
A small side-effect visible in the patch is that ocelot_port_set_pvid
needs to be moved above ocelot_port_vlan_filtering, so that it can be
called from there without forward-declarations.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 53 ++++++++++--------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 323dbd30661a..bc5b15d7bce7 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -199,6 +199,22 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 	return 0;
 }
 
+/* Default vlan to clasify for untagged frames (may be zero) */
+static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	ocelot_port->pvid = pvid;
+
+	if (!ocelot_port->vlan_aware)
+		pvid = 0;
+
+	ocelot_rmw_gix(ocelot,
+		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid),
+		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
+		       ANA_PORT_VLAN_CFG, port);
+}
+
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 			       bool vlan_aware, struct switchdev_trans *trans)
 {
@@ -233,25 +249,13 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		       ANA_PORT_VLAN_CFG_VLAN_POP_CNT_M,
 		       ANA_PORT_VLAN_CFG, port);
 
+	ocelot_port_set_pvid(ocelot, port, ocelot_port->pvid);
 	ocelot_port_set_native_vlan(ocelot, port, ocelot_port->vid);
 
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
-/* Default vlan to clasify for untagged frames (may be zero) */
-static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
-{
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
-
-	ocelot_rmw_gix(ocelot,
-		       ANA_PORT_VLAN_CFG_VLAN_VID(pvid),
-		       ANA_PORT_VLAN_CFG_VLAN_VID_M,
-		       ANA_PORT_VLAN_CFG, port);
-
-	ocelot_port->pvid = pvid;
-}
-
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged)
 {
@@ -542,26 +546,11 @@ EXPORT_SYMBOL(ocelot_get_txtstamp);
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int pgid = port;
 
 	if (port == ocelot->npi)
 		pgid = PGID_CPU;
 
-	if (!vid) {
-		if (!ocelot_port->vlan_aware)
-			/* If the bridge is not VLAN aware and no VID was
-			 * provided, set it to pvid to ensure the MAC entry
-			 * matches incoming untagged packets
-			 */
-			vid = ocelot_port->pvid;
-		else
-			/* If the bridge is VLAN aware a VID must be provided as
-			 * otherwise the learnt entry wouldn't match any frame.
-			 */
-			return -EINVAL;
-	}
-
 	return ocelot_mact_learn(ocelot, pgid, addr, vid, ENTRYTYPE_LOCKED);
 }
 EXPORT_SYMBOL(ocelot_fdb_add);
@@ -1048,7 +1037,6 @@ static void ocelot_encode_ports_to_mdb(unsigned char *addr,
 int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
 	struct ocelot_pgid *pgid;
@@ -1057,9 +1045,6 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	if (port == ocelot->npi)
 		port = ocelot->num_phys_ports;
 
-	if (!vid)
-		vid = ocelot_port->pvid;
-
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc) {
 		/* New entry */
@@ -1108,7 +1093,6 @@ EXPORT_SYMBOL(ocelot_port_mdb_add);
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb)
 {
-	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
 	struct ocelot_pgid *pgid;
@@ -1117,9 +1101,6 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 	if (port == ocelot->npi)
 		port = ocelot->num_phys_ports;
 
-	if (!vid)
-		vid = ocelot_port->pvid;
-
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc)
 		return -ENOENT;
-- 
2.25.1

