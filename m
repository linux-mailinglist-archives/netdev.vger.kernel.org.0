Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EBB3B9A43
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 02:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhGBA6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 20:58:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230369AbhGBA63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 20:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Jlff3/cR3gNBtqn9tl3Uw9zlbyMHBb8A+aqc39wUcx0=; b=fp
        iMvutniJssAWmf2WIszVUL6ap3tTnK2VkB46fLKAuVs3v18uQGmD5wTjlbIsacKl1A1useYtw5/jE
        h/ud4wftxWPyetkPdacB53W1W4wBMV2+zxRX6HjRFhmKJ6M6z5GPJY/9sSuTLgrwc4sJi4V87VsBt
        O+0awAYZBWtv0IM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lz7TG-00Brpo-BG; Fri, 02 Jul 2021 02:55:54 +0200
Date:   Fri, 2 Jul 2021 02:55:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Peter Rosin <peda@axentia.se>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC net-next] dt-bindings: ethernet-controller: document
 signal multiplexer
Message-ID: <YN5kGsMwds+wCACq@lunn.ch>
References: <20210701005347.8280-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210701005347.8280-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 02:53:47AM +0200, Marek Behún wrote:
> There are devices where the MAC signals from the ethernet controller are
> not directly connected to an ethernet PHY or a SFP cage, but to a
> multiplexer, so that the device can switch between the endpoints.
> 
> For example on Turris Omnia the WAN controller is connected to a SerDes
> switch, which multiplexes the SerDes lanes between SFP cage and ethernet
> PHY, depending on whether a SFP module is present (MOD_DEF0 GPIO from
> the SFP cage).

At the moment, i don't think phylink supports this. It does not have a
way to dynamically switch PHY. If the SFP disappears, you probably
want to configure the PHY, so that it is up, autoneg started,
etc. When the SFP reappears, the PHY needs to be configured down, the
SFP probably needs its TX GPIO line set active, etc. None of this
currently exists.

The Marvell switches have something similar but different. Which ever
gets link first, SFP or PHY gets the data path. In this case, you
probably want phylink to configure both the SFP and the PHY, and then
wait and see what happens. The hardware will then set the mux when one
of them gets link. phylink should then configure the other
down. Again, non of this exists at the moment.

I would imaging a similar binding could be used for these two
conditions. But until we get the needed code, it is hard for me to
say. So i think i would prefer to wait until we do have code.

I also wonder how wise it is to put this into the generic ethernet
controller binding. Muxing based on MOD_DEF0 i expect to be very
rare. Muxing based on first port having link seems more likely. But
both i expect are pretty unusual. So i would be tempted to make it a
standalone binding, which can be imported into an MAC binding which
actually needs it. Or it actually becomes part of the phylink
binding, since this all appears to be PHY related, not MAC.

	  Andrew
