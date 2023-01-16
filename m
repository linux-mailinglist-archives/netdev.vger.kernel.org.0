Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041E666B6DA
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 06:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjAPF0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 00:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjAPF0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 00:26:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ADB8691
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 21:26:49 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pHI0n-0002zC-FI; Mon, 16 Jan 2023 06:26:25 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pHI0k-0001HV-VI; Mon, 16 Jan 2023 06:26:22 +0100
Date:   Mon, 16 Jan 2023 06:26:22 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Peng Fan <peng.fan@oss.nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        linux-clk@vger.kernel.org
Subject: Re: [PATCH v1 05/20] ARM: dts: imx6qdl: use enet_clk_ref instead of
 enet_out for the FEC node
Message-ID: <20230116052622.GA980@pengutronix.de>
References: <20230113142718.3038265-1-o.rempel@pengutronix.de>
 <20230113142718.3038265-6-o.rempel@pengutronix.de>
 <76716956-3f15-edd0-e9e2-bdba78de54f9@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <76716956-3f15-edd0-e9e2-bdba78de54f9@oss.nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 09:01:08AM +0800, Peng Fan wrote:
> Hi Oleksij,
> 
> On 1/13/2023 10:27 PM, Oleksij Rempel wrote:
> > Old imx6q machine code makes RGMII/RMII clock direction decision based on
> > configuration of "ptp" clock. "enet_out" is not used and make no real
> > sense, since we can't configure it as output or use it as clock
> > provider.
> > 
> > Instead of "enet_out" use "enet_clk_ref" which is actual selector to
> > choose between internal and external clock source:
> > 
> > FEC MAC <---------- enet_clk_ref <--------- SoC PLL
> >                           \
> > 			  ^------<-> refclock PAD (bi directional)
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >   arch/arm/boot/dts/imx6qdl.dtsi | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> > index ff1e0173b39b..71522263031a 100644
> > --- a/arch/arm/boot/dts/imx6qdl.dtsi
> > +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> > @@ -1050,8 +1050,8 @@ fec: ethernet@2188000 {
> >   				clocks = <&clks IMX6QDL_CLK_ENET>,
> >   					 <&clks IMX6QDL_CLK_ENET>,
> >   					 <&clks IMX6QDL_CLK_ENET_REF>,
> > -					 <&clks IMX6QDL_CLK_ENET_REF>;
> > -				clock-names = "ipg", "ahb", "ptp", "enet_out";
> > +					 <&clks IMX6QDL_CLK_ENET_REF_SEL>;
> > +				clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";
> 
> 
> Please also update fec binding, otherwise there will be dtbs check error.

Hm, there is no restriction on enet_clk_ref use or requirements to use
enet_out in Documentation/devicetree/bindings/net/fsl,fec.yaml

Do I missing something?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
