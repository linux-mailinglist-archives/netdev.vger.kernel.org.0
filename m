Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A413105D5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 08:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhBEH2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 02:28:05 -0500
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:50849
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231509AbhBEH1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 02:27:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8ttYU/OVqQJVvjtbl3WWnKFry3DWxTmKILaXIH92Bz6lO8VLT5qljBzL4RMUDB2DrcA6ZYienXPR7YbzKl082xAvmAVNuX5uPTNqpR6RaGR6ijTMHr9Ys25s4Srb+NRQvLHXucDoSaAA+wVAj2uelyWFjaLOaGMcFHdzmyvagSI8x4N4/Zacuqd/sefZfooXU6JLIVUVz5ahFubkZniawmEa4aM6B+3ahKOK72moDkrZjTcT1Nf1SRxXf/DKBqRC+FiOWbj/o/N7WOtOYC8rwcxX2/tZQ9hqumPV9aqQ1yKQ1SMsEXZVsput/Nw3NKy6/tP3Eefsr/yWCrFI1EyCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHId1mWeBQb6P0X8xTLdnyY7yxEgLjNp/8E6auNgBfU=;
 b=ZZRXvf787JGqLUkU5GRGfYfiY5IrFijRFvkqRt6j4iOkRwAVPlo2H9TItug58dgb9JnCG+I/7neV4QXo8SfFkgwtI/UURKBWjE9+W5A9YedYvE7yuf268tcsNgfsCgofM1n1tQyfVj7SzSlyN/o2zV0ZmEaltUVLcWnYQVTpRUuP2wtEREQ+XqjA1oFCjlV/C/q+ChxibjrUmKHT5I2gozG4rYaBB40ul6M58CACDMXFlzBD31R7plZID0TkHxzr6XSO0lFPBll3YfbBMr0WRUSkYevzu2pi2cXV+srXfS7dW0a5za4VqINtg1klklx34Md/zID5eS/ikh16/5HA9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHId1mWeBQb6P0X8xTLdnyY7yxEgLjNp/8E6auNgBfU=;
 b=VV/az/h5fHofZsO6gS4cWcHnvViUiVlX4aJY6Vfivvqb/ejwgS4PA89e6RcEqAbUovm7+tSWe3Olz5pKRRpwXUK2UkTK5ECSbMC/7803EI4G1t4GlWHrziSDJn3vXHW9F6WZd7R8cPUfKkwdmwWl10Mh/2m8+H4JZl6ZqoH8tuo=
Authentication-Results: grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=none action=none
 header.from=windriver.com;
Received: from DM5PR11MB1898.namprd11.prod.outlook.com (2603:10b6:3:114::10)
 by DM6PR11MB3627.namprd11.prod.outlook.com (2603:10b6:5:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 5 Feb
 2021 07:26:29 +0000
Received: from DM5PR11MB1898.namprd11.prod.outlook.com
 ([fe80::d4c5:af6f:ddff:a34d]) by DM5PR11MB1898.namprd11.prod.outlook.com
 ([fe80::d4c5:af6f:ddff:a34d%8]) with mapi id 15.20.3825.024; Fri, 5 Feb 2021
 07:26:29 +0000
From:   Xulin Sun <xulin.sun@windriver.com>
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     dmurphy@ti.com, sriram.dash@samsung.com, kuba@kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xulin.sun@windriver.com, xulinsun@gmail.com
Subject: [PATCH 2/2] can: m_can: m_can_class_allocate_dev(): remove impossible error return judgment
Date:   Fri,  5 Feb 2021 15:25:59 +0800
Message-Id: <20210205072559.13241-2-xulin.sun@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205072559.13241-1-xulin.sun@windriver.com>
References: <20210205072559.13241-1-xulin.sun@windriver.com>
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK0PR03CA0116.apcprd03.prod.outlook.com
 (2603:1096:203:b0::32) To DM5PR11MB1898.namprd11.prod.outlook.com
 (2603:10b6:3:114::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp4.wrs.com (60.247.85.82) by HK0PR03CA0116.apcprd03.prod.outlook.com (2603:1096:203:b0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23 via Frontend Transport; Fri, 5 Feb 2021 07:26:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0d9db16-ca03-4a23-a16f-08d8c9a75ad7
X-MS-TrafficTypeDiagnostic: DM6PR11MB3627:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB3627505DAE95E4EA4D8121D5FBB29@DM6PR11MB3627.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dYJ6GxOPh0+SrjZUR7x6d6xrA86QVHRzAU5XAZ72VbE83NMRuiqQKgRiCRVTg7mqp5Q9KWfCN524ckJzcUDJ6w2Md/juC4imYb50eC2IDPPl3Br/w8LXCM3JIvKnpXxCvqZN/9qF/BIUslURHiicbDlWDUeM4t6+Abb2cRLLPoL1OjXOSkUhQKY6EgZ5CHBSbW7w4G6JT8gHL8uBVYzRfp1Yc0Jfzofug2yOpw9kya8ipLhP7m7MgYxoy5dT9Cx4CvXpGtml0WnukwhMIqsL25LFgZ/ckVnhn7wLpRvmA4wVRuWn7UG6cN7iNdxCUcl5q5XipW8VNEdXSvlAJsgDwQXwjBvNlpD9pw8/+O877sAFUTVG2IH9vKKYyyfrfZ4gwJwtuX73XCsowqj+eu+/nCcjSZRmskQAJ/IR47rCM0Hets2C6u3YkG3UgAZcOEizwuUnyFyG2VSTIgIsBZPCIHPK0kHF5bPZzSm6sraO/CZVA5q1ba4ZrlLoF4SN8YjalwLA2cQnOvVKweNKCCK4LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1898.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(39850400004)(396003)(316002)(956004)(2616005)(16526019)(186003)(8676002)(5660300002)(66946007)(66556008)(66476007)(6666004)(52116002)(44832011)(7416002)(36756003)(83380400001)(6486002)(2906002)(4326008)(8936002)(6512007)(4744005)(86362001)(6506007)(478600001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EExT9NnISx8a+iAbVWYI6b/F8Vm5+SXAstc50VD1EEJFg3Pp/cCIzh/UzEMy?=
 =?us-ascii?Q?R1C3IvD+/PNEXz0Kd31PjUz43DFim/U/fL9Ijz6LRkZZrWe4Ryc5kHALOJNc?=
 =?us-ascii?Q?nR6aCWt1oZzybWh3ZNuw6lX0MkgqDWvT8UwqE84Qx/sxHk0mDXjTvrXrnssj?=
 =?us-ascii?Q?BZEjZvW6luKjs59FH+DpTyEo9/zGNFdHkQMnhE2wi+Gtg8B2be2Jsiq3E60E?=
 =?us-ascii?Q?dMmMUhTlFnRYTlmOq4cJIanGE0Q0U8REqgvtLs0wGRurGHuJQr4cJTS/1MDI?=
 =?us-ascii?Q?N714SRhe9+6Q6KCcpYpILtGsQcdIdqlLQcadJ6DnQgfc99NUs4Si3vG//nUk?=
 =?us-ascii?Q?ua1xZiSqMVdOj2GWER2BlkyzullDdgyXX8dPRilpxnWLIH/PPTDPQ3m7uyfJ?=
 =?us-ascii?Q?slwc2Tw166Anw5U5gDmE+5NCoZuoigt7v8irHOBCw4DUsC6VhwlW7cu79cJ9?=
 =?us-ascii?Q?wZuzVUuLRtIhvdV38ZEjK4c+S+yqSE3KqjFJmki9C8UD+Dhmx2Lp7OxeO5BH?=
 =?us-ascii?Q?JGWFkehzsewc0mxXG0ql2sJnoJ3dZ0HvkAkkyvqAD1gfZ4tpkqywHCMz7uVX?=
 =?us-ascii?Q?7rJ4Z3uIXKOT7/C4ft4WmIAK4bQJcr8Kf6ecXy7z56jgttA2sXnPMonyDuV5?=
 =?us-ascii?Q?eggXtrBsPertskOM2cB06nWzXTr94Zjk2tqQOMtyiVtFnSYAdPQgspmChiMs?=
 =?us-ascii?Q?SZyEKBPcwKabZSrmzL23cqp/4+FFeLPLw7GnR4E+oD41LKiu/0dOk1D7t+wY?=
 =?us-ascii?Q?uHRvMAwygzYG8uMGmHwxm6eH7FdBu56oGZLr6k5476gH2OdyGmy+iGrKXzBr?=
 =?us-ascii?Q?F4Z6imFfVs0B4a705XBCpkY+FQ9X98gr993pkRIuMvAXBkCc/aScgZKsvMe0?=
 =?us-ascii?Q?Hks+IGf+2/r0HRpB6sLJ7eGQFV6tXKxhzTBjysv0RxU+5YKD6B9aW6KA2GSQ?=
 =?us-ascii?Q?slqufn0x1EkeNgOiqna/MSH91EYnyPLfJR4BLaUOGVeaeCgIZleK3GMpxhRo?=
 =?us-ascii?Q?QLJcVU6Sr52JmekHfBoThB5G0PE/Fgke/A41rExGnhkYj19V/5yB/vfS8w5L?=
 =?us-ascii?Q?TKWIxQshc/Lwti3BcRMqwqf+BiTLuYNFZcj1cfq/mvnZClzaBtROQCTMlO1C?=
 =?us-ascii?Q?LHTUMQltLZLiR90t+1m4DnbjAtRawRkWYnhLFWCms+bOI/LsBUWi+lWlFbyr?=
 =?us-ascii?Q?uRqwJgrQckOSPvmI3GC1r9V3YrdUzM5i8hrixSk/3i0FX+C0cRtd6aSy4qo3?=
 =?us-ascii?Q?yagnEmlYL08Ium5leyw+0cytGIZMSzXgxDcDxDVcG3UJih2FXhwObTSlG7TK?=
 =?us-ascii?Q?nP5IWdIYuLA6WAsh0BmeU1Ns?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d9db16-ca03-4a23-a16f-08d8c9a75ad7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1898.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 07:26:29.7306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUKatR2/vSg2h5MQIiRGCU8b82zILfpWaciE+zo0ttwMYw1WvM6CigMl2kxyNmiePFrhNetZx09Mt6GXcNy9yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3627
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the previous can_net device has been successfully allocated, its
private data structure is impossible to be empty, remove this redundant
error return judgment. Otherwise, memory leaks for alloc_candev() will
be triggered.

Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
---
 drivers/net/can/m_can/m_can.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 02c5795b7393..042940088d41 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1797,11 +1797,6 @@ struct m_can_classdev *m_can_class_allocate_dev(struct device *dev)
 	}
 
 	class_dev = netdev_priv(net_dev);
-	if (!class_dev) {
-		dev_err(dev, "Failed to init netdev cdevate");
-		goto out;
-	}
-
 	class_dev->net = net_dev;
 	class_dev->dev = dev;
 	SET_NETDEV_DEV(net_dev, dev);
-- 
2.17.1

