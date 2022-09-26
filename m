Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCA25E9747
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiIZAbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiIZAau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:30:50 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2111.outbound.protection.outlook.com [40.107.96.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2649728E33;
        Sun, 25 Sep 2022 17:30:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grMGP8gQEwf/fIaOPdetS0O/cv+DfML+VW55LDJM0qyj3kWitdYgi4HwKinadDs98Q/GiJ+Lu/w/cIKibajySozUEkQBIDOYrT7W4P6c+NbTfuvoVm3RGWdcnbr/MoZVuZRVi/1/wrz/a2sFNrnTqNJIXc5XxHeLVO1XrkCXAeenosHK7h+ZCPstcOKfTsoErS7dbC0vBvVflwT2T7FfRO8tuzSzjvnA6N+XdAACUD13YPWOCBifqH/jguRz0qVQVGaM30MD+6960IV4bO/xfSlnBIHoey7VgiCCXJh9IX/dny7DiAqNAfW20/gtgD2m/pXgOmEXl4Edp3ZmMkf5fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+Au91cu3uuL08D0+MPuTCF6Asxdf83Cs5VMNNrP7Pc=;
 b=GjIp2r5kebtARfwwFwXMfBUoVfN8LHMTwgxi/k7pJ5kcYRHEVDpoVSMR/vllMYipRf6wvcLdOhMspNVKuTBkDBa22M/wZTmahL5Sy8x0gbxGBe3tj/4pgRBz0Bhr/3S88j3zWQ1r3lx14IsQapBIaXILYQScs5qhA1WKPvtvtfQES2g/AX4yisSRZyusieMs5O/NG2GlF/ycBb+JnTZ1JHXctWW2ne8b8SGp3GKbJdlWelh6pOZbjyDaQVodB/VMKVQY6rGhDvnjHY0gh7t54LfHW1Jct7cj3Ui4ztd6EClUfi4flmtTcdvSN76KxopCaETPQ5ctY/LSbhfQqZrXCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+Au91cu3uuL08D0+MPuTCF6Asxdf83Cs5VMNNrP7Pc=;
 b=p4uc5Kbs/p7X0Ow0GknIngfQ41Yepd5bgyaI/zdR1RqmfusaTIaHXRi4xy4G6/b0MoZLv8MB14ab2ZhKkZtpMye1uP9vVnWVqp8iBmR1KRqXI02d7imRnSlUcbvi5PFs1yUnfJ/dJF8ZypX8YK39lqU9yIjEyv8sGQ/31W0c21Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:23 +0000
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
Subject: [PATCH v3 net-next 07/14] net: dsa: felix: populate mac_capabilities for all ports
Date:   Sun, 25 Sep 2022 17:29:21 -0700
Message-Id: <20220926002928.2744638-8-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5d2a36fe-b75d-400b-e7e8-08da9f564c72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjTTEGLtWpXKd4WjXRhZw/z7qJWpE5fat3sf6VR4ee8zaFzEvIhUlvpSePy/oS4HXkw8P1aB2rh4eViZkQBF/0h0ptfTFqZt7IMT6KNm91ivegnip6p5dewBM2JVsc+Rs9bC5j+itkzCjVoccwYd0PRk5ZdvGmMQGYZ+FuqkJZIpF3ZP+sUQIHz+94ba3ykq9KfezzRCrAnp+autntRDGMNZrmfbCjRLNXC9pNua22lm9eUrtrjHys041uHlKDw2KB3bZVohmgZ5eyisk8y61JdyYsYZLLH6/gNyEyMBq2eNp84aeuHqMLuNNM+25Nj5JjOlrx6tgQPfG1eIhi1a9/Ea7pCn7n+lIk2esyyLC9JP9qrlZAiLW3Ae3gmxx15R617Gf65EeVOMOC//jhWylS91DYc57UkoqLDC16n193Ia3ip60rsxMGJ8vGOoignhbQR1oslEQcFse873fXwQ4ISBDXSX3xwTGKqUiQAH6IY6fqeTQ0koSswEeT1KaSlybUJocqQW3a/3stUPFYjGpIdD36nB70/kGLtNYPDr4eTx+lWGbmdYu5vdUNzStDhoGENeQvuTuzODngvf21hevH6zh0BSydQuvrva9KOhJjbZc8l6ywmTaJZO/CfjwOIi3kgPG4o0cXH8aQ6QqgtDJnostnik2PrzH69pOqIrlmuYiwLYUZKYIn3k4S967HNMTrVgsY5y3IJCMVC7FnX7Sn8pY43r53JxXueSTKDsYrTkFjRNDM1KAe4EgY/63aVl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(41300700001)(83380400001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zoSy74fbDoHoP0/C0z6iSi1DA6aYyWFHYRk6R1XpbVXknPZ+Qjq5FSmAywzo?=
 =?us-ascii?Q?Why+C5odAIuzY0DdS/HDKjw4Qz2J8t4haIsevbQxil9k69InDti8XHG4ZJ7C?=
 =?us-ascii?Q?KuRYNYwUw4vJfNp0SgUj4/SaGHmn4m8KwqRanN0Ry2eT4wILDDbqB1blqzOB?=
 =?us-ascii?Q?WcTwM0P0DKxJGrqIujqjkCIyNv91VJn9UoofDqTZVClsLEcHbWNJwM5ttqy2?=
 =?us-ascii?Q?JsqRz7YH4Cvuh/yRiLrCPef7nPwDS6KExyPlzc9RrQSWRwcGAcBMIhztRF/U?=
 =?us-ascii?Q?wbjCgNq2rkDbb7fukLLfUAyWwIQ4KnsiGr0ldUOKr/IQDm5ZurJB0wYkFw5j?=
 =?us-ascii?Q?N2ECKU+vxwXvuVSKERA3v2qCHLpT9rTLsokO3qEnPsMmI/LZ4e5T10PV7sbY?=
 =?us-ascii?Q?y+O+L0ZFoiIojR8E9DxMWC0u0UnR8QwVSGa2i+cgYFYgZsTNT42LIpG7J7Zg?=
 =?us-ascii?Q?qbCjs366S8iSonH+SiYOhTitFhDlxKhnUHg3aTc9Qp9N4PXeknsLxX2XKj96?=
 =?us-ascii?Q?/c6oQXEPJTW1MH/XtGltm94d3Ayb6saT3xeB2sZs3X2eY7oLbLsDaeObYfo5?=
 =?us-ascii?Q?qV3yALLcAPfTqxH4WqlxyhQ6JMqbntoHF5CLedaf+qoWRSKlmuZC8MmvRT0y?=
 =?us-ascii?Q?9/cheUL6boxl0RH8fM2W34gonjeZ1L3vsoOA8XYpaJYqGh0ZGENtxmN8PXGu?=
 =?us-ascii?Q?jUkrsEKZuJghtm+7XdwF+5MegJbuAG7X2pZlSlY1Rlr04774kF5Nx+XNZ/rj?=
 =?us-ascii?Q?OGOEwXZpdwtPyHoYL5VSl+3T5W/akrfuohE91H0WUpq1S10qucxZbhHuV+NC?=
 =?us-ascii?Q?DDsWoPKFVfFom1S2ERqpEUsEqiWugOmGSCvBwclzrDQXxjhRXdctmP8Kiqnd?=
 =?us-ascii?Q?7PU/CSqSQw0AfMAXNnowci8bGTz5GNVk9kc/i7SbohgQTfyXBJ4XwzaFnT+7?=
 =?us-ascii?Q?AJu/Lyr1NZF5ObcGdD5uVYOf47gv3TXasQ9kZAvjZS2a6uIjj6zfdzW8wEAd?=
 =?us-ascii?Q?cc5xpABaMeKLXuVNUBbesjGWBUEz6niBVJBTHdA3nXYhZDXANjax57l43jHA?=
 =?us-ascii?Q?rPDyYvIqnSj4wz4PahdMQzZx5rJcvy3CxRkipwtr0JqYnTcl0EyBKejyb1/N?=
 =?us-ascii?Q?km3xkI4UhKaelrEbH+hMxaAvUPGdMjn+cXKxmIKi3RP+ABSIEDh7OYRtsgcw?=
 =?us-ascii?Q?lHFfWJaZiTQSoMwxYfKHdrAtmyhxZ396L7l5Ew6b1XUe0BpHSMqPBSjwZMaf?=
 =?us-ascii?Q?4QTFZ/BJcRzWapq2RxcXXgk/1Tbh4SwK1SDK9l8ekNB/h4hcVbxz45gCO5Nk?=
 =?us-ascii?Q?2f4+VMc4Jt9A1PsbJoNNZlHGPwupd2V59iP+LDHK8lRXMOO31dUoYi7zqklc?=
 =?us-ascii?Q?m3H3v/RvsMUp73hfroQIUKrXol51JObVMhaLSp179t86GYQLQRMO/VMqRyn3?=
 =?us-ascii?Q?J61JOc6AH7k2JhNltoCccqjFIzkg6/eyZl0TtamRLn/IpeHxYlMkCh2mrFrB?=
 =?us-ascii?Q?efJEMCjp1IySg3VTwNSJ1xCg+VqG11v/mHBHzR1UeH4wySyG3rvkznG+1/0g?=
 =?us-ascii?Q?fC4vbbBvT5Q73IbtXFTXbr6JskFBQLC7icymZUNV6/B6y2Hay1Qz7XzqsX+m?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d2a36fe-b75d-400b-e7e8-08da9f564c72
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:22.6980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FysgqR6xYrYbGrYV+1j/DE6fC52B4DTnTqTQa/UclnWmF/tTqxl6uen0Mybohl6GwAtd8n1lfqvD5HjPi73+pqrWk1jNII9PSTCKF1XOzb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_generic_validate() requires that mac_capabilities is correctly
populated. While no existing felix drivers have used
phylink_generic_validate(), the ocelot_ext.c driver will. Populate this
element so the use of existing functions is possible.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v3
    * No change

v2
    * Updated commit message to indicate "no existing felix drivers"
      instead of "no existing drivers"

v1 from previous RFC:
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 07c2f1b6913d..a8196cdedcc5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1050,6 +1050,9 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 
 	__set_bit(ocelot->ports[port]->phy_mode,
 		  config->supported_interfaces);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE | MAC_10 |
+				   MAC_100 | MAC_1000FD | MAC_2500FD;
 }
 
 static void felix_phylink_validate(struct dsa_switch *ds, int port,
-- 
2.25.1

