Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207606741BD
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjASS7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjASS6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:58:55 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A4095745;
        Thu, 19 Jan 2023 10:57:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctpifJDJLKDMaRV/Ois9sYMTiz+xpfb+WFdSpDGCUGvW4FeNbeJo6gF3zk94uYs3ug3wCGNNul2k6co0rRkLuAz5ts+xB/pAS/LnqM14ISjuTa294YHSQ8oICb757f2MM7hhguu6e82dmMCqGQ2jbvoYy7JubcPLiUEH69ANuKyvOiR261C3X7unZE6ewVMczqNIf7e+ouCOFQXrCDl+eAVgFiB0KAkcLGZO2JcFVEbpEJNLvbm4iF0nED8fbYYJxxRhh5TBIYrK0OWVdTltRvp93nfsigtfpfxTcDc2byqGBfPdjRhW1qSkiEoKV8LTw66VXgMvOR0lgaPnMQ+s0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6Mmb1NFqjuxG6A7PMTfMfjxq8TJAe4DvuBonfgjtr0=;
 b=CeTTEXLwluP2faBXF30roZfqqDDfkthbnpMfmFwOSLRIu/q2XOXBGBmDZcxB4geWE/R2eYfC+8t8twmvFu7Rgj3bXchihfNlP8say8aGgpLgu63/5mTfgihBiVG14jCL0x5ZoKjdkkLVGNl2IvbMG5YJvbmutkYuToBwXLm69a6RatNVvEEsD2e2vNOzVfQyBRoUQWKXEq5P59YlygBHtrFK8QArcD7xqGw/OUMk995FETtGPBz1+dh7tDjQNWMB5avvBRw9Kye0C6hlcpIiHPZ3YUBjyW1Sd2PIo/sGrZFmwnrPkSaPU28ndIirBtjZIKBo/+fWKm+roCeYI+jhGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6Mmb1NFqjuxG6A7PMTfMfjxq8TJAe4DvuBonfgjtr0=;
 b=SvCWYM+T3w/WR3dsKUwYr5ET0B0VA+6SxL18xPnwuxvTK/DsAEo4M5BLAXly5aRqEcUKB+a5W/CVVKrkiIMlcdalN3dVc/m+8dL+G8KjGXuh5gNMfroQD2M8EM9aL20ZZoa4SAmVmBFGwONJTwsyWuJg6DBypPIbhzpM8zAZ14I=
Received: from BN9PR03CA0716.namprd03.prod.outlook.com (2603:10b6:408:ef::31)
 by SJ0PR12MB6734.namprd12.prod.outlook.com (2603:10b6:a03:478::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Thu, 19 Jan
 2023 18:57:39 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::14) by BN9PR03CA0716.outlook.office365.com
 (2603:10b6:408:ef::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 18:57:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 18:57:38 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 12:57:37 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 10:57:36 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 12:57:11 -0600
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
To:     <broonie@kernel.org>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>,
        <sanju.mehta@amd.com>, <chin-ting_kuo@aspeedtech.com>,
        <clg@kaod.org>, <kdasu.kdev@gmail.com>, <f.fainelli@gmail.com>,
        <rjui@broadcom.com>, <sbranden@broadcom.com>,
        <eajames@linux.ibm.com>, <olteanv@gmail.com>, <han.xu@nxp.com>,
        <john.garry@huawei.com>, <shawnguo@kernel.org>,
        <s.hauer@pengutronix.de>, <narmstrong@baylibre.com>,
        <khilman@baylibre.com>, <matthias.bgg@gmail.com>,
        <haibo.chen@nxp.com>, <linus.walleij@linaro.org>,
        <daniel@zonque.org>, <haojian.zhuang@gmail.com>,
        <robert.jarzmik@free.fr>, <agross@kernel.org>,
        <bjorn.andersson@linaro.org>, <heiko@sntech.de>,
        <krzysztof.kozlowski@linaro.org>, <andi@etezian.org>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <masahisa.kojima@linaro.org>, <jaswinder.singh@linaro.org>,
        <rostedt@goodmis.org>, <mingo@redhat.com>,
        <l.stelmach@samsung.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <alex.aring@gmail.com>, <stefan@datenfreihafen.org>,
        <kvalo@kernel.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <skomatineni@nvidia.com>,
        <sumit.semwal@linaro.org>, <christian.koenig@amd.com>,
        <j.neuschaefer@gmx.net>, <vireshk@kernel.org>, <rmfrfs@gmail.com>,
        <johan@kernel.org>, <elder@kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <git@amd.com>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <joel@jms.id.au>,
        <andrew@aj.id.au>, <radu_nicolae.pirea@upb.ro>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <claudiu.beznea@microchip.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <fancer.lancer@gmail.com>,
        <kernel@pengutronix.de>, <festevam@gmail.com>, <linux-imx@nxp.com>,
        <jbrunet@baylibre.com>, <martin.blumenstingl@googlemail.com>,
        <avifishman70@gmail.com>, <tmaimon77@gmail.com>,
        <tali.perry1@gmail.com>, <venture@google.com>, <yuenn@google.com>,
        <benjaminfair@google.com>, <yogeshgaur.83@gmail.com>,
        <konrad.dybcio@somainline.org>, <alim.akhtar@samsung.com>,
        <ldewangan@nvidia.com>, <michal.simek@amd.com>,
        <linux-aspeed@lists.ozlabs.org>, <openbmc@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-amlogic@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-sunxi@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wpan@vger.kernel.org>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <lars@metafoo.de>, <Michael.Hennerich@analog.com>,
        <linux-iio@vger.kernel.org>, <michael@walle.cc>,
        <palmer@dabbelt.com>, <linux-riscv@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <greybus-dev@lists.linaro.org>, <linux-staging@lists.linux.dev>,
        <amitrkcian2002@gmail.com>
Subject: [PATCH v2 08/13] spi: Add stacked and parallel memories support in SPI core
Date:   Fri, 20 Jan 2023 00:23:37 +0530
Message-ID: <20230119185342.2093323-9-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT041:EE_|SJ0PR12MB6734:EE_
X-MS-Office365-Filtering-Correlation-Id: 61b6e378-56df-4107-b2e1-08dafa4f0944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7TCY/2KSxzV8N9mG8lEGoIMjtmp5zzYPPs7fEvErnoXi35VbPZ2kHWoWGDBX9427K9ewEri6tjFNKEWceiWLGNaW8BKZOTT7ylTgNT8d5vmBK1W4LK4hnoFt9M2noN47rR6J9afFk4OsfqE0sb8HhQ9eEERaP2pqIQ1jTpTkc03BCjQKSm51//I4YiJxe77j5QMn/0PgCh40NhPb6bD12iEPZAonFv7zOEyJtu8dsg9Y2Mij19YOQ1gjXxBQv6DPmiZxjlQpHd2UKT7fsYoFs417elKrgKJPiuI1Y84ux5z89Ld41SqmjNiHTwdOZ1lA+wqjzMhlgKhDbsmhGkKUdp6EXs6q8YXMLeXcpxww3YM3fMqpYH2zuDbdY0HPBNL8yGdxtQzHuknIQhEwWubb3rTAkd5tIdMeNmJAhCSH9DGhqAY4dgB5rVzpy0AYUiB+FLflSUMcQfw/qd1ff+QFaXqPuUhMNGmtPAwJDBeIii7JFk1TKenTBnclLdoPjtzYkX82iFUknBI2Ji1ZpzMqwY+6agdwLHCrIew8C5xIjpNua0Vx7GlK6FEFIYNr+y5CbIB/NBqARwr74OcxeNoJuQGdrjzLe5mDUdT2+kUntvLJVEGRw5BififRIstawqnRK3ioss1wwGiNYJO1wQX+G/r+5MM2eXRVZYvzKSKtDbz3Jsg6XsjlzB53+klxXuLF6vmyFR3SJDBnFU5ez2g6PMak8gvPyCieASQJKtLwcsc6FgeSvI00uoO8rQaEaafMGHrpwPZRnuf+7LYq5NBr2EizJVTM0Ac0cQtJOEoCIVBY4DoDWQE31XQPL8KTLpVFB+/UfkWf9B/VAUDgeNfua2i5wNAegAWxq8vG7XPgoA4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(36840700001)(46966006)(40470700004)(921005)(356005)(82310400005)(40480700001)(6666004)(36860700001)(478600001)(336012)(2906002)(86362001)(1191002)(110136005)(316002)(54906003)(7336002)(4326008)(7366002)(7276002)(1076003)(7406005)(7416002)(5660300002)(82740400003)(2616005)(81166007)(70206006)(70586007)(40460700003)(47076005)(83380400001)(30864003)(426003)(41300700001)(8936002)(186003)(26005)(8676002)(36756003)(2101003)(84006005)(83996005)(41080700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:57:38.9954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b6e378-56df-4107-b2e1-08dafa4f0944
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6734
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For supporting multiple CS the SPI device need to be aware of all the CS
values. So, the "chip_select" member in the spi_device structure is now an
array that holds all the CS values.

spi_device structure now has a "cs_index_mask" member. This acts as an
index to the chip_select array. If nth bit of spi->cs_index_mask is set
then the driver would assert spi->chip_select[n].

In parallel mode all the chip selects are asserted/de-asserted
simultaneously and each byte of data is stored in both devices, the even
bits in one, the odd bits in the other. The split is automatically handled
by the GQSPI controller. The GQSPI controller supports a maximum of two
flashes connected in parallel mode. A "multi-cs-cap" flag is added in the
spi controntroller data, through ctlr->multi-cs-cap the spi core will make
sure that the controller is capable of handling multiple chip selects at
once.

For supporting multiple CS via GPIO the cs_gpiod member of the spi_device
structure is now an array that holds the gpio descriptor for each
chipselect.

Multi CS support using GPIO is not tested due to unavailability of
necessary hardware setup.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/spi/spi.c       | 213 +++++++++++++++++++++++++++-------------
 include/linux/spi/spi.h |  34 +++++--
 2 files changed, 173 insertions(+), 74 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 38421e831a7d..96130153f0fc 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -613,7 +613,8 @@ static int spi_dev_check(struct device *dev, void *data)
 	struct spi_device *new_spi = data;
 
 	if (spi->controller == new_spi->controller &&
-	    spi_get_chipselect(spi, 0) == spi_get_chipselect(new_spi, 0))
+	    spi_get_chipselect(spi, 0) == spi_get_chipselect(new_spi, 0) &&
+	    spi_get_chipselect(spi, 1) == spi_get_chipselect(new_spi, 1))
 		return -EBUSY;
 	return 0;
 }
@@ -628,7 +629,7 @@ static int __spi_add_device(struct spi_device *spi)
 {
 	struct spi_controller *ctlr = spi->controller;
 	struct device *dev = ctlr->dev.parent;
-	int status;
+	int status, idx;
 
 	/*
 	 * We need to make sure there's no other device with this
@@ -637,8 +638,7 @@ static int __spi_add_device(struct spi_device *spi)
 	 */
 	status = bus_for_each_dev(&spi_bus_type, NULL, spi, spi_dev_check);
 	if (status) {
-		dev_err(dev, "chipselect %d already in use\n",
-				spi_get_chipselect(spi, 0));
+		dev_err(dev, "chipselect %d already in use\n", spi_get_chipselect(spi, 0));
 		return status;
 	}
 
@@ -648,8 +648,10 @@ static int __spi_add_device(struct spi_device *spi)
 		return -ENODEV;
 	}
 
-	if (ctlr->cs_gpiods)
-		spi_set_csgpiod(spi, 0, ctlr->cs_gpiods[spi_get_chipselect(spi, 0)]);
+	if (ctlr->cs_gpiods) {
+		for (idx = 0; idx < SPI_CS_CNT_MAX; idx++)
+			spi_set_csgpiod(spi, idx, ctlr->cs_gpiods[spi_get_chipselect(spi, idx)]);
+	}
 
 	/*
 	 * Drivers may modify this initial i/o setup, but will
@@ -689,13 +691,15 @@ int spi_add_device(struct spi_device *spi)
 {
 	struct spi_controller *ctlr = spi->controller;
 	struct device *dev = ctlr->dev.parent;
-	int status;
+	int status, idx;
 
-	/* Chipselects are numbered 0..max; validate. */
-	if (spi_get_chipselect(spi, 0) >= ctlr->num_chipselect) {
-		dev_err(dev, "cs%d >= max %d\n", spi_get_chipselect(spi, 0),
-			ctlr->num_chipselect);
-		return -EINVAL;
+	for (idx = 0; idx < SPI_CS_CNT_MAX; idx++) {
+		/* Chipselects are numbered 0..max; validate. */
+		if (spi_get_chipselect(spi, idx) >= ctlr->num_chipselect) {
+			dev_err(dev, "cs%d >= max %d\n", spi_get_chipselect(spi, idx),
+				ctlr->num_chipselect);
+			return -EINVAL;
+		}
 	}
 
 	/* Set the bus ID string */
@@ -712,12 +716,15 @@ static int spi_add_device_locked(struct spi_device *spi)
 {
 	struct spi_controller *ctlr = spi->controller;
 	struct device *dev = ctlr->dev.parent;
+	int idx;
 
-	/* Chipselects are numbered 0..max; validate. */
-	if (spi_get_chipselect(spi, 0) >= ctlr->num_chipselect) {
-		dev_err(dev, "cs%d >= max %d\n", spi_get_chipselect(spi, 0),
-			ctlr->num_chipselect);
-		return -EINVAL;
+	for (idx = 0; idx < SPI_CS_CNT_MAX; idx++) {
+		/* Chipselects are numbered 0..max; validate. */
+		if (spi_get_chipselect(spi, idx) >= ctlr->num_chipselect) {
+			dev_err(dev, "cs%d >= max %d\n", spi_get_chipselect(spi, idx),
+				ctlr->num_chipselect);
+			return -EINVAL;
+		}
 	}
 
 	/* Set the bus ID string */
@@ -965,58 +972,119 @@ static void spi_res_release(struct spi_controller *ctlr, struct spi_message *mes
 static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 {
 	bool activate = enable;
+	u32 cs_num = __ffs(spi->cs_index_mask);
+	int idx;
 
 	/*
-	 * Avoid calling into the driver (or doing delays) if the chip select
-	 * isn't actually changing from the last time this was called.
+	 * In parallel mode all the chip selects are asserted/de-asserted
+	 * at once
 	 */
-	if (!force && ((enable && spi->controller->last_cs == spi_get_chipselect(spi, 0)) ||
-		       (!enable && spi->controller->last_cs != spi_get_chipselect(spi, 0))) &&
-	    (spi->controller->last_cs_mode_high == (spi->mode & SPI_CS_HIGH)))
-		return;
-
-	trace_spi_set_cs(spi, activate);
-
-	spi->controller->last_cs = enable ? spi_get_chipselect(spi, 0) : -1;
-	spi->controller->last_cs_mode_high = spi->mode & SPI_CS_HIGH;
-
-	if ((spi_get_csgpiod(spi, 0) || !spi->controller->set_cs_timing) && !activate)
-		spi_delay_exec(&spi->cs_hold, NULL);
-
-	if (spi->mode & SPI_CS_HIGH)
-		enable = !enable;
+	if ((spi->cs_index_mask & SPI_PARALLEL_CS_MASK) == SPI_PARALLEL_CS_MASK) {
+		spi->controller->last_cs_mode_high = spi->mode & SPI_CS_HIGH;
+
+		if ((spi_get_csgpiod(spi, 0) || !spi->controller->set_cs_timing) && !activate)
+			spi_delay_exec(&spi->cs_hold, NULL);
+
+		if (spi->mode & SPI_CS_HIGH)
+			enable = !enable;
+
+		if (spi_get_csgpiod(spi, 0) && spi_get_csgpiod(spi, 1)) {
+			if (!(spi->mode & SPI_NO_CS)) {
+				/*
+				 * Historically ACPI has no means of the GPIO polarity and
+				 * thus the SPISerialBus() resource defines it on the per-chip
+				 * basis. In order to avoid a chain of negations, the GPIO
+				 * polarity is considered being Active High. Even for the cases
+				 * when _DSD() is involved (in the updated versions of ACPI)
+				 * the GPIO CS polarity must be defined Active High to avoid
+				 * ambiguity. That's why we use enable, that takes SPI_CS_HIGH
+				 * into account.
+				 */
+				if (has_acpi_companion(&spi->dev)) {
+					for (idx = 0; idx < SPI_CS_CNT_MAX; idx++)
+						gpiod_set_value_cansleep(spi_get_csgpiod(spi, idx),
+									 !enable);
+				} else {
+					for (idx = 0; idx < SPI_CS_CNT_MAX; idx++)
+						/* Polarity handled by GPIO library */
+						gpiod_set_value_cansleep(spi_get_csgpiod(spi, idx),
+									 activate);
+				}
+			}
+			/* Some SPI masters need both GPIO CS & slave_select */
+			if ((spi->controller->flags & SPI_MASTER_GPIO_SS) &&
+			    spi->controller->set_cs)
+				spi->controller->set_cs(spi, !enable);
+			else if (spi->controller->set_cs)
+				spi->controller->set_cs(spi, !enable);
+		}
 
-	if (spi_get_csgpiod(spi, 0)) {
-		if (!(spi->mode & SPI_NO_CS)) {
-			/*
-			 * Historically ACPI has no means of the GPIO polarity and
-			 * thus the SPISerialBus() resource defines it on the per-chip
-			 * basis. In order to avoid a chain of negations, the GPIO
-			 * polarity is considered being Active High. Even for the cases
-			 * when _DSD() is involved (in the updated versions of ACPI)
-			 * the GPIO CS polarity must be defined Active High to avoid
-			 * ambiguity. That's why we use enable, that takes SPI_CS_HIGH
-			 * into account.
-			 */
-			if (has_acpi_companion(&spi->dev))
-				gpiod_set_value_cansleep(spi_get_csgpiod(spi, 0), !enable);
-			else
-				/* Polarity handled by GPIO library */
-				gpiod_set_value_cansleep(spi_get_csgpiod(spi, 0), activate);
+		for (idx = 0; idx < SPI_CS_CNT_MAX; idx++) {
+			if (spi_get_csgpiod(spi, idx) || !spi->controller->set_cs_timing) {
+				if (activate)
+					spi_delay_exec(&spi->cs_setup, NULL);
+				else
+					spi_delay_exec(&spi->cs_inactive, NULL);
+			}
 		}
-		/* Some SPI masters need both GPIO CS & slave_select */
-		if ((spi->controller->flags & SPI_MASTER_GPIO_SS) &&
-		    spi->controller->set_cs)
+	} else {
+		/*
+		 * Avoid calling into the driver (or doing delays) if the chip select
+		 * isn't actually changing from the last time this was called.
+		 */
+		if (!force && ((enable && spi->controller->last_cs ==
+				spi_get_chipselect(spi, cs_num)) ||
+				(!enable && spi->controller->last_cs !=
+				 spi_get_chipselect(spi, cs_num))) &&
+		    (spi->controller->last_cs_mode_high ==
+		     (spi->mode & SPI_CS_HIGH)))
+			return;
+
+		trace_spi_set_cs(spi, activate);
+
+		spi->controller->last_cs = enable ? spi_get_chipselect(spi, cs_num) : -1;
+		spi->controller->last_cs_mode_high = spi->mode & SPI_CS_HIGH;
+
+		if ((spi_get_csgpiod(spi, cs_num) || !spi->controller->set_cs_timing) && !activate)
+			spi_delay_exec(&spi->cs_hold, NULL);
+
+		if (spi->mode & SPI_CS_HIGH)
+			enable = !enable;
+
+		if (spi_get_csgpiod(spi, cs_num)) {
+			if (!(spi->mode & SPI_NO_CS)) {
+				/*
+				 * Historically ACPI has no means of the GPIO polarity and
+				 * thus the SPISerialBus() resource defines it on the per-chip
+				 * basis. In order to avoid a chain of negations, the GPIO
+				 * polarity is considered being Active High. Even for the cases
+				 * when _DSD() is involved (in the updated versions of ACPI)
+				 * the GPIO CS polarity must be defined Active High to avoid
+				 * ambiguity. That's why we use enable, that takes SPI_CS_HIGH
+				 * into account.
+				 */
+				if (has_acpi_companion(&spi->dev))
+					gpiod_set_value_cansleep(spi_get_csgpiod(spi, cs_num),
+								 !enable);
+				else
+					/* Polarity handled by GPIO library */
+					gpiod_set_value_cansleep(spi_get_csgpiod(spi, cs_num),
+								 activate);
+			}
+			/* Some SPI masters need both GPIO CS & slave_select */
+			if ((spi->controller->flags & SPI_MASTER_GPIO_SS) &&
+			    spi->controller->set_cs)
+				spi->controller->set_cs(spi, !enable);
+		} else if (spi->controller->set_cs) {
 			spi->controller->set_cs(spi, !enable);
-	} else if (spi->controller->set_cs) {
-		spi->controller->set_cs(spi, !enable);
-	}
+		}
 
-	if (spi_get_csgpiod(spi, 0) || !spi->controller->set_cs_timing) {
-		if (activate)
-			spi_delay_exec(&spi->cs_setup, NULL);
-		else
-			spi_delay_exec(&spi->cs_inactive, NULL);
+		if (spi_get_csgpiod(spi, cs_num) || !spi->controller->set_cs_timing) {
+			if (activate)
+				spi_delay_exec(&spi->cs_setup, NULL);
+			else
+				spi_delay_exec(&spi->cs_inactive, NULL);
+		}
 	}
 }
 
@@ -2222,9 +2290,9 @@ void spi_flush_queue(struct spi_controller *ctlr)
 static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 			   struct device_node *nc)
 {
-	u32 value;
+	u32 value, cs[SPI_CS_CNT_MAX] = {0};
 	u16 cs_setup;
-	int rc;
+	int rc, idx;
 
 	/* Mode (clock phase/polarity/etc.) */
 	if (of_property_read_bool(nc, "spi-cpha"))
@@ -2297,13 +2365,21 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 	}
 
 	/* Device address */
-	rc = of_property_read_u32(nc, "reg", &value);
-	if (rc) {
+	rc = of_property_read_variable_u32_array(nc, "reg", &cs[0], 1,
+						 SPI_CS_CNT_MAX);
+	if (rc < 0 || rc > ctlr->num_chipselect) {
 		dev_err(&ctlr->dev, "%pOF has no valid 'reg' property (%d)\n",
 			nc, rc);
 		return rc;
+	} else if ((of_property_read_bool(nc, "parallel-memories")) &&
+		   (!ctlr->multi_cs_cap)) {
+		dev_err(&ctlr->dev, "SPI controller doesn't support multi CS\n");
+		return -EINVAL;
 	}
-	spi_set_chipselect(spi, 0, value);
+	for (idx = 0; idx < rc; idx++)
+		spi_set_chipselect(spi, idx, cs[idx]);
+	/* By default set the spi->cs_index_mask as 1 */
+	spi->cs_index_mask = 0x01;
 
 	/* Device speed */
 	if (!of_property_read_u32(nc, "spi-max-frequency", &value))
@@ -3824,6 +3900,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 	struct spi_controller *ctlr = spi->controller;
 	struct spi_transfer *xfer;
 	int w_size;
+	u32 cs_num = __ffs(spi->cs_index_mask);
 
 	if (list_empty(&message->transfers))
 		return -EINVAL;
@@ -3836,7 +3913,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 	 * cs_change is set for each transfer.
 	 */
 	if ((spi->mode & SPI_CS_WORD) && (!(ctlr->mode_bits & SPI_CS_WORD) ||
-					  spi_get_csgpiod(spi, 0))) {
+					  spi_get_csgpiod(spi, cs_num))) {
 		size_t maxsize;
 		int ret;
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 9b23a1d0dd0d..a73cbbda006e 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -19,6 +19,11 @@
 #include <linux/acpi.h>
 #include <linux/u64_stats_sync.h>
 
+/* Max no. of CS supported per spi device */
+#define SPI_CS_CNT_MAX 2
+
+/* chip select mask */
+#define SPI_PARALLEL_CS_MASK	(BIT(0) | BIT(1))
 struct dma_chan;
 struct software_node;
 struct ptp_system_timestamp;
@@ -163,6 +168,7 @@ extern int spi_delay_exec(struct spi_delay *_delay, struct spi_transfer *xfer);
  *	deasserted. If @cs_change_delay is used from @spi_transfer, then the
  *	two delays will be added up.
  * @pcpu_statistics: statistics for the spi_device
+ * @cs_index_mask: Bit mask of the active chipselect(s) in the chipselect array
  *
  * A @spi_device is used to interchange data between an SPI slave
  * (usually a discrete chip) and CPU memory.
@@ -178,7 +184,7 @@ struct spi_device {
 	struct spi_controller	*controller;
 	struct spi_controller	*master;	/* Compatibility layer */
 	u32			max_speed_hz;
-	u8			chip_select;
+	u8			chip_select[SPI_CS_CNT_MAX];
 	u8			bits_per_word;
 	bool			rt;
 #define SPI_NO_TX	BIT(31)		/* No transmit wire */
@@ -199,7 +205,7 @@ struct spi_device {
 	void			*controller_data;
 	char			modalias[SPI_NAME_SIZE];
 	const char		*driver_override;
-	struct gpio_desc	*cs_gpiod;	/* Chip select gpio desc */
+	struct gpio_desc	*cs_gpiod[SPI_CS_CNT_MAX];	/* Chip select gpio desc */
 	struct spi_delay	word_delay; /* Inter-word delay */
 	/* CS delays */
 	struct spi_delay	cs_setup;
@@ -209,6 +215,13 @@ struct spi_device {
 	/* The statistics */
 	struct spi_statistics __percpu	*pcpu_statistics;
 
+	/* Bit mask of the chipselect(s) that the driver need to use from
+	 * the chipselect array.When the controller is capable to handle
+	 * multiple chip selects & memories are connected in parallel
+	 * then more than one bit need to be set in cs_index_mask.
+	 */
+	u32			cs_index_mask : 2;
+
 	/*
 	 * likely need more hooks for more protocol options affecting how
 	 * the controller talks to each chip, like:
@@ -265,22 +278,22 @@ static inline void *spi_get_drvdata(struct spi_device *spi)
 
 static inline u8 spi_get_chipselect(struct spi_device *spi, u8 idx)
 {
-	return spi->chip_select;
+	return spi->chip_select[idx];
 }
 
 static inline void spi_set_chipselect(struct spi_device *spi, u8 idx, u8 chipselect)
 {
-	spi->chip_select = chipselect;
+	spi->chip_select[idx] = chipselect;
 }
 
 static inline struct gpio_desc *spi_get_csgpiod(struct spi_device *spi, u8 idx)
 {
-	return spi->cs_gpiod;
+	return spi->cs_gpiod[idx];
 }
 
 static inline void spi_set_csgpiod(struct spi_device *spi, u8 idx, struct gpio_desc *csgpiod)
 {
-	spi->cs_gpiod = csgpiod;
+	spi->cs_gpiod[idx] = csgpiod;
 }
 
 struct spi_message;
@@ -387,6 +400,8 @@ extern struct spi_device *spi_new_ancillary_device(struct spi_device *spi, u8 ch
  * @bus_lock_spinlock: spinlock for SPI bus locking
  * @bus_lock_mutex: mutex for exclusion of multiple callers
  * @bus_lock_flag: indicates that the SPI bus is locked for exclusive use
+ * @multi_cs_cap: indicates that the SPI Controller can assert/de-assert
+ *	more than one chip select at once.
  * @setup: updates the device mode and clocking records used by a
  *	device's SPI controller; protocol code may call this.  This
  *	must fail if an unrecognized or unsupported mode is requested.
@@ -584,6 +599,13 @@ struct spi_controller {
 	/* Flag indicating that the SPI bus is locked for exclusive use */
 	bool			bus_lock_flag;
 
+	/*
+	 * Flag indicating that the spi-controller has multi chip select
+	 * capability and can assert/de-assert more than one chip select
+	 * at once.
+	 */
+	bool			multi_cs_cap;
+
 	/* Setup mode and clock, etc (spi driver may call many times).
 	 *
 	 * IMPORTANT:  this may be called when transfers to another
-- 
2.17.1

