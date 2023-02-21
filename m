Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0C769D879
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbjBUC3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjBUC3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:29:50 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8318F125A3;
        Mon, 20 Feb 2023 18:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nJwv5MrRP2lEvh4BMShIAmUyVMLpxeVSPUYRAHDCtog=; b=6Hg9DSweigf3jhNjtiq5P4zLao
        nkdUM7lU3uClTPubgvN8g8n26KVkSAQ9ar8FVFzCGv2Mz6YJGIgv0EWiVVvWCuYoblOmj4SQuhEJF
        DQOT2XIcCbQg264qbOqJwLYBESgHoB1E8V91z8zaaAtVvxSRgrTaVOYAKCPnIlmQ7+Mc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pUIPT-005YNQ-T2; Tue, 21 Feb 2023 03:29:39 +0100
Date:   Tue, 21 Feb 2023 03:29:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Tom Rix <trix@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steen.hegelund@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lan743x: LAN743X selects FIXED_PHY to resolve a
 link error
Message-ID: <Y/QskwGx+A1jACB2@lunn.ch>
References: <20230219150321.2683358-1-trix@redhat.com>
 <Y/JnZwUEXycgp8QJ@corigine.com>
 <Y/LKpsjteUAXVIb0@lunn.ch>
 <Y/MXNWKrrI3aRju+@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/MXNWKrrI3aRju+@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 07:46:13AM +0100, Simon Horman wrote:
> On Mon, Feb 20, 2023 at 02:19:34AM +0100, Andrew Lunn wrote:
> > On Sun, Feb 19, 2023 at 07:16:07PM +0100, Simon Horman wrote:
> > > On Sun, Feb 19, 2023 at 10:03:21AM -0500, Tom Rix wrote:
> > > > A rand config causes this link error
> > > > drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netdev_open':
> > > > drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference to `fixed_phy_register'
> > > > 
> > > > lan743x_netdev_open is controlled by LAN743X
> > > > fixed_phy_register is controlled by FIXED_PHY
> > > > 
> > > > So LAN743X should also select FIXED_PHY
> > > > 
> > > > Signed-off-by: Tom Rix <trix@redhat.com>
> > > 
> > > Hi Tom,
> > > 
> > > I am a little confused by this.
> > > 
> > > I did manage to cook up a config with LAN743X=m and FIXED_PHY not set.
> > > But I do not see a build failure, and I believe that is because
> > > when FIXED_PHY is not set then a stub version of fixed_phy_register(),
> > > defined as static inline in include/linux/phy_fixed.h, is used.
> > > 
> > > Ref: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/phy_fixed.h?h=main&id=675f176b4dcc2b75adbcea7ba0e9a649527f53bd#n42
> > 
> > I'n guessing, but it could be that LAN743X is built in, and FIXED_PHY
> > is a module? What might be needed is
> > 
> > depends on FIXED_PHY || FIXED_PHY=n
> 
> Thanks Andrew,
> 
> LAN743X=y and FIXED_PHY=m does indeed produce the problem that Tom
> describes. And his patch does appear to resolve the problem.

O.K. So the commit message needs updating to describe the actual
problem.

> Unfortunately your proposed solution seems to run foul of a complex
> dependency situation.

I was never any good at Kconfig. Arnd is the expert at solving
problems like this.

You want either everything built in, or FIXED_PHY built in and LAN743X
modular, or both modular.

     Andrew
