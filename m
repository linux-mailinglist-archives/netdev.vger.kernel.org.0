Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B5F69FBCC
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjBVTMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBVTM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:12:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687F92E80B;
        Wed, 22 Feb 2023 11:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=epmo8wriRa1iyL2sEskdW+2jWUcVwuUj8S3EBRRMHqg=; b=SnVlv2I+yVrCPILSB/kw80CLvp
        2aKsPdvmS2yX/lawZ/NBFM0NFD/nXdTvvy57zdcJBZthlqSQz+eaNDhERKuKuZxJ1BcTV4sKWYRUw
        i3Y3sZ0/8LnE43wzkbdwt8EjK48liLfo2TCmc+dinHMd3mU05Czp+AEcaAUWpSB+vCCe4Op1ELxBX
        fUe3vqcA0zcF0IhiVjC72j6cHaC5FvJpi1mcajy0dcGnpLTeB6Y2ZOp7QqeglYofqkSmOoccQlzqR
        EpYOYf8Srocl+NAPpjCYw36BjJQXKR4E7ibXMLPrCHjtbtQbsSr2aX/XhNJDCnYX4zh5EuGHw7Ru0
        RiYayDYQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35656)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pUuXP-0007II-Vv; Wed, 22 Feb 2023 19:12:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pUuXN-0003RQ-I1; Wed, 22 Feb 2023 19:12:21 +0000
Date:   Wed, 22 Feb 2023 19:12:21 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function
 for KSZ87xx
Message-ID: <Y/ZpFcX5LA/EbE8T@shell.armlinux.org.uk>
References: <20230222031738.189025-1-marex@denx.de>
 <Y/YPfxg8Ackb8zmW@shell.armlinux.org.uk>
 <Y/YSs6Qm9OrBoOSX@shell.armlinux.org.uk>
 <df03ab8e-ce2b-6c58-2ae3-f41b33f4aaa8@denx.de>
 <Y/Y7PoHMxTA/B3S9@shell.armlinux.org.uk>
 <b408dc57-082e-e725-22ec-727ac57c7027@denx.de>
 <Y/ZFJfvDWeII/mhI@shell.armlinux.org.uk>
 <13fd97dc-e09e-6913-986c-a7c94215654c@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13fd97dc-e09e-6913-986c-a7c94215654c@denx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 07:43:35PM +0100, Marek Vasut wrote:
> On 2/22/23 17:39, Russell King (Oracle) wrote:
> > On Wed, Feb 22, 2023 at 05:30:43PM +0100, Marek Vasut wrote:
> > > On 2/22/23 16:56, Russell King (Oracle) wrote:
> > > > On Wed, Feb 22, 2023 at 04:10:33PM +0100, Marek Vasut wrote:
> > > > > On 2/22/23 14:03, Russell King (Oracle) wrote:
> > > > > > On Wed, Feb 22, 2023 at 12:50:07PM +0000, Russell King (Oracle) wrote:
> > > > > > > On Wed, Feb 22, 2023 at 04:17:38AM +0100, Marek Vasut wrote:
> > > > > > > > diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> > > > > > > > index 729b36eeb2c46..7fc2155d93d6e 100644
> > > > > > > > --- a/drivers/net/dsa/microchip/ksz_common.c
> > > > > > > > +++ b/drivers/net/dsa/microchip/ksz_common.c
> > > > > > > > @@ -319,7 +319,7 @@ static const u16 ksz8795_regs[] = {
> > > > > > > >     	[S_BROADCAST_CTRL]		= 0x06,
> > > > > > > >     	[S_MULTICAST_CTRL]		= 0x04,
> > > > > > > >     	[P_XMII_CTRL_0]			= 0x06,
> > > > > > > > -	[P_XMII_CTRL_1]			= 0x56,
> > > > > > > > +	[P_XMII_CTRL_1]			= 0x06,
> > > > > > > 
> > > > > > > Looking at this driver, I have to say that it looks utterly vile
> > > > > > > from the point of view of being sure that it is correct, and I
> > > > > > > think this patch illustrates why.
> > > > > > > 
> > > > > > > You mention you're using a KSZ8794. This uses the ksz8795_regs
> > > > > > > array, and ksz8_dev_ops. You claim this is about the P_GMII_1GBIT_M
> > > > > > > bit, which is bit 6.
> > > > > > > 
> > > > > > > This bit is accessed only by ksz_get_gbit() and ksz_set_gbit().
> > > > > > > 
> > > > > > > Firstly, ksz_set_gbit() is only called from ksz_port_set_xmii_speed(),
> > > > > > > which is only called from ksz9477_phylink_mac_link_up(). This is only
> > > > > > > referenced by ksz9477_dev_ops and lan937x_dev_ops, but not ksz8_dev_ops.
> > > > > > > Therefore, ksz_set_gbit() is not called for KSZ8794.
> > > > > > > 
> > > > > > > ksz_get_gbit() is only referenced by ksz9477.c in
> > > > > > > ksz9477_get_interface(), called only by ksz9477_config_cpu_port().
> > > > > > > This is only referenced by ksz9477_dev_ops, but not ksz8_dev_ops.
> > > > > > > 
> > > > > > > Therefore, my conclusion is that neither of the ksz_*_gbit()
> > > > > > > functions are called on KSZ8794, and thus your change has no effect
> > > > > > > on the driver's use of P_GMII_1GBIT_M - I think if you put some
> > > > > > > debugging printk()s into both ksz_*_gbit() functions, it'll prove
> > > > > > > that.
> > > > > > > 
> > > > > > > There's other places that P_XMII_CTRL_1 is accessed - ksz_set_xmii()
> > > > > > > and ksz_get_xmii(). These look at the P_MII_SEL_M, P_RGMII_ID_IG_ENABLE
> > > > > > > and P_RGMII_ID_EG_ENABLE bits - bits 0, 1, 3 and 4.
> > > > > > > 
> > > > > > > ksz_get_xmii() is only called by ksz9477_get_interface(), which we've
> > > > > > > already looked at above as not being called.
> > > > > > > 
> > > > > > > ksz_set_xmii() is only called by ksz_phylink_mac_config(), which is
> > > > > > > always called irrespective of the KSZ chip.
> > > > > > > 
> > > > > > > Now, let's look at functions that access P_XMII_CTRL_0. These are
> > > > > > > ksz_set_100_10mbit() and ksz_duplex_flowctrl(). The former
> > > > > > > accesses bit P_MII_100MBIT_M, which is bit 4. The latter looks at
> > > > > > > bits 6, bit 5, and possibly bit 3 depending on the masks being used.
> > > > > > > KSZ8795 uses ksz8795_masks, which omits bit 3, so bits 5 and 6.
> > > > > > > Note... bit 6 is also P_GMII_1GBIT_M. So if ksz_duplex_flowctrl()
> > > > > > > is ever called for the KSZ8795, then we have a situation where
> > > > > > > the P_GMII_1GBIT_M will be manipulated.
> > > > > > > 
> > > > > > > ksz_set_100_10mbit() is only called from ksz_port_set_xmii_speed(),
> > > > > > > which we've established won't be called.
> > > > > > > 
> > > > > > > ksz_duplex_flowctrl() is only called from ksz9477_phylink_mac_link_up()
> > > > > > > which we've also established won't be called.
> > > > > > > 
> > > > > > > So, as far as I can see, P_XMII_CTRL_0 won't be accessed on this
> > > > > > > device.
> > > > > > > 
> > > > > > > Now, what about other KSZ devices - I've analysed this for the KSZ8795,
> > > > > > > but what about any of the others which use this register table? It
> > > > > > > looks to me like those that use ksz8795_regs[] all use ksz8_dev_ops
> > > > > > > and the same masks and bitvals, so they should be the same.
> > > > > > > 
> > > > > > > That is a hell of a lot of work to prove that setting both
> > > > > > > P_XMII_CTRL_0 and P_XMII_CTRL_1 to point at the same register is
> > > > > > > in fact safe. Given the number of registers, the masks, and bitval
> > > > > > > arrays, doing this to prove every combination and then analysing
> > > > > > > the code is utterly impractical - and thus why I label this driver
> > > > > > > as "vile". Is there really no better option to these register
> > > > > > > arrays, bitval arrays and mask arrays - something that makes it
> > > > > > > easier to review and prove correctness?
> > > > > > > 
> > > > > > > I'm not going to give a reviewed-by for this, because... I could
> > > > > > > have made a mistake in the above analysis given the vile nature
> > > > > > > of this driver.
> > > > > > 
> > > > > > However, I should add that - as a result of neither ksz_*_gbit()
> > > > > > functions being used, I consider at least the subject line to be
> > > > > > rather misleading! While it may be something that you spotted,
> > > > > > I suspect the other bits that are actually written are more the
> > > > > > issue you're fixing.
> > > > > 
> > > > > Thank you for the lengthy review, I agree the driver and the register offset
> > > > > calculation are hideous.
> > > > > 
> > > > > However, I did spent quite a bit of time on it already and checked both
> > > > > P_XMII_CTRL_0 and P_XMII_CTRL_1 mappings with printks and by dumping the
> > > > > register values via regmap debugfs interface.
> > > > > 
> > > > > Also note that KSZ8794 and KSZ8795 seem to be the same chip die, just
> > > > > different package (the former has fewer ports) and different chip ID.
> > > > 
> > > > It's not clear what you think of my review and whether you are going to
> > > > take any action at all... So, let me try again...
> > > > 
> > > > The fundamental question that my review raises was whether this gigabit
> > > > bit is actually used, and your response remains silent on that point.
> > > > 
> > > > As the gigabit bit is not actually used given the code structure, it
> > > > is irrelevant for this commit, despite Is_Gbit being the thing that
> > > > lead to the patch.
> > > > 
> > > > Therefore, I believe that the patch description needs to be updated
> > > > to state what the effective fix for this change is (which is to fix
> > > > ksz_set_xmii()) rather than making it sound like it's fixing a wrong
> > > > access for Is_Gbit.
> > > > 
> > > > The reason I think this is important is that if we need to look back
> > > > at the history, current description leads one to think that this
> > > > change is about fixing the Is_Gbit bit - but that isn't used as the
> > > > code stands. The effective change that this patch makes is to the
> > > > only access the driver makes to this register in ksz_set_xmii(),
> > > > and I think that needs to be explained as the primary reason for
> > > > this patch. Fixing Is_Gbit seems to be merely incidental.
> > > 
> > > On the hardware I use here, the P_XMII_CTRL_1 register ends up being
> > > populated with all bits set, 0xff. Without this change, the driver writes to
> > > non-existent register when it attempts to access P_XMII_CTRL_1 .
> > 
> > Why is this so difficult?
> > 
> > I'm *not* disagreeing with the patch. I'm disagreeing with your
> > commit description.
> 
> Why not comment on the commit message part which you disagree with, and
> suggest an improved wording you do agree with ? Then I can send a V2 with
> that part changed, and be done with it.

I have made it crystal clear which bit of the commit message I don't
agree with.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
