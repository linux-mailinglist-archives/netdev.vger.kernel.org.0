Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA53669B2E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 15:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjAMO7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 09:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjAMO7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 09:59:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877E87279B;
        Fri, 13 Jan 2023 06:48:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76C8BB82143;
        Fri, 13 Jan 2023 14:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291BDC433EF;
        Fri, 13 Jan 2023 14:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673621336;
        bh=mKDVcodgQCR6DPkp/F4rI7u1VeNzP/9JniqcDRZGYt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GlkccT/Hr2LutWYIz7x2OeZwDKnzimkm3AKE/6pQDz7vMVa+5Ysxp2cXVA1uDc585
         tQu+sSYrG4mCQCUpcKotZX/0gkRc6Sp8eojXlizzx2VSGudlXZ6UHXs0UTKUkFg07t
         Zg0lVU7doBCMAB56RDZ86axs+9pIsk5l6QWfD2Y46HgJWHg4wzQsIYdkPKMQRNqPSB
         QEKxqUKniznS11sgtKlEeomB6ebH21Lpsh7UJD9Dhdz3yuNDJQoy/VZGU1Mt1s8x2G
         dz6k2lOgOQS84JcpLtasgHMczxnX0Jz6Mb0VVq7hrsV9zhlZqGUplkzxDt/aBlB2qg
         /G/4NlCcu07Bg==
Date:   Fri, 13 Jan 2023 14:48:48 +0000
From:   Lee Jones <lee@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Abel Vesa <abelvesa@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 17/20] clk: imx6ul: add ethernet refclock mux support
Message-ID: <Y8FvULElX2D8FGXA@google.com>
References: <20230113142718.3038265-1-o.rempel@pengutronix.de>
 <20230113142718.3038265-18-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230113142718.3038265-18-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan 2023, Oleksij Rempel wrote:

> Add ethernet refclock mux support and set it to internal clock by
> default. This configuration will not affect existing boards.
> 
> clock tree before this patch:
> fec1 <- enet1_ref_125m (gate) <- enet1_ref (divider) <-,
>                                                        |- pll6_enet
> fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´
> 
> after this patch:
> fec1 <- enet1_ref_sel(mux) <- enet1_ref_125m (gate) <- ...
>                `--<> enet1_ref_pad                      |- pll6_enet
> fec2 <- enet2_ref_sel(mux) <- enet2_ref_125m (gate) <- ...
>                `--<> enet2_ref_pad
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/clk/imx/clk-imx6ul.c                | 26 +++++++++++++++++++++
>  include/dt-bindings/clock/imx6ul-clock.h    |  6 ++++-
>  include/linux/mfd/syscon/imx6q-iomuxc-gpr.h |  6 +++--
>  3 files changed, 35 insertions(+), 3 deletions(-)

[...]

> --- a/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
> +++ b/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
> @@ -451,8 +451,10 @@
>  #define IMX6SX_GPR12_PCIE_RX_EQ_2			(0x2 << 0)
>  
>  /* For imx6ul iomux gpr register field define */
> -#define IMX6UL_GPR1_ENET1_CLK_DIR		(0x1 << 17)
> -#define IMX6UL_GPR1_ENET2_CLK_DIR		(0x1 << 18)
> +#define IMX6UL_GPR1_ENET2_TX_CLK_DIR		BIT(18)
> +#define IMX6UL_GPR1_ENET1_TX_CLK_DIR		BIT(17)
> +#define IMX6UL_GPR1_ENET2_CLK_SEL		BIT(14)
> +#define IMX6UL_GPR1_ENET1_CLK_SEL		BIT(13)
>  #define IMX6UL_GPR1_ENET1_CLK_OUTPUT		(0x1 << 17)
>  #define IMX6UL_GPR1_ENET2_CLK_OUTPUT		(0x1 << 18)
>  #define IMX6UL_GPR1_ENET_CLK_DIR		(0x3 << 17)

Why not convert more of them them?

Either way, could you please refrain from sending me subsequent
patch-sets please.

Acked-by: Lee Jones <lee@kernel.org>

-- 
Lee Jones [李琼斯]
