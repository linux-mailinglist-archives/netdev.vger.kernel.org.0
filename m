Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D117757C09
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 08:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfF0GVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 02:21:30 -0400
Received: from mail-eopbgr740071.outbound.protection.outlook.com ([40.107.74.71]:19328
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726641AbfF0GVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 02:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juRf0YmxwVJQtRYPcsDYMhmPZUqILA8Nbn2jp67q5VA=;
 b=n4Usiet8/3RNsE4PoOd4PLrwHvklm8k4uihmC1DJVE+XnLi0wVQn+48Q9UWxhIC5XIecP85X8NEbF/s6fl73UjnxWojoDKvw9tq5OhLLP5Drao8fTn5XW74963bY9d4FvdsnzO+abda7ple4i0Jn7heymlBPzXBMBvOgNssHFxg=
Received: from BN6PR02CA0037.namprd02.prod.outlook.com (2603:10b6:404:5f::23)
 by SN1PR02MB3743.namprd02.prod.outlook.com (2603:10b6:802:31::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.16; Thu, 27 Jun
 2019 06:21:27 +0000
Received: from BL2NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by BN6PR02CA0037.outlook.office365.com
 (2603:10b6:404:5f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2008.16 via Frontend
 Transport; Thu, 27 Jun 2019 06:21:27 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT011.mail.protection.outlook.com (10.152.77.5) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2032.15
 via Frontend Transport; Thu, 27 Jun 2019 06:21:26 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hgNmg-00038M-4C; Wed, 26 Jun 2019 23:21:26 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hgNma-0007qs-5C; Wed, 26 Jun 2019 23:21:20 -0700
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x5R6LCMI010740;
        Wed, 26 Jun 2019 23:21:12 -0700
Received: from [172.23.37.92] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hgNmR-0007mn-Av; Wed, 26 Jun 2019 23:21:11 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        richardcochran@gmail.com, claudiu.beznea@microchip.com,
        rafalo@cadence.com, andrei.pistirica@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH 2/2] net: macb: Fix SUBNS increment and increase resolution
Date:   Thu, 27 Jun 2019 11:51:00 +0530
Message-Id: <1561616460-32439-3-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561616460-32439-1-git-send-email-harini.katakam@xilinx.com>
References: <1561616460-32439-1-git-send-email-harini.katakam@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(346002)(396003)(2980300002)(199004)(189003)(446003)(16586007)(316002)(47776003)(426003)(48376002)(63266004)(77096007)(5660300002)(26005)(9786002)(126002)(8936002)(2906002)(50226002)(356004)(6666004)(51416003)(81166006)(478600001)(4326008)(44832011)(336012)(107886003)(476003)(81156014)(8676002)(486006)(76176011)(36756003)(11346002)(70586007)(106002)(305945005)(186003)(50466002)(70206006)(36386004)(14444005)(7696005)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR02MB3743;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b92dcfd-7f64-4d0d-f82b-08d6fac7af74
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN1PR02MB3743;
X-MS-TrafficTypeDiagnostic: SN1PR02MB3743:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <SN1PR02MB374376F2C36B0FD344806184C9FD0@SN1PR02MB3743.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 008184426E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: QK1SGimbvl/zgJbT/xBkcrScdeuYAhSDlFDgo1FcpCqIeX2ztn4vTdRr7ZISeIKGN4w/gashKB6F9kHTe/XPK7olF8PMEasyFLaxOhIn+GhkJxyCNTnxfHHVc//2wLACxEDDMXAqG5c4ss8p+UvJrHM/vBf2xaNsBp7Qwus72z+epf9CIrFYI3YC6WnNm/EIEFa4Qr3T7OM+wWYYVA+5RhhHpdMImzHd4e7TBWOGigzAJUx3f/3DxfT3ohod0HZlZa8/iIRt21c8HzQ2tuI2jD3kBZNh5S6TPQ02pb/Vcg6dbTGBBFmlbWAXN2HLuymD6djxWlT+pDBGD3WvkKS3bf88ZcymO2X/LYzPnrHRCAELfMnFjE8eTnYEWMhpng5T+OXi1kf9ZxMYVbOgrJm97rSjdBZplnjjSUaug+f2134=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2019 06:21:26.6886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b92dcfd-7f64-4d0d-f82b-08d6fac7af74
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR02MB3743
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subns increment register has 24 bits as follows:
RegBit[15:0] = Subns[23:8]; RegBit[31:24] = Subns[7:0]

Fix the same in the driver and increase sub ns resolution to the
best capable, 24 bits. This should be the case on all GEM versions
that this PTP driver supports.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
 drivers/net/ethernet/cadence/macb.h     | 6 +++++-
 drivers/net/ethernet/cadence/macb_ptp.c | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 90bc70b..03983bd 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -496,7 +496,11 @@
 
 /* Bitfields in TISUBN */
 #define GEM_SUBNSINCR_OFFSET			0
-#define GEM_SUBNSINCR_SIZE			16
+#define GEM_SUBNSINCRL_OFFSET			24
+#define GEM_SUBNSINCRL_SIZE			8
+#define GEM_SUBNSINCRH_OFFSET			0
+#define GEM_SUBNSINCRH_SIZE			16
+#define GEM_SUBNSINCR_SIZE			24
 
 /* Bitfields in TI */
 #define GEM_NSINCR_OFFSET			0
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 6276eac..43a3f0d 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -104,7 +104,10 @@ static int gem_tsu_incr_set(struct macb *bp, struct tsu_incr *incr_spec)
 	 * to take effect.
 	 */
 	spin_lock_irqsave(&bp->tsu_clk_lock, flags);
-	gem_writel(bp, TISUBN, GEM_BF(SUBNSINCR, incr_spec->sub_ns));
+	/* RegBit[15:0] = Subns[23:8]; RegBit[31:24] = Subns[7:0] */
+	gem_writel(bp, TISUBN, GEM_BF(SUBNSINCRL, incr_spec->sub_ns) |
+		   GEM_BF(SUBNSINCRH, (incr_spec->sub_ns >>
+			  GEM_SUBNSINCRL_SIZE)));
 	gem_writel(bp, TI, GEM_BF(NSINCR, incr_spec->ns));
 	spin_unlock_irqrestore(&bp->tsu_clk_lock, flags);
 
-- 
2.7.4

