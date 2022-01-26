Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5537349CBD2
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241921AbiAZOHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241924AbiAZOHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 09:07:12 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28F3C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 06:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CRq2ZmnN+74NJ8r6+07MtHyhCD1qGPHrmeMqQOr/9vg=; b=z4A7FOvyc8yrf0gn3N2G7H7by6
        w8OnHRdsUBwA9iVcTxNBFCS1rbXj+2XYWRw05id+CdSTZu4gZD+G9SudD0V8ZJjXrFK9eNlij6tOA
        5+UwoW87F1b52gmS7/zgRYIp5MXoDY27VFSRaZlrEkB+/lgS4LHqXchWHQsPIfYSXin3hcx+ndpIl
        LDS4wkrTMBtffTJ5O/Xn8gnBvwUSa4lBRfMY6JX3rT9rKjQYqy+i+PTjK6XZiDMVCo3pMq4nDcXh2
        BZCL9/B9ikQzk9BBC9k78jMMXafWCYTkEPjfNoF2V8QY5UmWYgW6HCLShKUZaGABNMMt0N8Ui1ysN
        1pSdDwcw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56890)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCiwv-0003ML-KW; Wed, 26 Jan 2022 14:07:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCiwp-0004WU-FP; Wed, 26 Jan 2022 14:06:55 +0000
Date:   Wed, 26 Jan 2022 14:06:55 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Cc:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, mail@david-bauer.net
Subject: Re: [PATCH net-next v4 0/3] at803x fiber/SFP support
Message-ID: <YfFVf1jCIgWLM9TB@shell.armlinux.org.uk>
References: <20220125165410.252903-1-robert.hancock@calian.com>
 <YfFTGL1AdbOQOE8R@ppc.Dlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfFTGL1AdbOQOE8R@ppc.Dlink>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 04:56:40PM +0300, Andrey Jr. Melnikov wrote:
> On Tue, Jan 25, 2022 at 10:54:07AM -0600, Robert Hancock wrote:
> > Add support for 1000Base-X fiber modes to the at803x PHY driver, as
> > well as support for connecting a downstream SFP cage.
> > 
> > Changes since v3:
> > -Renamed some constants with OHM suffix for clarity
> > 
> > Changes since v2:
> > -fixed tabs/spaces issue in one patch
> > 
> > Changes since v1:
> > -moved page selection to config_init so it is handled properly
> > after suspend/resume
> > -added explicit check for empty sfp_support bitmask
> > 
> > Robert Hancock (3):
> >   net: phy: at803x: move page selection fix to config_init
> >   net: phy: at803x: add fiber support
> >   net: phy: at803x: Support downstream SFP cage
> > 
> Backported this series to 5.15.16 and tested on Ubiquiti EdgeRouter X SFP
> hardware. Optical SFP modules working without problems, but cooper SFP with
> Marvell 88E1111 not work - link is up but no packets sent/recieved via
> interface.

Could be that the 88E1111 is in SGMII mode, and with the 803x in
1000base-x mode, they just don't want to talk... and having a link up
event with an optical SFP (in 1000base-x mode) changes the state in the
803x so it somehow works.

SGMII and 1000base-x are similar enough that it can appear to work at
gigabit speeds if everything is just right.

> Can someone explain - why copper module not work from boot? And how controll 88E1111
> inside SFP ?

The Linux networking layer only permits one PHY per network interface,
so in the case of a SFP with a PHY connected to another PHY, the only
PHY we can expose is the PHY closest to the network interface. There
is no way e.g. via ethtool to be able to direct the PHY specific
ethtool calls to a specific PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
