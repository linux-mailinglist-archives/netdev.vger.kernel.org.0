Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709085ED02C
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 00:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiI0WVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 18:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiI0WU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 18:20:57 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2139.outbound.protection.outlook.com [40.107.237.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1C51CE93B;
        Tue, 27 Sep 2022 15:20:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeqcaCmVRnRG5RQp0LoieYHSk7Bmre3YCMDn2CN5Q+hMS0xY6eAdRLJsPIqfqYH01QZeGsOv26OIyr3+Vn7beED9WNLRhRIczXbOwAQ7iY06nfsWhvNAoesQIRGMvV1AA2el2otIKdZMENTkb2t9LnKsmOZ3pNDiJ0WAmYNyhDbDh1hS4ZDShn2q2uF8kqVNwyUnwzxtCszh3PDrIVSuJCDzjjoL0E0V2QNru+r9ARl83GR0U1VmvThiRfUk/soNLXdUaUeDDRHc+VMDMn7odF7Ys0Ak2G8T+0kFPmuYlm5/Kl9WfPJ8w/A1qosvt8Mslps+lWZwj3ssC0nGsaPhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IokLYMoHevv4kqNbEqW6P0g1MFMsu/JPV3zrGvrAMRk=;
 b=Bc/GNsQKIritbTFFlaV5LXF84naCR1miSMNHxb0mPbrhaG4yJTtyv8PnoKRJoaxZQCzfNfnCISOq68UxRy0Yo21gaBvry4U9cSoi5a2kz/4Cc20FRQ8C35gA7cHlPiAf1XxloeyGq+P2NNvJ5jawrWXKt8maOeuk1BJWZn5sxzH2PxZqS49c86XPKZkfFLHTU3ClSnPEV5lz9R/PO+K5dXmEAhbqHujoA9G8mr82GzHiobKccTaTLelLztF7gkMF0GTsQYmJXBt6520tQJugje30oRCmDjEp2bVaBT3AH1M6RhmMHjEgFm32v3mbgfwn9tzHHD6cKsYSpY+PfdsEUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IokLYMoHevv4kqNbEqW6P0g1MFMsu/JPV3zrGvrAMRk=;
 b=m/Bj4M5o2456iTXLsA9P+/T6DXHTBSCtxnwKLr0yBKOgE2ga46n7551vreABLmpKVnPiuddR2lfN9CrkZAVRWICuP4yYdfFhBQF/q/DjtLTFLqYuuKBF6nr6v0c0xi8CXBsNXUob/P1RZi7rdGZ7GMj64BPy4UX7UNJIPVzmr2Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Tue, 27 Sep
 2022 22:20:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b417:2ac7:1925:8f69%4]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 22:20:51 +0000
Date:   Tue, 27 Sep 2022 15:20:47 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
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
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <YzN3P6NaDhjA1Qrk@colin-ia-desktop>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
X-ClientProxiedBy: MW2PR2101CA0011.namprd21.prod.outlook.com
 (2603:10b6:302:1::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b5f0d39-e180-4f7b-4c0f-08daa0d68928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WAx4hBsex2y0BQQ1W0sFwk58Dls1a+pwFryLO+qI7w5HgC35aaiSaissyt0hWP5lHuZNhMlmcqDuWTx1oxM3usNQmqF3brI+FC7r5p51delo9bwagUMjTaTtY70f6qwdcfU+gMzDz7G3XDIHySeHHhtpOkTs3GVF0jxBEPNJaj5rM6UErZa2EJnrle1x1YJGtjzqobAzLpP1Fyywm4oZnP0U3BpU3KL7WpZ6DkQxH7GkBuVWntflzrieRSqUx9lxEGpXYr6lu0BSnhDvC6QEJmzSOSb5B43g+C31yHjsXGdBUWGgARqnlq/P3vAdHv8TABtIaUzbxy2HD+vAd8XN/jSVktJckG+Nh/5TPwOVOGNNCUlmt9p3osWMdpJIai4TX57CKX703x1ztn0+HAnTUTmcymXhDbu9CrqdaQSo5LSSCVqUv1DpM1nLSOUXO93BQYo+ylE+LkYPROiiQSEHJsRQctVVS5xSdFV4C7QWoO22KIKUO2B1B7p7mgSHp3uW4gTBkkLRrDxA8dVmYUpBCEyMVSqkzjToHS513qnNbiKDH24pluLsrLXFijlu+c2RBkIZEfqO7Qg0zj2VujH6EsKarVT3BLx0vKjEmTok1+O65K6nW35fDDvpx8d/qmJSC+3EaOY3ZsR/f2UiyfskMgr0QoqStgqHtuOirroY0ZP47OJuU5QwugWNwKFycZ0FkVYPzZNOxb9SJZU5WXJ9iaZvA88OWdEe4ME+qCE/6vU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39840400004)(346002)(136003)(376002)(396003)(366004)(451199015)(66946007)(86362001)(44832011)(38100700002)(2906002)(9686003)(6512007)(966005)(33716001)(6486002)(478600001)(6916009)(54906003)(26005)(8936002)(7416002)(5660300002)(41300700001)(66476007)(6666004)(83380400001)(4326008)(6506007)(66556008)(186003)(8676002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vFWA2yyyyp1uy5LUKNwCDv0uj0iSZLNHVQwr40tKrJxCF+rz+09JMrgqeVUH?=
 =?us-ascii?Q?4jR/dzOD1+MGUgGFWnTce5p+AAPO91XhpqMRNBhWEDgvM6Z8z5DMvLOpeNC7?=
 =?us-ascii?Q?9Nbb62iRq37UhQkwq5m6eXjDfXFXGV8UQqqmXzt0I8/Kqo++wQRZmRth4DSb?=
 =?us-ascii?Q?M92zFM9W4GwTg42UqEgj5/tAznANSBX2w50+X/cAK5MPdQ/PgRPio34cgZpt?=
 =?us-ascii?Q?SXH3hGDQxeubAjJ7wpSmDfaNdJ3TKO7VW6cqvrATVeJnSA6tDMRTQRZwkIZq?=
 =?us-ascii?Q?sReSoa/dtKI4lkRfinyiFEOz5y/FOiXsLcFNUkahd6fcQ7cnti6VYAWONHQU?=
 =?us-ascii?Q?i38gpGtqQnVvzmplCLu3GGpCgOQsXrUR84LPdQHHdomLtCM3bixytCxu6gNi?=
 =?us-ascii?Q?FgjlC1oUTZELLRjSeZau+vedPZiF76q9KJa9zvoaC9dyVcNKRiLuWKwlLXj1?=
 =?us-ascii?Q?WHCMmlEUbZ1OgUHcd5LeBas+Zs4l6ZMmldCExxmNu3GfMG6Z3lzNlta8jl7N?=
 =?us-ascii?Q?12Z9CyWeI3/QeTWDz7Lske0wMxhn5cipfvJ95Ja0Juc2rirFtiB0cA3AQJ8/?=
 =?us-ascii?Q?8XDB8bP0OhD+y4sSBAsrEz1ASl6OrRmjWxuPMhj2UZI9QD0bDtHc0PD7fSfn?=
 =?us-ascii?Q?31qatqWkhQAhsWi3mzRxgiu8gdHB/ooaMInG7UxjqK8wax906mQJYMifWXgu?=
 =?us-ascii?Q?KIS4uBErk2q+FwCTnLRQgnekmqbMU8mLTx5Ij6Wofhl5FJqNOkakpcBuxtJG?=
 =?us-ascii?Q?eslNvuPrXgcyzPuNuTakbRXlsX9NlGsamQbgzEliWiud2Xvod5Cpb03xm1H0?=
 =?us-ascii?Q?Ezje8M//QWc2P2RoGHPAj0ODDPQHU0+fpOU8eU4z0oZUWMbDVkGTYppa8vJh?=
 =?us-ascii?Q?bM6PttAe82D7U67xQFCncNg8H/fFECY32lbzeMDl9yEaNnCqLXDbKLtX7QED?=
 =?us-ascii?Q?dimwr5Q9OaBsnTB2zY0TyK8A9S/HACftN2FQHMHOzoJKjM+7JDIFjcmHa+c+?=
 =?us-ascii?Q?4jAsQBfEe6VOsID6442DqPi3pvldfjOnBOiV+UtiUU9v2DYlucAPFG6e6WO+?=
 =?us-ascii?Q?79u3Sk7cQo1iTqKyOdPCNCwqjyDpdGERrc4J5KyMlvXm+ambL3hlBvxinzMJ?=
 =?us-ascii?Q?VCqkO+WBbuUQOcmROHwJyg9yqHgK1W4mc5Qx34xDkgxI4vLrbAxW0OjSK2Ne?=
 =?us-ascii?Q?oLGqznLhffmgLl9g7ODEeVeW4L3oY2gOxhuywFfiCfS/QOsNDoRwIpUsyGdl?=
 =?us-ascii?Q?76Fsv76Awi7yGCuONqudzZG7/ToWNXg0f9Gv28yUxOba2+oFO01gAepeou6z?=
 =?us-ascii?Q?H5lQFGq89tyFud4v6HhY0lgM+Gf/wgaQ4mNKa7nJnRJVS4LiJKY/qSrno9op?=
 =?us-ascii?Q?rOToNIxuGETV0GSk4rJ4DuFayc0DtUJWLhGqt0MX3FnhfB0HwL00OLnqD46e?=
 =?us-ascii?Q?tnbXjStWEzrbWkoI6TI2ycHjieqgtBdmniEQ/pBPM2L8YgEJD3R9AQDd/eV8?=
 =?us-ascii?Q?4yDPywHaflXCOurVQfsB/CRVy1deTjTECP+fCjSVbt5/D/5IhGK0uI/Nc6WM?=
 =?us-ascii?Q?pFG0yZScU+amPzRNfV/5ESiDpUTzV1qrU174n8RykjJhSrG9GINAZOVikMBH?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5f0d39-e180-4f7b-4c0f-08daa0d68928
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 22:20:51.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cu2fa7phfFxtyUvo23d6/9tFFY7J7P9+hdUVlmAa1ne1pTzhLTmSUW5h9bKxEgf/wx+kSDu++vbyTWGEgOppQdau0oRgptKagM25okeGAFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:26:00PM +0300, Vladimir Oltean wrote:
> On Sun, Sep 25, 2022 at 05:29:26PM -0700, Colin Foster wrote:
> > ---
> >  .../bindings/net/dsa/mscc,ocelot.yaml         | 59 +++++++++++++++++++
> >  1 file changed, 59 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> > index 8d93ed9c172c..49450a04e589 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> > @@ -54,9 +54,22 @@ description: |
> >        - phy-mode = "1000base-x": on ports 0, 1, 2, 3
> >        - phy-mode = "2500base-x": on ports 0, 1, 2, 3
> >  
> > +  VSC7412 (Ocelot-Ext):
> 
> VSC7512

Oops. Thanks.

> 
> > +
> > +    The Ocelot family consists of four devices, the VSC7511, VSC7512, VSC7513,
> > +    and the VSC7514. The VSC7513 and VSC7514 both have an internal MIPS
> > +    processor that natively support Linux. Additionally, all four devices
> > +    support control over external interfaces, SPI and PCIe. The Ocelot-Ext
> > +    driver is for the external control portion.
> > +
> > +    The following PHY interface types are supported:
> > +
> > +      - phy-mode = "internal": on ports 0, 1, 2, 3
> 
> More PHY interface types are supported. Please document them all.
> It doesn't matter what the driver supports. Drivers and device tree
> blobs should be able to have different lifetimes. A driver which doesn't
> support the SERDES ports should work with a device tree that defines
> them, and a driver that supports the SERDES ports should work with a
> device tree that doesn't.
> 
> Similar for the other stuff which isn't documented (interrupts, SERDES
> PHY handles etc). Since there is already an example with vsc7514, you
> know how they need to look, even if they don't work yet on your
> hardware, no?

Understood. My concern was "oh, all these ports are supported in the
documentation, so they must work" when in actuality they won't. But I
understand DTB compatibility.

This is the same thing Krzysztof was saying as well I belive. I'll
update for v4, with apologies.

> 
> > +
> >  properties:
> >    compatible:
> >      enum:
> > +      - mscc,vsc7512-switch
> >        - mscc,vsc9953-switch
> >        - pci1957,eef0
> >  
> > @@ -258,3 +271,49 @@ examples:
> >              };
> >          };
> >      };
> > +  # Ocelot-ext VSC7512
> > +  - |
> > +    spi {
> > +        soc@0 {
> > +            compatible = "mscc,vsc7512";
> > +            #address-cells = <1>;
> > +            #size-cells = <1>;
> > +
> > +            ethernet-switch@0 {
> > +                compatible = "mscc,vsc7512-switch";
> > +                reg = <0 0>;
> 
> What is the idea behind reg = <0 0> here? I would expect this driver to
> follow the same conventions as Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml.
> The hardware is mostly the same, so the switch portion of the DT bindings
> should be mostly plug and play between the switchdev and the DSA variant.
> So you can pick the "sys" target as the one giving the address of the
> node, and define all targets via "reg" and "reg-names" here.
> 
> Like so:
> 
>       reg = <0x71010000 0x00010000>,
>             <0x71030000 0x00010000>,
>             <0x71080000 0x00000100>,
>             <0x710e0000 0x00010000>,
>             <0x711e0000 0x00000100>,
>             <0x711f0000 0x00000100>,
>             <0x71200000 0x00000100>,
>             <0x71210000 0x00000100>,
>             <0x71220000 0x00000100>,
>             <0x71230000 0x00000100>,
>             <0x71240000 0x00000100>,
>             <0x71250000 0x00000100>,
>             <0x71260000 0x00000100>,
>             <0x71270000 0x00000100>,
>             <0x71280000 0x00000100>,
>             <0x71800000 0x00080000>,
>             <0x71880000 0x00010000>,
>             <0x71040000 0x00010000>,
>             <0x71050000 0x00010000>,
>             <0x71060000 0x00010000>;
>       reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
>             "port2", "port3", "port4", "port5", "port6",
>             "port7", "port8", "port9", "port10", "qsys",
>             "ana", "s0", "s1", "s2";
> 
> The mfd driver can use these resources or can choose to ignore them, but
> I don't see a reason why the dt-bindings should diverge from vsc7514,
> its closest cousin.

This one I can answer. (from November 2021). Also I'm not saying that my
interpretation is correct. Historically when there are things up for
interpretation, I choose the incorrect path. (case in point... the other
part of this email)

https://patchwork.kernel.org/project/netdevbpf/patch/20211125201301.3748513-4-colin.foster@in-advantage.com/#24620755

'''
The thing with putting the targets in the device tree is that you're
inflicting yourself unnecessary pain. Take a look at
Documentation/devicetree/bindings/net/mscc-ocelot.txt, and notice that
they mark the "ptp" target as optional because it wasn't needed when
they first published the device tree, and now they need to maintain
compatibility with those old blobs. To me that is one of the sillier
reasons why you would not support PTP, because you don't know where your
registers are. And that document is not even up to date, it hasn't been
updated when VCAP ES0, IS1, IS2 were added. I don't think that Horatiu
even bothered to maintain backwards compatibility when he initially
added tc-flower offload for VCAP IS2, and as a result, I did not bother
either when extending it for the S0 and S1 targets. At some point
afterwards, the Microchip people even stopped complaining and just went
along with it. (the story is pretty much told from memory, I'm sorry if
I mixed up some facts). It's pretty messy, and that's what you get for
creating these micro-maps of registers spread through the guts of the
SoC and then a separate reg-name for each. When we worked on the device
tree for LS1028A and then T1040, it was very much a conscious decision
for the driver to have a single, big register map and split it up pretty
much in whichever way it wants to. In fact I think we wouldn't be
having the discussion about how to split things right now if we didn't
have that flexibility.
'''

I'm happy to go any way. The two that make the most sense might be:

micro-maps to make the VSC7512 "switch" portion match the VSC7514. The
ethernet switch portion might still have to ignore these...

A 'mega-map' that would also be ignored by the switch. It would be less
arbitrary than the <0 0> that I went with. Maybe something like
<0x70000000 0x02000000> to at least point to some valid region.

> 
> > +
> > +                ethernet-ports {
> > +                    #address-cells = <1>;
> > +                    #size-cells = <0>;
> > +
> > +                    port@0 {
> > +                        reg = <0>;
> > +                        label = "cpu";
> 
> label = "cpu" is not used, please remove.

Will do. This sounds familiar, so I'm sorry if it fell through the
cracks.

