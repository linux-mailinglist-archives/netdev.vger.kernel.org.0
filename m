Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97224B3ED2
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 02:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbiBNBNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 20:13:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBNBNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 20:13:39 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2135.outbound.protection.outlook.com [40.107.22.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2794E527D3;
        Sun, 13 Feb 2022 17:13:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GspGhb4IgWJaFdPJv30nllFXED+uosYcbhN6mqOxxDckqGhpcCGrvJxuxzDAXNhPH0Lh5en23waFiTOp5+/9YJAA/Qo5tPD/kODJT4pW87PtGCB0umgzO62fHGxGb/R1JCwnWEf969ifL1C4QwX7JnmmO3k0HEHCBn1bpM+/074WBf0xDE9/bjlB7Kg2pFcJ8pPb0KHzZLEQyQG6fS1135uZgq1zJH5w2yS9VELyA4OGvRHy1m+bUjW9VN0cPV18WSc7cmFcZDOUkx4ZL2OJdxKby7OIGcCQVtBd9oGp+/2xX2rawMP+m+Y63uWGHZgzIkWP94fObdNmUOBoHeGShg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6od7VRUyVFGNPGxJj6mpfqpcgwp7NkUJVG4PIxYq6/Y=;
 b=c1wquMoxWrLnLFGvqAJccFp1HJLjVMwxz5uOQFJIeEmk2HWdQygw4WV/PNThZ15FK+x1qjxeO/arSL9AGVrs6GEJ/c5ETy7SULSx7gmeiNgKZAETHhyGEJSHS4QbRcjm9oJqY6O/BUBw1j820KCr/XlliwIAP43AYu1sAnRsm2uhbDSlY1ngqhM3+U8Z2V9nWlt7yJyiCOjEvSNc4jguZmLz8hQ3mbc6AWCFarni8QUUk8x0iim5ki3frtDpcwVgiP9yTR3wMuTdEISLiGNoHvnC0l8M5pPDLrpcXBcrJn8JJCPRR9oG6/W63D/4GhPm17OoMnGyaqHI7l4KJ+ZOJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6od7VRUyVFGNPGxJj6mpfqpcgwp7NkUJVG4PIxYq6/Y=;
 b=ygq4lgBSwV7t5PBgxsII/hPTZPDeN2qeKH9lmCJ2Hw3mc0r8L7OziOlSQOvXWsCOSme49RNo3kycfge8Bjolp8Nws1dXBXYBfjkJb+1/niY12ebHK4n5mmGH36j8nTVOb0RmNqwxUUUghEt/KuQrPtYvgfk2NfNkai93Dr3dyR4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by DB9P190MB1098.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:22e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.14; Mon, 14 Feb
 2022 01:13:28 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117%4]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 01:13:28 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: marvell: prestera: Fix includes
Date:   Mon, 14 Feb 2022 03:12:28 +0200
Message-Id: <20220214011228.5625-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0086.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::22) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08ac4925-ab3d-44ff-2c8c-08d9ef573503
X-MS-TrafficTypeDiagnostic: DB9P190MB1098:EE_
X-Microsoft-Antispam-PRVS: <DB9P190MB109819254D5194534AB0F1BC93339@DB9P190MB1098.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vXhImy/1c0LN6ffkBO1cQqH1yN5I8ch9hcdP0TBYd2ymVnhy/d8nGs5nlEGFhW2E4k6Li0VYoTUItJ9swQipYdbQ9tuk8bQc09MZej4kVjyJFBBA47gqttLFxVPeTLnYnCgYwKlWssLHq3MrT/8Fjxhv27qoX0VDnjlBw6Km1G4E1TWj+kL3qFRmkUHJJ6AYHFDgXrhnqI/visVnBKV8YBIvUHnF4MZ7Qr6emD7oBg+tLcZ57sn//uV7G9aUwj+AmYyePAk6vq9MbJxXSm5WDxIkIPhjD84lr7wkvYlMKiRS0zM30dG57G+qrwusB3tH4LV6+ohyWE+Sdc3+oMA6tJHYFSLOeW9cFJCbaS1az+EHPqxG/dgOC3/j375L4isc3ypUF5huhRxbN4p7GBgGCX8Fn8P97FeXUD73QD3uJkkDREtOwIEmnAx6S/rtOgaE/A0zbv1qJFUiBsyIe/ioIdF5z9VvRH1zDfDouSCVm2xLWc+lWpnxdGQl0khLJxZ62LrPDV/A2B+eruYwW4Q3B8e+R5rGl94xGXcQdjpmYTLjIFpbXFbrdmWxb3t2VvROt2cLP/p42CX2DYwfhPTu5Am03UVk9YEWCIH1gSwK2xr8TO/GoWHxSZAQZ/4lDsdVGJq89h9CVrb6pxJcW51Yid17rJ8cfQZDRmiU2xh0I/js2W9GYG8GrPVpeLQcVp6hrdU5SI2cF/vHMCocTzBM1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(376002)(366004)(39830400003)(346002)(4326008)(44832011)(66946007)(36756003)(2906002)(86362001)(5660300002)(66556008)(66476007)(8936002)(8676002)(4744005)(52116002)(38350700002)(38100700002)(54906003)(6512007)(6506007)(6486002)(2616005)(6916009)(1076003)(186003)(508600001)(316002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xenz51kzyMu8LE7AjbXcnnvbV4kTGXSdqIdR2rF7Zf6kEes7G6aVZgBwygTy?=
 =?us-ascii?Q?tcmg/gJTqw1jyWta2C9GKSD9f3jeF2Wh/cDYi1mtWjmDkyTBNNg0xwHZqOS1?=
 =?us-ascii?Q?xnIKo2Ud7icxlYPd3bfg/Qe19KOeia1Wd6twfRKIKP6bek81UANa+/rfdO8n?=
 =?us-ascii?Q?kuKVauUoFTrInGG+KOnjZbfhaNoNGuGTJdtl1BKFRG19AgwYk9gdr+3veMWl?=
 =?us-ascii?Q?wRYUqoRPxstggnks+eQPTwcm7Y8aGMeHeNvszeoq9c8wcHFN1jnIz/5TwKcg?=
 =?us-ascii?Q?AreL0ye8VB7aoH/qX5VLIZJrHNSLuEYVMbQeqj9uyx++IJ8UURUfz/zupHz+?=
 =?us-ascii?Q?hFzfLoUtpXc3nxWFtQu1oPABtRA0Fgq16Gcg2SFVKqilYUf/FiwaOnI+3Bci?=
 =?us-ascii?Q?YrGh5qJ8BgazRGLxrftCGz50YRBIWB9YEbPRKM8q80ALyG8O3oGtdVQqyv9f?=
 =?us-ascii?Q?JHYs4duBsqnlPPuIbc81HoXziBEcj/iIhIiFM8A911iN/V2nXwc0RI0ypUIH?=
 =?us-ascii?Q?F7+vsTqP1eZiPQ8etZW87ODfb1SIpD2TKP5320dSjNVoLGaZOFrNmMsmi31o?=
 =?us-ascii?Q?M/MSQS3wNMA1gmMkigif2SAXjAS0e4XCukdhOayG8e9PyTejx7ni9zT80XJm?=
 =?us-ascii?Q?UOuvuk5ilA1Flwv17ci+ptQbSKo11QTL43jZicOLar7zxbVoktCaZWvkvmzh?=
 =?us-ascii?Q?/ZPv6zgM8s4QalrYGWom8GStS9Gycw+ux9sHlRLJt/zyn/+Ut9xMxwQVezwv?=
 =?us-ascii?Q?g4hJItI9Wfi0bNQxt+jURF4VZOUfy4aAfN11kpiEm4JGVom7+FIOMDdCiP+M?=
 =?us-ascii?Q?lbnrj8IZxAsCFKkx9K6kStvc7FCE+2ghRTUJoBAYewGyQJk/tcyxukbUC/do?=
 =?us-ascii?Q?kYOlgyjKi78AshhzcGvYSOxg31RyHdhePYWKu4XFBASP02k9vttnu6zjacmy?=
 =?us-ascii?Q?BBThsmi67Ul+ZADWz5hg5Wy+pYEJu/vqMI8ymk0kLri/ATthvTjO/TiptaR1?=
 =?us-ascii?Q?9VUI1JvEQo1e2fhgRsW9CC+up6NI/K1Ee97Bm93zjv0x6RX5TYHE5w2+1inL?=
 =?us-ascii?Q?PAknwoaMpQAoGzGk0i32Gyj469UQNwStzirDbApq9559iHwcOk6unOCD9zVs?=
 =?us-ascii?Q?jk76Y9TdTY3c7mRYokR7fhw8Nbh1Ktf7V0LT3w6xZ4NCaQrOQ/m9j1f3jGL5?=
 =?us-ascii?Q?E7cjI9a14FuOUkEMk+QG5zmXzoAOxcwprucv43v+osLBnAThT/XPKoQs5r7F?=
 =?us-ascii?Q?HYhlCXq8i+CKt1VMZxuxVi/U2ILqoMXcMtaOsfh8vQNbKdet+9gvmF8U0pAt?=
 =?us-ascii?Q?0sxbfTD77fSPHrrJIMWWmI3AKh6AaqbKY25obgx33DH+58q9adjrTmlEoPPm?=
 =?us-ascii?Q?D+Dyezl+UPAkJtu6mS1/yNaHN6qVcJSgSrfKfOzYt4csSYy1Ht6XoNnaLpRI?=
 =?us-ascii?Q?seojWcOpbaQikDKFa7eSDWl7o7b0M3ROouFLsiC2LUzOYV/1eMGvWkh8pelj?=
 =?us-ascii?Q?Gf890hOslHEIcoeBxjTr9/9tdoKcO5ddRvfmR4czsTDvP0Ovcwis53KiCY9a?=
 =?us-ascii?Q?4EU6YI98WXrPRf5pNuoRYSkLXhNMpOiQGu/RlEj26uPmGhzFZ5G711xW+j0r?=
 =?us-ascii?Q?L7qZ3ShQsjquTU1XOebzv4SKsKhDNoweXJMkPDeqXYRN62YnrpOiftorpQP+?=
 =?us-ascii?Q?Xpkmeg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ac4925-ab3d-44ff-2c8c-08d9ef573503
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 01:13:28.3197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6esh5GBBym8EP+d9ImOSDRS6IXW6fUH7pSNK1pNIX4sdJS7c/oIpDKNJ4sNwqmpS/5Kofciu7K7wh5APDdT+Jz1te2q0yXOxtEXPAjAcAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1098
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include prestera.h in prestera_hw.h, because it may contain common
definitions.

Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_hw.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 3ff12bae5909..24f2cf1c875f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -5,6 +5,7 @@
 #define _PRESTERA_HW_H_
 
 #include <linux/types.h>
+#include "prestera.h"
 #include "prestera_acl.h"
 
 enum prestera_accept_frm_type {
-- 
2.17.1

