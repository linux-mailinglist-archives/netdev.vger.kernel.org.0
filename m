Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A423352F36B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352963AbiETSs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352945AbiETSs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:48:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4391413274F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l4gdrKPvi7EaVVStoMKo1MY2tIZ7RD7uJ6iHGfEjhR8=; b=G92N75Q4cwIy9Z6WaG5ip+xRcL
        XanV1eMtyC01pXIceDJJAAgFL2Poeg5a5FxmC4eyjqskk+MixggmneiEkIx+7WUqRNpZKWv64aWAw
        CCNoMi3WggIbZr2C8FJMZDn+mQTl5ydww+/K5+oZlHUQREJ3o++jTwiAT+JZM24uX2QU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ns7fg-003g7V-Rm; Fri, 20 May 2022 20:48:20 +0200
Date:   Fri, 20 May 2022 20:48:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, olteanv@gmail.com,
        hkallweit1@gmail.com, f.fainelli@gmail.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <YofidJtb+kVtFr6L@lunn.ch>
References: <20220520004500.2250674-1-kuba@kernel.org>
 <YoeIj2Ew5MPvPcvA@lunn.ch>
 <20220520111407.2bce7cb3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520111407.2bce7cb3@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I was looking at bnxt because it's relatively standard for DC NICs and
> doesn't have 10M lines of code.. then again I could be misinterpreting
> the code, I haven't tested this theory:
> 
> In bnxt_set_pauseparam() for example the driver will send a request to
> the FW which will result in the link coming down and back up with
> different settings (e.g. when pause autoneg was changed). Since the
> driver doesn't call netif_carrier_off() explicitly as part of sending
> the FW message but the link down gets reported thru the usual interrupt
> (as if someone yanked the cable out) - we need to wrap the FW call with
> the __LINK_STATE_NOCARRIER_LOCAL

I'm not sure this is a good example. If the PHY is doing an autoneg,
the link really is down for around a second. The link peer will also
so the link go down and come back up. So this seems like a legitimate
time to set the carrier off and then back on again.

> > The driver has a few netif_carrier_off() calls changed to
> > netif_carrier_admin_off(). It is then unclear looking at the code
> > which of the calls to netif_carrier_on() match the off.
> 
> Right, for bnxt again the carrier_off in bnxt_tx_disable() would become
> an admin_carrier_off, since it's basically part of closing the netdev.

> > Maybe include a driver which makes use of phylib, which should be
> > doing control of the carrier based on the actual link status.
> 
> For phylib I was thinking of modifying phy_stop()... but I can't
> grep out where carrier_off gets called. I'll take a closer look.

If the driver is calling phy_stop() the link will go down. So again, i
would say setting the carrier off is correct. If the driver calls
phy_start() an auto neg is likely to happen and 1 second later the
link will come up.

Maybe i'm not understanding what you are trying to count here. If the
MAC driver needs to stop the MAC in order to reallocate buffers with
different MTU, or more rings etc, then i can understand not wanting to
count that as a carrier off, because the carrier does not actually go
off. But if it is in fact marking the carrier off, it sounds like a
MAC driver bug, or a firmware bug.

    Andrew
