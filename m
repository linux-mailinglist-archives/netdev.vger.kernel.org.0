Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1C75BB9D0
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 20:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiIQSCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 14:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIQSCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 14:02:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF38727DD5
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 11:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IruG7mdPxBQlq6OwH7+IQofd6kNrkykMoZ+9UBIX1Ps=; b=3oS5OsURlqFK0cYqHqcMLcfxpG
        Z84pfurU7Eam50u6vI0zFousQB5w5cmBgFEFr5jttzKrccEfx1o6sXMXlXrcLK/kWSU3HhflE7I8Q
        EsVdpzIE0ueVmWt2qvD1PqpcdowGBopPofJJTxgKXsgiwUDbGHjxMYyEK+OakjJd1cYA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oZc8t-00GzyV-0k; Sat, 17 Sep 2022 20:02:15 +0200
Date:   Sat, 17 Sep 2022 20:02:15 +0200
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
Subject: Re: [PATCH net-next v13 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <YyYLpyOrmRM/Qj/n@lunn.ch>
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
 <20220916121817.4061532-5-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916121817.4061532-5-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 02:18:15PM +0200, Mattias Forsblad wrote:
> The Marvell SOHO switches supports a secondary control
> channel for accessing data in the switch. Special crafted
> ethernet frames can access functions in the switch.
> These frames is handled by the Remote Management Unit (RMU)
> in the switch. Accessing data structures is specially
> efficient and lessens the access contention on the MDIO
> bus.

Thanks for continually reworking this. It is nearly there now.

I said earlier, you want lots of small patches which are easy to
review. I would separate the MIB stuff into a separate patch.  This
patch can provide the basic infrastructure to send a request to the
RMU, and do basic validation of the reply. Then have patches which
make use of that. One such patch is getting the ID. Another patch is
getting statistics.

> +int mv88e6xxx_state_get_stats_rmu(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
> +{
> +	const u64 *stats = chip->ports[port].rmu_raw_stats;

...

> +static void mv88e6xxx_rmu_stats_get(struct mv88e6xxx_chip *chip, int port, uint64_t *data)
> +{
> +	u16 req[4] = { MV88E6XXX_RMU_REQ_FORMAT_SOHO,
> +		       MV88E6XXX_RMU_REQ_PAD,
> +		       MV88E6XXX_RMU_REQ_CODE_DUMP_MIB,
> +		       MV88E6XXX_RMU_REQ_DATA};
> +	struct mv88e6xxx_dump_mib_resp resp;
> +	struct mv88e6xxx_port *p;
> +	u8 resp_port;
> +	int resp_len;
> +	int num_mibs;
> +	int ret;
> +	int i;

...

> +	/* Copy MIB array for further processing according to chip type */
> +	num_mibs = (resp_len - offsetof(struct mv88e6xxx_dump_mib_resp, mib)) / sizeof(__be32);
> +	for (i = 0; i < num_mibs; i++)
> +		p->rmu_raw_stats[i] = be32_to_cpu(resp.mib[i]);
> +
> +	/* Update MIB for port */
> +	mv88e6xxx_state_get_stats_rmu(chip, port, data);

Why copy the stats into p->rmu_raw_stats[i] when you can just pass
resp to mv88e6xxx_state_get_stats_rmu().

This is left over from the way you used the old stats function to
decode the values. But now you have a dedicated function, you can
avoid this copy.

      Andrew
