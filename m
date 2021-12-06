Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049AD46A201
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhLFRIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:08:02 -0500
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:64823
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348553AbhLFRBw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:01:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuGalrZlkIHq2+ZPDVEEfHLHU0hhTMFlFUvj31MgvgVQsTaIfhMvmH9Ga6qM9Y+XzdHG9rD4jt5ernQtb0hm83tlMCMNvhqJUn7hiq47Py1Bukpitx4GolzR5O1g3OtkQg8/JrgQAa1+RM9KZyTAnPL2w9EDoyvyKAsbLoXtzfcj8pP1JSGebvA9Wm8l/lI+fpvneM7h2Se2ueBP+OicBeRFTT3UjuLIJg1W+gwkg1AEkHJM/VopOLEtcl90wdKddffefahKg8nVZbTAVtqckI291bXuiHeH/QV4TVGa1oCLK9kxYj9+69lClAhmLEXXHjzx0t2TG78R8clKVuSNAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXC95uBo6o00CBiMbRlnJtOFYg5mBvdv2zhTgBT2DH8=;
 b=DC/kAVnsDAmetNPyo7Wu1pw/iRknvQIKp4oH+pvBAZtXP01jb02ZZbkXY+pdI0VVdVW+11UOBnrgX0AYVlk0SkZrZc9jdqFBDQjZNnTkDQb7WnNaajkWtYb78TkWpmLswbCZWTwqlNBuwTSmWNO1LpJoN/vJZQXY0td46alhMdXBwUeWLJY9noM03xsfUREjaQAeJxNhg+9oQR8F8aaFhZNj/XLUbLXbAagG/Xm8WagDcKA1zHvpuUw/VpXyH29SX2GX5aQ1eMlv3iuE/0nB7vQ2jksjrfHfo0ulfnQZaKwb1K/xIGbKgroBn139UcwK68MbNLCGmoIx4fWBQdPICQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXC95uBo6o00CBiMbRlnJtOFYg5mBvdv2zhTgBT2DH8=;
 b=NeToMUKPv5niGDpe6+ornslJ+t9qFEm7NhwzoqNb8YX4XV7C55gIPA+yFiJSqjbBvrghA/dtcDo0DFg3wMjq+5pRaiXdu3/zL92h+1ri/M0M3QuVnuwJLLjh9Ey8/77dpYc0kuX+ohPCYd2gXnuwdiUBLbtx2ELzCtr13nQhOqU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 16:58:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 16:58:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 03/12] net: dsa: mt7530: iterate using dsa_switch_for_each_user_port in bridging ops
Date:   Mon,  6 Dec 2021 18:57:49 +0200
Message-Id: <20211206165758.1553882-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
References: <20211206165758.1553882-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0062.eurprd05.prod.outlook.com
 (2603:10a6:200:68::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM4PR0501CA0062.eurprd05.prod.outlook.com (2603:10a6:200:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Mon, 6 Dec 2021 16:58:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9989d5bf-1ca5-420c-f8bb-08d9b8d99b69
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4912A657F2CBF2D21B0C1DA3E06D9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c3POKQPd8F9UJvuQCRdnWXnwBy+CElNfSizN3HFp5JWRbdwGe/mrbncuJXhsANqYubiRzHqXZhyBT8uDYFMF+6pCyT7laI+xEOHEIdaIa3KItNpHoALBKrxvHDvBWZiW6TI0LSV7JgMAn48Ibnr4WL97Tt6E4um5+A4AjRbdIIr9uCnMS0Jn09JfYO+XTuKa3PQdLpq2WmtgEnY33hogcmVMtqEbZPg1XeGywosUe7gEa7YN9AUvTYr9+QXMCtJLj5FpFJ4eJ6tZqtDAJotnxKnK+QGC3w1gUhXQ2Rz9ApgHWojpQXWG294wpeIhTh8h7bcuU6TrLTYFKU3RzKijRtwzBRTiCW8550GcheJvwAadjznNItpDW4fDCtPygiayaaZxC0PXUqd1axnUB/0E6eSIN890Os+ivKVuTjY/EH06z3AQvmbQm36kvfAyeO+YMemndN+W+2ko9gYMRELkiKKlCN0sEYXO08eIHMkjPLJAZG4I8Y1zw5yCi8N4AoJ4QDEHRcIO9i1tK7KsOpLpQemLDRyNlsO3hdsuicC4Tn7sbENhg7VzhF+RBJCEBcdlzvaN9x+Eb3v7W8G+f4rUZSRO3oMByE/1uqS4iewaEK+a9jCadtdA8hh7RFSSaaUTLj9oIwCkAtunHcAIIq0CYciL8BqOrnRX1LNMUvUTKhpWi3klRachP/4qhdVeyzvFxpImG3DN44glPH/lKgTFtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(6506007)(1076003)(54906003)(66946007)(4326008)(6666004)(5660300002)(7416002)(508600001)(316002)(52116002)(6512007)(83380400001)(86362001)(2616005)(36756003)(26005)(6916009)(38350700002)(186003)(6486002)(2906002)(38100700002)(44832011)(8676002)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F0HoF3h26IPE1YQGRTvmsngwjP1oG26sSBA5UgDE8nW80bPFalmTpD9qJvBO?=
 =?us-ascii?Q?2ldUzZOcpG/9fIy/wibMRKsUUMOubPsEvHaC/o+Z6rjopBCwJLN3JqPPZnAQ?=
 =?us-ascii?Q?TJmkxZ/5ba0wY4bnaczV6W2cMo3jNh/KRoW/GYrbw83zrYWUsEuJXRUju1uQ?=
 =?us-ascii?Q?uXN/gedLhPFcOZC3qtVmklnvNuktpPHflpE+QVz790QmOwIyibETjTUuQXNC?=
 =?us-ascii?Q?r0Yk+ROkRFl4zxzbOTx0YItnzoaGL/ctZNPIO6WINbgREAr+04GhZJQrMl3/?=
 =?us-ascii?Q?ef1nkKcGVXtM+4j2uPMA0y/XlW1nZ7IwGFJDm1Id2dqyiGfNQiXP7CtSQgU0?=
 =?us-ascii?Q?/ztAYwtD60k8XGEBYvKqElgS4cJwqEXyPoAoZZIMNhuLrgn67TEvY5ows3JQ?=
 =?us-ascii?Q?6Uc58C+lnpBeJOV9vdkvQvx2NHmNfQnA+BLUdKxrSMsp7U2495qI9Mg90k5F?=
 =?us-ascii?Q?9fKA5BtRtduIbLoOMvStk9JtY+sMZua2bSdz2p1K67pNhcIbWwVY4zVj9eEk?=
 =?us-ascii?Q?VAF2hbOz2ik1WSPe6dWckxeVmBX+9vGlYNRXyh1k4gZ9UNH13q1VPHZuC248?=
 =?us-ascii?Q?wg7ezplphd9cttQ1/jzHya33c+AU9bU4Gqnz87uYIHFzmq+2QbGmOtOAZUra?=
 =?us-ascii?Q?bW/SLgdyCX5FwuR5q9/lE1Kb8OoAoiCEYPm+XbBi8iEXFf2L6xVbnGGSt1UP?=
 =?us-ascii?Q?PJ28jG0fbxWln8T9SLTeuH66YxVwrrR926/eLkIiFZ7FcxoPybI02wQ8ga/P?=
 =?us-ascii?Q?IKo/SaRcKn1UYLpVPWYDsF96xb/ZF+OlRgMdOqQnkAojpgAUuCm/wVDuXjwe?=
 =?us-ascii?Q?E/1vg+ndIvZWX3yBOINUjyl8kpv+zCx+dJfmE6HrHM7gBwKfNsx72L1bZdeU?=
 =?us-ascii?Q?y+W7j5QouaKGS39Xw+/3fDxPG4yg6dnfYBZ3yLH5E1VsAFnPgCCXixe3H2qo?=
 =?us-ascii?Q?C+BDjU+hMDmE1yHA4/p58te0qEAkuYXOYrsAWUwMHHQaTb1WboLR5JWo71Cm?=
 =?us-ascii?Q?Ca9ZD7vldok4h+ieNg9GkZI4fOA5nxFTv+nBGcGRYGrs8WxyPjXUnZDsxs0p?=
 =?us-ascii?Q?jURI2jCJIm6S3ANhixTDDvGcgGgsqjSZCPWi82D5VqMheHuvN6hIAwDDOMtk?=
 =?us-ascii?Q?bP5Yz6gm50mbEzqPrZ36W3H1pLlQqm6AN2/fBDpnceq4haBTREo6pWbLLCfY?=
 =?us-ascii?Q?QMjgMA2Ar4ea2MsJ3w7wBeKSq/O0CTwpKAwVCjmN0y1eSbVHl74xFB8ltiZq?=
 =?us-ascii?Q?ttIV2jWW4JYRXGTf8TkDolf+9ymvi7fhEtVLD5p1vAxWUn0d31kqfnTzyt8S?=
 =?us-ascii?Q?AyXaFQgChpMa2KJWKMXGnm6JDfMGgo7GF+gz14G9Cpa26EgIqvXEFO9cmHrd?=
 =?us-ascii?Q?WabcHD91So6QacLRjkM6GVnBpTiBaK/uoZASmZ/qhaSmN+Mq7hVJ9jvBcblu?=
 =?us-ascii?Q?A4NmubpskySlDzhVLU4t4s01XXdiHlTCEHlGmAKad/aYjZRIB/1Fpa7BGloN?=
 =?us-ascii?Q?MIFL9/ugJWXtuuwr/U5vJxvhVqdWdbFeR12C0d6Dq7lbLdIZdU4lfAdpKXm/?=
 =?us-ascii?Q?JF4qIC7hbp0/G6VqPedzip3oaruNuS6BqS4CKGHoNpQ8wDSFTWzdMvovzTUE?=
 =?us-ascii?Q?n8Cg/G/K90NuyA0cO6g6ngI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9989d5bf-1ca5-420c-f8bb-08d9b8d99b69
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:58:20.5869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlZqpc11eTcBBzchziGsZGdClYv8ZXRfFfDfM16dz2tTBsuRcN8bkQh4djGCzcJpESdv5ugFrEN+5V1/X1Ar2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid repeated calls to dsa_to_port() (some hidden behind dsa_is_user_port
and some in plain sight) by keeping two struct dsa_port references: one
to the port passed as argument, and another to the other ports of the
switch that we're iterating over.

dsa_to_port(ds, i) gets replaced by other_dp, i gets replaced by
other_port which is derived from other_dp->index, dsa_is_user_port is
handled by the DSA iterator.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is split out of "net: dsa: hide dp->bridge_dev and
        dp->bridge_num behind helpers"

 drivers/net/dsa/mt7530.c | 52 +++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9890672a206d..f7238f09d395 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1188,27 +1188,31 @@ static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			struct net_device *bridge)
 {
-	struct mt7530_priv *priv = ds->priv;
+	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
-	int i;
+	struct mt7530_priv *priv = ds->priv;
 
 	mutex_lock(&priv->reg_mutex);
 
-	for (i = 0; i < MT7530_NUM_PORTS; i++) {
+	dsa_switch_for_each_user_port(other_dp, ds) {
+		int other_port = other_dp->index;
+
+		if (dp == other_dp)
+			continue;
+
 		/* Add this port to the port matrix of the other ports in the
 		 * same bridge. If the port is disabled, port matrix is kept
 		 * and not being setup until the port becomes enabled.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port) {
-			if (dsa_to_port(ds, i)->bridge_dev != bridge)
-				continue;
-			if (priv->ports[i].enable)
-				mt7530_set(priv, MT7530_PCR_P(i),
-					   PCR_MATRIX(BIT(port)));
-			priv->ports[i].pm |= PCR_MATRIX(BIT(port));
+		if (other_dp->bridge_dev != bridge)
+			continue;
 
-			port_bitmap |= BIT(i);
-		}
+		if (priv->ports[other_port].enable)
+			mt7530_set(priv, MT7530_PCR_P(other_port),
+				   PCR_MATRIX(BIT(port)));
+		priv->ports[other_port].pm |= PCR_MATRIX(BIT(port));
+
+		port_bitmap |= BIT(other_port);
 	}
 
 	/* Add the all other ports to this port matrix. */
@@ -1301,24 +1305,28 @@ static void
 mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 			 struct net_device *bridge)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
 	struct mt7530_priv *priv = ds->priv;
-	int i;
 
 	mutex_lock(&priv->reg_mutex);
 
-	for (i = 0; i < MT7530_NUM_PORTS; i++) {
+	dsa_switch_for_each_user_port(other_dp, ds) {
+		int other_port = other_dp->index;
+
+		if (dp == other_dp)
+			continue;
+
 		/* Remove this port from the port matrix of the other ports
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port) {
-			if (dsa_to_port(ds, i)->bridge_dev != bridge)
-				continue;
-			if (priv->ports[i].enable)
-				mt7530_clear(priv, MT7530_PCR_P(i),
-					     PCR_MATRIX(BIT(port)));
-			priv->ports[i].pm &= ~PCR_MATRIX(BIT(port));
-		}
+		if (other_dp->bridge_dev != bridge)
+			continue;
+
+		if (priv->ports[other_port].enable)
+			mt7530_clear(priv, MT7530_PCR_P(other_port),
+				     PCR_MATRIX(BIT(port)));
+		priv->ports[other_port].pm &= ~PCR_MATRIX(BIT(port));
 	}
 
 	/* Set the cpu port to be the only one in the port matrix of
-- 
2.25.1

