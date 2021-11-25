Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27CA45DD7A
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355987AbhKYPcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234727AbhKYPcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 10:32:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 250A160184;
        Thu, 25 Nov 2021 15:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637854150;
        bh=tHVdhLvqghxMFuUawhPp4clmR+uHdlLc9jbHMyTnE3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ufyqXW0IflHgzUokj9v2f43TB6ifq90V5j/j9/G27pfXoBM0E3O1Mwow6mlLb9LxW
         dtM9j4Uy3kWG1+ScP40iulhtXpjBE9AnQ9OOo9n+ij9Cb6iYyRTp6YAEa+v2E0GPYF
         JzUvhIOOQ7suovDKIBXzJT8ogbqwl83Ncu9x5Qxe/OUXtkzYF8VnU82PjaYbGpI2bi
         hbgMY5Vb2gWlDphOlcID0qYg5VpGdvIKID0/iOQZxWa3JMUqywfQ0d0XgoQQ39BT7K
         C9/Xu1wnan5/EGqUUFzT+98wE8pTvqjJagWpv6QcMZdlxu15oflxr45rmnDWOQhOhy
         1Km5BlGQ5ST5w==
Date:   Thu, 25 Nov 2021 07:29:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next] net: dsa: felix: enable cut-through
 forwarding between ports by default
Message-ID: <20211125072909.23b4e9d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125101652.ansuiha5hlwe3ner@skbuf>
References: <20211123132116.913520-1-olteanv@gmail.com>
        <20211124183900.7fb192f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211125101652.ansuiha5hlwe3ner@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 12:16:52 +0200 Vladimir Oltean wrote:
> > > +			if (min_speed > other_ocelot_port->speed)
> > > +				min_speed = other_ocelot_port->speed;  
> > 
> > break; ?  
> 
> Break where and why?
> Breaking in the "if" block means "stop at the first @other_port in
> @port's forwarding domain which has a lower speed than @port". But that
> isn't necessarily the minimum...
> And breaking below the "if" block means stopping at the first
> @other_port in @port's forwarding domain, which doesn't make sense.
> This is the simple calculation of the minimum value of an array, no
> special sauce here.

A single slower port is enough to disable cut through, this is can be
read as a proof of nonexistence rather than min calculation. But really
just a nit pick, don't think any bot will bother us about it.

> > >  	/* Core: Enable port for frame transfer */
> > >  	ocelot_fields_write(ocelot, port,
> > >  			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);  
> > 
> > Does this enable forwarding? Is there a window here with forwarding
> > enabled and old cut-thru masks if we don't clear cut-thru when port
> > goes down?  
> 
> Correct, I should be updating the cut-through masks before this, thanks.
> 
> > > +	if (ocelot->ops->cut_through_fwd)
> > > +		ocelot->ops->cut_through_fwd(ocelot);
> > >  }
> > >  EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_up);
> > >  
> > > @@ -1637,6 +1647,9 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
> > >  
> > >  		ocelot_write_rix(ocelot, mask, ANA_PGID_PGID, PGID_SRC + port);
> > >  	}  
> > 
> > Obviously shooting from the hip here, but I was expecting the cut-thru
> > update to be before the bridge reconfig if port is joining, and after
> > if port is leaving. Do you know what I'm getting at?  
> 
> Yes, I know what you're getting at. But it's a bit complicated to do,
> given the layering constraints and that cut-through forwarding is an
> optional feature which isn't present on all devices, so I am trying to
> keep its footprint minimal on the ocelot library.
> 
> What I can do is I can disable cut-through forwarding for ports that are
> standalone (not in a bridge). I don't have a use case for that anyway:
> the store-and-forward latency is indistinguishable from network stack
> latency. This will guarantee that when a port joins a bridge, it has
> cut-through forwarding disabled. So there are no issues if it happens to
> join a bridge and its link speed is higher than anybody else: there will
> be no packet underruns.

Hm, to make sure I understand - fixing standalone ports doesn't
necessary address the issue of a slow standalone port joining, right?
