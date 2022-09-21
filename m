Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F215C02FC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 17:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiIUP5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 11:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiIUP5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 11:57:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62789E692
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 08:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cj/AhpLur6t6HbqPjKAxtXs/H+XkLQkwI6R4xxdMUNs=; b=AML8E3B8BfMYTdoxLSBtQLTTw5
        sRM0lExCbzLNHrvZcNm63U0FqgEi8LJZKKHbAZG7A+sCfKzJ0/DzqJO2TZnoJKqlg97unz/13zhAK
        +xhQSRMRcZl30vVlQpdLgQatjCLUdAiU5MeBHsjJNmH8YPZ0qMkyIf7S0T2qUviE6cTE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ob1zL-00HNxR-HF; Wed, 21 Sep 2022 17:50:15 +0200
Date:   Wed, 21 Sep 2022 17:50:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Message-ID: <Yysyt3e6iBN2qKRI@lunn.ch>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
 <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
 <20220920131053.24kwiy4hxdovlkxo@skbuf>
 <Yyoqx1+AqMlAqRMx@lunn.ch>
 <5d50db8c-5504-f776-521b-eaae4d900e90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d50db8c-5504-f776-521b-eaae4d900e90@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I understand want you want but I can see a lot of risks and pitfalls with moving
> ordinary read and writes to RMU, which I wanted to avoid by first doing
> RMON dump and then dump ATU and at a later stage with a better architecture
> for write/read combining doing that, instead of forcing through read/writes
> with all associated testing it would require. Can we please do this in
> steps?

If we are going to fall back to MDIO when RMU fails, we need a
different code structure for these operations. That different code
structure should also help solve the messy _ops structure stuff.

RMU affects us in two different locations:

ATU and MIB dump: Controlled by struct mv88e6xxx_ops

register read/write: Controlled by struct mv88e6xxx_bus_ops

We could add to struct mv88e6xxx_ops:

        int (*stats_rmu_get_sset_count)(struct mv88e6xxx_chip *chip);
        int (*stats_rmu_get_strings)(struct mv88e6xxx_chip *chip,  uint8_t *data);
        int (*stats_rmu_get_stats)(struct mv88e6xxx_chip *chip,  int port,
                                   uint64_t *data);

and then mv88e6xxx_get_stats() would become something like:

static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
                                uint64_t *data)
{
        int count = 0;
	int err;

	if (chip->info->ops->stats_rmu_get_stats && mv88e6xxx_rmu_enabled(chip)) {
		err = chip->info->ops->stats_rmu_get_stats(chip, port, data)
		if (!err)
			return;
	}
			
        if (chip->info->ops->stats_get_stats)
                count = chip->info->ops->stats_get_stats(chip, port, data);

We then get fall back to MDIO, and clean, separate implementations of
RMU and MDIO stats operations.

I hope the ATU/fdb dump can be done in a similar way.

register read/writes, we probably need to extend mv88e6xxx_smi_read()
and mv88e6xxx_smi_write(). Try RMU first, and then fall back to MDIO.

Please try something in this direction. But please, lots of small,
simple patches with good commit messages.

       Andrew


