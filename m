Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA3E5BA1DF
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 22:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiIOUjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 16:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIOUjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 16:39:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75948983D
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 13:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Vh4EwPsnMAZitfBfSZoEBZDvRaY6DSBfVH0jS0uvljU=; b=Z9EkZ3IRnj4UYon0kV3GRIA8F3
        Pqabvj9IIeLoNicdtJZSwGHd/oX7F+98UINuHA2prPvHeefdHEHOP9j9G3sVl1WJ0eOt4DFmWcJIA
        3wU6a83t7uyZ8zy4zGb001rkk8W7sAkhiKT58tXHoQonSzzTfieQmD0JRs1LXemQ+QBU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oYvdf-00Gr7Y-KU; Thu, 15 Sep 2022 22:39:11 +0200
Date:   Thu, 15 Sep 2022 22:39:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v12 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for
 reading RMON data
Message-ID: <YyONb429ODhmiu6I@lunn.ch>
References: <20220915143658.3377139-1-mattias.forsblad@gmail.com>
 <20220915143658.3377139-6-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915143658.3377139-6-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	{ "sw_in_discards",		4, 0x10, 0x81, STATS_TYPE_PORT, },
> +	{ "sw_in_filtered",		2, 0x12, 0x85, STATS_TYPE_PORT, },
> +	{ "sw_out_filtered",		2, 0x13, 0x89, STATS_TYPE_PORT, },

I agree with Florian here. Maybe add a table just for these three
values? Or even a switch statement.

> -static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
> -				     uint64_t *data, int types,
> -				     u16 bank1_select, u16 histogram)
> +static int mv88e6xxx_state_get_stats_rmu(struct mv88e6xxx_chip *chip, int port,
> +					 uint64_t *data, int types,
> +					 u16 bank1_select, u16 histogram)
> +{
> +	const u64 *stats = chip->ports[port].rmu_raw_stats;
> +	struct mv88e6xxx_hw_stat *stat;
> +	int offset = 0;
> +	u64 high;
> +	int i, j;
> +
> +	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
> +		stat = &mv88e6xxx_hw_stats[i];
> +		if (stat->type & types) {
> +			if (stat->type & STATS_TYPE_PORT) {
> +				data[j] = stats[stat->rmu_reg];
> +			} else {
> +				if (stat->type & STATS_TYPE_BANK1)
> +					offset = 32;
> +
> +				data[j] = stats[stat->reg + offset];
> +				if (stat->size == 8) {
> +					high = stats[stat->reg + offset + 1];
> +					data[j] += (high << 32);
> +				}
> +			}
> +
> +			j++;
> +		}
> +	}
> +	return j;
> +}

This is definitely getting better, closer to what i was thinking. But...

> +static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
> +				     uint64_t *data, int types,
> +				     u16 bank1_select, u16 histogram)
> +{
> +	if (mv88e6xxx_rmu_available(chip))
> +		return mv88e6xxx_state_get_stats_rmu(chip, port, data, types,
> +						     bank1_select, histogram);
> +	else
> +		return mv88e6xxx_stats_get_stats_mdio(chip, port, data, types,
> +						      bank1_select, histogram);
> +}

I would still like to get rid of this.

What i think the problem here is, you are trying to be 100%
compatible. So you only show bank1 statistics, if they where available
via MDIO. However, it seems like all the RMU implementations make all
statistics available, both banks, and counters in the port space.

So long as you keep the names consistent, you can return more
statistics via RMU than via MDIO.

   Andrew
