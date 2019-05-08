Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576F517714
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfEHLaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:30:19 -0400
Received: from mail-eopbgr820072.outbound.protection.outlook.com ([40.107.82.72]:10944
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727887AbfEHLaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:30:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2kUTxOBDW7W13uwOdmuJPQDQWhKkMs+dI0VfMHNhcs=;
 b=HmsHAFljmcbaN1BpAlIGHCpGcJ5jk39AUEqf/6w5Fch3rgS9LrOHdDkTRid4twIc316F2MrfuNLVkUGQ1NWLbgumQMbITyYa+XILsOarTTI+P/wjFyGQgnt0YjzNFAD0f6jVnTLQ0U3CRal0YHtfYbnJ7fVybRtPPhSGo+MDAbc=
Received: from BN3PR03CA0078.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::38) by CO2PR03MB2262.namprd03.prod.outlook.com
 (2603:10b6:102:e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.11; Wed, 8 May
 2019 11:30:10 +0000
Received: from CY1NAM02FT020.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by BN3PR03CA0078.outlook.office365.com
 (2a01:111:e400:7a4d::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1856.11 via Frontend
 Transport; Wed, 8 May 2019 11:30:09 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT020.mail.protection.outlook.com (10.152.75.191) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:30:07 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x48BU7gu023733
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:30:07 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:30:06 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-rockchip@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-omap@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-usb@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <alsa-devel@alsa-project.org>
CC:     <gregkh@linuxfoundation.org>, <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 09/16] mmc: sdhci-xenon: use new match_string() helper/macro
Date:   Wed, 8 May 2019 14:28:35 +0300
Message-ID: <20190508112842.11654-11-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(396003)(39860400002)(376002)(346002)(136003)(2980300002)(189003)(199004)(356004)(6666004)(36756003)(5660300002)(50466002)(48376002)(2616005)(126002)(426003)(336012)(107886003)(51416003)(44832011)(2906002)(47776003)(486006)(2201001)(4326008)(476003)(11346002)(446003)(86362001)(76176011)(26005)(16586007)(246002)(478600001)(2441003)(50226002)(53416004)(1076003)(7696005)(70586007)(70206006)(7636002)(305945005)(7416002)(106002)(77096007)(8676002)(316002)(186003)(110136005)(8936002)(54906003)(921003)(83996005)(1121003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR03MB2262;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8666f1cf-9df3-40da-2f35-08d6d3a88708
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:CO2PR03MB2262;
X-MS-TrafficTypeDiagnostic: CO2PR03MB2262:
X-Microsoft-Antispam-PRVS: <CO2PR03MB226289536B8045C7EF017BB5F9320@CO2PR03MB2262.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 7rCCvmL00MJBmcDTDIesTQyTH/FNWfXEsju68ENrTwxg/JIcze2MSJ12BbCQi4KSrgLnc1A1T6oXYLKYxlqmijCkcIwNL4E9xzrBeXjIFArc3gJbJYEsik3rWIiMQrmNac8NKVSXbLpB/o4OjBebxyfuuKkkNtQJJAndo0715UIZuDMc1ZdvuMrceL8LElXSfQiRCtrBNnkB/KWkSmtT8hsShWBcIskk5FP30zXoYxV/z2dgb6eFA53PQRv7N/xDDavBCp9yNUm4NynSE3PGnYKIawmDQ1m2K8VQatJsc8AN1TyPmq9PF1A8pLI6egBZrXN35GHe2/ZpHJhBxPEZoVlVwSfSUS96GPx1sw2lCVmgt88RgJFlddOoDGa3f1+TOqJw2fXL5R0yGXI+tAlczYBs61mJT3hH1NvT9TI8S+8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:30:07.6794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8666f1cf-9df3-40da-2f35-08d6d3a88708
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR03MB2262
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The change is also cosmetic, but it also does a tighter coupling between
the enums & the string values. This way, the ARRAY_SIZE(phy_types) that is
implicitly done in the match_string() macro is also a bit safer.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/mmc/host/sdhci-xenon-phy.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/sdhci-xenon-phy.c b/drivers/mmc/host/sdhci-xenon-phy.c
index 59b7a6cac995..2a9206867fe1 100644
--- a/drivers/mmc/host/sdhci-xenon-phy.c
+++ b/drivers/mmc/host/sdhci-xenon-phy.c
@@ -135,17 +135,17 @@ struct xenon_emmc_phy_regs {
 	u32 logic_timing_val;
 };
 
-static const char * const phy_types[] = {
-	"emmc 5.0 phy",
-	"emmc 5.1 phy"
-};
-
 enum xenon_phy_type_enum {
 	EMMC_5_0_PHY,
 	EMMC_5_1_PHY,
 	NR_PHY_TYPES
 };
 
+static const char * const phy_types[NR_PHY_TYPES] = {
+	[EMMC_5_0_PHY] = "emmc 5.0 phy",
+	[EMMC_5_1_PHY] = "emmc 5.1 phy"
+};
+
 enum soc_pad_ctrl_type {
 	SOC_PAD_SD,
 	SOC_PAD_FIXED_1_8V,
@@ -821,7 +821,7 @@ static int xenon_add_phy(struct device_node *np, struct sdhci_host *host,
 	struct xenon_priv *priv = sdhci_pltfm_priv(pltfm_host);
 	int ret;
 
-	priv->phy_type = __match_string(phy_types, NR_PHY_TYPES, phy_name);
+	priv->phy_type = match_string(phy_types, phy_name);
 	if (priv->phy_type < 0) {
 		dev_err(mmc_dev(host->mmc),
 			"Unable to determine PHY name %s. Use default eMMC 5.1 PHY\n",
-- 
2.17.1

