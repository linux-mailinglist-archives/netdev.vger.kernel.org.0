Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791B0626027
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbiKKRK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiKKRK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:10:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76906447;
        Fri, 11 Nov 2022 09:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Tk0Hf69YpxSBIfkAMdq6PCEYbR7nI6ryQyiKET4SZR0=; b=5wn/6vDBGpTFEcDieElbxGjbHR
        gr/SORd92RIorBuTsjdfZQxlTdTfTqLg8RqY2g5VRvTSj6bWf709Y37Q9tnGcyy2uhwWtrtLXKMrf
        u2qODuuLaKIOtxICJ7TkXV9yONeRZDymOCXwmKQCCEkApiHp3TBPv4xU3K/5wMacl8EI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otXXc-0028Sr-7k; Fri, 11 Nov 2022 18:10:08 +0100
Date:   Fri, 11 Nov 2022 18:10:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: use NET_NAME_PREDICTABLE for user ports with
 name given in DT
Message-ID: <Y26B8NL3Rv2u/otG@lunn.ch>
References: <20221111161729.915233-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111161729.915233-1-linux@rasmusvillemoes.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_PASS,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index a9fde48cffd4..dfefcc4a9ccf 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2374,16 +2374,25 @@ int dsa_slave_create(struct dsa_port *port)
>  {
>  	struct net_device *master = dsa_port_to_master(port);
>  	struct dsa_switch *ds = port->ds;
> -	const char *name = port->name;
>  	struct net_device *slave_dev;
>  	struct dsa_slave_priv *p;
> +	const char *name;
> +	int assign_type;
>  	int ret;
>  
>  	if (!ds->num_tx_queues)
>  		ds->num_tx_queues = 1;
>  
> +	if (port->name) {
> +		name = port->name;
> +		assign_type = NET_NAME_PREDICTABLE;
> +	} else {
> +		name = "eth%d";
> +		assign_type = NET_NAME_UNKNOWN;
> +	}

I know it is a change in behaviour, but it seems like NET_NAME_ENUM
should be used, not NET_NAME_UNKNOWN. alloc_etherdev_mqs() uses
NET_NAME_ENUM.

https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/netdevice.h#L42
says that NET_NAME_UNKNOWN does not get passed to user space, but i
assume NET_NAME_ENUM does. So maybe changing it would be an ABI
change?

Humm, i don't know what the right thing is...

      Andrew
