Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DDA5AE90F
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 15:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbiIFNF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 09:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240267AbiIFNFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 09:05:23 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2063.outbound.protection.outlook.com [40.107.105.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E907E520A2
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 06:05:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOomsjeveLdcU6ADdJELDehEMhL985KvAL5ah4lQGerl7amU5E66ptkG6SFvJT1qYGh3UdcTdaLZ/CbZaIYG8hqfux+TxeWHgTF8srbWKNofawxexvNaIeDLXT6eFg2TcjzW87SbJ6CTXH5PXpvZEL5JPGfxDU9rOoQ4Jw8K7vv9pbCMj+k+dNleWYvGAyvZ2db5JlPTyCWHIffbmiAqd4Abjc2DjCOBNGLuRsD9nImVN7I7yQRB2lPfaw/MOfUBUdhdbYT2FtjTjGEmJK3Hx4GMiXqpq/34cPBBX+9lso9hzTxjpGJtWR1G0a85Eok1sqv6yRNDjXAyRtvRhmXfUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yuhuP8ic7Dr0apxxZZ4FnI1NzwYMg4b7Zq1FszV7WSM=;
 b=Tz6zjjne6/x/Qrc4JlOuNGveu4RNy4yTDnpvkFam0/aEdN23il8ZG3CasoEiPuWgy41jZXkKSg2xwKQhUff3nFWv5oZVzJwwlVue4ZAE9VqEuODeC+BeImvYFoL7o688qPTgoak+8MGoVwd4wJVVEDYZMkLgnPMkfnuVuinZs8SvpX7DilP7aurQTH0tI90QBxYjgtYrHxQeRuqgmDisc6kQd5StRzy1+KRPK0B5pozqtDuSCD40ijt2Vx5Lbk0YridaLJbIiJq90K4mXJDPdjkTipoQdczGwk2lvHaKAmyWe5cvI+T+jNMxMiTEQfv9fdPctYgqIH54UdpXXSDbgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuhuP8ic7Dr0apxxZZ4FnI1NzwYMg4b7Zq1FszV7WSM=;
 b=CypicTn9lkIaOe55VMzwuOl3Ttqg7FQ+Ug2E18cF3FXlM5pS1shWC1eh7zFfc4Hs8mI4Nw1V72y9tEpnoiuITcg1+cr0R6HyEbkmMxRuJj9S1hUse7yrZ7XVuEnJQOv2DgcLkzi9Z3yPZrG59m9sKDgAraDYYSkjMByakOa2mS4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DB6PR04MB3062.eurprd04.prod.outlook.com (2603:10a6:6:b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.18; Tue, 6 Sep 2022 13:05:17 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::b9df:164b:d457:e8c0]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::b9df:164b:d457:e8c0%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 13:05:17 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net] net: phy: aquantia: wait for the suspend/resume operations to finish
Date:   Tue,  6 Sep 2022 16:04:51 +0300
Message-Id: <20220906130451.1483448-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0006.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::11) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afa65158-2266-4b4e-cc1e-08da900871de
X-MS-TrafficTypeDiagnostic: DB6PR04MB3062:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qes9H2/Ucf4qQavotngQKity5zy/LEm9W1zwxLDbaDjFzgpZ0tC8E4FFkZUdwiE8Tg5nGVwdEtLC6bbaWRZ5xu0WPC8nmnvnGwlcK8SrDSCYafvsMu0oKUf6Un8uGCS2x7It07LwHM9Q5eFu7ZwNtLxY4h7yfsS0eyRcH1XOZRrCDD9lsZmXfEdezzOZm1Fu5LKMLMWgAH4G2DadGDWxIOBwjsc0gFUI8r90QevoWl+eIFI7736fRfTf88qd2nsNzAzvYvH6ANt43gcnHwY5srEY9Y9ijOjoh3AVyhqLZo0OXjPH9lDziXi8j/Keo8Km9td1AytDuQqjsn5glrw7iHCOJZkQoOMlO+LohEjV9FEmWm/ZrkJG8RyR6n23JWyqZlTp7XBfyaU5yuiQeVUs3GR7KYmMD+TWrQlfs8WXa2TLjNadKyYua9s7Io6QRXkzA/VOHKUlKgtiehQTVagqb5gOQldin/Tx31zEDDXZG+NgDDcVAHv00mLO5QY2nsrgepXv7pgMJdluDwjOv3ieSVgvzotfN+9tEeJ0GuvykJava4GHOknMs6HTkmg5hE0xjhy/2KrjSCd0LGuNPiUQFTFg/C1DXf7TFPD18UWwzMoDrkf5VlvBgkcTF7MhvIxyWkfLrw5EM3OmXEp6ba2pYDspZ+gL602ja4H2PX5kOo5kq4EjGHqLKSdVUU58GO6pgP74ydmmepRZ9ZJ6tuhOP3MK+llkRx9G/U20+kUzil5g5vH8WUtXhxMqt+dmBRWU+57CRHZJBcViA+Ny7gs5Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(2906002)(52116002)(41300700001)(44832011)(5660300002)(26005)(6506007)(86362001)(6512007)(316002)(15650500001)(6666004)(6486002)(186003)(2616005)(66946007)(66476007)(66556008)(38100700002)(8676002)(478600001)(83380400001)(4326008)(1076003)(8936002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HyLJSJI8VLzym9fALGq3GxunWoNTPa1ilUmOJOyh5o1GAtk2ArxNBm5iswB8?=
 =?us-ascii?Q?tqWVNocU7HpxnsXky+18kMpz3tfSguVGQ7mXCHNILJ9L+gyl7kTLCglIl6np?=
 =?us-ascii?Q?KcdlwoINuEh9g96SNHQhr3i8OsvYKb1TMpdBUGFIuu8yIhgMxTn8O7r14VaA?=
 =?us-ascii?Q?4uSKGy5MGka2rG+GiZfxHFd7k6Q11REU9Dl6gyBsMlYJ8Uogl186lXi+Dzbf?=
 =?us-ascii?Q?kArU583LynCfYxy8ONBCZ67SVVYnZHSGP3y2JCcekKKsFQcUwuTB0BemTxNK?=
 =?us-ascii?Q?kGhQpS6TzbcxnwvXDBkpDXl1fKIAbaZcm/25ruRp762CT2j6gcymf5S8QuFb?=
 =?us-ascii?Q?Rur6VUok7JEd1JWRK9NPyGW+zOeABuMARoGQ0aO9FK7qtFsBcvJLUQrlXZXY?=
 =?us-ascii?Q?Z2V5IBdAR1CsHQoJhF/Ci33Gqz/a+irX1CnJ0vu8dlVRPXuYwtiQLGdPeEsg?=
 =?us-ascii?Q?ccKZSEenOX+szTpqsJA9xBaoT1oxfFTx+gxh8VoNOgjOTdDEtdyyTXjXBpgq?=
 =?us-ascii?Q?XApHpAvjCPZODAnq/UnWkHmfBI5sAx0UDP+Ma3M+foL9C33M+6MQuuaZKz7z?=
 =?us-ascii?Q?pSw24B63ITRjdnh3Y3yLoZKvbyffhXk6cY6x3ql0/UnKivdGpnL9aOZmzUDB?=
 =?us-ascii?Q?AuEPL7XblwIRCEc3/QJw99zw3wxqkrqQnr5QuzqBalPSkcEz/UtKtdZV0KNP?=
 =?us-ascii?Q?K3kFn7L53G9VQbJy8EUNgxJQZOU12LcpTEU5KwTVzYDd8Q5QD4+7N0qTKuPX?=
 =?us-ascii?Q?hGbNzHDPbyNwP3PNEahSKo0yRXYb72pBPR8F+y0qqbJsY0U6UM3ABhVEVr7P?=
 =?us-ascii?Q?6Om2S96G+BqbJVOwaWrjGYVPVydqtwrF7ndd1LUXew4bkfi7Y6BNETe23TFA?=
 =?us-ascii?Q?UFesRZEKCmnhIxQpeXuKmUwp+Iolb6JbJStePBv+QdmmzNZnlYBX9X5lvLrT?=
 =?us-ascii?Q?M6VfxdBOCvcA4qcVeBTBzIVfq7f218T3mNLYg7jpPv46eclwTpuU01OYyybw?=
 =?us-ascii?Q?YmgGP09ZxyUDKQttAZtLrrRzt+lRm4dncPCZ96U50+aFq8SZZ4wQtkjgawUv?=
 =?us-ascii?Q?C8ioMRQlXJL0Gf8SwA4LXb6e1TyJVw16SAXY73N2KxGL1xiFWntAUMRTJgzB?=
 =?us-ascii?Q?NALPZtFdaawc1JdoWGhkIIetQakjfQ104zJ8+PaJBl9rrPuPlYAyRXt60iP2?=
 =?us-ascii?Q?/5R/DeS0D+9KIoj4CwBqhM3mBkJBrScPHe0tS94gIgzS6bS3b2m7GIf//wek?=
 =?us-ascii?Q?8Kw9/nzRPWWVwbje0qbp3QiwCy9gVl/2c8m3LCSkQDRlLcylaq+bNl2V63su?=
 =?us-ascii?Q?x9OENKupdOcArbbCRwzJxjouUX7cLtOwHWm4ENaYG9bt5818Dq+fidprZVIi?=
 =?us-ascii?Q?a5iNADVmV3DhZ8r5Xq6Oa+frQfwgHzSzTd8V9WI7sHPflEyxJeT/Q2ZWjmRE?=
 =?us-ascii?Q?IBlXN1lvHjvKbopo3M5T1GE3hiGSCVlxJKXoaWGa8Xna8mXAj2T7lPueLmSx?=
 =?us-ascii?Q?8NFQguZBQmH8ZsBZtV+vmr/maXrFnGHw1vn35ixsARbiB1DgQAZSnXSgxxfx?=
 =?us-ascii?Q?6QXkDgyMjJrRta3w1vT/nyAf4CYx3P68mHjK5S4JijUTrVbIrlSq3ROCdlTp?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa65158-2266-4b4e-cc1e-08da900871de
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 13:05:17.2629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVCDzEfMFbyB/JiU+vRAenrROJYwPoxgvnKaPnZnMU7F6ZmQ2HQLjdgL9xvEKpj/ToanJ4Q+jkNCJCrKFU0IeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3062
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Aquantia datasheet notes that after issuing a Processor-Intensive
MDIO operation, like changing the low-power state of the device, the
driver should wait for the operation to finish before issuing a new MDIO
command.

The new aqr107_wait_processor_intensive_op() function is added which can
be used after these kind of MDIO operations. At the moment, we are only
adding it at the end of the suspend/resume calls.

The issue was identified on a board featuring the AQR113C PHY, on
which commands like 'ip link (..) up / down' issued without any delays
between them would render the link on the PHY to remain down.
The issue was easy to reproduce with a one-liner:
 $ ip link set dev ethX down; ip link set dev ethX up; \
 ip link set dev ethX down; ip link set dev ethX up;

Fixes: ac9e81c230eb ("net: phy: aquantia: add suspend / resume callbacks for AQR107 family")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - use phy_read_mmd_poll_timeout instead of readx_poll_timeout
 - increase a bit the sleep and timeout values for the poll

 drivers/net/phy/aquantia_main.c | 53 ++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 8b7a46db30e0..7111e2e958e9 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -91,6 +91,9 @@
 #define VEND1_GLOBAL_FW_ID_MAJOR		GENMASK(15, 8)
 #define VEND1_GLOBAL_FW_ID_MINOR		GENMASK(7, 0)
 
+#define VEND1_GLOBAL_GEN_STAT2			0xc831
+#define VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG	BIT(15)
+
 #define VEND1_GLOBAL_RSVD_STAT1			0xc885
 #define VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID	GENMASK(7, 4)
 #define VEND1_GLOBAL_RSVD_STAT1_PROV_ID		GENMASK(3, 0)
@@ -125,6 +128,12 @@
 #define VEND1_GLOBAL_INT_VEND_MASK_GLOBAL2	BIT(1)
 #define VEND1_GLOBAL_INT_VEND_MASK_GLOBAL3	BIT(0)
 
+/* Sleep and timeout for checking if the Processor-Intensive
+ * MDIO operation is finished
+ */
+#define AQR107_OP_IN_PROG_SLEEP		1000
+#define AQR107_OP_IN_PROG_TIMEOUT	100000
+
 struct aqr107_hw_stat {
 	const char *name;
 	int reg;
@@ -597,16 +606,52 @@ static void aqr107_link_change_notify(struct phy_device *phydev)
 		phydev_info(phydev, "Aquantia 1000Base-T2 mode active\n");
 }
 
+static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
+{
+	int val, err;
+
+	/* The datasheet notes to wait at least 1ms after issuing a
+	 * processor intensive operation before checking.
+	 * We cannot use the 'sleep_before_read' parameter of read_poll_timeout
+	 * because that just determines the maximum time slept, not the minimum.
+	 */
+	usleep_range(1000, 5000);
+
+	err = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
+					VEND1_GLOBAL_GEN_STAT2, val,
+					!(val & VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG),
+					AQR107_OP_IN_PROG_SLEEP,
+					AQR107_OP_IN_PROG_TIMEOUT, false);
+	if (err) {
+		phydev_err(phydev, "timeout: processor-intensive MDIO operation\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static int aqr107_suspend(struct phy_device *phydev)
 {
-	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
-				MDIO_CTRL1_LPOWER);
+	int err;
+
+	err = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
+			       MDIO_CTRL1_LPOWER);
+	if (err)
+		return err;
+
+	return aqr107_wait_processor_intensive_op(phydev);
 }
 
 static int aqr107_resume(struct phy_device *phydev)
 {
-	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
-				  MDIO_CTRL1_LPOWER);
+	int err;
+
+	err = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
+				 MDIO_CTRL1_LPOWER);
+	if (err)
+		return err;
+
+	return aqr107_wait_processor_intensive_op(phydev);
 }
 
 static int aqr107_probe(struct phy_device *phydev)
-- 
2.33.1

