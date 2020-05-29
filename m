Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5F51E8111
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgE2O7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:59:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56872 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbgE2O7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 10:59:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fvmK0IwoC1SLNgIGKFyumiFKiGujzr+Gf1ZoKgBbf4E=; b=PG2RH/QU/+tiU3BPxeKl4SWmSk
        MkrXO76+YzQvXJasdtDeOZG6uwR+cHo/xzWhzWIj5zZyoGISht/3RM7buiwExuYv1dVvcWxNaI2B8
        qnRKJVXFPvUiMnQ5y0UzbJmoQ6Ys4wTdxPeauiZ28RjxvlTiCcYHV/cjvGhzBhxvx5Pc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jegTo-003ecn-P9; Fri, 29 May 2020 16:59:28 +0200
Date:   Fri, 29 May 2020 16:59:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200529145928.GF869823@lunn.ch>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
 <20200528130738.GT1551@shell.armlinux.org.uk>
 <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
 <20200528135608.GU1551@shell.armlinux.org.uk>
 <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
 <20200528144805.GW1551@shell.armlinux.org.uk>
 <20200528204312.df9089425162a22e89669cf1@suse.de>
 <20200528220420.GY1551@shell.armlinux.org.uk>
 <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 01:05:39PM +0200, Thomas Bogendoerfer wrote:
> On Thu, 28 May 2020 23:04:20 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > Can you explain this please?  Just as we think we understand what's
> > going on here, you throw in a new comment that makes us confused.
> 
> sorry about that.
> 
> > You said previously that the mvpp2 was connected to a switch, which
> > makes us think that you've got some DSA-like setup going on here.
> > Does your switch drop its serdes link when all the external links
> > (presumably the 10G SFP+ cages) fail?
> > 
> > Both Andrew and myself wish to have a complete picture before we
> > move forward with this.
> 
> full understandable, I'll try by a small picture, which just
> covers one switch:
> 
>         external ports
>       |  |          |  |
> *-----------------------------*
> |     1  1          2  2      |
> |                             |
> |           switch            |
> |                             |
> |   1   2            1   2    |
> *-----------------------------*
>     |   |            |   |
>     |   |            |   |
> *----------*     *----------*
> |   1   2  |     |   1   2  |
> |          |     |          |
> |  node 1  | ... |  node 8  |
> |          |     |          |
> *----------*     *----------*
> 
> External ports a grouped in ports to network 1 and network 2. If one of the
> external ports has an established link, this link state will be propagated
> to the internal ports. Same when both external ports of a network are down.

By propagated, you mean if the external link is down, the link between
the switch and node 1 will also be forced down, at the SERDES level?
And if external ports are down, the nodes cannot talk to each other?
External link down causes the whole in box network to fall apart? That
seems a rather odd design.

> I have no control over the software running on the switch, therefore I can't
> enable autoneg on the internal links.

O.K. So that means using in-band signalling in DT is clearly
wrong. There is no signalling....

What you are actually interested in is the sync state of the SERDES?
The link is up if the SERDES has sync.

    Andrew
