Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39665455FA1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhKRPh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhKRPh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 10:37:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAF3C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 07:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q0UaIYt3KOZ0azhRYf3EdbyBFPj3Ta9pbRL+Dqk02gQ=; b=YFBOOxR975pmvRCRX7VhBOqZHy
        Yv9ChigUZQ7jh5FWWPf4ELMU+XnhADLTz5xJD/Y8xHqNll2bYSSS1mdHn8BniXDWLKqrxjxUoDsQw
        /DmCs/anc7uA3S/1vsHeuVCM3onCeapsl77E27M9WQOTMkipHVD1hxLzUes3JKCwPrcOmAXTsDNkD
        P7a7ACQM0ICVow2ANNrrwGWUTDkfFlOkFYCaPZjCnmcxnBqK9KXahSbKoF67WG0jIIKenuFmMAVe3
        fujveQ1lobw5UqatkOoZZ4FCgBq1XkdUVtnAlL4Gu21NvCXdOQVviMHja2mdcsK9rekpXKRIeRTcq
        3EL9kocQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55724)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnjR6-000368-Ae; Thu, 18 Nov 2021 15:34:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnjR2-000423-6l; Thu, 18 Nov 2021 15:34:48 +0000
Date:   Thu, 18 Nov 2021 15:34:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        Antoine Tenart <atenart@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Milind Parab <mparab@cadence.com>
Subject: Re: [net-next PATCH v6] net: macb: Fix several edge cases in validate
Message-ID: <YZZymBHimAhx8lja@shell.armlinux.org.uk>
References: <20211112190400.1937855-1-sean.anderson@seco.com>
 <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
 <684f843f-e5a7-e894-d2cc-3a79a22faf36@seco.com>
 <YZRLQqLblRurUd4V@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZRLQqLblRurUd4V@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 12:22:26AM +0000, Russell King (Oracle) wrote:
> On Tue, Nov 16, 2021 at 05:56:43PM -0500, Sean Anderson wrote:
> > Hi Russell,
> > 
> > I have a few questions/comments about your tree (and pl in general).
> > This is not particularly relevant to the above patch, but this is as
> > good a place as any to ask.
> > 
> > What is the intent for the supported link modes in validate()? The docs
> > say
> 
> The _link_ modes describe what gets reported to userspace via the
> ethtool APIs, and therefore what appears in ethtool as the supported
> and advertised capabilities for the media, whatever the "media" is
> defined to be.
> 
> Generally, the "media" is what the user gets to play with to connect
> two network interfaces together - so twisted pair, fibre, direct-attach
> cable, etc.
> 
> > > Note that the PHY may be able to transform from one connection
> > > technology to another, so, eg, don't clear 1000BaseX just
> > > because the MAC is unable to BaseX mode. This is more about
> > > clearing unsupported speeds and duplex settings. The port modes
> > > should not be cleared; phylink_set_port_modes() will help with this.
> > 
> > But this is not how validate() has been/is currently implemented in many
> > drivers. In 34ae2c09d46a ("net: phylink: add generic validate
> > implementation"), it appears you are hewing closer to the documented
> > purpose (e.g. MAC_1000FD selects all the full-duplex 1G link modes).
> > Should new code try to stick to the above documentation?
> 
> I try to encourage new code to stick to this - and this is one of the
> motivations behind moving to this new model, so people don't make
> these kinds of mistakes.
> 
> In the case of nothing between the MAC and the media performing any
> kind of speed conversion, the MAC itself doesn't have much to do with
> which ethtool link modes are supported - and here's why.
> 
> Take a gigabit capable MAC that is connected via SGMII to a PHY that
> supports both conventional twisted-pair media and fiber. If the
> twisted-pair port is in use at 1G speeds, then we're using 1000base-T.
> If the fiber port is being used, then we're using 1000base-X. The
> protocol between the PHY and MAC makes no difference to what link
> modes are supported.
> 
> A more extreme case could be: a 10G MAC connected to a backplane PHY
> via 10G BASE-KR which is then connected to a PHY that connects to
> conventional twisted-pair media.
> 
> Or a multi-speed PHY where it switches between SGMII, 2500BASE-X,
> 5GBASE-R, 10GBASE-R depending on the results of negotiation on the
> twisted-pair media. The MAC supports operating at 10M, 100M, 1G,
> 2.5G, 5G, and 10G speeds, and can select between PCS that support
> SGMII, 2500BASE-X, 5GBASE-R and 10GBASE-R. However, ultimately for
> userspace, what matters is the media capabilities - the base-T*
> ethtool link modes. 2500base-X in this situation doesn't come up
> unless the PHY offers 2500base-X on the media.
> 
> The same PHY might be embedded within a SFP module, and that SFP
> module might be plugged into a cage where the MAC is unable to
> support the faster speeds - maybe it is only capable of up to
> 2.5G speeds. In which case, the system supports up to 2500BASE-T.
> 
> So you can see, the MAC side has little relevance for link modes
> except for defining the speeds and duplexes that can be supported.
> The type of media (-T, -X, -*R) is of no concern at this stage.
> 
> It is of little concern at the PCS except when the PCS is the
> endpoint for connecting to the media (like it is in _some_ 802.3z
> connections.) I say "some" because its entirely possible to use
> 1000base-X to talk to a PHY that connects to 1000base-T media
> (and there are SFPs around that will do this by default.)
> 
> > Of course, the above leaves me quite confused about where the best place
> > is to let the PCS have a say about what things are supported, and (as
> > discussed below) whether it can support such a thing. The general
> > perspective taken in existing drivers seems to be that PCSs are
> > integrated with the MAC. This is in contrast to the IEEE specs, which
> > take the pespective that the PCS is a part of the PHY. It's unclear to
> > me what stance the above documentation takes.
> 
> Things can get quite complex, and I have to say the IEEE specs give
> a simplified view. When you have a SGMII link to a PHY that then
> connects to twisted pair media, you actually have multiple PCS:
> 
>                                  PHY
>                       /----------------------\
> MAC -- PCS ---<SGMII>--- PCS --- PCS --- PMA ---- media
>      (sgmii)           (sgmii)   (1000baseT)
> 
> This can be seen in PHYs such as Marvell 88E151x, where the fiber
> interface is re-used for SGMII, and if you read the datasheet and/or
> read the fiber page registers, you find that this is being used for
> the fiber side. So the PHY can be thought of two separate PHYs
> back-to-back. Remember that the PCS for 1000BASE-X (and SGMII) is
> different from the PCS for 1000BASE-T in IEEE802.3.
> 
> The point I'm making here is that the capability of the link between
> the MAC and the PHY doesn't define what the media link modes are. It
> may define the speeds and duplexes that can be supported, and that
> restricts the available link modes, but it doesn't define which
> media "technologies" can be supported.
> 
> Hence, for example, the validate() implementation masking out
> 1000base-X but leaving 1000base-T on a *GMII link is pretty silly,
> because whether one or the other is supported depends ultimately
> what the *GMII link ends up being connected to.
> 
> > Consider the Xilinx 1G PCS. This PCS supports 1000BASE-X and SGMII, but
> > only at full duplex. This caveat already rules out a completely
> > bitmap-based solution (as phylink_get_linkmodes thinks that both of
> > those interfaces are always full-duplex).
> 
> I don't see why you say this rules out a bitmap solution. You say that
> it only supports full-duplex, and that is catered for in the current
> solution: MAC_10 for example is actually MAC_10HD | MAC_10FD - which
> allows one to specify that only MAC_10FD is supported and not MAC_10HD
> in such a scenario.
> 
> Hmm. Also note that the validate() callback is not going away -
> phylink_generic_validate() is a generic implementation of this that
> gets rid of a lot of duplication and variability of implementation
> that really shouldn't be there.
> 
> There are cases where the generic implementation will not be suitable,
> and for this phylink_get_linkmodes() can be called directly, or I'd
> even consider making phylink_caps_to_linkmodes() available if it is
> useful. Or one can do it the "old way" that we currently have.
> 
> > There are also config options
> > which (either as a feature or a consequence) disable SPEED_10 SGMII or
> > autonegotiation (although I don't plan on supporting either of those).
> > The "easiest" solution is simply to provide two callbacks like
> > 
> > 	void pcs_set_modes(struct phylink_pcs *pcs, ulong *supported,
> > 			   phy_interface_t interface);
> > 	bool pcs_mode_supported(struct phylink_pcs *pcs,
> > 				phy_interface_t interface, int speed,
> > 				int duplex);
> > 
> > perhaps with some generic substitutes. The former would need to be
> > called from mac_validate, and the latter from mac_select_pcs/
> > mac_prepare. This design is rather averse to genericization, so perhaps
> > you have some suggestion?
> 
> I don't have a good answer for you at the moment - the PCS support
> is something that has been recently added and is still quite young,
> so these are the kinds of issues I'd expect to crop up.
> 
> > On the subject of PCS selection, mac_select_pcs should supply the whole
> > state.
> 
> That may seem like a good thing to ask for, but not even phylink
> knows what the full state is when calling the validation function,
> nor when calling mac_select_pcs.
> 
> Let's take an example of the Marvell 88X3310 multi-speed PHY, which
> supports 10G, 5G, 2.5G, 1G, 100M and 10M on copper, and 1G and 100M
> on fiber, and can do all of that while connected to a single serdes
> connection back to the MAC. As I've said above, it does this by
> switching its MAC connection under its internal firmware between
> 10000Base-R, 5000Base-R, 2500Base-X, and SGMII. This PHY has been
> found to be used in platforms, and discovered to also be in SFP
> modules. Beyond programming the overall "host interface" mode, we
> don't get a choice in which mode the PHY picks - that is determined
> by the results of which interface comes up and autonegotiation on
> that interface.
> 
> So, if the PHY decides to link on copper at 2500BASE-T, then we end
> up with the MAC link operating at 2500BASE-X, and there's nothing
> we can do about that.
> 
> The only way to restrict this is to know ahead of time what the
> capabilities of the MAC and PCSes are, and to restrict the link
> modes that phylib gives us in both the "supported" and "advertising"
> fields, so the PHY will be programmed to e.g. not support 2500BASE-T
> on copper if 2500BASE-X is not supported by the PCS, or 2.5G speeds
> are not supported by the MAC.
> 
> This isn't something one can do when trying to bring the link up,
> it's something that needs to be done when we are "putting the system
> together" - in other words, when we are binding the PHY into the
> link setup.
> 
> Now, this is quite horrible right now, because for PHYs like this,
> phylink just asks the MAC's validate function "give me everything
> you can support" when working this out - which won't be sufficient
> going forward. With some of the changes you've prompted - making
> more use of the supported_interfaces bitmap, and with further
> adaption of phylib to also provide that information, we can start to
> work out which interface modes the PHY _could_ select, and we can then
> query the validate() function for what is possible for each of those
> interface modes, and use that to bound the PHY capabilities. However,
> at the moment, we just don't have that information available from
> phylib.
> 
> > This is because the interface alone is insufficient to determine
> > which PCS to select. For example, a PCS which supports full duplex but
> > not half duplex should not be selected if the config specifies half
> > duplex. Additionally, it should also support a selection of "no pcs".
> 
> Right now, "no pcs" is really not an option I'm afraid. The presence
> of a PCS changes the phylink behaviour slightly . This is one of my
> bug-bears. The evolution of phylink has meant that we need to keep
> compatibility with how phylink used to work before we split the PCS
> support - and we detect that by whether there is a PCS to determine
> whether we need to operate with that compatibility. It probably was
> a mistake to do that in hind sight.
> 
> If we can find a way to identify the old vs new drivers that doesn't
> rely on the presence of a PCS, then we should be able to fix this to
> allow the PCS to "vanish" in certain modes, but I do question whether
> there would be any realistic implementations using it. If we have a
> PHY connected to a serdes lane back to a set of PCS to support
> different protocols on the serdes, then under what scenario would we
> select "no pcs" - doesn't "no pcs" in that situation mean "we don't
> know what protocol to drive the serdes link" ?
> 
> > Otherwise MACs which (optionally!) have PCSs will fail to configure. We
> > should not fail when no PCS has yet been selected or when there is no
> > PCS at all in some hardware configuration.  Further, why do we have this
> > callback in the first place? Why don't we have drivers just do this in
> > prepare()?
> 
> I added mac_select_pcs() because finding out that something isn't
> supported in mac_prepare() is way too late - as explained above
> where I talked about binding the PHY into the link setup. E.g. if
> the "system" as a whole can't operate at 2.5G speeds, then we should
> not allow the PHY to advertise 2500BASE-T. It is no good advertising
> 2500BASE-T, then having the PHY negotiate 2500BASE-T, select 2500BASE-X,
> and then have mac_prepare() decide that can't be supported. The link
> won't come up, and there's nothing that can be sensibly done. The
> user sees the PHY indicating link, the link partner indicates link,
> but the link is non-functional. That isn't a good user experience.
> 
> Whereas, if we know ahead of time that 2.5G can't be supported, we can
> remove 2500BASE-T from the advertisement, and the PHY will instead
> negotiate a slower speed - resulting in a working link, albiet slower.
> 
> I hope that explains why it is so important not to error out in
> mac_prepare() because something wasn't properly handled in the
> validate() step.

What I haven't described in the above (it was rather late when I was
writing that email!) is where we need to head with a PHY that does
rate adaption - and yet again an example of such a PHY is the 88X3310.
This is actually a good example for many of the issues right now.

If the 88X3310 is configured to have a host interface that only
supports 10GBASE-R, then rate adaption within the PHY is activated,
meaning the PHY is able to operate at, e.g. 10BASE-T while the host
MAC operates at 10GBASE-R. There are some provisos to this though:

1) If the 88X3310 supports MACSEC, then it has internal MACs that
   are able to generate pause frames, and pause frames will be sent
   over the 10GBASE-R link as necessary to control the rate at which
   the MAC sends packets.

2) If the 88X3310 does not support MACSEC, then it is expected that
   the MAC is paced according to the link speed to avoid overflowing
   the 88X3310 internal FIFOs (what happens when the internal FIFOs
   overflow is not known.) There are no pause frames generated.
   (This is the case on Macchiatobin boards if we configured the PHY
   for 10GBASE-R rate-adaption mode.)

We have no "real" support for rate adaption at either phylib or phylink
level - phylib has no way to tell us whether rate adaption is enabled
on the PHY, nor does it have a way to tell us if we either need to pace
the MAC or whether to expect pause frames from the PHY.

If we have a PHY in rate adaption mode, the current behaviour will be
that mac_link_up() and pcs_link_up() will be passed the negotiated
media parameters as "speed", "duplex" and any flow control information,
which will confuse PCS and MAC drivers at the moment, because it isn't
something they expect to happen. What I mean is, if we are using
PHY_INTERFACE_MODE_10GBASER, then most people will expect "speed" to be
SPEED_10000, but with a rate adapting PHY it may not be.

In order to properly support this, we need to update the documentation
at the very least to say that what gets passed to mac_link_up() for
"speed" and "duplex" are the media negotiated parameters. Then we need
to have a think about how to handle flow control, and this is where
extending phylib to tell us whether the PHY supports rate adaption
becomes important. Flow control on the MAC needs to be enabled if (the
PHY has rate adaption disabled but the media negotiated flow control)
or (the PHY has rate adaption enabled _and_ the PHY is capable of
issuing flow control frames - presumably the PHY will respond itself
to flow control) or (the PHY has rate adaption enabled and the media
negotiated flow control but the PHY is not capable of issuing flow
control frames).

Then there's the issue of implementing transmission pacing in any MAC
driver that wants to be usable with a rate adapting PHY.

Lastly, there's the issue of the "speed" and "duplex" parameters passed
to pcs_link_up(), which I'm currently thinking should be the interface
parameters and not the media parameters. In other words, if it's a
10GBASE-R connection between the PHY and PCS, we really should not be
passing the media negotiated speed there.

So, to sum up, rate adaption isn't something that is well supported in
the kernel - it's possible to bodge around phylib and phylink to make
it work, but this really needs to be handled properly.


Rate adaption is fairly low priority at the moment as it is in a
minority, although it seems we are seeing more systems that have PHYs
with this feature.

So, I hope these two emails have provides some useful insights.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
