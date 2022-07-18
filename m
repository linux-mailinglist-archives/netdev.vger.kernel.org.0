Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17C7578737
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiGRQXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbiGRQW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:22:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25442A73C;
        Mon, 18 Jul 2022 09:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tU1M0l6iXcdV+YPLLftDmPI8G3v7jAoMtfkYILmdfLE=; b=MVTsRrFbnK/qW6g8A1WcrIka45
        EyTq3BHKXSdIo6aqcTe09mj8ZNYcWBKvbKfGn724iZ0P0u9jx5SwLcniDEqdK2gbPMoipAwzNe7S9
        vq55+L+d5CeTe9JSQKJgLP7hkHzguH6VmZ9E9B1mTjNVB0Jk4Tb3I0iMyVj06bi2mPQyUdj7wDzRo
        4PfnQHJF2Vp37LwweC+IvHeqJq6RlvkZAlSO9zRz74ypmyvRqVigF+N5S4BEhl9S+K0KBHaz2HnEw
        fv4jLHxEzMqaScE3jZrdnKglUK1Vu7EFHme/IlEoryMawVZf0Z+j3VnSUiERPlaP7CypogrCIOXx7
        yJE2jISQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33422)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDTW1-0001pV-4k; Mon, 18 Jul 2022 17:22:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDTVz-00026J-Ah; Mon, 18 Jul 2022 17:22:35 +0100
Date:   Mon, 18 Jul 2022 17:22:35 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 10/47] net: phylink: Adjust link settings
 based on rate adaptation
Message-ID: <YtWIy2C/5Xf1CseG@shell.armlinux.org.uk>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-11-sean.anderson@seco.com>
 <YtMc2qYWKRn2PxRY@lunn.ch>
 <4172fd87-8e51-e67d-bf86-fdc6829fa9b3@seco.com>
 <YtNoW8bJdWPzX3Cq@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtNoW8bJdWPzX3Cq@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 03:39:39AM +0200, Andrew Lunn wrote:
> > > I would not do this. If the requirements for rate adaptation are not
> > > fulfilled, you should turn off rate adaptation.
> > > 
> > > A MAC which knows rate adaptation is going on can help out, by not
> > > advertising 10Half, 100Half etc. Autoneg will then fail for modes
> > > where rate adaptation does not work.
> > 
> > OK, so maybe it is better to phylink_warn here. Something along the
> > lines of "phy using pause-based rate adaptation, but duplex is %s".
> 
> You say 1/2 duplex simply does not work with rate adaptation. So i
> would actually return -EINVAL at the point the MAC indicates what
> modes it supports if there is a 1/2 duplex mode in the list.

If we have a PHY that supports rate adaption using pause frames, which
implies a full duplex link between the PHY and MAC, one would hope that
someone isn't silly enough to integrate it with a half-duplex only MAC.

This ought to be handled while bringing up the PHY. If the PHY uses
pause frames but the MAC doesn't support full-duplex at the PHY
interface speed, then we should not allow the PHY to do rate adaption.
The easiest way to achieve that is to not allow the PHY to advertise
anything except the PHY interface speed on its media. If that means
there's nothing to advertise, then we fail.

> Right, so we need a table somewhere in the documentation listing the
> different combinations and what should happen.
> 
> If the MAC does not support rx_pause, rate adaptation is turned off.
> If the negotiation results in no rx_pause, force it on anyway with
> Pause based adaptation. If ethtool turns pause off, turn off rate
> adaptation.

That last bit is really awkward - what if the link partner is doing 100M
on the media because that's the fastest it's capable of, but our local
PHY is doing rate adaption to 1G, and we turn pause off, causing rate
adaption in the PHY to be turned off. We need to reconfigure the
advertisement to drop anything except the 1G speed and renegotiate the
link, which will cause the link to go down.

That's going to be really odd behaviour for a user to get their head
around.

> Does 802.3 say anything about this?

I think rate adaption is out of scope of 802.3.

> We might also want to add an additional state to the ethtool get for
> pause, to indicate rx_pause is enabled because of rate adaptation, not
> because of autoneg.

That may well be a much better approach; it lets the user see what is
going on and it becomes more understandable to the user IMHO.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
