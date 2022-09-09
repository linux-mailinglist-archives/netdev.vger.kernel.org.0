Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618485B2BD2
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiIIBuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiIIBuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:50:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5141786C9
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 18:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vHQPBCmOZC20mKttphgElDe9PeLN0VZBWuXWF1HG8AY=; b=2APHw7si7MnEN55eBubdeqvnKY
        VDKs1QgVqeiwNboG2U5WTw2KPIzCMyBnDbpSxn9DPgqcN4D3NITMwizzN0gl8dX6ApktO+7cJtMj8
        e3N1/W7wdbn6xX+EsiHkWOR2388+2k2Q6JTNSlITdaFeQVi1vwLdPoda9IKs1s3ye/44=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oWT9T-00G2A7-Q9; Fri, 09 Sep 2022 03:49:51 +0200
Date:   Fri, 9 Sep 2022 03:49:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v7 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for
 reading RMON data
Message-ID: <YxqbvwlHi4Au0Q5Z@lunn.ch>
References: <20220908132109.3213080-1-mattias.forsblad@gmail.com>
 <20220908132109.3213080-6-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908132109.3213080-6-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index bbdf229c9e71..bd16afa2e1a5 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1234,16 +1234,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
>  				     u16 bank1_select, u16 histogram)
>  {
>  	struct mv88e6xxx_hw_stat *stat;
> +	int offset = 0;
> +	u64 high;
>  	int i, j;
>  
>  	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
>  		stat = &mv88e6xxx_hw_stats[i];
>  		if (stat->type & types) {
> -			mv88e6xxx_reg_lock(chip);
> -			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
> -							      bank1_select,
> -							      histogram);
> -			mv88e6xxx_reg_unlock(chip);
> +			if (mv88e6xxx_rmu_available(chip) &&

I was trying to avoid code like this, by the use of the ops.

In terms of code, you are actually reusing very little here. What you
are re-using is the table of statistics. I would add a new function,
not change this function.

> +			    !(stat->type & STATS_TYPE_PORT)) {
> +				if (stat->type & STATS_TYPE_BANK1)
> +					offset = 32;
> +
> +				data[j] = chip->ports[port].rmu_raw_stats[stat->reg + offset];
> +				if (stat->size == 8) {
> +					high = chip->ports[port].rmu_raw_stats[stat->reg + offset
> +							+ 1];
> +					data[j] += (high << 32);
> +				}
> +			} else {
> +				mv88e6xxx_reg_lock(chip);
> +				data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
> +								      bank1_select, histogram);
> +				mv88e6xxx_reg_unlock(chip);
> +			}
>  
>  			j++;
>  		}

> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 566d18cf5170..5459037067e6 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -266,6 +266,7 @@ struct mv88e6xxx_vlan {
>  struct mv88e6xxx_port {
>  	struct mv88e6xxx_chip *chip;
>  	int port;
> +	u64 rmu_raw_stats[64];

That is a lot of space you don't actually need. Once you have a clean
set of functions, you can simply pass the raw data as a parameter.

    Andrew
