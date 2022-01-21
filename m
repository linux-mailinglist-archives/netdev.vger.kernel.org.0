Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3490D495F7A
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 14:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380580AbiAUNKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 08:10:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47714 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380571AbiAUNKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 08:10:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VjS0OJn+RpvVLKj4BixmF3/YwNqhhxyxBg835FSGE74=; b=LhiRWcFnbEfnZOEVCTTP/G1djQ
        iyILYSYuNwQvEKuVrnZ8zVaRUOLDfPQ8/7dPib+5YX7FhJTw+RL7YcDABEZJu04+tikfRwWb6InvT
        oY+pWFz98oqxhg1Qy02ygnZ5qgamEQnW4yyp/S7xLUdraHgdqxo4BHKyoys8aFnyGaBo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAtgX-0025JU-Vt; Fri, 21 Jan 2022 14:10:33 +0100
Date:   Fri, 21 Jan 2022 14:10:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <YeqwyeVvFQoH+9Uu@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <Yelnzrrd0a4Bl5AL@lunn.ch>
 <CAAd53p45BbLy0T8AG5QTKhP00zMBsMHfm7i-bTmZmQWM5DpLnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p45BbLy0T8AG5QTKhP00zMBsMHfm7i-bTmZmQWM5DpLnQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > -static void marvell_config_led(struct phy_device *phydev)
> > > +static int marvell_find_led_config(struct phy_device *phydev)
> > >  {
> > > -     u16 def_config;
> > > -     int err;
> > > +     int def_config;
> > > +
> > > +     if (phydev->dev_flags & PHY_USE_FIRMWARE_LED) {
> > > +             def_config = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL);
> > > +             return def_config < 0 ? -1 : def_config;
> >
> > What about the other two registers which configure the LEDs?
> 
> Do you mean the other two LEDs? They are not used on this machine.

Have you read the datasheet for the PHY? It has three registers for
configuring the LEDs. There is one register which controls the blink
mode, a register which controls polarity, and a third register which
controls how long each blink lasts, and interrupts. If you are going
to save the configuration over suspend/resume you probably need to
save all three.

This last register is also important for WoL, which is why i asked
about it.

      Andrew
