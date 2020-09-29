Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E97F27C211
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgI2KLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:33 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:43453
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728274AbgI2KL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRZt0egHCZg3kjcOPCvuQNRCViwheBokXxdHI029GZloJPIq+WDr4ouQeihHCdJQhbdAok+977S1J8DAyQGC3jhS3EcMRjruDdbTdgrWpBuxOPnKA8hNgr46/2ngpvXUfTeODZoWZvxg48FJxI5cdR2o4oM4RHqzRKqq6G8q0tshwungI3tPCW6KGiedW2a4gNoE/tsIYsPr6MrC06RN3+/U+m8U2lb34d3WIzVuYAE5YG4M0qmAVRQmB+gGS83vacRILElQgYKQtqgSAwvGE/rf4UmcqVKOWuRf7mw+qAPu4sIyVyRX6Nej1oYona+fV54aWqebVoElz0BM/fYszQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JirYPLroYe+Ylm0htk4T0aX66liBQ4BiL7b49r3AdE=;
 b=YD7ToGimxpTHVkoXsHCTI3QIhNJ8WC5E2iH/uNOmUIRCVeDjCuEQ1eYvr0tSnM5tMEA4dPf08K2XcenhkMJmzwsNh5KJLBhKgNEU+fmAbsXHwOlWjp5cbTl8+Ccaxc9IWqXyW8bS/Q/sUSs5Q8PCJDWxBnaxtVxWFjGZHRCFHIFw/yVf9FVp50ShhFU6staVLzoIi/yIAilaEp+LA5+DPX462kR7vRpuuh4N69adXb86ceLs8qor8VBmGT6NVrf6Cpttybtlhs42G1qYC9vdcbKWRD2GXdpPzTgm4SGC3L3X2dIfEe0wsCgeCaI2VpS76F4y9MNV1vEiE2fJUYVvig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JirYPLroYe+Ylm0htk4T0aX66liBQ4BiL7b49r3AdE=;
 b=VXKbu3nWYJL/1pC6QkYy2uZecJgnogK2Ox3lLy3/GQYGbpe1dws+bpo+45BkmXquL/BTLokfzPXR+RF9vkcdkM1Mefgfx/UbyzzsFHkpEP7UvPY5E5IpETy69w9ZyHmm9jopn+i3Av5XvALB1548EOr1rujsaxS4y7OQqdbU0ZU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:44 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 12/21] net: mscc: ocelot: add a new ocelot_vcap_block_find_filter_by_id function
Date:   Tue, 29 Sep 2020 13:10:07 +0300
Message-Id: <20200929101016.3743530-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c12ebc8b-4244-43f6-e47d-08d8645fed57
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB52951EBB073627FCA2495729E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wdLN+aD1EYQ/tky5PqWhqQCWh6i5EtewXMujC9Ki6Zu+4I40FVNPQ2B7KMRBNg+yccYxMU4A9v9Xfuo7L6bC9mQrbIGByQziQQYHoiSxp9vEQ2ioq5oHLePlmK4VIdPZ+9b7tbhmNHptZg5NMp2qWUGTpnl3keKT7EX2VYvHua8vtD4/9FjLWDpg0V/mjTsc9Mi7YBBrBpVJzyCeQhh87fpIF82tyGvukluAZIpHyMx33UBKnlzYZO9QRupETo9nXL2GYNT8vc1xc5c2IepKwlBTTMMBrOd+kq7STO48ITDmGBP7gJsbOIqmoCwTpubTTxILn4GWLklmp1hqUd92DeEVIOJkXYIpP81enO9Bk38w7qw/GINdHJ3Q6SKeCiQH8cvNorDxORnRhh6D4INVxo9ofE9cTnwMPRTF8aAEzNzE2zHyiEd5IweM8QKXv83s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ikT+bRNv6/AFmL08YVl4n3ywZYk449iLAfMR+bXFYLROBCtTZtNEhKMQevBvW0LbdalLV7Rkac4kkX3pQx3TLHDpYOUP2BgeGAE62+4MRGgzlVbK/9sFzohGKtSGrx31G7Ib0dzP486t/yKuk6sWM1BKyLUMHAqhSlAxDMtSELAqHxxG/daSBMA056IadXl7gG6wmF1XhyqpksZuZ2UdAZv0rXuiU+GxDbt8sR5lkvG3VdBuhgaDsB0GvQdmfLyZf2C0qz6tCCiFYnRcAAS4HCHsCbeshyqpLq0G+++tNccnJmpW/pJjdLrPcOejzgoetagWL3HHpD0smkqJcJN5wctAmORiurrUVSMYYQMAD+EDUFfbu46Yq20R6F48y40oFV0dBLrruQcFmKr4BtPTAhu7cSP5eqvZgsJP3D/2Z1G0FKKpk5u0WvDk2ZML/+IGOpMnvV6qJYactQq4Va48gfjfZEpVYYGOXNyQJUCnHDpmRRg6mkxOx5Y7V/8XMncrdnutoN7sPR1dfZfMVnlcqBAe04JngxZx+vDlggBqV6MpHpj5g5HS5ah5tA5AWeZInc1u8vMcI7JuNgGeSQCmBJ6eRhmIxm1vtSIPFx6n4w7j6snKKNb61vKY6CMOJ1HpUD6kY0OPIXOd3ifbCU6K8g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c12ebc8b-4244-43f6-e47d-08d8645fed57
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:44.3014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQqfD6TUSeqY436TS/FI7iKstnXakqiBbueBO1Yo455RhmcQuU0b9lIoRoSX9a6P2sX5FothcWshz5DZjZahYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And rename the existing find to ocelot_vcap_block_find_filter_by_index.
The index is the position in the TCAM, and the id is the flow cookie
given by tc.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 26 ++++++++++++++++++-------
 drivers/net/ethernet/mscc/ocelot_vcap.h |  2 ++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 67fb516e343b..6c43c1de1d54 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -731,8 +731,8 @@ static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
 }
 
 static struct ocelot_vcap_filter*
-ocelot_vcap_block_find_filter(struct ocelot_vcap_block *block,
-			      int index)
+ocelot_vcap_block_find_filter_by_index(struct ocelot_vcap_block *block,
+				       int index)
 {
 	struct ocelot_vcap_filter *tmp;
 	int i = 0;
@@ -746,6 +746,18 @@ ocelot_vcap_block_find_filter(struct ocelot_vcap_block *block,
 	return NULL;
 }
 
+struct ocelot_vcap_filter *
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id)
+{
+	struct ocelot_vcap_filter *filter;
+
+	list_for_each_entry(filter, &block->rules, list)
+		if (filter->id == id)
+			return filter;
+
+	return NULL;
+}
+
 /* If @on=false, then SNAP, ARP, IP and OAM frames will not match on keys based
  * on destination and source MAC addresses, but only on higher-level protocol
  * information. The only frame types to match on keys containing MAC addresses
@@ -827,7 +839,7 @@ ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 	if (ocelot_vcap_is_problematic_mac_etype(filter)) {
 		/* Search for any non-MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
-			tmp = ocelot_vcap_block_find_filter(block, i);
+			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
 			    ocelot_vcap_is_problematic_non_mac_etype(tmp))
 				return false;
@@ -839,7 +851,7 @@ ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 	} else if (ocelot_vcap_is_problematic_non_mac_etype(filter)) {
 		/* Search for any MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
-			tmp = ocelot_vcap_block_find_filter(block, i);
+			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
 			    ocelot_vcap_is_problematic_mac_etype(tmp))
 				return false;
@@ -878,7 +890,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 	for (i = block->count - 1; i > index; i--) {
 		struct ocelot_vcap_filter *tmp;
 
-		tmp = ocelot_vcap_block_find_filter(block, i);
+		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 		is2_entry_set(ocelot, i, tmp);
 	}
 
@@ -930,7 +942,7 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 	for (i = index; i < block->count; i++) {
 		struct ocelot_vcap_filter *tmp;
 
-		tmp = ocelot_vcap_block_find_filter(block, i);
+		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 		is2_entry_set(ocelot, i, tmp);
 	}
 
@@ -954,7 +966,7 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 	vcap_entry_get(ocelot, filter, index);
 
 	/* After we get the result we need to clear the counters */
-	tmp = ocelot_vcap_block_find_filter(block, index);
+	tmp = ocelot_vcap_block_find_filter_by_index(block, index);
 	tmp->stats.pkts = 0;
 	is2_entry_set(ocelot, index, tmp);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index b1e77fd874b4..9e301ebb5c4f 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -237,6 +237,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *rule);
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *rule);
+struct ocelot_vcap_filter *
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id);
 
 int ocelot_vcap_init(struct ocelot *ocelot);
 
-- 
2.25.1

