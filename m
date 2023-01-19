Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48766741A2
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjASS6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjASS53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:57:29 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2072.outbound.protection.outlook.com [40.107.101.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5850259E57;
        Thu, 19 Jan 2023 10:56:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhSLEZH1ceddKbKeb7a21dLX306uFsmtSa+JwqSrt3DvzD5asW8NfdnB1rqVt6mRMdfjHj/9L9X5YONPFTlBvmpxzjJsb8JrN43KONLqj8K3WxFxRFTsAc/fGe5wijVH0n/fjfYinB9CDfB9ylCljLEnmrtXQxSwuffuOmNUKVA6EJA9UxzdOfuGTkpOxEhnS1Vd5F8oPGDQ8JfWgMwHsyxri8rV2JRKXF6EZ3xR1eEVYdYOcxT2hEIYoqBRcL+a5XOysfLP185qLP4kTOqCNY8ilfvAVYSPBM9AE6me4VjBHZGXfOlUzQG48Ay1kSRrcuxWlPJXnpSMumDSw+0qcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbpacNubrT0lasDs0WmKpnsl7zP4LIrl3AFONwBPP3E=;
 b=DZY33sOfe7on2f7rz8otoTRVVx1gpy7imVN5nqf++QIgE4yNvT0W7tEayU2IYYUKO0WXYnogrAtFn+oyh29tNy8L+q4o6mhbjo3iRy6vDJD8UJbNHAIFuili4bUqy76GkRhPZOxdu/zP8AkQUI9CAvQRkMBILpVbo+2c8AdlS+OGlgWuf6KME/dvKCPVHDX/rUEK8+XP4uJdnemxEcUe9vN8gwjx2vxwYUetuubNXTiqyrmjVVJ44zl2bsCs2NbPM+xYI6sa8eKU6gnHYrLuHN5rKw3/BgvdlhU3GIGOjwayTk/VieTSN0VJ0p0CF8urNHlKK0p/jteITTGbt3AXyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbpacNubrT0lasDs0WmKpnsl7zP4LIrl3AFONwBPP3E=;
 b=ozrGxRxDg7dtcWJFyBo75toUGZfYx33jcW+ZB165ki2VSO3/I/G6SfTe3gdLE9sK91IZV1WCSO42FkZoz7lSjGrsTytLOyo2qaPNW1JPLziVebVqXVPUAbMqaZI2K1vtLW3/V4VaXt2YKFwCzI2MSQmHeZTl2sGQi9dz4l3oFrk=
Received: from BN9P222CA0014.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::19)
 by DM4PR12MB8497.namprd12.prod.outlook.com (2603:10b6:8:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Thu, 19 Jan
 2023 18:56:45 +0000
Received: from BN8NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::5) by BN9P222CA0014.outlook.office365.com
 (2603:10b6:408:10c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 18:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT103.mail.protection.outlook.com (10.13.176.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 18:56:45 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 12:56:45 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 12:56:44 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 12:56:19 -0600
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
Subject: [PATCH v2 06/13] staging: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Fri, 20 Jan 2023 00:23:35 +0530
Message-ID: <20230119185342.2093323-7-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT103:EE_|DM4PR12MB8497:EE_
X-MS-Office365-Filtering-Correlation-Id: 1820a53f-7933-4fbb-d1d0-08dafa4ee96f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4n93fzqKlKWi1mV2URGd/oKDNjIOB4j4umQ6bKgbhDXqjWd2ozku+b9c5/2KoV/onUaBYqMYa3RA+x+SB9cYdprcGTLO8Z2M0HsO+xnZ42oJhb9DPCQ4/LbCGTRYZuS+2RfGrI/AAhOPouivcGEwioRec8pr5sz5byT1pVYWdjV+2q9Xi4zf4+MhhUW1zyWFP9d+n2mS4Rj18DWhc332KdQvsMHRBp2gw4Vj73YIPe7jlQ16zneNcGIDYoFJOLvg86D021rw44TJkEHbzYJLs5xEPJvHcLkHr4hLPC1GmB8DITfB3u9hPY0Qlv3x0ivQbrh9z3CAPywFGQS07hgMSr8ES3RUcPtF4VOdUMWVTIjbI60MOeStttvaqMnAPffoTXBUWmjpNWMvp14lvP7uIEOIQw03wSMmlnrtwXT+Yd/NLklkaPUu+zm4xcr9bZVGpMLLOaBP8AOxYV+sO/mEtfX6BsoCeaNoe4V792glBdZac2XDpZGwUa4OLJI6SMCqHqPc+KZn9KH7JY+sf29AT/+/oh+gGz17YRiRf2Oc9jZZqATwQKuyLTgp5iNAkwSeVAXiJeJfM7DQCc7BHqiurcuKzCX1I+G3AWYJegaxUaJK7YTuhdWG0VCw8CfsRx3qlIiJT+LNLsw5sWFl8JtwJdCgf5Xus840x27er680AgHZllDsbbWGQOVOKPijZ0LUmHt+t4q6wSUQywEWlNnjd8+2rKWyvWl6h+OI2hb+6pEmo7hUE7BHnBtzLFKoa2427SSW5r+11rs/hDmlVHdFoJUS0Vx+0C/1HtwGIPwrdrd/h2T5QEJwSgJ9fnZIaOGikzGGRhIK5CLTQc4GujLVmMAHXAVUJJWfEa1BCV8EGxA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(86362001)(70206006)(70586007)(40480700001)(478600001)(4326008)(7276002)(5660300002)(7366002)(2616005)(47076005)(8676002)(7416002)(7336002)(7406005)(41300700001)(54906003)(336012)(426003)(83380400001)(110136005)(40460700003)(36756003)(26005)(186003)(82310400005)(8936002)(6666004)(1076003)(356005)(921005)(316002)(81166007)(2906002)(82740400003)(1191002)(36860700001)(41080700001)(2101003)(84006005)(36900700001)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:56:45.5752
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1820a53f-7933-4fbb-d1d0-08dafa4ee96f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supporting multi-cs in spi drivers would require the chip_select & cs_gpiod
members of struct spi_device to be an array. But changing the type of these
members to array would break the spi driver functionality. To make the
transition smoother introduced four new APIs to get/set the
spi->chip_select & spi->cs_gpiod and replaced all spi->chip_select and
spi->cs_gpiod references with get or set API calls.
While adding multi-cs support in further patches the chip_select & cs_gpiod
members of the spi_device structure would be converted to arrays & the
"idx" parameter of the APIs would be used as array index i.e.,
spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/staging/fbtft/fbtft-core.c | 2 +-
 drivers/staging/greybus/spilib.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index afaba94d1d1c..3a4abf3bae40 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -840,7 +840,7 @@ int fbtft_register_framebuffer(struct fb_info *fb_info)
 		sprintf(text1, ", %zu KiB buffer memory", par->txbuf.len >> 10);
 	if (spi)
 		sprintf(text2, ", spi%d.%d at %d MHz", spi->master->bus_num,
-			spi->chip_select, spi->max_speed_hz / 1000000);
+			spi_get_chipselect(spi, 0), spi->max_speed_hz / 1000000);
 	dev_info(fb_info->dev,
 		 "%s frame buffer, %dx%d, %d KiB video memory%s, fps=%lu%s\n",
 		 fb_info->fix.id, fb_info->var.xres, fb_info->var.yres,
diff --git a/drivers/staging/greybus/spilib.c b/drivers/staging/greybus/spilib.c
index ad0700a0bb81..efb3bec58e15 100644
--- a/drivers/staging/greybus/spilib.c
+++ b/drivers/staging/greybus/spilib.c
@@ -237,7 +237,7 @@ static struct gb_operation *gb_spi_operation_create(struct gb_spilib *spi,
 	request = operation->request->payload;
 	request->count = cpu_to_le16(count);
 	request->mode = dev->mode;
-	request->chip_select = dev->chip_select;
+	request->chip_select = spi_get_chipselect(dev, 0);
 
 	gb_xfer = &request->transfers[0];
 	tx_data = gb_xfer + count;	/* place tx data after last gb_xfer */
-- 
2.17.1

