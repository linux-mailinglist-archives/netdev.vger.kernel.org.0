Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E38F6B4EA1
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 18:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjCJRfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 12:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCJRfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 12:35:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC6AF31F0;
        Fri, 10 Mar 2023 09:34:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGnpyLYpSSbnKhKkZHaDMeFceCxDNaOH1FBmKch0Yo6SS5qf1f4fs4S6CNWzhajuWHpW3sQmCkFU57CvRyx2qw55J7iZy2Wfa/06HD5/yg+1csduMU4SQcRmmm5flKIU3Bqk1zEdCkrMaINw1C+U5tk2jRiAJbElUiPnABEfiWtkMRwPngQTq24c+GwzQNkT9vW0oRvqZqErJPUA4ghuoNDmfGsdNhCEHUujzFIhLuVIISPJqUjnTsEd3VmtUbc70o7W9U/R1KU89/FjNZ6kmlDCxJ421+YpR9/Mv4PJZ9Hx8r3aoQCTkm2WeQSBXuvjGE/2f8qOPAELJJ0aTLmooA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGTDv9j62eqAAUbZYCqOwhh6o6pzCwATcSrO/Vzqvog=;
 b=nDdiZGsXMImFPNUTrIcuhQkYs4v09i1Q7G5Fc8TJnyqMV7QgvTaVPMGOSO3cnhiuoeZUFiqrFaHjIqO7Z0Zrb+kOEO8BWI0h3EzW0fkXffHTdGdMXX51mIVqFGQgIjMd9p9K5tBMEXdkTdDlqNG7IwF9JtKiPrqnniF/16AvMwo4cVZt6OsbVrL12TGDIBa/FGdE2L2GO3bhNLSbkDxUyc7YLXrXxUPiZz8ye/wy5dAAZ+dBn2/cMn0g2qP0m1e2Ef2nARjhYVJUBezwM70QijdfBs5xLTfUp+G5Myu6pAEJZbSDK59a+Iwf2yDPLslU+tp8WxexmoXFFIYowh22gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGTDv9j62eqAAUbZYCqOwhh6o6pzCwATcSrO/Vzqvog=;
 b=ywYxtFHuYI3a7wiJBXwoHFW8zHURijvDZVZapy9NHFdCF+9zFZa/9TmluHqKVZs/+9Pq8DYAib7deOUhgscw+YDRoM3k1haJ+ceJ4BLXypiCPu/SHg5tMSXn/TFemK/wf7o+5nAlN4UJDk3YC9zOswwqqZZbVVhtN7UlhIsiMuo=
Received: from DM6PR01CA0030.prod.exchangelabs.com (2603:10b6:5:296::35) by
 BL1PR12MB5224.namprd12.prod.outlook.com (2603:10b6:208:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 17:34:36 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::fe) by DM6PR01CA0030.outlook.office365.com
 (2603:10b6:5:296::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 17:34:35 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.20 via Frontend Transport; Fri, 10 Mar 2023 17:34:35 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 11:34:33 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 09:34:33 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Mar 2023 11:34:06 -0600
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
To:     <broonie@kernel.org>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>,
        <Sanju.Mehta@amd.com>, <chin-ting_kuo@aspeedtech.com>,
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
        <kvalo@kernel.org>, <james.schulman@cirrus.com>,
        <david.rhodes@cirrus.com>, <tanureal@opensource.cirrus.com>,
        <rf@opensource.cirrus.com>, <perex@perex.cz>, <tiwai@suse.com>,
        <npiggin@gmail.com>, <christophe.leroy@csgroup.eu>,
        <mpe@ellerman.id.au>, <oss@buserror.net>, <windhl@126.com>,
        <yangyingliang@huawei.com>, <william.zhang@broadcom.com>,
        <kursad.oney@broadcom.com>, <jonas.gorski@gmail.com>,
        <anand.gore@broadcom.com>, <rafal@milecki.pl>
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
        <ldewangan@nvidia.com>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <michal.simek@amd.com>,
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
        <alsa-devel@alsa-project.org>, <patches@opensource.cirrus.com>,
        <linuxppc-dev@lists.ozlabs.org>, <amitrkcian2002@gmail.com>,
        <amit.kumar-mahapatra@amd.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH V6 03/15] iio: imu: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Fri, 10 Mar 2023 23:02:05 +0530
Message-ID: <20230310173217.3429788-4-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
References: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|BL1PR12MB5224:EE_
X-MS-Office365-Filtering-Correlation-Id: daa8f0e0-27f8-4b28-ca0b-08db218db74e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fzSPlN4fWA9/JhlR+c1dMnXMqVbOtQ3yVwzWxZ6boJ813Nh2jCBJmpdoZw5FV7heOYd88TbhEmc46tT+lfpHe5v+PZT5FLuzvVf6Klab3gdtnUC7axUMFo9uAB7i0EQq5dA0XlbwMu9YklYgVgTGuvN0sRVXc8mChHCxKrjMe6jdwOaqdz1vi8E1JsUW3gTxBzsZtgC4g59pUH4AsI1ae13Rt4gPimtSNRwZrJucgg7jJd68C2pPPEzU4+NKt6MxX0l8QrJJRxiG2SiAfGlYuMyVhoLj8cyL5KUoLN1U9c2R7EreZ+qE7n45i3SeY22YGDb0dmPSKSAGCPc3t/zR+uHLUi8AUXwf0WZ+RUFB79ZjdtJSnBJk9vG9xeZK6pH1QUr5BI7Dr4smak9MIdxfdnzLUXHrRi5a3y57lWvODzMEYq+T8yZQ9lJkHlrD1h9enuhfr0xjvTa5Reo4llsd3JE65r4D8l0gk+9FT39axvrIbqH8u6uuQGgatIDGVK5YuUyS72FMaIi99neGXNgGxWW8qRZzRohGZPZSa9+hUO0MRXce53oosXRKIuE9r73wDJtuR2XgCZKmQQ+/gXsMLYrAEGrKUOkAsf2rZxtumlTsf3G5Eo89Fs8AX626GUR6UaGgZMgmHALGXJ40Su485H8Khz7M9qmO1f2HJPY40CIl8HOrESyQ6YFFt6UyX327SsF92mJZZTZOScC2nFmVF410Qnad4I/8q2UmBTgEDZyJr/FWCAq5jzb12HhesjoDVI8ECP7cbyZ54EcfhSxeZCEmOPtIxPI+kLD/Y+Qhw8YZHWT8E5n0LqfitHa0KDrWNwqnxKTkHXdk8A5e/pW0hzT0b6RAwd4oOHPWehcu0+o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199018)(36840700001)(46966006)(40470700004)(36860700001)(356005)(86362001)(921005)(81166007)(82740400003)(36756003)(2906002)(41300700001)(7276002)(7416002)(7366002)(7336002)(7406005)(8936002)(5660300002)(40460700003)(40480700001)(1191002)(4326008)(82310400005)(63370400001)(186003)(26005)(1076003)(83380400001)(63350400001)(336012)(2616005)(426003)(47076005)(54906003)(316002)(110136005)(70206006)(8676002)(70586007)(478600001)(36900700001)(41080700001)(2101003)(84006005)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:34:35.0994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: daa8f0e0-27f8-4b28-ca0b-08db218db74e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5224
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
---
 drivers/iio/imu/adis16400.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
index c02fc35dceb4..3eda32e12a53 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -466,7 +466,7 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
 
 		dev_info(&indio_dev->dev, "%s: prod_id 0x%04x at CS%d (irq %d)\n",
 			indio_dev->name, prod_id,
-			st->adis.spi->chip_select, st->adis.spi->irq);
+			spi_get_chipselect(st->adis.spi, 0), st->adis.spi->irq);
 	}
 	/* use high spi speed if possible */
 	if (st->variant->flags & ADIS16400_HAS_SLOW_MODE) {
-- 
2.25.1

