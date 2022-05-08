Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EAB51EF3B
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238923AbiEHTGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382458AbiEHS52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2101.outbound.protection.outlook.com [40.107.223.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8F2A1B1;
        Sun,  8 May 2022 11:53:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k50dYPqU2chcdkHAIkaBmsYDLdC2w79aYv/9Dc0YVPpHr399HMH8bGlUHwVzfQek5Tj1Yf2sj9rw5ON/zc5EG6ufzHCExQ9AJifD/Kx49ONrbPdPel64HJlm8hf6nHp11MKi8V4ht+qPS414XUbziG3pgu/B0Cyt5dM6CjW25kvhPgcKonJgDWET8jGVfVyuYGXWKcNZ7qP8dt/VHumBT+BVNiXga/W2U47J5cGpXGKQ/ViOsZ07J61BgsnQDIWpuP7RqTeeGz57axHlate0ontYRqNZDx4yUk1vtHSWnvgG+dicYJlfYytjh46HHgu5K1jjCz2gFnS7XENDVtBZvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHA0gxBULloT1d9GVK35WIKgH38LA6IF0kvowOr1iIE=;
 b=QryKOpNswDR26kjAAUxSf9zCSOWrV/FSSSXl+i4/IboDjMKPB9ziNoELUVHvrxhp6Ge+5o1cFupRxoVEBCbzMwKksjIBulWK9gwKV0CDopRhKpRidQhgMFvc5mJDwh5+ucyx3GlE7f5oURAjzQMfMqwVZlettQ7rkNlt1yATUQUkGtE6jBYEDDijCfTqEQntzFEIe2dhUhWwxzneJOlBjAd3rJxbB5O7J6UGtQoOK9qH3I0YY9147N3N+TyIQdNVd83d7vFIfarUTyNGc9cakIgBZfPnJ9oxJFVRDLwjTJPbEXkkupp1gnaHXwSEb0J3UXbftVGsl48kcFpWuVr+Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHA0gxBULloT1d9GVK35WIKgH38LA6IF0kvowOr1iIE=;
 b=tI/VQwgjVWhxIz8QpaY2ChHmCL+PH42B1yrDdMmqJeO8EwPSkQ0XvVFScogIHXRrd5vZdqe3zriJa38eeF6MHtx8o+bOyl3SbIOldqnFWp+PjOLd/c2m9CDN9bIKVf5cn2wNXHQlYNqGHbPISen3oC5gauWHMtpvB915dxKt4QA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5533.namprd10.prod.outlook.com
 (2603:10b6:a03:3f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 18:53:32 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:32 +0000
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
Subject: [RFC v8 net-next 03/16] net: ocelot: add interface to get regmaps when exernally controlled
Date:   Sun,  8 May 2022 11:53:00 -0700
Message-Id: <20220508185313.2222956-4-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7b45d7e9-7a4f-41d0-483a-08da31240c82
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55335FE93934862CF91D650AA4C79@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ISV4DolRQ+uu9ZXgkMjEyIfjVkFZ8na9wojPMILL+tKMqA6+9bUUNd22e3jYlwNVIHrTaBqX7B0fd926JrYQHUHMdpuNKWNDEZFo/mPVr77eGV80MPpy3rbnpQrr76KaVkP+Wf+cgKpwJYdW+qqHhkj7yORlvpWu4B7jsYZhHXvKpK6ZoweDBtck+xEoIqGfz4aR2WIl6ECzy9HvCN8ThcFVKWsuv7LlGVpcytFwxRfstjCWHbBIM7dGb07M2ILHTwYahpBKoMUQ6M5ymXrHStjFmzJHsYVLbM35ecWAhKAbWUPWUGRxxp7zpop16+oBMSlb4Socef3qzIrcMWt8bZSq3++0EFiV5ihgGVgAcPNASV/nfVLAszkv+N1jmpWTvp4Jhn1UleDm+lQHe3ZqGw3tgOChO5Fgzflyz860RGDyCS87vroC+g6mgXV4pIgkrmUY/7NQ3d2QttWuLZlUYGNqD6rSPPPDPUrdP2BktUVITO3i9+PK5hcNSlF9wJXmdAf7WyYEsyf1UpiswY1Tl1DwBecWH+izHPiZ4Icu4uMJ+BqFm5pQtzDsWaXpaczGCEIY1xE5DYRRhtsBhL+FBYqHLrLNSZ/v8KlR8BNWfJD/KVS7yOZsa7KnpgGARlaAIAGbTW6oGXHRKiPPVFS4ui7j4QwHcqLtkEnfEGf1lJMQDOvQzTf6GQTZKBH3E99kLfFYLX7++Qm5/xVh+aW9eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(376002)(366004)(396003)(346002)(316002)(66946007)(6666004)(4744005)(26005)(66556008)(508600001)(44832011)(6512007)(6486002)(66476007)(52116002)(186003)(86362001)(2906002)(4326008)(54906003)(8676002)(38100700002)(2616005)(38350700002)(6506007)(83380400001)(8936002)(7416002)(1076003)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B/Kof9IgHaKzpPKxG1VQI8y4SDvKdQy/fpEAugbC8+J5U1agShucTOXnzbhS?=
 =?us-ascii?Q?gc1zMwZ8nMVDf6yDSPjf/reswCAt0xuKsgn7+TDVwz34bO1sx7VdUQfBKmHB?=
 =?us-ascii?Q?znGs7MvDCnmFF4E+Efxpfw3tM4zSu/9yjJr0Eg5x/17TIEtdAwmIwlvZHnvC?=
 =?us-ascii?Q?1j37le7wT9BkhIHj940zz4/gveVFCR8l2JN0coNWF5Vwp7gZivnPPeBecobr?=
 =?us-ascii?Q?03f2xe2MKrZ26O85S71MA3T00CXWHkWJB/npCTBlzLovJpjXXjiKpsDPkjaJ?=
 =?us-ascii?Q?yCblNB2ulbJaIPtgomscwVNbKkbAz1+RF0KnlIpuG8RaHDXMlv5tw7VZVEKD?=
 =?us-ascii?Q?PQZ7MOVKDW1yXOhM4lBqH4Ih+Es4wjgDEVfSYpBvsBxCmxn1FVMUjBriJ84v?=
 =?us-ascii?Q?rvBUSJreMZcn3xRma+J1JEehE3kIkvXSgRwjwvROghY3ShDUditT4tK7S4tC?=
 =?us-ascii?Q?k6MNTMWuhppz8yXCCUUbkdzstLSB5/nS1hIMU/Asg1lV8KUiUD9nDeL5fuIV?=
 =?us-ascii?Q?7EvKZsuT8xF/ushJa1dBAfDUwt4nIXngBYlcrcTrmuxEZ8ihWh5+UUl2usds?=
 =?us-ascii?Q?2IyUqOUhjrMD5dH8JW8lDUOSPBANnisZrM6ajqm/OuR+uP6SPwF97qD/jnBo?=
 =?us-ascii?Q?ZU8m7xx68e/SGrOHamsI/hnSVMCRq0k1RF+EdAKBPJa771SKNyhGA7JN+iyQ?=
 =?us-ascii?Q?cl9DiID0qqWI88pjALZmiYrH8nUhrpa9iP8H+lGYxuqQw+Fkt15nvQQRy9RW?=
 =?us-ascii?Q?o0vO4HpCHsZogSi6mZUl7yOP1F95onLHPx6YmZ/JTkVb15y9EPfe3ePgRSR+?=
 =?us-ascii?Q?3C2gqFtH3or8PWKPacjif8psKuolIC/NgOF08uunDbIqywOJxLzFPrbQc2zD?=
 =?us-ascii?Q?ke3gQMDh3K2n0wD4x5AT0HYKn3+uw12O8+VTKanFVc94nFiFPJGbEZ6Sfby7?=
 =?us-ascii?Q?msbzrx7azKy8C+o3VVeWKyuHcOcykwLsTM0Y/p8gjXlqWyw9Y2JjkkFWY7UV?=
 =?us-ascii?Q?MjfW7hJWBLyTLIBh9dEkFH7kNLof4CfHH5GwN9fIbRp3QEhucjyuKGCqeakI?=
 =?us-ascii?Q?LgauzSGvQQzfnt7DcDGAUbSBy70ukQqLMK1azxNdIkebk2HGLl9D8lr7knOU?=
 =?us-ascii?Q?FKFvb+I8Y2MGSsRqWlQMp1xlrrzV78Jdqnn9hl4dHdHgXcI3YlftKHiPYpZu?=
 =?us-ascii?Q?vzpQKj5oI/So2OpSlecCWnKZtS7wkhfX5QCwX9ALDrgp5rxUl2j1Vz6vnyaY?=
 =?us-ascii?Q?sotWmtzNKe5oQpDE5A83GaIKnsOIRJKJsXlIn0swCv45gEqJ5+LPoqYXLU7S?=
 =?us-ascii?Q?IuQs75eLssEFLZct+7RStNTWopsmcha/4HnZrYw2zd7fDkWDV1Pbd0cw7MFw?=
 =?us-ascii?Q?0DRzxwh5QAa5NBTusThWGrwB60Lj48YRjisL/eMGYJs8AqQOjBJyNpCkaLP9?=
 =?us-ascii?Q?AR77dMk9MeTmVzyPpOHBvsNtHwOFpXOqlB6MzYyvNmcfE1f4StWq71bLbfA6?=
 =?us-ascii?Q?VtGT/iiXAeAGtXl7NOlTvXgn0+X/XQibgi52HYG3w+hfheJByLnScUm4R35Z?=
 =?us-ascii?Q?0E4GacNiTCSvHkUN4PZEHIkdcxZ42bGY/kcDP/GeS7fpPmnqh5c6XAXyATV9?=
 =?us-ascii?Q?RDZ3U2dq4Zqu1Lda1g137wepAOU8NbcIz7iX8PszmekGJ0Bs/VKA6uGch0Qq?=
 =?us-ascii?Q?EyuXnFKoxHxMmvRFQ2ERk7zEcLid610y6cCcXtTHKpdHzxmHYdQmfnwQwfrD?=
 =?us-ascii?Q?n+VClDyId52RLhr+HEypN0kkxo6b7eTDeFiOrpwq3kHtp3eMp8cX?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b45d7e9-7a4f-41d0-483a-08da31240c82
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:32.7294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwDij+SiEiLEgYjwI0utF6CXpLLDjYQSOA1HqD9Se+MudbsENAn9fFX8EzgbWhqvgal2189QpvS6r8qsFFl6yfXYhfKjO2PWPZW6VJyFIGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot chips have several peripherals: pinctrl, sgpio, miim... If the chip
is in a configuration where it is being externally controlled via SPI, the
child device will need to request a resource from the parent.

Add the function call that will be used in those scenarios so that drivers
can be updated before the full functionality is added.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/soc/mscc/ocelot.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 8d8d46778f7e..1897119ebb9a 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1039,4 +1039,11 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 }
 #endif
 
+static inline struct regmap *
+ocelot_init_regmap_from_resource(struct device *child,
+				 const struct resource *res)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 #endif
-- 
2.25.1

