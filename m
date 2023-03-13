Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C196B6FC3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjCMG5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjCMG5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:57:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106224D62C;
        Sun, 12 Mar 2023 23:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A023D610E7;
        Mon, 13 Mar 2023 06:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9A8C433EF;
        Mon, 13 Mar 2023 06:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678690661;
        bh=yXZd505XmCeN942UNqXIjHQ5Kwm2nMyuVli34Flsl0k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OV3Qmz/IfYFypeHG/KN765o4V5OmR9wF58a5r9sl82BrhzjL6RJ0t2BMCNGpw1ntM
         KjslQkVZ0JESUZldaRATa7IiEt8tChEUY7aZGOsKDbNPnUsdLkk50GUTNcHuQt8uwu
         /nvJPmC0zq/U3J3CkrwQSJOg3YVsyp9NHgqDbR+vvwKY5uHZfopN5Xhlfq4vRJqL5K
         2lcLp4KOgNNKzHrc3lBCwzRTQhSEaT9H270FVzm0fOR5LBxNIFif2HMZyuJyMpJZPr
         JZdom+77L9fbpCIolgn8UTraemz7xWvoDX9JRXWvn+mO+3wAXa1vcYQvfqy6DaFU28
         H00x/o9omaPFw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: Use of_property_read_bool() for boolean properties
References: <20230310144718.1544169-1-robh@kernel.org>
Date:   Mon, 13 Mar 2023 08:57:31 +0200
In-Reply-To: <20230310144718.1544169-1-robh@kernel.org> (Rob Herring's message
        of "Fri, 10 Mar 2023 08:47:16 -0600")
Message-ID: <87ttypnnok.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob Herring <robh@kernel.org> writes:

> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties.
> Convert reading boolean properties to to of_property_read_bool().
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/net/can/cc770/cc770_platform.c          | 12 ++++++------
>  drivers/net/ethernet/cadence/macb_main.c        |  2 +-
>  drivers/net/ethernet/davicom/dm9000.c           |  4 ++--
>  drivers/net/ethernet/freescale/fec_main.c       |  2 +-
>  drivers/net/ethernet/freescale/fec_mpc52xx.c    |  2 +-
>  drivers/net/ethernet/freescale/gianfar.c        |  4 ++--
>  drivers/net/ethernet/ibm/emac/core.c            |  8 ++++----
>  drivers/net/ethernet/ibm/emac/rgmii.c           |  2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c |  3 +--
>  drivers/net/ethernet/sun/niu.c                  |  2 +-
>  drivers/net/ethernet/ti/cpsw-phy-sel.c          |  3 +--
>  drivers/net/ethernet/ti/netcp_ethss.c           |  8 +++-----
>  drivers/net/ethernet/via/via-velocity.c         |  3 +--
>  drivers/net/ethernet/xilinx/ll_temac_main.c     |  9 ++++-----
>  drivers/net/wan/fsl_ucc_hdlc.c                  | 11 +++--------
>  drivers/net/wireless/ti/wlcore/spi.c            |  3 +--
>  net/ncsi/ncsi-manage.c                          |  4 ++--
>  17 files changed, 35 insertions(+), 47 deletions(-)

For wireless:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
