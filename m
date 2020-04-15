Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D181AA051
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 14:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369214AbgDOMZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 08:25:27 -0400
Received: from mail-vi1eur05on2056.outbound.protection.outlook.com ([40.107.21.56]:30848
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393963AbgDOMZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 08:25:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjYSxH/Jhrb48hDXpu4jXnWsgRADEYwqNvSYLi/t7hBB7aFg8rmwNVmGFr3oRSU///eZMyHRSYel3UIOFHhrtEyUlSLVJ+nhvrI7gTPP43jqJvwWsUyQk/io7XGlUuER0NyxwkpSYOWuYtlo9/iQTzW55fpQkj19ZPj0pB4wTdZ5CX+jhoQZx5S432dF6v/MQSHR6EZ6pyMuSUDePxLrBauqqWp4pqDhW+3t+6HTe5v2x+1oW2Aehc5qXmw0XwkvFg9a49UAE9VsT8e+Ma8zzrh/UH4XgXfGiJzqW6XxpMovOkHaaMPqzGr/XNPwsy6S5sWQ8j0MOLow1x0nvH8nDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYeFNtnkvU1qFshr/Iw5VAqPCiQPFhNBOGhyOQO9oM0=;
 b=GnCOE4MLjGqyg1GmKdceoHmOTDwOa4O2t0OycOAfi9Jd210HQv1CsJ7wRjt/2ikpWs9/n7jUuOx0WX7XQ8GScThQCC+45Ip9Cmz6l54Mf9lPGIushhWS8rWTSDweHZAathzbN7cdZPPK8AX8HW2Z1gu195MMQ1BMMXp0xSJbBJG2zLbR9LKvyX+xxx4c7NXfo/1Y9seaWU1cw1ffUA6Lf9md9GeTaP7Du1MRtDAJyCo+IrD6Z8aMGoMcUULVVbJhHdjh64wQpUMp0V0m+CKDp61oOnkVUcLjkrS9DcTktpZPf1kFH4c4PfTSJOkLLTgo7ycQoqE8ZJzGq/402r/+7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYeFNtnkvU1qFshr/Iw5VAqPCiQPFhNBOGhyOQO9oM0=;
 b=lwNxAmlDWyy073odcF+Xn3pbDfv4SYbKJa0bL8Xsju9Wgd9+lxkieDiGC3Bdtvb9KmUYXPqj1Qi1T5XretH4Wk7gpbYlzkQtJRnsUwFQqe6QfzwHxGPp0HK3WuM14bjeRFwIdYkZj2Qt17gjXlFyttotpOxgFxfiMS0VOhC8mf4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=julien.beraud@orolia.com; 
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com (2603:10a6:206:3::26)
 by AM5PR06MB3153.eurprd06.prod.outlook.com (2603:10a6:206:6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Wed, 15 Apr
 2020 12:25:08 +0000
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b]) by AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b%7]) with mapi id 15.20.2900.028; Wed, 15 Apr 2020
 12:25:08 +0000
From:   Julien Beraud <julien.beraud@orolia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Julien Beraud <julien.beraud@orolia.com>
Subject: [PATCH v2 1/2] net: stmmac: fix enabling socfpga's ptp_ref_clock
Date:   Wed, 15 Apr 2020 14:24:31 +0200
Message-Id: <20200415122432.70972-1-julien.beraud@orolia.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0178.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::22) To AM5PR06MB3043.eurprd06.prod.outlook.com
 (2603:10a6:206:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from julien.spectracom.local (2a01:cb00:87a9:7d00:39f3:186e:89f3:a8d8) by LO2P265CA0178.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28 via Frontend Transport; Wed, 15 Apr 2020 12:25:07 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:cb00:87a9:7d00:39f3:186e:89f3:a8d8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14cff4aa-e635-4ddf-d186-08d7e1380904
X-MS-TrafficTypeDiagnostic: AM5PR06MB3153:|AM5PR06MB3153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR06MB3153E1C2786213626B98524E99DB0@AM5PR06MB3153.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR06MB3043.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(366004)(136003)(396003)(39850400004)(346002)(6666004)(316002)(66476007)(86362001)(6512007)(2906002)(107886003)(1076003)(5660300002)(4326008)(6486002)(8936002)(66946007)(52116002)(81156014)(8676002)(6506007)(44832011)(478600001)(110136005)(36756003)(186003)(66556008)(16526019)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: orolia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iiwb+Sm/+Oc5+UovPXIYvlS92QuSTLrDb2PrucajaN/0IvDZPzJKMBeOrXYFTUWnQXvSBR69e4JEpYi2aO+S9CIu2+ShOHLYVq/6M+bvXrosqe/HHgCbj4rsz8SCoDj/d0lp3YXLJmOK1NgEuyteo3uvDylIaqKZm1q8ZeTba6OlthIqGqmleq3UNK17I8+IOmCq2M/0JexSHnr1a+bKwLmYOGOmhRMjpyDB70mu1G+kHXKQe8lE+QggpUoQcDINWXnDJrAlh+UHqMjizseRppQgq4JqK1j8iOu+tYjzx00/URo2BIuE6G+NsJEMJ8MS+02/UDqWBveTqGsR7PLAn9urNrgjWr8P5jY2InXyC0RxxLh4xaNk3wMHn7lHqSjfng9M0JMr/8E2sLQETZ8v8Cvz+nqwYN8DuV8Dg1wyQzbsdr1SIL+doFqoVwzQ56oj
X-MS-Exchange-AntiSpam-MessageData: THrKqeURUJmyoYTWZb/mStu6YZvhniAfI+ySIsFdBnqMIldEofJBfkz0a0xoSzi/y5ufTWx5XSp7Vp4o6CABc1INUdA+ZWkqJKZpL+EZHYibdCvXc0pgfSpxzs+rY7ON/CIQgvwYPRhICZhXzloqmAMFPsd40WWda036lPXbtqPeKqSnQ2Qw8p+xittQSEJAaFLeg19tvy2B8GDiU+NsmQ==
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14cff4aa-e635-4ddf-d186-08d7e1380904
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 12:25:08.4232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: exKfAaCgZnY6onYgZsLnFw9ePVH1GGBJQxQ2HRxqS4i0psfJyHFLbb33lYOBs3a8G2mWgcnwuP+fh2zXibeBHx1+3EnscryUvUqOXq2K/Dg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR06MB3153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 registers to write to enable a ptp ref clock coming from the
fpga.
One that enables the usage of the clock from the fpga for emac0 and emac1
as a ptp ref clock, and the other to allow signals from the fpga to reach
emac0 and emac1.
Currently, if the dwmac-socfpga has phymode set to PHY_INTERFACE_MODE_MII,
PHY_INTERFACE_MODE_GMII, or PHY_INTERFACE_MODE_SGMII, both registers will
be written and the ptp ref clock will be set as coming from the fpga.
Separate the 2 register writes to only enable signals from the fpga to
reach emac0 or emac1 when ptp ref clock is not coming from the fpga.

Signed-off-by: Julien Beraud <julien.beraud@orolia.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index e0212d2fc2a1..b7087245af26 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -289,16 +289,19 @@ static int socfpga_gen5_set_phy_mode(struct socfpga_dwmac *dwmac)
 	    phymode == PHY_INTERFACE_MODE_MII ||
 	    phymode == PHY_INTERFACE_MODE_GMII ||
 	    phymode == PHY_INTERFACE_MODE_SGMII) {
-		ctrl |= SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK << (reg_shift / 2);
 		regmap_read(sys_mgr_base_addr, SYSMGR_FPGAGRP_MODULE_REG,
 			    &module);
 		module |= (SYSMGR_FPGAGRP_MODULE_EMAC << (reg_shift / 2));
 		regmap_write(sys_mgr_base_addr, SYSMGR_FPGAGRP_MODULE_REG,
 			     module);
-	} else {
-		ctrl &= ~(SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK << (reg_shift / 2));
 	}
 
+	if (dwmac->f2h_ptp_ref_clk)
+		ctrl |= SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK << (reg_shift / 2);
+	else
+		ctrl &= ~(SYSMGR_EMACGRP_CTRL_PTP_REF_CLK_MASK <<
+			  (reg_shift / 2));
+
 	regmap_write(sys_mgr_base_addr, reg_offset, ctrl);
 
 	/* Deassert reset for the phy configuration to be sampled by
-- 
2.25.1

