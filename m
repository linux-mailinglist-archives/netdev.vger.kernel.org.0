Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50574D240A
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350594AbiCHWOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiCHWOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:14:37 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2117.outbound.protection.outlook.com [40.107.92.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA85B4757E;
        Tue,  8 Mar 2022 14:13:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDzeWSwijTQTi2u6vDYyTcsMXZWlOqOGC7PWntD4BKoDBX95cn/YsE7ES1HAziOrGDl1vEwHJgwY1iEDebdXSQUnN2g7NRzo2y3nhQqdGhLls8Mr+lolhzPF6tSZSwFbKCKzJdUcF6x3uar1U1XQ2g1QLtJsBtzfIvuuRIAmZ1XLxEvgYbs0UoVBNhF05WtC6icSorp6hslzN6MhCnM77rI4x2vcKzrutIRgfwkglGJ+InLKWJ9xCULQ1ESmjyxgIv5W8t7BuOEiL/x3lILcQ5dn+kxs7BZKv9+bcIAUHt0En2/a3QSLNNKyLinjrOjTYh6ojmGbeVYW1mZQXsdTMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOiQ1zSG4utOZSqDOLOwD13ZVlYmCLVPtiPb4bnzxcU=;
 b=B+bNFUNB5g1BBe1iv8MGhsgdPF9Q9+c8gGX2JcMDKEO8KPQflX+OJZpj9KBvjdCQEVXdYU/jwDxwArRQZaHy6Yk1bHPi6VDs2VOzT/e5WCsHay63riX0FBEdhbgelU/HerMeWJlAhUGPBRsx2H5jstR5+aa2IHCJvj8oTt55BKlow7H+qZeUJG0zwVWbVJAZTlfG0r93wXEaXWUM8ddopiG8kwBCXqtUMTTDKwhzyoB3dXhZGnxfMxbi0Rm8Zu+xGTq817ex5BWgGhej4P5N7K3xkcnMJjfSUFuqUuEeh0lZVYD95AG3l/5BzOleV4y3+QBhdCoHTxglmjnmvoGbSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOiQ1zSG4utOZSqDOLOwD13ZVlYmCLVPtiPb4bnzxcU=;
 b=Iv1rUC8Q7UrHPxO7QD2ON+WgmuoVgDhovFUEn/xFSEz5624GdQq0S4a/JHRaM1q0DQqP4zk3K/mgTqvaVSgwi3ylz/5964pjRoX2IUykt0TO836hPTzESBjM2raFiiDFGeaLANsVBDLjAausRwUVAYPoeHQUbXX8Kz9sqYHdZts=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB4813.namprd10.prod.outlook.com
 (2603:10b6:a03:2d2::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 22:13:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 22:13:35 +0000
Date:   Tue, 8 Mar 2022 22:13:29 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v7 net-next 13/13] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <20220309061329.GA1309@COLIN-DESKTOP1.localdomain>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
 <20220307021208.2406741-14-colin.foster@in-advantage.com>
 <20220308141440.ggghkmkteey74cwo@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308141440.ggghkmkteey74cwo@skbuf>
X-ClientProxiedBy: MWHPR2001CA0019.namprd20.prod.outlook.com
 (2603:10b6:301:15::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb2350ab-d6fa-4dc8-81cb-08da0150e312
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4813B32487DC531988E077B2A4099@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QguBrq/AZE7JSg+fW57H53wPggKU2gjb19zqi5CLao2iAq3kqEmCJrsVdzvivfWA++3/wF0UmM/ii9kbBD+Gw6OuBBIK72Loqq20/hphgREVU2Pb88dkWPxAx20QM0H6V635VQGsnnqY9GxbY9ScMtEg82kA6/cZ9cK+kJIBGMtVo6KXVKZvRbu3Muq+aF+75ere3r5zStETtMXKFdgtC8CWRsBoNc5HrZYQBVk0VNYfm8BIgAQLj2OAtRtQckgw652BkrQCHDp44tHUO/N/RHyiL9FBzQlfm3BRdjDIXGOqv267PUL5Y4OgrqtT9dYSq9CZ/4n8JhSmyrb+nAJE2qKZnfTf0ucuqoGFIYxp9aH3OI3RLaLDRxmTjtoqcy51fWPd7VtLkH+KY89SHogKL9hRs0VL9stsUgTyr3ggCzERKWS0xUNSq6sXXWsJ3vpsyakUJAC1d6+9z8NU/uOdGwBYPy77PJKH4p+53skcYUmq08ONqiQQujamPge8S8KUnS/fO1ODs0MhjZ7lmpzXftkzTC0t7s8coqJgDWDOhOvlwyi4In1uj6SIDZ8QMNq0ZVHNWGu/SysmA6Z2H7cgMlGphSqLGHZtcXK+CYqAIh9/6p0RDsz+CvyRyAqb7CJ7uZwEVCBSzh9YHmdbM1akXs3+CDh5eGZaPKvYv2U2CgaK02vJMUObQTwNrtg8vFOXPaI3i/o38+gNFuhTBPWNtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(136003)(366004)(376002)(42606007)(39830400003)(8936002)(6486002)(33656002)(316002)(9686003)(6512007)(52116002)(54906003)(6916009)(6506007)(508600001)(5660300002)(66476007)(186003)(86362001)(83380400001)(66556008)(1076003)(8676002)(107886003)(4326008)(66946007)(30864003)(44832011)(38100700002)(38350700002)(7416002)(2906002)(6666004)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?llKI2kKg5ucQGolcR+t8mcDticmIxYSiVhvSO0VZxFQZcUIvXFDL2JWpFkQO?=
 =?us-ascii?Q?VVZHQEmgTZY5ENqqf3J8ZNymsuIOqPiNBVSxqVFUtZu3vMZ8GjfxInsv3zky?=
 =?us-ascii?Q?8t6RYCuQt12r8kx4ZwroiRe0yuhoB1CP9D5uXMUnC9eCpt7yUOps1fShnju1?=
 =?us-ascii?Q?w1p5AWw0z+Q/IdgCM1o3szw2QT9JbKjN2gmClOB/bMIzJlnLHxWAuJmGfps6?=
 =?us-ascii?Q?3/9ZajAJbg62hESugHc9GMvN3qMC/z6V+VYot6n6rUa5zT+qyf844nVjJt/5?=
 =?us-ascii?Q?C1czbatz8Ld5MWlBSv/9mpmaH5N7pf5ZUwP+EAI3xCNO/uwNjQg2ka/F48et?=
 =?us-ascii?Q?be28r3y2JPS4dOVp+xv/7kPAT2stHLnjOOc7Uixc8Dtqp9BRkGgDgNe8AR5P?=
 =?us-ascii?Q?nf3L+M9Qs+vWm1NX7FX5geR8mlNYr33OozJDnlC5IHKEoTsZXbutY1gKvDvH?=
 =?us-ascii?Q?weNTdxGMZ2L5PM7BeldmqSFRv3ljiJNYixEH0O0NurkeS5oxm+rHrXFshWrZ?=
 =?us-ascii?Q?Tu21dh4izJLe+ssUCeEOSm4HQ233rWMFaZsRA+1HlESB7M3IWUciaccA92Yz?=
 =?us-ascii?Q?9xXqJpO7yuARXH+uWadoHiu4ThsFIjLlHRB1Spa+uMwlB2+2pa25BDIsqhdc?=
 =?us-ascii?Q?0OZtiKIJM1FAwmuugPY0mfGGNSR8IX8Qxf+TI/P1pJr8wAbYwlwzVK0TmVmL?=
 =?us-ascii?Q?BMy4q1onievmsAipRK3KmyOJmhRu7DzqZJFNIy/gBIc2j9/wrJDGdcXlT0gv?=
 =?us-ascii?Q?2lyl7t9Wpv7uy50NEk9zFPG8OZILufyq+jO33VbUbvOeRDW5vPGtZnUhVdFK?=
 =?us-ascii?Q?Xw0DA9/pfBr+tn78MfBa+y9cW6fCX3Q4HhyaUdmrokTbqidrohlc7Bgtjv/y?=
 =?us-ascii?Q?bREOJg76wEUI0lP3Ps0tm3fJqex8zpZ98ICS3in/vW+fZxIwFt9PDP8UNGsA?=
 =?us-ascii?Q?wzQHiIoimpYy3OWcBpW8J/SqAaj0ZTAFe18mCE9+4rM8V8qHvRVzc7pQ3vwc?=
 =?us-ascii?Q?5GIXsiIUNagNOh8c/YdDcB4w/Duy5ECyaedzRfYCWOwNM1Dtgk2lMj+Ho5W9?=
 =?us-ascii?Q?wlrA0IZFzOLlogg1LuEeD33nSEiEwLgTzX5Cf+Ry4W9mC8Qo9BDmTJ+auTYt?=
 =?us-ascii?Q?fpE1+Dsz93fgAnFp6W3J6ueibxqmhe9hCSpGhwLLdwY5hgDW5jwZ38TbJ4Ja?=
 =?us-ascii?Q?IeDYuP8eOZPi7nb+BjSGe/0jPo94Gw7tEDNI/ZlCldqpxCdXcWmy4Xd/M38x?=
 =?us-ascii?Q?EvhIGGHbiJkSiqyasA43Hm1qffqqM7QNZcLHMDNM0Y8UEpuMZ4Mo6mIX3UGm?=
 =?us-ascii?Q?5tlh5pREgPy7ev1Dl4ODq5152vxnztALJnuMKFtzjZ8bp+FQIzHeF3CgQ7P/?=
 =?us-ascii?Q?WM6vVxQTPggtFkaiwGCnF4Kut/GMcOghlgoPq2UrOoSHvnRPq4wp7xEoYr5J?=
 =?us-ascii?Q?wjLgiCfwOeNdZDBSncYBGjY7TmCLRy9XJcjLIfnFathcBRlPgwrRosaMVxrG?=
 =?us-ascii?Q?IQybHPzD5db3qFZJL75j0N+k0jIFpiIQU8OZSMUP0lBPxgHrh9TTZfUHoRnU?=
 =?us-ascii?Q?UPCtcmD+08nH6A2Oxk0+rkd1waiHd2cGaG1/og1V1yX6OejvxkuNkSLkVGF7?=
 =?us-ascii?Q?1TZhqcZqAzzw14/TrNpHqOHpq769wkX3C9YQpCHghfEI1YOKCeLNhwuhWnHW?=
 =?us-ascii?Q?btDdCA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2350ab-d6fa-4dc8-81cb-08da0150e312
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 22:13:35.0154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xfK3qU4icbmeC74M22vsZL6Ht+dyj1OFT5iD0e4l9IZZVBWuBjltrAI4oVWcmZ0wMzneM1wGYIZrJ6T45CWJAZiSff57uEuMXTL8jBtX77g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 02:14:40PM +0000, Vladimir Oltean wrote:
> On Sun, Mar 06, 2022 at 06:12:08PM -0800, Colin Foster wrote:
> > +static const struct reg_field vsc7512_regfields[REGFIELD_MAX] = {
> > +	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
> > +	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
> > +	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
> > +	[ANA_ANEVENTS_ACLKILL] = REG_FIELD(ANA_ANEVENTS, 26, 26),
> > +	[ANA_ANEVENTS_ACLUSED] = REG_FIELD(ANA_ANEVENTS, 25, 25),
> > +	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
> > +	[ANA_ANEVENTS_VS2TTL1] = REG_FIELD(ANA_ANEVENTS, 23, 23),
> > +	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
> > +	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
> > +	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
> > +	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
> > +	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
> > +	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
> > +	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
> > +	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
> > +	[ANA_ANEVENTS_DROPPED] = REG_FIELD(ANA_ANEVENTS, 14, 14),
> > +	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
> > +	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
> > +	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
> > +	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
> > +	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
> > +	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
> > +	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
> > +	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
> > +	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
> > +	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
> > +	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
> > +	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
> > +	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
> > +	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
> > +	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 18, 18),
> > +	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 10, 11),
> > +	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
> > +	[GCB_SOFT_RST_SWC_RST] = REG_FIELD(GCB_SOFT_RST, 1, 1),
> 
> If you add GCB_SOFT_RST_SWC_RST to ocelot_regfields, can't you just use that?

Interesting idea. I'll look and see if there are any bitfield
differences between the 7512 and 7514. If no, I'll do the same I did
with vsc7514_*_regmap structs. 

> 
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 20, 20),
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 8, 19),
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 4, 7),
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 1, 3),
> > +	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 0, 0),
> > +	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
> > +	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
> > +	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
> > +	/* Replicated per number of ports (12), register size 4 per port */
> > +	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
> > +	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
> > +	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
> > +	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
> > +	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
> > +	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
> > +	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
> > +	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
> > +	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
> > +};
> > +
> > +static const struct ocelot_stat_layout vsc7512_stats_layout[] = {
> 
> Why not use ocelot_stats_layout?

Same as above (and below). I can probably remove all of these.

> 
> > +	{ .offset = 0x00,	.name = "rx_octets", },
> > +	{ .offset = 0x01,	.name = "rx_unicast", },
> > +	{ .offset = 0x02,	.name = "rx_multicast", },
> > +	{ .offset = 0x03,	.name = "rx_broadcast", },
> > +	{ .offset = 0x04,	.name = "rx_shorts", },
> > +	{ .offset = 0x05,	.name = "rx_fragments", },
> > +	{ .offset = 0x06,	.name = "rx_jabbers", },
> > +	{ .offset = 0x07,	.name = "rx_crc_align_errs", },
> > +	{ .offset = 0x08,	.name = "rx_sym_errs", },
> > +	{ .offset = 0x09,	.name = "rx_frames_below_65_octets", },
> > +	{ .offset = 0x0A,	.name = "rx_frames_65_to_127_octets", },
> > +	{ .offset = 0x0B,	.name = "rx_frames_128_to_255_octets", },
> > +	{ .offset = 0x0C,	.name = "rx_frames_256_to_511_octets", },
> > +	{ .offset = 0x0D,	.name = "rx_frames_512_to_1023_octets", },
> > +	{ .offset = 0x0E,	.name = "rx_frames_1024_to_1526_octets", },
> > +	{ .offset = 0x0F,	.name = "rx_frames_over_1526_octets", },
> > +	{ .offset = 0x10,	.name = "rx_pause", },
> > +	{ .offset = 0x11,	.name = "rx_control", },
> > +	{ .offset = 0x12,	.name = "rx_longs", },
> > +	{ .offset = 0x13,	.name = "rx_classified_drops", },
> > +	{ .offset = 0x14,	.name = "rx_red_prio_0", },
> > +	{ .offset = 0x15,	.name = "rx_red_prio_1", },
> > +	{ .offset = 0x16,	.name = "rx_red_prio_2", },
> > +	{ .offset = 0x17,	.name = "rx_red_prio_3", },
> > +	{ .offset = 0x18,	.name = "rx_red_prio_4", },
> > +	{ .offset = 0x19,	.name = "rx_red_prio_5", },
> > +	{ .offset = 0x1A,	.name = "rx_red_prio_6", },
> > +	{ .offset = 0x1B,	.name = "rx_red_prio_7", },
> > +	{ .offset = 0x1C,	.name = "rx_yellow_prio_0", },
> > +	{ .offset = 0x1D,	.name = "rx_yellow_prio_1", },
> > +	{ .offset = 0x1E,	.name = "rx_yellow_prio_2", },
> > +	{ .offset = 0x1F,	.name = "rx_yellow_prio_3", },
> > +	{ .offset = 0x20,	.name = "rx_yellow_prio_4", },
> > +	{ .offset = 0x21,	.name = "rx_yellow_prio_5", },
> > +	{ .offset = 0x22,	.name = "rx_yellow_prio_6", },
> > +	{ .offset = 0x23,	.name = "rx_yellow_prio_7", },
> > +	{ .offset = 0x24,	.name = "rx_green_prio_0", },
> > +	{ .offset = 0x25,	.name = "rx_green_prio_1", },
> > +	{ .offset = 0x26,	.name = "rx_green_prio_2", },
> > +	{ .offset = 0x27,	.name = "rx_green_prio_3", },
> > +	{ .offset = 0x28,	.name = "rx_green_prio_4", },
> > +	{ .offset = 0x29,	.name = "rx_green_prio_5", },
> > +	{ .offset = 0x2A,	.name = "rx_green_prio_6", },
> > +	{ .offset = 0x2B,	.name = "rx_green_prio_7", },
> > +	{ .offset = 0x40,	.name = "tx_octets", },
> > +	{ .offset = 0x41,	.name = "tx_unicast", },
> > +	{ .offset = 0x42,	.name = "tx_multicast", },
> > +	{ .offset = 0x43,	.name = "tx_broadcast", },
> > +	{ .offset = 0x44,	.name = "tx_collision", },
> > +	{ .offset = 0x45,	.name = "tx_drops", },
> > +	{ .offset = 0x46,	.name = "tx_pause", },
> > +	{ .offset = 0x47,	.name = "tx_frames_below_65_octets", },
> > +	{ .offset = 0x48,	.name = "tx_frames_65_to_127_octets", },
> > +	{ .offset = 0x49,	.name = "tx_frames_128_255_octets", },
> > +	{ .offset = 0x4A,	.name = "tx_frames_256_511_octets", },
> > +	{ .offset = 0x4B,	.name = "tx_frames_512_1023_octets", },
> > +	{ .offset = 0x4C,	.name = "tx_frames_1024_1526_octets", },
> > +	{ .offset = 0x4D,	.name = "tx_frames_over_1526_octets", },
> > +	{ .offset = 0x4E,	.name = "tx_yellow_prio_0", },
> > +	{ .offset = 0x4F,	.name = "tx_yellow_prio_1", },
> > +	{ .offset = 0x50,	.name = "tx_yellow_prio_2", },
> > +	{ .offset = 0x51,	.name = "tx_yellow_prio_3", },
> > +	{ .offset = 0x52,	.name = "tx_yellow_prio_4", },
> > +	{ .offset = 0x53,	.name = "tx_yellow_prio_5", },
> > +	{ .offset = 0x54,	.name = "tx_yellow_prio_6", },
> > +	{ .offset = 0x55,	.name = "tx_yellow_prio_7", },
> > +	{ .offset = 0x56,	.name = "tx_green_prio_0", },
> > +	{ .offset = 0x57,	.name = "tx_green_prio_1", },
> > +	{ .offset = 0x58,	.name = "tx_green_prio_2", },
> > +	{ .offset = 0x59,	.name = "tx_green_prio_3", },
> > +	{ .offset = 0x5A,	.name = "tx_green_prio_4", },
> > +	{ .offset = 0x5B,	.name = "tx_green_prio_5", },
> > +	{ .offset = 0x5C,	.name = "tx_green_prio_6", },
> > +	{ .offset = 0x5D,	.name = "tx_green_prio_7", },
> > +	{ .offset = 0x5E,	.name = "tx_aged", },
> > +	{ .offset = 0x80,	.name = "drop_local", },
> > +	{ .offset = 0x81,	.name = "drop_tail", },
> > +	{ .offset = 0x82,	.name = "drop_yellow_prio_0", },
> > +	{ .offset = 0x83,	.name = "drop_yellow_prio_1", },
> > +	{ .offset = 0x84,	.name = "drop_yellow_prio_2", },
> > +	{ .offset = 0x85,	.name = "drop_yellow_prio_3", },
> > +	{ .offset = 0x86,	.name = "drop_yellow_prio_4", },
> > +	{ .offset = 0x87,	.name = "drop_yellow_prio_5", },
> > +	{ .offset = 0x88,	.name = "drop_yellow_prio_6", },
> > +	{ .offset = 0x89,	.name = "drop_yellow_prio_7", },
> > +	{ .offset = 0x8A,	.name = "drop_green_prio_0", },
> > +	{ .offset = 0x8B,	.name = "drop_green_prio_1", },
> > +	{ .offset = 0x8C,	.name = "drop_green_prio_2", },
> > +	{ .offset = 0x8D,	.name = "drop_green_prio_3", },
> > +	{ .offset = 0x8E,	.name = "drop_green_prio_4", },
> > +	{ .offset = 0x8F,	.name = "drop_green_prio_5", },
> > +	{ .offset = 0x90,	.name = "drop_green_prio_6", },
> > +	{ .offset = 0x91,	.name = "drop_green_prio_7", },
> > +};
> > +
> > +static void ocelot_ext_phylink_validate(struct ocelot *ocelot, int port,
> > +				     unsigned long *supported,
> > +				     struct phylink_link_state *state)
> > +{
> > +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +
> > +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> > +	    state->interface != ocelot_port->phy_mode) {
> > +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +		return;
> > +	}
> 
> You might want to check
> git log -4 --author="Russell King" drivers/net/dsa/ocelot/
> especially commit e57a15401e82 ("net: dsa: ocelot: remove interface checks").
> And you can/should in fact use phylink_generic_validate, since there
> aren't any special constraints that I know of.

Oh, nice. Thanks. By the end of all this it feels like there'll be
nothing left in this file (in a good way!)

There might be more implications for me regarding commit 
79fda660bdbb ("net: dsa: ocelot: populate supported_interfaces") since it
seems to be based on the assumption that every sub-driver only supports
a single interface mode. I still have my homework to do there though.

> 
> > +
> > +	phylink_set_port_modes(mask);
> > +
> > +	phylink_set(mask, Pause);
> > +	phylink_set(mask, Autoneg);
> > +	phylink_set(mask, Asym_Pause);
> > +	phylink_set(mask, 10baseT_Half);
> > +	phylink_set(mask, 10baseT_Full);
> > +	phylink_set(mask, 100baseT_Half);
> > +	phylink_set(mask, 100baseT_Full);
> > +	phylink_set(mask, 1000baseT_Half);
> > +	phylink_set(mask, 1000baseT_Full);
> > +
> > +	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +	bitmap_and(state->advertising, state->advertising, mask,
> > +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +}
> > +
> > +static struct vcap_props vsc7512_vcap_props[] = {
> 
> Why not vsc7514_vcap_props?
> 
> > +	[VCAP_ES0] = {
> > +		.action_type_width = 0,
> > +		.action_table = {
> > +			[ES0_ACTION_TYPE_NORMAL] = {
> > +				.width = 73,
> > +				.count = 1,
> > +			},
> > +		},
> > +		.target = S0,
> > +		.keys = vsc7514_vcap_es0_keys,
> > +		.actions = vsc7514_vcap_es0_actions,
> > +	},
> > +	[VCAP_IS1] = {
> > +		.action_type_width = 0,
> > +		.action_table = {
> > +			[IS1_ACTION_TYPE_NORMAL] = {
> > +				.width = 78,
> > +				.count = 4,
> > +			},
> > +		},
> > +		.target = S1,
> > +		.keys = vsc7514_vcap_is1_keys,
> > +		.actions = vsc7514_vcap_is1_actions,
> > +	},
> > +	[VCAP_IS2] = {
> > +		.action_type_width = 1,
> > +		.action_table = {
> > +			[IS2_ACTION_TYPE_NORMAL] = {
> > +				.width = 49,
> > +				.count = 2,
> > +			},
> > +			[IS2_ACTION_TYPE_SMAC_SIP] = {
> > +				.width = 6,
> > +				.count = 4,
> > +			},
> > +		},
> > +		.target = S2,
> > +		.keys = vsc7514_vcap_is2_keys,
> > +		.actions = vsc7514_vcap_is2_actions,
> > +	},
> > +};
