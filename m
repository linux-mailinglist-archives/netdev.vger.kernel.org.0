Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9853956D075
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 19:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiGJRXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 13:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiGJRXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 13:23:11 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05hn2245.outbound.protection.outlook.com [52.100.174.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AFC1402D;
        Sun, 10 Jul 2022 10:22:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNKnR6MUTbhYE5tJKblPywpFS/MWAg5q7wod9tCW2FtA5ygBXeFjrCNzjvFZM5JnyyV1UFUe0nyzs/SMjBVCfNS6OSEzdaV/oW5MnE9443MqhJTEEOqwag22wxB3K0F2mJfsxxNqLunMBYaVJ5IN1lEhInCdz4HbLlXPciexGaZqIzT6ln5dEETnKsSbb0W9m0vsxm9OO5U9zM1qt3Qoel3Q9o/gROMIzDGfxlKGt27BFWZCgZgCDoYRphhuQ8dfVRn95fSGOyexIh9aGh+z4y4OELDo44Mh+8RX7aJMCgkCEItphG4Cu+BvXn0br4ADQewJELU1g+PbBW0a5Mcj5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=IuyjTVLyUlcKbGC2K7SP/8GqnfN74zv7Ijwl9XnA/wVqD5EUlFw+hkYdJU5Zpp3MmoP03+hPIephPTMYOsIt1+y3QKKQpS1zEAUJhi59ZPr6dA87sNoSneKOKZ1AEqHDlXWarkLmVia4HrnqeY0MYLMv+tsi9DWFaLakUdJwRCTpZ2P0HFH5dK7ULy3VS7PmDP/KDFasyT4SIMWC17wzqwTPOF3upJ66//pbLOEdFJP07V6yQ4mjTE4oB5JrY9R+FhTG9Q4KFaBZMXe/RXXncxUe4UNVv02f7e3WqEluO7bzUPINzg/uYWhIx7Qi/UDvVY45r9/9yMaHb4kSwvQaIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=qyhat7uikUAKowZMTaXGjJ0wUKlvaTTj0ILQiDcYbqqFQufV85lALme08qbG+Co9l4cnXgb2tD+vMNRPlWBdvoU2dr2xqbwnTr+VeTlnTYXBuLUmJz/yic197Gxq78c7fwhprjVM9zchV2OXfmhWSS0Ai+AicoBWrYQkG4/N1tM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1109.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Sun, 10 Jul
 2022 17:22:41 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::d521:ba19:29db:e42d%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 17:22:41 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/9] net: marvell: prestera: Add length macros for prestera_ip_addr
Date:   Sun, 10 Jul 2022 20:22:03 +0300
Message-Id: <20220710172208.29851-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
References: <20220710172208.29851-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::28) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 724893ab-237e-45c4-932c-08da6298cb5d
X-MS-TrafficTypeDiagnostic: AS8P190MB1109:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(13230016)(4636009)(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(41300700001)(1076003)(6666004)(6486002)(6512007)(316002)(66574015)(2616005)(36756003)(52116002)(6506007)(186003)(38350700002)(2906002)(38100700002)(6916009)(54906003)(86362001)(5660300002)(478600001)(8936002)(66946007)(66556008)(4326008)(44832011)(8676002)(66476007)(59833002);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?e+h3Qvs+qxEqR2EwwR+ORsCrLiw85NtR6Dtm1IZdGZNYg0CBLOvmUbHrdBFt?=
 =?us-ascii?Q?UNTYGw6vKS7WXrnW3fR6OdfmXZObSiavfJsdz07CsppKUGBi/a7stopxlCFm?=
 =?us-ascii?Q?lkKoN614br9v/3lMRyouDDUWijtkjV/gPOD8mmYJpkgogn604wuENkTewdpm?=
 =?us-ascii?Q?Gn2753winNJ7qg7pkEzzNS82ND+m/GD2t7PztnbzbiNdThlJlZXRzMx5MP9b?=
 =?us-ascii?Q?/t5yCaywfqzMfGd5bHEdoEUgEFAQyCb8DWE151a0YASb7pinokbTuVvdTv9A?=
 =?us-ascii?Q?VeXIqW9mJlo/+7HcSo9+V0pZOaMKRUpfGHUjjwKKKkrqjOWbnWbkOpgPdO4T?=
 =?us-ascii?Q?uXhyZCquaDleJYvrA60h0NopwLbvjGHrNJLsVJn3j7bPHwBcHrccfE0CiSly?=
 =?us-ascii?Q?xryBu8KO2CJF66U9DsTa4mcnGwO27NrbfFWyiKNh1EhoD/x9nA3McqWKdtu8?=
 =?us-ascii?Q?hPNxndl12QMY0539Op3IAbpj1MgKGYorHF1wy74WXlSdAehG9yvf9gFD+10R?=
 =?us-ascii?Q?Sf7RgB7QzVl2jKvx/7Xc6CkniAg7zukky0opfqtpVWpD17L4AXBuxiD2ns8+?=
 =?us-ascii?Q?KVJv7NLCkitX9NYHGGNmWXgQDU49oNApgPD02i/pcSRZbkICe5dmmdaOFp8T?=
 =?us-ascii?Q?7UGSZrBAS2XFaoxH8w9o2BG0uvC3iYgMm43lxdAIcEAPcs0VbLgwvpSyliAF?=
 =?us-ascii?Q?Hc60Sm8RXH9jSChsgTKDSDndtmomOaRM3hOoL6Dk1qqHi12lFBDRHpYkkGEK?=
 =?us-ascii?Q?90bAe4mXJS3gKW4BmnVTnkoSi0tGzJMNFXnqVabSwmJEqbs8vULBC8vlga7r?=
 =?us-ascii?Q?vvTo68KTB9ZvAPvQ5aJhRzO3SI7h5/q1zS1xl0MzgWpX8M3dNQGs5p/Hf/nf?=
 =?us-ascii?Q?1ubKF0ffVjj89yRKe9v4CogNGRALmaTIoMzgDJDaFC+jUUpMpQvpcILIyVHx?=
 =?us-ascii?Q?a/K/nRw7Ie+jZg9X19SxEfucsi62QnnznScTjt8MbM9OSXrlzCRKi7byEukX?=
 =?us-ascii?Q?pDxZXu2jkh6MhJeJ0E4A3Ea9fSHCFvIsvwHeGWcdznAoNVnc4e41GwR96x2/?=
 =?us-ascii?Q?yV3EMyObfGGMvCxrY1zHT9wb3qA3uWS+JMOKjtb+CcCaK963buSv2nlZK/Ga?=
 =?us-ascii?Q?ddJFmprPASaBVh1qvdLiMqkVdlEwhObjtQ=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2EphegT+ZZ+8DbrD/pUI10A+macL6GI+B2iqRqib4iwJ5x/9vwxUa1x726S1?=
 =?us-ascii?Q?YEHdpJbJjwahmL5ZWOa8b0oRMH0mqoJrLRgHSIfXtlxi9gYm/tzzfLFppiB3?=
 =?us-ascii?Q?hd4n1ryeDaYRPS4Xtk7ut/MAt2xIEqSvL1DnTHsF9NUEK/UAOOm6X4cDnqhh?=
 =?us-ascii?Q?aWdZAMIVeBLesTIJrRjUMo4SUjmlDGzYGSs46Fdt8MheQRS9KAAJDp8Mgvkz?=
 =?us-ascii?Q?mxY687iM2dxEkqXAaGtV5ovYQnaFgEWyq7zXNRqEsKPwZL/CKY9xuW3K1GjS?=
 =?us-ascii?Q?kqPcFy1H+gJpzd4bntCg2ztrnraxsW0VubcKRQZ3bfikKYpNzNNN2SZC1/Ky?=
 =?us-ascii?Q?1X8aGxYaCsVvLWJMjOtNyOpuE9ulH6PavwYnWbEIQFiMUpmPwc0Q5EigwW0W?=
 =?us-ascii?Q?JUvXzvUmYGAsflFpTXt/gTPnix7/norKLkuDmuDW8/1REx88EW3EaayTapJm?=
 =?us-ascii?Q?1VTSOkgfqfZyZx69aPvShEAb1GMCL+pKLLzLHYBOeUMImgbgcVC22Ds9VzsA?=
 =?us-ascii?Q?0gkrdW7d3+iUPuy7CVsPwp6KK4ksuJxKk5eROeocuA7X2KbP4flEH9GznHyw?=
 =?us-ascii?Q?2CDVopPhg3R2i9nuLgmolSGEDdlYZHtsasPqzsAqEgPh4imxACIcYWHS0iGP?=
 =?us-ascii?Q?nGvwTICtT903IGg6jHuxoGvkGF4qmWDOrx78CrAJe2/+IQqOd5q8FjFjdDfr?=
 =?us-ascii?Q?A/sKlzWUlb8RKwwp5bi2w3NnxTBB2Jwez9ZBeTo/HEW3XGYYsLDCfIOSZ+CU?=
 =?us-ascii?Q?EyEXi2LwBeoQtB/AJaKq1nbdVE0zPYhZF1FSIYzWQGLFV7fFgmYVLedjB6pQ?=
 =?us-ascii?Q?vxLmqcB5EXadthMVwv/v6k3a+sKDXd8XnGvhjJfu1HdRM6yQ/pG8d85eIel7?=
 =?us-ascii?Q?alsHh8FIBNN1VW3ikllBTTZiz8Ew+/QqVwws7fQ383TCY/M39o0QmRy62b/F?=
 =?us-ascii?Q?9yukNLeI/77mi3hpij/cj+326Tr/VJ6nMftfjepOQGs6TxQgYaIsxKOgY5em?=
 =?us-ascii?Q?ey5NDbisUwCHt1BJMgyzfKyTQOlMmoDtHI8+9bOOC40DI+dCgetbw4kGqH4c?=
 =?us-ascii?Q?4BZJxoLBN4ft4dqTlsqBTksP1azJvdIZ3xy7snzKnuV5RSAgjy9GzmJWh/Ef?=
 =?us-ascii?Q?kZ8XqwO0BTN8dSS7ISY547F7KBg3MegSxx9A2fsBPccoQX36US6Eb9+cvtS2?=
 =?us-ascii?Q?4bMbnjijwvLvOO+BjksCPTlJ2O8UQKIEVbCNOAVj1EFeTwuGWEPmSsfhHIhu?=
 =?us-ascii?Q?TWml+5M+B9x6b2UWuAqFn5X/0M4zgTBw9iX85FcLiEUXvoS/e2g+sbmliu61?=
 =?us-ascii?Q?VIBG+YqT4qNF0NT1j7eY8jUZ3w9THCMCq+aB4HQ7sF3BW7AzCWTnX6GyKAlH?=
 =?us-ascii?Q?OuF+TlTiZkAEC+g6Ld7DX6d9hjKgf0s4ogQkXWJAr9EZSSiX6pIwtFpv+aF4?=
 =?us-ascii?Q?vQY0LnpHBjxjer2CnDOoMB3Ov4WiVBiOeXTC77GnGYWEmyy8bWRm5cMhp3xN?=
 =?us-ascii?Q?FVtySAMieMprBFYaHun47CUj3SaTdgipmvnrBgW+QlrUqMYaOPaiDqUlW5UZ?=
 =?us-ascii?Q?7r1ApLQdauhXNxMfM+lhi7XIPx54DksXZU+oxytXdHfZsQPHq80rQZBBkf4u?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 724893ab-237e-45c4-932c-08da6298cb5d
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 17:22:41.4211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u0axz8BNT5cil3gM6SRo2+vs2/KMt77XDXdDYXpTzpPsmLfFVDne4RsiaOZEfcuZS11OGF/Vh/Mmc19HBHRqIR3gFjjYHKG6pqN+BP4vO9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1109
X-Spam-Status: No, score=1.0 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros to determine IP address length (internal driver types).
This will be used in next patches for nexthops logic.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index 43bad23f38ec..9ca97919c863 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -31,6 +31,8 @@ struct prestera_ip_addr {
 		PRESTERA_IPV4 = 0,
 		PRESTERA_IPV6
 	} v;
+#define PRESTERA_IP_ADDR_PLEN(V) ((V) == PRESTERA_IPV4 ? 32 : \
+				  /* (V) == PRESTERA_IPV6 ? */ 128 /* : 0 */)
 };
 
 struct prestera_nh_neigh_key {
-- 
2.17.1

