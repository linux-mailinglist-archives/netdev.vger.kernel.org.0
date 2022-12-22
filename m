Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBE86544FF
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiLVQSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiLVQSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:18:15 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2058.outbound.protection.outlook.com [40.107.20.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6972228B;
        Thu, 22 Dec 2022 08:18:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xecsh/3LC6RQHOkxCNXKpv8K2o/V6qoa22qOgHx6g3Yywj+Mx8Nnht49s236i+aD1pb1js+Sux/ptnAsnbymctPhjCh8E/Les9NSvIRkvm30f6i4NoyQXbGxWX8/xlJuHJRcUtILH6yf3I0wMfyunhSUNu1pAubb1V52E8qnr1z5ZsYxxOfEdppmRDjOYd0TZZHS/Pov+8KWBGPbz047DUwp4snwq57bqX0uTsnvCxf8i8l4bYWaciDL7gn7deIrvx3Lr165AC+mpzhphrP5sIJ+AbZ2yhnaflgIVeYK4wrR94SlwS31GizTLyrjrGf6XFOsTR3BrJiSt6Ixu7uyqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AngS1GlVvxZqsaWQ36UrUcTz81dvr0WDqS4ErYqoNO8=;
 b=ZxSN5yC+0eBecweyu1sBnqmxc9ijD1TDuVOGSRdXTQ2qKVKdORbZMf0xdmbwKv5WIfXjgUBGlNpEapMuuHs1c9UQwPZDLLapOPtWuD9uffmPVszmGSOZNWdvdWLgYLSkRDPEFtOqADle5dJ2w9dLElQX1IwUbAyHQ1cJBM2cWx7IQk9nnYwPCRP1txhZiuDPTR4raxaVjwdjYj1mt4OYaLIgmPILs4BJGpNF/Q6o+lRQuApbYMb6n6qSEL4JGj5sAcR4zJhSGLDClrg4KsD+wUVjAqYW1xmHf2ASEssb0ljBNrt1e+5LctZs/UtB1YLGeEHFkWbiLxM7y/IF+u6RBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AngS1GlVvxZqsaWQ36UrUcTz81dvr0WDqS4ErYqoNO8=;
 b=o/oqKiQ+eCLQCR+JdoLgUWBgiYyhkyore4BQEtQ53V0MtTjYXfeNYbNHJ0TgYiWRgXAsY2+QF0S58MPIrfyQX3N7YIi9ylMhlc9RAgMQ0onPecHay99Vnd8UDX9klL+qJyatnPuySXuGBLayBlWwp+8NjZBAZn1XsEuSLGjM+y4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8431.eurprd04.prod.outlook.com (2603:10a6:10:24e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.12; Thu, 22 Dec
 2022 16:18:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::7c13:ef9:b52f:47d8]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::7c13:ef9:b52f:47d8%6]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 16:18:10 +0000
Date:   Thu, 22 Dec 2022 18:18:06 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Advice on MFD-style probing of DSA switch SoCs
Message-ID: <20221222161806.mhqsr2ot64v34al2@skbuf>
References: <20221222134844.lbzyx5hz7z5n763n@skbuf>
 <Y6Rq8+wYpDkGGbYs@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6Rq8+wYpDkGGbYs@lunn.ch>
X-ClientProxiedBy: AM8P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c8d0e42-b7da-4518-3bd4-08dae4381e37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5wPuu2X8SIrnWFDYOAzbKO2qXAZOSFCsYizefa4fhZIci8dD8Suv0BY+LBcUiBNcZa0axt4MPYN77gtrGkoRROEgQmbYkmg04QncVJYwWqBxQh9Q2GNhAzJp6+L8gVg7bsDkjUXKciYRVV0V2clAUjRY5ZP0GfZK6fVUBtYK5hm6arKFdgunn2C4hOi8Vzw+R8GwWhmaOJLEPdI9hgtxuD8mocOFOm5NFAw3P8ryA2YT/30gYztwD4JS6Ns7A7IifGmr1hZNktryiOCCSaj9K1yCfdBmZ0hGQFd7WmjuXJEACYQBfZFCFSyAjSuhX+y7jbTy4Jak4/aFMCEw2OfNYwDNBLU13a+FVJElWAmQm4UbT9hu9E0Wm/8gz6NSmfeLHX3xM+KVF4Yu0MBxqnbSeE8+N3RpljxQPsrSDH8o0C+f//tBoIQbVduJHOIXJwqN6s2uPN4YE49+T0awr/A3SEv15IRgOdfzC9KFOpNKG1RUJr2AiWLb1yaWrOYt7ivPoHrKn5NmwJNYAiW4mR1K/X3O18vDDmmP+JkYMb9pugYAKM+HuUTqRqu5bTnvt8Z9Mpse6FC9dFzsd5yqIbHeAYI7ay9ZjmJBi3eNJvR4Sd5w/9nn2T7xSfeizceFWz5vaPWCBZGhqiG/6o/OKA4IJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(6029001)(7916004)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199015)(38100700002)(2906002)(41300700001)(86362001)(26005)(6512007)(9686003)(186003)(316002)(33716001)(5660300002)(8936002)(66476007)(7416002)(1076003)(83380400001)(4326008)(8676002)(66556008)(66946007)(44832011)(478600001)(6916009)(6666004)(6506007)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?egaoiopmOQJDtDV6FE0I3+iLvm/NKQlm8m9IVJd6NWmoNx5s+44J0+qGRwvC?=
 =?us-ascii?Q?WDIFCVzB5leyeHsJHfcLaUlpC7eZK8CjjDhfkT4gB2runeZ4J51XHJs8Di8A?=
 =?us-ascii?Q?VmG/UZeLvBLdqviJknquzfoNMbCFzTpsZv6geguwpjwj2QRNLB/lszW+Pvxe?=
 =?us-ascii?Q?nHiQuApZ7uP0+at8y319DxnefBroWVTg00+OKg2S7df5HdZC6XQpErZ0DXbc?=
 =?us-ascii?Q?mS0aZfKFEXgSTpuz9lMc3eJb15S2dnnyBtLnO5EA0h4lFBDhOv6uj3ySouDb?=
 =?us-ascii?Q?IdXrqx4m062ijIGvlpC881UZOIpSRfC/Dq70r0ib++7HVmQ7ltRnwcI3lEHV?=
 =?us-ascii?Q?YNk93HiEa8eK+j3FSnUSqmSm9xFgbaNsADGqKBH6QEwnx6ymxAt0Ur08scNE?=
 =?us-ascii?Q?lZjwBS/+4Q5f3EaMgqXQ1+t9R9+ApRYyCcd6mInvj1wf9LY+9p3JZAKYmsyG?=
 =?us-ascii?Q?+cWBZQXKlQB8/FD5JCaSz/lAa4pXat9XXnuSxMmnWjWe9cF+hiLIrTM2ySCl?=
 =?us-ascii?Q?eeTrE7f7yJk6vXSwfDUqlulHf0NtwTcAw6Dq3Y4ecQlEmgtrmodxSkO7Rt64?=
 =?us-ascii?Q?JkhFTuP6c1S8rztuNuC123JV+l5y0+W+17f+lwAkAUXR0RqnrtgVGuGFSs15?=
 =?us-ascii?Q?QoaDgiueKivQ7dIhM2mSjgVlUt7AyXFVqIDPrFMnMTXgS/Tb4pBxYQ32Idr9?=
 =?us-ascii?Q?fk4EanGSwDeeyvR5xgj2TPCUE2xES0dxBnJFv3058XF+Kj9ddyn0hB/FxTiL?=
 =?us-ascii?Q?DMvrYci/DJQ/Cyd2FiTQrp6w/2gQ9SDij4/p/A00MwBIhEMrrjjFS13rxyAo?=
 =?us-ascii?Q?KOEhkQt2s+eDdCvoc+hz8EbvPzIwpWD4yg8t4CKaxAXypPYhwMnDlPUanzHU?=
 =?us-ascii?Q?wtFn4FoB+N6SvIbOZwTo/fYS5gj8uuh/jmC010sakj2rknhIhhEkePfmhHoT?=
 =?us-ascii?Q?Qq+wrHu07Qqgkp6cQACRT4hoI/pZUsBRpZwfNOb9HKBWc3vUPWrw3EZeShxY?=
 =?us-ascii?Q?jQu7M6B5PYvjRSBrlF6eqdgX0rdnPv3/hRVxozIXmMuN9IF32/PFnaVySicG?=
 =?us-ascii?Q?la4z2x+xDy7BsOOsE4Y/OobFasWzPAU4MrJN8quXbhWsDPrbdSjBbCcVzGsm?=
 =?us-ascii?Q?puClpoT4ZlQ1f7H+pad8/c+iDS3qM4BifHJYOIVUNUmZEJD9fULslpRr48Pp?=
 =?us-ascii?Q?r6DKGrg55Ot3+W5g4gw/iRzGmb2RykSy/EXv3ov8c0JY/YfTN2GMM8lXgau5?=
 =?us-ascii?Q?lFKNLpdYart71GkHj+eVbjVNchA/8L1DGyjZWNhmt9DlM/b/RA2C5/MFIw69?=
 =?us-ascii?Q?vwPN7QxjI2u0J5J9dMAOE1giuUSEzhpjXAlsnPbzgbP3Ld8hBqYR9t+KY8w1?=
 =?us-ascii?Q?4l3QcXLxUe9RMLjglXpaxhgF3s+hSN8nSq6y2gEHEZ6GDFgIpP2PhtGtldra?=
 =?us-ascii?Q?z8H4mtWMwDLbSKHz7ifMbF1s20GHe9bzEXp8MrkNIWFjJkvgkQgApOOl1FXO?=
 =?us-ascii?Q?PsKY6Ds0bbjw8Zo+eU/esYQlhEFsIeSpQ6eNdUozbiPH/WLZaEIp9c1FTdp2?=
 =?us-ascii?Q?dW7RBhHW9YkDI7Ws2t847Vccw3bKlY6135Okcohw3F66DURSh6Gy+uJ/z9bm?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8d0e42-b7da-4518-3bd4-08dae4381e37
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 16:18:10.8052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFDWimmAg+hk9T25v6ya93+7LPNcEB2WgQG8Yo+VTk7IHBv/YuPThpsJrYCMDL1bcNTpGE0PTx+J/i02tIB/Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8431
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 03:34:27PM +0100, Andrew Lunn wrote:
> > I think that doesn't scale very well either, so I was looking into
> > transitioning the sja1105 bindings to something similar to what Colin
> > Foster has done with vsc7512 (ocelot). For this switch, new-style
> > bindings would look like this:
> 
> Have you looked at probe ordering issues? MFD devices i've played with
> are very independent. They are a bunch of IP blocks sharing a bus. A
> switch however is very interconnected.

Some bits are functionally fully independent in a switch SoC as well -
the GPIO controller might have nothing to do with the MDIO controller.
Sure, there might be interdependencies too. That being said, there
shouldn't be probe ordering issues. Children of the soc node can depend
on each other (not circularly), but they are probed in parallel by the
soc driver, so that's not a problem.

> > 	soc@2 {
> > 		compatible = "nxp,sja1110-soc";
> > 		reg = <2>;
> > 		spi-max-frequency = <4000000>;
> > 		spi-cpol;
> > 		#address-cells = <1>;
> > 		#size-cells = <1>;
> > 
> > 		sw2: ethernet-switch@0 {
> > 			compatible = "nxp,sja1110a";
> > 			reg = <0x000000 0x400000>;
> > 			resets = <&sw2_rgu SJA1110_RGU_ETHSW_RST>;
> > 			dsa,member = <0 1>;
> > 
> > 			ethernet-ports {
> > 				#address-cells = <1>;
> > 				#size-cells = <0>;
> 
> ...
> 
> > 
> > 				port@3 {
> > 					reg = <3>;
> > 					label = "1ge_p2";
> > 					phy-mode = "rgmii-id";
> > 					phy-handle = <&sw2_mii3_phy>;
> > 				};
> 
> So for the switch to probe, the PHY needs to probe first.

Yup. This is better/clearer compared to the original binding, where the
mdio was a child of the ethernet-switch, now they can probe truly in
parallel, and fw_devlink can even enforce any ordering it wants.

> > 		mdio@704000 {
> > 			compatible = "nxp,sja1110-base-t1-mdio";
> > 			#address-cells = <1>;
> > 			#size-cells = <0>;
> > 			reg = <0x704000 0x1000>;
> > 
> > 			sw2_port5_base_t1_phy: ethernet-phy@1 {
> > 				compatible = "ethernet-phy-ieee802.3-c45";
> > 				reg = <0x1>;
> > 				interrupts-extended = <&slir2 SJA1110_IRQ_CBT1_PHY1>;
> > 			};
> 
> For the PHY to probe requires that the interrupt controller probes first.

Yup. This was actually a problem with fw_devlink with the old bindings,
especially with mv88e6xxx-type bindings, where the interrupt-controller;
property gets applied to the ethernet-switch node, and so, the
interrupts-extended property is practically a backlink.

> > 		slir2: interrupt-controller@711fe0 {
> > 			compatible = "nxp,sja1110-acu-slir";
> > 			reg = <0x711fe0 0x10>;
> > 			interrupt-controller;
> > 			#interrupt-cells = <1>;
> > 			interrupt-parent = <&gpio 10>;
> > 		};
> 
> and the interrupt controller requires its parent gpio controller
> probes first. I assume this is the host SOC GPIO controller, not the
> switches GPIO controller.

Yup, the interrupt-parent is a host interrupt, not something handled by
the switch. Although I've added logic to this irqchip driver (not posted)
which makes the parent interrupt completely optional, and it falls back
to poll mode if the parent IRQ is missing.

> 
> > 		sw2_rgu: reset@718000 {
> > 			compatible = "nxp,sja1110-rgu";
> > 			reg = <0x718000 0x1000>;
> > 			#reset-cells = <1>;
> > 		};
> 
> and presumably something needs to hit the reset at some point? Will
> there be DT phandles to this?

Yes, there already is a phandle in the ethernet-switch node:

			resets = <&sw2_rgu SJA1110_RGU_ETHSW_RST>;

This is something which SJA1110 engineers did better than SJA1105: the
reset domains are much better separated. Via the RGU block, one can
individually reset different peripherals.

Here's the content of my #include <dt-bindings/reset/nxp-sja1110-rgu.h>:

/* SPDX-License-Identifier: GPL-2.0+ */
/*
 * Device Tree binding constants for NXP SJA1110 Reset Generation Unit
 *
 * Copyright 2022 NXP
 */

#ifndef __DT_BINDINGS_NXP_SJA1110_RGU_H
#define __DT_BINDINGS_NXP_SJA1110_RGU_H

#define SJA1110_RGU_CBT1_RST		22
#define SJA1110_RGU_PERSS_RST		21
#define SJA1110_RGU_ETHSW_RST		20
#define SJA1110_RGU_MCSS_RST		19
#define SJA1110_RGU_NT1SS_PORT4_RST	18
#define SJA1110_RGU_NT1SS_PORT3_RST	17
#define SJA1110_RGU_NT1SS_PORT2_RST	16
#define SJA1110_RGU_NT1SS_PORT1_RST	15
#define SJA1110_RGU_CBT1_RESUME		14
#define SJA1110_RGU_CHIP_SYS_RST	13
#define SJA1110_RGU_PLL_DISABLE		12
#define SJA1110_RGU_DEVCFG_RST		11
#define SJA1110_RGU_OTP_RST		10
#define SJA1110_RGU_OSC_DISABLE		9
#define SJA1110_RGU_PMC_RST		8
#define SJA1110_RGU_SISS_RST		7
#define SJA1110_RGU_WARM_RST		6
#define SJA1110_RGU_COLD_RST		5
#define SJA1110_RGU_COLD_INP_RST	4
#define SJA1110_RGU_HW_RST		3
#define SJA1110_RGU_HW_INP_RST		2
#define SJA1110_RGU_POR_RST		1
#define SJA1110_RGU_PORTAP_RST		0

#endif /* __DT_BINDINGS_NXP_SJA1110_RGU_H */

I haven't yet discovered the mapping of all peripherals to reset
domains, but the switch reset really resets only the switch IP (this is
necessary to load a different static config into it).

This is different compared to SJA1105, where the XPCS also gets reset
when the switch reset is triggered. That led to workarounds such as me
needing to call xpcs_do_config() from sja1105_static_config_reload() -
every time the switching IP got reset. Food for thought, especially with
Sean Anderson's proposal to treat PCS devices using the regular device
model with independent probe and remove - how independent the PCS truly
is will depend on the hardware integration.

> > 
> > 		sw2_cgu: clock-controller@719000 {
> > 			compatible = "nxp,sja1110-cgu";
> > 			reg = <0x719000 0x1000>;
> > 			#clock-cells = <1>;
> > 		};
> 
> and phandles to the clock driver?

Yup. Consumers of CGU clocks can either be some other SJA1110
peripherals, or external devices altogether, which need to keep a clock
ticking. Currently I don't have a need for a CGU driver, it's there
mostly for illustrative purposes.

> Before doing too much in this direction, i would want to be sure you
> have sufficient control of ordering and the DT loops are not too
> complex, that the MFD core and the driver core can actually get
> everything probed.

Yup, I did think about that.

> The current way of doing it, with the drivers embedded inside the DSA
> driver is that DT blob only exposes what needs to be seen outside of
> the DSA driver. And the driver has full control over the order it
> probes its internal sub drivers, so ensuring they are probed in the
> correct order, and the linking is done in C, not DT, were again the
> driver is in full control.

Calling the sub-functions "drivers" is a bit too much, since in the
Linux device model sense, the old/standard way proposes only a single
driver for a single device structure: the spi_driver / i2c_driver /
mdio_driver / platform_driver for the switch chip as a whole. That
device driver calls dsa_register_switch(), but also optionally calls
mdiobus_register(), gpiochip_add_data(), irq_domain_add_linear(), etc
etc. Basically it registers a single struct device with all the
subsystems that the switching chip needs.

> I do however agree that being able to split sub drivers out of the
> main driver is a good idea, and putting them in the appropriated
> subsystem would help with code review.

Yup. Concretely, here, my problem is somewhat different. It is related
to OF addresses for all those SoC children. Somehow that was a problem
even in the old-style (current) bindings, but in a different way: see
the "mdios" subnode.

Some other mfd drivers which call of_platform_populate() and their
children have unit addresses are all memory-mapped in the CPU address
space. Not the case here.

> Maybe the media subsystem has some pointers how to do this. It also
> has complex devices made up from lots of sub devices.

You mean something like struct v4l2_subdev_ops? This seems like the
precise definition of what I'd like to avoid: a predefined set of
subfunctions decided by the DSA core.

Or maybe something else? To be honest, I don't know much about the media
subsystem. This is what I saw.
