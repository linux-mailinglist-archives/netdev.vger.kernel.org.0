Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AC45F86D9
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJHSwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiJHSwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023A63FA25;
        Sat,  8 Oct 2022 11:52:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N16kqmyKJl4iN73YOzG45EtUO4jRms8tiqWSwDoqDw5y0FtNRc5b4goMPmtzYecx63TkWlZiu7z/EzHGfR4+8zo1ZAmmu6Fv4pEgtZrJVFzgEXwN044gHq9oQfCPNyrZ15QcmMZh5V7zT5W+XnDS6yvZnW06ehL6jlcu++MPplulVoZHkJCV73N/7o0I47bgUmZgTr0RmN5U+mJNM3xjfFsLLu9kMspdOunl5TXh+JV9rRFuk+wAbbwyWITtw/9v6zgBuHnWFckhuwDtBccMpTlyc8OTG5/IGML6P6ntu3bv3L+gKG/qNc17xirTp+MFxkTfWiAsY95xw/jd+mYoZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cpMbOVw6uh87QImc+X5A0jBc16Ci0MxOxYuoUUx5Ig=;
 b=gW2Y6U3F4O6G7brDQWlMOQKDFwFq4tHNcjEr9aFa5Fnhu7xyFVVkbNuSZjR5nmrjgV0DLjNES89W2ZkAOJb5bQ9pGZlbumO+LKSokS+DMuRKOwpqLkVSqNlQFvPi/9j7l3S1iQcjxyJ7rmLf2OgegazuutB79irKIlt0HHDupOahElyCy8dqovqKuHQdujqvMPnXKXbpizmAFPpWVt/HGf+SyaaD6H/nR/XtLNRiQYrRHnMBrisPcBBsQre7t0d2KV91VZbotGNu5bUBm3paNfomN3UUr++iQfXoPX5eDQMN9ct38fTM6YGyCY7s2IrUlOW6NVrJwVzYO/a+fML2ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cpMbOVw6uh87QImc+X5A0jBc16Ci0MxOxYuoUUx5Ig=;
 b=OqUpPrmY9/M6L8mVxKFyWDzi2gSyeSvaaY0fx0r+xyBgsanVMA9WgWqTd2CNKRQKi3PjhbvVQD0lYDhLcbrPUeikn/kJHVHPu7+XuvzhTSr9eJ+qecPbzfqLrmteFTbrYCjtACVgunk+TSKUWL00btL7JPnNCQjlyoI3zw4uC1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:10 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 11/17] mfd: ocelot: prepend resource size macros to be 32-bit
Date:   Sat,  8 Oct 2022 11:51:46 -0700
Message-Id: <20221008185152.2411007-12-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: f5c7a404-4c10-4588-4b4f-08daa95e342e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSkboECQpOEGma1puHvtB4XAv7JjUATKqzA1MTZNuOh46jurPY1b2mcoFFhD9Mfp5vwRQ/T2A6sDPQxsTUEZXVQyxkOsP511G7QmlvyjT7m0YFuCUwnYEXEwgTMs3rjZZB+BEF+sRJaLohsTN2EqlVwpp+hUVesKFYdKbWki18a+pEfYTo875xuaEIrxYzQbMAyWJ62yTNTpfi9J1kJ80Cg//J+g4EYvS4aSSzEkvDHGRvXZ4ztsYB9ep0nhdEouhwalkcCygLAe74uE8BmxWyH+PDhhbFLnet7LzD1826Ccw7ivXcgGKNeJX548cYvV4lA5RV7zfiGrTwbsZVirRO+bEAUU7CqS38Co7ACSriE8kob3Vm7VCnC6U1xxr5H2i627CMrlfX+4RUFJDLfG1NHmMmYeINfgwcTuqD4tnRga4EtjFaZ5+SSnPHjG6zpRvAK54MeQ7j97RE5XCcJJQoPeB1stu7c2s9DLCo96MzUloNQfHeDU4WXkUxbMDnNhJ6APvDDAi9X+o8/Lvj0uWmGd52jZy36lioxLyqaDISeTlantCIkhx3t8SqasReGN7BdqqDooS65RZPKDCZpZLGlFxG5RZZNZTLvXed+Cz7qszThZRPhymQlxOb/90suFmJOdLMPKnSD4sIUTRSqjJrv2R2y4rqUADdDXbyEXKSbJ4rFxwGRzeOLtahuzGeKog0mVJdPAjZPbyprP1GICabjNlBq+ec8CberybAUoS1Ga0HYfxjy2k+y4ysa9kKrUFlOEr2ceVeIbsPCYjFEz7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NjaxF3yGzH8EijYf7rVu/5OpUYpkRbOQcgRrCciG2zDU/EQO45euCLA4CtVf?=
 =?us-ascii?Q?Cc9WNejFUQjBOq64Ta4e9XZ8xlNFC9B4Vtj5WiXq8WqMP8qNKgl4XoqTju/d?=
 =?us-ascii?Q?UyovVViYEHdXHzCWW8j8GJk+YlhIMd7POALPzG7nwOgSvgERkdTo7r3ar9Qa?=
 =?us-ascii?Q?2EaY4vJW+K1Cu9IDgMWe+TjLMuQpHmQC0swyCasPuSXoh51MZmpWvXHO8DYY?=
 =?us-ascii?Q?uhDy1lrL1a2DeoagzwCWpXimJ36eNsoLgm4ih50EjzRu6GuqJudlKyiFLAcs?=
 =?us-ascii?Q?A2xTAIklOIBYw7jsyjZt1Dt3vfzS0pixHB1w38QPSAgtO2ruhFPutCGx0SDg?=
 =?us-ascii?Q?s8nhPrrNIvLHDHqV9dxF7hewNwoUBHRCUXUUEAIg9BJVk0+bRANgzGKTGY5b?=
 =?us-ascii?Q?sRWreXuYOIjIj9FIfOV9JGcbeGMs9OvBvqR0RLi4P+bnxxAQAO8pTEqX4VSA?=
 =?us-ascii?Q?qW/RhO8i/zkq4JMUO/to6gub/Ci8I1V3JtK5bIebqEBo9vlxsUJYBmx/6Qcv?=
 =?us-ascii?Q?k3q7xfzOkeUvBq8yAiuFoMLcAkX6xBJZGFw3HZOjbt0k118WWY2+BOHiyXpd?=
 =?us-ascii?Q?A/g6jKpwtdkVvaiFdx6F47mEyBV5+OSL8/u3bRinGx+8T0GFT1h7X/dQw0KY?=
 =?us-ascii?Q?J+wh0hg15+9dx72jkZ2G5EvWac2DOzFyvios2pfs0FdFZRzSpb0bcioHaAMZ?=
 =?us-ascii?Q?0DKv71YF58Sm6aNGFkHupln5U5olHDfi1DtMkYMtrdeSRw8yfLnVoWthuhEi?=
 =?us-ascii?Q?Mm5CnkyNdR9FRX+3l6ZdZYznaA7teVa+AhemllLGYqASoZxMF119ux8Q7R01?=
 =?us-ascii?Q?W2jFXH7qdjfmJx0F2ZGbFBSQrg7V7mBxA8wX0O1yk3NpghHMXBszQ/MmL47h?=
 =?us-ascii?Q?s7yLSyd2dPFSxsTpPUc2dJ3umq//XIDfyyR9cQzvChRv5xTnSBENfYyZnK+i?=
 =?us-ascii?Q?b7N/5kA1lZmoJ1xm7Lx5onAGJV0HfDmVVCv/d70H2Hv/TM2aQID8IrbzEA0b?=
 =?us-ascii?Q?PvWgKkE4OeZ/XkGuaCqjygfOaJdntjs7pCRUrINTjmFWlSuEIuTZSQjqo0sv?=
 =?us-ascii?Q?4HjpGh1O6tW+w01XBz0wo47F34Qyqbt7Y+Yg4JV/Q58UAQw4k/UdSnS8QsH4?=
 =?us-ascii?Q?wX+XKbiDMum1jqerrHHGNeAqrvBrw8L2drSDLS8ZE8zfdV7khmcctRKVkkeB?=
 =?us-ascii?Q?+v+22SMecThqWUAzW2qjDNqJlqyhFL3US6lvfAcT9ipuQ/PVtLMepSlP7i9d?=
 =?us-ascii?Q?0aTIHd/ANm/8jScxWoFMZwvheKGfm+FZ/ScJN8oouFgEWcu7pMGPyXIlS14Y?=
 =?us-ascii?Q?z3TPVftoJvjSAIAlDDjtlfBiQoR9lU0n5NiKCEN1ZCeB4XJ/tSoFt1aNnQCg?=
 =?us-ascii?Q?Q7FOfi2FbSEaMgHMVZmc3/J5pms/GtfyOJtEyCjAnCz+EJ73WkBO2ixtev02?=
 =?us-ascii?Q?dsU0EByuFCmohTNZr/218GNMif/I+Y7G7ND9L7fUF4NEiJQvNSG4+2LRdocb?=
 =?us-ascii?Q?0MtyJ3N4rjQgWozFcR1Sz8s1o9ihdx+EIrR0Ql8J3CFHSLwm9rJNMqKIGYMD?=
 =?us-ascii?Q?qPRUH5ojpo5e/ki+gERx7Tu+KLXUOT2veVaALL6ojDRB9+GNTOyZ7/6x1HfL?=
 =?us-ascii?Q?J65ppAsxbTBSUPyHKNn8ikU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c7a404-4c10-4588-4b4f-08daa95e342e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:09.5534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVLbqWnue57uiRZIW7IfvHhbW4DQ2ZgaVo0HFHIWjXDZileTzsAoxA1acFSuLjSJ/4/zoHJrNg77hugslIuwyQlGk3E50dNcfisN3iHGpQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
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

v3-v4
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

