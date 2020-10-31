Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE2A2A153E
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgJaKaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:30:11 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:28640
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726774AbgJaK3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 06:29:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yzi6mXRg+HD4N6gHg+8gvgb0qTtmjnN8E5eH8dYSGZBvXaMSmpg0VYR4D7opv2BePEkEAS53a1AgSRm3g8+B3hJPr7OhRDsEqfGq+mVTl/LfiiDpUSwg1bOTGM2nfY+VWwlshaznvJjbTY+zmA7GF7HSImQkBqt0vHCIqN23dNXSfVI5bgBdTyp77lDWQmLj8+P7155zwpglos7HCzxtongEyJkNNYRNDPV4TZjpPGWzPVCFhIJRYLuotUXlRm2yA5jaEmWS7Zq7uVED+3G3eAQVdJeVgvFEkjP92zbe8xXsvSndaHCJ6f8S80Cra0qVn58OfsawbOWg1BLi4yx/oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKtpJaD0SCyg+CYmRIXJ7EzcIbBTTXsnqtX2g3RhboY=;
 b=fgJZhUNwi+9RDBmniMI/46JrdMOpE/2lJbeDZ8g5DJ91gyH5LKwA/IBzAHLVEhRMRpsifPv+YAXJQCS7YLjByS2k9R+eVaVkhb7XdQVLlAW3Tiz7/KXuPd+wa0gzL3+lgJft1s15zmpGHi/b1okofXJx2FXVSMeq0IPRyq/lmDTDvHdy4J/pxm6vb8JGEHUVnl4CkXGiKYD/Ultg8pDwgMZIs/Z1youJ8tWUrewurXf0z7/8xUs2l+V4KJ7jSDkVlz2QSO386ayCQ519ZCDA4ZzHLSieUZAbTuiFPPYByTckVSUhvp6+bge74JRGu5FNFqHIdIshNbrtOpeerkpz2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKtpJaD0SCyg+CYmRIXJ7EzcIbBTTXsnqtX2g3RhboY=;
 b=FliEp/dv46zW8Yjp/ylE3+MCeeQdVkm2zNzBNuROS2C7k5+V0ExcJZnSlMEx/MJ9PmeiDttzKB8RKqQWcv7rVooj8L0WI7cBs80nvU5fhoI85E6+bTNzw4xn6ulN5vnfi2XCyaUkgliDImcAoHZgBDVuE/4/HcjjBYosndvJDec=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sat, 31 Oct
 2020 10:29:30 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sat, 31 Oct 2020
 10:29:30 +0000
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
Subject: [PATCH net-next 4/7] net: mscc: ocelot: add a "valid" boolean to struct ocelot_vlan
Date:   Sat, 31 Oct 2020 12:29:13 +0200
Message-Id: <20201031102916.667619-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by VI1PR08CA0170.eurprd08.prod.outlook.com (2603:10a6:800:d1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 31 Oct 2020 10:29:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 793191d5-a45c-47f5-8986-08d87d87d992
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB66379866FA7CDAC24517F24FE0120@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2z2dPlMNYPkVNFFQGrUBRpkF/yTW8PqwFg0h8se6Hd/xGkxl05/as/pz2Czfjqhp5OGXvIaIqLXsljdvO5LfG30xeyCFgle0VAGjcwgwKqa0w/paItKiZrtHNMLHaUQY+MPW2bg+j14GBxcsVnV/NHELOmO6R+WAfU+NbN5dD2GuX9SbV18aVvdQHZ4zBY3x7xQ1EOicnZq7zpJYD57zGVhPaVSQPLKjKJ4lm+yS+JvpzIa/Ad78LIv7Pn20lA80I7A68pyuV5hClX+l3OnK4dUD9qN6MWJR+axsXQAdirLeHrDEpscVfa8kQtJXw7ETxl0wIP1oKX1dfv/OmBRt0lGo4NJwYKOM/Ulgru471XFfap3I0FwLgMvN+fdmtBGmZPzAbtc56q+MbI91eCcqrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(66556008)(1076003)(316002)(956004)(86362001)(66476007)(8936002)(83380400001)(2906002)(110136005)(66946007)(8676002)(36756003)(6512007)(6666004)(16526019)(186003)(52116002)(6506007)(44832011)(26005)(6486002)(69590400008)(478600001)(2616005)(5660300002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Tktj649tLH5arm2tptdyqgQOnlNDk95LvjHOX9a7nGArunwfRAKNvRe8k/Ipf5HPGFlP8PZUx62sSb+JGSl6aGLwK8RapO6XKY7/rHd7j8WMlaKnCn9shBE6U54O1e+i/FfkaZkoAjM/5Uy5xmO6xvK8m9cTwy5hWvlneVWJpsEvzj14Q5gEe4696w3DDkWFApnt4cj/U2A7R5zkKVKPSA5pokl2mw7fJUC6L9sjDCRnnEzQDQSWSgcB0OjZG9fQsyr9KqYChl8ZHDrQZpJ5J2rVQ47rNTmYeqmJm5+dfe25fY2ghQ2f3f0cXLRJNJ3GHGraT/eSC4DBDWUwL6huWzxag8F1mFGt2AhEFScCwKaCvp1KH1AOCG7qt0HXt/1af5odcSbDNp2ezcCTswI4rt+nIs07NaubyPmSk8o52yb0keoqa/zJ58dOUyUrc51FxFYvml3AGk5xbyszMxU/xlwiGde6JW6vqzkyzljYy8tuRKw224Y17X9YsVBK0Z+MOGjD+wfM6F8Top3MCht0oP/T6xrnIOTc5gtlIfhr1uwdKoc17rlg1BEJyCHLzcP4pV+ZHl2mhl/YFZyeIpLw6FChnoS/oqAOlzWCq6DGhiw17EyF2ocqo1/7rCIzwAOWH7hcY37Vy54mlHpW5PPfSw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 793191d5-a45c-47f5-8986-08d87d87d992
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2020 10:29:29.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1nDCwYbXcdqKrV3FoZ5wSKtv1haC0rHKTuS3njZ/r7fkLnDkN+axiPYM029WLdDSGZ+ZyDLNQa/4qJToNuOzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we are checking in some places whether the port has a native
VLAN on egress or not, by comparing the ocelot_port->vid value with zero.

That works, because VID 0 can never be a native VLAN configured by the
bridge, but now we want to make similar checks for the pvid. That won't
work, because there are cases when we do have the pvid set to 0 (not by
the bridge, by ourselves, but still.. it's confusing). And we can't
encode a negative value into an u16, so add a bool to the structure.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 27 ++++++++++++++-------------
 include/soc/mscc/ocelot.h          |  1 +
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a7e724ae01f7..d49e34430e23 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -153,22 +153,22 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 val = 0;
 
-	if (ocelot_port->native_vlan.vid != native_vlan.vid) {
-		/* Always permit deleting the native VLAN (vid = 0) */
-		if (ocelot_port->native_vlan.vid && native_vlan.vid) {
-			dev_err(ocelot->dev,
-				"Port already has a native VLAN: %d\n",
-				ocelot_port->native_vlan.vid);
-			return -EBUSY;
-		}
-		ocelot_port->native_vlan = native_vlan;
+	/* Deny changing the native VLAN, but always permit deleting it */
+	if (ocelot_port->native_vlan.vid != native_vlan.vid &&
+	    ocelot_port->native_vlan.valid && native_vlan.valid) {
+		dev_err(ocelot->dev,
+			"Port already has a native VLAN: %d\n",
+			ocelot_port->native_vlan.vid);
+		return -EBUSY;
 	}
 
+	ocelot_port->native_vlan = native_vlan;
+
 	ocelot_rmw_gix(ocelot, REW_PORT_VLAN_CFG_PORT_VID(native_vlan.vid),
 		       REW_PORT_VLAN_CFG_PORT_VID_M,
 		       REW_PORT_VLAN_CFG, port);
 
-	if (ocelot_port->vlan_aware && !ocelot_port->native_vlan.vid)
+	if (ocelot_port->vlan_aware && !ocelot_port->native_vlan.valid)
 		/* If port is vlan-aware and tagged, drop untagged and priority
 		 * tagged frames.
 		 */
@@ -182,7 +182,7 @@ static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 		       ANA_PORT_DROP_CFG, port);
 
 	if (ocelot_port->vlan_aware) {
-		if (ocelot_port->native_vlan.vid)
+		if (native_vlan.valid)
 			/* Tag all frames except when VID == DEFAULT_VLAN */
 			val = REW_TAG_CFG_TAG_CFG(1);
 		else
@@ -273,6 +273,7 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		struct ocelot_vlan pvid_vlan;
 
 		pvid_vlan.vid = vid;
+		pvid_vlan.valid = true;
 		ocelot_port_set_pvid(ocelot, port, pvid_vlan);
 	}
 
@@ -281,6 +282,7 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		struct ocelot_vlan native_vlan;
 
 		native_vlan.vid = vid;
+		native_vlan.valid = true;
 		ret = ocelot_port_set_native_vlan(ocelot, port, native_vlan);
 		if (ret)
 			return ret;
@@ -303,9 +305,8 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 
 	/* Egress */
 	if (ocelot_port->native_vlan.vid == vid) {
-		struct ocelot_vlan native_vlan;
+		struct ocelot_vlan native_vlan = {0};
 
-		native_vlan.vid = 0;
 		ocelot_port_set_native_vlan(ocelot, port, native_vlan);
 	}
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index baf6a498f7d1..67c2af1c4c5c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -572,6 +572,7 @@ struct ocelot_vcap_block {
 };
 
 struct ocelot_vlan {
+	bool valid;
 	u16 vid;
 };
 
-- 
2.25.1

