Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DEF6D5BF7
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbjDDJdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjDDJde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:33:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A90125
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 02:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZshVpJKHSKEtaL2NMLWmdiwgw6h830G7eTTKvvrmesE=; b=ofD/TCzGjJFaR/e5Ex+nA2aIvr
        W4e7bqIv6ioXUCkzxRoFxazHZbkwL2diSALCR7HLaM0E5KZxXMoVTw71dXJx8O8n8QmHvTGQlfUFf
        r/k8tAs/8JSfvq91NrmKKk8u+GDTdQFqQHByRU5hlC+VxI+dbze04kTqpxpv1O8SLKj1k5O54otKJ
        B/YJHduTp8w13vqFK+9wUXmQq7GVOq/NYk3UzWn8wU4nFCsfeniNqRRmXfM7ED6TzX/8OLw6lchTB
        9576LzXoHpwyLorfGR4OcCK9GuftteDzt/ZSX74MaVtcPqeO+woTy58zyeUM4V6uR1OjVhF3S2Zlb
        fLi3/2dw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51518)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjd2c-0003rB-1k; Tue, 04 Apr 2023 10:33:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjd2X-00059J-JE; Tue, 04 Apr 2023 10:33:21 +0100
Date:   Tue, 4 Apr 2023 10:33:21 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        John Crispin <john@phrozen.org>
Subject: Re: Convention regarding SGMII in-band autonegotiation
Message-ID: <ZCvu4YpUAUSUBPRd@shell.armlinux.org.uk>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCtvaxY2d74XLK6F@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

First thing I'll say is that bear in mind that historically Linux
didn't have any standard for using (or not) the in-band messages in
SGMII and 1000base-X. That was a big mistake in my opinion, and
leads to some of the problems today, where we're trying to have
things work consistently for the sake of SFP support.

In order to combat this, I try to ensure that phylink-using
implementations are consistent. Hence why I was insistent that
mtk_sgmii behaves in a particular way w.r.t enabling in-band mode.
Even if it doesn't solve everything, it is consistent with many of
the other implementations, which means if we want to change it in
the future, we can do so across all implementations.

As previously stated, one of the things I want to do is lift the
decision about whether in-band mode should be enabled in the PCS up out
of the PCS driver into phylink so the PCS driver doesn't need to be
making those decisions. I have some patches for that but they aren't
going anywhere until the MV88E6XXX DSA driver gets sorted out and
converted to phylink_pcs. This is the _last_ phylink based driver that
isn't using phylink_pcs for SGMII/1000base-X protocols. For that
conversion to happen, I need to get the default-to-fastest-speed
patches merged as a pre-requisit, but those have been a major problem
for a year now and whatever solution I propose there are always
objections to it. The current solution (using swnodes) was Vladimir's
suggestion, but the swnode people hate it, and I hate their
suggestions of how to make it acceptable to them (because to do it
correctly, I'm quite sure the DSA maintainers will then object
because it will have to be in the DSA core code again. I am at the
point of giving up with it, because there seems to be no way forward
that *everyone* finds acceptable. As a direct result of this, I've
more or less stopped doing much proper phylink development because
the patches will just continue to back up.

Maybe the right answer is not to do that, but to let mv88e6xxx rot
and hope that some day someone has the will power to solve the
problems - and if that means mv88e6xxx breaks, then so be it (but
that goes against the "no regressions" rule, so also can't really
be done.)

On Tue, Apr 04, 2023 at 01:29:31AM +0100, Daniel Golle wrote:
> Hi!
> 
> I've been dealing with several SGMII TP PHYs, some of them with support
> for 2500Base-T, by switching to 2500Base-X interface mode (or by using
> rate-adaptation to 2500Base-X or proprietary HiSGMII).
> 
> Dealing with such PHYs in MAC-follow-PHY-rate-mode (ie. not enabling
> rate-adaptation which is worth avoiding imho) I've noticed that the
> current behavior of PHY and MAC drivers in the kernel is not as
> consistent as I assumed it would be.

Yes, rate adaption comes with it a bunch of issues such as always
having to have pause frames recognised by the MAC, or having the
requirement to increase the inter-packet gap (which no MAC driver
currently supports).

However, switching the interface mode *requires* us to know what the
PHY is doing, so the PHY must be accessible in order for this to be
even remotely possible.

> Background:
> From Russell's comments and the experiments carried out together with
> Frank Wunderlich for the MediaTek SGMII PCS found in mtk_eth_soc I
> understood that in general in-band autonegotiation should always be
> switched off unless phylink_autoneg_inband(mode) returns true, ie.
> mostly in case 'managed = "in-band-status";' is set in device tree,
> which is generally the case for SFP cages or PHYs which are not
> accessible via MDIO.

Not quite, the rule for consistent behaviour is:

- When operating in *SGMII modes, then:
   - if in-band AN mode, SGMII in-band mode should be enabled.
   - otherwise SGMII in-band mode disabled.

  Let's be clear what SGMII in-band mode is. It is *not* negotiation.
  The PCS doesn't advertise anything. The PHY doesn't take action and
  change what it's doing as a result of what it receives from the PCS.
  It is status passing from the PHY to the PCS, and an acknowledgement
  by the PCS back to the PHY. Nothing more.

- When operating in an 802.3z mode, then
   - if in-band AN mode and the Autoneg bit is set, then 802.3z in-band
       mode should be enabled.
   - otherwise 802.3z in-band mode should be disabled.

The reason for the Autoneg bit with 802.3z, particularly 1000base-X, is
that these protocols are designed as the _media_ protocol, like
1000baseT, and thus they are proper negotiation between two ends of the
link. As such, the user needs to be able to turn on/off this
negotiation, and the accepted way to do that is via the Autoneg bit in
the advertising mask.

There are implementations where 1000base-X (and 2500base-X) is
documented as requiring in-band negotiation to always be enabled,
and as such they have a pcs_validate() function that rejects such a
combination.

Conversely, there are implementations where 2500base-X is documented
as not having in-band negotiation, and of course implementations where
1000base-X can have in-band enabled/disabled.

2500base-X is a total mess because it was not a standard, but
manufacturers decided to offer it and went off and did their own
thing. Many took their implementation and just increased the clock
rate to 3.125GHz from 1.25GHz, thus meaning that everything which
was offered at 1.25GHz clock rate is there for the faster rate.
Some document that AN isn't supported, but when you try it, it
works (because it's literally just 1000base-X up-clocked.)

Just like the "AN must always be enabled when not in SGMII mode" on
mvneta and mvpp2 hardware, the statement that AN isn't supported in
2500base-X in documentation is rather questionable.

> As of today this is what pcs-mtk-lynxi is now doing as this behavior
> was inherited from the implementation previously found at
> drivers/net/ethernet/mediatek/mtk_sgmii.c.
> 
> Hence, with MLO_AN_PHY we are expecting both MAC and PHY to *not* use
> in-band autonegotiation. It is not needed as we have out-of-band status
> using MDIO and maybe even an interrupt to communicate the link status
> between the two. Correct so far?

Correct - and the reason is because, like it or not, there *are* PHYs
out there that do *not* provide any in-band status when operating in
SGMII mode, and there is *no* *way* to get them to do so... and those
PHYs do get used on SFP modules. So, we need a way for MAC/PCS to be
told to operate without in-band status.

This is exactly what MLO_AN_PHY mode is - it's a mode where we read
the status from the PHY manually, and configure the PCS and MAC
according to that read status.

> I've also previously worked around this using Vladimir Oltean's patch
> series introducing sync'ing and validation of in-band-an modes between
> MAC and PHY -- however, this turns out to be overkill in case the
> above is true and given there is a way to always switch off in-band-an
> on both, the MAC and the PHY.
> 
> Or should PHY drivers setup in-band AN according to
> pl->config->ovr_an_inband...?

That is out of reach of PHY drivers, and don't forget that phylink is
optional, many MAC drivers use phylib directly without phylink.

> Also note that the current behavior of PHY drivers is that consistent:

We definitely *need* consistency in how phylink is implemented in PCS
and MACs if we're going to stand a chance of SFPs behaving the same
no matter what they're plugged in to. More importantly for this point
is maintenance of phylink - if we have differing behaviours, then it
_will_ make future maintenance of phylink utterly impossible, as
attempting to fix or change the behaviour for one implementation could
end up breaking another if each make different decisions.

> 
>  * drivers/net/phy/mxl-gpy.c
>    This goes through great lengths to switch on inband-an when initially
>    coming up in SGMII mode, then switches is off when switching to
>    2500Base-X mode and after that **never switches it on again**. This
>    is obviously not correct and the driver can be greatly reduced if
>    dropping all that (non-)broken logic.
>    Would a patch like [1] this be acceptable?
> 
>  * drivers/net/phy/realtek.c
>    The driver simply doesn't do anything about in-band-an and hence looks
>    innocent. However, all RTL8226* and RTL8221* PHYs enable in-band-an
>    by default in SGMII mode after reset. As many vendors use rate-adapter-
>    mode, this only surfaces if not using the rate-adapter and having the
>    MAC follow the PHY mode according to speed, as we do using [2] and [3].
> 
>    SGMII in-band AN can be switched off using a magic sequence carried
>    out on undocumented registers [5].
> 
>    Would patches [2], [3], [4], [5] be acceptable?

Before phylink, PHYs were free to do anything they like with in-band
modes, as long as the PHY and MAC combination that was being used
agreed. This leads to some PHYs that phylib has drivers for having
in-band enabled in SGMII mode (with or without managed = "in-band"
in DT) others may have it disabled.

The problem now is trying to get consistent behaviour can cause
regressions.

Introducing PHY interface switching to existing drivers can also be
problematical - that's only something we introduced to phylib when I
added the 88x3310 Marvell 10G PHY driver, and after we discussed the
problem. At that time, it was a new phylib driver and so there weren't
any MAC drivers, so we could make both the phylib and MAC drivers
deal with phydev->interface changing. Before this happened,
phydev->interface was constant that could be relied upon to never
change, so MAC drivers in general do not expect it to change.

Adding the ability for phydev->interface to change for existing
phylib drivers brings with it the obvious can of worms - are the MAC
drivers that are using that phylib driver setup to cope with the
interface mode changing? If they aren't, then clearly we can't
change the PHY's behaviour to switch its interface mode until the
MAC drivers have been updated.


The overall message in my reply is essentially one of caution - yes
we can make changes to how PHYs work, but we need to audit the MAC
drivers that the PHY is used with to try to cut down on unexpected
regressions.

> 
> 
> Thank you for your advise!
> 
> 
> Daniel
> 
> [1]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/mediatek/patches-5.15/731-net-phy-hack-mxl-gpy-disable-sgmii-an.patch;hb=HEAD
> [2]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/721-net-phy-realtek-rtl8221-allow-to-configure-SERDES-mo.patch;hb=HEAD
> [3]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/722-net-phy-realtek-support-switching-between-SGMII-and-.patch;hb=HEAD
> [4]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/724-net-phy-realtek-use-genphy_soft_reset-for-2.5G-PHYs.patch;hb=HEAD
> [5]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/725-net-phy-realtek-disable-SGMII-in-band-AN-for-2-5G-PHYs.patch;hb=HEAD

Eww, when clicking on those links, Firefox downloads them, and then when
I click on them, it decides to open Libreoffice Writer to view them!
Would've been nicer if Firefox could have displayed them directly.

In patch [4], isn't normal behaviour that a soft reset does not change
the programmed settings in the PHY? That is certainly true for Marvell
PHYs (which need to be frequently hit with a soft-reset after changing
settings to make them active). Do Realtek PHYs reset the register
contents on soft-reset?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
