Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D663E1ED0AA
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 15:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgFCNV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 09:21:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34926 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgFCNV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 09:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kq7XlYCYEvDPrzu5OEp1VNG25HMp75SUwW8RLaDeDds=; b=0RIydBKRLRzJCLHAX6Qlhaj13F
        WWj4KSywK7CM6GMMs3NmnwVUJaVyTYQbhm7S47EVT05BJS13vifLWmh15qdWLyC8ixoqQLV/HUmn4
        NcqQmQD5Vxu+ytgHqySPCWPmJ2YG2Wj2fPUMiZFYVZpp55VBDbgL8ZeahawTwd98icUU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jgTL1-0043W9-Ev; Wed, 03 Jun 2020 15:21:47 +0200
Date:   Wed, 3 Jun 2020 15:21:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200603132147.GW869823@lunn.ch>
References: <20200528135608.GU1551@shell.armlinux.org.uk>
 <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
 <20200528144805.GW1551@shell.armlinux.org.uk>
 <20200528204312.df9089425162a22e89669cf1@suse.de>
 <20200528220420.GY1551@shell.armlinux.org.uk>
 <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
 <20200529145928.GF869823@lunn.ch>
 <20200529175225.a3be1b4faaa0408e165435ad@suse.de>
 <20200529163340.GI869823@lunn.ch>
 <20200602225016.GX1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602225016.GX1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 11:50:17PM +0100, Russell King - ARM Linux admin wrote:
> On Fri, May 29, 2020 at 06:33:40PM +0200, Andrew Lunn wrote:
> > Given the current code, you cannot. Now we understand the
> > requirements, we can come up with some ideas how to do this properly.
> 
> Okay, I've been a little quiet because of sorting out the ARM tree
> for merging with Linus (now done) and I've been working on a solution
> to this problem.
> 
> The good news is, I have an implementation in phylink to use the sync
> status reported from a PCS, and to appropriately enable sync status
> reporting.  I'm quite nervous about having that enabled as a matter of
> routine as I've seen some Marvell hardware end up with interrupt storms
> from it - presumably due to noise pickup on the serdes lines being
> interpreted as an intermittently valid signal.

Hi Russell

I have seen similar with an SFP without link. I think squelch is
optional, so noise gets passed through, which is enough to get and
loose sync.

I think we probably need to only enable the interrupt when the LOS
signal indicates there is at least some power coming into the SFP.

> However, I think we need to think about:
> 1) how we classify Thomas' problem - does it count as a regression
>    given that support for his platform is not part of mainline, and
>    the use of in-band-status in his unreviewed DT is clearly incorrect?

I would say no, it is not a regression.

> 2) if we deem it to be a regression, then how do we intend to solve
>    this for stable kernels?

I think this new code should go into net-next, when it opens. I
suspect it is going to be a big change, once we consider LOS.

	Andrew
