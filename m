Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259296B9C38
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjCNQxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCNQxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:53:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB212109;
        Tue, 14 Mar 2023 09:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dchTFOWcpOz0w7UHfp2ykSo2qzEkxKQuhSWO0cv59nc=; b=ZUazO1n1xC0Kw5A0zOtlxU7f6X
        WQaj2pCl/E9Bud6olWVqaMm1xYMFP5fKC3OHXcGWU5JsgPrH8hbT16noe8ZtVDbJCE8tviX0aX4jO
        g7DwJPKkvgN3BzNtNkZl70wGPsCC3TZDEjwhk16qtao1LRTEHx+CG46aEezXumyyMrfs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pc7tP-007JPf-J6; Tue, 14 Mar 2023 17:52:55 +0100
Date:   Tue, 14 Mar 2023 17:52:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: mscc: fix deadlock in
 phy_ethtool_{get,set}_wol()
Message-ID: <0a017d9f-168e-4c6e-a061-68118e8e635e@lunn.ch>
References: <20230314153025.2372970-1-vladimir.oltean@nxp.com>
 <a9bfe427-4d76-44ea-9890-3b0c44ccb551@lunn.ch>
 <20230314164547.5s55hmoeytrdevvb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314164547.5s55hmoeytrdevvb@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 06:45:47PM +0200, Vladimir Oltean wrote:
> On Tue, Mar 14, 2023 at 05:31:45PM +0100, Andrew Lunn wrote:
> > [Goes and checks to see if the same problem exists for other PHY drivers]
> 
> Here's a call path I am not sure how to interpret (but doesn't look like
> there's anything preventing it).
> 
> linkstate_get_sqi()
> -> mutex_lock(&phydev->lock)
>    -> phydev->drv->get_sqi(phydev);
>       -> lan87xx_get_sqi()
>          -> access_ereg()
>             -> lan937x_dsp_workaround()
>                -> mutex_lock(&phydev->lock);
>                -> mutex_unlock(&phydev->lock);
> -> mutex_unlock(&phydev->lock)

I noticed access_ereg() as well. But i don't think there have been any
recent changes there. Lots loop in the Microchip developers.

       Andrew
