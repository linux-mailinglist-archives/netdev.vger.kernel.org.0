Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B29829E2A2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391186AbgJ2C23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:28:29 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:10036
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391171AbgJ2C21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 22:28:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRzYiUGYP5M3dOK94007zUZVGzCR9vnfHjhR3Dvr7bVqlTR0+GbxtpQOq5YtAm1vHN7ORvTA6mTgR/BIjYJRrLK/j2kT+YqgvJAcab0YcwP2mzzXN0LFHYB1dgXnOIRr8U3lJVFDoSv6xwYDeivmvA9aF7BvUhE97RRc9N3sTIgkstoXYlvschJ2nZbF2Ws8Ob834JRxvoN1PtrJWWE+tJKc1CHq3Q2lNBLPJdXbt6oL/Fagc24pNLYSqxcgnmi6L4ysB/hGQWB3retJpfiRyaNIKF5rXfidlVzCqIvCH9cdmlA5/Ml278179dtG322D2gJMxmYeHBs20k37Hkxtjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YG/JVuBvuhSdmgC07ZidrlXbw0Ov7rxgyIZfES8bmFQ=;
 b=U5z6EgygxR5C3ZvUG5scsw6bAkYvOHcje5GvsDBbfaL0TTrc3mCz1vDu+Wn3SJb2lKA9s4Wn8E2K9J0BiUWm0sT8PONDQS4qNdaX26CYVFwuCwKdIx3HaacClRKc3fj/Mj87FJ/GbazAowgrZk7OFoq7ZJLTS9NpG1Av6PiI1JPMEx2GL8Oy+rv/Bpnb2EIbnzIpsHYyR6D1mYZY0I7U9GIlp3iTNSyhMrD8fq1CDV7eUMYWlClVOGIooWIMWbCz32QXazmyhEnG5wm/Vs63PlzITiJu6LlQnGsB8zjYvvc/sIBGq0Mgvc2epoVXX0rWepDA5D1PtZLwMrDgykQCdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YG/JVuBvuhSdmgC07ZidrlXbw0Ov7rxgyIZfES8bmFQ=;
 b=CbSPinVkUTaIu4vC6OONPIfJO8hFNTxIiFkGpxZw2OOlHYNwRTvUkGlg6wTExVhuliBlO6aiDrKYdfs/UDszEzPC+axVr0Z2BJZfylFIjFD1p2b0USA456yyjrZrhrYbYtZISQ7h2CuA01fkbHoXa6551BcFvnqfqpBaNAOZ1BE=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 02:28:02 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 02:28:02 +0000
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
Subject: [PATCH net-next 5/5] net: mscc: ocelot: support L2 multicast entries
Date:   Thu, 29 Oct 2020 04:27:38 +0200
Message-Id: <20201029022738.722794-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201029022738.722794-1-vladimir.oltean@nxp.com>
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0101CA0052.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0101CA0052.eurprd01.prod.exchangelabs.com (2603:10a6:800:1f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 29 Oct 2020 02:28:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc7a6cf5-3a6c-4967-7816-08d87bb24279
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6942864244D52F172834E61FE0140@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vynAbtZMavgu2AgH8DoV4pzv9qXai1aga7j2Sbdix2t3LLS7ix6pGN9kKEM+u7LNCXu7aJ25e6LKN7vVMgLURwWEmj9eFcVSJ8Q0pqJtWeVGl8lAz1DpWYP3GdEp7XPPdX2XRZZCN7fGOntVm+tu+2I+BxXzZhQccgmDtqeRc5tbKm/cgVBJmYm7Rkm761CALzmQ2R/4DyIxB4r2UFlQqvVnDwOtSP7Iau5FkhqKUywsY6ZKAjz4huygMEuprgbr6FUbmZLzXgm6w40Xs1r6E6c6MfY3iB6l62TC3yGDTFEn4EVoeOrhyc8RI4okVLLgoOhS3R66xUbh1iJnB9I+zi4mz+rjo7l1IQZzsVY8knOQqsb+OyGRgfyMb6hklhdtwYZU+9WsnD1CxOSCywjfyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(6486002)(110136005)(186003)(5660300002)(44832011)(83380400001)(1076003)(316002)(6666004)(2906002)(86362001)(69590400008)(26005)(8936002)(16526019)(6506007)(2616005)(66556008)(8676002)(66946007)(52116002)(66476007)(36756003)(956004)(6512007)(478600001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tfMaq9Itv5NEUV6ALF9NhudXfHiBq1QI36aRixuY7Sj9TVhctOVV4eNEljBPCqwD+rzcsYhNyzZACNiw8+nviRtLokbTIgGipdZMvZbR3vb8t72FwNf+qPaocIx+rnqghpZAA14fSsxUtw5Esg45dOl3f+tJCAJin5XL67mCjwlPfIh2huSJh8r3wr+CCcSFJcP8iDubiRF0+DNKAZI5wdfQ7hY++CbVmYrZYSWweaS/IcleOcs+44TTlwrwqya/JWLYoMBKJBMR0LD3zTIzSA/8Blj9Ic70iKwXUS8KeARefcowAUAZi1kWGziQHKdGA84NvsTDVIhljEO4KsV00yIWcDN2V8mEITKLxkDU9cv5uFdKYwZlM+9mhmSJ7th+IO1k+R4Xto5ZPst8hPx43Y4WoNw5PPeCfwxTbnxHiGBPlIXYMceFcKK8gxxFmM2RaBzO5Gp9diHJCESXScwdkYfOGY6Gp9bpAQYStiw1GU+fGtnCDuyoe37QfSCwSoEpfUEsFv9U7RFc7WCYLoHsCGS4ysyzqo+0rgpJ4SmZZruxw1TwlrLzRjNEtu0PCEml5GdCtwDxLp44i35pBXowgBlXgE+WxWsDbEeGAVQmDXo2SzJRq0aO0quMwL7qSL7JltyVdlEw5AcuALrOrDGl+g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7a6cf5-3a6c-4967-7816-08d87bb24279
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 02:28:02.4326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VfpxK3aQOkXCfPvAaqlcVkeVukCbf9vP+gs/j3djwCBJn40Iij7V52ps8Y9lZfrj+QkBVKnajgHF4kSO6qcuig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is one main difference in mscc_ocelot between IP multicast and L2
multicast. With IP multicast, destination ports are encoded into the
upper bytes of the multicast MAC address. Example: to deliver the
address 01:00:5E:11:22:33 to ports 3, 8, and 9, one would need to
program the address of 00:03:08:11:22:33 into hardware. Whereas for L2
multicast, the MAC table entry points to a Port Group ID (PGID), and
that PGID contains the port mask that the packet will be forwarded to.
As to why it is this way, no clue. My guess is that not all port
combinations can be supported simultaneously with the limited number of
PGIDs, and this was somehow an issue for IP multicast but not for L2
multicast. Anyway.

Prior to this change, the raw L2 multicast code was bogus, due to the
fact that there wasn't really any way to test it using the bridge code.
There were 2 issues:
- A multicast PGID was allocated for each MDB entry, but it wasn't in
  fact programmed to hardware. It was dummy.
- In fact we don't want to reserve a multicast PGID for every single MDB
  entry. That would be odd because we can only have ~60 PGIDs, but
  thousands of MDB entries. So instead, we want to reserve a multicast
  PGID for every single port combination for multicast traffic. And
  since we can have 2 (or more) MDB entries delivered to the same port
  group (and therefore PGID), we need to reference-count the PGIDs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 109 ++++++++++++++++++++++-------
 drivers/net/ethernet/mscc/ocelot.h |  16 ++++-
 include/soc/mscc/ocelot.h          |   1 +
 3 files changed, 100 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 713ab6ec8c8d..323dbd30661a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -961,10 +961,37 @@ static enum macaccess_entry_type ocelot_classify_mdb(const unsigned char *addr)
 	return ENTRYTYPE_LOCKED;
 }
 
-static int ocelot_mdb_get_pgid(struct ocelot *ocelot,
-			       const struct ocelot_multicast *mc)
+static struct ocelot_pgid *ocelot_pgid_alloc(struct ocelot *ocelot, int index,
+					     unsigned long ports)
 {
-	int pgid;
+	struct ocelot_pgid *pgid;
+
+	pgid = kzalloc(sizeof(*pgid), GFP_KERNEL);
+	if (!pgid)
+		return ERR_PTR(-ENOMEM);
+
+	pgid->ports = ports;
+	pgid->index = index;
+	refcount_set(&pgid->refcount, 1);
+	list_add_tail(&pgid->list, &ocelot->pgids);
+
+	return pgid;
+}
+
+static void ocelot_pgid_free(struct ocelot *ocelot, struct ocelot_pgid *pgid)
+{
+	if (!refcount_dec_and_test(&pgid->refcount))
+		return;
+
+	list_del(&pgid->list);
+	kfree(pgid);
+}
+
+static struct ocelot_pgid *ocelot_mdb_get_pgid(struct ocelot *ocelot,
+					       const struct ocelot_multicast *mc)
+{
+	struct ocelot_pgid *pgid;
+	int index;
 
 	/* According to VSC7514 datasheet 3.9.1.5 IPv4 Multicast Entries and
 	 * 3.9.1.6 IPv6 Multicast Entries, "Instead of a lookup in the
@@ -973,24 +1000,34 @@ static int ocelot_mdb_get_pgid(struct ocelot *ocelot,
 	 */
 	if (mc->entry_type == ENTRYTYPE_MACv4 ||
 	    mc->entry_type == ENTRYTYPE_MACv6)
-		return 0;
+		return ocelot_pgid_alloc(ocelot, 0, mc->ports);
+
+	list_for_each_entry(pgid, &ocelot->pgids, list) {
+		/* When searching for a nonreserved multicast PGID, ignore the
+		 * dummy PGID of zero that we have for MACv4/MACv6 entries
+		 */
+		if (pgid->index && pgid->ports == mc->ports) {
+			refcount_inc(&pgid->refcount);
+			return pgid;
+		}
+	}
 
-	for_each_nonreserved_multicast_dest_pgid(ocelot, pgid) {
-		struct ocelot_multicast *mc;
+	/* Search for a free index in the nonreserved multicast PGID area */
+	for_each_nonreserved_multicast_dest_pgid(ocelot, index) {
 		bool used = false;
 
-		list_for_each_entry(mc, &ocelot->multicast, list) {
-			if (mc->pgid == pgid) {
+		list_for_each_entry(pgid, &ocelot->pgids, list) {
+			if (pgid->index == index) {
 				used = true;
 				break;
 			}
 		}
 
 		if (!used)
-			return pgid;
+			return ocelot_pgid_alloc(ocelot, index, mc->ports);
 	}
 
-	return -1;
+	return ERR_PTR(-ENOSPC);
 }
 
 static void ocelot_encode_ports_to_mdb(unsigned char *addr,
@@ -1014,6 +1051,7 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
+	struct ocelot_pgid *pgid;
 	u16 vid = mdb->vid;
 
 	if (port == ocelot->npi)
@@ -1025,8 +1063,6 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc) {
 		/* New entry */
-		int pgid;
-
 		mc = devm_kzalloc(ocelot->dev, sizeof(*mc), GFP_KERNEL);
 		if (!mc)
 			return -ENOMEM;
@@ -1035,27 +1071,36 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 		ether_addr_copy(mc->addr, mdb->addr);
 		mc->vid = vid;
 
-		pgid = ocelot_mdb_get_pgid(ocelot, mc);
-
-		if (pgid < 0) {
-			dev_err(ocelot->dev,
-				"No more PGIDs available for mdb %pM vid %d\n",
-				mdb->addr, vid);
-			return -ENOSPC;
-		}
-
-		mc->pgid = pgid;
-
 		list_add_tail(&mc->list, &ocelot->multicast);
 	} else {
+		/* Existing entry. Clean up the current port mask from
+		 * hardware now, because we'll be modifying it.
+		 */
+		ocelot_pgid_free(ocelot, mc->pgid);
 		ocelot_encode_ports_to_mdb(addr, mc);
 		ocelot_mact_forget(ocelot, addr, vid);
 	}
 
 	mc->ports |= BIT(port);
+
+	pgid = ocelot_mdb_get_pgid(ocelot, mc);
+	if (IS_ERR(pgid)) {
+		dev_err(ocelot->dev,
+			"Cannot allocate PGID for mdb %pM vid %d\n",
+			mc->addr, mc->vid);
+		devm_kfree(ocelot->dev, mc);
+		return PTR_ERR(pgid);
+	}
+	mc->pgid = pgid;
+
 	ocelot_encode_ports_to_mdb(addr, mc);
 
-	return ocelot_mact_learn(ocelot, mc->pgid, addr, vid,
+	if (mc->entry_type != ENTRYTYPE_MACv4 &&
+	    mc->entry_type != ENTRYTYPE_MACv6)
+		ocelot_write_rix(ocelot, pgid->ports, ANA_PGID_PGID,
+				 pgid->index);
+
+	return ocelot_mact_learn(ocelot, pgid->index, addr, vid,
 				 mc->entry_type);
 }
 EXPORT_SYMBOL(ocelot_port_mdb_add);
@@ -1066,6 +1111,7 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
+	struct ocelot_pgid *pgid;
 	u16 vid = mdb->vid;
 
 	if (port == ocelot->npi)
@@ -1081,6 +1127,7 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 	ocelot_encode_ports_to_mdb(addr, mc);
 	ocelot_mact_forget(ocelot, addr, vid);
 
+	ocelot_pgid_free(ocelot, mc->pgid);
 	mc->ports &= ~BIT(port);
 	if (!mc->ports) {
 		list_del(&mc->list);
@@ -1088,9 +1135,20 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 		return 0;
 	}
 
+	/* We have a PGID with fewer ports now */
+	pgid = ocelot_mdb_get_pgid(ocelot, mc);
+	if (IS_ERR(pgid))
+		return PTR_ERR(pgid);
+	mc->pgid = pgid;
+
 	ocelot_encode_ports_to_mdb(addr, mc);
 
-	return ocelot_mact_learn(ocelot, mc->pgid, addr, vid,
+	if (mc->entry_type != ENTRYTYPE_MACv4 &&
+	    mc->entry_type != ENTRYTYPE_MACv6)
+		ocelot_write_rix(ocelot, pgid->ports, ANA_PGID_PGID,
+				 pgid->index);
+
+	return ocelot_mact_learn(ocelot, pgid->index, addr, vid,
 				 mc->entry_type);
 }
 EXPORT_SYMBOL(ocelot_port_mdb_del);
@@ -1449,6 +1507,7 @@ int ocelot_init(struct ocelot *ocelot)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&ocelot->multicast);
+	INIT_LIST_HEAD(&ocelot->pgids);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
 	ocelot_vcap_init(ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 7f8b34c49971..291d39d49c4e 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -79,13 +79,27 @@ enum macaccess_entry_type {
 	ENTRYTYPE_MACv6,
 };
 
+/* A (PGID) port mask structure, encoding the 2^ocelot->num_phys_ports
+ * possibilities of egress port masks for L2 multicast traffic.
+ * For a switch with 9 user ports, there are 512 possible port masks, but the
+ * hardware only has 46 individual PGIDs that it can forward multicast traffic
+ * to. So we need a structure that maps the limited PGID indices to the port
+ * destinations requested by the user for L2 multicast.
+ */
+struct ocelot_pgid {
+	unsigned long ports;
+	int index;
+	refcount_t refcount;
+	struct list_head list;
+};
+
 struct ocelot_multicast {
 	struct list_head list;
 	enum macaccess_entry_type entry_type;
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	u16 ports;
-	int pgid;
+	struct ocelot_pgid *pgid;
 };
 
 int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1e9db9577441..cc126d1796be 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -632,6 +632,7 @@ struct ocelot {
 	u32				*lags;
 
 	struct list_head		multicast;
+	struct list_head		pgids;
 
 	struct list_head		dummy_rules;
 	struct ocelot_vcap_block	block[3];
-- 
2.25.1

