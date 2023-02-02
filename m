Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBCC6881BD
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjBBPXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbjBBPXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:23:32 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0376F738;
        Thu,  2 Feb 2023 07:23:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPjqR+CAbbBXEj4uP79s77U8NOjK1NYbQ7LQPNY4j3IDNtrqCPbiEcJKEcYb1Ogw+bcFrZ3zaRDUL9H6R+ZiCgG1oIDcYx/2eZNmLguAy1y16QwTq20sjhltt2P1+eJV9qJ+88ALHPUyJ3sMzEHxGePNUhX588kfeUCriO9cczsoFz509/dDqMGVnHnciOfGRON5c8qhWpdktx2gSmu6wjLTJhU78NFyWreRmM+sh9My473g3XrMzlsuNjdX7oohXeFcL6v8oqzGKDD0Jo3lAjk5erpbbVqMpl7zo7NUwinYKtHeu8L0j51bT/3ijo3uZD0MifkRcGKrmTyXqlrqWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAdrgk3KyVhnaGF18PzqgBxbw1BjQvL7UPZPp2UbjjY=;
 b=Uv1L5sZBXwrBPIGXY1J9fZAVPUfmEsgw5E5EpRagk4ywQzkAL6rzJjR3FtPlkaYctan/dPMTOt+gE+zZgEJXdnbPWutpccY43/RxqTr6PXiMlBoRjMnA9Yn9wtCt9+ykaZM6u7oN7b0v2D6YGMrm9uRpPK3LP7Picffp1Rfq7nLi+u2IvtIQXg5D9GEjvyONpx05fa9wAIP/esdfmES0xW4S9C8WJBZfAPRR10JyO/TcDeHaTnBrOfsGLoK7DPhVSguaIcNtndVvmxb2wxh1akWcYHIFfXkjkvqP590m0dMLsC2NbikTC4dZDzg0AuYu1PwikE5tGGujkcnJKvILWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAdrgk3KyVhnaGF18PzqgBxbw1BjQvL7UPZPp2UbjjY=;
 b=Ku2sGK+cTW6lGognkYR3NL9pqtjApXF7suy2t0glywjHAJX1BPAJyVuZHVdX6EnLnel8L2eQcc2C53w9Gg7VSW7ToqJi1xGX1lD/pdl41EEXygdaiLNrB6WUdYm5M3G+bOmW02LGMdO4Xq/6N/EKF/TOvoFyJx81c9/Syk6SbkE=
Received: from MW3PR06CA0025.namprd06.prod.outlook.com (2603:10b6:303:2a::30)
 by CY5PR12MB6178.namprd12.prod.outlook.com (2603:10b6:930:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Thu, 2 Feb
 2023 15:23:27 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::c2) by MW3PR06CA0025.outlook.office365.com
 (2603:10b6:303:2a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23 via Frontend
 Transport; Thu, 2 Feb 2023 15:23:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 15:23:25 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:23:24 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:23:23 -0600
Received: from xhdsgoud40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 2 Feb 2023 09:23:00 -0600
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
Subject: [PATCH v3 00/13] spi: Add support for stacked/parallel memories
Date:   Thu, 2 Feb 2023 20:52:45 +0530
Message-ID: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT004:EE_|CY5PR12MB6178:EE_
X-MS-Office365-Filtering-Correlation-Id: e03217f4-f0ab-401f-4c97-08db05316e04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HGoBFrVFE/2Yqra9zYUlLmwedm/NxSqf90KDCExavRhRcFtyXvi+PzZOULOs+pqTo2Xm+A1rm6YTp2qpUlYxPUyw4tKokRlyGA3tMxCX7nMbJW6BSJsUtSZXA8CGWjwFekn/sTnKsDwco6YQf9bcYSWMaP5ypDp/Vxe8XoF0DBl2JEe5zMAbtMBzjXyrNsNKrW2Vtp4xK917rI8KkAmqeCGgRFT8UxTMVoVuA33NOwZ1Q7ca1G8wodyNJTl8D1ttIRRsip+0LOL71krUcxaX07WeoIA5smfTlS0RmhQymkOs+ezpMjxu7NjL624HG40Ov9Gyd4P1Y9/mnhhqUyhnM5oaFSKP44vDohc8cKarQP1YtnMcavPKRiawbH0IF3FFyuC0eVXkrM13E4rbIRuSW/MdXRVp/N+LZ8Hz0mcPveiu4QYsozDiziiwa7Zz9urFjdW1/NHL2r9jEad9yqKlJbIYVeFeFHBfxV4HSHvL9yOKoqoiLFvldft/wk5Eb3JYtznQifBRRKGZYfDeWf3khdqdOl4SOQyC1et5kKaphdBhsG8OU2l9pcyAmkBe/DhOc5QC6Fvf5sqwj2wBlwU3B/1pf/AsRSIoxLVe1FfyJP2Q3ZZd0ENuflQTp66l1eyA6E7ZIsd86O+oD2aLSf4IURLm4itdwlPkw2WrhJs1XfwXdsnckphM6aDumKZ6o0xad/yjGaS/Gujk0MS1Q1GEo18S+IzT0wmTsj6z1EAksj3c31YtZnXMBc5UxCsmQ9FFBDwOzgDy90XC2++DwA7HaZY3HfzlCRIhyEnxE20G/B7ailcQ5/LAXTR+ofzJhsBCZ3lsdNnQkXAtdhfeNkmk+TU0iYuLnXutmJ/prWF33EgcMVYOyW88WSJKD8q1yh32wVw9II8/r26PBmfQEztTLA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199018)(46966006)(40470700004)(36840700001)(356005)(186003)(81166007)(26005)(70586007)(4326008)(921005)(70206006)(1076003)(82310400005)(41300700001)(2616005)(8936002)(6666004)(8676002)(966005)(7366002)(5660300002)(7336002)(7276002)(7416002)(478600001)(86362001)(47076005)(7406005)(316002)(336012)(83380400001)(36756003)(426003)(40460700003)(110136005)(82740400003)(2906002)(54906003)(40480700001)(36860700001)(2101003)(83996005)(36900700001)(41080700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 15:23:25.8494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e03217f4-f0ab-401f-4c97-08db05316e04
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6178
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is in the continuation to the discussions which happened on
'commit f89504300e94 ("spi: Stacked/parallel memories bindings")' for
adding dt-binding support for stacked/parallel memories.

This patch series updated the spi-nor, spi core and the spi drivers
to add stacked and parallel memories support.

The first patch
https://lore.kernel.org/all/20230119185342.2093323-1-amit.kumar-mahapatra@amd.com/ 
of the previous series got applied to 
https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next
But the rest of the patches in the series did not get applied due to merge 
conflict, so send the remaining patches in the series after rebasing it 
on top of for-next branch.
---
BRANCH: for-next

Changes in v3:
- Rebased the patches on top of 
  https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next
- Added a patch to convert spi_nor_otp_region_len(nor) & 
  spi_nor_otp_n_regions(nor) macros into inline functions
- Added Reviewed-by & Acked-by tags
 
Changes in v2:
- Rebased the patches on top of v6.2-rc1
- Created separate patch to add get & set APIs for spi->chip_select &
  spi->cs_gpiod, and replaced all spi->chip_select and spi->cs_gpiod
  references with the API calls.
- Created separate patch to add get & set APIs for nor->params.
---
Amit Kumar Mahapatra (13):
  spi: Replace all spi->chip_select and spi->cs_gpiod references with
    function call
  net: Replace all spi->chip_select and spi->cs_gpiod references with
    function call
  iio: imu: Replace all spi->chip_select and spi->cs_gpiod references
    with function call
  mtd: devices: Replace all spi->chip_select and spi->cs_gpiod
    references with function call
  staging: Replace all spi->chip_select and spi->cs_gpiod references
    with function call
  platform/x86: serial-multi-instantiate: Replace all spi->chip_select
    and spi->cs_gpiod references with function call
  spi: Add stacked and parallel memories support in SPI core
  mtd: spi-nor: Convert macros with inline functions
  mtd: spi-nor: Add APIs to set/get nor->params
  mtd: spi-nor: Add stacked memories support in spi-nor
  spi: spi-zynqmp-gqspi: Add stacked memories support in GQSPI driver
  mtd: spi-nor: Add parallel memories support in spi-nor
  spi: spi-zynqmp-gqspi: Add parallel memories support in GQSPI driver

 drivers/iio/imu/adis16400.c                   |   2 +-
 drivers/mtd/devices/mtd_dataflash.c           |   2 +-
 drivers/mtd/spi-nor/atmel.c                   |  17 +-
 drivers/mtd/spi-nor/core.c                    | 665 +++++++++++++++---
 drivers/mtd/spi-nor/core.h                    |   8 +
 drivers/mtd/spi-nor/debugfs.c                 |   4 +-
 drivers/mtd/spi-nor/gigadevice.c              |   4 +-
 drivers/mtd/spi-nor/issi.c                    |  11 +-
 drivers/mtd/spi-nor/macronix.c                |   6 +-
 drivers/mtd/spi-nor/micron-st.c               |  39 +-
 drivers/mtd/spi-nor/otp.c                     |  48 +-
 drivers/mtd/spi-nor/sfdp.c                    |  29 +-
 drivers/mtd/spi-nor/spansion.c                |  50 +-
 drivers/mtd/spi-nor/sst.c                     |   7 +-
 drivers/mtd/spi-nor/swp.c                     |  22 +-
 drivers/mtd/spi-nor/winbond.c                 |  10 +-
 drivers/mtd/spi-nor/xilinx.c                  |  18 +-
 drivers/net/ethernet/adi/adin1110.c           |   2 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |   2 +-
 drivers/net/ethernet/davicom/dm9051.c         |   2 +-
 drivers/net/ethernet/qualcomm/qca_debug.c     |   2 +-
 drivers/net/ieee802154/ca8210.c               |   2 +-
 drivers/net/wan/slic_ds26522.c                |   2 +-
 .../net/wireless/marvell/libertas/if_spi.c    |   2 +-
 drivers/net/wireless/silabs/wfx/bus_spi.c     |   2 +-
 drivers/net/wireless/st/cw1200/cw1200_spi.c   |   2 +-
 .../platform/x86/serial-multi-instantiate.c   |   3 +-
 drivers/spi/spi-altera-core.c                 |   2 +-
 drivers/spi/spi-amd.c                         |   4 +-
 drivers/spi/spi-ar934x.c                      |   2 +-
 drivers/spi/spi-armada-3700.c                 |   4 +-
 drivers/spi/spi-aspeed-smc.c                  |  13 +-
 drivers/spi/spi-at91-usart.c                  |   2 +-
 drivers/spi/spi-ath79.c                       |   4 +-
 drivers/spi/spi-atmel.c                       |  26 +-
 drivers/spi/spi-au1550.c                      |   4 +-
 drivers/spi/spi-axi-spi-engine.c              |   2 +-
 drivers/spi/spi-bcm-qspi.c                    |  10 +-
 drivers/spi/spi-bcm2835.c                     |  19 +-
 drivers/spi/spi-bcm2835aux.c                  |   4 +-
 drivers/spi/spi-bcm63xx-hsspi.c               |  22 +-
 drivers/spi/spi-bcm63xx.c                     |   2 +-
 drivers/spi/spi-cadence-quadspi.c             |   5 +-
 drivers/spi/spi-cadence-xspi.c                |   4 +-
 drivers/spi/spi-cadence.c                     |   4 +-
 drivers/spi/spi-cavium.c                      |   8 +-
 drivers/spi/spi-coldfire-qspi.c               |   8 +-
 drivers/spi/spi-davinci.c                     |  18 +-
 drivers/spi/spi-dln2.c                        |   6 +-
 drivers/spi/spi-dw-core.c                     |   2 +-
 drivers/spi/spi-dw-mmio.c                     |   4 +-
 drivers/spi/spi-falcon.c                      |   2 +-
 drivers/spi/spi-fsi.c                         |   2 +-
 drivers/spi/spi-fsl-dspi.c                    |  16 +-
 drivers/spi/spi-fsl-espi.c                    |   6 +-
 drivers/spi/spi-fsl-lpspi.c                   |   2 +-
 drivers/spi/spi-fsl-qspi.c                    |   6 +-
 drivers/spi/spi-fsl-spi.c                     |   2 +-
 drivers/spi/spi-geni-qcom.c                   |   6 +-
 drivers/spi/spi-gpio.c                        |   4 +-
 drivers/spi/spi-gxp.c                         |   4 +-
 drivers/spi/spi-hisi-sfc-v3xx.c               |   2 +-
 drivers/spi/spi-img-spfi.c                    |  14 +-
 drivers/spi/spi-imx.c                         |  30 +-
 drivers/spi/spi-ingenic.c                     |   4 +-
 drivers/spi/spi-intel.c                       |   2 +-
 drivers/spi/spi-jcore.c                       |   4 +-
 drivers/spi/spi-lantiq-ssc.c                  |   6 +-
 drivers/spi/spi-mem.c                         |   4 +-
 drivers/spi/spi-meson-spicc.c                 |   2 +-
 drivers/spi/spi-microchip-core.c              |   6 +-
 drivers/spi/spi-mpc512x-psc.c                 |   8 +-
 drivers/spi/spi-mpc52xx.c                     |   2 +-
 drivers/spi/spi-mt65xx.c                      |   6 +-
 drivers/spi/spi-mt7621.c                      |   2 +-
 drivers/spi/spi-mux.c                         |   8 +-
 drivers/spi/spi-mxic.c                        |  10 +-
 drivers/spi/spi-mxs.c                         |   2 +-
 drivers/spi/spi-npcm-fiu.c                    |  20 +-
 drivers/spi/spi-nxp-fspi.c                    |  10 +-
 drivers/spi/spi-omap-100k.c                   |   2 +-
 drivers/spi/spi-omap-uwire.c                  |   8 +-
 drivers/spi/spi-omap2-mcspi.c                 |  24 +-
 drivers/spi/spi-orion.c                       |   4 +-
 drivers/spi/spi-pci1xxxx.c                    |   4 +-
 drivers/spi/spi-pic32-sqi.c                   |   2 +-
 drivers/spi/spi-pic32.c                       |   4 +-
 drivers/spi/spi-pl022.c                       |   4 +-
 drivers/spi/spi-pxa2xx.c                      |   6 +-
 drivers/spi/spi-qcom-qspi.c                   |   2 +-
 drivers/spi/spi-rb4xx.c                       |   2 +-
 drivers/spi/spi-rockchip-sfc.c                |   2 +-
 drivers/spi/spi-rockchip.c                    |  26 +-
 drivers/spi/spi-rspi.c                        |  10 +-
 drivers/spi/spi-s3c64xx.c                     |   2 +-
 drivers/spi/spi-sc18is602.c                   |   4 +-
 drivers/spi/spi-sh-msiof.c                    |   6 +-
 drivers/spi/spi-sh-sci.c                      |   2 +-
 drivers/spi/spi-sifive.c                      |   6 +-
 drivers/spi/spi-sn-f-ospi.c                   |   2 +-
 drivers/spi/spi-st-ssc4.c                     |   2 +-
 drivers/spi/spi-stm32-qspi.c                  |  12 +-
 drivers/spi/spi-sun4i.c                       |   2 +-
 drivers/spi/spi-sun6i.c                       |   2 +-
 drivers/spi/spi-synquacer.c                   |   6 +-
 drivers/spi/spi-tegra114.c                    |  28 +-
 drivers/spi/spi-tegra20-sflash.c              |   2 +-
 drivers/spi/spi-tegra20-slink.c               |   6 +-
 drivers/spi/spi-tegra210-quad.c               |   8 +-
 drivers/spi/spi-ti-qspi.c                     |  16 +-
 drivers/spi/spi-topcliff-pch.c                |   4 +-
 drivers/spi/spi-wpcm-fiu.c                    |  12 +-
 drivers/spi/spi-xcomm.c                       |   2 +-
 drivers/spi/spi-xilinx.c                      |   6 +-
 drivers/spi/spi-xlp.c                         |   4 +-
 drivers/spi/spi-zynq-qspi.c                   |   2 +-
 drivers/spi/spi-zynqmp-gqspi.c                |  58 +-
 drivers/spi/spi.c                             | 213 ++++--
 drivers/spi/spidev.c                          |   6 +-
 drivers/staging/fbtft/fbtft-core.c            |   2 +-
 drivers/staging/greybus/spilib.c              |   2 +-
 include/linux/mtd/spi-nor.h                   |  18 +-
 include/linux/spi/spi.h                       |  34 +-
 include/trace/events/spi.h                    |  10 +-
 124 files changed, 1321 insertions(+), 592 deletions(-)

-- 
2.25.1

