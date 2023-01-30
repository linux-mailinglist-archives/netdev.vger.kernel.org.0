Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ECE680D59
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbjA3MPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbjA3MPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:15:44 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE6640F6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 04:15:43 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pMT4N-0003qm-24; Mon, 30 Jan 2023 13:15:31 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pMT4M-0002HO-A1; Mon, 30 Jan 2023 13:15:30 +0100
Date:   Mon, 30 Jan 2023 13:15:30 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Abel Vesa <abel.vesa@linaro.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        Stephen Boyd <sboyd@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-clk@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Abel Vesa <abelvesa@kernel.org>
Subject: Re: [PATCH v2 15/19] clk: imx6ul: fix enet1 gate configuration
Message-ID: <20230130121530.GA10978@pengutronix.de>
References: <20230117061453.3723649-1-o.rempel@pengutronix.de>
 <20230117061453.3723649-16-o.rempel@pengutronix.de>
 <Y9atr+Gn60+m4nOg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y9atr+Gn60+m4nOg@linaro.org>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 07:32:31PM +0200, Abel Vesa wrote:
> On 23-01-17 07:14:49, Oleksij Rempel wrote:
> > According to the "i.MX 6UltraLite Applications Processor Reference Manual,
> > Rev. 2, 03/2017", BIT(13) is ENET1_125M_EN which is not controlling root
> > of PLL6. It is controlling ENET1 separately.
> > 
> > So, instead of this picture (implementation before this patch):
> > fec1 <- enet_ref (divider) <---------------------------,
> >                                                        |- pll6_enet (gate)
> > fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´
> > 
> > we should have this one (after this patch):
> > fec1 <- enet1_ref_125m (gate) <- enet1_ref (divider) <-,
> >                                                        |- pll6_enet
> > fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´
> > 
> > With this fix, the RMII reference clock will be turned off, after
> > setting network interface down on each separate interface
> > (ip l s dev eth0 down). Which was not working before, on system with both
> > FECs enabled.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> I'm OK with this. Maybe a fixes tag ?

Hm. Initial commit was:
Fixes: 787b4271a6a0 ("clk: imx: add imx6ul clk tree support")
but this patch will not apply on top of it.
Next possible commit would be:
Fixes: 1487b60dc2d2 ("clk: imx6ul: Switch to clk_hw based API")
But this patch didn't introduce this issue, it was just refactoring.

What do you prefer?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
