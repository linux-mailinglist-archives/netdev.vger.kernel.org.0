Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1378028CF75
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387883AbgJMNtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:18 -0400
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:11232
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387772AbgJMNtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvgoouzeQIL2PQbFtVxuzDPh59XnG66KoKSb4dH5PN/46Ush/wihANimPDcT56hxKY/e92NqvhhOQwABvFLLcQYRCo4LlMEH30VBdQs81hPpN/cK2zT6NfxvgFK9IIzDt49+LpoP17KPAtVR+YkjWrvKH4idMXQoOTUNdTN9xZsGX8YKXv9OddsD1BC+4uh+4cDTmQPXuaNZwv5AQCWMeH5iK8FyCE1lw5NWlXNUWuuDuHTwdNjqGIT9Z1aHjopbrjrVT00Rm13YPvidUHitiL43VdRv2nGC9dspryV5HzN1KZxrbCVW6rj2h3hKW5dl36dVn8HGboCw2AQlHZA+mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIwY2Els2OJHS55Euvj7X3mYT5NgTBpKwPyLGZdLYug=;
 b=E5yYltUSFV51EZ7jYbt4JmaTqBjNaCWOfw8VH03S9x93u2PTrxx33yJYKLgqJ850SEjA09leVK4WHG2I9x6Tj4GVxLXmvxqDoC98nYfhkRtwoavaKM8CEOB9HtwKwJiEaOaAE2hs8Q8CZ8LeMNWXBnDxpEI+2F9s4xnW/q10NmP190sQIPgV6Lh0F/d0NN3cWsmfghhaVyq82YDVbmlO+eIdR0EkYQSH710ieHRkk2Fuwv5dUXXdGOwdAMQdPEmepcDu+h+HJm7DDeypylUVLtUWcpNHXLxVfzeZBCxhvcxsVTRz9jj4pF3KONYxJ3/bNIknwNLsY9PQWP1wa0JOJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIwY2Els2OJHS55Euvj7X3mYT5NgTBpKwPyLGZdLYug=;
 b=qoxfxWuIBB6Dy8n2H7RITI7aXq6wwnLD8kViRW/VOtvXnUfTAF+FP2xkzVfWI833BsAf00bQezYoyHwhBaQGTdIpmvVz4KJ0TFituefNts3Oc1HIsBBVzcXyHCmF+byhLTYfUjbI5c+IJWpu7yByCZsYCjmk59ouJiYuQESovdc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24; Tue, 13 Oct
 2020 13:49:10 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 02/10] net: mscc: ocelot: add ops for decoding watermark threshold and occupancy
Date:   Tue, 13 Oct 2020 16:48:41 +0300
Message-Id: <20201013134849.395986-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2716da69-a96c-4483-7e42-08d86f7ec313
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB66374ACE598635C5A279D245E0040@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4a80fCiL0iuoDnQ7G6lPWjAXEpwRHqAZ0pQCgAdM0FF9JQRVk/MwEmyOagCqYbgV662SZePXStWSWna8Z/++9xNCWn5aWiPTbP0Oln/aVd5asYebPBcEUaIeaXsNh1bgZoPYQo4qKNddGN/swNuH6z2++1Cj91WxxnAApMhHto6iLY8Rtt2CTg8Ytaa4bHVx+XnfIv4qYeMK2yo/UXdNX4gYRV6ez1BQLSEn7qxzITwuFZoGyBfg4+2lJp1T+dhbco1X6K2UQjWR5gUYuJ6qgEKVGLSufMOYTH8FGGb87BghEE/Vmh30Mmmc5fVtS9g1tfFK2SY7G+H4R86FOPxXR6Kl2/k3ztn/D5XjJzL6aIdyO8eaaf6TW5dsqiyJ/b1/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39850400004)(366004)(52116002)(83380400001)(66946007)(66476007)(4326008)(6506007)(186003)(8936002)(69590400008)(26005)(8676002)(6666004)(16526019)(66556008)(5660300002)(44832011)(956004)(478600001)(6916009)(36756003)(86362001)(6512007)(1076003)(6486002)(316002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: o98ei3dJ5fb/ENVgpceD59CbLEO9tYe7WZXuXoFflRQDzm42F3wdFU3LbYMlgBEPggQvppX8FZ5rzQFcbOUihSALzyGtpqm4tR/HnEfr1Vl1oCsTI5VFMG2NL7LZz+k+0UazUARaAeH95JgeB7PyYntYR+K+osTyhDV0H0nowUwCE47OYN3+id7dMnE545L04QLZubLNj5xsX17SZs4FvV9rJx/Otfl51ctTxIAaqu5vfPdPuwIZFJa8lHg8nVnuxuQoUeXe6Ukg9H3EHcBZH+s2qzpvbMe2xNM+TShkD7fCSM3bIX/QkuGzXcJKC9JbBIe14m7ifXZf8r2eXVKdoaUhqjZJzF9WI2y+TU8jvH3ySi4n5fS/8xu2SoxaGx7peG6bMucbiR1O3VdisVp0I4Od5AnqqQ+nRqMYbHLz5bt+2rS6Ku3wnrXtPnPiJ8qCFw6iHjLI7endltKw8YBPvTEBe5p4YBBOefpXt/YGk5VXRlTq0UO87OXBBekUfit5M1bzy+q9+65CYHpjDSIF9XW1FR1H9ArWhvpLfJ3iGVfJZvxXASByQMv7f6co/Ywom68Vp8gjTz/PulowBnxhfPSra3/JETEX2rfRXEyh1Z6XRl0HMFAtOBUL6APVABNaNpTt/e6TXzKR/1nnk8tCbA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2716da69-a96c-4483-7e42-08d86f7ec313
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:10.7469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSI6lXRtwvOierJLK8jos0KqUQo0PGfDBXCoZ2K3MTif72qrGYmtwzKSJFDgI0MfMLz+pr2CNi5dDTsnOd0U/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need to read back the watermark thresholds and occupancy from
hardware (for devlink-sb integration), not only to write them as we did
so far in ocelot_port_set_maxlen. So introduce 2 new functions in struct
ocelot_ops, similar to wm_enc, and implement them for the 3 supported
mscc_ocelot switches.

Remove the INUSE and MAXUSE unpacking helpers for the QSYS_RES_STAT
register, because that doesn't scale with the number of switches that
mscc_ocelot supports now. They have different bit widths for the
watermarks, and we need function pointers to abstract that difference
away.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 18 ++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 18 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 16 ++++++++++++++++
 include/soc/mscc/ocelot.h                  |  2 ++
 include/soc/mscc/ocelot_qsys.h             |  6 ------
 5 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index a2d5a9a8baf1..d4ef440d6340 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1006,9 +1006,27 @@ static u16 vsc9959_wm_enc(u16 value)
 	return value;
 }
 
+static u16 vsc9959_wm_dec(u16 wm)
+{
+	WARN_ON(wm & ~GENMASK(8, 0));
+
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+
+static void vsc9959_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+
 static const struct ocelot_ops vsc9959_ops = {
 	.reset			= vsc9959_reset,
 	.wm_enc			= vsc9959_wm_enc,
+	.wm_dec			= vsc9959_wm_dec,
+	.wm_stat		= vsc9959_wm_stat,
 	.port_to_netdev		= felix_port_to_netdev,
 	.netdev_to_port		= felix_netdev_to_port,
 };
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index dbf2bb951761..b9890d18ad16 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1057,9 +1057,27 @@ static u16 vsc9953_wm_enc(u16 value)
 	return value;
 }
 
+static u16 vsc9953_wm_dec(u16 wm)
+{
+	WARN_ON(wm & ~GENMASK(9, 0));
+
+	if (wm & BIT(9))
+		return (wm & GENMASK(8, 0)) * 16;
+
+	return wm;
+}
+
+static void vsc9953_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(25, 13)) >> 13;
+	*maxuse = val & GENMASK(12, 0);
+}
+
 static const struct ocelot_ops vsc9953_ops = {
 	.reset			= vsc9953_reset,
 	.wm_enc			= vsc9953_wm_enc,
+	.wm_dec			= vsc9953_wm_dec,
+	.wm_stat		= vsc9953_wm_stat,
 	.port_to_netdev		= felix_port_to_netdev,
 	.netdev_to_port		= felix_netdev_to_port,
 };
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 5a07f0c23f42..ea55f4d20ecc 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -763,9 +763,25 @@ static u16 ocelot_wm_enc(u16 value)
 	return value;
 }
 
+static u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+
+static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
+	.wm_dec			= ocelot_wm_dec,
+	.wm_stat		= ocelot_wm_stat,
 	.port_to_netdev		= ocelot_port_to_netdev,
 	.netdev_to_port		= ocelot_netdev_to_port,
 };
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index da3e50efcf96..4f4390408925 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -563,6 +563,8 @@ struct ocelot_ops {
 	int (*netdev_to_port)(struct net_device *dev);
 	int (*reset)(struct ocelot *ocelot);
 	u16 (*wm_enc)(u16 value);
+	u16 (*wm_dec)(u16 value);
+	void (*wm_stat)(u32 val, u32 *inuse, u32 *maxuse);
 };
 
 struct ocelot_vcap_block {
diff --git a/include/soc/mscc/ocelot_qsys.h b/include/soc/mscc/ocelot_qsys.h
index b7b263a19068..9731895be643 100644
--- a/include/soc/mscc/ocelot_qsys.h
+++ b/include/soc/mscc/ocelot_qsys.h
@@ -71,12 +71,6 @@
 
 #define QSYS_RES_STAT_GSZ                                 0x8
 
-#define QSYS_RES_STAT_INUSE(x)                            (((x) << 12) & GENMASK(23, 12))
-#define QSYS_RES_STAT_INUSE_M                             GENMASK(23, 12)
-#define QSYS_RES_STAT_INUSE_X(x)                          (((x) & GENMASK(23, 12)) >> 12)
-#define QSYS_RES_STAT_MAXUSE(x)                           ((x) & GENMASK(11, 0))
-#define QSYS_RES_STAT_MAXUSE_M                            GENMASK(11, 0)
-
 #define QSYS_MMGT_EQ_CTRL_FP_FREE_CNT(x)                  ((x) & GENMASK(15, 0))
 #define QSYS_MMGT_EQ_CTRL_FP_FREE_CNT_M                   GENMASK(15, 0)
 
-- 
2.25.1

