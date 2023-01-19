Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E152D674167
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjASSzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjASSy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:54:56 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A25795172;
        Thu, 19 Jan 2023 10:54:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gwg0QyHOzbekXGsK+ngFjfMaDaGjNEB8KQ1Pta+C39YAiUWYlq4fZOrD7OCipfkeA/o+HQFswYKaHuhrqI7r0Sy7vaknJByn1RWECWxRB6xqz4uVGhOz+lfq1hOKxAt0eR+BMkpieAv6Xeqn5YPkAl+Ww1wf1q3Q+gR+OHA9YEkG2GVqJ5kZOK4jBNOu7P0EoeDFuBiWLRZFbp9qtWgvELlF9v317b+4I9ZdIx4eBGEg0aqOfUqrU0wpgHHmLr+ok39GyGbPf9U3zRsnxDrSQetBDqbNKb8a/7HDIFijzaeACD03sbPG7/TAOtNS62QRx5Ti3mTHL7nKQSG1GNnayA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8O8xdl2eBOQ+XziSVLk4BszyM0SozzlHpkpul91Ha4=;
 b=WZRv+bkAJ5M/yG+uI3FoPSC4CeV8qQBlr977gYy/M2l96HOj+G/1IvNix9OXJBd38psgeLnxzeBIh3kRJ0N7GyVKW0UilUZogauMJkqXjFpIPafOH61luS5LmoW6vQasi3khtgZy9MWlv/vEW3uWZo5L1ANtG0Nv5btW1Zg1eZ7COx35HCH9P8mbxNhr0wjkO2Oq9I+7O4oVPReCKFcjRo5aY8wneYtFBLqHmrFWQW+EVIZ7x2Pi5Y1dClK9HNFb2jh9tHW49LYVl0KPXzmDSxxiL7VMw53fGGRZJ7EUM2nZBB/hONqbiOzWQ7vSUnxxHmmKK9eF8xlKqQ5hhmsUUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8O8xdl2eBOQ+XziSVLk4BszyM0SozzlHpkpul91Ha4=;
 b=vLPQP2cYAUAlFXsq4W/5gHnLE4v/UsPa2nfq3uYGriRC+z5oMDTIT1+jGn+uAPPamteE6ts+gJziFIBtDHO8MJIBI3Qvt8tZ/mxz0SlUN62XzGy1oRL2ZkeDHWRp9zcFw0F2vozS3v71IHhZFYXYNkIZh4kKlSmsGitnihjmzOg=
Received: from MW2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:907::15) by
 DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.25; Thu, 19 Jan 2023 18:54:39 +0000
Received: from CO1PEPF00001A64.namprd05.prod.outlook.com
 (2603:10b6:907:0:cafe::22) by MW2PR16CA0002.outlook.office365.com
 (2603:10b6:907::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 18:54:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF00001A64.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Thu, 19 Jan 2023 18:54:39 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 12:54:35 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 10:54:34 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 12:54:09 -0600
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
Subject: [PATCH v2 01/13] spi: Add APIs in spi core to set/get spi->chip_select and spi->cs_gpiod
Date:   Fri, 20 Jan 2023 00:23:30 +0530
Message-ID: <20230119185342.2093323-2-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A64:EE_|DS0PR12MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: b667f0dc-2f09-4427-8469-08dafa4e9e12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSpdVEkFJct8iHK7TDDlDtdTyyB5TP3eb2C+hCxP0Y30z+eb+wnSYKsfGXDE21RIRP8g0lBu/vi+cImBz2LNrb5NUfdl5om2y1mxdPV9jrSW4bLh5M5XO0T1b05iWSp9m9zwkdsm4t+iH9HG4edkgpoQRfEWxXzqBdhNXkipMvUS8AGJuBhzsnb/6WgLoJ04C3BfaVeT0Ib8e+GsG7EaPndHJxwmtoJ3wsCr8kY97qQVWbhNkAq9F5dQCOpYE2TdxusWti2c+0XUIl3pkaR9pVsxNkWhZQW0MD2XfDZzcfdzVc8uXDtZZsANDya+gGRsVqtjl6jzusId1t91rQpnuLyECAKvHu7Rdw+Q8VdfNDjATmdc7nYXIGvWcT/CvIWfJd6xJTVI1XmLiad1V0u+gpY5ROIsgsJpzu2pXfYGAY5YLyrRkT2oU1nzkxboSpaZe/DgB+2UlK7xqc6x7VdRetNSYLSI+jKyiWn1FpJWOBnJuA5ABsXJ+91h4B2Y4NLL4nuqwKqSrREV+L0WrG4FbbRTqIWUravrs0tgMV2SLrw87JUOmplYkju26qKkE/07Yk7HLhHfsAFaSbd8ihs3UThOSaOOhsx3rNd9rT1NPsIZ34rN+eUINGMvRUpec0Q+buPj3jkD4fKOHrRf6gNrubupUiKw/kMq8+a3FpAyluAhZSYL8/x9zz93tYr0pc9sThKAMdpSsN6O8gGhfERshLOneT4dhcsiByLpGJC0kpwNSnMl9Ie2GeswQ/ZzFoxwMu+NQBUtB3fhaz91i8rNDKAzOgYfO16GIncCOILgRO8MjGny4xlBBQEkIFkHCsywwod73HsfvuFjZg8Jel9XFbpB3VrkQsCVnRNKHgOhySw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199015)(40470700004)(36840700001)(46966006)(86362001)(81166007)(26005)(921005)(356005)(7366002)(41300700001)(7416002)(7336002)(1191002)(7406005)(5660300002)(7276002)(8936002)(40460700003)(82740400003)(36860700001)(36756003)(186003)(110136005)(54906003)(83380400001)(6666004)(478600001)(8676002)(4326008)(70206006)(316002)(70586007)(82310400005)(2906002)(336012)(1076003)(40480700001)(47076005)(426003)(2616005)(36900700001)(2101003)(83996005)(84006005)(41080700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:54:39.0565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b667f0dc-2f09-4427-8469-08dafa4e9e12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A64.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6439
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supporting multi-cs in spi core and spi controller drivers would require
the chip_select & cs_gpiod members of struct spi_device to be an array.
But changing the type of these members to array would break the spi driver
functionality. To make the transition smoother introduced four new APIs to
get/set the spi->chip_select & spi->cs_gpiod and replaced all
spi->chip_select and spi->cs_gpiod references in spi core with the API
calls.
While adding multi-cs support in further patches the chip_select & cs_gpiod
members of the spi_device structure would be converted to arrays & the
"idx" parameter of the APIs would be used as array index i.e.,
spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/spi/spi.c       | 45 ++++++++++++++++++++---------------------
 include/linux/spi/spi.h | 20 ++++++++++++++++++
 2 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 3cc7bb4d03de..38421e831a7d 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -604,7 +604,7 @@ static void spi_dev_set_name(struct spi_device *spi)
 	}
 
 	dev_set_name(&spi->dev, "%s.%u", dev_name(&spi->controller->dev),
-		     spi->chip_select);
+		     spi_get_chipselect(spi, 0));
 }
 
 static int spi_dev_check(struct device *dev, void *data)
@@ -613,7 +613,7 @@ static int spi_dev_check(struct device *dev, void *data)
 	struct spi_device *new_spi = data;
 
 	if (spi->controller == new_spi->controller &&
-	    spi->chip_select == new_spi->chip_select)
+	    spi_get_chipselect(spi, 0) == spi_get_chipselect(new_spi, 0))
 		return -EBUSY;
 	return 0;
 }
@@ -638,7 +638,7 @@ static int __spi_add_device(struct spi_device *spi)
 	status = bus_for_each_dev(&spi_bus_type, NULL, spi, spi_dev_check);
 	if (status) {
 		dev_err(dev, "chipselect %d already in use\n",
-				spi->chip_select);
+				spi_get_chipselect(spi, 0));
 		return status;
 	}
 
@@ -649,7 +649,7 @@ static int __spi_add_device(struct spi_device *spi)
 	}
 
 	if (ctlr->cs_gpiods)
-		spi->cs_gpiod = ctlr->cs_gpiods[spi->chip_select];
+		spi_set_csgpiod(spi, 0, ctlr->cs_gpiods[spi_get_chipselect(spi, 0)]);
 
 	/*
 	 * Drivers may modify this initial i/o setup, but will
@@ -692,8 +692,8 @@ int spi_add_device(struct spi_device *spi)
 	int status;
 
 	/* Chipselects are numbered 0..max; validate. */
-	if (spi->chip_select >= ctlr->num_chipselect) {
-		dev_err(dev, "cs%d >= max %d\n", spi->chip_select,
+	if (spi_get_chipselect(spi, 0) >= ctlr->num_chipselect) {
+		dev_err(dev, "cs%d >= max %d\n", spi_get_chipselect(spi, 0),
 			ctlr->num_chipselect);
 		return -EINVAL;
 	}
@@ -714,8 +714,8 @@ static int spi_add_device_locked(struct spi_device *spi)
 	struct device *dev = ctlr->dev.parent;
 
 	/* Chipselects are numbered 0..max; validate. */
-	if (spi->chip_select >= ctlr->num_chipselect) {
-		dev_err(dev, "cs%d >= max %d\n", spi->chip_select,
+	if (spi_get_chipselect(spi, 0) >= ctlr->num_chipselect) {
+		dev_err(dev, "cs%d >= max %d\n", spi_get_chipselect(spi, 0),
 			ctlr->num_chipselect);
 		return -EINVAL;
 	}
@@ -761,7 +761,7 @@ struct spi_device *spi_new_device(struct spi_controller *ctlr,
 
 	WARN_ON(strlen(chip->modalias) >= sizeof(proxy->modalias));
 
-	proxy->chip_select = chip->chip_select;
+	spi_set_chipselect(proxy, 0, chip->chip_select);
 	proxy->max_speed_hz = chip->max_speed_hz;
 	proxy->mode = chip->mode;
 	proxy->irq = chip->irq;
@@ -970,24 +970,23 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 	 * Avoid calling into the driver (or doing delays) if the chip select
 	 * isn't actually changing from the last time this was called.
 	 */
-	if (!force && ((enable && spi->controller->last_cs == spi->chip_select) ||
-				(!enable && spi->controller->last_cs != spi->chip_select)) &&
+	if (!force && ((enable && spi->controller->last_cs == spi_get_chipselect(spi, 0)) ||
+		       (!enable && spi->controller->last_cs != spi_get_chipselect(spi, 0))) &&
 	    (spi->controller->last_cs_mode_high == (spi->mode & SPI_CS_HIGH)))
 		return;
 
 	trace_spi_set_cs(spi, activate);
 
-	spi->controller->last_cs = enable ? spi->chip_select : -1;
+	spi->controller->last_cs = enable ? spi_get_chipselect(spi, 0) : -1;
 	spi->controller->last_cs_mode_high = spi->mode & SPI_CS_HIGH;
 
-	if ((spi->cs_gpiod || !spi->controller->set_cs_timing) && !activate) {
+	if ((spi_get_csgpiod(spi, 0) || !spi->controller->set_cs_timing) && !activate)
 		spi_delay_exec(&spi->cs_hold, NULL);
-	}
 
 	if (spi->mode & SPI_CS_HIGH)
 		enable = !enable;
 
-	if (spi->cs_gpiod) {
+	if (spi_get_csgpiod(spi, 0)) {
 		if (!(spi->mode & SPI_NO_CS)) {
 			/*
 			 * Historically ACPI has no means of the GPIO polarity and
@@ -1000,10 +999,10 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 			 * into account.
 			 */
 			if (has_acpi_companion(&spi->dev))
-				gpiod_set_value_cansleep(spi->cs_gpiod, !enable);
+				gpiod_set_value_cansleep(spi_get_csgpiod(spi, 0), !enable);
 			else
 				/* Polarity handled by GPIO library */
-				gpiod_set_value_cansleep(spi->cs_gpiod, activate);
+				gpiod_set_value_cansleep(spi_get_csgpiod(spi, 0), activate);
 		}
 		/* Some SPI masters need both GPIO CS & slave_select */
 		if ((spi->controller->flags & SPI_MASTER_GPIO_SS) &&
@@ -1013,7 +1012,7 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
 		spi->controller->set_cs(spi, !enable);
 	}
 
-	if (spi->cs_gpiod || !spi->controller->set_cs_timing) {
+	if (spi_get_csgpiod(spi, 0) || !spi->controller->set_cs_timing) {
 		if (activate)
 			spi_delay_exec(&spi->cs_setup, NULL);
 		else
@@ -2304,7 +2303,7 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 			nc, rc);
 		return rc;
 	}
-	spi->chip_select = value;
+	spi_set_chipselect(spi, 0, value);
 
 	/* Device speed */
 	if (!of_property_read_u32(nc, "spi-max-frequency", &value))
@@ -2423,7 +2422,7 @@ struct spi_device *spi_new_ancillary_device(struct spi_device *spi,
 	strscpy(ancillary->modalias, "dummy", sizeof(ancillary->modalias));
 
 	/* Use provided chip-select for ancillary device */
-	ancillary->chip_select = chip_select;
+	spi_set_chipselect(ancillary, 0, chip_select);
 
 	/* Take over SPI mode/speed from SPI main device */
 	ancillary->max_speed_hz = spi->max_speed_hz;
@@ -2670,7 +2669,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
 	spi->mode		|= lookup.mode;
 	spi->irq		= lookup.irq;
 	spi->bits_per_word	= lookup.bits_per_word;
-	spi->chip_select	= lookup.chip_select;
+	spi_set_chipselect(spi, 0, lookup.chip_select);
 
 	return spi;
 }
@@ -3632,7 +3631,7 @@ static int spi_set_cs_timing(struct spi_device *spi)
 	struct device *parent = spi->controller->dev.parent;
 	int status = 0;
 
-	if (spi->controller->set_cs_timing && !spi->cs_gpiod) {
+	if (spi->controller->set_cs_timing && !spi_get_csgpiod(spi, 0)) {
 		if (spi->controller->auto_runtime_pm) {
 			status = pm_runtime_get_sync(parent);
 			if (status < 0) {
@@ -3837,7 +3836,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 	 * cs_change is set for each transfer.
 	 */
 	if ((spi->mode & SPI_CS_WORD) && (!(ctlr->mode_bits & SPI_CS_WORD) ||
-					  spi->cs_gpiod)) {
+					  spi_get_csgpiod(spi, 0))) {
 		size_t maxsize;
 		int ret;
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 9a32495fbb1f..9b23a1d0dd0d 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -263,6 +263,26 @@ static inline void *spi_get_drvdata(struct spi_device *spi)
 	return dev_get_drvdata(&spi->dev);
 }
 
+static inline u8 spi_get_chipselect(struct spi_device *spi, u8 idx)
+{
+	return spi->chip_select;
+}
+
+static inline void spi_set_chipselect(struct spi_device *spi, u8 idx, u8 chipselect)
+{
+	spi->chip_select = chipselect;
+}
+
+static inline struct gpio_desc *spi_get_csgpiod(struct spi_device *spi, u8 idx)
+{
+	return spi->cs_gpiod;
+}
+
+static inline void spi_set_csgpiod(struct spi_device *spi, u8 idx, struct gpio_desc *csgpiod)
+{
+	spi->cs_gpiod = csgpiod;
+}
+
 struct spi_message;
 
 /**
-- 
2.17.1

