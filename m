Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F4365B71B
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 21:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbjABU31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 15:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbjABU3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 15:29:24 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006A5B849;
        Mon,  2 Jan 2023 12:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PWRzFQWdbpw1ppNYNgN2Z1c44x9u7d1L1LKdszgoE0k=; b=FdNORceAXTzDaFWqRrkQfw3xOf
        Bjeqxlx7CBg5IRpdsealjYQYcvxcCQH24eh07JXy9Tcg2aM+xs7k2r3E2RMow9oheTHm4CTa1ZGmN
        OnJHWjW6qLB7UFcNE9xnS6YFEMfuToV2GFVsnViy9G2lhkdQoKjM77fIC4sSOPRkIjTw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pCRQn-000xgm-Ur; Mon, 02 Jan 2023 21:29:13 +0100
Date:   Mon, 2 Jan 2023 21:29:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <Y7M+mWMU+DJPYubp@lunn.ch>
References: <20230102150209.985419-1-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102150209.985419-1-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -3548,7 +3548,9 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
>  	if (chip->info->ops->port_set_jumbo_size)
>  		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
>  	else if (chip->info->ops->set_max_frame_size)
> -		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> +		return (max_t(int, chip->info->max_frame_size, 1632)
> +			- VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN);
> +
>  	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;

I would also prefer if all this if/else logic is removed, and the code
simply returned chip->info->max_frame_size - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;

> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -132,6 +132,7 @@ struct mv88e6xxx_info {
>  	unsigned int num_gpio;
>  	unsigned int max_vid;
>  	unsigned int max_sid;
> +	unsigned int max_frame_size;

It might be worth adding a comment here what this value actually
represents. We don't want any mixups where the value already has the
frame checksum removed for example.

      Andrew
