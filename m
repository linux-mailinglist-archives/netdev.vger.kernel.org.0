Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833FA63B809
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiK2Cfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiK2Cfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:35:30 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392A24AF0C;
        Mon, 28 Nov 2022 18:35:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bd/Qu3Pc+D8kLjyCXdz5p4yuPpvM3bRDCAKQ3/lTeZwn+sMbPDMHvByTYt8DAhkrY/K8KcjpBatj1FrJXptst+auSVhavJKsj6P7RC7bHowD9XMxtVp+ntLhvsaO59iZQy3+wVyqhPyMRiF8YR9j2n71fLCe0paXZ1xn19WiO37uisQC6QBMfPbXUHxq6N0pbcEix/s4MRg5QOpSDpuC2pl3/fmWvcz/HG17wlog5jNPiyRobIw5uCvzGg86f0vd+3gd2nYoDL6eGEj0TVgWpRpFxMupNnn7SPD78NfNradXOaRvw0l8GaAzsvaDSLlL7nNaOY1kH64WYSmHk4GrBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjqRvSoyRe8qY0tEik/RzKHxMAP5klF9EJ1punOwvVU=;
 b=GdN2eoxo4kdcBfQncDXuEXrtwsmQ6wHx+iBThUZR/7Ch6u78o6MKPW7mdBR+ZyKY50DGruhnG5hJQRR33Y7sSId9l7UiK5tu9Y5M58ImFG6ifoyNSckRiHoolMDZhitlj/pLdI16kPA15j9XCZ5M70N31RQX/kVKiFHezyA/ZfLImsDlJFYLgvEk+oMYWTXhSck1TjRBpVONXD1UBZNnNQII7QLakRmdaRi+QRVRULhupVcNWTtlSaFZ5JZPRaYsiar199vKqti2yOeLEydKyxqVwKLVBp3TZMEAgqHsqXpJcuBJkD3CpV2MuU3o81DufRPU7WKAEocN/fM3fsNj2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjqRvSoyRe8qY0tEik/RzKHxMAP5klF9EJ1punOwvVU=;
 b=oYVsGQ3F+Gd9l40cIb+mtfGCeEpOIYfmY0RYknLrMmsLppArajg7X2VWyMu5n+k19+3nkai6hZ6xnb308gKnLkxYG8RsxaeqWGdYoX10YjhnK/BLD8OwFyJ60kw+VYuKbMVE63lSdDpPJj+8egkPPxNe28pZuvue3RT+Nd85scc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6617.namprd10.prod.outlook.com
 (2603:10b6:806:2ac::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 02:34:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 02:34:56 +0000
Date:   Tue, 29 Nov 2022 01:34:52 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
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
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v3 net-next 03/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <Y4XSPMMDgiFipdIW@COLIN-DESKTOP1.localdomain>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-4-colin.foster@in-advantage.com>
 <20221128232337.GA1513198-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128232337.GA1513198-robh@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SN7PR10MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 698dfc62-9a53-4bc7-3558-08dad1b24d85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ekAKDEHlsi54g2ceqi1vk0ZG7DDT/LwT2cuQmMUURuwzo1YeLn5QIxOsUS3ubzyZ9oUKzovrBYdeDboI+PkfkDTZd3bubZevY6OzeDuGehaQNOhjIPqJJug5+zpeX/7EMcKcXvMU5n1eANb2PazFO8KLKDSnit085ibVTU1dr8dxs/LwE1iPARiNV4soqh7WOVO0oR87zj1PCayxC+b0m3tm+rGv3SjfLSekg6b6N3LU+vVgKBg0MkaTp1l81Y4PvcBDvZy/n+lRgzu80i0bOyHK0XKuirtSBrO0Ya2Lo3LY4qCGpoflFyQuLdtsTqb5CIA6yp234UfH7ZMoUXnjz2sWMu+PkSnJthJOArH0gvNcKXu05PE+2/o2eHN1siI5dgqjG0CwoK+cerEF9kssilAKqLWepWctoHp9AMMCJdvLuEDM4q3sA7KVDD1/Q00ANMqdwM88Bgi5f1p76X5P9FHeNSDyKIIAjuJahiqJeEE9OtQMZtS7Qb1xZGvhGONZ094tMnjF6eHO96xz42WIabvFtMlmkYmt/fUcWiGtjJD6GzE+Z+gcwYIyEE8MgAFyhSI8ZLOyW0xFBzNCtLxi+To/HZXMdH+pi9E74ylSDLCEC7krMce988ksqd+dAM3HGOmpuY6swgjdyEixHklo6jt/XTmUR3Ycc6jEYpgafKE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(346002)(136003)(39840400004)(451199015)(86362001)(316002)(41300700001)(5660300002)(83380400001)(54906003)(66946007)(8676002)(66556008)(4326008)(26005)(6506007)(6512007)(66476007)(9686003)(6666004)(478600001)(186003)(6486002)(966005)(6916009)(7416002)(7406005)(8936002)(44832011)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R9Hx9EKAt+nCE19UqSuzSZdIjkfKwUIuV6uUxMVomFfn/QZ/QxxPOyyTWhB9?=
 =?us-ascii?Q?NQKnVgX/WEbRsXRg+nEBJDvO0Nhi62zefWIm2SCrTgKxb6BflmTgGzk7VFkI?=
 =?us-ascii?Q?vhJTkGpIa8S+Aq4fLFOSUhgIYpViRBnwDQKBNwEAqKq8ummtJvNdH23E4bGV?=
 =?us-ascii?Q?BdmxXEf8j7p/NLD/hIT91tYN43L2A1INKkApA9bAv+NUyc6wgrlgm1GXqw/5?=
 =?us-ascii?Q?2EbpF62UPEVavfybDoygQLT8fhbt9vm9yMnmU4uBxNSO/XOygNy5dLqK6L3U?=
 =?us-ascii?Q?lr2JF8TPHPImBewNIAwoiEw8PhOQLjZU1/FCRkLv/XxedO7cZLpfPYA1o/lp?=
 =?us-ascii?Q?YbxMiQUd5MR3jauHDUK8dHjA7MyNW1Juv2/42g74AZAtSgRdwmwh4aG1uN/j?=
 =?us-ascii?Q?yy3ENegWrhWWHW0hKGcX7pLgX4xyk1mpd7d5puZ4/BsMlowrJVnCA5vw/gz5?=
 =?us-ascii?Q?9AM/tB1bRsBwj0HrvbTDDgyWHaRvdjqEUY7fi7WPnytQ7RFxDQloCHEboLxz?=
 =?us-ascii?Q?i+jJNdRVIuRG4eT6GJhbBKHByieXiFvDLlpMokaVD3f26PCYcSkY8nk4Z+Si?=
 =?us-ascii?Q?9UE3TorQxwxqCSudUdJYkYUKpHQj/u5PJ2eR0UNGqrZJHEFb5/g5qwSfQbUo?=
 =?us-ascii?Q?Z3s7zYrXr7dtx4bfQ8ONWiqBZ7ajsoXO5WXVOchhs3ukFBjO7bGFVq5pVncH?=
 =?us-ascii?Q?1PSOgftUjnXm+v8IMDCrc9HnKFhU0/7gpoYoKlo6LkbS+AGoF5cWRpFFv0CF?=
 =?us-ascii?Q?RYRY4OPnV396kjdX5DYcJ5Gozf4ItTCqOXd6IAv+FZRoy5/uKsvoG115YRiL?=
 =?us-ascii?Q?/6tfKpuqipm1+N7qtTC2DgMU3JETeViCIqXth80ir6EjCmpgQg89E+jqK2RK?=
 =?us-ascii?Q?x2t7KPa4oJV/drgIsUwDzxepNK8WyWO+rtWtlO7fFwSbAuetn7jlP303laHc?=
 =?us-ascii?Q?6joURLl/BRsphQFH6itRyL0E7C8xvTSObyhy0wqH6soJPgqI0Kd95WPkwWbw?=
 =?us-ascii?Q?/9WkLsLulODwRab1UN2ZMVpr9qSgDQ9vQZH1TA/WoS3N7AHmBtPUGS2GDs1M?=
 =?us-ascii?Q?lOn5WuWmgMT06O+wh2kqDJPxcVJEN4vFteD9AmkSCGepu76OYrWae4vY3F8o?=
 =?us-ascii?Q?hOCBMsMFxJUgDov93DwjJx3AiqRVWS8iuzj65pk4Bb8ZGect1FO1A4HWsycn?=
 =?us-ascii?Q?CIIijhgE5wLkvzVpqLkGohdh3AkC1HGfVaAFX37DL+30eTRrl8O+0GXhoE7D?=
 =?us-ascii?Q?Bj3aYzKFJJduvEF2qQlneyZ1dGFCWLyLAgALXmQTvi3Rz+ZXSHs7lVr3Uc0O?=
 =?us-ascii?Q?W9qcZsOJhUhhfQky+4DxfdBajTEgp/tAUTzguu1UxrJQDJbwRNhBP9D2Hpmb?=
 =?us-ascii?Q?krHWlj/lYCPNzt3ptMJ2VYBtRkJhNEGeL0sr9sqyYTgDew5CbuPCL+YR5dWC?=
 =?us-ascii?Q?6Yezb9rWCqKfwB7J41gfoK1oxteID3XEmpflnm9FLckf/EtvL7GC04xzROYf?=
 =?us-ascii?Q?p0qCa2nm3o14wQ7tNcO1nGNUJftlspycKH5uRF9qNiLUnHqHMQdzIAOTa854?=
 =?us-ascii?Q?EUf/xcJoNaZ00Prmb2i1/6deXVax3AoC9aFyDLMWQ/4HHmMwG5b3sC/R+3mc?=
 =?us-ascii?Q?WLLrQ3ONH//9dmqz0ohPGBU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 698dfc62-9a53-4bc7-3558-08dad1b24d85
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 02:34:56.3493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oY3YZJTJEpC/FeXaGlz34yaCdqgLlFVWF08ifyEDVHCt8ps57gRZ1k/RAcEYx39jL3hkujESKtSH/LU6DBiRt2jK6PMrGABvCdCA6KWH14s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6617
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Mon, Nov 28, 2022 at 05:23:37PM -0600, Rob Herring wrote:
> On Sun, Nov 27, 2022 at 02:47:27PM -0800, Colin Foster wrote:
> > DSA switches can fall into one of two categories: switches where all ports
> > follow standard '(ethernet-)?port' properties, and switches that have
> > additional properties for the ports.
> > 
> > The scenario where DSA ports are all standardized can be handled by
> > swtiches with a reference to 'dsa.yaml#'.
> > 
> > The scenario where DSA ports require additional properties can reference
> > the new '$dsa.yaml#/$defs/base'. This will allow switches to reference
> > these base defitions of the DSA switch, but add additional properties under
> > the port nodes.
> 
> You have this backwards. '$dsa.yaml#/$defs/base' can't be extended. 
> Perhaps '$defs/ethernet-ports' would be a better name.

Oops. I'll fix this up for next set.

> 
> > 
> > Suggested-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> > 
> > v3
> >   * New patch
> > 
> > ---
> >  .../bindings/net/dsa/arrow,xrs700x.yaml       |  2 +-
> >  .../devicetree/bindings/net/dsa/brcm,b53.yaml |  2 +-
> >  .../devicetree/bindings/net/dsa/dsa.yaml      | 19 ++++++++++++++++---
> >  .../net/dsa/hirschmann,hellcreek.yaml         |  2 +-
> >  .../bindings/net/dsa/mediatek,mt7530.yaml     |  2 +-
> >  .../bindings/net/dsa/microchip,ksz.yaml       |  2 +-
> >  .../bindings/net/dsa/microchip,lan937x.yaml   |  2 +-
> >  .../bindings/net/dsa/mscc,ocelot.yaml         |  2 +-
> >  .../bindings/net/dsa/nxp,sja1105.yaml         |  2 +-
> >  .../devicetree/bindings/net/dsa/realtek.yaml  |  2 +-
> >  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |  2 +-
> >  11 files changed, 26 insertions(+), 13 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> > index 259a0c6547f3..8d5abb05abdf 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> > @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
> >  title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
> >  
> >  allOf:
> > -  - $ref: dsa.yaml#
> > +  - $ref: dsa.yaml#/$defs/base
> >  
> >  maintainers:
> >    - George McCollister <george.mccollister@gmail.com>
> > diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > index 1219b830b1a4..f323fc01b224 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> > @@ -66,7 +66,7 @@ required:
> >    - reg
> >  
> >  allOf:
> > -  - $ref: dsa.yaml#
> > +  - $ref: dsa.yaml#/$defs/base
> >    - if:
> >        properties:
> >          compatible:
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > index b9d48e357e77..bd1f0f7c14a8 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -19,9 +19,6 @@ description:
> >  select: false
> >  
> >  properties:
> > -  $nodename:
> > -    pattern: "^(ethernet-)?switch(@.*)?$"
> > -
> >    dsa,member:
> >      minItems: 2
> >      maxItems: 2
> > @@ -58,4 +55,20 @@ oneOf:
> >  
> >  additionalProperties: true
> >  
> > +$defs:
> > +  base:
> > +    description: A DSA switch without any extra port properties
> > +    $ref: '#/'
> > +
> > +    patternProperties:
> > +      "^(ethernet-)?ports$":
> 
> This node at the top level needs 'additionalProperties: false' assuming 
> we don't allow extra properties in 'ports' nodes. If we do, then we'll 
> need to be able to reference the 'ports' schema to extend it like is 
> done with dsa-ports.yaml.

I'll double check if there's anything that adds any properties. If there
is, would that be a separate file pair: "dsa-ports.yaml" and
"ethernet-switch-ports.yaml"? Or do you think that could be contained in
the existing dsa.yaml, ethernet-switch.yaml?

> 
> > +        type: object
> > +
> > +        patternProperties:
> > +          "^(ethernet-)?ports@[0-9]+$":
> > +            description: Ethernet switch ports
> > +            $ref: dsa-port.yaml#
> > +            unevaluatedProperties: false
> > +
> > +
> 
> One blank line.

Oops again. Thanks for spotting this and for all your help on this!

> 
> >  ...
