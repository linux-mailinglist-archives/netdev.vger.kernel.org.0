Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D35B6A9515
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 11:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjCCKU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 05:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCCKU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 05:20:26 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0F7168B0
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 02:20:25 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 4933F127D;
        Fri,  3 Mar 2023 11:20:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1677838823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ZUzQT8BPAh5CTM5uURavdjoDXTGKWGfBgAXn3xfo6g=;
        b=Gg4wl+meTqoxw3THmuG6b777ViFKIDhbwjCNsh/fFXZLxJEKFQxafORBgytD1IUIuFGpyx
        E/VLC+nNR7ouJ3N/2BaxFutx/IdhPp/ScBWppYi2ibFGB+lrQP+NZ2hGxRlQr+h52NO6Me
        YGrL8HaCyLTFOig3DKGGukOkCRWTe8Ipc7fzcHo7MN3VAcYonIVJRdek0kFZTzexnYyzYp
        SOUIqe5GT9viz7I3Ii3j9wEFL13j8NPKWXrR0bazD+VmG0T2ji2CNQSsT9XNeTJB+R3pgp
        /752p7qmXDp3o9DLBA5oJp5c6BuQl/KnyBIPGbV3QRg8/JddRzJafQ6OkvoUmw==
From:   Michael Walle <michael@walle.cc>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, thomas.petazzoni@bootlin.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support [multicast/DSA issues]
Date:   Fri,  3 Mar 2023 11:20:05 +0100
Message-Id: <20230303102005.442331-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
References: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > (In essence, because of all the noise when trying the Marvell PHY with
> > > ptp4l, I came to the conlusion that NTP was a far better solution to
> > > time synchronisation between machines than PTP would ever be due to
> > > the nose induced by MDIO access. However, I should also state that I
> > > basically gave up with PTP in the end because hardware support is
> > > overall poor, and NTP just works - and I'd still have to run NTP for
> > > the machines that have no PTP capabilities. PTP probably only makes
> > > sense if one has a nice expensive grand master PTP clock on ones
> > > network, and all the machines one wants to synchronise have decent
> > > PTP implementations.)
> > 
> > Don't wanna waste too much of your time with the questions since
> > I haven't done much research but - wouldn't MAC timestamp be a better
> > choice more often (as long as it's a real, to-spec PTP stamp)? 
> > Are we picking PHY for historical reasons?
> > 
> > Not that flipping the default would address the problem of regressing
> > some setups..

Another thing I pointed out some time ago is that you might have a
working setup with MAC timestamping. Then comes along a patch which
adds PHY timestamping for the PHY you are using and it might break your
setup, because of the "PHY timestamping first" rule.

> There is the argument in PTP that having the PHY do the timestamping
> results in the timestamps being "closer to the wire" meaning that
> they will not be subject to any delays between the packet leaving
> the MAC and being transmitted on the wire. Some PHYs have FIFOs or
> other buffering which introduces a delay which PTP doesn't desire.
> 
> TI has a blog on this:
> 
> https://e2e.ti.com/blogs_/b/analogwire/posts/how-to-implement-ieee-1588-time-stamping-in-an-ethernet-transceiver
> 
> However, what is failed to be mentioned there is that yes, doing
> PTP at the PHY means one can accurately trigger a capture of the
> timestamp from the PHC when the SFD is detected on the media. That
> is a great advantage, but is really only half the story.
> 
> If the PHC (hardware counter) in the PHY can't be accurately
> synchronised, for example, it has a 1.5ppm second-to-second
> variability, then the resulting timestamps will also have that
> same variability. Another way to look at it is they will appear to
> have 1.5ppm of noise. If this noise is random, then it becomes
> difficult to filter that noise out, and results in jitter.

Exactly this.

> However, timestamping at the MAC may have only 40ppb of variability,
> but have a resulting delay through the PHY. The delay through the
> PHY will likely be constant, so the timestamps gathered at the MAC
> will have a constant error but have much less noise.

One thing to consider is also the quality of the oscillator of each
part. E.g. we design boards which have special temperture controlled
oscillators. How would you know where that one is connected to, MAC?
PHY? Both?

> Things change if one can use hardware signals to synchronise the
> PHC, because then we become less reliant on a variable latency
> accessing the PHY over the MDIO bus. The hardware event capture
> allows the PHC to be captured on a hardware signal, software can
> then read that timestamp, and if the hardware event is a PPS,
> then that can be used to ensure that the PHC is ticking at the
> correct rate. If the PPS is also aligned to a second boundary,
> then the hardware PHC can also be aligned. With both, the latency
> of the MDIO bus becomes irrelevant, and PTP at the PHY becomes a
> far more preferable option.
> 
> Note that things which can influence the latency over the MDIO bus
> include how many PHYs or other devices are also on it, and the
> rate at which accesses to those PHYs are performed. Then there's
> latency from kernel locking and scheduling. Maybe interrupt
> latency if the MDIO bus driver uses interrupts.
> 
> When I created the generic Marvell PHY PTP layer (my patch set
> for Marvell PHYs) I tried very hard to eliminate as many of these
> sources of variable latency as possible - such as avoiding taking
> and releasing locks on every MDIO bus access. Even with that, I
> could not get the PHY's PHC to synchronise any better than 1.5ppm,
> vs 40ppb for the PP2 MAC's PHC.
> 
> The last bit of consideration is whether the PHCs can be synchronised
> in hardware. If one has multiple ethernet interfaces, no hardware
> synchronisation of PHY PHCs, but also have MAC PTP support which is
> shared across the ethernet interfaces, why would one want to use the
> PHY with software based synchronisation of their individual PHCs.
> 
> So, to wrap this email up... if one has hardware purposely designed
> for PTP support, which uses the PTP hardware signals from the
> various PHCs, then one would want to use the PHY based timestamping.
> If one doesn't have that, then one would want to use something that
> gives the best timestamps, which may not necessarily be the PHY.

Which would make that a property of the board and not something
the software could figure out most of the time.

IMHO it really depends on how precise one want to go. Just saying
PHY timestamping is better isn't true. Vendors might go great
lengths to design their boards to do very well regarding precision
including PHY timestamping and maybe some kind of synchronization.

But in genernal, MAC timestamping - if available and not totally
broken - is the better choice IMHO. If it wasn't for the legacy rule,
I'd prefer MAC timestamping and just use PHY timestamping if MAC
timestamping is not available. If both are available, PHY
timestamping should be an opt-in.

-michael
