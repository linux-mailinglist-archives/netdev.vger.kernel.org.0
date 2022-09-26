Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508965E9758
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbiIZAcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiIZAbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:31:33 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2111.outbound.protection.outlook.com [40.107.96.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEEE2A438;
        Sun, 25 Sep 2022 17:30:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjhpNS/AKe43nO8liXGspr6iwSSgXXav+Kr1gWp9GSdBTmHLh+VyZhtRuqf9H1TlRWsJU9HeYr228IPsGY6uInj1rTRYuZq63jNRoTusy0CyujC802IxQaOWfqfr5QO0DUPIVvDyHzRmSEPyROpZ/qX2tNBbDW8IdalnMCCnRjKWE4LEPSIJ6hfYfrQw1dIsbPdR9fK5NFJ/ID7eGhpP5iQNV/rwnkuSmKlEpTcqSyJLHbFY+Hf0f6WJteth5Y9ZifZmd+WLLYMbv73XUEpler9+u4tuMN+vBAasw0QGjUzZSL48RaP0CyF7GXHaeoMqI7IU+pingVcDEN19gwppSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjgLO9u32pEV+OAvuDZG62F+qdkTStLP6SR/sEud5L4=;
 b=OWR04W7sT/JbBKQc4pmqMCTzhdAauQr9ZarvTy9Wk6RelbtdPBvvNw0Ak3/Ukjc/HsPoVM+P2Zi3aYcfWs6h0Zae/hOZ9ClBOSzJlBeLTNdBtpNNOk/MiHXc53bDgfLc75Lo6L1JFH0XV1rTVHnaLanEU2NSLICOOAUOd9+FQo+B78QZrm//0jgF+cKbEQNPBSbKD/f0y8a9pFBrfVXiAKBcASlQhA77GlfdcdW/ddCve4clMUqo+ukClvME2HgsYDIS6LEkcrlglkPiPDzIZ+K/FSlTc78h/t5gQ3PDJ4XkjyI/jTs9Jtenq6mtTlUG+Uei802zYXFwVGyHh+Tl2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjgLO9u32pEV+OAvuDZG62F+qdkTStLP6SR/sEud5L4=;
 b=qGIsANpSoF2zut7RH9Lxp1g8BlsFRG44IhBA0bBMPoOxSQNURKJX1FuJjc/4AUwRhB4S7s+s6orhFNchuKk2p2EHu5u3GhFKrUAbH0rofc87xutY6Jcn8Xwy0S+NBsrDePEgfYLylxkhhTINSpT1k6Be24eAZPfLPdY/HOC6k1M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:25 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 10/14] mfd: ocelot: prepend resource size macros to be 32-bit
Date:   Sun, 25 Sep 2022 17:29:24 -0700
Message-Id: <20220926002928.2744638-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220926002928.2744638-1-colin.foster@in-advantage.com>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0260.namprd04.prod.outlook.com
 (2603:10b6:303:88::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: ccc5caa0-7469-474b-5b4d-08da9f564dd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwvhM93gAY3gSlMJQ0GHNa5yOuApaaDCho49uTqwifGb3Oc+G68SzJFoaaL7V4GYtxAmfDphK5PGEj+OfAFfjk26F1X3fJgVWh3cN6soxoStpYtR8x3VGupTnM2HQefic0yyk98N6moGtJ3wHDD7UchJ1OOP0ZGNxjSDO+u7qne569tqXYLiQX7W6S7FjCNR/qsUc7KipxWXHR31kXoRiUZu+Js3pH1VnNNyBYDQudmqHaa60uITVDf8uZG4W3SyAu8V95Q0Iy+AGlDzu4Aag7dnw6rnaUFSRiWxwqNeSgsXqd7+l+udNSaHvM9dMnJr6g+3QNecK/hwclc6FkFThZz+dh8ySUymQhFqkIklCuYEdPCn+NAzfrci2gbMQv3VpfX/NPLH15jzFVb3qu9DfQ0IKaPz1W2mK7V3p7QrNUwU69cy3R0XursoK3h8nYcF/svKh5TuUPH4vA6eyYd9TciMZVnEYzGbcXe/gdMAR6GBILBvNkrfXlZuGUCKMVmidqfyZYzK6af9WvneQjm8S6xPHCLJSgAXjXFw/yXEtQdZLRWLROiaZGr+fZhZhyCC+71WNIAoPUULAHH+zDvAdRbzg6m0aBqg53+H/1kawVmoU8G97vv12n0Qy4AcceqsozgZCfW9cJuq6xmh4LiPZyvxMToXNhvaqWDins/9kPpUw6L7JL3cC6aXaRgK+lSRq1CnVwYU2UiBSBadAKHnFUcOAKwLD+P7ZpO/An5Am4WO4wG2DIb9UlF/daX8MliQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(41300700001)(83380400001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sfOG2f7uwrfil7C67Wgx6RSiCDGCpoDibHxVxQglCKNs2aioHrcwFIf8rN/i?=
 =?us-ascii?Q?JM+vr4nC7Ezyguhuir2LpqLhHquge6NrZepmGlpLrb2HzQi6pu2xsS5Vfo0t?=
 =?us-ascii?Q?yQV8AHX4RipSX3DRz0be7g4DDcPhaNa8vUsubPzY7BktZk2S5c4XKPWV23XC?=
 =?us-ascii?Q?4gCvumqeJ1xV9Kz5PcydxbVvTPoVASWxYIhZKybZ9++hvJidv3R5Q78he/+s?=
 =?us-ascii?Q?NONGreG+hR34fff3pLe1EWIvvpgC4KDFBu/9sLXz/Y4nviY73u3ydH+tpOL3?=
 =?us-ascii?Q?fQpK/eY2ZgA+qoO6idYaj+a3gnhutYwW8VFdmOm5xc1vK5R5IS8RVLitjirZ?=
 =?us-ascii?Q?ePMY+vVJ7ZrSTC8gx54p1OUYJP2K/pr0jVxk1RtrCG0VfOg5w+1zE9l8oFUM?=
 =?us-ascii?Q?tBhtqvJqpxtRRg+sTsyRrHOJFE+Hw1bFSz3JBEamrC8485c0dYqK8NFzb9z2?=
 =?us-ascii?Q?jgDsJCSy0bTdODlnvUDf/mM4P0n44DkKkSElR/IjYnQUOm7sat5bXUsA5pTi?=
 =?us-ascii?Q?pfQbKa/WEpodtv2c+d3D+RgGlgTUSmqQxxxOFH+iuQUgNO7CSGgVM7gEO3j2?=
 =?us-ascii?Q?INVejMctCNxwpd7MbbWk6mk7CeMZJaI5ltPRD4vGy4QQtiHrEwd1Zoqa4CUs?=
 =?us-ascii?Q?esHnIYIXHYmu4iKsQzoIkl43vzmGD5+bjsMgLIgm6WlbMCwPYJNUwmZu08Bp?=
 =?us-ascii?Q?wxUR0AmtEg8e458d5M/BpO3c+ZSwhuqLi8iNv6tpvagLioyukM/mkdcBtaB+?=
 =?us-ascii?Q?Pgu5J2nmLYeMJpWEPk/scbn9IzIqLS7n17HsnZ/zySCxq7TYAxrBS5fzUXaQ?=
 =?us-ascii?Q?1fkRFy6lVa/Fg6saVDdJLzwgVSIetP9zClLSiDlRYW2BksTkOJPprw2L+WvE?=
 =?us-ascii?Q?1RMHoB3wac19J7ksujfADgVbvC8Dbma74Cf8swjLC+Eig4g0UCr/i24ZkGS8?=
 =?us-ascii?Q?ruo0UOcpDDWkMa626uMeafMlMZukXoeTcNFJnSQrS0YET23WX0zwnegTP/Pe?=
 =?us-ascii?Q?AIPe17SnO70/PSJElf53GrkVId+DVheJZYR61Yhas6vTqpQ/2IavGU1/GRfg?=
 =?us-ascii?Q?P22/AKiFmI2MX4gfnQ6QUOXZMH2F8LF0UyzmzE7094DCgU9BQ+Ip5rPyQPGg?=
 =?us-ascii?Q?l3lkLHnw8sE3S13rDmHxzSkVpRpxtK3nsgQvv5sx6XeyA15QbnN4TDPzelHI?=
 =?us-ascii?Q?MpvqlavlMgCcUnQOWKYrC/YdTEJVaHHhRPxm0H26evvi7UByBms0Oa2pctDX?=
 =?us-ascii?Q?FBbZCaKn6Zlksl1Xx6dWzFYlf5g3AtDXGIvbdN9FPlZYEnru1BYDN0wO1XeK?=
 =?us-ascii?Q?qXG4U0f55XHYdvviNAMqkfDNaPImYthm/lwl0BTCJMu9okxQuA66WOBrwSU1?=
 =?us-ascii?Q?jHRWUgXcCRtH17/Sk14nSIw+e3QxryWSI/wSPuSNXrEjRtnEp/J4XFAr0kPo?=
 =?us-ascii?Q?8ym0W5J8WyhsXTKeMCWKq5Z4/PJ+vi3s6YHdL6Yd4ilTBGr5qFpIv3ioWLoi?=
 =?us-ascii?Q?pCxjC1ySpjhfKtxJGXxytDlD1Zc5UX8wFYr0yrSgeP+7MO66nd76VNLJUa0i?=
 =?us-ascii?Q?4iSg0rmh52oOH1fX1bGWNwtEz8+3VeZUQE4V2Ye2sKN4l4p87o+UIw6J73hV?=
 =?us-ascii?Q?9QDlaH3gA8s6K3IWSshsJJ8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc5caa0-7469-474b-5b4d-08da9f564dd1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:25.0572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9z7WHJtLTx21QZm13V3Sc0LKoY+roElkJUcEt7h0EfBwDg7VYtDzb1zbbYfYJR2pJuWm2NuwsEnPeHkJrSP9nKOHEAmvcwiGib64LWhrgS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The *_RES_SIZE macros are initally <= 0x100. Future resource sizes will be
upwards of 0x200000 in size.

To keep things clean, fully align the RES_SIZE macros to 32-bit to do
nothing more than make the code more consistent.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

b3
    * No change

v2
    * New patch - broken out from a different one

---
 drivers/mfd/ocelot-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 1816d52c65c5..013e83173062 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -34,16 +34,16 @@
 
 #define VSC7512_MIIM0_RES_START		0x7107009c
 #define VSC7512_MIIM1_RES_START		0x710700c0
-#define VSC7512_MIIM_RES_SIZE		0x024
+#define VSC7512_MIIM_RES_SIZE		0x00000024
 
 #define VSC7512_PHY_RES_START		0x710700f0
-#define VSC7512_PHY_RES_SIZE		0x004
+#define VSC7512_PHY_RES_SIZE		0x00000004
 
 #define VSC7512_GPIO_RES_START		0x71070034
-#define VSC7512_GPIO_RES_SIZE		0x06c
+#define VSC7512_GPIO_RES_SIZE		0x0000006c
 
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
-#define VSC7512_SIO_CTRL_RES_SIZE	0x100
+#define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
 
 #define VSC7512_GCB_RST_SLEEP_US	100
 #define VSC7512_GCB_RST_TIMEOUT_US	100000
-- 
2.25.1

