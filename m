Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EF96926FE
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjBJTmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbjBJTmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:42:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA93461D04;
        Fri, 10 Feb 2023 11:41:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfOL+X5KnFkqsSseBez1yZ4Ndnwx/ZNKRe2v2GA9HvCyr68jRZPbbtk3dPdsaHAcpMXMVbsvMEL4CzxS4gz4m3JoIMhDAZ5i2XFZIcV7Cq89P6F+6P9ZtAV8OXSGEHfvqgyrv2sYyxckHNSkMtdU4mlcYNY4Kp1zUzi+uHeosxOTz0s8thV9vzZJhyrvYBpFmy6vuaap8Z5uB+jhHJfAotENWJqdvng/5pwmOp3b48O1rUR6PO0hoNxbGdLYGI5Qp0FBgQulPIbgjlzpPSs+gNoHsaREEzLw2WfxRMlYgT9W6XSyQ0VyqSJY33RG9PdCQKhtBAB+fcmk3QwjSDk/8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNYJPkJ8aaPK5awYxnsnKWkYB0u9T5qlqGRNHD3pdtg=;
 b=GgOZKzsY6v5949+oo/XJ0udt8Ft0T0J7Nxwvtx/cvlSRPfJHu2Ogv0ve2n7Qb2AnjKwrgGIn+OeSpUW2aICLArh+iB3jcxWvBkyDErKbL+CDPhSEINVg2GkPh2oZpPxpgCqVbnwIsqkYZ7Gxeq8HQOqQPNTMenoZaA9vujhdDUCTVeqJfKBN1+lp4FP/2dgOZwzsXYCpozEVLzTbNsMpFrhN4V7qbE/pogmWcpND4yY+J4X2pj45dkOslKvNm3VNRq5IfiahtL5HwC4QUKdbJuEQAVM+ReI1S8xRXYnpDJUFYmKkLZPCFCfBRo2pkDnR6zCVh+bBSoSyQzpXZ6kj/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNYJPkJ8aaPK5awYxnsnKWkYB0u9T5qlqGRNHD3pdtg=;
 b=k6gysIUrOabAOtawbYI76piuiG9oPp8FgLpedvyM+KF57BnSRnK347sb2TUZ1uHBEzl65UzfmzV3+iO2Qu9Lt7vuhgzhZJc9kKXUFPOEQKCvXn/J6VEa4NNTJVhswRJkv4mLSuDe/EqYRmVZ0VfnwBcRGa50GZvguCMGPXAPNAQ=
Received: from MW4PR04CA0176.namprd04.prod.outlook.com (2603:10b6:303:85::31)
 by BL0PR12MB4945.namprd12.prod.outlook.com (2603:10b6:208:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 19:40:50 +0000
Received: from CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::91) by MW4PR04CA0176.outlook.office365.com
 (2603:10b6:303:85::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19 via Frontend
 Transport; Fri, 10 Feb 2023 19:40:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT074.mail.protection.outlook.com (10.13.174.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.21 via Frontend Transport; Fri, 10 Feb 2023 19:40:50 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 13:40:49 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 13:40:48 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 13:40:22 -0600
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
Subject: [PATCH v4 08/15] ALSA: hda: cs35l41: Replace all spi->chip_select references with function call
Date:   Sat, 11 Feb 2023 01:06:39 +0530
Message-ID: <20230210193647.4159467-9-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
References: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT074:EE_|BL0PR12MB4945:EE_
X-MS-Office365-Filtering-Correlation-Id: c43fac58-e4c8-4b0e-6be0-08db0b9eb6c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpebiUL1vPcu5q68CE5AL2AY1AcAoutuwH8kethpGNz1Cb+FpBNoMBtAXnm4HZsYUdegrvSimHeSn85gS7gYK9jpIT1dV2SirB2sNp2ktUQqcqcQT6kAVbAethmJEG0Z1rloIQVw2n0FPpxP5tTRFKFISNTiOg0aPpzcUnwdZfkWvBm5ZNvw2+4I5iLAlDZZ06c3wGTZP61enqj9OWf2PoWsEIn77+T0phNrzlPNsnT3xCmEGT2l8W+hthu35mZzNx0U5rVYEtJ/eyO9B9xA7Fvcv7Sfz4DLqkNM2ZrXink13hpPWykodG99Uort2wN1tTnBsJBViH/H+2rO2VbELEEH34R3dkk/EtjqDL4R1+3b2LuKDfRydl1EIviuG6GKq41+DnHJVGONoA4hgNyaUoliYprcJhKmJupb2aEZHmVeUuuwLpCyqpp3zhIWTDRCYgSh60NwNJAGo6Myufx5LsN0QxXwtLCO1JitZ+61kvTlGeHXKi0Cznh+geNAyUZHaCZbC7eXBw30FVRFqNl2BpgLGvIW1KCsq7vMCnoYcI4EMnDYiDs2nuLkJ2W/I5uvF/femKeA8lhgv/BKzoRgCafjAWqLGY6GDULQcj8TLZ/MjUa7Khnr9zvkM+qRlRzJEQ7mnS1ZOiJ3L5BTccApFTTQMpXAr78CWc5PdleM7mysdjXohWp6GDyIB/7zwsdCPKSWAGZlX6Gh4720fjuCnqDOVirOp577nlg294HWwjyt3gXge7KFPJ/6RAJU1eAkvP0dp+gFchIIwwvDPLkCMkASFYZMQIMSVATnyDqDxnTLr0OkDaoHevBMzDfqKVu5Fhl4gncJZnJGvc9+h7X1NBD0HtbE/1ajCzH4fwjzbrA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(83380400001)(36860700001)(2906002)(921005)(356005)(36756003)(86362001)(82310400005)(5660300002)(7416002)(7276002)(7336002)(41300700001)(8936002)(40480700001)(1191002)(4326008)(81166007)(186003)(40460700003)(47076005)(110136005)(8676002)(2616005)(426003)(70206006)(336012)(54906003)(6666004)(316002)(26005)(1076003)(70586007)(478600001)(7406005)(7366002)(41080700001)(36900700001)(83996005)(2101003)(84006005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:40:50.0115
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c43fac58-e4c8-4b0e-6be0-08db0b9eb6c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4945
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
 sound/pci/hda/cs35l41_hda_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/cs35l41_hda_spi.c b/sound/pci/hda/cs35l41_hda_spi.c
index 71979cfb4d7e..eb287aa5f782 100644
--- a/sound/pci/hda/cs35l41_hda_spi.c
+++ b/sound/pci/hda/cs35l41_hda_spi.c
@@ -25,7 +25,7 @@ static int cs35l41_hda_spi_probe(struct spi_device *spi)
 	else
 		return -ENODEV;
 
-	return cs35l41_hda_probe(&spi->dev, device_name, spi->chip_select, spi->irq,
+	return cs35l41_hda_probe(&spi->dev, device_name, spi_get_chipselect(spi, 0), spi->irq,
 				 devm_regmap_init_spi(spi, &cs35l41_regmap_spi));
 }
 
-- 
2.25.1

