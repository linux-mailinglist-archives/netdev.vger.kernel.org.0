Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09636B3EC5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 13:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjCJMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 07:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjCJMHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 07:07:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B905FEF2E;
        Fri, 10 Mar 2023 04:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5n0+qBrV2sTyru8+y7JIo3cYfCzXZeYuxMZq0U4lR9U=; b=Rh//1Fdk4q5kWEEy577pKVP+jE
        zDXcYsfLL6F1zbhG+JUmMKIfOcOAqwUrHHUhMauq0liaeg9bN6fQvuMO1ODSk8SDgtI7hfb1sIfnP
        QGHU9DPceQ3NksHWYY4r7gWRRwz0Nimn6jIMWfSvZBj8s0vLKPP1IjF615dwRgFZSi3AvZDsKLGGe
        gU40N8hSV7NNoGu9ZIESf2UN+iUDeLz0OZyw6BN8vs3LyPQi0SH3o+ZwXkCJo5Tqfrj4c7LIM47G9
        draXGhMfl8wJOVO4KUn5mjYFl7ly59s2hjkwSrdYpX6wTbSprwwuRWpJ0DIg55j4EbbyUsy1k1oN1
        268BOq6w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44922)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pabVp-0006dO-Lw; Fri, 10 Mar 2023 12:06:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pabVn-0004fE-Fm; Fri, 10 Mar 2023 12:06:15 +0000
Date:   Fri, 10 Mar 2023 12:06:15 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] dsa: marvell: Correct value of max_frame_size
 variable after validation
Message-ID: <ZAsdN3j8IrL0Pn0J@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-7-lukma@denx.de>
 <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
 <20230309154350.0bdc54c8@wsk>
 <0959097a-35cb-48c1-8e88-5e6c1269852d@lunn.ch>
 <20230310125346.13f93f78@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310125346.13f93f78@wsk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 12:53:46PM +0100, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > > > If I understand this correctly, in patch 4, you add a call to the
> > > > 6250 family to call mv88e6185_g1_set_max_frame_size(), which sets
> > > > a bit called MV88E6185_G1_CTL1_MAX_FRAME_1632 if the frame size
> > > > is larger than 1518.  
> > > 
> > > Yes, correct.
> > >   
> > > > 
> > > > However, you're saying that 6250 has a frame size of 2048. That's
> > > > fine, but it makes MV88E6185_G1_CTL1_MAX_FRAME_1632 rather
> > > > misleading as a definition. While the bit may increase the frame
> > > > size, I think if we're going to do this, then this definition
> > > > ought to be renamed. 
> > > 
> > > I thought about rename, but then I've double checked; register
> > > offset and exact bit definition is the same as for 6185, so to avoid
> > > unnecessary code duplication - I've reused the existing function.
> > > 
> > > Maybe comment would be just enough?  
> > 
> > The driver takes care with its namespace in order to add per switch
> > family defines. So you can add MV88E6250_G1_CTL1_MAX_FRAME_2048. It
> > does not matter if it is the same bit. You can also add a
> > mv88e6250_g1_set_max_frame_size() and it also does not matter if it is
> > in effect the same as mv88e6185_g1_set_max_frame_size().
> > 
> > We should always make the driver understandably first, compact and
> > without redundancy second. We are then less likely to get into
> > situations like this again where it is not clear what MTU a device
> > actually supports because the code is cryptic.
> 
> Ok, I will add new function.
> 
> Thanks for hints.

It may be worth doing:

static int mv88e6xxx_g1_modify(struct mv88e6xxx_chip *chip, int reg,
			       u16 mask, u16 val)
{
	int addr = chip->info->global1_addr;
	int err;
	u16 v;

	err = mv88e6xxx_read(chip, addr, reg, &v);
	if (err < 0)
		return err;

	v = (v & ~mask) | val;

	return mv88e6xxx_write(chip, addr, reg, v);
}

Then, mv88e6185_g1_set_max_frame_size() becomes:

int mv88e6185_g1_set_max_frame_size(struct mv88e6xxx_chip *chip, int mtu)
{
	u16 val = 0;

	if (mtu + ETH_HLEN + ETH_FCS_LEN > 1518)
		val = MV88E6185_G1_CTL1_MAX_FRAME_1632;

	return mv88e6xxx_g1_modify(chip, MV88E6XXX_G1_CTL1,
				   MV88E6185_G1_CTL1_MAX_FRAME_1632, val);
}

The 6250 variant becomes similar.

We can also think about converting all those other read-modify-writes
to use mv88e6xxx_g1_modify().

The strange thing is... we already have mv88e6xxx_g1_ctl2_mask() which
is an implementation of mv88e6xxx_g1_modify() specifically for
MV88E6XXX_G1_CTL2 register, although it uses (val & mask) rather than
just val. That wouldn't be necessary if the bitfield macros (e.g.
FIELD_PREP() were used rather than explicit __bf_shf().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
