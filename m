Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C673CF7D6
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbhGTJrZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Jul 2021 05:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbhGTJmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 05:42:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675C4C061762
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 03:23:17 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m5mu4-0001g8-Aw; Tue, 20 Jul 2021 12:23:08 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m5mu3-0002S8-Sy; Tue, 20 Jul 2021 12:23:07 +0200
Message-ID: <c8ec5fe0c8eb86898416edb7c68dcf0eeeaccf54.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/5] can: rcar_canfd: Add support for RZ/G2L family
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Date:   Tue, 20 Jul 2021 12:23:07 +0200
In-Reply-To: <20210719143811.2135-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
         <20210719143811.2135-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-07-19 at 15:38 +0100, Lad Prabhakar wrote:
> CANFD block on RZ/G2L SoC is almost identical to one found on
> R-Car Gen3 SoC's. On RZ/G2L SoC interrupt sources for each channel
> are split into different sources and the IP doesn't divide (1/2)
> CANFD clock within the IP.
> 
> This patch adds compatible string for RZ/G2L family and registers
> the irq handlers required for CANFD operation. IRQ numbers are now
> fetched based on names instead of indices. For backward compatibility
> on non RZ/G2L SoC's we fallback reading based on indices.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/can/rcar/rcar_canfd.c | 178 ++++++++++++++++++++++++------
>  1 file changed, 147 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> index 311e6ca3bdc4..d4affc002fb3 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -37,9 +37,15 @@
[...]
> +	if (gpriv->chip_id == RENESAS_RZG2L) {
> +		gpriv->rstc1 = devm_reset_control_get_exclusive_by_index(&pdev->dev, 0);
> +		if (IS_ERR(gpriv->rstc1)) {
> +			dev_err(&pdev->dev, "failed to get reset index 0\n");

Please consider requesting the reset controls by name instead of by
index. See also my reply to the binding patch.

> +			return PTR_ERR(gpriv->rstc1);
> +		}
> +
> +		err = reset_control_reset(gpriv->rstc1);
> +		if (err)
> +			return err;

I suggest to wait until after all resource requests have succeeded
before triggering the resets, i.e. first get all reset controls and
clocks, etc., and only then trigger resets, enable clocks, and so on.

That way there will be no spurious resets in case of probe deferrals.

regards
Philipp
