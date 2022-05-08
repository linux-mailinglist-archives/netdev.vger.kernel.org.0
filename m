Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D21351EF75
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238304AbiEHTF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382408AbiEHS5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2115.outbound.protection.outlook.com [40.107.223.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A90BC08;
        Sun,  8 May 2022 11:53:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qy1xoORiUD6qIHaofOxNTSEsMe1/ehikrgroS6cN6Q4zo3JRmb4CJzEF87m4bYZ1+JEg9Yt6mM7pL+d7ocOKPz34dbLSWsgS8EBw2+60jlN4CP885vsxg07FYhl0BNYQ0819fHaqqx61crYQ3sz0c//1yCKIW5DAkAve02urKRt/oWx3W7YMeAUFthtDmZRuN6fzFSiPvdCAREcPYYpZ+FwavKkF/aem550sK8Nyq2Kh4+JUlFLO2NNjvPaZn9G8RSnluyrBciEiUSkYi2cGGHUpygV4V/XHwtX1a26pOJfHokjaqzfqjw4WmBh7kLcRv9jPkpcPBU0/Ct6D9yn+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcVskv6WnzwPW3s4W2EBmoqO9NyB9w6el8NLcOf2dZw=;
 b=f7a/KIdbwWrDGi1rrbmROq+ah/iBwNsbScL4zbyGUu5uIL2bn7fiYm3IkSjZSqCv9hv2Q6PdJJibfjm30dZo7iq2/j6yDHvBApRxSg3sZaQ/9popU+dwhhy4sATgz4hy3UqCAPfm8yOCgCrgDrShHu5ISNC+emFrHsrDj4lYTIvYxbQQEqOU/5ZGltfs1NpEvnVXp8/0huvNT/L06+I5FNTGfzX6D9WDVJ300nDtm17viQN5M2IBASky/c/rToa9lgTY4mJz9/AbyGy51wI6oH5k/LtQUu5jrnHGXnYb1vHHeL5etM6kYDdaM8cIicneX6WoINxYMRtkDbUJVY/DXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcVskv6WnzwPW3s4W2EBmoqO9NyB9w6el8NLcOf2dZw=;
 b=Vg1OhgMGsAqY9P7GzyOxmns9ycXbh8y1fOjLkKKo/7YoPytaxOS9kIf7mTCFxljvBvj8zAM5KMiDCqaBjBxF7tRjt6ZDyFXpBdFtkM5ca9NGWpL/qKlZjeACGLA1ywKAy1Euy/kOt3Spb19MuTK0VxHs1yYu44Z8k/UiRGJsxJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5533.namprd10.prod.outlook.com
 (2603:10b6:a03:3f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 18:53:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:27 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 01/16] pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
Date:   Sun,  8 May 2022 11:52:58 -0700
Message-Id: <20220508185313.2222956-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98eebe9b-5b88-4f1e-1973-08da3124095a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB553389AB34BC012AEE13B4B8A4C79@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9tShuiKR3VVzb7JvyNRzD3PzQQ/Sa0dN64ltAXEZZblnFgvUVdsn5KiDsqlAbh/Y7wRfGrSxArAAEn8OymhjKTmUHTRlNRAeXN8qn06m4BIXSG5Fsuo3PQN9Me+Mfy62MK4s0wnJG6br6SAUprXBFY1F+rpl4twT4+NoTQtedyhikEIpyXzZCdg7ULeIQkbcVY48u3ArEglRVwmw/5j3h4kyPRXTPsRLjjreGsDQPfqRUv8iBsxqum5JKAyAbbyMXA17DAaIAh1cs7PDHIMjtr6UgPNWo7HqX9vUysvbzXYMLCiXgaMAB7PhQoCIg4ENPKOTXHgxjzdDNLtOc0Bb6GU0WIZ/t/QU4vLtDeKbMFocqMptHWq2/JsgEN5smecMV6TIW1XytaQVuWfWOeo2FsPj8Uzl7GjcYkk5+l4AFcNTlMo1ZIPFlCzda+hjh0b3gLFwMWjNsnJoJOKnvvO4dEAm4YfwPur69gMFwZiO4RiJqOE9MkvMV+rI0QNLKPFsDVSs+RFOYM1TBju2PLcTmdX98TgpTvyNezVGVOCSUr+xejG9plZViVmlsk7ex+5GxdPrCR0XDNrzEW5+yOUX0gj2Xn1PrxHBGD3IcJhQNej8LhN6okc/8Ir2lFp48aoRDew3N7tNyU2Bo5L8AakI0d42GWvYzyjHUXCy5oK5/ZsRBNYW1acssv2vK5lBroS0jMwYLH0wC/RUX6E5EZ6U7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(376002)(366004)(396003)(346002)(316002)(66946007)(6666004)(26005)(66556008)(508600001)(44832011)(6512007)(6486002)(66476007)(52116002)(186003)(86362001)(2906002)(4326008)(54906003)(8676002)(38100700002)(2616005)(38350700002)(6506007)(83380400001)(8936002)(7416002)(1076003)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FJ0yx0fY4XVsaMWxd+oMMg8Iivb/zOlXb48WKK7MIdoXkyUWDfGhJzDc8BAA?=
 =?us-ascii?Q?0pWWS0Jl7zf2uPOw/cZl1p0AL/BycoXQZCiphKOWCWCptPL6RK7HKPh1I4Y4?=
 =?us-ascii?Q?1AyQ+JCms9WNto5zNdL/wUAgMVKXYaVqlyIaf2IrEQTATTnad5mswcF0czBQ?=
 =?us-ascii?Q?rSLzTd78AbHRLujwVV6wdK9BmVtCwMxtqglUsnhVluUhAuUSREN8WwEtShzB?=
 =?us-ascii?Q?GfVZkYOITih7WhjzwFfUqUhR0D8Q1JIiTN2ZRQkkjSHrj3kQSKj8NmfevMDE?=
 =?us-ascii?Q?5DXkmL2Z32nlH5Tr5j5ORVIWidjn1WuhgAPajDO40bI/PIoBlZfLxfNQzeyI?=
 =?us-ascii?Q?jnPG6DcKOwUiCLDk9fmvuyq7GAt7W9x1BmoGhUkUSXtAuRGl+ULXZfdhUPjS?=
 =?us-ascii?Q?t/4ZgOdDqyu32d+uIn31oLPTJqddPw3YDZ5yAVMOQzy3M+44PuOPeZHWYi5W?=
 =?us-ascii?Q?updFGSEfKA3eltFUhQgO+ZKD6tTjtzi+Vs6mufz8McsR3ZiYxgzEUbKxBFN1?=
 =?us-ascii?Q?XhDr82b5H7T7WPkcDH6BF1yz4NELdZAMPXG8P8dkSjjfgVc7zmB96/ibCJnQ?=
 =?us-ascii?Q?R2Niiom1Jmto8EvbvVRjpnFXhV9I194I24Ahpg3nsXUS+uhMz5ZTS2WtCQgy?=
 =?us-ascii?Q?6PrEav8u86fJdBaA5tx4PA9mqxVIf4uCdGE1VsS7ANZdl0LRGo2imImmw3hq?=
 =?us-ascii?Q?OMlIG1ejZYYgfxZc4dfMXb3gGU8P/n5U03jsKJSfNbyQU5J4QXObYkVS3Uly?=
 =?us-ascii?Q?j72KmCpJurxx8j8eoR8KjBLJq8SAftJvR4GyepeKS78jjMNCog7HV7j4HuPb?=
 =?us-ascii?Q?zmiLWoDVjsrHnodEULOCOgkaR+6uT3V2imLA31dPo4BkgHCshkxRts/HRrk5?=
 =?us-ascii?Q?//vRT+wEm9gbY2xZPwj5GkIsKzb7A5uGEI2AlUIGlUknNwFVzF1gvjthS8wA?=
 =?us-ascii?Q?6u3xfOFYUu3XywSXthB3hCTZ1Fm1kBE+eq5g1l21Cmp/eARTNQsctZEAB8Hh?=
 =?us-ascii?Q?u7X23aF6nzXvzGOiZXGTuc+5eLz4mRv7f6NCgVWpMMahG3VQYmvhpIwLfWud?=
 =?us-ascii?Q?b++Ruj2cq5Z15z98qZfBhxu8s7WlhckHwl42SlFV7s+aC9XBkyYAYrzH5owb?=
 =?us-ascii?Q?zT5AQRQU1RBcPwy9u8X6IZuGf8/tXuJ0/g4pLrBFv8vKh20m8AvB6vZa6OCq?=
 =?us-ascii?Q?vZDNU5cSz9CG7kR3M+O05Bepj2FOAj3pjqS7+ZjWSPFbeUlh3vYpScUuyVRn?=
 =?us-ascii?Q?nAKbmm7YhDgmvX8VK6j0jnRyKQ1faF60SrN0LH+lK+t9pN74qFql09tk2EYl?=
 =?us-ascii?Q?58Ks7I/9vM76AL0OWvc0JlRJAhLPufGdoNoxyL882/RtthYEWOm6dt6Rsdmd?=
 =?us-ascii?Q?Oai/5XtdKWfYLQ5vFi5Q/87YubYJJlNFOU1YGpuW3YdSIGRy9UykNG1doPtB?=
 =?us-ascii?Q?YuF2nfKni3OtDOyPrS4IAF1gVgAaU10tS6Ae2Ptp/jgx/6J8MANm1tQe/vzh?=
 =?us-ascii?Q?uemQLpniIaz6y8OCXPODfj0X8mVQxtFCBVM0gjktX0skr22ns1JnJagQL2Mo?=
 =?us-ascii?Q?UQCPaml6fHMWo9U1yddGuNbTAGVWibDajFtF2fXNCF8dek89sLccDlE0dIJR?=
 =?us-ascii?Q?s2J8l9SUTqKSvQL8/v02UhyLrN3uyIYi90tgaorUlKvRBjyUOug5Hz7ILldq?=
 =?us-ascii?Q?5ac5A8dMLDAY4KOYymG03WKVGMdz/Bnh0UfgX/SEX4vIk+xOgwt+vqjvds0u?=
 =?us-ascii?Q?o5AEZzeV+ggpaB8vDVsyFPhJaZnPlxq65HmqkO+cJoiM/+ilqN56?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98eebe9b-5b88-4f1e-1973-08da3124095a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:27.4173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmNwmcLD1V3epKHnE72bri2GlJsVyyHtwadkWr1BbZtr19WGAX2GA6n1mM3bxFqAIwICpDFjEcDAK+7FRVG9j7a7zh9aNt42mLxvYIBniAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Work is being done to allow external control of Ocelot chips. When pinctrl
drivers are used internally, it wouldn't make much sense to allow them to
be loaded as modules. In the case where the Ocelot chip is controlled
externally, this scenario becomes practical.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/pinctrl/Kconfig          | 2 +-
 drivers/pinctrl/pinctrl-ocelot.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index f52960d2dfbe..257b06752747 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -311,7 +311,7 @@ config PINCTRL_MICROCHIP_SGPIO
 	  LED controller.
 
 config PINCTRL_OCELOT
-	bool "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
+	tristate "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
 	depends on OF
 	depends on HAS_IOMEM
 	select GPIOLIB
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 003fb0e34153..30577fedb7fc 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1880,6 +1880,7 @@ static const struct of_device_id ocelot_pinctrl_of_match[] = {
 	{ .compatible = "microchip,lan966x-pinctrl", .data = &lan966x_desc },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ocelot_pinctrl_of_match);
 
 static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 {
@@ -1969,3 +1970,6 @@ static struct platform_driver ocelot_pinctrl_driver = {
 	.probe = ocelot_pinctrl_probe,
 };
 builtin_platform_driver(ocelot_pinctrl_driver);
+
+MODULE_DESCRIPTION("Ocelot Chip Pinctrl Driver");
+MODULE_LICENSE("Dual MIT/GPL");
-- 
2.25.1

