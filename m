Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D61F645205
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLGC1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLGC1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:27:23 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2106.outbound.protection.outlook.com [40.107.223.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5EA4F1BF;
        Tue,  6 Dec 2022 18:27:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7+FhNOOixJlM95hKmdh62SjtAINqZy4DxZtvu5c8htW2T8iK170uxQTBhD9f3Ri/ZpILcZH197LsB4gKXFwRag5oeVrYf1XYJZ526LG+/qfJTZUCHk005WCldFXhmLsSmC8eZepslyfRSos8w47XrZj6jBS76GxjQIaii+m52/RVRU4oNyU81CbqLAyvTbxKOH0ZupRPvMU8zp2B8p4yM9XNfEXzJhTEb2gzuCcvyhEg5iCjNjcC/K/QnMJtvwCsy37LcwmgWukkaYmuGQPiQFnFLRWh6wevPj20bngqnlzAXymQTsmDSfXvfwHcSDSZQbJ54GIHwatSQCJl0goeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0a7dBbVm0OE7MYMZoII/vOGfPvowfSDlYO9kEawMeU0=;
 b=gC/CXst3qJFeuvlvjHDZRjBl8lhb3GLg5sC527OVn+z4EiIxIw0Hx1u3e9YBuAdsmRsbvWbcq+Accu66tJ7G4o33CxWoVtX8MkPumY8odD1jAUmlzV2PA38ThuuhHDOEMDBDkQtnNTMzPigwclEkLW8qlZY6gDsZMjMDyH/je4Nc7vTKlZHKqROSF8ffdhgg7V871BylVY7LWA7qxzxpPyO/xYelWvIejDP58OQVdPDqzr0/RKTaV8zBKRFCaw1/7g0ysT7osvtMVJZDrGFy7YVtxXJKFmTcVfv3ciSwugMfP0fUKBnRAHJ15kNTDrm784gJ/qvTJ5oWSmj++95RiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0a7dBbVm0OE7MYMZoII/vOGfPvowfSDlYO9kEawMeU0=;
 b=DITHAQ0VaCXcx5tqhRnJHML7k14lxdagBvxZKTz+B7DEUA+32BjlGTXDafyugn69F0ji38ALmwCplr4RbYC7n1i/yBEeH31nKyF6lBXIVCFn6LhJY0LDpbdZbYYD9eFtwDpPArNrAFAzcum9q/riORAC7f5GoQRLWT8WvhXrNkg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ1PR10MB5930.namprd10.prod.outlook.com
 (2603:10b6:a03:48b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 7 Dec
 2022 02:27:21 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.013; Wed, 7 Dec 2022
 02:27:21 +0000
Date:   Tue, 6 Dec 2022 18:27:17 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 net-next 3/9] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <Y4/6BWW+dTjR9f72@euler>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
 <20221206153734.4os4effdzlt2calg@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206153734.4os4effdzlt2calg@skbuf>
X-ClientProxiedBy: BY5PR17CA0040.namprd17.prod.outlook.com
 (2603:10b6:a03:167::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SJ1PR10MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: 82c4f830-0d8c-4d73-53cf-08dad7fa91c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EqSI3PpXig27TqOiEhh0SWJ57NJfHOyEuq7yns6JDYlN0lWKfgE2kT38R9/g5TihHyknm+UXuKTe6/LZmLtKGsdeEoDnf9J1BQ9L7j2OxoPyYxFlqJDXqbROtE9551VhH1aGtzfap2djWawaKLrGuqcOoCWFiX1e0MNiFzbiiEwiYZ/6vFQcZnnTTVAHZUy2/GTHVVN5ryPdN4u7KzLdM7nQ1/uOFTgkeSZlVlgmMCzdl1axMi0c2Sle4Zu7bKlUgTDm6a0iZ/HKW9+r21Q+7oPMzbXPPfzeAVwQFdsz3fIiK3/eq5PizLy9r4LV4k3ELogxk+xExMtJggbCwmkCmpMbS3B4aqVdQeqlJ/R60ywPrsb9CBwH4yLe8dEM76jWipZN1LspNoeWjAYGWGUFIKtC1tvHgjn9fdg1FWS3LslRqYDnXuCX3tn7s2MY9jTB9CHuq7+5L1rRblhrS2rRtV7MP0A8yKjqSiSjHzIbMWH78Y30bmes+AgdyDvPKK0JE/UQOIodi6yNHEI5ApFeV0Tn1ljkr9fm0ONZKjCpTJy5CCW0OLLUhSBys6ahPxA8muc5iRm0VXpw56wvayu690j4bwZp0G7VTHuMzNHQaD/4ft3oqMOpbnzc3BfpECdonHBLMX0L97PiwqMW6NgPGfbJqg8kDYe99Mv4k3pd3Z4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(376002)(396003)(366004)(136003)(39840400004)(451199015)(66946007)(44832011)(66556008)(66476007)(7406005)(8676002)(7416002)(5660300002)(4326008)(2906002)(8936002)(316002)(41300700001)(54906003)(6916009)(6486002)(966005)(478600001)(6666004)(9686003)(6506007)(6512007)(26005)(186003)(33716001)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eDThwzn5ELWNOttzjZ4gcV/SsgL02+wkKY7TGowUL54udWGex6XwIbal1U9U?=
 =?us-ascii?Q?vj7P4e7CsHDzbOScXGKgdAADC95OeAhnfa1AgStIB8LWMY6kfTgi710eW+4y?=
 =?us-ascii?Q?Gf2kLB9xCeylWjFHeotQL40v1QgVPTqOXP0U+Ogbogh5zLKhOtMmDjI9Hkba?=
 =?us-ascii?Q?Ls6w5GVH9n/wr9FefE8rWZOOpLHYjqko+Phs7gj1Cl0D1dC9BbPxx+tQWtyx?=
 =?us-ascii?Q?HY0Tm6QPlnNUpaJAmhaQfOcdzk/jyNkZbU3JS0uGSOFwJWgYEeh2mss3dp6P?=
 =?us-ascii?Q?RC2qzRg+cGZMQ10L4a9/ZWVDStBchEtU/UeUhQ8X6y23ChisorGAZT75H11x?=
 =?us-ascii?Q?AnLlSgLSbkTPQTIEDogBOFkoz+AAAuNKxDMM3dW0a4V9kJvfIlkvEY7N4T6t?=
 =?us-ascii?Q?Pd5rFaOVn3cZSQLiZqSWd2EKyqf1cETKZbVx6peret4l54+P4HPjyihXPztf?=
 =?us-ascii?Q?Xv2dvQiCbNb5D7jFtXPDJzYVw36LNJjlaM0i3cBZmKtAvaKoN115wpUqDlHr?=
 =?us-ascii?Q?pLQ0TQdBRDt2oEtXG2OR1FdAIsv42D4nuUYvayKmAeTZIefSThEDdCzhPHOE?=
 =?us-ascii?Q?knV/af2h+OB4h+/CGM41TkJi2BRyeRc0YnWDPUIxoNOSjInAC8pWp2uxjm9f?=
 =?us-ascii?Q?ZyENlsp2GVxAHw2ufOT04xUKmEc/UhAc80jLo8iENYYr4sB7/ymv1VhIuldJ?=
 =?us-ascii?Q?jgCu4gaWVDyZEVfGz5g662mzoU5LzS08YuvOcfZUr4/0Nc+qXR/PqhhNBGZx?=
 =?us-ascii?Q?WIZpDkqc7Ku6zI/GeWT8xtnpdTcsvm2DKvh04VOmdid+W1eY8D8mZkGs6SW2?=
 =?us-ascii?Q?xdUf+uHeRjnKNWbvKiKjgZjec5yt+va6d0m26sd03043bcck2srC8ieZojra?=
 =?us-ascii?Q?iTcNpzwZOj4wxKJxVXNqOZ2imWm1RnZvHXkWA5y+UirqCiTcvudTkiyr352B?=
 =?us-ascii?Q?p24Mc9X27AwSAvQ2co99tuA+lDpk89W4G9wu39NcmQt6tO/gAvl+AREaQzND?=
 =?us-ascii?Q?eN5AKgFmanokfJJA8zi+xf12rSvLyA6blRoHS0HAERQNa7oCPPIFZKri62KW?=
 =?us-ascii?Q?Gtm31dSZQON5fypMJqG8RZf3mYi+W7tQd9fHZCMVwwLjpdJvs80UXIlE1+Lw?=
 =?us-ascii?Q?ic3kTsk6eMMSf8GVCDdsEtOBIY8LBdUSZ6d7Ur7RMXbElRI3JKe9arO4itzK?=
 =?us-ascii?Q?HrJ/VJF/yw+GrugnmT2VBABaL3EUGKZRctcwk+s0Iu8lpKYetsCwVZLVrYLC?=
 =?us-ascii?Q?JTbzat0228bWDSTXOz/cLK+DlarBv4zYe7tHTb3DKdxLj6si2Lj4CK3DaW1S?=
 =?us-ascii?Q?DnLhmfo8Rf2ydZCMRBNRCHvRxCHceXzdVQjt7G3j/AsCMSYXKgK2haz0CnRj?=
 =?us-ascii?Q?H/eTgyZyL1+azmx9Nx0qJHYPX4mVdUPogAcJUz/fSv4rUvtAcsJcp932XsUU?=
 =?us-ascii?Q?puikKLHVIksH1EL54e9Swxm4PmfaK6TsObT1yppnrW7Eotq/dbxSMSkztDo0?=
 =?us-ascii?Q?Xt3WkhGkfFMq3o6bMTRty/AUea2bh8QF7wBl77Av9zXeqRCUcifoq2aeJuOT?=
 =?us-ascii?Q?hjK/RsoJjFlZW1VBLP6O9WFIXVIQHfCXfNs/XdJMWKhcALsyWcUF2v4xDfOD?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c4f830-0d8c-4d73-53cf-08dad7fa91c7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 02:27:21.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Djv6MN8Oi5bUM966GgFXWjs8DdkDhn42oA6nyY2V+3fLH2PnufHbrvaAa61rr3tMZXgk0UvcRsP47CM2g4yytEtq4Q/JztDfkmP0XwwE1AA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5930
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:37:34PM +0200, Vladimir Oltean wrote:
> On Fri, Dec 02, 2022 at 12:45:53PM -0800, Colin Foster wrote:
> > diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> > index 259a0c6547f3..5888e3a0169a 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> > @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
> >  title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
> >  
> >  allOf:
> > -  - $ref: dsa.yaml#
> > +  - $ref: dsa.yaml#/$defs/ethernet-ports
> >  
> >  maintainers:
> >    - George McCollister <george.mccollister@gmail.com>
> > diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > index 1219b830b1a4..5bef4128d175 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > @@ -66,7 +66,7 @@ required:
> >    - reg
> >  
> >  allOf:
> > -  - $ref: dsa.yaml#
> > +  - $ref: dsa.yaml#/$defs/ethernet-ports
> 
> I'm wondering if "ethernet-ports" is the best name for this schema.
> Not very scientific, but what about "just-standard-props"?

I have no strong opinions on this topic (except that I confused myself
when writing the commit message and it was 'base'). Anyone else care to
chime in?
