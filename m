Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E283C6ACA17
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCFR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjCFR0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:26:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980D967028;
        Mon,  6 Mar 2023 09:25:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qii9Fo9sIj8ztSq74xIx9izh4U+72RNm/6VAWIX12KvbAxSViwJ8krZV6dGlF/I7o3BEapKx9LTIAbulbssCkiGj9q1czTbRNRvfi3jBgG7LKnLveRuTu4tlXPcxiD3LvGMdJ1TepAnq7T3cEUonSy6trIGKQc8K5GI99xamuXg2At909ErpPr38/lS2mwdbM91EfhrZIdtelwr9gLH3pjLWIDCwkZngxPhaoq0bac7PpXGC0SdNsKZXvYLYKUR2rCGgV5RydURUE04dkGqdtUeUIpaF4iCyogm1vAlXCxfebGV9cJ6XhsMcKucGAL96Z2KtpEgL6L4V8uvpyrqKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3M3Cb03rj/nbO1yn3yzEnhmtHVCZH2EXdqX8XhwSkZA=;
 b=AhWlh/2sF0MBbf+m2pxpmV9EMG1hYfOgWeaiwcMhyip+VIbBi+9laS8gxw87mBX5wmljy62DCmuLcQvTPinUur+ua1x6D+ZowVZnlgfCIL1xLLMg+1cas/8xlE1HHRE2avVu1ceSAdjD5/+1NgIZtPvTCwIWUerdASbN04idUWpjxCvhSNi0U0fN+IVpxnupjiW0znLp8DFvWrlJYx6yVrkaf89UKZMRp3aKAx0pTErWQ1rLyrhprYol0zZ3kswJ+F/FVh+9vBUIsx3fXcV/pNY1QA4c1XqApWUphjBS7lK9RtXWxPW/oA8Yoiv42uIzdXZ5mqt61B3f5T/fF26xIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3M3Cb03rj/nbO1yn3yzEnhmtHVCZH2EXdqX8XhwSkZA=;
 b=06xXfuzrT+GMR4J/BagtpVJpPrEX8NAbiFuU8jYxc9Jt6TJUe01ZoVy9GG3n80F6Csmi4f9u296sOy9K6Ly/zhBOHYJj8rQS4tv8369iUoyPjcPjaoH5L5ZoKVZalUQ0EI7qn8Mt06X84HdrYPWvyLbZOlrdQ/4cVxlGl4EUn+c=
Received: from BN9PR03CA0917.namprd03.prod.outlook.com (2603:10b6:408:107::22)
 by PH7PR12MB8155.namprd12.prod.outlook.com (2603:10b6:510:2b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Mon, 6 Mar
 2023 17:25:13 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::11) by BN9PR03CA0917.outlook.office365.com
 (2603:10b6:408:107::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27 via Frontend
 Transport; Mon, 6 Mar 2023 17:25:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.15 via Frontend Transport; Mon, 6 Mar 2023 17:25:13 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 11:25:12 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 6 Mar 2023 11:24:45 -0600
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
        <amit.kumar-mahapatra@amd.com>
Subject: [PATCH V5 07/15] powerpc/83xx/mpc832x_rdb: Replace all spi->chip_select references with function call
Date:   Mon, 6 Mar 2023 22:51:01 +0530
Message-ID: <20230306172109.595464-8-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
References: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT045:EE_|PH7PR12MB8155:EE_
X-MS-Office365-Filtering-Correlation-Id: 1537cbf0-0c77-4281-2019-08db1e67beba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ClrZL3mq4MiDm/KQrQWyRr7xwycSL454yU35XAFJVx2GmOYnWphJieXBmmn/jvC8iOoIGcV3cSP1fiUADV3s+8MGk1ZxGIyMbBSoUPw2TRRkspbhSSY+bQLdNjNVTMfHunsiAYRDko3pgTiJRAw8lQgge7jNRgpLGpQr2T+mMlXmh3s1m8L6zDX5SgkqJRkt+3STH+kgLr4DpESKhAKGuQLtF/WMr08VUq+ayZN6ZYxIyQxsBjQTTjZsfjbwqkEtyVzAtskQZBW8ovuID5xBwf/VvXf3FSOdxy3DagqCRNg2e2lHMEzfGJ29MGzm0RoEJavCog3s5nZ4mg1aFh/p2Kab3ABk+7tuJVCP0O1js9UoeIFc4GHTLzSeuPKDKTyu/0Goh2f8g4WtY4blZ/1rUSkc/BupmktRoja8BljlRRqJvYEvhhUe8w94eG8ak8fnUY5IDT7iJXmsu9q2EmPw/QHm1VaemdVIjMsbPO9GFz7rJ0+zonXerEa/xeBYpZw1DuFpa6i0QX+8vKYWgXTRa5B2H6b1UEqo1UR501dc1rrtWkLlIdLigs3eJjjmsjtxsoRokq9Efapdi9nrVvp8iEmxSaLbP2F50yWmE1zEC/PpLryTaA3dH4qlGgLLA2isytYYc+e1v1jljK5wAuFjKboBkww0z8gXwTX6oH2eWRwHMUSwMR+4pnIY/TXsDsJ/TskLaPu8RtpTJG3SFMYsEpMVBuel1a1mUcadlcaPsBwEyZZXRd6W9npSb6kzKUI6TfvRvHIAj9nkUP03J1FrOybEe6IgJqwxNNShcQI2HVKTKkAbZSeE3Uk9bHL+JeyfKreZK1YgpZl57xvddtZ08iYNTrPJdqQtlE/IjFNZxr8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199018)(40470700004)(36840700001)(46966006)(1191002)(478600001)(36860700001)(6666004)(47076005)(83380400001)(426003)(82310400005)(36756003)(40460700003)(356005)(110136005)(82740400003)(921005)(54906003)(316002)(1076003)(186003)(26005)(336012)(5660300002)(2616005)(41300700001)(7276002)(8676002)(81166007)(7416002)(7366002)(7336002)(70586007)(7406005)(86362001)(8936002)(70206006)(40480700001)(4326008)(2906002)(36900700001)(2101003)(83996005)(84006005)(41080700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:25:13.1828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1537cbf0-0c77-4281-2019-08db1e67beba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8155
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

