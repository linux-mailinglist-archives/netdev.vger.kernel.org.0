Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB97165AB
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 16:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfEGO3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 10:29:44 -0400
Received: from mail-eopbgr730088.outbound.protection.outlook.com ([40.107.73.88]:55024
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbfEGO3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 10:29:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBkPRWdAZlIekwhrtw3YcEmKI9BYYYetQM6fYt/2t58=;
 b=KW2HMl2SzKvOOO7gPz7I2ZGn2d92oG+Fx7dQ0d+so5zVIBOJdh483jYOTHzlVXqLfQLLT9R2IWkZOPMxDvIYJWQMkkYin5sH9IZ5DAprcMqBU/M50WM9qtaoD7Jq7Oyq0OS4zealMqCn8MhNgxuUymvvytc+cTSXsMtJ5/+7eDc=
Received: from MN2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:208:fc::25)
 by BY5PR02MB6019.namprd02.prod.outlook.com (2603:10b6:a03:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.11; Tue, 7 May
 2019 14:29:39 +0000
Received: from CY1NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::208) by MN2PR02CA0012.outlook.office365.com
 (2603:10b6:208:fc::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1856.10 via Frontend
 Transport; Tue, 7 May 2019 14:29:38 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT037.mail.protection.outlook.com (10.152.75.77) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Tue, 7 May 2019 14:29:38 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hO169-0006ZL-Nn; Tue, 07 May 2019 07:29:37 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hO164-0001Ge-Jw; Tue, 07 May 2019 07:29:32 -0700
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x47ETNve018017;
        Tue, 7 May 2019 07:29:23 -0700
Received: from [172.23.37.92] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hO15v-0001Eq-8b; Tue, 07 May 2019 07:29:23 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <rafalo@cadence.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>
Subject: [PATCH] net: macb: Change interrupt and napi enable order in open
Date:   Tue, 7 May 2019 19:59:10 +0530
Message-ID: <1557239350-4760-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(39850400004)(376002)(396003)(2980300002)(199004)(189003)(50226002)(8676002)(2906002)(8936002)(107886003)(476003)(2616005)(486006)(54906003)(126002)(106002)(81166006)(36756003)(44832011)(4326008)(5660300002)(70586007)(7696005)(51416003)(81156014)(70206006)(2201001)(478600001)(110136005)(6666004)(316002)(26005)(77096007)(36386004)(336012)(16586007)(356004)(47776003)(426003)(305945005)(50466002)(48376002)(14444005)(63266004)(186003)(9786002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR02MB6019;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d14e63e6-13e4-43ec-d928-08d6d2f86f9c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:BY5PR02MB6019;
X-MS-TrafficTypeDiagnostic: BY5PR02MB6019:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <BY5PR02MB6019772A2C2FB69975F0AE00C9310@BY5PR02MB6019.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0030839EEE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: YvJiW4EXI/uSxIA2squLSkkFu/PAaOEUvk8R+1uq8cFx5F80W/hnok+76fEk9wnM82whHX8X5o1aXtbAiwN3mj33Z54JAIChAXaogOO8gv2jo5/hwgdL7t6eIkgoX8R4dUGedakBDkuw6xGirNMMqhTC3pWAnU+18rirGIB2hcglJ4V2GnvO6rQh9LqJrMGy7wXN0kACYYQVud349X9ETadtmImgpiYFSlGsKqGEr7jVKIXe8iM6xnTjfykZETPYT29/tHOp4xATji/nx+fZZgfv0Aa53XOPgph5Mnfba5dfen6LisaYgz92gPqCIi557wU+ZGsHJvUDtAbKfJdQyDkDsuwhCVmBXvuYsEpzZCaBKGU9+6C5DbsTYl/xiHp+jlrUUDDuV8+E2F9aNuhI+gFb5/aLWklN5cRX3Q0nsYQ=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2019 14:29:38.1923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d14e63e6-13e4-43ec-d928-08d6d2f86f9c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current order in open:
-> Enable interrupts (macb_init_hw)
-> Enable NAPI
-> Start PHY

Sequence of RX handling:
-> RX interrupt occurs
-> Interrupt is cleared and interrupt bits disabled in handler
-> NAPI is scheduled
-> In NAPI, RX budget is processed and RX interrupts are re-enabled

With the above, on QEMU or fixed link setups (where PHY state doesn't
matter), there's a chance macb RX interrupt occurs before NAPI is
enabled. This will result in NAPI being scheduled before it is enabled.
Fix this macb open by changing the order.

Fixes: ae1f2a56d273 ("net: macb: Added support for many RX queues")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 5d5c9d7..c049410 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2427,12 +2427,12 @@ static int macb_open(struct net_device *dev)
 		goto pm_exit;
 	}
 
-	bp->macbgem_ops.mog_init_rings(bp);
-	macb_init_hw(bp);
-
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
 		napi_enable(&queue->napi);
 
+	bp->macbgem_ops.mog_init_rings(bp);
+	macb_init_hw(bp);
+
 	/* schedule a link state check */
 	phy_start(dev->phydev);
 
-- 
2.7.4

