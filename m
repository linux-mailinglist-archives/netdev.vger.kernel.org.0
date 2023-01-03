Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDC965C057
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 13:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237642AbjACMzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 07:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbjACMzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 07:55:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814BA10FC5;
        Tue,  3 Jan 2023 04:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=i1X/dAEXknkd6JuUKqxl20xIM3iRsOafx1BzQIXRdfQ=; b=pkKDhS9BfegC050glpTLF/VgFZ
        64KHrxghxA3JyMW9N+4qDbgOpcv/pqhdA6B7QvIgVxnK6Tktho0SWIFOEPyFxuemdqGce9ScVqKwX
        MvBfheyXtL1780eKIHjSwy6jCNXZ9cXNiQtyBWihbANQrXtdZ++pWkR/caL1voAgnERM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pCgoW-0012mB-7w; Tue, 03 Jan 2023 13:54:44 +0100
Date:   Tue, 3 Jan 2023 13:54:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <Y7QllC1+oWk4vbd/@lunn.ch>
References: <20230102150209.985419-1-lukma@denx.de>
 <Y7M+mWMU+DJPYubp@lunn.ch>
 <20230103100251.08a5db46@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103100251.08a5db46@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 10:02:51AM +0100, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > > @@ -3548,7 +3548,9 @@ static int mv88e6xxx_get_max_mtu(struct
> > > dsa_switch *ds, int port) if (chip->info->ops->port_set_jumbo_size)
> > >  		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > ETH_FCS_LEN; else if (chip->info->ops->set_max_frame_size)
> > > -		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > ETH_FCS_LEN;
> > > +		return (max_t(int, chip->info->max_frame_size,
> > > 1632)
> > > +			- VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN);
> > > +
> > >  	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;  
> > 
> > I would also prefer if all this if/else logic is removed, and the code
> > simply returned chip->info->max_frame_size - VLAN_ETH_HLEN -
> > EDSA_HLEN - ETH_FCS_LEN;
> > 
> 
> So then the mv88e6xxx_get_max_mtu shall look like:
> 
> WARN_ON_ONCE(!chip->info->max_frame_size)
> 
> if (chip->info->ops->port_set_jumbo_size)
> ...
> else 
>     return chip->info->max_frame_size - VLAN_ETH_HLEN -
> 	EDSA_HLEN - ETH_FCS_LEN;

I think it should go even further:

{
	WARN_ON_ONCE(!chip->info->max_frame_size)

	return chip->info->max_frame_size - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
}

If we are going to use info->max_frame_size, we should always use
info->max_frame_size.

	Andrew
