Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D413FF716
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239588AbhIBWZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbhIBWZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 18:25:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF784C061575;
        Thu,  2 Sep 2021 15:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PBzyx3b13E88ZqIykmsooULNl81ACAy1mgmIEC9rA0w=; b=MoZ1ROTlk9qs+uyOJbq2GbS3C
        tG9jBwKyPz4AFi2V0PPrU2hxzC0RTyzfEkx8bRMPch2u9AIJFVTW485ufyrH0eu/SKgn1R+VY2EKr
        kHgRB0TKyAslZLruVCsf/2j86V/bgLQDdb3jAJa4AYXftByhZ+CirOtSnWFRH5AKjeFU8Ofnh2ziQ
        sFdngdrSQqFXAC7XH54BbP2c7qUQLnOpF09HImFm5KCNGpRRA5RtJnhWnrY2Eg7o/0RohBsKofG1l
        kYUsu0TDoTS0ozsAmJKcGyy++8zP+HHJoquEWVO+rrDMcieN8IJ1mukzywkCWvLcmgjXVuPJlPaiG
        sGwMyDoMg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48116)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLv8S-00028L-Mj; Thu, 02 Sep 2021 23:24:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLv8R-0008HC-5I; Thu, 02 Sep 2021 23:24:39 +0100
Date:   Thu, 2 Sep 2021 23:24:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210902222439.GQ22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk>
 <YTErTRBnRYJpWDnH@lunn.ch>
 <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
 <20210902213303.GO22278@shell.armlinux.org.uk>
 <20210902213949.r3q5764wykqgjm4z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902213949.r3q5764wykqgjm4z@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 12:39:49AM +0300, Vladimir Oltean wrote:
> On Thu, Sep 02, 2021 at 10:33:03PM +0100, Russell King (Oracle) wrote:
> > That's probably an unreliable indicator. DPAA2 has weirdness in the
> > way it can dynamically create and destroy network interfaces, which
> > does lead to problems with the rtnl lock. I've been carrying a patch
> > from NXP for this for almost two years now, which NXP still haven't
> > submitted:
> > 
> > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=cex7&id=a600f2ee50223e9bcdcf86b65b4c427c0fd425a4
> > 
> > ... and I've no idea why that patch never made mainline. I need it
> > to avoid the stated deadlock on SolidRun Honeycomb platforms when
> > creating additional network interfaces for the SFP cages in userspace.
> 
> Ah, nice, I've copied that broken logic for the dpaa2-switch too:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d52ef12f7d6c016f3b249db95af33f725e3dd065
> 
> So why don't you send the patch? I can send it too if you want to, one
> for the switch and one for the DPNI driver.

Sorry, I mis-stated. NXP did submit that exact patch, but it's actually
incorrect for the reason I stated when it was sent:

https://patchwork.ozlabs.org/project/netdev/patch/1574363727-5437-2-git-send-email-ioana.ciornei@nxp.com/

I did miss the rtnl_lock() around phylink_disconnect_phy() in the
description of the race, which goes someway towards hiding it, but
there is still a race between phylink_destroy() and another thread
calling dpaa2_eth_get_link_ksettings(), and priv->mac being freed:

static int
dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
                             struct ethtool_link_ksettings *link_settings)
{
        struct dpaa2_eth_priv *priv = netdev_priv(net_dev);

        if (dpaa2_eth_is_type_phy(priv))
                return phylink_ethtool_ksettings_get(priv->mac->phylink,
                                                     link_settings);

which dereferences priv->mac and priv->mac->phylink, vs:

static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
{
...
        if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {
                dpaa2_eth_set_mac_addr(netdev_priv(net_dev));
                dpaa2_eth_update_tx_fqids(priv);

                if (dpaa2_eth_has_mac(priv))
                        dpaa2_eth_disconnect_mac(priv);
                else
                        dpaa2_eth_connect_mac(priv);
        }

static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
{
        if (dpaa2_eth_is_type_phy(priv))
                dpaa2_mac_disconnect(priv->mac);

        if (!dpaa2_eth_has_mac(priv))
                return;

        dpaa2_mac_close(priv->mac);
        kfree(priv->mac);		<== potential use after free bug by
        priv->mac = NULL;		<== dpaa2_eth_get_link_ksettings()
}

void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
{
        if (!mac->phylink)
                return;

        phylink_disconnect_phy(mac->phylink);
        phylink_destroy(mac->phylink);	<== another use-after-free bug via
					    dpaa2_eth_get_link_ksettings()
        dpaa2_pcs_destroy(mac);
}

Note that phylink_destroy() is documented as:

 * Note: the rtnl lock must not be held when calling this function.

because it calls sfp_bus_del_upstream(), which will take the rtnl lock
itself. An alternative solution would be to remove the rtnl locking
from sfp_bus_del_upstream(), but then force _everyone_ to take the
rtnl lock before calling phylink_destroy() - meaning a larger block of
code ends up executing under the lock than is really necessary.

However, as I stated in my review of the patch "As I've already stated,
the phylink is not designed to be created and destroyed on a published
network device." That still remains true today, and it seems that the
issue has never been fixed in DPAA2 despite having been pointed out.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
