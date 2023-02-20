Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0A669C3F3
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 02:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjBTBTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 20:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBTBTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 20:19:51 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6057A80;
        Sun, 19 Feb 2023 17:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ffYEjqsipoo5Z0haRaM9dRCFCHidxtBN3H+wTaMVNZ0=; b=paKMic56Tre33qM4zASsP7Vifq
        gWkIqpb4XIJZHUKdy4Y5JUYRob/DG1NWQy74hr8gPHaQBrwbwpDzDqy5J6r0LH30hMC4hFw9APAln
        JS6kFeUKOQqYMU3TG7fqT6RcAFsQRb8FFGpPFIP8R9GGbmAIbOn+BBDOFGQwLvPsH0Hc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTuq6-005T1J-8y; Mon, 20 Feb 2023 02:19:34 +0100
Date:   Mon, 20 Feb 2023 02:19:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Tom Rix <trix@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steen.hegelund@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: lan743x: LAN743X selects FIXED_PHY to resolve a
 link error
Message-ID: <Y/LKpsjteUAXVIb0@lunn.ch>
References: <20230219150321.2683358-1-trix@redhat.com>
 <Y/JnZwUEXycgp8QJ@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/JnZwUEXycgp8QJ@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 07:16:07PM +0100, Simon Horman wrote:
> On Sun, Feb 19, 2023 at 10:03:21AM -0500, Tom Rix wrote:
> > A rand config causes this link error
> > drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netdev_open':
> > drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference to `fixed_phy_register'
> > 
> > lan743x_netdev_open is controlled by LAN743X
> > fixed_phy_register is controlled by FIXED_PHY
> > 
> > So LAN743X should also select FIXED_PHY
> > 
> > Signed-off-by: Tom Rix <trix@redhat.com>
> 
> Hi Tom,
> 
> I am a little confused by this.
> 
> I did manage to cook up a config with LAN743X=m and FIXED_PHY not set.
> But I do not see a build failure, and I believe that is because
> when FIXED_PHY is not set then a stub version of fixed_phy_register(),
> defined as static inline in include/linux/phy_fixed.h, is used.
> 
> Ref: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/phy_fixed.h?h=main&id=675f176b4dcc2b75adbcea7ba0e9a649527f53bd#n42

I'n guessing, but it could be that LAN743X is built in, and FIXED_PHY
is a module? What might be needed is

depends on FIXED_PHY || FIXED_PHY=n

	Andrew
