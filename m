Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2931C529774
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbiEQClu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiEQClt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:41:49 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2098.outbound.protection.outlook.com [40.107.117.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71702271E;
        Mon, 16 May 2022 19:41:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqEGwCMMxBYwBVVtoJQHeydxcehYxK891AzNbNgp1wuohFycOtnCW5HrTNeyL4z8e/p13DGcle+db6BOZsZI5E8Ttt4m5hr3mWr7TMFVJOjZzgkRK6A9AJHC8NClFmWDrGg9JLnrqpyBNXAknXuvyQ+gXjNPnQ9GVefWlKBtnAoCqaE/UQGPfV5F8FA9jjUAZJro1DoJmzAeIMXM9cGuOkIZS0+UOwzLugJJ6XWHd62d2wltKaJ05EAd/X246wLJTEHZ6sFIi7KCZMBDBHL/hnNL3p7TS/z7B0gRV1vtFlgkzE95yPeNzZNfEgECwjovDoNVqMTrMzU51+4vYareIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1z5+fqQW73EH1Uz88Qrbw4Xb1UTgCrRNgp1Jh9tnV54=;
 b=eG03ROnJbXfZfMTxmwB7YcRgiRY8r9Lfr+P5RYh4C+3fZmWinAzlKpK8bLKLy2mThhUg158hXj8KZFKVPrP8S75KvWJzIcQpEqL4Nqew3Ax+cBGIx6tUzAfaQojY8Ee337Hiw1yyxiZWqIviAxFlvbR/U8cuCDZ1lyBA+DQut5BVzw89A2F+aI1i979qZgMRQBHzokUmK65x4348UIIsTTyQ0VyURAFStwDAJ3tReujClz2KhbQ8GUBBM385PeIXvGS/73L6HFUS6lBkivI0uZXRaSeJiAIqb36F5eBFqDX59pYRamQPEAGw5CKkswe+dwtS/xQFXqeDDEL0i7ZqhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1z5+fqQW73EH1Uz88Qrbw4Xb1UTgCrRNgp1Jh9tnV54=;
 b=EOGRhxm/BetReTlKJVjnZga0M5UkrOcgz3KNX9CsHKjP0I+pcyhxvOT7Ntn76zXFnHeqzePbCJ9IeVvsvtv2f/0qupqHy+8lJnAjrvJgXDC6FGnerxqECJMcJFjWd6VysdotTXdEf6bOaTBYNaQXfpwwCoxVFDpGq6vJBOnz5Sk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by PS2PR06MB3622.apcprd06.prod.outlook.com (2603:1096:300:6e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 02:41:44 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 02:41:44 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:QUALCOMM ATHEROS ATH9K
        WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH linux-next v2] net: ath9k: replace ternary operator with max()
Date:   Tue, 17 May 2022 10:41:06 +0800
Message-Id: <20220517024106.77050-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <874k1pxvca.fsf@kernel.org>
References: <874k1pxvca.fsf@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0009.apcprd06.prod.outlook.com
 (2603:1096:404:42::21) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd1fb0dc-4994-43cf-380f-08da37aec7eb
X-MS-TrafficTypeDiagnostic: PS2PR06MB3622:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB36221BFC788949BAD998E675C7CE9@PS2PR06MB3622.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKfImLTYDs1U1W8XEZfMuCGE1R1tXMI0VvavXLGS+6qEoTcMSwNaRazW88YwevbULA8DRbpyU1Sk2P/fl0m+fGCk+aXj+zWBThbK6Yv2GjCkTZBHSdcGJTRBEOcgGYEeLGq6HTsFvxEkJiTOKG264DRs0YpcLMELVlHG7Y3tgo+Npo2K517SOkJH7UTu9TgmF+t7lo8mxEzV1fCiDE5/+QQOxkKajWon1vCCKEbwfESsJ4T7MYc56QWuyXmTJ5nOutT8uCZ7x/3GXh4Kt5IGRZfCETpMtQrheUgiFHXxiCx4zRh+nJgDvTzq3rLcsMa+KJBHFmivTwXkhv7/+jCiZrL1WEuLao/UIGduRke3nxh/TUDmZQWyxJqDIKSfDGfVuNH2X4gEdrQmun6od7S65aZKVFDBe2vZ5BuOMDCE4klxwpIRw1B5JR95k6G75E+Muvi5YbmLICSBLV6XmyQgo7WNmmH5kvSjzVWtKy1fsd4FXJdFHPXmlLAdMIyeXruDthQzd4imHPvWK3XPXDE1G2cKZn+l2mVWGM789ARQ1XaZVK91mCUeo/jPl8TZJOR11FT+4mWdgxvKjZXptGg84aPD5F0bfCUbwLCB4oK3PqscuqprqEBkv4zeEGAk6kuJyqch5nZz3z+V2CYe2PWXUtMo22OcBQNsVuzirQ2/zQb27+wq20uhzvqqYFoto2JAo+WYi6rL2AIgx6EGKcHclg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(26005)(8676002)(2616005)(4326008)(2906002)(52116002)(6486002)(6506007)(83380400001)(8936002)(508600001)(6666004)(6512007)(38350700002)(38100700002)(5660300002)(36756003)(186003)(316002)(7416002)(66946007)(66476007)(4744005)(107886003)(66556008)(110136005)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?62NkKavqPaRCDcj5YpiHPESyKZ+A3RyK4NhQx7RTE0quOhOJPgPEyE0IqlYh?=
 =?us-ascii?Q?DXhEohxHSjfVVC7+HQW7Z83O7jCBqWoTO6t8svkEbTVPLkIrEPNEbTmdw8y5?=
 =?us-ascii?Q?P4WeEleY3hsQ+MhDEnc8hGRWARR6j/c4QBUk3tQEpgVYdPaEZGrKCEIxTt6O?=
 =?us-ascii?Q?wNZ6sTrAzy3w0KNVC5roKNfGlLgTWKwRzPwFMCxo16xXp3F8OMXmndUAnHrL?=
 =?us-ascii?Q?LzsSpbljJt+nS754bCyV3K/tx2m7yKSsMI8/2DOkTyssmc4pzcgAB6h+Dkdd?=
 =?us-ascii?Q?iAYIaCYu/lpzjb6dgKnEy2ZKeOAf7GjFRdAWy4CMFJk1cirEROWJ5IkAMnvj?=
 =?us-ascii?Q?57IyxZ5WUTCYj4ScJID8nDmorbiITe8F4p/kT1q2p7f9ifrDKGnzk9+0Nnyw?=
 =?us-ascii?Q?fbYqUeGvW6Dyqclx2iI0QDYOCKt4y16Usqi4JykeMVIJ8tYFP6yuARltpsRi?=
 =?us-ascii?Q?5h/XUT4OaF3mGCU4rP6HHH9nnf5GUSEThSB68nnYkfj/bBzJRh16xWwlpAfS?=
 =?us-ascii?Q?laUUkekNWbCS1+XdAVhp779S1HjQ5W6xeM/aUTJots4Zaqep+YxPnSyv0W3n?=
 =?us-ascii?Q?JNh43DpHAp7gpMTppg2FNFIyuIq/RAjQdUoOayUO2t+vtEn5+YVKfIkjrF9i?=
 =?us-ascii?Q?NqgsoInwsC+XGeP/76ZizfL5s++PIPgHnPtKH/+47i3Y8PWLnuM9ZEHun9Fn?=
 =?us-ascii?Q?lwm5A5y0RYG8ip+8R3QcESXmbMbSHtu4FcSXcpDApE/b4KDqSij/HZ1unkig?=
 =?us-ascii?Q?C8CZO4nnEThHk7Zx7hG+ZvDp4IL1pkCuA8HE45IhbhxUgunOPdta1UlfVwST?=
 =?us-ascii?Q?TI20xCY4Y+T+6yRXOCxN92eN9Ag4SfEGtmwP1+YkxsLtbuIxj05n1PxOyWAC?=
 =?us-ascii?Q?lGJJMi+hXVb0OfI9UKG85m4LJ/8sEvpmaHo1AOa1TrzBV7eD33kolhbNng05?=
 =?us-ascii?Q?Fmo10v6bQ1pv3hOIztmNwpceePWnbjC20pjAt4uX4rzF5FOo/lxY18A9ehiH?=
 =?us-ascii?Q?kOZKTC8EmxlXZ5nrPArJHWNgmY6bTYG1W2kmxaq4gOmIw5nwuE42J4ZDGXEC?=
 =?us-ascii?Q?hnXqvWQFSdzYsXQIHzBaXvSMw5fD0qIOdEV+GH/+597QxSyaW0zXmRvgfgkO?=
 =?us-ascii?Q?kNnlZCVjBeUf4SUw0EKumW3P6fd8/2fnSoBk8g7QLEC9Ig9wzZ3/9W9cZfV+?=
 =?us-ascii?Q?6T+8jA5H3dWhcyjewOx9yXUveHJGIXCS0+x14cHyRiDeT4kWdsJJ1wGsJS/L?=
 =?us-ascii?Q?ec184Xf84Ve92OT7o2whjb/9Uj8LpwuPkM77baX0N3LchRIbHtCPSqn+HdxV?=
 =?us-ascii?Q?sfrHh5gahztuUloEoTercDPbuoNlvObUOk3bZUR5kfd/otpA8v2pm4Q7GYY0?=
 =?us-ascii?Q?fG8vPfzeGMHbo5/N46Kfk6QvxRFZFN7yvw8AX0KQNokXcJSEUPK8lzTpV/T/?=
 =?us-ascii?Q?GPqfJcT51qi8LEfmt7LmOopTDmlyDvHRrgTsXG3EkNQmfSkozYuRSL/JQbQo?=
 =?us-ascii?Q?bizhCSPhfxgUMN52nCq2xWXgE1oy7r4XFUIEcb1nPGcpdgYynYcCLoOVzGfT?=
 =?us-ascii?Q?7QFsTbnazi3342UjnCt9ibFrLaPYImu0TFWOR9qiWnrZP2l6zz/lndu7EHjI?=
 =?us-ascii?Q?UKM49ubup2T5O4nOyGSnpux7A8IaRLtO+7mB62R2I7c3ncxm797xDNcK+fgf?=
 =?us-ascii?Q?js6bPScP4Q6kyeabnSLWA0U4nBbl7IOjogia6dx49QFai4q9+2b6o7htDHU7?=
 =?us-ascii?Q?49+N4xFrFQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1fb0dc-4994-43cf-380f-08da37aec7eb
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 02:41:44.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pp6KXCnwqGxLL6VK3RbwCgn21jUfnLZuQrIYnBr1XvfvLIXIYta8LyvBS6zL+aMdPFx3QOKYtHGLRNmX9rGSBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB3622
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/ath/ath9k/dfs.c:249:28-30: WARNING
opportunity for max()

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index acb9602aa464..11349218bc21 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -246,7 +246,7 @@ ath9k_postprocess_radar_event(struct ath_softc *sc,
 		DFS_STAT_INC(sc, dc_phy_errors);
 
 		/* when both are present use stronger one */
-		rssi = (ard->rssi < ard->ext_rssi) ? ard->ext_rssi : ard->rssi;
+		rssi = max(ard->rssi, ard->ext_rssi);
 		break;
 	default:
 		/*
-- 
2.20.1

