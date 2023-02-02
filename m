Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DB96881E7
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjBBP0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjBBP0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:26:00 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BF574C06;
        Thu,  2 Feb 2023 07:25:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KudGelhf1MaohGrKEzg0aPBN2+o4OMn2R7jA3ZUb/EZc+0FX88FM/8Zwkfj8R/fkDd3HX4UJYCUtqRCgwmLFQyaPrEcCipHMK2Yn65VnHCS/Fld2oqjo+f0kcrtOJ5933yQjqfW/poq7uCSe1vfdyhSq6xcBCwn1kjtXXeP/ts4mmvCs9mK/pRnud5AvLXYoH/YWQiYGsA7A9jkGPu5EvxVnyRHj932F5OEGNvsFOYjQAHkyySFuhN8yLroTF9LIizx7TxL/hNpVez016c10KLUkKU1Y1ufcki6PEEQPbrnVrNgUzKrWgSi1PEYDvH3C8HMRVuIPGpwcIbhexPLHzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/Yet+5rsiDfnRUIoBGZ5uihYT2ozvs6P0wK1Jad2Yk=;
 b=QV1MS/SwcLxuCtUuHgJlY4VBIuI5hHeHzKbZcctSFDiihvtWat6GG8AB8R59fqnUfqZ1D1IsPqkQhm+/+3OOCbWiqmPIUFh+eoUgIf+sAvOk9er9TAjBC1ksIAipc75mX4hs1CVAYyKN9mewGbbPwuqZlXZg3j6gnNVzG3qgklKz3wjIJpaITEnhRq6oQuaWkJdFwaBXMv7u4mn/xKUActBhI6qpd21eV0Pb4dDlMQpgOiMKjgRHPlVwQE36lR3042KbmEBreDaJL0HuHGQ0TvTW6PQj30MOy5mP2IIE9RoHicLTHyOnTxQ1DpXjaKBvj3ThOCle0SzKbzOUpY53sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/Yet+5rsiDfnRUIoBGZ5uihYT2ozvs6P0wK1Jad2Yk=;
 b=fpqYhLS1s1hriaFtqhNC2tynHJKKywVWRo//yentynKogFD2Bc2K5QhHOLV4AXtrZERTO0sJxQo7VHMlZxADjylZQWRQYlTIQkMCMOnh8SHerYoJmFd2i3bjDcY9/awOxMJcIiHTMXXvIR7lEC2kdvKczEa2ESTlZPgx4Vh3rdU=
Received: from BLAPR03CA0140.namprd03.prod.outlook.com (2603:10b6:208:32e::25)
 by MW4PR12MB7311.namprd12.prod.outlook.com (2603:10b6:303:227::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Thu, 2 Feb
 2023 15:24:59 +0000
Received: from BL02EPF000108E8.namprd05.prod.outlook.com
 (2603:10b6:208:32e:cafe::7b) by BLAPR03CA0140.outlook.office365.com
 (2603:10b6:208:32e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 15:24:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108E8.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.17 via Frontend Transport; Thu, 2 Feb 2023 15:24:58 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:24:58 -0600
Received: from xhdsgoud40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 2 Feb 2023 09:24:35 -0600
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
        <kvalo@kernel.org>
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
        <amitrkcian2002@gmail.com>,
        "Amit Kumar Mahapatra" <amit.kumar-mahapatra@amd.com>
Subject: [PATCH v3 04/13] mtd: devices: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Thu, 2 Feb 2023 20:52:49 +0530
Message-ID: <20230202152258.512973-5-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
References: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E8:EE_|MW4PR12MB7311:EE_
X-MS-Office365-Filtering-Correlation-Id: 077c7516-519c-4344-f049-08db0531a571
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KgOiwqJNo5ghjC9sKDzaP4ps7koNW2gA7VdQTwnmhaK2mHRet085+ClPrdlmIQGNg7ND9DdYlbQw06TA/wPp/XBf2hJmKcNTpWa0FtztYt7IpjW2QnAiPWFaPWuO03AOwa2CxNLmMIP6xFmg7Gw3zZdwVumCDNFC+OVEt/5O7O+ZXOO5StfI/U0O+xnwWfNGtZa4MERN7ybcJJHb6y3MwAco/L3Xw8fhP6ZJ5GWGyua+fam7q0vkARm0ROClA9Dzi7nYf/VZA/i4eUViJgw+Wuz3aU91prKREe3xMYz8PyUlMDEyIM+LYFPGIYFvTvmuQ1rQXjik2G4o0bBZ2okkKNsdkFINHsufbWHUGaQ3wvDjRem6DFQu3c3Gi2an96ympSyOBuj9t1Gthv97ZazPL0QPIRqYXe+Tj8by1/PNh2H63BGphrTOt+35SvRbORpi4ijw5kY/EBOGw/zsyzUBPbNmyT+7v3krkhKpl+fcZv9qnrIsFulXgL9jGOydKivBytvbK3PHqrIS93962aKczOxo0SOAbSQqECTlLGr77dh+JCprKLkVUMc0z6myS+z8fZbNnVpS373sIenR8sucyJGstxHwfp0/Q3D095xF3VBRdyurOTG3WP+qTGZWr/weOVgBUytejxq9Y8S92qntKchpgJccGH0jw8wJa6YwhD+Ttst+cH7w7qdiCQLv7JvvoScDbYXa36JFET4GvYGwtiEMuDOUmuexC/cKetcIZmq1KFPwBtWZYOPZYi3tSjQcBhRw4Ncb2sDYKKTQhQhpYpTekI4SyEz3kPVCcC9+Vuv4XolCgmoPNdXI3PCN0kpjD7P4DMsgc+l9v9HvWbZ/dT1391Plfm/3KemORBD1llWUNaY2GkGTMglDq8YUiz+L
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(478600001)(7366002)(7276002)(7336002)(7406005)(7416002)(5660300002)(41300700001)(86362001)(36860700001)(81166007)(82740400003)(8936002)(356005)(921005)(2906002)(2616005)(336012)(40480700001)(36756003)(40460700003)(83380400001)(70586007)(70206006)(82310400005)(8676002)(4326008)(54906003)(110136005)(47076005)(426003)(316002)(6666004)(1076003)(26005)(186003)(36900700001)(41080700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 15:24:58.8738
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 077c7516-519c-4344-f049-08db0531a571
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7311
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
Reviewed-by: Michal Simek <michal.simek@amd.com>
---
 drivers/mtd/devices/mtd_dataflash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 25bad4318305..34d7a0c4807b 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -646,7 +646,7 @@ static int add_dataflash_otp(struct spi_device *spi, char *name, int nr_pages,
 
 	/* name must be usable with cmdlinepart */
 	sprintf(priv->name, "spi%d.%d-%s",
-			spi->master->bus_num, spi->chip_select,
+			spi->master->bus_num, spi_get_chipselect(spi, 0),
 			name);
 
 	device = &priv->mtd;
-- 
2.25.1

