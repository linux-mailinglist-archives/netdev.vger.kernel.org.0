Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54771E181F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389133AbgEYXHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387745AbgEYXHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:07:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCF5C061A0E;
        Mon, 25 May 2020 16:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ndlkmIWKGBpzvwVCQ43l+ydPG0dLjEM/7QOyONbHlcE=; b=IydryHpBIDlDyHSfMR8ysoxgW
        04zG/zmbbTpWEHHgOe88FqU9p09rfnbLIXwSBVkxCOncPnbzSSpwfRfGu0Guo5iQ4vdFmhnEwc3+6
        26tza2EKb5lxAhFpivsHZoFoI6JleVyrrXPn94KAp/N7V0OijhOKIWFOkJ7U5fyC9cFBh/M47U5t6
        qH5ueRroVKAA/KIywurxk9idsve4zNOqLiPR+kgUWcygRVo/Yz3NFQeuhPBLTKyRqXKpzJn0l7/TY
        os48WpAkjfJlbvW2uTFkKwzMNNroHd2aCOmQGt2uSvsfDSFFYsnYMepmVwE8HotSIdFKqI+rbSLb2
        bwCFPVaGA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34526)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdMBy-0006Cu-Lp; Tue, 26 May 2020 00:07:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdMBw-0004lF-QN; Tue, 26 May 2020 00:07:32 +0100
Date:   Tue, 26 May 2020 00:07:32 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 04/11] net: phy: Handle c22 regs presence better
Message-ID: <20200525230732.GQ1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-5-jeremy.linton@arm.com>
 <20200523183731.GZ1551@shell.armlinux.org.uk>
 <f85e4d86-ff58-0ed2-785b-c51626916140@arm.com>
 <20200525100612.GM1551@shell.armlinux.org.uk>
 <63ca13e3-11ea-3ddf-e1c7-90597d4a5f8c@arm.com>
 <20200525220614.GC768009@lunn.ch>
 <8868af66-fc1a-8ec2-ab75-123bffe2d504@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8868af66-fc1a-8ec2-ab75-123bffe2d504@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 05:17:27PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/25/20 5:06 PM, Andrew Lunn wrote:
> > > Yes, we know even for the NXP reference hardware, one of the phy's doesn't
> > > probe out correctly because it doesn't respond to the ieee defined
> > > registers. I think at this point, there really isn't anything we can do
> > > about that unless we involve the (ACPI) firmware in currently nonstandard
> > > behaviors.
> > > 
> > > So, my goals here have been to first, not break anything, and then do a
> > > slightly better job finding phy's that are (mostly?) responding correctly to
> > > the 802.3 spec. So we can say "if you hardware is ACPI conformant, and you
> > > have IEEE conformant phy's you should be ok". So, for your example phy, I
> > > guess the immediate answer is "use DT" or "find a conformant phy", or even
> > > "abstract it in the firmware and use a mailbox interface".
> > Hi Jeremy
> > 
> > You need to be careful here, when you say "use DT". With a c45 PHY
> > of_mdiobus_register_phy() calls get_phy_device() to see if the device
> > exists on the bus. So your changes to get_phy_device() etc, needs to
> > continue to find devices it used to find, even if they are not fully
> > complient to 802.3.
> > 
> 
> Yes, that is my "don't break anything". But, in a number of cases I can't
> tell if something is an intentional "bug", or what exactly the intended side
> effect actually was. The c22 bit0 sanitation is in this bucket, because its
> basically disabling the MMD0 probe..

I'm really not sure it causes any problem what so ever.  Have you read
the commit adding cortina.c to see what it says - there is an
interesting comment about what it requires in firmware.  That is, it
calls for an explicit "ethernet-phy-id" compatible in DT naming the
PHY ID, but that can't be used for Clause 45 PHYs (it will be ignored.)
So, it will be treated by the kernel as a Clause 22 PHY.

It is presently in use:

arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
arch/powerpc/boot/dts/fsl/t4240rdb.dts: compatible = "ethernet-phy-id13e5.1002";
arch/powerpc/boot/dts/fsl/t2080rdb.dts: compatible = "ethernet-phy-id13e5.1002";
arch/powerpc/boot/dts/fsl/t2080rdb.dts: compatible = "ethernet-phy-id13e5.1002";

Now, given this, none of the Clause 45 PHY detection code will be
touched while probing for these PHYs, so really that work-around to
read form MMD 0 in the Clause 45 probing function really doesn't seem
to apply to these PHYs.

Next, when you read cortina.c, it becomes obvious that the PHY's MMD 0
doesn't even follow IEEE 802.3 - the ID registers are at register 0/1
not 2/3.  So even if we did try to read the ID from MMD 0, we wouldn't
be reading the ID from the right registers.

Hence, I don't think anything has been broken at all by the commit
you refer to.

> I know for sure we find phys that previously weren't found. OTOH, i'm not
> sure how many that were previously "found" are now getting kicked out by
> because they are doing something "bad" that looked like a bug.

I don't think you've found any problem what so ever.

For these PHYs to be automatically probed, they need to have a DT
string identifying them as clause 45 compliant.  From the DTS files
I've provided above, that isn't the case, this code path won't be
reached, so nothing has been broken.  In any case, for the
reasons I mention above wrt non-standard register layout, it seems
it couldn't have worked via this probing code.

I would dig some more into the history of the change to
get_phy_c45_ids() and how it relates to the addition of the Cortina
driver, but unfortunately my machine is being painfully slow with
git log searching the history that it's way too time consuming for
me to do anything further now, but the conclusion I'm coming to is
that there has been no regression how you think there has been.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
