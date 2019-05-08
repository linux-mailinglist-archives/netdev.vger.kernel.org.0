Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15253177D6
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfEHLaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:30:07 -0400
Received: from mail-eopbgr720075.outbound.protection.outlook.com ([40.107.72.75]:63520
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727660AbfEHLaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjcT89AhZdKkG8M5isLXr+VAVcRFhlBYogTm1g/4pg8=;
 b=q7IP+9NQa5EDYubf+Njn1bcwKqmHVEVEGwgvxF4CCCebgPyhKgL87yUmH6oKqvITyTy7ly7BzqJF9CuibfYxh1CD7eVrjMoC5DQyzQjqpnGGsZvQUhXfV78CE1aOuzWdCyhisJf3G2Zqgl4Qabaoo9JYILLYMMWBWRQ5g29Xp+w=
Received: from MWHPR03CA0049.namprd03.prod.outlook.com (2603:10b6:301:3b::38)
 by MWHPR03MB3134.namprd03.prod.outlook.com (2603:10b6:301:3c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.11; Wed, 8 May
 2019 11:29:57 +0000
Received: from BL2NAM02FT003.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by MWHPR03CA0049.outlook.office365.com
 (2603:10b6:301:3b::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.21 via Frontend
 Transport; Wed, 8 May 2019 11:29:57 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT003.mail.protection.outlook.com (10.152.76.204) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:29:56 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x48BTu06023698
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:29:56 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:29:56 -0400
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
Subject: [PATCH 07/16] device connection: use new match_string() helper/macro
Date:   Wed, 8 May 2019 14:28:33 +0300
Message-ID: <20190508112842.11654-9-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(346002)(396003)(136003)(376002)(39860400002)(2980300002)(199004)(189003)(36756003)(50226002)(246002)(47776003)(8936002)(8676002)(2906002)(48376002)(70586007)(76176011)(54906003)(4326008)(106002)(70206006)(86362001)(51416003)(2201001)(107886003)(14444005)(316002)(110136005)(16586007)(7696005)(486006)(11346002)(53416004)(126002)(476003)(2616005)(446003)(44832011)(2441003)(50466002)(7636002)(305945005)(7416002)(6666004)(426003)(186003)(5660300002)(336012)(478600001)(77096007)(1076003)(356004)(26005)(921003)(83996005)(1121003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR03MB3134;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91c3809a-bbd8-4770-1064-08d6d3a87fc5
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:MWHPR03MB3134;
X-MS-TrafficTypeDiagnostic: MWHPR03MB3134:
X-Microsoft-Antispam-PRVS: <MWHPR03MB3134ADED8AEA2DE87EDA3597F9320@MWHPR03MB3134.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: vPHqUyoLZcW0hVOhWn9GTqMZTbShobrGD2/ViAb1u/5/xckKY/lz+Bdz9sVMaISB5ZX+9BzGInurLqmM2FwjifOIAfCaB8oBwVzIS8pCv9hhyB42Iq3xXxptH5PZSBgO+M5i2dwNxoYHH/OfZkBJA5ivGIM3gJVbqng57UMMXQ2w+fpSmMh4cSgClNCxo8N5onzhk1RNY/exNSfBdSN+Djs9KjT6E9pvBp/NmRaLYmuLC6ZT+yMJ9koDYkjHuyWAEmz0HO0dNrjGBmAXW52KixyJ8drIdiD8EfBe6ovS9H4IykWVZ+zhpPAJrX7aE7bNhPgAj6OIz76YE9VndH2HHEjnLTtm3qOeMcvAav+dbYvG6K++r8veVFChlLmcP/tySHd8yyqVyS0HojCmo6O6IxxBOqhu4D25Gwq0FyInxLU=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:29:56.9840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c3809a-bbd8-4770-1064-08d6d3a87fc5
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR03MB3134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `device_connection` struct is defined as:
struct device_connection {
        struct fwnode_handle    *fwnode;
        const char              *endpoint[2];
        const char              *id;
        struct list_head        list;
};

The `endpoint` member is a static array of strings (on the struct), so
using the match_string() (which does an ARRAY_SIZE((con->endpoint)) should
be fine.

The recent change to match_string() (to ignore NULL entries up to the size
of the array) shouldn't affect this.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/base/devcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/devcon.c b/drivers/base/devcon.c
index 7bc1c619b721..4a2338665585 100644
--- a/drivers/base/devcon.c
+++ b/drivers/base/devcon.c
@@ -70,7 +70,7 @@ void *device_connection_find_match(struct device *dev, const char *con_id,
 	mutex_lock(&devcon_lock);
 
 	list_for_each_entry(con, &devcon_list, list) {
-		ep = __match_string(con->endpoint, 2, devname);
+		ep = match_string(con->endpoint, devname);
 		if (ep < 0)
 			continue;
 
-- 
2.17.1

