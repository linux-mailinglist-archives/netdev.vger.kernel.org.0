Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC942DE19B
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 11:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389053AbgLRK53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 05:57:29 -0500
Received: from mail-vi1eur05on2138.outbound.protection.outlook.com ([40.107.21.138]:28769
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727292AbgLRK52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 05:57:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=At2VUy/dVrvYju09fgQa9h0LThugTQ9qkEO45mX/axY6I50CEx99wAFmNbp/2KlyX/orYJ7oEXcvimjtYuKA4OYW4UzK0kheBxGaSdNTSplhhYi+wQYmHIqkaUCMIAMwW7bsiHNZ01Y8Waf4I/0wMz45D04zzurfi8NzKVGWqedc2e6UkLCEsCmcgFrnkm4jqZXJxCztcBkjexi3RzZa+JUTqm9BUa/TQfbFeewzZ4xy3Fw6HD00AYJupGiPGHS/8aH7JskT7Ow0L67FFNrayg6JmKXtH8SzPcf0DzyITnWEOFXRn2C7Ab+iZtl8ZrX7wZuuFkFKBas2yWZiUKN/ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8V+XO1z13KPHg4JZFVlOmxZAuGjh8gUkGGSasnR70Ew=;
 b=Fcohmh7AtIiqr10KXPtU5J0CdwnrTQl3mO2rKHiz33GfW1o/PmuY0ELiEv94AxeQ22GY+7X8580FyjPymRcMlCxHIvrO+wBc2t0fdYplP+TLDGAagUFsSJwMbWtREFLw5UAmwZatuUXBk52p13IXomSxmflw8RB6B+nJVsxVNhEKdE35q/64Q4D9CUTO9cTPZunXXOPVfTTe18Jq+t97xUysYiHd7I7D3s7oYMAQcOI6n9YYe2LJfJPkenVuYXmM5VuJYVEqmVOoVNBgShLMxielr41hVZIQVhYpWuF9z+gJNlxgi8yRDzKxBNh0u26R0KePss9r/nWxmUquwBB5WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8V+XO1z13KPHg4JZFVlOmxZAuGjh8gUkGGSasnR70Ew=;
 b=URmB47iGxpNI8y6EfVJS+CZ5BY4N2C4ypo9gFT+Qx5N9noZQ6rHVpxOgCDjmwER/hvc84ksu4ftaddP8kN4Ryg0E54Hq+x5jOzjy0Cqc+d5r4BgtFkEpa7WVarlWHd9E4ks/oF4KI3yytONiEKSrx2p6RDTHmgVJfARdxkwVFP8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM8PR10MB4163.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Fri, 18 Dec
 2020 10:56:37 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 10:56:37 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Zhao Qiang <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net v2 0/3] ucc_geth fixes
Date:   Fri, 18 Dec 2020 11:55:35 +0100
Message-Id: <20201218105538.30563-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR10CA0100.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::41) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6PR10CA0100.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 10:56:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ad25e0f-ba58-4aba-8f8f-08d8a3439792
X-MS-TrafficTypeDiagnostic: AM8PR10MB4163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR10MB4163FC2B9B6E7D475E9B189293C30@AM8PR10MB4163.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: evKC32Ln0z06vhX4a55mDINMlVEmS+IMckfGaGPdQGFZKb1mYHwvPlih0hnKVoDWukb0UtsGk5Fbx8Mf+iBEJH3TXBmX9boZmfQweWvbLvgtQJV88hOMHKpBhMSLf+wN9Pi+XVYjRyDILD1k8PlUI9dht5GuvUIDtroiQEXc97rn4zBFvhqV0RpADJ6+OtstaUCrGBi6o+OhX/ca1l4aVnlYJFyI34ESHfihJ503XpjFd+8hx+VUoe57Vh04ovmfJ2utQqum1LDzhare/NG+SoDPbofRyKunx97nHo7uZaYGt/YpORoEoHgmz7PC8rMEIXEnsgjfqHwy0LWDaH2Khg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39840400004)(396003)(366004)(136003)(346002)(44832011)(66946007)(36756003)(26005)(66556008)(2616005)(52116002)(478600001)(316002)(86362001)(54906003)(8976002)(4744005)(956004)(1076003)(186003)(2906002)(16526019)(8676002)(6486002)(6506007)(4326008)(83380400001)(107886003)(5660300002)(110136005)(66476007)(6512007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LoMgdhuwWnPA32V1u6PY325qbo7mlcnxmG3KUX/zc0Zjp6z8/0Egmv6AL+Vt?=
 =?us-ascii?Q?kAz1DRX+6U4kHMq0Vd8IfjLKBFPWAbZByiSPy/nlrJyvUY6A78TRsKk7ksy8?=
 =?us-ascii?Q?ayx/U//+g+FIH3mqht7/KMBn+DWzhIFpkeLznM89NS29XL9RimYhZ/P4Oo44?=
 =?us-ascii?Q?jROAjoTvfj0MqqGOYLVLaRdDyrqSWCX0lMDEEI9ou5SIxA12Hiyt40uLENy2?=
 =?us-ascii?Q?O9dYk2CMVDrPWsNthhhWDLyvdbQ4vsa6wTS9hDWwTqQTd8PPSG97vQj3SMiF?=
 =?us-ascii?Q?dWDUgDbb1uDUrYBJmJh335sUWRJZ8RUA2tTt+kHMYsTUv5W002h/Z5kINE3/?=
 =?us-ascii?Q?r4zjVetfBA8FTI+94BurQNQI6dRWQO9oJyKXE/v3q7lwBkdkBaidN5WwQ14o?=
 =?us-ascii?Q?Z7E5ecE1lfpnrJ4XWkhGuqNMR5avcbMeFmQa4g6GyeX/FGt42pmnK/wJ++Lm?=
 =?us-ascii?Q?Ehmw+tWOWN228BLK17gzupEhYQlLpERqNieDWXwiLNFsaex3T+ITWpXmyuZG?=
 =?us-ascii?Q?QHTcuVcqNbXNNFGQ0FV5f5StbMBMh/nLLpfEzaLkg3cocTxm9EG1X5HSGbNu?=
 =?us-ascii?Q?GSlat4m5O3HRNda7be0Pq4vEBIwMFMu52lelPEcItLMA8dgKZoAggIKfEA66?=
 =?us-ascii?Q?oHxsCl8aPKI3dGgxckwKEXFRMbN2xzYnQniafvsnpBi6hX19s9aGjpCV6M/6?=
 =?us-ascii?Q?kgpmWPb0bnOba9dp6sjStyLfB5c/pTc+jxOAhbrY/ApZUOQX50DE1q1/VMy7?=
 =?us-ascii?Q?IAjbUYh6xOSh3uwojvpR6FBJy0NV2cUULkrewCPJF8JJXdw+Zdh1n3bCaFpk?=
 =?us-ascii?Q?AYDOXE0N4kA/DhKuKPh7LX6mtQLGbTCd6CQvTGTwPwYYZEuPiy06cyV5g3ks?=
 =?us-ascii?Q?X1nZsDWZD7wKbo2khYaPhV6WZGUjNgfB20mzN6lpama3MQrXKv0mgOXSvykI?=
 =?us-ascii?Q?Lc55aakh6OeX2VElvH6ujzZ06suIqwxD7edv+FSiNghMYiwLbxbZQq4xLKfN?=
 =?us-ascii?Q?lJBH?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 10:56:37.3096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad25e0f-ba58-4aba-8f8f-08d8a3439792
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eowl0ALoahptBCT01n4gLZs1Gr+MHEUFRGh8ZmX289OQ93twDDLz7gKLmLP4yeQUoHs9R0YIStY7BO4AAvV+7yTpHGBFIFsyn/e/cUkoK/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4163
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is three bug fixes that fell out of a series of cleanups of the
ucc_geth driver. Please consider applying via the net tree.

v2: reorder and split off from larger series; add Andrew's R-b to
patch 1; only move the free_netdev() call in patch 3.

Rasmus Villemoes (3):
  ethernet: ucc_geth: set dev->max_mtu to 1518
  ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
  ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()

 drivers/net/ethernet/freescale/ucc_geth.c | 3 ++-
 drivers/net/ethernet/freescale/ucc_geth.h | 9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
2.23.0

