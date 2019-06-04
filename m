Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2B2352E9
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFDW7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:59:25 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46852 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFDW7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 18:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LwrHbRw1EUYrSGGzEDs/kPUSWBlRRmmmk3bhtU19WX4=; b=ziXqlsQHiSjmjqk6c9jBX4PCt
        GZwKbvpd0biFaV614fnrLSWRtH0qusrH/ep1ddN+HXqA2nNcZnyZ5OLDN0k6GVlkO9WLBtHYTw9Nj
        /MXrvq4vCnDPl3z5VhtlU07qdDxLlFZsIzNSQV3LQZRhKKkfI6zO4jBti4T4SWjYTMQ1ckKFmHLyD
        kVmEi4LTbSbagMtm8euPI8jPmiK+Q34LuGDyxrNBTge/I2m4eoqYpbIoirD0qe8JrIUXs7r2lar4U
        GHpCvXMTSoaQvTqir6X+6mo5rda5Q6a0Qapa+7Ramez7l2oWOsa+iHWxvdVzICKRl9TSOuHGQQ1th
        WW1NlHnGA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38508)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYIOn-00046C-9M; Tue, 04 Jun 2019 23:59:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYIOl-0001rU-Cn; Tue, 04 Jun 2019 23:59:19 +0100
Date:   Tue, 4 Jun 2019 23:59:19 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch>
 <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch>
 <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com>
 <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk>
 <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 01:44:08AM +0300, Vladimir Oltean wrote:
> You caught me.
> 
> But even ignoring the NIC case, isn't the PHY state machine
> inconsistent with itself? It is ok with callink phy_suspend upon
> ndo_stop, but it won't call phy_suspend after phy_connect, when the
> netdev is implicitly stopped?

The PHY state machine isn't inconsistent with itself, but it does
have strange behaviour.

When the PHY is attached, the PHY is resumed and the state machine
is in PHY_READY state.  If it goes through a start/stop cycle, the
state machine transitions to PHY_HALTED and attempts to place the
PHY into a low power state.  So the PHY state is consistent with
the state machine state (we don't end up in the same state but with
the PHY in a different state.)

What we do have is a difference between the PHY state (and state
machine state) between the boot scenario, and the interface up/down
scenario, the latter behaviour having been introduced by a commit
back in 2013:

    net: phy: suspend phydev when going to HALTED

    When phydev is going to HALTED state, we can try to suspend it to
    safe more power. phy_suspend helper will check if PHY can be suspended,
    so just call it when entering HALTED state.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
