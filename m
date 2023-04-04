Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA78C6D65B2
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 16:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjDDOq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 10:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjDDOqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:46:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35772F7
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 07:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TZAaXRuS1LFMcxVBM+B66bRRYzWSVnFOpYPt9k8QVYQ=; b=08TZfXBHqxsehZdrjCfII9HM/t
        n0tc+nbIt62nVgJdT1C67gZH1Bvo4w/J11H0Kys43CFeV+ulTJEASzdFI6QTN+mAQzqUHBEXfJKlk
        mbnU570l73DcDJdtVfuoepnjWW/qGsGB/oze2uDb3YU2mF9nqBDBmfnJ56q/Rvc++5dndSFuZJRen
        5iDkgybHwIIlz/4FUwR0GJdsViknxMjC2LSF1oERyRfHqOx9BM22gfQZ1KD7WNhuYswnbcMDxbafX
        gjw+6M/5PLGgd/pFBPFUHrg0bGn3/3s7m9pW131K2Jt/vLVPTjOf2NQkWV3k3yXGe4DrpmUHBhAxT
        e3W9irLQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44724)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjhvq-0004Kn-U9; Tue, 04 Apr 2023 15:46:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjhvl-0005MR-AL; Tue, 04 Apr 2023 15:46:41 +0100
Date:   Tue, 4 Apr 2023 15:46:41 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        John Crispin <john@phrozen.org>
Subject: Re: Convention regarding SGMII in-band autonegotiation
Message-ID: <ZCw4UUAiTi1/yjUA@shell.armlinux.org.uk>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
 <ZCvu4YpUAUSUBPRd@shell.armlinux.org.uk>
 <ZCwQePDCuvlX3wu5@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCwQePDCuvlX3wu5@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:56:40PM +0100, Daniel Golle wrote:
> > On Tue, Apr 04, 2023 at 01:29:31AM +0100, Daniel Golle wrote:
> > > Hi!
> > > 
> > > I've been dealing with several SGMII TP PHYs, some of them with support
> > > for 2500Base-T, by switching to 2500Base-X interface mode (or by using
> > > rate-adaptation to 2500Base-X or proprietary HiSGMII).
> > > 
> > > Dealing with such PHYs in MAC-follow-PHY-rate-mode (ie. not enabling
> > > rate-adaptation which is worth avoiding imho) I've noticed that the
> > > current behavior of PHY and MAC drivers in the kernel is not as
> > > consistent as I assumed it would be.
> > 
> > Yes, rate adaption comes with it a bunch of issues such as always
> > having to have pause frames recognised by the MAC, or having the
> > requirement to increase the inter-packet gap (which no MAC driver
> > currently supports).
> 
> Yeah, that matches my understanding of the story. Sadly, AQR PHYs are
> all usually setup with rate adaption switched on, now I understand the
> reason for that are Marvell's MAC drivers...

Not just MAC drivers, but MAC hardware. It turns out that the mvpp2 in
Armada 8040 commonly shipped with Macchiatobin just does *not* support
flow control. You wouldn't know that from reading the documentation,
but one of their engineers who submitted patches in the last few
years explained that it needs firmware support (as in a blob running
in the device) but that isn't present on earlier versions.

Wonderful.

So the only possibility for such mvpp2 is enlarging IPG, and there is
a register for that. Whether that works or not is another matter.

> > However, switching the interface mode *requires* us to know what the
> > PHY is doing, so the PHY must be accessible in order for this to be
> > even remotely possible.
> 
> Thank you for confirming this and spelling out the details.

Well, if we don't have access to the PHY:

1) we can't know what the media negotiated, so we don't know what the
   media speed is, and thus we won't know what IPG to use. All that we
   would know is the speed of the interface between MAC/PCS and PHY.

2) we can't know what interface mode it is using if it switches its
   interface mode according to the media.

Basically, for any PHY that operates with multiple different media
speeds, the only way it can sanely work is if we can access and
properly drive the PHY.

The one exception to that would be where the PHY does rate adaption
using pause frames, the MAC supports pause frames, and we know that
rate adaption is in use (so we know we need to enable RX pause
frames at the MAC.) Even with that, not having access to the PHY, we
have no idea what duplex it has negotiated (although pause frames
will slow down the MAC) and we also have no idea whether pause modes
were negotiated on the media side.

Essentially, having a PHY that is unaccessible isn't particularly
good news, and whether it works or not (which may depend on the
media side resolution) will be entirely hit and miss. I don't
think there is much we can do about that, other than maybe advising
people that that's what one gets with hardware that can't be
accessed.

> > > Background:
> > > From Russell's comments and the experiments carried out together with
> > > Frank Wunderlich for the MediaTek SGMII PCS found in mtk_eth_soc I
> > > understood that in general in-band autonegotiation should always be
> > > switched off unless phylink_autoneg_inband(mode) returns true, ie.
> > > mostly in case 'managed = "in-band-status";' is set in device tree,
> > > which is generally the case for SFP cages or PHYs which are not
> > > accessible via MDIO.
> > 
> > Not quite, the rule for consistent behaviour is:
> > 
> > - When operating in *SGMII modes, then:
> >    - if in-band AN mode, SGMII in-band mode should be enabled.
> >    - otherwise SGMII in-band mode disabled.
> > 
> >   Let's be clear what SGMII in-band mode is. It is *not* negotiation.
> >   The PCS doesn't advertise anything. The PHY doesn't take action and
> >   change what it's doing as a result of what it receives from the PCS.
> >   It is status passing from the PHY to the PCS, and an acknowledgement
> >   by the PCS back to the PHY. Nothing more.
> > 
> > - When operating in an 802.3z mode, then
> >    - if in-band AN mode and the Autoneg bit is set, then 802.3z in-band
> >        mode should be enabled.
> >    - otherwise 802.3z in-band mode should be disabled.
> > 
> > The reason for the Autoneg bit with 802.3z, particularly 1000base-X, is
> > that these protocols are designed as the _media_ protocol, like
> > 1000baseT, and thus they are proper negotiation between two ends of the
> > link. As such, the user needs to be able to turn on/off this
> > negotiation, and the accepted way to do that is via the Autoneg bit in
> > the advertising mask.
> > 
> > There are implementations where 1000base-X (and 2500base-X) is
> > documented as requiring in-band negotiation to always be enabled,
> > and as such they have a pcs_validate() function that rejects such a
> > combination.
> > 
> > Conversely, there are implementations where 2500base-X is documented
> > as not having in-band negotiation, and of course implementations where
> > 1000base-X can have in-band enabled/disabled.
> > 
> > 2500base-X is a total mess because it was not a standard, but
> > manufacturers decided to offer it and went off and did their own
> > thing. Many took their implementation and just increased the clock
> > rate to 3.125GHz from 1.25GHz, thus meaning that everything which
> > was offered at 1.25GHz clock rate is there for the faster rate.
> > Some document that AN isn't supported, but when you try it, it
> > works (because it's literally just 1000base-X up-clocked.)
> > 
> > Just like the "AN must always be enabled when not in SGMII mode" on
> > mvneta and mvpp2 hardware, the statement that AN isn't supported in
> > 2500base-X in documentation is rather questionable.
> 
> On 1000Base-X and 2500Base-X we mean auto-negotiation as in Clause 37
> of the Ethernet standard,

Definitely. I do not mix up these terms. When I talk about 1000Base-X,
I always mean the IEEE 802.3 defined protocol. When I talk about
2500Base-X, that is slightly less clear because of its history and lack
of standardisation, but I _personally_ think of it as 1000Base-X locked
at 2.5x faster.

The fact that IEEE 802.3 eventually decided to give in and put
something in the standard for 2500Base-X is welcome, but sadly was
way too late as it had already been around for years by the time they
did that... making their standardised version basically irrelevant in
the real world.

> as opposed to CISCO-style MAC-side or PHY-side
> SGMII auto-negotiation in SGMII mode, right?

You may notice in the emails I tend to send, I talk about Cisco SGMII,
particularly when I think that the recipient won't understand the
difference - there is a lot of crap in industry surrounding "SGMII"
where "SGMII" gets used for "it's a serial gigabit MII link" and then
they use it for 1000Base-X. It annoys me intensely that industry
constantly dilutes these terms in a confusing way, so we end up with
patches that talk about doing stuff with SGMII that are actually doing
stuff with 1000Base-X.

For example, recently I've seen patches that add support for a device
that can to 10GBASE-R and 1000BASE-X... and their function for
configuring 1000BASE-X was called something with "_sgmii_" in its name.

As far as I'm concerned, there's 1000Base-X which is the 802.3 protocol
and there is Cisco SGMII which is 1000Base-X taken by Cisco and
modified - and one shall not use SGMII to other than to refer to the
Cisco version, because otherwise there's way too much scope for
confusion and misunderstanding.

> > >  * drivers/net/phy/mxl-gpy.c
> > >    This goes through great lengths to switch on inband-an when initially
> > >    coming up in SGMII mode, then switches is off when switching to
> > >    2500Base-X mode and after that **never switches it on again**. This
> > >    is obviously not correct and the driver can be greatly reduced if
> > >    dropping all that (non-)broken logic.
> > >    Would a patch like [1] this be acceptable?
> 
> Did you take a look at the current implementation in mxl-gpy.c and
> patch [1]?
> 
> To me the current code looks obviously wrong and cannot work when
> switching from SGMII (with in-band-status, initialized by the
> bootloader) to 2500Base-X and then back to SGMII (which will then
> always be without in-band-status), so that to me look like a bug, and
> if something like that should work, the driver will need to remember
> the previous state of in-band-status for SGMII instead of relying on an
> already overwritten PHY register.

Why do you think it doesn't re-enable in-band AN?

gpy_update_interface() does this when called at various speeds:

if SPEED_2500, it clears VSPEC1_SGMII_CTRL_ANEN

if SPEED_1000, SPEED_100, or SPEED_10, it sets VSPEC1_SGMII_ANEN_ANRS
   and VSPEC1_SGMII_ANEN_ANRS is both the VSPEC1_SGMII_CTRL_ANEN and
   VSPEC1_SGMII_CTRL_ANRS bits.

So the situation you talk about, when switching to 2500base-X,
VSPEC1_SGMII_CTRL_ANEN will be cleared, but when switching back to
SGMII mode, VSPEC1_SGMII_CTRL_ANEN will be set again.

To be honest, when I was reviewing the patch adding this support back
in June 2021, that also got me, and I was wondering whether
VSPEC1_SGMII_CTRL_ANEN was being set afterwards... it's just the
macro naming makes it look like it doesn't. But VSPEC1_SGMII_ANEN_ANRS
contains both ANEN and ANRS bits.

> > The overall message in my reply is essentially one of caution - yes
> > we can make changes to how PHYs work, but we need to audit the MAC
> > drivers that the PHY is used with to try to cut down on unexpected
> > regressions.
> 
> How do I even know which MAC driver is using which PHY driver as
> the PHY is being probed using the PHY ID at run-time?

Sadly, that is the big problem. It's not possible to go through the
DTS files, because many don't list which PHY the board is using (as
we rely on reading it from the hardware.) So really we don't have
much to go on.

It's rather a difficult problem to solve that has crept up on the
effort to maintain code in this area.

> In git history there are some hints regarding this, but there are
> probably a lot of "hidden" users of a PHY driver which we don't
> even know about simply because the fact a certain PHY driver is
> going to be used isn't documented anywhere.

Quite.

> I'm afraid we will need some kind of feature flag to indicate that a
> MAC driver is known to behave according to convention with regards to
> SGMII in-band-status being switched off and only in that case have the
> PHY driver do the same, and otherwhise stick with the existing
> codepaths and potentially unknown hardware-default behavior
> (ie. another mess like the pre_march2020 situation...)

Yes. Thankfully, it's something that, provided the PCS implementations
are all the same, at least phylink users should be consistent and we
don't need another flag in pl->config to indicate anything. We just
tell phylib that we're phylink and be done with it.

For everything else, I think we just have to assume "let the PHY
driver do what it does today" as the safest course of action.

As for the pre_march2020 situation, we're down to just two drivers
that require that now:

1) mtk_eth_soc for its RGMII mode (which, honestly, I'm prepared to
   break at this point, because I do not believe there are *any* users
   out there - not only have my pleas for testers for that had no
   response, I believe the code in mk_eth_soc to be broken.)

   I am considering removing RGMII support there for implementations
   which have MTK_GMAC1_TRGMII but _not_ MTK_TRGMII_MT7621_CLK -
   basically the path that calls mtk_gmac0_rgmii_adjust(). I doubt
   anyone will complain because no one seems to be using it (or
   they are and they're ignoring my pleas for testers - in which
   case, being three years on, they honestly get what's coming, that
   being a regression or not.)

2) mv88e6xxx DSA support, which needs to be converted to phylink_pcs
   as previously stated.

I never thought it would take 3+ years to get drivers converted, but
sadly this shows how glacially slow progress can be in mainline, and
the more users phylink gets, the more of a problem this is likely to
become unless we have really good interfaces into code making use of
it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
