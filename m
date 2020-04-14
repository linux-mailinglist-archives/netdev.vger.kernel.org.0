Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D801A7714
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437462AbgDNJLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:11:39 -0400
Received: from mail-db8eur05on2083.outbound.protection.outlook.com ([40.107.20.83]:6130
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437447AbgDNJLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 05:11:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXDQpQD3jCR/d6uPOB6RdQgINMwsRxzfYvEnLoNgTXNmGNr8EzPLggAoKpxrWykELEZo9fymRXEg9Itj4b568pK52BI441YZ1hDdkRxy7ObK9ST/t4AIRKmkh1hqtEtvrPnTcpxw4BMlfstXtp8yGEGsmmDmeXGjMykZM5J2q+5ScgiDeGWjfayznAuGWOBnsWidSsbHgzHpHo3tNAkpPBcCpU8Q2owUGOH2T7HCXdyrBgJiQumdNNbZLcXgCB31A/RRjCghNXkVxfeyBz3ZPRdZC/9sOUZ48DRPy7tQT/KD+Y5SVGgTAlsKuG6nphqs2j6wpUxnQcYkuGO5BLWzeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYeFNtnkvU1qFshr/Iw5VAqPCiQPFhNBOGhyOQO9oM0=;
 b=ftyFe/IhCAMS5/uWhZvg+kXZonZ+F1PJkj8RKP4SOu1t0V1x+bmooRMS68qXdzDu7jKie+cJInz96FDcnwicZj8WZK3d2Q9PZobFuVPrS5CfVYCbEETsP/5gY4u+QRGXMoMcoAbjushIVpAo7u9KrYuh12U8RhzAW9UgJdSdIwHc7N7aLBJk/aMow4Rz8LwiXdce6uN1vZs/0qxPd53RcAocb2Ihuie8VDHP0pQUYy6+znYNVhi/dIW+p600XyLT2iEGv6a/tmm1lgt8tNCUxQ1cONQCBRVWAx4opg/XSqzsHd7wHuc73bf0TF5jLZXbOXDc1MGD8gMy4I9LsTaG6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYeFNtnkvU1qFshr/Iw5VAqPCiQPFhNBOGhyOQO9oM0=;
 b=q2iWtXCM7EiqVPbwWAzy/hl6GCpyXUEql5PUXZKhoIMM15q+dPnQS6tDeHFedz0kRV/cMBdUJ9T/Sg1pSKeXkc1BLvRzS8K6+ZXOHCWenVcPe83SW0HhmtSab3KnJJ0J4Pk0ZfVISrYvS14oxxXhXF3wI912iwV1M35++2YNBBk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=julien.beraud@orolia.com; 
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com (2603:10a6:206:3::26)
 by AM5PR06MB3057.eurprd06.prod.outlook.com (2603:10a6:206:f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Tue, 14 Apr
 2020 09:11:29 +0000
Received: from AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b]) by AM5PR06MB3043.eurprd06.prod.outlook.com
 ([fe80::7893:2451:4039:f36b%7]) with mapi id 15.20.2900.026; Tue, 14 Apr 2020
 09:11:29 +0000
From:   Julien Beraud <julien.beraud@orolia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Julien Beraud <julien.beraud@orolia.com>
Subject: [PATCH 1/2] net: stmmac: fix enabling socfpga's ptp_ref_clock
Date:   Tue, 14 Apr 2020 11:10:02 +0200
Message-Id: <20200414091003.7629-1-julien.beraud@orolia.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0318.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::18) To AM5PR06MB3043.eurprd06.prod.outlook.com
 (2603:10a6:206:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from julien.spectracom.local (2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc) by LO2P265CA0318.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Tue, 14 Apr 2020 09:11:29 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:cb00:87a9:7d00:9d00:f9d3:1f5a:64cc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7acfdfd-c84b-4678-a53e-08d7e053d14c
X-MS-TrafficTypeDiagnostic: AM5PR06MB3057:|AM5PR06MB3057:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR06MB3057F2FE84D2636C92FDD67099DA0@AM5PR06MB3057.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR06MB3043.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(396003)(366004)(39850400004)(346002)(136003)(4326008)(6506007)(81156014)(110136005)(6486002)(2906002)(316002)(5660300002)(8936002)(186003)(8676002)(16526019)(478600001)(66946007)(86362001)(6666004)(52116002)(36756003)(1076003)(107886003)(66476007)(44832011)(6512007)(2616005)(66556008);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: orolia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tD44eTOi4uHaKfp+uHtG6OjDxugpIt6IJFh77UR8bDjlS/K/N1hKVZwMbXMm4+mOKgi57HU7OirsFQyR2oZTYleFxn0H1A3eO67r97Z4DWrYBg/kmwWVvxOP5BuFzQaZh9+vrz2QTm6W353hyPLZyyYDNIqmfHGCYfA6q8eBwDTdtMXm2gDVijeaZIPmS3s1MK9jcBebXlGn+pA2M/j/hHO1GO/9fxQqI9bJWutqZSTFpuIK7BOiGbe+cqRMU3nltD2QDVdqfJ0fGLCchJLYGfRXUkR1p7dgoUx+Qe37KyqyntDkhFNWhu/GOt9jxKUtWSanDpjA5+bc6pJwDZTrv+rtr+Vivt8cGHYeTLQOCf0VuYWidKcmk2JspS3R7oF++W/RM5v880P3l2pBEjrx3z19NMco3sAO19nrKm5I9dbPLaavq5gHvz2vWUKXryzD
X-MS-Exchange-AntiSpam-MessageData: 8aOIo9dibSjad2YPpgMZZ+Hb/sabdoaZilu7njU/bYNTmQ7BhwtPqidThSN9BFPt1bAUfYdMxIbgOeSekTUtLqfjwflvvREVRM5oVvjB357QpDmjF5cVXDra9xx3VR2/46uYcdek65tWbo6v/hsRvt7JLVqt4dRRk28ub29WZwMYHgXGQm5LmtEhtu570Gyw5VyDgnn4X3YU0jkeLwayUg==
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7acfdfd-c84b-4678-a53e-08d7e053d14c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 09:11:29.6022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLf0+x+SajN0PyNabIxSDjnDubc3YeCrOW/4YBrD1/HywE+mbQMJXn7tgI/Jdy/72vodcGGuEalZYr0vlDF2yasGbearR6RtL9DILfJsIkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR06MB3057
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

