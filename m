Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228212CFE24
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgLETTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:19:54 -0500
Received: from mail-am6eur05on2114.outbound.protection.outlook.com ([40.107.22.114]:33377
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726851AbgLETTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:19:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0PWGthhQQVdlqnITrAuKqdmL4qhKy+o945wIpL9LMcq5D8GO7V2W/fFYZpPKUjBl3mQGRz2hEqvR95JDZMqDnw3pHzTF//OynCeDna2t9PbFhcKEfTJtCxAvnHygrfv3a6/sP7CtTVfPGa+ZnlniDLdKIVS6cdB5mnolEu57tVYseUfXCiqBvueVAHYF9uCuD5QWDY5XRqE8ZnX9rrsTnN4TpQtKBcry6mJYFqsi1gn51ICQu3eLfXwQ72KR74pOXkH/UKh+CT5Xqvz0jtOUrQtnf4OfdGbrAw4og/1Xtn9ap2FNr8w5/gD0ELj0anlYQnH2Ud8QxeIprZhSf7c5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYFfpagrFo/3cBGI3QDe1Efu6Hiw+YatR+iw/NjqYrc=;
 b=DV0PBbN1vx1PE//8C6uYh0g6h2I7CzNTt9QzV1xoAQsvgf29C0QJ23ze27LWfM3vGL8GMHyaJHUkzO9IrZEv9SIEJg/5cGwivS8yBhPGpYozgEFB3fiFMs8l6Gr+35suao7AHjRAkK58TEbbdq5o6OS9NuUG0u2LRqcFIjOSASiCOsxwhKLnymfV1mVJMraKUh/B9fUyJUHSAtVErz8tELB64cUJkMaeCXbTnAX5M2+agviPh50IkIEMGtcOohDLuShXtl26wu2d0faB+YEpfqmVf9YmaJZ5jWbdGE9/H4mG2Kxbq6M46fP7m5zfvHcYrZjo2U6YgTJyUwHjYr7aTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYFfpagrFo/3cBGI3QDe1Efu6Hiw+YatR+iw/NjqYrc=;
 b=fTPMG4+dk6c62UAdDzkd2yK3XyIGQWPYeXnwvOCFRq9RzzRpnS3yqwiuPPqwzJB6QhoU9Dhayr1KUGcwlgeGYM18YcCadZFC+L3KcE+x7gcD4ORske8ZDXBMc6oK5s60EOF6Th23whifQADj88nWeVmH2byvOiP/BlM9avOBabA=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:24 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:24 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/20] ethernet: ucc_geth: replace kmalloc+memset by kzalloc
Date:   Sat,  5 Dec 2020 20:17:32 +0100
Message-Id: <20201205191744.7847-10-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8eb9e5d-1eb7-4e3e-fda6-08d89952896a
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB13632820EA374319B9B28B8B93F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uQMUOoU9SJM0IqdSO7mlC9BVYN05P8g+4Z0Vknk0A0CU2o2HDbKIKE7Lf7vCVVr6VBVhTilOEXwP9eyGYMFacvOuvRlqrqlXHa0dXlsGR5O7JdI4mRvGh8O3RGPwixJQYWUmbK+3gMCZRskcHja449MoSTJpTi2JLEbiFolvbmwcaKoFIP88CAO5QhHa+Yw4Kv0+EgtdPLnZf3Vo9F5aFNg87FMsDVe7ASoCMe7yctnAx//OwleyUyxqAF+xzvldNdMl6XpOVxwphko72V0bTbdZIqUTEO1S8O3mFd9m8aIkVfWBJWOKWLL+DSf6CeQaiNtUQ7Qlo3EVSATDIEiUxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qPtm+IqXx4ui3/UlMDguk7II1fqStCpXLgK9xtkvXJXlTIERnVvQZX4AbPNy?=
 =?us-ascii?Q?vHyhIwdlmJ6d7ARmP02/yPvRW/cwAb/fEPxhvMkEClK0Y8tRv83S67lS5agv?=
 =?us-ascii?Q?A7kzgL+FbbhkoxOvToF6QEEwhzZ2cyUOuooQqwYINmUfUKPHPUd13cHY8KUj?=
 =?us-ascii?Q?CCn+TgKbSsPC5o7LYGvIklX/NkfrWPAtbKeNGcP48dKKOdfN10Y1JVG3I4sl?=
 =?us-ascii?Q?yPBTd/n3Vjzt0RHQWyuRPhZ4Np+8ldW2aXe0UAKIngQdD/YVVTGC0Qkw+sd/?=
 =?us-ascii?Q?g5fyTkPJpaSFVhaGxAp25/GgMuJ4NCX1erYIacRQ5jHr217dQquQTkdw+A9/?=
 =?us-ascii?Q?UJYp8i/xmCbPQ373DpLae0+5s3EbURM5BsctYv2fcFoCxPpbgxKOm1eCDCRa?=
 =?us-ascii?Q?5D6nE9KMx2wpzrhxRm1IrcPjmFpNzP5Bmw4BnklBlhCjANPFgscJKXeBJrX/?=
 =?us-ascii?Q?H8uKNnw0BdtDvh5zYNO4gIcUnb7AYGkSrIrYxLER+8j6u1v7GZ1ggBmP0vnY?=
 =?us-ascii?Q?t6dONX+9nxx7xKe2QLR75zoByv0Xv6fOWJA7jZuQf6I7dmIOgqyyhIV7hBl8?=
 =?us-ascii?Q?HxkqvqM1S9lJsaY7cZNeKd9dvMoMwtbhHVRqnwA0VcqwL07rBX6bTekL9tLq?=
 =?us-ascii?Q?MoHswlX4ozVzEDAoMYZcJX0n1jnE5NTkrzp/h4CnQZXzWJIDChG6pwfDu42S?=
 =?us-ascii?Q?T23jWmQZRqYO9D9CPdSOFdglNYk+572rxXJCpy93NaBfH2/P1cgny7Dv+HT/?=
 =?us-ascii?Q?WHpUxMu+k3NzgiBfN7TgnyUFAShM4ydxP0AkOopjQxI0fdvZDt2wvw6ykrBU?=
 =?us-ascii?Q?iDCUIoByuFdRh1lxSpOw+NGq7FQu4OuC5W/X/X9t3VvmFT9Pf0rUYr7hAXkT?=
 =?us-ascii?Q?vHPSam49kya3VNLudW23cna5UVEn6ZvV+ElIvMJhtvmfEhlSKSuHWVUtwSyI?=
 =?us-ascii?Q?mZz3uSDmfe2ehR5al708xf3U94Bt12n7aimIBuGnwFztpkYVZsi4OAmVoi8m?=
 =?us-ascii?Q?XD8f?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: b8eb9e5d-1eb7-4e3e-fda6-08d89952896a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:24.5722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yOtpDe/fYi0sNICrK0V+8snnicfIQoEhuXfyyKp9ef+6TZaFTMPO3t/4ms1QyxksO1dZk0qcTdkP/KSRYdC2BRARdjr1U1adyxJXmfXkszY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index f854ff90f238..e1574c14b7e5 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -2904,14 +2904,11 @@ static int ucc_geth_startup(struct ucc_geth_private *ugeth)
 	 * allocated resources can be released when the channel is freed.
 	 */
 	if (!(ugeth->p_init_enet_param_shadow =
-	      kmalloc(sizeof(struct ucc_geth_init_pram), GFP_KERNEL))) {
+	      kzalloc(sizeof(struct ucc_geth_init_pram), GFP_KERNEL))) {
 		if (netif_msg_ifup(ugeth))
 			pr_err("Can not allocate memory for p_UccInitEnetParamShadows\n");
 		return -ENOMEM;
 	}
-	/* Zero out *p_init_enet_param_shadow */
-	memset((char *)ugeth->p_init_enet_param_shadow,
-	       0, sizeof(struct ucc_geth_init_pram));
 
 	/* Fill shadow InitEnet command parameter structure */
 
-- 
2.23.0

