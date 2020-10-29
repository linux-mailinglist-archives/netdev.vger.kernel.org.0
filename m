Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1191929E2A0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391177AbgJ2C20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:28:26 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:10036
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391116AbgJ2C2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 22:28:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEknBv6MbNaES3vrF8s+obtQi8W/53n/ochfnem4s/QWthFi6SqJaHNJAhCRJPEEeK9l0OUBbJ6oA8SYyoFL3L9nvj/ZfI5tDPlxAqA07NjdMS5w/YIWwzP/Gre63/im9hnlqTd1lKknwzIJ6q8LFhCFouelxaK3u9Upb5cLpd2WkBVxSBhL0Y88vgxU9RNom3FFTqi6vzH+z+DF2CYVPK6yVwNUNeOrM7GdbTXyEVoVA9GvRfgfZ+hgCwdwO7avYkOKq3FGLzLC67zLNchAv2U7t31lT2k+OqtVNRpEswjmwZI74VlLazzN0jLmyfGH0evrf4EDqUnFd8NGRLyPCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2Mr2aiI4Q2i7doUveBWEEcHtRY7Ktj2XVOc+aTzDbU=;
 b=aFrfEp+r8wvN0Jhs5NzQYp3jMD5ePur6vi5QaRjhyCcoDtpPdKnOGd3zcA1lIgKvGDeWsV7VRSNIxiLrWQhh+nUtpZMaJoW14Mi3IXoU2rzTred+2HtGH23NOnniZR2MYUywZtG8UtaHWqDBv2knT+U/hoGZROLW02gIPdkmGeI/1vw4fEclB2gYhjIwagQ2pWTk2j2fZt0C2vOaCQZVkbDcDquNfTwIN8U/4/teprAUdC8ecXkubTnTgulEAZ8K0lldGZm2GUVlvVaS0WPRuoJLimBL0FZSKDCDTL64cwlze22OmTmxUppNd7R4kU5HIimST45cSUMX9zLcy6J8iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2Mr2aiI4Q2i7doUveBWEEcHtRY7Ktj2XVOc+aTzDbU=;
 b=Lt+o6bfWJON/nICnOnFPDSa3owOeOSNA2VoKggTwr+xkv7JmvNd7ZoqJa2z0AYMRFJDFuy36kE3+prrfYW1kXWHT25Fe7mjYgM9/a83DCr4X7C+180kjpXHOQhh0Gp0Jc3y+41pQ5v5ATDoeklUntb3GNWQh8uR1zjxWcuahIc0=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 02:28:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 02:28:01 +0000
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
Subject: [PATCH net-next 4/5] net: mscc: ocelot: make entry_type a member of struct ocelot_multicast
Date:   Thu, 29 Oct 2020 04:27:37 +0200
Message-Id: <20201029022738.722794-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 844bb014-1301-4468-45d0-08d87bb2421e
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6942C4128BAF8FE1CEEF0FBDE0140@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7i1ZFG6MIx02milgMLfF6w1JFevUdnjrf8ETxa2jUNs7JOjVBBHC0HZXv2zNNUcCuf8B5ydL4znZ/8vcdGxXlO8ymbG8Ra8JBogHkpOMQxxm72rI0PhG/EZnEUAgumDHZuEUxUHz/LTYLuunsrWYsn1BmHi4RR164HbkjVwTOKYLK7VbR+v+eiql3qhDxL0bZeIv+ByNU6hSDDbICrWWMZXtE7ROgMT5uPK+Q0XB7YwiToHZoxv78oDjHr0/Z/Pwy3P0TNqEJ8tUr2ncUxfMqjjt85zxe45JjTxRPBoMW6VJrgt7tODdjI6LSYcITuypQh3800ue8593peM/6a5xMHC4t9ANCI9xbVdzXON6ynAicVCmgQzeXWKOHFmQgwPZaXgimYT8mtDnSNyACJZSSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(6486002)(110136005)(186003)(5660300002)(44832011)(83380400001)(1076003)(316002)(6666004)(2906002)(86362001)(69590400008)(26005)(8936002)(16526019)(6506007)(2616005)(66556008)(8676002)(66946007)(52116002)(66476007)(36756003)(956004)(6512007)(478600001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HZPYvR+HeI241BMmBkbcTYpuHD7LukMcsQgbFpNWh4obhNrzUhifc+EAoY1lwJJPN/CQS7JPNNIXQxZGbOWLTPiF5xnufMAxU2vAgmdx9H9Ce4ycjF7ltbtB3aldVeswrfZgmx8hY4NAjEQdzDEYAffCjnnmP8Wp2u8DRk4pZI3/pUhEiLaB78TZKffDRF9BXQCLzRGCh5LTWb/3mkEzp+p74N5s7TNy2TC9/99ks0mSI1QyNwxCDRmX6Du30D0hO4B4nS+rhJzc/pGN/fgBuDepS4eB5w0BcqFnNv/f/ADAPMCNIo1+/qiC4Zzgl9HkMACKAUmNMIBa18O+mAj8i5b6AVW9mvyr1acy+zX01OiFv1hwqldvRwZHh82YuEX87rwLs3GGwBPNw0A0gGJexfHxXEHl44j+/izlPMskgJBafdPEyuDFFkTcMr7WzHvbgbvi652yKT1u2VKk6OdSAVcVBtBhF1huk+nljSRGYxrBAKwOd4eblOKeOK3td0c7scuTX97V7H5FPlHYBozsEYclsZ+SNgFKtktIv1dC/8HMzlwkno/zhi2PAwOeOfmL0F45towaAsqPpipDDILJZdDCE3i3QLldssqm70n5OGIS+r9Q2EEl0qb0FMFsg5HqRlz8S3T+oOVd7PTrbXAUeg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 844bb014-1301-4468-45d0-08d87bb2421e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 02:28:01.8279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A29SqE5fX2IoeuEq5CkDqf4p+6RReOdpOkw0d96A4AWN5CkR2j71Hylbm47COa/Eg3LQzjAmLT9mF8gG4fpC1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This saves a re-classification of the MDB address on deletion.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 51 +++++++++++++++---------------
 drivers/net/ethernet/mscc/ocelot.h | 17 +++++-----
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ea49d715c9d0..713ab6ec8c8d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -962,7 +962,7 @@ static enum macaccess_entry_type ocelot_classify_mdb(const unsigned char *addr)
 }
 
 static int ocelot_mdb_get_pgid(struct ocelot *ocelot,
-			       enum macaccess_entry_type entry_type)
+			       const struct ocelot_multicast *mc)
 {
 	int pgid;
 
@@ -971,8 +971,8 @@ static int ocelot_mdb_get_pgid(struct ocelot *ocelot,
 	 * destination mask table (PGID), the destination set is programmed as
 	 * part of the entry MAC address.", and the DEST_IDX is set to 0.
 	 */
-	if (entry_type == ENTRYTYPE_MACv4 ||
-	    entry_type == ENTRYTYPE_MACv6)
+	if (mc->entry_type == ENTRYTYPE_MACv4 ||
+	    mc->entry_type == ENTRYTYPE_MACv6)
 		return 0;
 
 	for_each_nonreserved_multicast_dest_pgid(ocelot, pgid) {
@@ -994,16 +994,15 @@ static int ocelot_mdb_get_pgid(struct ocelot *ocelot,
 }
 
 static void ocelot_encode_ports_to_mdb(unsigned char *addr,
-				       struct ocelot_multicast *mc,
-				       enum macaccess_entry_type entry_type)
+				       struct ocelot_multicast *mc)
 {
 	ether_addr_copy(addr, mc->addr);
 
-	if (entry_type == ENTRYTYPE_MACv4) {
+	if (mc->entry_type == ENTRYTYPE_MACv4) {
 		addr[0] = 0;
 		addr[1] = mc->ports >> 8;
 		addr[2] = mc->ports & 0xff;
-	} else if (entry_type == ENTRYTYPE_MACv6) {
+	} else if (mc->entry_type == ENTRYTYPE_MACv6) {
 		addr[0] = mc->ports >> 8;
 		addr[1] = mc->ports & 0xff;
 	}
@@ -1013,7 +1012,6 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	enum macaccess_entry_type entry_type;
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
 	u16 vid = mdb->vid;
@@ -1024,12 +1022,20 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	if (!vid)
 		vid = ocelot_port->pvid;
 
-	entry_type = ocelot_classify_mdb(mdb->addr);
-
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc) {
 		/* New entry */
-		int pgid = ocelot_mdb_get_pgid(ocelot, entry_type);
+		int pgid;
+
+		mc = devm_kzalloc(ocelot->dev, sizeof(*mc), GFP_KERNEL);
+		if (!mc)
+			return -ENOMEM;
+
+		mc->entry_type = ocelot_classify_mdb(mdb->addr);
+		ether_addr_copy(mc->addr, mdb->addr);
+		mc->vid = vid;
+
+		pgid = ocelot_mdb_get_pgid(ocelot, mc);
 
 		if (pgid < 0) {
 			dev_err(ocelot->dev,
@@ -1038,24 +1044,19 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 			return -ENOSPC;
 		}
 
-		mc = devm_kzalloc(ocelot->dev, sizeof(*mc), GFP_KERNEL);
-		if (!mc)
-			return -ENOMEM;
-
-		ether_addr_copy(mc->addr, mdb->addr);
-		mc->vid = vid;
 		mc->pgid = pgid;
 
 		list_add_tail(&mc->list, &ocelot->multicast);
 	} else {
-		ocelot_encode_ports_to_mdb(addr, mc, entry_type);
+		ocelot_encode_ports_to_mdb(addr, mc);
 		ocelot_mact_forget(ocelot, addr, vid);
 	}
 
 	mc->ports |= BIT(port);
-	ocelot_encode_ports_to_mdb(addr, mc, entry_type);
+	ocelot_encode_ports_to_mdb(addr, mc);
 
-	return ocelot_mact_learn(ocelot, mc->pgid, addr, vid, entry_type);
+	return ocelot_mact_learn(ocelot, mc->pgid, addr, vid,
+				 mc->entry_type);
 }
 EXPORT_SYMBOL(ocelot_port_mdb_add);
 
@@ -1063,7 +1064,6 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	enum macaccess_entry_type entry_type;
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
 	u16 vid = mdb->vid;
@@ -1078,9 +1078,7 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 	if (!mc)
 		return -ENOENT;
 
-	entry_type = ocelot_classify_mdb(mdb->addr);
-
-	ocelot_encode_ports_to_mdb(addr, mc, entry_type);
+	ocelot_encode_ports_to_mdb(addr, mc);
 	ocelot_mact_forget(ocelot, addr, vid);
 
 	mc->ports &= ~BIT(port);
@@ -1090,9 +1088,10 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 		return 0;
 	}
 
-	ocelot_encode_ports_to_mdb(addr, mc, entry_type);
+	ocelot_encode_ports_to_mdb(addr, mc);
 
-	return ocelot_mact_learn(ocelot, mc->pgid, addr, vid, entry_type);
+	return ocelot_mact_learn(ocelot, mc->pgid, addr, vid,
+				 mc->entry_type);
 }
 EXPORT_SYMBOL(ocelot_port_mdb_del);
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index abb407dff93c..7f8b34c49971 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -41,14 +41,6 @@ struct frame_info {
 	u32 timestamp;	/* rew_val */
 };
 
-struct ocelot_multicast {
-	struct list_head list;
-	unsigned char addr[ETH_ALEN];
-	u16 vid;
-	u16 ports;
-	int pgid;
-};
-
 struct ocelot_port_tc {
 	bool block_shared;
 	unsigned long offload_cnt;
@@ -87,6 +79,15 @@ enum macaccess_entry_type {
 	ENTRYTYPE_MACv6,
 };
 
+struct ocelot_multicast {
+	struct list_head list;
+	enum macaccess_entry_type entry_type;
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	u16 ports;
+	int pgid;
+};
+
 int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 			    bool is_static, void *data);
 int ocelot_mact_learn(struct ocelot *ocelot, int port,
-- 
2.25.1

