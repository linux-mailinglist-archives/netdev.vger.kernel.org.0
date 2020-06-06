Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9A81F06D4
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 15:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgFFNoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 09:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgFFNoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 09:44:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0D5C03E96A;
        Sat,  6 Jun 2020 06:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vozlHdf9KLuw8QLuy6Exnt1trvwv2FE24skv0EkmY5k=; b=mUH728r7zwGBlIvp2uCjOU3mX
        CQiRiWQ/jVofdPufbya+44rAPdc/CLynbPpiQYOKFquKevYKj8eB8TlOyHxOEYTpU6slfNZ/sQZ6F
        91qNUFzD1f9DRerSSnMKHWBU0LuuuCBLkE8B5eQ6UU+ItLuEupbm565+QvKB6nT5oUeBFxy2sUfx3
        Hc00plYurfpoGGr1GTXl50b/e4R/x99UOPJzHIkWDS60bVcDK1yvRFHGuRxie+2X2p6WU4QQrrtt9
        Z/Ekh7c8oPX8zLh6s99KLPI+KKEDSkazk2X/pm3e6OJU0ZQa6Tk6FiHOzQbIghsKnCRPpf0Yxg9Qf
        JruJuFsbA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42072)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jhZ7C-0004Xy-Ln; Sat, 06 Jun 2020 14:44:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jhZ77-00005S-0G; Sat, 06 Jun 2020 14:43:57 +0100
Date:   Sat, 6 Jun 2020 14:43:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: introduce SGMII configuration
 options
Message-ID: <20200606134356.GM1551@shell.armlinux.org.uk>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
 <20200606083741.GK1551@shell.armlinux.org.uk>
 <20200606105909.GN311@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606105909.GN311@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 06, 2020 at 11:59:09AM +0100, Jonathan McDowell wrote:
> So the device in question is a 7 port stand alone switch chip. There's a
> single SGMII port which is configurable between port 0 + 6 (they can
> also be configure up as RGMII, while the remaining 5 ports have their
> own phys).
> 
> It sounds like there's a strong preference to try and auto configure
> things as much as possible, so I should assume the CPU port is in MAC
> mode, and anything not tagged as a CPU port is talking to a PHY/BASEX.
> 
> I assume I can use PHY_INTERFACE_MODE_1000BASEX on the
> phylink_mac_config call to choose BASEX?

Yes, but from what you've mentioned above, I think I need to ensure that
there's a proper understanding here.

1000BASE-X is the IEEE 802.3 defined 1G single lane Serdes protocol.
SGMII is different; it's a vendor derivative of 1000BASE-X which has
become a de-facto standard.

Both are somewhat compatible with each other; SGMII brings with it
additional data replication to achieve 100M and 10M speeds, while
keeping the link running at 1.25Gbaud.  In both cases, there is a
16-bit "configuration" word that is passed between the partners.

1000BASE-X uses this configuration word to advertise the abilities of
each end, which is limited to duplex and pause modes only.  This you
get by specifying the phy-mode="1000base-x" and
managed="in-band-status" in DT.

SGMII uses this configuration word for the media side to inform the
system side which mode it wishes to operate the link: the speed and
duplex.  Some vendors extend it to include EEE parameters as well,
or pause modes.  You get this via phy-mode="sgmii" and
managed="in-band-status" in DT.

Then there are variants where the configuration word is not present.
In this case, the link has to be manually configured, and without the
configuration word, SGMII operating at 1G is compatible with
1000base-X operating at 1G.  Fixed-link can be used for this, although
fixed-link will always report that the link is up at the moment; that
may change in the future, it's something that is being looked into at
the moment.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
