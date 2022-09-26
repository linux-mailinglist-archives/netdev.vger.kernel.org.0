Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9125E9754
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiIZAbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiIZAbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:31:08 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2103.outbound.protection.outlook.com [40.107.96.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B082A256;
        Sun, 25 Sep 2022 17:30:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Liiw5aMaBKYKQ24l0JpFB78WokniF/BSWBP5Bnil0F1bywSZXKhqDfQrqKJcjnRryr78Su4g4UEe8Y5ntASqk7ToLO+E+6bNzkLUOZftHB2nZY5StBk8l9qvm4xCaeT8/76MVK9OSkKb/gvZGAN6oW2z4tonxD+UgwCdXhPIv1zgXxoEdQv4t79EzFJWH6ba+reYlZagBfMLoVkzSkZhoUbfUUqH/8x++4g/VGD4OWIdFwrXyeb6L+D8CvKltRUfmtd+Tj7bfMqnngiBCtEAP+fLC8lY/mlsx8CynNicTCj4b0Hbn5jLt6zQo99kbH2Y/reuACJVRzV+oA9I8CJKVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASIiEnFKGLw923mztlg95DyOv0KbmFqGr7B6B5DszVQ=;
 b=HCrkr/TMx2R0C2OuTKvm+r5ppyQnHZDJRghq+q7tea37+4LWfCxi72znlhAvqjIVLp8DmxQq+pPr/kEQSCHNcc2Cjl5AjJ8Jqu3pZDtHHyM1j6ZaM2zJPE2ebQ/S/J/B8XG5aXbhJyQFSC0QtO/55fhWBHOFfDVpXNu+hHm2M99WopO3Woc3Wrdusao0FdqbHAi7OrrZa1WkY8HfnefjaXnMzy++gISNnsqWpUsjVlAYjn0AJi20MjgFF31o2wuZbMH9+8zzyPt1rw9lniVRb4IrqNv5P6ZhdKguCSWs1X6Ua0uZZ6emo7IN+DgQD1jLzq+8fuhmnFw0hX9o0PBjIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASIiEnFKGLw923mztlg95DyOv0KbmFqGr7B6B5DszVQ=;
 b=wLhm22o6C6iPdLJi+XNSzlISZOk3SMfP1PAGVo7KkPwJhwp34wj3AcEDei8AJTQyyapp7fMrlICpVJUIdhJfXs40FWqv/U94Gtaydw9ZKgDivfUSLvK599OVmdT5Msv6HHun41t0ofqbCmyKAz5DG7ZOvTiLXMfnL6EUoiyRYJY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4849.namprd10.prod.outlook.com
 (2603:10b6:208:321::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 00:30:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 00:30:24 +0000
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
Subject: [PATCH v3 net-next 09/14] pinctrl: ocelot: avoid macro redefinition
Date:   Sun, 25 Sep 2022 17:29:23 -0700
Message-Id: <20220926002928.2744638-10-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 255ac755-44d4-4259-ee6c-08da9f564d3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EBQcHfXEWzsBcYqMqCbv25aXVobgIauqH4U29nkQNnCHRFsbTUKJK4idodAWH3CegZXtQ3NuWVxwAZtUGJnCRPiJaDCIJDMzBFo23miAk7h5C1+QkbNpvblPoKb4fbVaMaflU7ad4GOdNM/kBVBRKc8lJ9B4fiiYQDUN/H+MO4WhGZsdE3klk7MtBkoMorZhnEbkS0LmczTWuSXFL91zCF8oM8fw77E8QfonQDD7JGL/RlNUaA6ZFCBxVtLP9Aa4wn/wnzvgWmNwIVT66+PaKCJE4qBFawxxNnVVyINb8nXUfO5/LKezu4ml1t6gd3TA/DqnCZCH7bDUstwoj89XVDnZsHnqZPymHqig1xbCWdlsgRXzIhZ3kdFTa2itNx2AKgpJyberL/pFsQ1UUwN4QT3VnO/+57hWaKiESTr7CI25g4ko29CcTmmKwvME+wOVGxxOrYYqYubCBfavbKR00CbjMbspmfPaqcnlpZk0OQPSrpVvYP6UjKPxsS/lLJG6CE4wNIbWsd4bZoX9dkCJq6of77q/3XhcfGIsc15ohdFkPlv6F2NvCyvlv5BDXcLjGFpZh3PkWmspmMSupttFXbvRDN+Kjob+Umm51jvSrjHgksvJd81A8LBECRaTNBQmPbH4Nq2XlcKlEHsagEYUqjhc3c1agUWl85VTHLGcw//NuJcA0YBscwlsGD4AJmBadVWk4YW80WM/FuWl9IKX+Cg31f7YNtfsd6vsyiY/g+eKumPbqx1Y6LqmnFMg0W4w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(39830400003)(366004)(136003)(451199015)(54906003)(38100700002)(478600001)(6486002)(316002)(2906002)(2616005)(6506007)(6512007)(26005)(5660300002)(1076003)(8936002)(7416002)(186003)(52116002)(86362001)(8676002)(38350700002)(36756003)(44832011)(41300700001)(66946007)(66556008)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U+NyP+LYXXw4dq05qV3+ScatVX5UKdUNPSjNAfMv2llIKI/g4RvMYgC/NREl?=
 =?us-ascii?Q?pAAkt6fogrGROajs1IXMKaEhVchrKFA9U4j8nA7gnW1XEN7yTjdAsIYh33f/?=
 =?us-ascii?Q?ZFxkkL+Z+R0d8dUvZpZqqhUDLSPamkZllNYYTOxwmTmHn0MUUgy2BpG9kryq?=
 =?us-ascii?Q?oZRotHSaCXNGafCVjmszWIoD2wl0fih658K+IQ2wxAAJ8LKZQD0Wn+pEe6YG?=
 =?us-ascii?Q?nGWPaQkIowjgIk6ab14Tn/Fh5R5Q7a77KszkQ2r6CtUlPtvTLI1F/Zo8jey8?=
 =?us-ascii?Q?PAEZYTQ7Ud3+jTRyuvN9qqDNrWMHh/bhrSXfEQsXlIXB17QjXwGMjqPntWRJ?=
 =?us-ascii?Q?3aL8UNfXv6NunqbfmSwyhD/e+F3TXorVkaYg3S+DJCskQpjYX/y1GqSRP5fB?=
 =?us-ascii?Q?sS6MBHDFZLJfREsDuCOP0UTF5q1N/LW0+09YVPEZtjmqwOGhlcmao9YC8kTe?=
 =?us-ascii?Q?P12zfxxhzm0hPOJGXbfJeWudEcSnsj4tBlmDyPde93uK8lQPpKczhQu0m5Gy?=
 =?us-ascii?Q?0vzC5sdP22NGWZINcIxufwdCXZTkQKHfp5zgG/2xDOZZi78GZ23fkhn+Os6G?=
 =?us-ascii?Q?8QTCa+1H9bXoYDCE8UHZp7JHVdcZS5vscXA4R84Av1Q1InK2gXM+ekpSHEf8?=
 =?us-ascii?Q?Y/HvNERuBdqeQUh0U4re6ebWsIr3OCJuB4R8qKy8dn5ZQ2lWOXldMknrp6ID?=
 =?us-ascii?Q?n71lJpTBxmTK21YbaoWph1wr2bpR7WN8i3zkMqnQiJOGCkBZdDO8SydH9FDQ?=
 =?us-ascii?Q?d1B/zJ6hRF9IFphNvp08cJTSdb/ZFnQln/uxZqgSg4Oq9plTuVqptBCOWjdc?=
 =?us-ascii?Q?7yAIcHTH1WbWNzVNOXoJPOxPY+4+kawjiTBOV8MNzKbsTcjNZf8XsbbjcVfG?=
 =?us-ascii?Q?IEu5GJELAHFznTicXe8rkRYXGkgRusXiqDY3Vb0Xi4/aF7zC5AQjREVgiGDY?=
 =?us-ascii?Q?tu3VZlWFdKcSV1lQeVICR1rh+o7D4WEt8CYXw1Du8kY/wzgMEgWnlwW79Nlh?=
 =?us-ascii?Q?rIPS10EbN+85IQXVcSCQT4UBMfiqyD2UOCRhZCkzVLaNk6Eo5H9+BzsO5z2U?=
 =?us-ascii?Q?T0aEpHHEcAYGzHjLkk3Pib8lb/sxGLtAcDExUdxZ7gWSUXtxP1bbOFWz2YLT?=
 =?us-ascii?Q?ZfdGJgR5/9Lu4cPIMv7SlFA/JRf4yBDG7tXR+SLVZ5LcoJjwG5koE1dzjm46?=
 =?us-ascii?Q?E8Jc/vsiw1ZYrB4cD08d2nsvGmiF7hVCymKljMaGtGyh5QyV+vaFqoaaGy1E?=
 =?us-ascii?Q?GQi3W7AI1f32iUqwxUHvA9npYiig65NRsbd7xXJWWT2f4m7arII/JiRs+JEa?=
 =?us-ascii?Q?kkHHbPJPCCD+6AUDgTE9w6dMBw8PofqZGyfTzQTkx9Q3ZQNFPKqxYpvDFOsy?=
 =?us-ascii?Q?MKg0bWQCt7A8NJ4YA4kiDHnl01cqYFkYfqQmoazOkQAM82C4/4G0OYuw127O?=
 =?us-ascii?Q?bDWMQclaeRq96nIA8FR+TTkA7CZLbqtWIoUta7GzAxC2St/bWV1zf9GBVtHD?=
 =?us-ascii?Q?zM3JPrEEMQhUqOqrPyIlUJG5aQe26Kss68UcI22MejWRwQXMw/nmWLOA3P/Q?=
 =?us-ascii?Q?OP0Zu5iYucoDBKzU+/yvR9hY6rtKrkUqpck6QUaawVex1/XhjbLc48kU/b2j?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 255ac755-44d4-4259-ee6c-08da9f564d3f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 00:30:24.3072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8eUnaYjrUy8ESHHzc1oA+cZx/E4e30BksLQ3u4dAqu3yuS/zqPc4dOXsYKRPaiSikBuYJmGfrhioRnzYxP6eVcNPAiiTvsIliyYQ1ykdPEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro REG gets defined in at least two locations -
drivers/pinctrl/pinctrl-ocelot.c and include/soc/mscc/ocelot.h. While
pinctrl-ocelot.c doesn't include include/soc/mscc/ocelot.h, it does in fact
include include/linux/mfd/ocelot.h.

This was all fine, until include/linux/mfd/ocelot.h needed resources from
include/soc/mscc/ocelot.h. At that point the REG macro becomes redefined,
and will throw a compiler error.

Undefine the REG macro in drivers/pinctrl/pinctrl-ocelot.c before it is
defined to avoid this error.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v3
    * No change

v2
    * New patch

---
 drivers/pinctrl/pinctrl-ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 62ce3957abe4..525c6ae898e2 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1237,6 +1237,7 @@ static int lan966x_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+#undef REG
 #define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
 
 static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
-- 
2.25.1

