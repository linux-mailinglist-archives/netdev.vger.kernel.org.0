Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7518E20F72C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388949AbgF3O2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388137AbgF3O2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:28:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9742C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q/pFAa41nMPEBl+sgTiWk7afxtV81D+fHqGoHAHqSmE=; b=kjJPjPNbvhytivRqww8+MJh9g
        tbXyh/MD+a2YA/OerW1wlu3fMmkEjwqU9wvOUfASyQDE8SceE7EV936p1luaw9BED3So4vO/lBQ/x
        fil7VpInQGCzolCELC81hhOk2GyvbqPdst9++B6Iv3zMtbW7Muj1YwPnb93TxuHcEwuJnIAG83ZGU
        6Ikx+AWGxFfBeEhRNqDucczSrB28QFYd1jrDqcVIee/NO6GKOwq/8BcEt6+2HjYzH+9k8dlbXm1w4
        2Y4z3L8xTlDlDMzX9Piut8j7oGPJCwV/xSZx+V/evHVs2lffYo6w36z/AfOAbmWlNBSO3GtcUJdY0
        1yLTZZuSg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33566)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqHEs-0000d2-K6; Tue, 30 Jun 2020 15:27:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqHEo-0008Fn-GI; Tue, 30 Jun 2020 15:27:54 +0100
Date:   Tue, 30 Jun 2020 15:27:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 00/13] Phylink PCS updates
Message-ID: <20200630142754.GC1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series updates the rudimentary phylink PCS support with the
results of the last four months of development of that.  Phylink
PCS support was initially added back at the end of March, when it
became clear that the current approach of treating everything at
the MAC end as being part of the MAC was inadequate.

However, this rudimentary implementation was fine initially for
mvneta and similar, but in practice had a fair number of issues,
particularly when ethtool interfaces were used to change various
link properties.

It became apparent that relying on the phylink_config structure for
the PCS was also bad when it became clear that the same PCS was used
in DSA drivers as well as in NXPs other offerings, and there was a
desire to re-use that code.

It also became apparent that splitting the "configuration" step on
an interface mode configuration between the MAC and PCS using just
mac_config() and pcs_config() methods was not sufficient for some
setups, as the MAC needed to be "taken down" prior to making changes,
and once all settings were complete, the MAC could only then be
resumed.

This series addresses these points, progressing PCS support, and
has been developed with mvneta and DPAA2 setups, with work on both
those drivers to prove this approach.  It has been rigorously tested
with mvneta, as that provides the most flexibility for testing the
various code paths.

To solve the phylink_config reuse problem, we introduce a struct
phylink_pcs, which contains the minimal information necessary, and it
is intended that this is embedded in the PCS private data structure.

To solve the interface mode configuration problem, we introduce two
new MAC methods, mac_prepare() and mac_finish() which wrap the entire
interface mode configuration only.  This has the additional benefit of
relieving MAC drivers from working out whether an interface change has
occurred, and whether they need to do some major work.

I have not yet updated all the interface documentation for these
changes yet, that work remains, but this patch set is provided in the
hope that those working on PCS support in NXP will find this useful.

Since there is a lot of change here, this is the reason why I strongly
advise that everyone has converted to the mac_link_up() way of
configuring the link parameters when the link comes up, rather than
the old way of using mac_config() - especially as splitting the PCS
changes how and when phylink calls mac_config(). Although no change
for existing users is intended, that is something I no longer am able
to test.

 drivers/net/phy/phylink.c | 365 +++++++++++++++++++++++++++++++---------------
 include/linux/phylink.h   | 103 ++++++++++---
 2 files changed, 337 insertions(+), 131 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
