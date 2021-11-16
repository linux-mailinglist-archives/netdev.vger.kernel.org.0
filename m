Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CDA452AC7
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhKPG3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:29:44 -0500
Received: from mail-bn8nam12on2126.outbound.protection.outlook.com ([40.107.237.126]:60901
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231229AbhKPG1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:27:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbAzco3mRleQu7pfRcaWjeMFIPM0US3QN5Q11H67qvzJLKouxOStTNdx/BpT9wmiWHAaKJvGaOhtHqjMihnhXEinVIakNv0xmSeOuDq0KiTiufpkrzy39DTmZibN3GTzjBpE4QhrzeRO4hn53GSTywHLSxo2ooMaP8xnzW7yGZSOjLQQx5elh1T3m5oWJbtCvrIwPfznFRIKI91m7w9s9SzIjKijw4PrN0hHCIoLPj9/f6yxKYL6GxSnaqRd1zgj0i1SfWcqBswEZR1/7466SS9QCSdHS/IFuxzbLvR4ouJD9253+xLxadPESR7ALHO0qLMD+2QL36aom8C8HKV22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fo4JH5MrJnAMOFnMpVlALeycztsDiiJYyJjTK4uA7Yw=;
 b=b0hZednMHfaEygYuJ2e5TMkJbJhMFaHeypa/eOZjjhkm9MrX/iDvrJvpB9BH3p2IVYqOxCXZo9jMhCpxGngnrjbqbQa4DROZ0v1gQKpX8OtCoaYGf2hZcV9FbHqIxV1jZKQKT1W62PNGJUFcp2a63/ABAYB1oUTtYeRf7M4j5zi6cSO7z3Td5oPTDZvVN8GIZ7g4yV0Eo0mbnAt+1INpnsRdjspx+r2E+arb3p75FmcoUUEUFhT0RmLc+xNCY0UQJJ/0bGrr7RmhoQ6mUxV+d+d5JpoEwa+TAJr0R1m4qVCMR5I6/p+OG91bGeaZza4IFuRC2Affk7K/6GR6L8OcOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fo4JH5MrJnAMOFnMpVlALeycztsDiiJYyJjTK4uA7Yw=;
 b=hkQk4KSZ2Jlc/vWVyYcDnin9FkAsfyHOjiZPKn/rpmGmeIRp0Ndd5RFe0Yund/S2JJz3MEpVnUxZdaISizzXW/nbpQFB/2Bkn+cLRFR2i0VWXDzC23+HYta5k2e3UX/ZdenGAJdNPzPfz7S3F993rbUc0F+cvKY0V4AmZpeLId8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:51 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 11/23] pinctrl: ocelot: update pinctrl to automatic base address
Date:   Mon, 15 Nov 2021 22:23:16 -0800
Message-Id: <20211116062328.1949151-12-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3e5f454-49f5-4a96-1d36-08d9a8c9a7cb
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB47226A13B226A6F77134A3A3A4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LKofzdcTeUFapm5SZqavoeGtQgZJF2ZjEpDjts9ub2NAeFJGXDtER3AxuyEXmdOKfdwGVAZn1oXwY0yYbPdzVPqoNiUMWwSehP8rp3C60KR5fUmgePcR1BGZjAJPvuwlYG7AGStokaAKgAiPrlyyepKLhQBxB/yIoGv1GVkCrZBKDONqLu8wtvOIN3RNm+KB0woPJoxJ6yTFVcpM6VUT6aRlaYW/sXzmrV5JQcGg5wlpXKKxjnqMwA5hliAQ1gYfxIBdwNBLvk3lPJs+x/121d0vcz3RDs/3OyC9H1jwLZKnUXHypkaxgOPg8J6JLr5uOTIHEOp+kN7SvanWrF5xCoFbjVdtCMbPept3z20YXXtsVMcJk05ZrGU17msrCRnPaaMIDJ5M8pejQ5Y7RL/dnWcDz8BFyx4YwVDuqBmVG87MMPoGq2dSaKBopDiqTjcvyyLa0Q9nYcU+sVPVGFl7DAWfM58WpzyXYUHJAfWmXr1zy59fO0EsiKDJF39fwvA9iTcYPn62j98eEAWqEyLk1X2W/IP8g/K6MmQl0JQodjDBH2g+AmdEtWaqA5Brt+kgHOrFb8E5kAHWOZu4bCwaQ804ABX/T8D9eh0/H6VQ/I2b7TYjNyh8Y5U9iZKUtAf4ytlDIhKmenS8tHdd7Ehp1swzfO1u97lMktOKkQT5lr+ipaNqpX6Ypf3FUkAely9bU6hvMCBjZoBhwVnYOjP4cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(4744005)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VcuV2p0nLpBR6lqtedm37nCvdcfOthvJhyTpXhz+fyrpAKu7tK3YSpdr6F2K?=
 =?us-ascii?Q?g2WZDo3S4K5yhYBfkuJe+hUSURT5E6X2NtLI1CcHdxeb/6ZczGxVArlY0uEh?=
 =?us-ascii?Q?/tSeRA8LHaICz9RWfwr5cMJ+5+elDbMgiqW+hToZWUsSSBdpSf+s7bsv2f2t?=
 =?us-ascii?Q?TuEXBoa4Gz+Urj/AThjVjK7uSNdjZREpbBGdmMW3kmbGbcT7PX/CQ8BW9n0k?=
 =?us-ascii?Q?AXHIuiwWnjZPfN8zZvD7/PfIqt9tlLawcEpH+z7ZT/5VC2++0PAhXtegB8CY?=
 =?us-ascii?Q?J6nyrijrk8DDKwvpZxy67AUzZ7Yjgy2ZJvPIC1mlUqQBE5o+v7X+PgURZAeK?=
 =?us-ascii?Q?X3bE/bUox2nmu1uyku04ekbtk8ibDd3Jd8dkJz3Pghomr5/NDKWKIZjnCi+K?=
 =?us-ascii?Q?UVy5t2FAJS71xdmbTdXZf7sujMXQ4zHyoE+kt0KcpliZHj7WIWb/m3ILuYnQ?=
 =?us-ascii?Q?PRgWkdoXDVgSklKx+ZsBbnpd2/qTqV7sF9l6WdQVQceLHZUPmH4L7ERy2jl7?=
 =?us-ascii?Q?sRBrLA3vPlQxlzmZ1JyIvKyfvoInj06lkV5kkLYjLADeVn2BtV4pu+GxbfJ5?=
 =?us-ascii?Q?qs+2q2iIjEYX3ttsgSg7PDBMWcEe13c9/QhvFnJ1YDaGji/AeE72JtTNV32l?=
 =?us-ascii?Q?H6ocF7lFySQVUCp/VYruKV1YFpiZ+Rs7qNKlr24NznHIL8LfEbmkjMi9oLkk?=
 =?us-ascii?Q?NX4fgiBVB6C3Dmf0hWnjmerq8REb7WEcxTrZfUDNs8pB9TNUfpuOCPCVG74N?=
 =?us-ascii?Q?8hDieaIueAh9/Y6zsHZJDgLCFt3FWVw8wYSWdiWk4fha7OVUG4lP9VGkfL4/?=
 =?us-ascii?Q?+McobXqpQArDfYFx/cevwMDlcal970i5PUGSudglrt1LhttM17qBY1ussnRN?=
 =?us-ascii?Q?knDvo1xbNkr8rj2mSRWW619lVh3ScksMbEhMgkvJzIfkWrYeS3pbkF+s5RFY?=
 =?us-ascii?Q?cCzkgHNI4iwbBe2xlg9+TIUDxBeg/HFof4ftKon1uxEgHPAblZQnV99fxFhz?=
 =?us-ascii?Q?oo+AdNtQRg5e4D+B1cuDX3EKxdj37AYRB93zzYHc5R6UoXTmN1hPutZJnCCN?=
 =?us-ascii?Q?ljeXfu2hyh+vSu1WaaVJMzICxnsM4+rWQbGmysMsd1qqbnxXzhP25jsRltnD?=
 =?us-ascii?Q?4XzVdeSQc/iKulLlVUAT3pcH0bqEudA9Xc8LUCbsnKECSFgB+K040jBRaJa0?=
 =?us-ascii?Q?HtjWGmob5/HOxh9aJmLTbnXCf5vV75+zRTYbDOwYA0b79OEudc4TmBsD04Mz?=
 =?us-ascii?Q?BqHlgO4bpK+obEWLj/UCl3F1oQVvc+rU6ccbbuz0t2eryogjQMszIcSVYMuu?=
 =?us-ascii?Q?4BhgbYOxVvwcqZ6cLMFAna8d8UwFvA1DGBW4nHsjNTvi9vpTqwztDeYiZcwV?=
 =?us-ascii?Q?gCv+SnV3oBNuZUG3NgsYjl9+wQl4cCkax1Nb9RMYk4SUjhCgNNSHNOVoTdPJ?=
 =?us-ascii?Q?Vd2Dbp2ZUTXYUvXebTpXc88Awp9TMCQnmK9DZi2OH5Ni9voI59bNwSBR9Gc+?=
 =?us-ascii?Q?VqG6clzJaYvmj9ka+yHz5by0AZmDUV20AVaUIkwknnSO4gOsrbAdAJRW2LXI?=
 =?us-ascii?Q?T58rGyzqFE3mhkrnYvlltWcibhe0ycgvYnIML6NW2hAXuJG85JdIfWDu6Jn0?=
 =?us-ascii?Q?3U/n4weMBKNT/+T7Qlu1jknSXGDH6tPGRIVnRrBoQZnJFS0wJJgpAfjLo4Oy?=
 =?us-ascii?Q?gGZ9w93PuavMhAbF5y4u+fuVb1s=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e5f454-49f5-4a96-1d36-08d9a8c9a7cb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:50.8623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qp6A7X5aa2IbawjFKZlD+lLMu2OrnEQfAPzgdnH6OeSg0+TarYZZGOYfmVH0dJ/HUOiIV64cw0GFhSzHygrmkpD5PQJUjp8y7Qolm32Zmcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct gpio_chip recommends passing -1 as base to gpiolib. Doing so avoids
conflicts when the chip is external and gpiochip0 already exists.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index cc7fb0556169..f015404c425c 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1308,7 +1308,7 @@ static int ocelot_gpiochip_register(struct platform_device *pdev,
 	gc = &info->gpio_chip;
 	gc->ngpio = info->desc->npins;
 	gc->parent = &pdev->dev;
-	gc->base = 0;
+	gc->base = -1;
 	gc->of_node = info->dev->of_node;
 	gc->label = "ocelot-gpio";
 
-- 
2.25.1

