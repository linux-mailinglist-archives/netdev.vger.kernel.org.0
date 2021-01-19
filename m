Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECD22FBB46
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390800AbhASPdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:33:40 -0500
Received: from mail-eopbgr60117.outbound.protection.outlook.com ([40.107.6.117]:28545
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389305AbhASPLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELSmdjscpdxh9S0O4gk2Fe5sQEDSwYuvobMkX1MxmfkLBsbspsSaUEE3fmZObPCXweSEAxUTbp8ZZ2Y8egd8QO+fnwlQga7YEH/l7qXXFryeknrI4Ox6NgZ7lGYPDX96b8Ce8z4g/mFSGdBEzQC9AM5m/CXrwuNUDS6Ea/99R18wxCJ/62A5i3mBNTtDxF/O4tUKX7fbOtTZ+fI+axEwUm0EQIHS9+ab1eYXUS2jeYlDAS90Yj8nLxRd6FecPmK2a39YpNlsJ/E490+TUlsq9euUcKu6GQ4ZrZKTuxXAmKoY+XD8F9BXuvHgmzZWlMrCWfQf0csgpQdjexNvMrRk+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTUqxgU+jZblnI01UQpiUO5A6doOPu4IclqFIZSQiZE=;
 b=aTPyUBVkuAvUx1LNT4IgrZjzckgXjzLYrbIXuaWqFZEdxvhMTraVpw7RcXEXzcz0IqE0dsqW47iQiRvujDB4Wo3qaxF9lrwegg6Kf9EeCwSMT8qhEkYNyb87G/5h3vR3KTsiGjtB8yN/QTHHVrpvM85xs+F1OR/zV4OLZ8LrFoxlhcvbR3MrkFbh6gWK8rOPF81ZfO2vffo4laitTurgNGHHObgq99+5nTfnr8jNmcrseCFIt47OTsJjheLU9Aa7WmOFljH1MbV6TNdgrpCe/sKTbII3wehijEBfvrVpaym+L6E7G9J1e2++cZaTe6Y3ZJXxNSkEWnFVsj5L5SuueA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTUqxgU+jZblnI01UQpiUO5A6doOPu4IclqFIZSQiZE=;
 b=awWDApkHQpZgxE6nMHJO8lCvTirOwatAMKIPYTh4J+c78EyGym46b4lA0hL3kWPfCsIWXg3me/TynfZk+XgzfjIqOVFQnwfsiZw3v6zbIRllblyH/MMHyo6fNQqUifXWbpG+hVQIyCmRgE33t/Pv6NvpL1N8Nu36VbgAlU+k2vQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 15:09:17 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:09:17 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 12/17] ethernet: ucc_geth: use UCC_GETH_{RX,TX}_BD_RING_ALIGNMENT macros directly
Date:   Tue, 19 Jan 2021 16:07:57 +0100
Message-Id: <20210119150802.19997-13-rasmus.villemoes@prevas.dk>
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
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR02CA0036.eurprd02.prod.outlook.com (2603:10a6:20b:6e::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 15:09:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f63e2583-15c0-4b9f-f3de-08d8bc8c30aa
X-MS-TrafficTypeDiagnostic: AM0PR10MB3681:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3681A19F17448A639C0FFD8993A30@AM0PR10MB3681.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UKX4eM4jo+StN+mIMWP2w255A0pWpGJcnfjvigPbwRVmMckrDKFdkYaGuYTU0R2P1KsHE7ndQFPeYJSlirPs84xHuNQfGnE71dCD/VIEHqysyYII0nW2j4CAnXHFOqtBEkVQEYESfwE7QIromizvEKoV8TmyO92sVUaEJUW1QO2VheABEn1+Cld5DMoQNK0NA7jIzdGJB+8dbcmO879ncfSrALdLxiyURCyeACUTGWaBsIwa4qDLpUzltC2+ePn85TyxbviKzBxlB8aizuhzJW9WXSlp0YxXPA5c215iGRE4d/Xi/gr29FPaqfvQ3fgxAkpxTxGhvS/J5XeiE1TMlR+2ff1phM0OBKox/SNj0F/DEvxuf2AmVIaNvkP984uuAt3L7AJ/eEG7+Ghfbas0lA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(136003)(39840400004)(376002)(8976002)(16526019)(6916009)(5660300002)(8936002)(2906002)(6506007)(66476007)(52116002)(66946007)(1076003)(83380400001)(186003)(956004)(6666004)(6486002)(8676002)(66556008)(4326008)(54906003)(44832011)(107886003)(478600001)(36756003)(6512007)(86362001)(26005)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dg7g3Y80ENQBTSxl25NfPTsWZfPwyK3aeRc7p4hNZNE83Fzn8YZIH5B3eiUJ?=
 =?us-ascii?Q?BATUx4rcumUjQpyeViQ7T78cSa/xPTCNUhGm9L7QQxbBcQbBRPppvRNmUVe8?=
 =?us-ascii?Q?+alExqcL7SvHlwn9dVHWSQsPDJgvh8NZTesDWHkq85CtCJPSD5kTtRP4iT1L?=
 =?us-ascii?Q?W0FRRABnK0X+VsnU0w/eQ7qQnzILNKWCcSG/VHCwboY5s6dWKRseglzrfcvx?=
 =?us-ascii?Q?5q/yIFfaLYz7IHF9JT5Wbtid27O5WCzXTAx2+A5ea2jRcnps1CSklojMNrSf?=
 =?us-ascii?Q?wEy7uRafogQemf1WlJ6XkIP1eqRxfR6Jz9QiasNjEcg2PPZMjLuTTkhs3FMn?=
 =?us-ascii?Q?xsb93vmeUoog/IdUpC9/c2R0jYe7x4bho8PnaUCTTZlQ9INnZhR7TvIijkkj?=
 =?us-ascii?Q?7xzy37E1qD5YUudlGxP/Xsv0ACAeAT8otBUtRWBJrmd1TF5vwYB+c62HDE0k?=
 =?us-ascii?Q?I/7Mbk6MiMy0/3Ks0w+Rj1xsEOTkhkw5W7XdwRmHRv4ncF+uKMGgvRyDzaaS?=
 =?us-ascii?Q?8cAk7hTzoYol30vmzQl1udy5IduGms8xUB1XSRQEdgMti/sRvyhSsw/CVCmK?=
 =?us-ascii?Q?RFZjEzwSt2IpuLQ8ptTFCnpBHzbWPwUBdivhr9H5THdNb72/dmqnGgAtwVL7?=
 =?us-ascii?Q?oeC87Z2dZIJ/1LL9GdkM7DOrBYnDpvcqnLXeyCCSXWK0nshSjV3THYQCjT4U?=
 =?us-ascii?Q?60c3BvG1iSyioj3IRCx3BiZDcOjL0ZfBWTYBz6x/qg/tJsCO/HJLGdMy1n3q?=
 =?us-ascii?Q?l+a//5545h7sNV74mhMjocPC7BX38FR3Sz972wsn7kHy1mY1clP6CZLyRzBF?=
 =?us-ascii?Q?cEHZf8OCbqBQJoY1cnO+7L58xB26ZLQajSlngnQ+IRbVgVx13ktBXfMway02?=
 =?us-ascii?Q?w3j0N6cG4NGI8phXBHLecA3OCMwKBmNvX6+ipV9jszCvxlNAW6YU6e5hbjCB?=
 =?us-ascii?Q?MeVU/EDn8/E0T2oHcBWBIFvea8SXf7s+3BgDXDrFNhU9OYJYOW8tur+gXUun?=
 =?us-ascii?Q?7zTk?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: f63e2583-15c0-4b9f-f3de-08d8bc8c30aa
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 15:09:17.4116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRAoBUYucABVuyv4RuLekHfWPK3nRER3mMAGmwfNg35IZqi3D2gRWIbmev5E0uQY8kLGKA1etISwUQj+10IUHXBBg3hw3fla6a5Q3EvooWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These macros both have the value 32, there's no point first
initializing align to a lower value.

If anything, one could throw in a
BUILD_BUG_ON(UCC_GETH_TX_BD_RING_ALIGNMENT < 4), but it's not worth it
- lots of code depends on named constants having sensible values.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 67b93d60243e..2369a5ede680 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2196,9 +2196,8 @@ static int ucc_geth_alloc_tx(struct ucc_geth_private *ugeth)
 		    UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT)
 			length += UCC_GETH_TX_BD_RING_SIZE_MEMORY_ALIGNMENT;
 		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
-			u32 align = 4;
-			if (UCC_GETH_TX_BD_RING_ALIGNMENT > 4)
-				align = UCC_GETH_TX_BD_RING_ALIGNMENT;
+			u32 align = UCC_GETH_TX_BD_RING_ALIGNMENT;
+
 			ugeth->tx_bd_ring_offset[j] =
 				(u32) kmalloc((u32) (length + align), GFP_KERNEL);
 
@@ -2274,9 +2273,8 @@ static int ucc_geth_alloc_rx(struct ucc_geth_private *ugeth)
 	for (j = 0; j < ug_info->numQueuesRx; j++) {
 		length = ug_info->bdRingLenRx[j] * sizeof(struct qe_bd);
 		if (uf_info->bd_mem_part == MEM_PART_SYSTEM) {
-			u32 align = 4;
-			if (UCC_GETH_RX_BD_RING_ALIGNMENT > 4)
-				align = UCC_GETH_RX_BD_RING_ALIGNMENT;
+			u32 align = UCC_GETH_RX_BD_RING_ALIGNMENT;
+
 			ugeth->rx_bd_ring_offset[j] =
 				(u32) kmalloc((u32) (length + align), GFP_KERNEL);
 			if (ugeth->rx_bd_ring_offset[j] != 0)
-- 
2.23.0

