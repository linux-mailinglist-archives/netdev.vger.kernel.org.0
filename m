Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F543BDFBE
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 01:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhGFXZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 19:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229910AbhGFXZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 19:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 666E061C93;
        Tue,  6 Jul 2021 23:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625613748;
        bh=5mlEDZpYyfsm7tdGyB+79GO9dRgHUn5r+UFeUbzhS/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sUesseh4jTaA8tnTNCEOEi+zDaJTAGkrhJ1JBopObj67sxM5KDnsFFM6Zh2K9DQ/w
         vANHA6iRRzRo6MMSlxXsZ2gYmChCPdvjOZe8VMl6b17EgSZriPhvgCuw1ZujF0zBRZ
         Ov+rsU/phD02mmkq6ovBv9AS3W6doxjdfPQObNcS+XWWN57a5FJLbuBrmo0tUg2NF4
         f1Dt5hUFhERDh07SlfNK2zcR962IJSmgKGxWRj29YD9f8VuRWvEyQ2/TCTv+dSyc48
         6DByJhVXX7gdSn0/CUIKghODj5ONUjZyaBtbkIdLS+UX8RF6vFm5oa/ZppYkp/lhWc
         wEzkoQRMrYwhg==
Date:   Wed, 7 Jul 2021 01:22:24 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Peter Rosin <peda@axentia.se>, netdev@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC net-next] dt-bindings: ethernet-controller: document
 signal multiplexer
Message-ID: <20210707012224.14df9eab@thinkpad>
In-Reply-To: <YN5kGsMwds+wCACq@lunn.ch>
References: <20210701005347.8280-1-kabel@kernel.org>
        <YN5kGsMwds+wCACq@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Jul 2021 02:55:54 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Thu, Jul 01, 2021 at 02:53:47AM +0200, Marek Beh=C3=BAn wrote:
> > There are devices where the MAC signals from the ethernet controller are
> > not directly connected to an ethernet PHY or a SFP cage, but to a
> > multiplexer, so that the device can switch between the endpoints.
> >=20
> > For example on Turris Omnia the WAN controller is connected to a SerDes
> > switch, which multiplexes the SerDes lanes between SFP cage and ethernet
> > PHY, depending on whether a SFP module is present (MOD_DEF0 GPIO from
> > the SFP cage). =20
>=20
> At the moment, i don't think phylink supports this. It does not have a
> way to dynamically switch PHY. If the SFP disappears, you probably
> want to configure the PHY, so that it is up, autoneg started,
> etc. When the SFP reappears, the PHY needs to be configured down, the
> SFP probably needs its TX GPIO line set active, etc. None of this
> currently exists.

Of course this is not supported by phylink: it can't be, since we don't
even have a binding description :) I am figuring out how to do correct
binding while working on implementing this into phylink.

> The Marvell switches have something similar but different. Which ever
> gets link first, SFP or PHY gets the data path. In this case, you
> probably want phylink to configure both the SFP and the PHY, and then
> wait and see what happens. The hardware will then set the mux when one
> of them gets link. phylink should then configure the other
> down. Again, non of this exists at the moment.
>=20
> I would imaging a similar binding could be used for these two
> conditions. But until we get the needed code, it is hard for me to
> say. So i think i would prefer to wait until we do have code.
>=20

I now have an idea that might be sane for bindings, so next time I will
send the code as well.

> I also wonder how wise it is to put this into the generic ethernet
> controller binding. Muxing based on MOD_DEF0 i expect to be very
> rare. Muxing based on first port having link seems more likely. But
> both i expect are pretty unusual. So i would be tempted to make it a
> standalone binding, which can be imported into an MAC binding which
> actually needs it. Or it actually becomes part of the phylink
> binding, since this all appears to be PHY related, not MAC.
>=20
> 	  Andrew

We'll see. Stay tuned for my patch series. :)

Marek
