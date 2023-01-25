Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA2367B5A4
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 16:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbjAYPNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 10:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbjAYPNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 10:13:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032C0233F2;
        Wed, 25 Jan 2023 07:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=z09YQWZaNeyU5LlbPTAJDfM0JH/4UK1IAx6XSK7tCyU=; b=Wwh9EVUpzB4tnYoH3BAKok+CJi
        eqRkB7pQq8kx/0XBa0l2cq5vfNE/HnY5WY4XL7ouQuJ5+WmHxcWGN39qT1Y1TZjMvHXmCkb/T1W5n
        chA+814FYsLFeRCAz37bP6hK6YSKmDXCbpSpaNrTYxZS4l1upr40JR59S92DbhYx/xRsWDQxrNUH+
        DXzGeD/KrpkBoB+6QdTGdcLuId15wyup6vEdsB/8pJOLXFhubDGdD8ogvPwgBEjBD9YSw0NDu2ker
        1LEk6nDq8OKwpYbD2demB5MmWNjDS4A6a+OlUeJijMW+SLDeZYmDlHM3h5SRCbc9RfEFl+auZ7THo
        tjJTE2yA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36292)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pKhS4-0000ph-3g; Wed, 25 Jan 2023 15:12:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pKhS1-0006Lm-18; Wed, 25 Jan 2023 15:12:37 +0000
Date:   Wed, 25 Jan 2023 15:12:36 +0000
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
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <Y9FG5PxOq7qsfvtz@shell.armlinux.org.uk>
References: <20230106101651.1137755-1-lukma@denx.de>
 <Y8Fno+svcnNY4h/8@shell.armlinux.org.uk>
 <20230116105148.230ef4ae@wsk>
 <20230125122412.4eb1746d@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125122412.4eb1746d@wsk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 12:24:12PM +0100, Lukasz Majewski wrote:
> Hi,
> 
> > Hi Russell,
> > 
> > > On Fri, Jan 06, 2023 at 11:16:49AM +0100, Lukasz Majewski wrote:  
> > > > Different Marvell DSA switches support different size of max frame
> > > > bytes to be sent. This value corresponds to the memory allocated
> > > > in switch to store single frame.
> > > > 
> > > > For example mv88e6185 supports max 1632 bytes, which is now
> > > > in-driver standard value. On the other hand - mv88e6250 supports
> > > > 2048 bytes. To be more interresting - devices supporting jumbo
> > > > frames - use yet another value (10240 bytes)
> > > > 
> > > > As this value is internal and may be different for each switch IC,
> > > > new entry in struct mv88e6xxx_info has been added to store it.
> > > > 
> > > > This commit doesn't change the code functionality - it just
> > > > provides the max frame size value explicitly - up till now it has
> > > > been assigned depending on the callback provided by the IC driver
> > > > (e.g. .set_max_frame_size, .port_set_jumbo_size).    
> > > 
> > > I don't think this patch is correct.
> > > 
> > > One of the things that mv88e6xxx_setup_port() does when initialising
> > > each port is:
> > > 
> > >         if (chip->info->ops->port_set_jumbo_size) {
> > >                 err = chip->info->ops->port_set_jumbo_size(chip,
> > > port, 10218); if (err)
> > >                         return err;
> > >         }
> > > 
> > > There is one implementation of this, which is
> > > mv88e6165_port_set_jumbo_size() and that has the effect of setting
> > > port register 8 to the largest size. So any chip that supports the
> > > port_set_jumbo_size() method will be programmed on initialisation to
> > > support this larger size.
> > > 
> > > However, you seem to be listing e.g. the 88e6190 (if I'm
> > > interpreting the horrid mv88e6xxx_table changes correctly)  
> > 
> > Those changes were requested by the community. Previous versions of
> > this patch were just changing things to allow correct operation of the
> > switch ICs on which I do work (i.e. 88e6020 and 88e6071).
> > 
> > And yes, for 88e6190 the max_frame_size = 10240, but (by mistake) the
> > same value was not updated for 88e6190X.
> > 
> > The question is - how shall I proceed? 
> > 
> > After the discussion about this code - it looks like approach from v3
> > [1] seems to be the most non-intrusive for other ICs.
> > 
> 
> I would appreciate _any_ hints on how shall I proceed to prepare those
> patches, so the community will accept them...

What I'm concerned about, and why I replied, is that setting the devices
to have a max frame size of 1522 when we program them to use a larger
frame size means we break those switches for normal sized packets.

The current logic in mv88e6xxx_get_max_mtu() is:

	If the chip implements port_set_jumbo_size, then packet sizes of
	up to 10240 are supported.
	(ops: 6131, 6141, 6171, 6172, 6175, 6176, 6190, 6190x, 6240, 6320,
	6321, 6341, 6350, 6351, 6352, 6390, 6390x, 6393x)
	If the chip implements set_max_frame_size, then packet sizes of
	up to 1632 are supported.
	(ops: 6085, 6095, 6097, 6123, 6161, 6185)
	Otherwise, packets of up to 1522 are supported.

Now, going through the patch, I see:

	88e6085 has 10240 but currently has 1632
	88e6095 has 1632 (no change)
	88e6097 has 1632 (no change)
	88e6123 has 10240 but currently has 1632
	88e6131 has 10240 (no change)
	88e6141 has 10240 (no change)
	88e6161 has 1632 but currently has 10240
	88e6165 has 1632 but currently has 1522
	88e6171 has 1522 but currently has 10240
	88e6172 has 10240 (no change)
	88e6175 has 1632 but currently has 10240
	88e6176 has 10240 (no change)
	88e6185 has 1632 (no change)
	88e6190 has 10240 (no change)
	88e6190x has 10240 (no change)
	88e6191 has 10240 but currently has 1522
	88e6191x has 1522 but currently has 10240
	88e6193x has 1522 but currently has 10240
	88e6220 has 2048 but currently has 1522
	88e6240 has 10240 (no change)
	88e6250 has 2048 but currently has 1522
	88e6290 has 10240 but currently has 1522
	88e6320 has 10240 (no change)
	88e6321 has 10240 (no change)
	88e6341 has 10240 (no change)
	88e6350 has 10240 (no change)
	88e6351 has 10240 (no change)
	88e6352 has 10240 (no change)
	88e6390 has 1522 but currently has 10240
	88e6390x has 1522 but currently has 10240
	88e6393x has 1522 but currently has 10240

My point is that based on the above, there's an awful lot of changes
that this one patch brings, and I'm not sure many of them are intended.

All the ones with "but currently has 10240", it seems they implement
port_set_jumbo_size() which, although the switch may default to a
smaller frame size, we configure it to be higher. Maybe these don't
implement the field that configures those? Maybe your patch is wrong?
I don't know.

Similarly for the ones with "but currently has 1632", it seems they
implement set_max_frame_size(), but this is only called via
mv88e6xxx_change_mtu(), and I haven't worked out whether that will
be called during initialisation by the networking layer.

Now, what really concerns me is the difficulty in making this change.
As we can see from the above, there's a lot of changes going on here,
and it's not obvious which are intentional and which may be bugs.

So, I think it would be far better to introduce the "max_frame_size"
field using the existing values, and then verify that value during
initialisation time for every entry in mv88e6xxx_table[] using the
rules that mv88e6xxx_get_max_mtu() was using. Boot that kernel, and
have it run that verification, and state that's what's happened and
was successful in the commit message.

In the next commit, change mv88e6xxx_get_max_mtu() to use those
verified values and remove the verification code.

Then in the following commit, update the "max_frame_size" values with
the changes you intend to make.

Then, we can (a) have confidence that each of the new members were
properly initialised, and (b) we can also see what changes you're
intentionally making.

Right now, given that at least two of the "max_frame_size" values are
wrong in this patch, I think we can say for certain that we've proven
that trying to introduce this new member and use it in a single patch
is too error prone.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
