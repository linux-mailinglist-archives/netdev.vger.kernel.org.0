Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A10D4B0E4F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242115AbiBJNWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:22:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242103AbiBJNWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:22:06 -0500
X-Greylist: delayed 394 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 05:22:05 PST
Received: from kirsty.vergenet.net (kirsty.vergenet.net [202.4.237.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4BFB22F;
        Thu, 10 Feb 2022 05:22:05 -0800 (PST)
Received: from madeliefje.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 3AE0C25AD6B;
        Fri, 11 Feb 2022 00:15:30 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 23A3D2593; Thu, 10 Feb 2022 14:15:28 +0100 (CET)
Date:   Thu, 10 Feb 2022 14:15:28 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3 1/4] can: rcar_canfd: Add support for r8a779a0 SoC
Message-ID: <YgUP8O/HEKA1fOm/@vergenet.net>
References: <20220209163806.18618-1-uli+renesas@fpond.eu>
 <20220209163806.18618-2-uli+renesas@fpond.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209163806.18618-2-uli+renesas@fpond.eu>
Organisation: Horms Solutions BV
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 05:38:03PM +0100, Ulrich Hecht wrote:
> Adds support for the CANFD IP variant in the V3U SoC.
> 
> Differences to controllers in other SoCs are limited to an increase in
> the number of channels from two to eight, an absence of dedicated
> registers for "classic" CAN mode, and a number of differences in magic
> numbers (register offsets and layouts).
> 
> Inspired by BSP patch by Kazuya Mizuguchi.
> 
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Hi Ulrich,

for some reason this caught by eye.

> @@ -740,12 +784,16 @@ static void rcar_canfd_configure_afl_rules(struct rcar_canfd_global *gpriv,
>  			    RCANFD_GAFLECTR_AFLDAE));
>  
>  	/* Write number of rules for channel */
> -	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLCFG0,
> +	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLCFG(ch),
>  			   RCANFD_GAFLCFG_SETRNC(ch, num_rules));
> -	if (gpriv->fdmode)
> -		offset = RCANFD_F_GAFL_OFFSET;
> -	else
> -		offset = RCANFD_C_GAFL_OFFSET;
> +	if (is_v3u(gpriv)) {
> +		offset = RCANFD_V3U_GAFL_OFFSET;
> +	} else {
> +		if (gpriv->fdmode)
> +			offset = RCANFD_F_GAFL_OFFSET;
> +		else
> +			offset = RCANFD_C_GAFL_OFFSET;
> +	}

nit: this could be:

	if (is_v3u(gpriv))
		offset = RCANFD_V3U_GAFL_OFFSET;
	else if (gpriv->fdmode)
		offset = RCANFD_F_GAFL_OFFSET;
	else
		offset = RCANFD_C_GAFL_OFFSET;

...
