Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B79F52746C
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 00:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiENWAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 18:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiENWAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 18:00:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2091.outbound.protection.outlook.com [40.107.93.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FCE40E4C;
        Sat, 14 May 2022 15:00:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mReehP3/wFjBybdMtnHAgQ8iLHsNtkpX686b0iS27+mPsykzTCk/Y+L4nBh4xOgMnUu2vzSO9XFKQFLryj4xOroYxE0k4oVobVgpa+ymJJVtw+WiTBn/kF2mJx/AXwuu4XFr8V4G5qUrX+J77Dx++DH/WCo0p7tEhRJs+EKQQ6gqfps/3YlQO7pVtDMTWmKNHTkCLYK8zqi6bYxtnCWOjDIZmxVk114MrheIfj0AV4Cf1iCvuq2/lOyey2PM+Sz6GWAZgJt0k11r2Pr+PIAUo85ef3/E9BQwOv5kskT3RZp7jg3sm+X2vlfaNlSdn72Nv/jV91Uljdjt4ZwDzgXj4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1rBSQiyNLoFtfXWg3Q24TO6m3EGxl2gqQcrEeeHQ/8=;
 b=XLQRmmb90txcXg99Q3KjnzM31etr2A71EOTS5LxGCDRKgN8kc0d0Z7FWhMyb27lGn1SGD7JJXg4qF4zHFYupg8p8SfDezw5QBuKTydxhU7thPxYJm6JXscVc2JLt9ZcpD1agHbvjPUZAvQU0g6S6rEgJ2/YlWPYQ9MaBKlJ8BrCP7gFMoEhxu8ts8OVD7F2n305+OQ36wLNEp7K3Ha8qyj1wzTW61cLtCv870Zw2FssAmL7WmRW1zBmoHVP+A+8rXgzHGOLeKv6qlElGYEotxMMecqogKYFViFK15I9zjqlBZ/J2s1S+30dWoVEUDGG9tPeyGyhCk7s2FMDxzmRydQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1rBSQiyNLoFtfXWg3Q24TO6m3EGxl2gqQcrEeeHQ/8=;
 b=JuSzqooQvermu1RCIrZP0CyWSHArARmSISzqlMNWovbz3KKaKSKTsyvxQLZHxwPVhihzIcAOXz8/TqvjW+IE7bWdnlPf/baM+vFZF9j9P+n9elrLhv8hEClZeK7tfeYgH4i00BhNzCUi+DhLog0RdfbkVZge11NxByDpUctGiHg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN7PR10MB2658.namprd10.prod.outlook.com
 (2603:10b6:406:c7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Sat, 14 May
 2022 22:00:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.027; Sat, 14 May 2022
 22:00:14 +0000
Date:   Sat, 14 May 2022 15:00:10 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
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
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [RFC v8 net-next 00/16] add support for VSC7512 control over SPI
Message-ID: <20220514220010.GB3629122@euler>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220509171304.hfh5rbynt4qtr6m4@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509171304.hfh5rbynt4qtr6m4@skbuf>
X-ClientProxiedBy: SJ0PR03CA0371.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 094f71e9-ed98-45f3-fbf7-08da35f51fe4
X-MS-TrafficTypeDiagnostic: BN7PR10MB2658:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB26585D58D96056D3B58E76FFA4CD9@BN7PR10MB2658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFsgkvJ3k4KXdp2fOWLbR1mf6qa2OzoFIZoTvbCxVIA45cpHldveVp5PsJUeso2Rk8AqF4KG6vQR0mk0pw5z1CvgLFRYcQoALhvKsZLN75Bsirp5O3StlwMwAt3p+tYIKUHOHokkbv6mohsg9nSgo/u5NRuVJg786zare1geX2cSM+vzA5UZh103JNWfgmWTD3SHkgZ4Ial+lgo2TeIK+1QT17iyQUd6GcFVMkP7/ZIT90maxncEozMtkNGt/Cnn7/3Tn0UoW21OG17CRqMPPbZTlfzxqLDXFOMBMcqdjpm9uHynXXzCVm2Av+z5pT7RfrixGHQ1dxxk6OXJcychJhaZM8UobgJ6KAczJwBD+Q/+phGu3jfjIkmKAw4ObxImTMmLSimW/WgldU68W37RtolgrCaFUAY88AF0tM5oCf+cpiBJaQSbggZ7x02Xh748qKCJpwpcaKs+ABqjbpgLLsPztMINs6TEODBT59OYVAMUUbIdKVZIEfOstl1RXzbcTMMu8Mc54vJyqpgRgs0ERp3tQJ2W1MdmFBGYptSkBM1y6fsJR9O7mcyNKAYKLUSTgP9EkGP+LwXZjU09MqmSbnjnXP8VZ0fd5HkHBoJmC8TkdF/4dtV4CUdzz2hOiSMBGG0kjT6/0vY91TraSOU9wHQ+owtojQQ+Av2saZUuJ8eFZjYeVk/XmEGXoRejVDQwkcCxtl5hE7h7U1ZI2N/quQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(376002)(366004)(346002)(136003)(396003)(39830400003)(4326008)(6666004)(86362001)(33716001)(44832011)(38100700002)(66476007)(52116002)(66556008)(508600001)(6506007)(6486002)(2906002)(33656002)(66946007)(38350700002)(316002)(8936002)(41300700001)(1076003)(8676002)(54906003)(5660300002)(6916009)(186003)(9686003)(7416002)(6512007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?joi86G/SJSijQoFeZReUpFCdo09Y2K6hJskFMRf2wvp4ZR3gO497NEHw5uYV?=
 =?us-ascii?Q?p9pshKzzEsH9ivGRT8vksgLCrXLlA+AN3F5PVAG7csq+61oB0EKiC/Y8gTYR?=
 =?us-ascii?Q?UUEwq/eNtmj72Z4cWnbhzNjSPigvcXBTaw6SQxtNLHI7k3CqcYOoSA11JDee?=
 =?us-ascii?Q?G+/v4910loA957hVsrTJC62HVLiaoqRmWnK/YpLXgnD5fZJsjaj3MGNGp5A6?=
 =?us-ascii?Q?1n+/PmuEgnRfVwrqWeNVWU49cZPodYZD/K24GKzrhFUcum095dUmKaf63/xD?=
 =?us-ascii?Q?+50IbqK7NfMtukpwjEI6IKvZ/02+lYbAiJ94NzrvVbxXKk7RzAuxXP40nqKL?=
 =?us-ascii?Q?yVl2uZ68BlR1UaibPLM1K6FOQzMHqdaRGCM+anaeE/6vfER63aRMI1LXe4zw?=
 =?us-ascii?Q?UYYni5NIagm59WcRJuA0Pj8ELlxvvThq8Qz2jUG3DC+vkgyeZMnkc261YIYS?=
 =?us-ascii?Q?BBGNmG2f9/x8p7AkbgiaveXugN6G+CqZ6k4NI0XkWHuAKmtRTx1hen6WN6PF?=
 =?us-ascii?Q?gnx5+pDLFqWSATwCVkCLzjXu4OZVZ6E34X0YNUBjx2UZWN+BXjrfM0gMNj2P?=
 =?us-ascii?Q?oZBN/kp7CRqK6dFWB4ITQJ6ue7lKqtGeFQ9dMOhNCqo0iz3bkv9JrlSw4+lD?=
 =?us-ascii?Q?njp8/Uz0rSFAceWsMNLH/MwhMIiwwSrN4BCMHLVbvgW1746NP62fhxc76XAe?=
 =?us-ascii?Q?c6mOkEa9mb5vMlNKZLIhk/lfmXYNi+i3ZXPsGjxtZT0mrN2UyrBVyV1Qlu62?=
 =?us-ascii?Q?snfg3BFbxLinzC0LrII4HJB0WdCjbHP8pijLN0djEMG0/+SLMP2f7D/2/urJ?=
 =?us-ascii?Q?k2BuMimSahk3A9xNoE3j1oQfPs+ILB60QV/WUPZ3b1pMFJ96ChbXnED9wBgK?=
 =?us-ascii?Q?BFgbNExO+Vid+cnxpRoHRmFVYsDH8hzJPNkGUCkvti27nDf1hJnTcGRoV/XC?=
 =?us-ascii?Q?U/8287v1CG+RXLqLcDVVZ0VFVzLSGQaAF5s25E4mPQ1jFDcQO3kLngRZrrgK?=
 =?us-ascii?Q?8XM6HE5SBZEAv7irgcLPuuU12mkyBr00jPj2hWZuHbB8Oujfr3PJbU+YpYlC?=
 =?us-ascii?Q?HdjrwasDyjewSedWMCoxxBsD7crxt8wOJSRJwJDQyhRTlxfvmqr2vur6rz2e?=
 =?us-ascii?Q?N3vJCyfMhHHk/HQZdfV6GRuaHENd/1lIDD6t3VHXkZlMC0fwqibhBW+PFJ3c?=
 =?us-ascii?Q?eIiaSiVxk/LN8fupCzEsojD4qEH5IRJVnwClWRqznKjN3UCDL0c+XvAUAX3s?=
 =?us-ascii?Q?5wtAYw56mpcZYOGox9HbPyPRZGB45/A7+YyKRvUMobOaPnnqPR9zMgM9Ipjn?=
 =?us-ascii?Q?HjUPT43yhbeNoiJGImnmjwHQaBv3rWWDZxlZg6n+CIUvtKiyGr99LClcddbV?=
 =?us-ascii?Q?jYVG3bJio+HViWgvxY6dqb1Vg+DSNeuttvpPGX2iUSaxQY9gIaXvoCT9iBt2?=
 =?us-ascii?Q?pQFjdXIol8pUIht+CWwGgDz/o+L2yeA4Nop0Uvuff6XIROZ2dnVZfBzUAL0k?=
 =?us-ascii?Q?9sY1kGNdYhhC0g8+F8PM7/LPg/IRSQTNrQGZgmqK38RL58ST4jRhg9P3pmq4?=
 =?us-ascii?Q?eaaeUlH3c43n+Ul2sgrTaszSphPguQTcCCBVRMtTgIRBieffdhpmCxWK+1QB?=
 =?us-ascii?Q?NM6+VvswcNq4VkcMeACL7HC15AVyncsGm7ZWI+EMP/sNb3YpJTR7mNw8T7/3?=
 =?us-ascii?Q?yxtgerVbhSwdJUU/LSL1yqc6Mh+tDvvjQnsCuYN/w1qSYN+FwBxVggdiW89A?=
 =?us-ascii?Q?hY2JxGUD+LyxqZ4kTaovW6ZRiNPAm2A8KM9OzbD/lowR8jFCJSQL?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 094f71e9-ed98-45f3-fbf7-08da35f51fe4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2022 22:00:14.8456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ysx833LmOpKiuj+nZHqA8u1y92Ivrc3qYcGvE7RMSnm5cG1WAEdmM2WHEiL6HppnsZxBXkOY3K5NgwYwh61pz2mbadhCFxtD//FyAg2Jwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2658
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 05:13:05PM +0000, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Sun, May 08, 2022 at 11:52:57AM -0700, Colin Foster wrote:
> > 
> > 		mdio0: mdio0@0 {
> 
> This is going to be interesting. Some drivers with multiple MDIO buses
> create an "mdios" container with #address-cells = <1> and put the MDIO
> bus nodes under that. Others create an "mdio" node and an "mdio0" node
> (and no address for either of them).
> 
> The problem with the latter approach is that
> Documentation/devicetree/bindings/net/mdio.yaml does not accept the
> "mdio0"/"mdio1" node name for an MDIO bus.

I'm starting this implementation. Yep - it is interesting.

A quick grep for "mdios" only shows one hit:
arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts

While that has an mdios field (two, actually), each only has one mdio
bus, and they all seem to get parsed / registered through
sja1105_mdiobus_.*_register.


Is this change correct (I have a feeling it isn't):

ocelot-chip@0 {
    #address-cells = <1>;
    #size-cells = <0>;

    ...

    mdio0: mdio@0 {
        reg=<0>;
        ...
    };

    mdio1: mdio@1 {
        reg = <1>;
        ...
    };
    ...
};

When I run this with MFD's (use,)of_reg, things work as I'd expect. But
I don't directly have the option to use an "mdios" container here
because MFD runs "for_each_child_of_node" doesn't dig into
mdios->mdio0...

> 
> > 			compatible = "mscc,ocelot-miim";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			sw_phy0: ethernet-phy@0 {
> > 				reg = <0x0>;
> > 			};
> > 
> > 			sw_phy1: ethernet-phy@1 {
> > 				reg = <0x1>;
> > 			};
> > 
> > 			sw_phy2: ethernet-phy@2 {
> > 				reg = <0x2>;
> > 			};
> > 
> > 			sw_phy3: ethernet-phy@3 {
> > 				reg = <0x3>;
> > 			};
> > 		};
> > 
> > 		mdio1: mdio1@1 {
> > 			compatible = "mscc,ocelot-miim";
> > 			pinctrl-names = "default";
> > 			pinctrl-0 = <&miim1>;
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 
> > 			sw_phy4: ethernet-phy@4 {
> > 				reg = <0x4>;
> > 			};
> > 
> > 			sw_phy5: ethernet-phy@5 {
> > 				reg = <0x5>;
> > 			};
> > 
> > 			sw_phy6: ethernet-phy@6 {
> > 				reg = <0x6>;
> > 			};
> > 
> > 			sw_phy7: ethernet-phy@7 {
> > 				reg = <0x7>;
> > 			};
> > 		};
> > 
