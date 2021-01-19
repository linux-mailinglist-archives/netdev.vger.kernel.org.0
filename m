Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B02D2FBE27
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbhASRot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:44:49 -0500
Received: from mail-eopbgr80120.outbound.protection.outlook.com ([40.107.8.120]:49294
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389488AbhASPKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:10:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LlCe0c350ZOcH41A1+8FaqExztoUMG1iSa61qbrd7asbrWjQPedIAAKujV8Mo7fwvNBnPKLLqN/AjSoXLfflIY6urN2waMnWHHMqJiPq+Eh/CHgyOwbqBDW2pzakJmpY0dZLLVCQFVYsLL4gnsSuv0UTgx1AAH9aSAPTAWmjzVSbZHeROA1VrkO7aosyAtXhDzKlW2fVd4URC1jaNdcJgJfgu77Z8wsaRlrLyg3ngkEj+bkUNWxMc487nwcNXRUTfg1/GKY798IAm/OMMMr9TUgdxtGfUkkKFGeqMOMKJgYyZkGC4LA1M/2IPNP5YZGKRAGwfPXsWoXa5h1GFSK1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9pAQ+YkqD8NXspjdVpOzcZ8lBwEd3OxgZUpUgEUfGk=;
 b=enUtQ1SMJTt3h56F4OA3TzfVcW2E3sbiEmfim5NNIyMF3Em06tXEnqAywEDKL9OC3rHVXNcppaDFxKpoEApAXa2MZFFrX3Yi4Z6p04tY+tZJnFIKitEQ5zSOsV+7blNRMbtw3NkrF/0r3s0mChx3ICG4zUu96uizmz3u3CC/38nuz5JKPXpy4PyTkKoZLlgBoxq2DYnzHZwLTsoqBmMUbdGEPzNP9/QSZ79YUYT5PfmLrAJ9v9wRcLTD+KrYpCI5qDSSg4DeQ9SidQnJ9Zgfbwbev4gwMGnzOp/Rps3iJHAd0munOj1Zc+6uQy3q5gZLL1I5B6dIyMMOMVATvR6feQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9pAQ+YkqD8NXspjdVpOzcZ8lBwEd3OxgZUpUgEUfGk=;
 b=XkQ8n7wui1n+LsCvbxpbCH8dDFOYHQo1k6CNKZZjKldn8qhipHql1gQDZv8pv0+DV2jNuD4w/ILIWpDDqc0VVNTph5owfVpRso2vOZQN7iWBU6yrDUlTWo7H5FRglJxN4mSYMuYAfxm6ictojYMVC4D2C1zURSfRDV/M6tDyhz4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 15:09:03 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:03 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 02/17] soc: fsl: qe: make cpm_muram_offset take a const void* argument
Date:   Tue, 19 Jan 2021 16:07:47 +0100
Message-Id: <20210119150802.19997-3-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR02CA0036.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::49) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d84cf6e-b63b-4931-e740-08d8bc8c2811
X-MS-TrafficTypeDiagnostic: AM0PR10MB1922:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB1922ACC36F1223D5855CCA5A93A30@AM0PR10MB1922.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htE5/z3c9b39VJeExENd5ibX+Z6IaSJ9dhb8eKISR98xoti25Py02wPnM691GGGswtaxqUBrOuAXT1oimhMjA2EF/e4xFdUCrSLlhR9jZJX1B7rYso6jSz7h0JNYKONFp57rKTHkAW+sy1SXz2k73jwDmVpHSouHrGMoFieKI6ibXg0RHrKh/Dk+ZJ612wh6KA1y12EHByf52gv6+bSNF3Wcnm+3fFkF1IKDM91I9G9S6wh1HQwr1pot//DDlaa66lRpBFKdJ/3EnF4qfhpTgidEQmLF9AMsPap3V1wNwiw9207Jd1BA04YUve5mDn2qKt7oIFdlueSnzeQ8VXQZT9XD8Y5xySBAbOrQjXPKODoQORoI2JLJdZxsyLhS3cjdztKH9aPWRiXMpQ+ceRhj1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(136003)(396003)(1076003)(186003)(956004)(2906002)(6512007)(44832011)(86362001)(16526019)(6666004)(2616005)(83380400001)(6916009)(107886003)(8676002)(26005)(36756003)(52116002)(66556008)(66946007)(6506007)(54906003)(4326008)(6486002)(5660300002)(478600001)(316002)(8976002)(66476007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4cph9SBXgN5qExCqNEobvV2XSemNlvKsAvEP7o6vz2Mftark00LRujWyg9J3?=
 =?us-ascii?Q?iNA1L6JAxvTiflgMJJTvzfMr0kpncEUjkJRzg9B+txdYQL7aAi4fFYmfZ4TT?=
 =?us-ascii?Q?KzpOIk+Y7m5XDfMloUlh1cYWsZVGJ7JAEZSjglnDdGjeRu9M5LECE41gxINd?=
 =?us-ascii?Q?7BRHllI+qT8K220kcCxVfXtTOhGJB9xv/OYxaUVmdzkFzaZSN3+utTO3WxZ5?=
 =?us-ascii?Q?tlEW6DPOWPTPdr6YcZ6ALUjdHMSywI8GNB2TF8xqaf6CthXXdJgwWCA1pm8C?=
 =?us-ascii?Q?99a2pJkdnntxzohGQdt4wED63PyCArPqjQtKl9c9Lk3/EjQH9bWn7aW7DuOR?=
 =?us-ascii?Q?uD7jukhj/3LWujHZfcCZE0fVv2tRB88UFvNIpiLk6yuVeik8vkf8Pv3bEQxa?=
 =?us-ascii?Q?kd9dccgc24dCLO1ISi7rqaXqWzrRMZrro4lUPGWIM5oFYFilNFcjHaDPqR66?=
 =?us-ascii?Q?mZifkCu/MLh4l7XRbCXQGqLOgWZ5g+lG1v+7Kl5kqhi9XABkUeoftQTmu54N?=
 =?us-ascii?Q?Y9u/00U4yhee5OG+9lcSeFL0cq6a9VmUMlfflziwaL9YoBN24f3qfH+qUP8v?=
 =?us-ascii?Q?kKBZxnwOb74/9lZYETl4BgguMcQcabQkXdA2tiNdpiSftfPscy7PJhhhgG9H?=
 =?us-ascii?Q?y+5a4w+ekRoPIeEHUNG+OIZU95jB6MLLQ9uGnagGmarnkO2Lzd+TJqBZre6U?=
 =?us-ascii?Q?RZd5WTAPelpqQkq1A3mpRm6W3H0oDtnLED5cbh/Ez9Puaz80bOQvEPJClnjO?=
 =?us-ascii?Q?gVkJTOCG+psXcsptRY5YRTJoOv9jnxv8FAIuigE2NSeF8tWrJT08gE4gn8W0?=
 =?us-ascii?Q?gEKlA6f7+WdCNzg6CT11zdo4FWwHKSSHtma2R1a4PFL3PIZBUqr1Ffm5HLU7?=
 =?us-ascii?Q?fGKt3EPgLUtneQqqLlOy1yWx8C/qVqf1CmOXsvpMWUza8EtGxC67UKyk0kbr?=
 =?us-ascii?Q?BLMK/mBwHNT0lFU7G4YpM+EruvF96cPTO8tbcX1dvNazFVlnDKavyXpvVJfx?=
 =?us-ascii?Q?8rKs?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d84cf6e-b63b-4931-e740-08d8bc8c2811
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:03.2697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3iO6vvp/IiNN091tsJqxbVbJd2jVNwCeNbNZEI2kw3xvtc6zPKfEoOAm8d+pI335Ywv7arjCv3eylqwwTCnTeO+SYCLA2bKVC4WhkWg3hk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB1922
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow passing const-qualified pointers without requiring a cast in the
caller.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/soc/fsl/qe/qe_common.c | 2 +-
 include/soc/fsl/qe/qe.h        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/fsl/qe/qe_common.c b/drivers/soc/fsl/qe/qe_common.c
index 75075591f630..0fbdc965c4cb 100644
--- a/drivers/soc/fsl/qe/qe_common.c
+++ b/drivers/soc/fsl/qe/qe_common.c
@@ -223,7 +223,7 @@ void __iomem *cpm_muram_addr(unsigned long offset)
 }
 EXPORT_SYMBOL(cpm_muram_addr);
 
-unsigned long cpm_muram_offset(void __iomem *addr)
+unsigned long cpm_muram_offset(const void __iomem *addr)
 {
 	return addr - (void __iomem *)muram_vbase;
 }
diff --git a/include/soc/fsl/qe/qe.h b/include/soc/fsl/qe/qe.h
index 3feddfec9f87..8ee3747433c0 100644
--- a/include/soc/fsl/qe/qe.h
+++ b/include/soc/fsl/qe/qe.h
@@ -102,7 +102,7 @@ s32 cpm_muram_alloc(unsigned long size, unsigned long align);
 void cpm_muram_free(s32 offset);
 s32 cpm_muram_alloc_fixed(unsigned long offset, unsigned long size);
 void __iomem *cpm_muram_addr(unsigned long offset);
-unsigned long cpm_muram_offset(void __iomem *addr);
+unsigned long cpm_muram_offset(const void __iomem *addr);
 dma_addr_t cpm_muram_dma(void __iomem *addr);
 #else
 static inline s32 cpm_muram_alloc(unsigned long size,
@@ -126,7 +126,7 @@ static inline void __iomem *cpm_muram_addr(unsigned long offset)
 	return NULL;
 }
 
-static inline unsigned long cpm_muram_offset(void __iomem *addr)
+static inline unsigned long cpm_muram_offset(const void __iomem *addr)
 {
 	return -ENOSYS;
 }
-- 
2.23.0

