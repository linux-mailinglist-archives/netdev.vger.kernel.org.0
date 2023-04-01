Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826F86D3283
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 18:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjDAQIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 12:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjDAQIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 12:08:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0e::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC6E1C1DE
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 09:08:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1Eqyxzeg7tYoeNC+ezLiN0BKo7w90cudLd7+DtN9nHYM4M2mdYoHPVRxhqhVTBCetAg0PenvQoN4eJO5YFvoYEFGNbM5UYtaY6WTK+jQEPGqIKU445uYFqk+n0itkBbKSRnKxZU5hiLnP2cFNO3ohFiKPBHdjk6itabgRQpfcGmkskWWCco9IY4PtayxbReLLfg3Idv1wq/DYn9/ZnwA9kGk6/8ICMy3s8uByQMVbt0nkH/TmVNnHwGYwtFQYg7IuHA1QNOMjEQOxdBLpsL5/S1lvBoDjJ/y9+9AnTGU9edE+9gvaT9hBWuQ4jOFsiH6k2MuvjpqQEv/BQ7FLu6lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRsq+yvi3yEhRmg3l5ItbACYr9cqDJp7Y9AqExKLreU=;
 b=mQIVrtTTRE6hPYComiv7QfInW8RJcY1Mo1en9muw6vY4pXsflHVzGwY+O7aebtkCxNZLEbqTRVIK6ushWDKwQFLxYSmXbPj5Sy6tN2h/eTbN3TFi/m4rdcueMCTVzX9dE+Ret6AebB1Hnl3oWdxbO6LCfC+jzcbqz64tS0vrBlFWIL3aJM/yfZ5tcO7w6m1RELi7gsFUqXnvo/QQukksekTUWsju6g2w5nn33T3lsqgmzjFDYy3JZ/qGYUHkiuyn1UpJJpZaG4OYQJaCunrqUIvkYxDJKuqgFHvZYcQdGrQEq+Bvhhj71gW0dbq31CLCSxFOekmEbne176m8o6PCtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRsq+yvi3yEhRmg3l5ItbACYr9cqDJp7Y9AqExKLreU=;
 b=SCiMw62oyKkGqJZHlox/uREyAo8a1WdOYsqw14tCoVcmDj+RuEXQAG6bsVxBdw0mzQ2Eo05bUn/u2uq8r5Z/4xrqxMDkbau9mGv7R5qyIX1UqcIyaqjM8sgthx59NDYvoaENtkOwgm+Pwfky5o3tM6NLWLk1FuEYKJQ/SH+HI8o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS1PR04MB9504.eurprd04.prod.outlook.com (2603:10a6:20b:4d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sat, 1 Apr
 2023 16:08:33 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 16:08:33 +0000
Date:   Sat, 1 Apr 2023 19:08:29 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401160829.7tbxnm5l3ke5ggvr@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330223519.36ce7d23@kernel.org>
X-ClientProxiedBy: FR3P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::9) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS1PR04MB9504:EE_
X-MS-Office365-Filtering-Correlation-Id: 072a0247-175d-4a0e-8f50-08db32cb577b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vbZtXiCxy0oyBA9Qtei3kOwiwdxlDbdqNA0Bj/yjyUclAvQ9tSyIBF0YmCuEOrQbePrHJlkJwq7+yuP1ROFVA2r2WSw9gZRix//frf4xCK1m1JrsXpkfEXjI6RcLwUDC1nqE8TO6jMuX1MtOMN1nqu5k8akVCLEgokcPvHbN3oQ+0IKbRh6oC1ysXk/3Vsuw6A62cDTiebPGIR2jzl1g19o8clZ5YvkSsMaedNiv/Tf32HPYKKCo55PgEvb+mbG62I9CPD1cvaS4FbiX4TSDAwC0YXy6FiVKo+UGirwyXTpHEuEkAaBPNBPpJyXvtIlX/4I7qH3NFRAVJVb+ksnotKqsLaIt87HthVpWsMbl+hIxya1zPHgWIsdj6doNj58gpBP196GCKIFIMMHJ3/Sg8yDKXXNxW5ppGAmy7DGTNfYMC5J3L/V20iqhDuq59JZD7JZ+DtkR2Cff1naBNxHYuyvBjbFY/yjVRA+hSUfk4bomJxzfUUN+xRHrCXrAhlgau7h5+Fk70sHJqj867zcgcs8Ue8LSvdmw25pAeILb9nNT9oD1662REEYNNm1H2Hpn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199021)(316002)(6916009)(478600001)(4326008)(8676002)(66946007)(66556008)(66476007)(41300700001)(6486002)(4744005)(5660300002)(186003)(9686003)(38100700002)(83380400001)(8936002)(86362001)(33716001)(6666004)(26005)(1076003)(6506007)(6512007)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wktDGgGxU7MMVMIb1Br7bADPuDc7Em0O9+jpCeIcm7tUUoy0wgjUJeYcE9MT?=
 =?us-ascii?Q?teGRfPeL22fx+QjqwdGPOclV8h+Lb5w96Yw+iX8GFBBibo3XwsM8qLzkiOF4?=
 =?us-ascii?Q?Xhc8vapH+U3c0W3ALJkzFi/IEuQ1JaQNb27dvyLoHUHcI+zrFnjO+Vdmm0rS?=
 =?us-ascii?Q?xrJu7i99sXp30PacikmrQfjfMbK0c0SgRs5RQmgmGF1QFIpBifSgNnGKeZQ2?=
 =?us-ascii?Q?KgXPQMnU22WppzsiVKTzrqQjhtZL2NMaLmIzmvA6GmdLimT4fQoHiacdOv4I?=
 =?us-ascii?Q?wqBMykYsxs6VRGCTB9tPs9RPI2D6hZ99IeLBE9BtCt47jkVsORbq1nftXTmA?=
 =?us-ascii?Q?UXXoy6QevCp+g7CXW10vN7V7hQWCYubkjrI7oO7ZoIYFsvSA0LcKWBQwxjQx?=
 =?us-ascii?Q?By8aKnfEfuHbCdmoQz4zO4ZOsCZCjJAnPvWjHpedULSVBs8xX/SpWJmtsRXl?=
 =?us-ascii?Q?4zMyyMsIshMmL5HWQETNLYgSv46Y4OxwGdwvKNFa2dwvpDFlSzX1SMsu2ky0?=
 =?us-ascii?Q?TV5+2InjBJaCA0CA1n/Viibmu0J48vbFApnKI3lw9dEspJCTg3zRaACP/yXJ?=
 =?us-ascii?Q?npGXMx/BbtqSPRxrsYHM1PRHPEF99hTihOUExWaEzNUnTl9AF72B3BRyIT1a?=
 =?us-ascii?Q?GexobLm3DQWA5sHu86VwRKSx52C/+eF300VXLfkLkGN4quxqDx3zHIITBlUb?=
 =?us-ascii?Q?52qiexQY19+1SkCQ7LcThgNdrswNqs8dhPRahkluaJZtrD9j7tOKrqgrKM4t?=
 =?us-ascii?Q?GYZVkPceWkEpN1b5M/4weGwKZHYrjQncQ5PZ84HXl6Tt/cfrvU6wDzPNIeWg?=
 =?us-ascii?Q?GIgiMX02ZlmyzRaUqRZaC4G2U17BC6BM3BF7IH1qyXyYvL+s0yO8o7hiNHrB?=
 =?us-ascii?Q?eYCWmQ/oHw+Ncb6W//tpaJOB2zFIJL3maMNuJhZIFdlC6LoiqIBefPImruNj?=
 =?us-ascii?Q?Uj4j5mmKumokdcVUYPjh0g0arK+2/8v+r+n9L4ezZvt5MSOrcdbWU+clBwOr?=
 =?us-ascii?Q?fNh5IQJC9mjB8Nbv621FV9dfSrZSobwLl9QEFIC/xPU4d/xtqTq2QKDMKBS/?=
 =?us-ascii?Q?O0zs5CE0baICut6LvZeZxB0rhXHywQCVkfePxfbtZpAOhiDnwi1Yr8Uf7iKT?=
 =?us-ascii?Q?Qjq/wfINWW23JgxbGBwBBg7A/kQjlRk46L3u8LXVIz9FZbsZ+fNZsv4PIySb?=
 =?us-ascii?Q?PA/RfrASNQElT8LGymWF4+JD7VA6HjBdhQgtp/hO/5B+WtKT2kEjZiHmNrKb?=
 =?us-ascii?Q?6mbKqjDJTK0IQCxWvhucJWI6lVsWtvfh0RQLcVmVTYpZvXgcpJtjZK4PchDn?=
 =?us-ascii?Q?iiKpnQx87RkKLkKkVdkDy9XNuh451jJ/TzcdThURK+UVad6v+uL1ausR4GJu?=
 =?us-ascii?Q?NH+YIlvok0vnsFqnLdc3icbhIDEJerep/kEuDOF2/pC28YAg7lq8TiCb7GY5?=
 =?us-ascii?Q?QXIHu7P7zRGlur1mS4R7B3zPnpUeBZvOrZ2xh03ID4X2cPhdlvz7G4yljwHw?=
 =?us-ascii?Q?7jDWXHy5pMtoyjQ8pLE3cNSZgCzS35V7SVxLi8FUmRrIDPCrg0SjN8CDFVA1?=
 =?us-ascii?Q?DQahvMWwSMnr4YBEe9uctloocaBxUoC35asN6d52+u7+Y8m/Sz8aC2ZIYfzQ?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072a0247-175d-4a0e-8f50-08db32cb577b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 16:08:33.2694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K3mlLJQp2PrithrmuTyOJzH8oqGGuQDO3+hGZznMm1B227GjIc17vSWkGHUq5wqry4cpq3T/FQ2Mp7nU1dgdSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9504
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 10:35:19PM -0700, Jakub Kicinski wrote:
> >  	case SIOCSHWTSTAMP:
> >  		err = net_hwtstamp_validate(ifr);
> >  		if (err)
> >  			return err;
> > -		fallthrough;
> > +		return dev_hwtstamp(dev, ifr, cmd);
> 
> Let's refactor this differently, we need net_hwtstamp_validate()
> to run on the same in-kernel copy as we'll send down to the driver.
> If we copy_from_user() twice we may validate a different thing
> than the driver will end up seeing (ToCToU).

I'm not sure I understand this. Since net_hwtstamp_validate() already
contains a copy_from_user() call, don't we already call copy_to_user()
twice (the second time being in all SIOCSHWTSTAMP handlers from drivers)?

Perhaps I don't understand what is it that can change the contents
of the ifreq structure, which would make this a potential issue for
ndo_hwtstamp_set() that isn't an issue for ndo_eth_ioctl()...
