Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CC248217D
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240897AbhLaCYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:24:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhLaCYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 21:24:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UZA2dRCoUAmUXuo6hEiVcYfoCW7A26IbP5jNz/Y/oTE=; b=LNmwi16WKPo+jx/f9rILPB+ngg
        dbjAavGByfHkCFuydx/Q2swGQx0XxCv67+GXIvYbMIAztqhFzp9T/vKITPVaNKLacDXa8hmg5N94K
        Up3YPxtH5GE69ABCApmstxxvJSdBEpBMH2WChZ5sFwcCBByS/4f3/ixQ9t5EebKY9sfE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n37aw-000ClS-Dx; Fri, 31 Dec 2021 03:24:38 +0100
Date:   Fri, 31 Dec 2021 03:24:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
Message-ID: <Yc5p5iAELXFCuY9t@lunn.ch>
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-5-dmichail@fungible.com>
 <Yc30mG7tPQIT2HZK@lunn.ch>
 <CAOkoqZk0O0NidoHuAf4Qbp3e35P7jbPKMYXS=56XWgMx1BceYg@mail.gmail.com>
 <Yc4x97vqj2fU9Zg/@lunn.ch>
 <CAOkoqZk3tgLi-iY0gju8KAwWvcyHXJUQ61MxAij9BwfMrakniA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOkoqZk3tgLi-iY0gju8KAwWvcyHXJUQ61MxAij9BwfMrakniA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 05:23:56PM -0800, Dimitris Michailidis wrote:
> On Thu, Dec 30, 2021 at 2:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > > I _think_ this is wrong. pause->autoneg means we are autoneg'ing
> > > > pause, not that we are using auto-neg in general. The user can have
> > > > autoneg turned on, but force pause by setting pause->autoneg to False.
> > > > In that case, the pause->rx_pause and pause->tx_pause are given direct
> > > > to the MAC, not auto negotiated.
> > >
> > > Having this mixed mode needs device FW support, which isn't there today.
> >
> > So if you are asked to set pause with pause->autoneg False, return
> > -EOPNOTSUPP. And pause get should always return True. It is O.K, to
> > support a subset of a feature, and say you don't support the
> > rest. That is much better than wrongly implementing it until your
> > firmware gets the needed support.
> 
> include/uapi/linux/ethtool.h has this comment
> 
>  * If the link is autonegotiated, drivers should use
>  * mii_advertise_flowctrl() or similar code to set the advertised
>  * pause frame capabilities based on the @rx_pause and @tx_pause flags,
>  * even if @autoneg is zero. ...
> 
> I read this as saying that pause->autoneg is ignored if AN is on and the
> requested pause settings are fed to AN. I believe this is what the code
> here implements.
> 
> Whereas you are saying that pause->autoneg == 0 should force
> despite AN. Right?

Take a look at phylink_ethtool_set_pauseparam() and accompanying
functions. This is a newish central implementation for any MAC/PHY
with Linux controlling the hardware. There are ambiguities in the API
description, so it would be better if your driver/firmware combo does
the same a the core Linux code. When Russell wrote that code, there
was quite a bit of discussion what the documentation actually means.

    Andrew
