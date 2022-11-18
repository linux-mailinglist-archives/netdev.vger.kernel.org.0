Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7408962F994
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242195AbiKRPmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiKRPms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:42:48 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8154A5A6C1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 07:42:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2ABk4X31H1DfoJ5N2ITjf7x4+0nyz3IJ5MVQF+m6d1YkgjMPr70T4eMoExmRcElytTIsdsz6u3g9Y7PEOtG+jO8KUz0ldOuyjhhqZi0+7Ra0q6evpRD1LBMBD9EMxmVaWptjWKv+qNMMk+EqWmwpIOs2zKM6xho/zmPF2kHlbL17X1vPDdV/6a/Jw9I52vhqcg1T8G3u5xI3dQ9iVwuxoaD8ZSR4E+sgFMisuTYAJhEy8pvhUibyRt6lARZYGR0DqlFKuVbWSa73niYm8nYDnVdlgPx20GsDDBeL+5bwpfgnBVsrMim1u/OJXku4GlD2PrZrHDzAw2pazmX8tUjzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvJD9xN4089224W0FzAL1lYMfOQ5anDF0JEfQJWSRKs=;
 b=jdee/dOyHwx5SSjHZlxPfJ2EvkWFV76zTkZzV39uIWtr6YX+9JL+2DwN+/SFb6EUBMPRGmL/xLYeJMi+GCfXS75sGHBaQ1ZYkabyZCcuQPTaRfVMqT2e/rzAFXC6gWyLljXMa6FAYjecLnjfo9eMOS6kZz7IFiLpIOZqQY5pic/QbOArL6PYI5exrxAlqyCf3bQ1IDjmM63eVB1qIOp2SIPYcHEF8KiZDovLtPQgBqf4ik5llSXaJakaElHhnzpsKgNc/BV8mljaEtpMSSiN5ZjMu+wk0OFAUhrN/8vXNyYozkyEBau+Hnq0BtmPS84MjwT2tywpIjFaIGVSKNaj/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvJD9xN4089224W0FzAL1lYMfOQ5anDF0JEfQJWSRKs=;
 b=Ek/SNP1sn/O+LXhEeaeWFeBV01hD+iHjPgJWnUnmez6NhRlC8rk7jqd/dXkABI9yziWddmA43VZ/PLRWiaJwi276W9E/bGqd9v9VSf29kXOXcq27fY64ZKtCHMLYATO5jT0rRwbeK6UdBGyI6nBd7KhEFeIvuzE+KdBSbopDnvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PAXPR04MB8928.eurprd04.prod.outlook.com (2603:10a6:102:20f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 15:42:45 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c%6]) with mapi id 15.20.5813.020; Fri, 18 Nov 2022
 15:42:45 +0000
Date:   Fri, 18 Nov 2022 17:42:41 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 2/8] net: phylink: introduce generic method
 to query PHY in-band autoneg capability
Message-ID: <20221118154241.w52x6dhg6tydqlfm@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-3-vladimir.oltean@nxp.com>
 <4a039a07-ab73-efa3-96d5-d109438f4575@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a039a07-ab73-efa3-96d5-d109438f4575@seco.com>
X-ClientProxiedBy: AM0PR04CA0084.eurprd04.prod.outlook.com
 (2603:10a6:208:be::25) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PAXPR04MB8928:EE_
X-MS-Office365-Filtering-Correlation-Id: d90887a8-3a93-4e40-6428-08dac97b8952
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0Kop46TSLDD1+f0L+iaDbBNFuDB0CXUiwpLzCSEWDMiL8hlT0B8luJ64FMmiNX2KaPcjmYXuR++96EGVN/uT273jC3xNS3k1rNh41H89v3DoY1bVWoYxS6c04AyO4iaq6DpMNixDE6JjIb05ynxb+27Eq4tP5ZhgLAyl29FfUTk48iKqfbfLVLt4SpQ5YIdqK7WLVe+bciSIgNcFM6QvrgogxSWw681r7/4+TgRjG4P2+XFMRfMn+XDarDWipzi1rKY21jeCriLQAvq4sdesRRcfKkXPEt6SCVwX5CXe8JfVsIIcE9rAZQ08KxGofz1rq+ni6Hb1EX45BMvO4CC7zyeYhuZnkbah6gVq8uwrQdTatJvoLQOK67MsvhvlX1EeudKV2qtqh1LZZOERHVe/EecKliVor0qy3YS0hXurXYCz/KRUU9lzb23+ucMZXGPG5aP74NgyMP7238c6O46YGDZsDyx8Djl8Qdhi594TAyE+ZOeJvwU/a64SoxjujA9Gm2Ed7MDwd+avVbfeNSzCyp2ZKL+PnHOA11Bxb/kp3XHa30ygpw8S8GfekFSSa2xBFTzbiYbdNfnVJpz6QaUvDesguNVRmtll2IhEcDvrH4gebrIwwo5yjJomQcPNxZnW0kjSA+eIM4m5hAPdJw62Nt6rCEJ9wbp23kfYxzhZ76tWRvxvtMqMtM1uKV6xDNq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(478600001)(54906003)(6666004)(6486002)(6506007)(33716001)(38100700002)(66556008)(4326008)(86362001)(66946007)(9686003)(26005)(316002)(6512007)(8676002)(66476007)(6916009)(5660300002)(41300700001)(7416002)(8936002)(186003)(2906002)(44832011)(1076003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NURAbr5zKcibPuPzQ7vuJPyQKlDhZjyRiZD5iXf3maN+itrNeRrctVnRD8/u?=
 =?us-ascii?Q?Xmrw5SzFoqSCDxXXEZX7ZnYzV7ki+G68yakSM2m8DXLIattKd+0MJdANZLJ+?=
 =?us-ascii?Q?VLJld9+/V6G21IcmJwh6dSF/LkLLDNxa3rweubdynGCWITXS86n7V9O/Z4Eo?=
 =?us-ascii?Q?I9cQNy2R9w7RtZTbf5MKZRcVZWwL4S/iH1JVsadm536T0E0+ez0bdQM5E8CY?=
 =?us-ascii?Q?JqSSnrMxEAW9YwSgo6biFsi5ZMVNKHkMTTbWBDp71xwUzm/noofoiHdV0Osy?=
 =?us-ascii?Q?tMur8EQn6KvmlnjEQdD8SbPB9V7wJ4v0sektGGt2UOOgMtwD82t+M0/CSyGX?=
 =?us-ascii?Q?F9aAXAM0dt8mmxTHlYGPTNjDAIz8FO0LAIxfngoOzkslQy6D8foSvydsftTP?=
 =?us-ascii?Q?sxwHN0pN5FiWF2mEeuwRaHcKujxRnux+l6PnDy1DWr5QT3VY8KNHhhtP/Qe4?=
 =?us-ascii?Q?BI23n5S4zwLqlxO/okaiLZDDzTvDDnFPpUnqUK9zDVuxJdku0fV1zbXGIAM5?=
 =?us-ascii?Q?jqKQahT9HwNxLJUaq+r2O1yzY3HE/EEYBvgVncaii6551Asx/TGAycZUz9RI?=
 =?us-ascii?Q?HeR0rPz8Xj+qH/GAqapnF0LC+tEmLtLnHoiNDkE0DFsuHhB5I5fx+PVbd6E0?=
 =?us-ascii?Q?LU1LqgspaVgELor0m22Go177usbDCKvmZV7qx7K5EafUXTBJTiSEHAJlIgIR?=
 =?us-ascii?Q?HWBfrJD2bAFecXhrRjCA/GQ9a3c7ss8lCkHJ438KELLUqoVAKONrtjc0FAuO?=
 =?us-ascii?Q?K49yZFmtbSUVNuZGo8GMtdT5zHU8AjkTOjm4KouzNeQi3kwuk4zkVZRVhlij?=
 =?us-ascii?Q?70Dx/dNDHB1R46aLLnvqSpHo9AuG8fDjIKsjXVZl6MrQdzZE9KHZIAsiQvmW?=
 =?us-ascii?Q?TzdL7oZUxk+oiJiKbzntYZV2lvtm8CjuC42vG+/dBlpwNP5qTa4+6iCB7Fj/?=
 =?us-ascii?Q?mvQNiquymtO/xhXBbugdyREcocHfZBFp5SN0CeAUNs5nMCqq7fvSTRdH9tDH?=
 =?us-ascii?Q?BnJ79cVRExmfATYqxi2nV+/7sMqOnQWb/f10D9M1yt3bXeFFEz5wFH5Zspy5?=
 =?us-ascii?Q?GfK5BDPrRKGOmiPTBkK1leWlGrat0g0nd6s/J9a52h+VGD6FIHAhZ2BHjHdH?=
 =?us-ascii?Q?fUQATGbi7z1xvVU1bBsrEoi75+uHz/XKLz5qhgjEQz7css0gLuT00BwEQHqv?=
 =?us-ascii?Q?YVy+sUDVzIyMQRAcg/WRTaw/wDIbpZ2hLNb5eLniKTaUOCKx7A6CtESLHX4o?=
 =?us-ascii?Q?bszfsNYyFpyxp3K7nB2fzbFoyyCoY5W2ZAxUVI+ymmMR0WmsTgVqtTeOK9Ea?=
 =?us-ascii?Q?9MJV5xKa8qs6VtJEWyEyJ/RGpKVXnNpzs/vkN2A6MR+4xd+Ywc0z9EguX44t?=
 =?us-ascii?Q?te8oHOo1RuAojebgZ7Sqs+bIfcZrzSmkwexGHUD4Niv2NOAQivrPwFDFTevz?=
 =?us-ascii?Q?Opg74Xj9lVKeOdSRkrUFop9Qvf11hBF6Qm2hHzns5tsFOlwplbsqWyr1Yg8/?=
 =?us-ascii?Q?w7fZhGLaRb/r3IwNljWcIirfvC2ke0ro9GB5mVYOMFAv/qR6d3wYNqbHQfyW?=
 =?us-ascii?Q?uczRnpbRBk0OWMeyeXLCzNZEI8ruQ7qE2mzdLGOC2QTYLvFhhO99KVQTx+vE?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90887a8-3a93-4e40-6428-08dac97b8952
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 15:42:45.0259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QEMKmDO2Cw5bTgrycuM5zOWHjSEo8OsQW90A3N2uMxRS8oam5vkSldm72bSyPOKwmh4ApcPnACRchve8lK5ABw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8928
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 10:11:06AM -0500, Sean Anderson wrote:
> > +enum phy_an_inband {
> > +	PHY_AN_INBAND_UNKNOWN		= BIT(0),
> 
> Shouldn't this be something like
> 
> 	PHY_AN_INBAND_UNKNOWN		= 0,
> 
> ?

Could be 0 as well. The code explicitly tests against PHY_AN_INBAND_UNKNOWN
everywhere, so the precise value doesn't matter too much.

> What does it mean if a phy returns e.g. 0b101?

You mean PHY_AN_INBAND_ON | PHY_AN_INBAND_UNKNOWN. Well, it doesn't mean
anything, it's not a valid return code. I didn't make the code too defensive
in this regard, because I didn't see a reason for making some pieces of
code defend themselves against other pieces of code. It's a bit mask of
3 bits where not all combinations are valid. Even if PHY_AN_INBAND_UNKNOWN
was defined as 0 instead of BIT(0), it would still be just as logically
invalid to return PHY_AN_INBAND_ON | PHY_AN_INBAND_UNKNOWN, but this
would be indistinguishable in machine code from just PHY_AN_INBAND_ON.

I don't know, I don't see a practical reason to make a change here.
