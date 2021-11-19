Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4EC4576D0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbhKSS7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235722AbhKSS7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 13:59:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0785EC061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 10:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dg/bvCCMq/WkqcwMqJ6ySbnOW22EI0P5QFX8u3Wz1i8=; b=a24wvDKf+WqO7sjpEQx94Ejj2f
        i6loQ2ZywpAwbjrjC2Yry/u9pdST3mr/Q2KKptEGH+gdRQWvuIyrZz9tRf5flKJcEKvyVHa6/gY2w
        MoxKBbx/kd1Z67w8iEE3m83BZQvo27qUeZAElGNWLO7cYJer+9ytSGpH6tfhBhkjYkCOnAxSSkL3r
        844GCpZNKbqtM+7KsQSORIBt38uQUvMvumQT9NSLPWxGLNUN3Ydvsy44VE8ZvMWOXLNGUqFTpJ6/h
        cApxsPWe79mCLGR3DSxYkP6JqCHwymAuM3Ff5mx/4u9RbhoNUYSNyJD8GdPnlE0cMTZC1qw3GZAha
        Jx4UQ1Rg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55746)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mo93V-0004G4-KB; Fri, 19 Nov 2021 18:56:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mo93R-000561-44; Fri, 19 Nov 2021 18:56:09 +0000
Date:   Fri, 19 Nov 2021 18:56:09 +0000
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
Message-ID: <YZfzSQBECA3Ew+IE@shell.armlinux.org.uk>
References: <20211112190400.1937855-1-sean.anderson@seco.com>
 <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
 <684f843f-e5a7-e894-d2cc-3a79a22faf36@seco.com>
 <YZRLQqLblRurUd4V@shell.armlinux.org.uk>
 <YZZymBHimAhx8lja@shell.armlinux.org.uk>
 <cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfcb368f-a785-9ea5-c446-1906eacd8c03@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On Thu, Nov 18, 2021 at 03:20:18PM -0500, Sean Anderson wrote:
> Hi Russell,
> 
> On 11/18/21 10:34 AM, Russell King (Oracle) wrote:
> > On Wed, Nov 17, 2021 at 12:22:26AM +0000, Russell King (Oracle) wrote:
> > > It is of little concern at the PCS except when the PCS is the
> > > endpoint for connecting to the media (like it is in _some_ 802.3z
> > > connections.) I say "some" because its entirely possible to use
> > > 1000base-X to talk to a PHY that connects to 1000base-T media
> > > (and there are SFPs around that will do this by default.)
> 
> Of course, since 1000BASE-X is not an electrical specification, this is
> really more like using 1000BASE-CX to 1000BASE-T :)

I'd disagree with that statement for the following reason:

With reference to the IEEE 802.3 1000BASE-X sublayers that are
described in diagram 36-1, section 38 and section 39.

Practically, a SoC implements a 1000BASE-X PCS, and a serdes block
that produces and receives the appropriate waveform on a balanced
pair, one for transmit and one for receive.

These balanced pairs can be routed to a 1000BASE-SX transceiver,
1000BASE-LX transceiver, or a 1000BASE-CX cable. One very likely
scenario where this can be seen practically is with a SFP cage.
The balanced pairs are routed to the SFP cage, and the medium is
entirely dependent on what kind of SFP is plugged in - whether
it is a LX, SX or CX compliant module.

Section 39.3 clearly defines 1000BASE-CX in terms of TP2 and TP3.
Section 38.2.1 is similar except for 1000BASE-SX/LX. Both states
that the electrical specification at points TP1 and TP4 are
electrical, but are not compliance points, and their parameters
are unspecified by IEEE 802.3.

How, this point (TP1/TP4) (which is about the division point
between the PMA and PMD) can also be connected to a PHY or DSA
switch. This doesn't change what TP1/TP4 is.

So, while it may be tempting to call the 1000BASE-X serdes
connection between the PMA and whatever it's connected to
1000BASE-CX, it is incorrect to do so unless it really does
consist of a jumper cable, as called out by section 39.1.

It may be that the electrical specifications of 1000BASE-CX at
TP2 and TP3 are the same as what can be measured at TP1 and TP4,
but that doesn't in my mind make it 1000BASE-CX.

Also note that 1000BASE-CX has a minimum operating distance of
0.1m, which is probably hard to achieve on many PCBs.

> > > Things can get quite complex, and I have to say the IEEE specs give
> > > a simplified view. When you have a SGMII link to a PHY that then
> > > connects to twisted pair media, you actually have multiple PCS:
> > > 
> > >                                  PHY
> > >                       /----------------------\
> > > MAC -- PCS ---<SGMII>--- PCS --- PCS --- PMA ---- media
> > >      (sgmii)           (sgmii)   (1000baseT)
> > > 
> > > This can be seen in PHYs such as Marvell 88E151x, where the fiber
> > > interface is re-used for SGMII, and if you read the datasheet and/or
> > > read the fiber page registers, you find that this is being used for
> > > the fiber side. So the PHY can be thought of two separate PHYs
> > > back-to-back. Remember that the PCS for 1000BASE-X (and SGMII) is
> > > different from the PCS for 1000BASE-T in IEEE802.3.
> 
> Right and this is a bit of the source of the confusion. There are
> different levels/layers of PHYs all with their own PCS/PMA/PMD stack.
> Depending on what perspective you take at the time, some of these can be
> subsumed into each other.

Right. One thing I didn't mention in the above is that such a PHY
looks after its MAC-facing PCS - there is generally no need for
management software to touch that PCS, since it is generally
configured by the hardware strapping of the PHY itself. Sometimes
(such as Marek's situation where he wishes to switch the operating
mode of the PHY from 10GBASE-R with rate adaption to USXGMII) it
may be required to reconfigure the PHY, but in terms of overall
link management, this PCS tends to be transparent.

Therefore, currently, there is no need to model this PCS, and
trying to do so until there is a need would add extra unnecessary
complexity - put another way, it would be over-design.

> > > The point I'm making here is that the capability of the link between
> > > the MAC and the PHY doesn't define what the media link modes are. It
> > > may define the speeds and duplexes that can be supported, and that
> > > restricts the available link modes, but it doesn't define which
> > > media "technologies" can be supported.
> 
> Right. IMO there is a lot of conflation of this concept in the current
> net subsystem. Realistically, the MAC should only be concerned with the
> phy interface mode, and perhaps duplex and speed. But! This should be
> the interface mode needed to talk to *the next stage in the signal
> path*.

You may be surprised that I agree with you, and this is the direction
I'm trying to move phylink towards. Before March 2020, phylink didn't
even consider there to be a separate PCS, so the separated PCS with
its own "ops" structure is really rather new and young.

However, we have to take all the current users along with us and keep
them working while we make changes - we can't just break everything
to implement an entirely new model. Consequently, change takes time,
effort and care.

> That is, if the MAC has GMII output and needs a separate PCS to
> talk 1000BASE-X or SGMII, it should only report GMII. And then the PCS
> can say what kind of interface it supports. However, the current model
> assumes that the PCS is tightly integrated, so these sorts of things are
> not modeled well. I don't know whether the above change would be
> feasable at all. Ideally, validate() would talk about interfaces modes
> and not link modes.

It is tightly integrated at the moment precisely because phylink has
its origins in the Marvell platforms of about September 2015, where
there was no separately identifyable PCS block despite it having
gigabit serdes and being capable of SGMII, 1000BASE-X and 2500BASE-X
on that serdes, as well as RGMII etc. Even in RGMII mode, everything
most of the configuration is hidden behind one register.

I do believe that the hardware does indeed have a PCS block - it's
just that Marvell decided to have one register that controls both the
MAC and PCS as if they are a single piece of hardware.

> Say that you are a MAC with an integrated PCS (so you handle everything
> in the MAC driver). You support GMII full and half duplex, but your PCS
> only supports 1000BASE-X with full duplex. The naïve bitmap is
> 
> supported_interfaces = PHY_INTERFACE_GMII | PHY_INTERFACE_1000BASEX;
> mac_capabilities = MAC_10 | MAC_100 | MAC_1000;
> 
> but this will report 1000BASE-X as supporting both full and half duplex.
> So you still need a custom validate() in order to report the correct link
> modes.

First, let me say that I've now been through all phylink users in the
kernel, converting them, and there are seven cases where the generic
helper can't be used. The validate() method isn't going away (at least
not just yet) which allows unexpected situations to still be handled.
The current state of this conversion is as follows.

In terms of network drivers:

mvneta and mvpp2: the generic helper is used but needs to be wrapped
  since these specify that negotiation must not be disabled in
  "1000BASE-X" mode, which includes the up-clocked 2500BASE-X.

stmmac: when there is no PCS attached, there is no clues from the
  driver which PHY interface modes are supported. I am in discussion
  with Jose about this.

In terms of DSA drivers:

bcm_sf2: pause mode support appears to be dependent on the interface
  mode.

  I have loads of questions about this driver in general, and have had
  for some time. E.g. bcm_sf2_sw_mac_config() makes it look like
  although RGMII is supported, RGMII_RXID and RGMII_ID are not.
  However, it has been established that the RGMII* modes defines the
  delays on the PHY end of the link, so this should be of no
  consequence on the MAC end... I regard this driver as needing
  attention, and probably a poor choice to draw any conclusions from.

hellcreek: this can probably be converted - it looks like it only ever
  contains copper PHYs which operate at a single fixed speed. phylib
  should restrict the link modes to baseT modes based on the PHYs,
  so specifying MAC_100FD or MAC_1000FD depending on
  hellcreek->pdata->is_100_mbits gets us the MAC capabilities.
  However, it is unknown which PHY interface mode is used in this
  driver, consequently I can't populate the supported_interfaces
  without assistance from the author.

mt7530: apparently, autoneg is not supported on TRGMII nor 802.3z
  interface modes on these switches. I don't yet know enough about
  TRGMII to comment on that, but it's a little surprising for
  802.3z (aka 1000BASE-X) because it means it restricts its use
  with fiber.

xrs700x: absolutely no information on which interface modes may be
  supported - the driver makes no attempt to check the interface
  mode anywhere in its code - it will accept anything we throw at
  it. I haven't researched to find any public information on it
  that may throw light on what it supports yet.

On the flip side:

- six ethernet drivers convert over to using phylink_generic_validate
directly, as does macb in its current form (although I haven't sent
those patches due to the open questions we have on it.)

- eight DSA drivers convert over to using phylink_generic_validate.

So we have fourteen drivers which lend themselves to this new model
really well, substantially reducing the amount of code that needs to
be looked after.

Now, I know this doesn't match your model, but it is a step closer
towards it. Why do I say this?

I have entirely eliminated the basex helper that writes to
state->interface in the validate() callback. This may not seem to be
significant, but it is - this is the reason why we have been passing
in the "state" and "supported" parameters in and requiring the
implementations to do the bitmap AND operations, rather than just
returning a bitmap of supported ethtool linkmodes.

The second thing that becomes possible through this change is we can
now find out from the MAC's validate() function what is supported for
a particular set of PHY interface modes. So, for example:
1) with the 88X3310 PHY operating in SGMII, 2500BASE-X, 5GBASE-R and
   10GBASE-R modes, we can ask for just these interface modes, rather
   than requesting everything that the PHY supports.
2) with a SFP, we can ask what is supported only for the PHY interface
   modes that would be appropriate to the cage and/or the SFP plugged
   in.

This makes it more practical to think about how to move forward towards
splitting the PCS part of validation from the MAC validate() callback.
Once we have a solution for that, then we can likely think about how to
get rid of the MAC dealing with ethtool linkmodes at all.

Rather than rush into this immediately, I want to let all these drivers
settle after this change - give time for any bugs that I may have
introduced to be shaken out and fixed. I'm not perfect, but I've given
this my best shot - and since I can't test beyond a build-test of this,
it's probably going to require a full kernel release cycle before we
really know whether anything has been broken.

> The tricky part comes in a scenario where the exact MAC is determined at
> runtime, such as the MACB+Xilinx PCS configuration.

We don't model multiple MACs - but we do have situations where we have
multiple MACs already. For example, Marvell mvpp2 has multiple MACs -
one for <=2.5G (GMAC) and another for >2.5G (XLG) and we deal with
that all in the driver. At this stage, I don't think we should begin to
start discussing any kind of model for this, otherwise I fear the
discussion will get too complex - let's concentrate on one issue at a
time.

> > > Right now, "no pcs" is really not an option I'm afraid. The presence
> > > of a PCS changes the phylink behaviour slightly . This is one of my
> > > bug-bears. The evolution of phylink has meant that we need to keep
> > > compatibility with how phylink used to work before we split the PCS
> > > support - and we detect that by whether there is a PCS to determine
> > > whether we need to operate with that compatibility. It probably was
> > > a mistake to do that in hind sight.
> 
> Of course it's an option :)

I'm saying that with phylink as it is, phylink does _not_ support there
being no PCS in a non-legacy driver, since the presence of a PCS is a
flag that the driver is non-legacy. It changes the circumstances in
which the mac_config() method is called.

If we want the PCS to become optional, then we need phylink to deal with
detecting non-legacy drivers some other way (e.g. a legacy-mode flag in
struct phylink_config), or we need to eliminate the legacy drivers by
either converting them (which is always my preference) or deleting them.

> > > I added mac_select_pcs() because finding out that something isn't
> > > supported in mac_prepare() is way too late - as explained above
> > > where I talked about binding the PHY into the link setup. E.g. if
> > > the "system" as a whole can't operate at 2.5G speeds, then we should
> > > not allow the PHY to advertise 2500BASE-T. It is no good advertising
> > > 2500BASE-T, then having the PHY negotiate 2500BASE-T, select 2500BASE-X,
> > > and then have mac_prepare() decide that can't be supported. The link
> > > won't come up, and there's nothing that can be sensibly done. The
> > > user sees the PHY indicating link, the link partner indicates link,
> > > but the link is non-functional. That isn't a good user experience.
> > > 
> > > Whereas, if we know ahead of time that 2.5G can't be supported, we can
> > > remove 2500BASE-T from the advertisement, and the PHY will instead
> > > negotiate a slower speed - resulting in a working link, albiet slower.
> 
> AIUI it's a bug in the driver to advertise something in validate() which
> it can't support.

Right now, it's a bug in the driver if validate() allows bits in the
supported mask or advertising mask to be set that the MAC or the PCS
are unable to support - and that goes _just_ for speeds, duplexes,
pause modes, and autoneg. It does not apply to media technologies,
nor port modes.

Restricting the media technologies is the responsibility of the PHY
when a PHY is present (so all those drivers that decide to only
allow the ethtool 1000baseX_Full bit when in 1000BASE-X mode, but
otherwise allow 1000baseT_Full are themselves buggy.)

In the case of:

MAC --- PCS --- non-SFP Media

Then we will currently get all the linkmodes advertised - unless
something restricts them, and currently with stmmac + xpcs, the
xpcs driver restricts the link modes. That said, if we have
stmmac + xpcs + phy, restricting to 10/100/1000BASE-T is pretty
silly when the PHY could be something like a Marvell 88E151x which
supports automedia between copper and fiber (and thus supports
1000BASE-X).

What constitutes the ethtool link modes really comes down to being
the responsibility of the device that's connecting to the media
coupled with the speed/duplex/pause capabilities of the blocks
leading back to the system. Even the "Autoneg" ethtool bit is
irrelevant for preceeding blocks if there's a PHY on the end that
performs autonegotiation - but it becomes more relevant when the
PCS the last modelled block before the media.

> > > I hope that explains why it is so important not to error out in
> > > mac_prepare() because something wasn't properly handled in the
> > > validate() step.
> 
> Specifically, "I don't need a PCS for this mode" should be a valid
> response. I agree that "I can't select a PCS" doesn't make sense.

If we are going to involve the PCS inside phylink as suggested above,
it may actually become a problem not to have a PCS, even when there
isn't one in the strict sense according to IEEE 802.3. It's a bit like
the model we've had for fixed-links prior to phylink - which was to
emulate a PHY in software that phylib can talk to complete with its
own set of MDIO registers.

> > What I haven't described in the above (it was rather late when I was
> > writing that email!) is where we need to head with a PHY that does
> > rate adaption - and yet again an example of such a PHY is the 88X3310.
> > This is actually a good example for many of the issues right now.
> > 
> > If the 88X3310 is configured to have a host interface that only
> > supports 10GBASE-R, then rate adaption within the PHY is activated,
> > meaning the PHY is able to operate at, e.g. 10BASE-T while the host
> > MAC operates at 10GBASE-R. There are some provisos to this though:
> > 
> > 1) If the 88X3310 supports MACSEC, then it has internal MACs that
> >     are able to generate pause frames, and pause frames will be sent
> >     over the 10GBASE-R link as necessary to control the rate at which
> >     the MAC sends packets.
> > 
> > 2) If the 88X3310 does not support MACSEC, then it is expected that
> >     the MAC is paced according to the link speed to avoid overflowing
> >     the 88X3310 internal FIFOs (what happens when the internal FIFOs
> >     overflow is not known.) There are no pause frames generated.
> >     (This is the case on Macchiatobin boards if we configured the PHY
> >     for 10GBASE-R rate-adaption mode.)
> 
> Well if it just drops/corrupts packets then it just looks like a
> lossy/congested link. And the upper layers of the network stack already
> expect that sort of thing (though perhaps not optimally).

I don't think you've thought this through. If you stuff the transmit
FIFO and you end up with a partial packet in the FIFO that the PHY
starts to transmit, the packet will not end up hitting the wire in
a complete form, and _every_ node on the network that receives that
packet is going to flag an error and increment its error counters.
I'm not saying this is what the PHY will do - I don't really know
what it will do if the pacing requirement isn't satisfied. However,
as it doesn't contain a MAC internally, it likely doesn't check the
checksum on the received data. Does it implement store-and-forward,
we don't know.

I wonder what your thoughts are if you do "ip -s li" and you see errors
reported on the receive side of your network interface? Would you
assume it's one particular machine on your network causing it, and
would you then seek to remove it from your network, or would you
suspect a cabling issue or problem with a network switch?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
