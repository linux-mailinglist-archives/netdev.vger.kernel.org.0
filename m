Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF414C0668
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbiBWAwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbiBWAwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:52:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB0B2D1D9;
        Tue, 22 Feb 2022 16:52:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ED7261353;
        Wed, 23 Feb 2022 00:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA0CC340E8;
        Wed, 23 Feb 2022 00:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645577538;
        bh=/EXjq+DxJhrHcYYvRHrCRngZP4fbKy2m1kl/vW5emX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ju39BsgF3hnjz3FT0G3JJrFowvqZSbKshvBTgZZ4BdMTigyANWAYtdU4cOBj2kVqt
         mbkEV5nEkMumKgBoNyzMWXJx2pSSTvRfDfeVTXmQD/NwqdquDMIGlCUgpyznS6hre/
         DCABFssdLc6nFhP5g7tb7YrqpMzAiNT5MtYIvltcwGYGtJTn6YrkgwiuQlpJJJbpr6
         qW/AqZRAzX0HOzYonRBD9DZ+jP5NJsqVa050HXihFmXxra2n6QE9V6Mjd0y29moUGZ
         HJMoXhXs+zCVDPz6fm94/UTxDWD4Jn694WP8N+ySz/v9Y6gQ8ANXuHH6pBg0b6H90U
         WqDV2js4fNINg==
Date:   Tue, 22 Feb 2022 16:52:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220222165217.62426462@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220221084328.3661250-1-o.rempel@pengutronix.de>
References: <20220221084328.3661250-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Feb 2022 09:43:28 +0100 Oleksij Rempel wrote:
> This chips supports two ways to configure max MTU size:
> - by setting SW_LEGAL_PACKET_DISABLE bit: if this bit is 0 allowed packed size
>   will be between 64 and bytes 1518. If this bit is 1, it will accept
>   packets up to 2000 bytes.
> - by setting SW_JUMBO_PACKET bit. If this bit is set, the chip will
>   ignore SW_LEGAL_PACKET_DISABLE value and use REG_SW_MTU__2 register to
>   configure MTU size.
> 
> Current driver has disabled SW_JUMBO_PACKET bit and activates
> SW_LEGAL_PACKET_DISABLE. So the switch will pass all packets up to 2000 without
> any way to configure it.
> 
> By providing port_change_mtu we are switch to SW_JUMBO_PACKET way and will
> be able to configure MTU up to ~9000.

And it has no negative side affects to always have jumbo enabled?
Maybe the internal buffer will be carved up in a different way?

> +static int ksz9477_change_mtu(struct dsa_switch *ds, int port, int mtu)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	u16 new_mtu, max_mtu = 0;
> +	int i;
> +
> +	new_mtu = mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN;
> +
> +	if (dsa_is_cpu_port(ds, port))
> +		new_mtu += KSZ9477_INGRESS_TAG_LEN;
> +
> +	/* Cache the per-port MTU setting */
> +	dev->ports[port].max_mtu = new_mtu;
> +
> +	for (i = 0; i < dev->port_cnt; i++) {
> +		if (dev->ports[i].max_mtu > max_mtu)
> +			max_mtu = dev->ports[i].max_mtu;
> +	}

nit:

	for (...)
		max_mtu = max(max_mtu, dev->ports[i].max_mtu)

> @@ -41,6 +41,7 @@ struct ksz_port {
>  
>  	struct ksz_port_mib mib;
>  	phy_interface_t interface;
> +	unsigned int max_mtu;
>  };

max_mtu already has two meanings in this patch, let's call this
max_frame or max_len etc, instead of adding a third meaning.
