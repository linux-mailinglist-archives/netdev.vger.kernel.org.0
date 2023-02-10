Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901456926F3
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbjBJTli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbjBJTlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:41:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ED07E03F;
        Fri, 10 Feb 2023 11:41:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORct4fbgq+4ny5d+CTRukNs0q/CsLEQVVqpd6j4pGWdC/ulpg3XwkNWcogU/8FA8xxISnmoKK2CzrpV/sxKHSD4fnVIpXNm3Om5FIsaqR2lBaxvOywSyEVqMmOcGMhXB+532jPpbeMvtqUWse8kktX2Ed4FSJSq1udVjnsCXCUxtW3nprgVyWaZghViEqQqGZbcESTXed/IGD644Ydg/3XIyz8tT3cm//neNepMqps0XcJr0Kn7y2YXzUPZtdn3uAFTv3PsuHb7PV4ZDpiwqMm8Llx8j1opqiD97iCmT1sbSoQ9Btp0EyKzyrWhL/sHLHOnc9UKKscy6NWYvoI10kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3M3Cb03rj/nbO1yn3yzEnhmtHVCZH2EXdqX8XhwSkZA=;
 b=dUg3/eO4u2Kwmi18VT/UuMw4kQJdlAuxeaDKxcO1aTuZt2vcbW5wLDRDhSfmSK+dFSaGJ0Uzu/Yh0C3mnJbfXswsVuCj1E4aKtFUg7+xoeqMMiwDlvfXy0ZT95J4rmy+hJiwpcssp94H12qbo7DqsJ3j7fkdxKWu09pcdNWeAojbGSFEfdfRDREtaYEO8D2B8rq4SajtI9uXMGq58Fw5X3hpsjztx2v7RYjk74eefdwfT1aMmtgeHE+yFCPwVhZRAuENVS8+ohTB7BaM3+kcluuJkNJZ2LT9nHNjirrDVofULenEPTRc1N2A+3fJmuBD2GqxZ9bNRKC4byngzIw74A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3M3Cb03rj/nbO1yn3yzEnhmtHVCZH2EXdqX8XhwSkZA=;
 b=42cA2ZZD68dshLhn3FBHUcHw6oegJzuyNVaioLeCpoRDQC/RZz/SJZYlka3Wf4fd+7DLECJs3TNcBt8/bYuDticJy6KwkHfONxscX2D9jFa2jx36167WPa5sdCK2YfAQQVriQjWzrIsc5SaDT6KWyTHtP1bHQ0fIjUQ4TXuWd+I=
Received: from MN2PR20CA0062.namprd20.prod.outlook.com (2603:10b6:208:235::31)
 by DS0PR12MB6485.namprd12.prod.outlook.com (2603:10b6:8:c6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.17; Fri, 10 Feb 2023 19:40:23 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:235:cafe::41) by MN2PR20CA0062.outlook.office365.com
 (2603:10b6:208:235::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 19:40:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Fri, 10 Feb 2023 19:40:23 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 13:40:22 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 13:40:22 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 13:39:56 -0600
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
        <kvalo@kernel.org>, <james.schulman@cirrus.com>,
        <david.rhodes@cirrus.com>, <tanureal@opensource.cirrus.com>,
        <rf@opensource.cirrus.com>, <perex@perex.cz>, <tiwai@suse.com>,
        <npiggin@gmail.com>, <christophe.leroy@csgroup.eu>,
        <mpe@ellerman.id.au>, <oss@buserror.net>, <windhl@126.com>,
        <yangyingliang@huawei.com>
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
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Subject: [PATCH v4 07/15] powerpc/83xx/mpc832x_rdb: Replace all spi->chip_select references with function call
Date:   Sat, 11 Feb 2023 01:06:38 +0530
Message-ID: <20230210193647.4159467-8-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
References: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|DS0PR12MB6485:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fe34892-1b27-4287-ad47-08db0b9ea6cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZFIz4UjWYO0xug0tnExp29Jcu8aPxlQkDziFV+qWmsYflBMn9Vxlaw1Cfl0fleWFPCxa5Ws4qOYxDjMB5+pqlearLZO3gHegA8kDOWvo/oVsD0CAcMVr6x8jIvonmwR3CHwN4o3mIOl48k5kHda+ad6HNjZq1XuStMbngvmxEWTA/FIzmPpO4Y9H63E4rJn8q3Iq43Se6LVemn3hmA3ZVSFkvw1QGLvZbX3DtaSpeOKGRJmmguJK1/IiF0U6oCws/w3tAw1XrMuDFDkF13xbzNaLh2f7DoFOcqn6i+PsEKm3+9kDC68tCnjvc+tGc8nMh1Oc2zDVn3DfqzExcVt/P7etsiFb3rZxz/YlE+bm3dWY37/Zg5KzMli4YHV2yP6JTnXOuQGpJC8L0P6MtcoD503Di5zCboB2FV1sOA2Ev65U6WTlM4ubENVo19toDw3AJJayz50ZBzTOjZCGH5m0kzphxUTlrtKWePbXDDZBqVQJppuBfucKy9qLUVr5jfiEsVpC+51WyMpubnkS11lIkhD9ASx4SdUjaCm5f6nPKMi9uAkCK4wS570vEwDdtXStxQ2RWnHG4/PGdvtj7xQp9Ub1UefZTPtx1QuHUy4JUy2UoA9pKKlP+5qA+RH/3lljnSYWYH/gvoGAp738ADm2jWG+3OylC2Gmdf3fUVDXNAzEgDhbYaZe4ZpZ7m6IkTzDuGgJbwRvmQQlM9hqzTu2XhkPJjO27EYdnXAHr0/DNNIGs7B8mh1oTXVteX4dFVOL4TX287jAgj3m8xEqLbjBtvo+oF3G+v20r/aykQGBLADRPZg7uaJvZiBriQRepRfN61kJNoyk69HC3l/vea/W+dcTPft1VGPHitWdgfdsSG8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(83380400001)(36860700001)(2906002)(921005)(356005)(36756003)(86362001)(82310400005)(5660300002)(7416002)(7276002)(7336002)(41300700001)(8936002)(40480700001)(1191002)(4326008)(81166007)(186003)(40460700003)(47076005)(110136005)(8676002)(2616005)(426003)(70206006)(336012)(54906003)(6666004)(316002)(26005)(1076003)(70586007)(478600001)(7406005)(7366002)(41080700001)(36900700001)(83996005)(2101003)(84006005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:40:23.1101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe34892-1b27-4287-ad47-08db0b9ea6cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6485
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
---
 arch/powerpc/platforms/83xx/mpc832x_rdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/83xx/mpc832x_rdb.c b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
index caa96edf0e72..4ab1d48cd229 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -144,7 +144,7 @@ static int __init fsl_spi_init(struct spi_board_info *board_infos,
 
 static void mpc83xx_spi_cs_control(struct spi_device *spi, bool on)
 {
-	pr_debug("%s %d %d\n", __func__, spi->chip_select, on);
+	pr_debug("%s %d %d\n", __func__, spi_get_chipselect(spi, 0), on);
 	par_io_data_set(3, 13, on);
 }
 
-- 
2.25.1

