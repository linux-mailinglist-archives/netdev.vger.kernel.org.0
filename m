Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D5C203F7D
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbgFVSwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730030AbgFVSwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 14:52:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171EBC061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 11:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=el9CBF/MChoTmqYeUxXW7N7aMlYT/V2wEflqdmbOlsg=; b=KV+4cOwV9nhsJPa3R2o4cytI4
        NM7f48drW+3Na0vMxdlZXZ3bE9bNzRWzsOWfNNSebT9//H+xS1g1GGeog+jXa7ZIHquw0TeZsU2o6
        HeN1ZeNrN9zk3w/MjWQhLKUw+PGyG0ueIbJyE/ENB0Fu6sEyGuVrfEAcotu0tGvtw96RDcXovPCYh
        LcZgTVj61kPZTYrX1b6C4D6ybIivRRI0Z8LvK2dK2J3SXNbVduQSYtT+8DFM4aRwbpUCVqZugkYOa
        aw0H0XgJrxVQ7LWUROVSnSwDY+pftqZ/bvGtu3b4szocSobEOwE7zL4l9Cwf9hbTgO/+vTXExxVR0
        Ml3Q4CiPw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58978)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnRYf-0000jI-Lf; Mon, 22 Jun 2020 19:52:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnRYf-0000HN-9B; Mon, 22 Jun 2020 19:52:41 +0100
Date:   Mon, 22 Jun 2020 19:52:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Daniel Mack <daniel@zonque.org>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports
 with internal PHY
Message-ID: <20200622185241.GM1551@shell.armlinux.org.uk>
References: <20200622183443.3355240-1-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622183443.3355240-1-daniel@zonque.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 08:34:43PM +0200, Daniel Mack wrote:
> Ports with internal PHYs that are not in 'fixed-link' mode are currently
> only set up once at startup with a static config. Attempts to change the
> link speed or duplex settings are currently prevented by an early bail
> in mv88e6xxx_mac_config(). As the default config forces the speed to
> 1000M, setups with reduced link speed on such ports are unsupported.
> 
> Change that, and allow the configuration of all ports with the passed
> settings.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
> Russell,
> 
> This changes the behaviour implemented in c9a2356f35409a ("net:
> dsa: mv88e6xxx: add PHYLINK support"). Do you recall why your code
> didn't touch the MLO_AN_PHY mode links in the first place?

The reason is that's how it was before - each port with a PHY has
PHY polling enabled, which means that the PPU (phy polling unit)
reads the PHY state and updates the port with that.  The port
follows whatever the state of the PHY, and that does not require
phylink to program the port.

I believe it to be incorrect to force ports where the PPU is
enabled, and since Marvell DSA switches have always had the PPU
enabled, it is incorrect to force these ports.

Note that there was no change in behaviour - the code was originally
doing this prior to phylink:

static void mv88e6xxx_adjust_link(struct dsa_switch *ds, int port,
                                  struct phy_device *phydev)
{
        struct mv88e6xxx_chip *chip = ds->priv;
        int err;

        if (!phy_is_pseudo_fixed_link(phydev))
                return;

        mutex_lock(&chip->reg_lock);
        err = mv88e6xxx_port_setup_mac(chip, port, phydev->link, phydev->speed,
                                       phydev->duplex, phydev->interface);
        mutex_unlock(&chip->reg_lock);

        if (err && err != -EOPNOTSUPP)
                dev_err(ds->dev, "p%d: failed to configure MAC\n", port);
}

So the internal PHYs (phys which are not a pseudo fixed-link) were
being ignored before my code.

As is normal for me, when ever I convert something from one thing to
another, I try to preserve as much of the original behaviour as
possible, and with regard to the issue that you raise, I preserved
the behaviour for the internal PHYs.

Hence, I believe your patch to be incorrect.

What problem are you seeing, and with which switch?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
