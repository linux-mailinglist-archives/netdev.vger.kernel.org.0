Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 067C21783C
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfEHLeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:34:24 -0400
Received: from mail-eopbgr680051.outbound.protection.outlook.com ([40.107.68.51]:58180
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727575AbfEHL3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ej4TvjRJPb880Evlka3jGsq9toPstBngds/H7MSz+98=;
 b=h9DQ+GRsCQDxKqwstM007EbLcpBHqWjQ2MRqXq5cju0OtcgE40K257CUdmKTcLmNiFsVQ8TTUi5HLpjaCc0tXSIxEMkemV6E3tWUguwanL7bPvyn1MHBba2gc+TzvtAMCzfuHmsH9w9p/tFocvXacJIH4a0VqaLEN/p5NINwGK0=
Received: from MWHPR03CA0013.namprd03.prod.outlook.com (10.175.133.151) by
 BN3PR03MB2260.namprd03.prod.outlook.com (10.166.73.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Wed, 8 May 2019 11:29:27 +0000
Received: from BL2NAM02FT056.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by MWHPR03CA0013.outlook.office365.com
 (2603:10b6:300:117::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1856.11 via Frontend
 Transport; Wed, 8 May 2019 11:29:26 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.57)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT056.mail.protection.outlook.com (10.152.77.221) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:29:26 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x48BTPmx016989
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:29:25 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:29:25 -0400
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
Subject: [PATCH 01/16] lib: fix match_string() helper when array size is positive
Date:   Wed, 8 May 2019 14:28:27 +0300
Message-ID: <20190508112842.11654-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(346002)(376002)(39860400002)(396003)(136003)(2980300002)(189003)(199004)(246002)(8676002)(356004)(5660300002)(1076003)(8936002)(50226002)(53416004)(7416002)(305945005)(2441003)(47776003)(478600001)(7636002)(336012)(107886003)(77096007)(4326008)(186003)(446003)(26005)(44832011)(126002)(476003)(2616005)(11346002)(486006)(86362001)(76176011)(7696005)(51416003)(426003)(14444005)(36756003)(2201001)(48376002)(54906003)(70586007)(110136005)(70206006)(16586007)(316002)(50466002)(2906002)(106002)(921003)(2101003)(1121003)(83996005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR03MB2260;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06992cbe-c2a0-450f-a978-08d6d3a86d64
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:BN3PR03MB2260;
X-MS-TrafficTypeDiagnostic: BN3PR03MB2260:
X-Microsoft-Antispam-PRVS: <BN3PR03MB22605D56BDEC0036712171DFF9320@BN3PR03MB2260.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: HMrFOjcKVNRTHDmX1/HvU/gXQlBl+uBSOtcwOD51vWmdyi5ZtZaq4HeTrVqglmQielk1qFJ8dbdhoPs7SBm2gQas++XsjhD055LJSrs5xjRibQaqSBcjHQ44wcFTrBpHBH89k3Ki8Yow3eXIUMpM+NlewIkNIJV3DPQLKY30RuyrOhfh8nkva9n/YB2AL2kQU6YR15UTz29qyv7g67oh8CMTWpMo3frw6vU81LMqNBFZ66OrPeZSiSJAkJBE/bMd3zQC4Hxw9oF5//2KgiJjBZpmuL6vm8U1PSkG8Dxc2tota5ciVE6wTr78/CN6CfJNaW+OzxN0iMIV1Ig8ZSn8zd4ymGDzX2XaqHB1wZ4OfMvmgpNKxP1+GEdfSFMqVRyw0npwgjP2wrgtmFovCAalytU1DI/oSEu8S/98Y5oQHkE=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:29:26.1629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06992cbe-c2a0-450f-a978-08d6d3a86d64
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2260
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation the `_match_string()` helper mentions that `n`
(size of the given array) should be:
 * @n: number of strings in the array or -1 for NULL terminated arrays

The behavior of the function is different, in the sense that it exits on
the first NULL element in the array, regardless of whether `n` is -1 or a
positive number.

This patch changes the behavior, to exit the loop when a NULL element is
found and n == -1. Essentially, this aligns the behavior with the
doc-string.

There are currently many users of `match_string()`, and so, in order to go
through them, the next patches in the series will focus on doing some
cosmetic changes, which are aimed at grouping the users of
`match_string()`.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 lib/string.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index 3ab861c1a857..76edb7bf76cb 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -648,8 +648,11 @@ int match_string(const char * const *array, size_t n, const char *string)
 
 	for (index = 0; index < n; index++) {
 		item = array[index];
-		if (!item)
+		if (!item) {
+			if (n != (size_t)-1)
+				continue;
 			break;
+		}
 		if (!strcmp(item, string))
 			return index;
 	}
-- 
2.17.1

