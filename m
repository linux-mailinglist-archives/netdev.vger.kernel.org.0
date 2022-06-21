Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54089552A60
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 06:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344486AbiFUE40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 00:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiFUE4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 00:56:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FF420BD5;
        Mon, 20 Jun 2022 21:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 784DBCE1799;
        Tue, 21 Jun 2022 04:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AE8C3411D;
        Tue, 21 Jun 2022 04:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655787380;
        bh=ik7pSplbVYwBvCW4LkJ/zGfaJRxicLwOi1ymeKG55mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AhMmK7fFhdIgu2PBs0+RIWN84F/RXwCG6JhogKd0UgCKOcyIxF9iox5jffqX9mqxp
         LRkFGzC+IGtF+2Ei+cDiz9SdpbbgMOLwcA4ujmkziegcZLJMlC4gwp39yEBCYzza2e
         r8GdxsNuyKn+PHz9kN2uy86k2kb3G/D4vdyfsL56hDbNEO/BmB8iL/zLxzyMd+Dv6H
         D+ST8PofuLEAz8XGMcXrhmz35SXQvYDmecRwsi8eY2XToyJql6DvWQDi1P4sl3bdfm
         0CzjJgJTDYgzeo4KFIK325ehSYufnvYwYybFYwV/06C2ip+Zc3D+tc37ush0e4VHTl
         mcoJ0+OkEqX1w==
Date:   Mon, 20 Jun 2022 21:56:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND net-next PATCH 3/3] net: dsa: qca8k: reset cpu port on
 MTU change
Message-ID: <20220620215619.2209533a@kernel.org>
In-Reply-To: <20220618072650.3502-3-ansuelsmth@gmail.com>
References: <20220618072650.3502-1-ansuelsmth@gmail.com>
        <20220618072650.3502-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jun 2022 09:26:50 +0200 Christian Marangi wrote:
> It was discovered that the Documentation lacks of a fundamental detail
> on how to correctly change the MAX_FRAME_SIZE of the switch.
> 
> In fact if the MAX_FRAME_SIZE is changed while the cpu port is on, the
> switch panics and cease to send any packet. This cause the mgmt ethernet
> system to not receive any packet (the slow fallback still works) and
> makes the device not reachable. To recover from this a switch reset is
> required.
> 
> To correctly handle this, turn off the cpu ports before changing the
> MAX_FRAME_SIZE and turn on again after the value is applied.
> 
> Fixes: f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
 
It reads like this patch should be backported to 5.10 and 5.15 stable
branches. While patches 1 and 2 are cleanups. In which case you should
reports just patch 3 against net/master first, we'll send it to Linus at
the end of the week and then you can send the cleanups on top for -next.

One extra question below.

> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index eaaf80f96fa9..0b92b9d5954a 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -2334,6 +2334,7 @@ static int
>  qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  {
>  	struct qca8k_priv *priv = ds->priv;
> +	int ret;
>  
>  	/* We have only have a general MTU setting.
>  	 * DSA always set the CPU port's MTU to the largest MTU of the slave
> @@ -2344,10 +2345,29 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
>  	if (!dsa_is_cpu_port(ds, port))
>  		return 0;
>  
> +	/* To change the MAX_FRAME_SIZE the cpu ports must be off or
> +	 * the switch panics.
> +	 * Turn off both cpu ports before applying the new value to prevent
> +	 * this.
> +	 */
> +	if (priv->port_enabled_map & BIT(0))
> +		qca8k_port_set_status(priv, 0, 0);
> +
> +	if (priv->port_enabled_map & BIT(6))
> +		qca8k_port_set_status(priv, 6, 0);
> +
>  	/* Include L2 header / FCS length */
> -	return regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
> -				  QCA8K_MAX_FRAME_SIZE_MASK,
> -				  new_mtu + ETH_HLEN + ETH_FCS_LEN);
> +	ret = regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,

Why care about the return code of this regmap access but not the ones
inside the *port_set_status() calls?

> +				 QCA8K_MAX_FRAME_SIZE_MASK,
> +				 new_mtu + ETH_HLEN + ETH_FCS_LEN);
> +
> +	if (priv->port_enabled_map & BIT(0))
> +		qca8k_port_set_status(priv, 0, 1);
> +
> +	if (priv->port_enabled_map & BIT(6))
> +		qca8k_port_set_status(priv, 6, 1);
> +
> +	return ret;
>  }
>  
>  static int
