Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5421646E123
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 04:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhLIDM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 22:12:28 -0500
Received: from mail-bn8nam11on2138.outbound.protection.outlook.com ([40.107.236.138]:39168
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231251AbhLIDM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 22:12:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoBrKJnaUd/RyMwAKKOv5XzBGCaNKZum6hmKVBir8LOyjOwbkByLXdT9rb3XVlrwiagJhoIB6ybiupnM9Dz6mfzwYgN1EwANfS5vHWyz6ExrPrdM6zje9Je/h0SjwQz6fcghnaaHh8XUm6RLsnLvzDXSGpK+0/L73ytQ32q7yA3/p6fmZd4CWs6OeJM/zjZ2GrBW3Aeagn36rOSL1sxPOTUz1BXTVqdJuNNzNMPO/40sIzwQi95lLzG+W+Xk4UGAn6aYC1IGNhWa/Bx9xPOYFhA4LH7NGe/p9Qn9nFR6anM4AtBXrdGGWjMOjfsxCQHmmFGec1u0yy6qZJlHGtMA7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDtZNwQWF27lQ+l5O4iu7BCa2/CB6d3l6m6TGMs8Rlc=;
 b=dygRh0h/I8ZDdVSSe4+h2Dobp2jwlbqHANxZzNHKwV0c8Vfcum0xQNhlsUvmeW6x+3DDx54b1HGR/8nz+PC64CPNi8/ryHp252LfV3SSkZ7L8dQ2AnFrHIxC/tHh17Z1Lh+i5uPG+NO+7qE2ywyEmGbGTJIjkSFyHBQFXZrDa7f317qpS07P7Q0L6gc7ul3R7c24GjFT8rMRHq/TEpM8MaxNbj6Uzhjee7QJutJjIqDeHbP9GFFpVUZSwayW8p9fkPanxt1KhtOVq6xZ1BizaJQzwSEN3jxiLHFJFRrDk5AIxFN+SOsypBCp/6ztGIHI1Xp4bM0+fvvBpTlo1uuuNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDtZNwQWF27lQ+l5O4iu7BCa2/CB6d3l6m6TGMs8Rlc=;
 b=ZwsXUO3hSsKOepPVGz6rGS94ZQLMi0zeCM5Qu0wCHnEafbz08u3NDfOJD71iS0xBxWf5dMdERrA9P6hIvDYiVVZV0a2c0vqreTwDUEjmxC4ErXrVYWB8YVp8nFPgWdaTlr0oHaFeLP793SHtd2qjaOa/IXLRIBkCbv79palgmCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by DM6PR10MB3226.namprd10.prod.outlook.com (2603:10b6:5:1a4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 03:08:52 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::6576:2647:62d6:cfdd]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::6576:2647:62d6:cfdd%4]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 03:08:51 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v1 net-next] net: ocelot: fix missed include in the vsc7514_regs.h file
Date:   Wed,  8 Dec 2021 19:08:40 -0800
Message-Id: <20211209030840.1778440-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0026.namprd12.prod.outlook.com
 (2603:10b6:301:2::12) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR12CA0026.namprd12.prod.outlook.com (2603:10b6:301:2::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Thu, 9 Dec 2021 03:08:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61600655-3b5a-492d-cd2e-08d9bac13a08
X-MS-TrafficTypeDiagnostic: DM6PR10MB3226:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3226E468F0A242AA40213315A4709@DM6PR10MB3226.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:350;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +In8Bgo4LuYymOmyIpixXYHVvpok61zZ7teDi0rQvoP++mFmlYO2cHd/c2vxEmXU43JRuwxmi8SM5YxQ5coM6gDITy9/S6WLlWBshNxkwvyxxYjcTvy4H6N/GJL2OfZ+p6Mua9zhwwv/YRdffzlOba96exPcFP/1AiHU8l+wWddnmwvcyyt1jdJjkIIH3tV7f1dx97EICbXzktyt7nOsYv+0kNfauotAb20Lwdol2ZN8AJ8IUYeL+GWA/Og4pooz8mB1U5ZAZ3BZFr8lKmeKZmPMrei2hfwVES/Yh0y57nUJi28Df+YUQ1jd6/m/bdyxKbtgNxsy3GKnH1bEZ+kqhhS/kjC2JssEQn5QQNhNY0c3dYvFq5mYT+VXfkWtXk6KzfhgO8I5fjtvUOtJdk28SlJnnRCyifqmi0ESO91FBxcGrSLRW1Njk8lajEScZMVak4ogZTmGZEnNtiK9zeNw/7kku0HCuhS41Ioj+ePN1ORyJkvVVz0FQnJ+4krvDHveGfELclrNUiFpPGxH5TwZ43swCnKSJziT5msuz6W7pWbIq6q57l2cwqMSX9grr6XuNC3YbevN4v9dyn3IXVLnuEOILQI+UNGHYENxntwUrd819TF0TIjonOK1hct7cycWuFDXb5Ajoqu5sqJSCSIg+kXZ5yuYcbLS955gA13bFrbctAXw+bJxlRmDj4mrJWvLuGpI2yJYVXiG4bjP4Cy+lA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(8936002)(2906002)(6506007)(26005)(36756003)(66946007)(44832011)(316002)(2616005)(956004)(8676002)(4326008)(6512007)(86362001)(5660300002)(66556008)(4744005)(508600001)(54906003)(66476007)(7416002)(186003)(6666004)(38100700002)(1076003)(52116002)(38350700002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?co8Q2DB94WmxwTMQ9SHJwVLRKEHakaiO67vA6z7vU4nEatCv9lnJpSI6e189?=
 =?us-ascii?Q?GqwOLamxPXMhbLG8Oe/S0RPfaWjjh4Aujz6jmGNyGKSE9FSBAoZRxXpwcEI0?=
 =?us-ascii?Q?j2RYpVrdPh9UrtyEslZdQdE5GBvLbrFUxX2UB4gl0i+9+hwL0wyb1EMTQJyE?=
 =?us-ascii?Q?2n/iyAzBqfPGZuTARciN/iMdkwKNbDe/ib1HJAJ8zlaMWfrU/vQrVh2YB5Pt?=
 =?us-ascii?Q?dsZtD1q0QYFitWUIkffQBX+Ik+/bSC4di+15MgI7YGwHQkwCnazfGOO5lBqZ?=
 =?us-ascii?Q?gjji5qE/7qRSJwRQnCTFR1bXwWjdPLTimwxQ62Od+Hw809Xy8c3Q4M4tiJEu?=
 =?us-ascii?Q?aqI/bS+siKC3l3/+YcBonGsMEtoARySBExdy0v5h2CcuwNx9k4vR6KzX0Sck?=
 =?us-ascii?Q?I5mZdsVbunX9yJOk+iSxJE1V1Es67IRQ7J9wB4ECVH7Yp7Rxio1QIh+N5uZR?=
 =?us-ascii?Q?q9iIoiii+qUykPYtNR1nZjRCZUquq+EWoSiQNbE8QxqhnBaDTuOWnCRXlYOL?=
 =?us-ascii?Q?pKrSxN5KrE4qFV1r6te2F3Ku/MUQUIb7Mp1a/Qki3WQvqXE9GTM7DKXXdU1u?=
 =?us-ascii?Q?SOoCxRWyTD45nL6KAqHYmWWhcLHxcnjyN3GVzbfVJwkwZOggRJJoJDhiiQy0?=
 =?us-ascii?Q?/DQPwvuHmblgjbM9z70imBh+/UykjsG+BB/t9hwCO2hvfpm2JSn2muQCG44f?=
 =?us-ascii?Q?lKnuhleBCdkSkcyw7+Pkk5FMz7UGt/NyTwRqbdbUnxZD0wWrujr/+GVYRmb4?=
 =?us-ascii?Q?u8uzDaFdUWGoGhbjhK6zZPg5yn9dAf9c47j1GuyiifhF9UffdFGGRc062KHU?=
 =?us-ascii?Q?hCtR0VSgV+C7SUWFyVnEttWIjyqRUuYSzZOE2QlvsLm1HhD0f1aeGKgJio/Y?=
 =?us-ascii?Q?K1nQKfZIzUeb8SqVR6Ps3pPRutNzFHqMVH5RrCSClXCbF3yJzDXN6eyLPqcS?=
 =?us-ascii?Q?UBL03HoEr6f5X5O4RHuQa74er0fFjTSmcYhF5p7Vhow2dF5FK5W/dMtepZBM?=
 =?us-ascii?Q?D6ux3XoCrB46w9oVvADzPNJ/LZPajfZ7Cg1lOvy8d9ntwCi9HW8r/yAWyKSD?=
 =?us-ascii?Q?Y2xthLMauwdjgxSq8QBw+dV5X69y/MhMlqJmj27L23sFDSyCWwZ38cy0k2Md?=
 =?us-ascii?Q?+rPa3xde8hHf6kB6iv6nApn93b1hM7yAW5rUVFCZL/08TWs3DG1hIRuPfF5x?=
 =?us-ascii?Q?n+7JeAJNUvvQgCZWAsc1h/dqwIxasJ4KBANGu3qBYuFuWHTsZY6mPpFEDb8Z?=
 =?us-ascii?Q?Tb3kp6A4EjDuZV9wKg3hogOdX/1rEjmdxYp9Z7VnYDxKZIYsI7BFS2U1fAB7?=
 =?us-ascii?Q?Hkls32wFmdlxC3iTYEGNiYfMgrZtZKB6Bf1YHV+7OWbNfs8gJGEDLBPFI1Sn?=
 =?us-ascii?Q?OQF482suzmScStgReSmhIps3DLcLHmsuTGgQe9cA52zqXYZY6mfbNp9KR2ue?=
 =?us-ascii?Q?4nyAiOdkPJ0ReUCv2ZrmmPkDDnjjKV31n1Zv6/Qw0T9J8iKqIa+f5W4NEEqD?=
 =?us-ascii?Q?zftG36aPSG2K5/cVLpAp3z3iUcRpirDLRfmaavxyhPbH/lh42xah6FRyeOtP?=
 =?us-ascii?Q?hs+qJixnq32nTPpxwmoBxJdavcvuVKy0MluRoPPLfnM4NLa/6Q9qGEmcYS1q?=
 =?us-ascii?Q?iMfGI/e7/rmYisV22X72ErY20gfP6LnpMy6ReEZUPbIQuVjzTNrSYrjX7utf?=
 =?us-ascii?Q?GXJFLQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61600655-3b5a-492d-cd2e-08d9bac13a08
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 03:08:51.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JgFmWQpURfJ/aHaY0lBAQbiQd+xCwF+dvgp0XNTDfjdXU9PuQ4LDTf6N2Kwd9myPPw8LOT11ZphMaxlTMO3hQZ2wKUhVziVXD+FfLWtzDkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3226
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 32ecd22ba60b ("net: mscc: ocelot: split register definitions to a
separate file") left out an include for <soc/mscc/ocelot_vcap.h>. It was
missed because the only consumer was ocelot_vsc7514.h, which already
included ocelot_vcap.

Fixes: 32ecd22ba60b ("net: mscc: ocelot: split register definitions to a
separate file")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/soc/mscc/vsc7514_regs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index 98743e252012..ceee26c96959 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -8,6 +8,8 @@
 #ifndef VSC7514_REGS_H
 #define VSC7514_REGS_H
 
+#include <soc/mscc/ocelot_vcap.h>
+
 extern const u32 vsc7514_ana_regmap[];
 extern const u32 vsc7514_qs_regmap[];
 extern const u32 vsc7514_qsys_regmap[];
-- 
2.25.1

