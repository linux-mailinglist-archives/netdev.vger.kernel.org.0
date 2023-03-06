Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B889E6AB480
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 03:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCFCCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 21:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCFCCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 21:02:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C0212853;
        Sun,  5 Mar 2023 18:02:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7155860B67;
        Mon,  6 Mar 2023 02:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FC7C433D2;
        Mon,  6 Mar 2023 02:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678068155;
        bh=Z/pfCgpFoEEHv7JcHJ6XnWQ3ENGLr+0L1mCke+Jm2IQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h1qn3Qnq9ADu9N5IFa3vlUdv+8/g8WhMnFTZ0mkEx/YORQUtbGCzGpwUUxsouVJM7
         JHCM38DmbjZWOmy4AZjo5nvWw32qJaYF/8uT11+Ksa2VYAbofgRpjt3O9T0WnEzi+k
         bG7MaoDj9shn7Wc/bZ/4hpyjR3YWQTGfI9Hwvt3RZhiji27G7Ex/ywiAwNo4CaDWM2
         OhBbQM7xPgatwh2lY6CLsiNHoovMflRhW+f6C8QhPP17AHUsw25uNx7Poqx3G+8pFy
         qspD/tG3xiuZ8Lh3+A6aYfOqFIE1ZrIH1gP0i6qBmbe0W7UFBeib2XvCxHcFUmLwQG
         LMimPrjLJfVdA==
Date:   Mon, 6 Mar 2023 10:02:26 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
Subject: Re: [PATCH v3 00/19] ARM: imx: make Ethernet refclock configurable
Message-ID: <20230306020226.GC143566@dragon>
References: <20230131084642.709385-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131084642.709385-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 09:46:23AM +0100, Oleksij Rempel wrote:
> changes v3:
> - add Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
> - rebase on top of abelvesa/for-next
> 
> changes v2:
> - remove "ARM: imx6q: use of_clk_get_by_name() instead of_clk_get() to
>   get ptp clock" patch
> - fix build warnings
> - add "Acked-by: Lee Jones <lee@kernel.org>"
> - reword some commits as suggested by Fabio
> 
> Most of i.MX SoC variants have configurable FEC/Ethernet reference
> lock
> used by RMII specification. This functionality is located in the
> general purpose registers (GRPx) and till now was not implemented as
> part of SoC clock tree.
> 
> With this patch set, we move forward and add this missing functionality
> to some of i.MX clk drivers. So, we will be able to configure clock
> opology
> by using devicetree and be able to troubleshoot clock dependencies
> by using clk_summary etc.
> 
> Currently implemented and tested i.MX6Q, i.MX6DL and i.MX6UL variants.
> 
> 
> Oleksij Rempel (19):
>   clk: imx: add clk-gpr-mux driver
>   clk: imx6q: add ethernet refclock mux support
>   ARM: imx6q: skip ethernet refclock reconfiguration if enet_clk_ref is
>     present
>   ARM: dts: imx6qdl: use enet_clk_ref instead of enet_out for the FEC
>     node
>   ARM: dts: imx6dl-lanmcu: configure ethernet reference clock parent
>   ARM: dts: imx6dl-alti6p: configure ethernet reference clock parent
>   ARM: dts: imx6dl-plybas: configure ethernet reference clock parent
>   ARM: dts: imx6dl-plym2m: configure ethernet reference clock parent
>   ARM: dts: imx6dl-prtmvt: configure ethernet reference clock parent
>   ARM: dts: imx6dl-victgo: configure ethernet reference clock parent
>   ARM: dts: imx6q-prtwd2: configure ethernet reference clock parent
>   ARM: dts: imx6qdl-skov-cpu: configure ethernet reference clock parent
>   ARM: dts: imx6dl-eckelmann-ci4x10: configure ethernet reference clock
>     parent
>   clk: imx: add imx_obtain_fixed_of_clock()
>   clk: imx6ul: fix enet1 gate configuration
>   clk: imx6ul: add ethernet refclock mux support
>   ARM: dts: imx6ul: set enet_clk_ref to CLK_ENETx_REF_SEL
>   ARM: mach-imx: imx6ul: remove not optional ethernet refclock overwrite
>   ARM: dts: imx6ul-prti6g: configure ethernet reference clock parent

Applied all mach-imx and DTS ones, thanks!
