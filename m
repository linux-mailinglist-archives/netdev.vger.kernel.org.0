Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368191856D3
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgCOBaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:30:12 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgCOBaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mZ0V+6x9saiQwGWyqvV/YMw0uTAzZDONepLrbjA2qNg=; b=ddAWiH73nmVHf9V/RqCvz9S7R
        C5A8EwWmdT/ic+3gyV3mdAcM1hxsUJrfm4hft8xtrIKhJUCfOoHhOEhfARNZyLG+G3iFBHMN+4R+L
        MzkvmKF1YMGl1vcxN2WV/ybkFzxAoJDxX0VcbhRzhaNSdO90QrNVn97TpSrALkhRzN25twK+qAT/d
        QAthnx9BJYIK28fYJ3qt8mWQp98eYhEz/hT6G3WTuI0r8VWbJyktyWU+eimcecUPHbilBIeNRahzq
        A7G+NKsbj9Hj8sGwf6n0D0DyGjUoMxC/lrlOrPMb+Kw1E4xG2NMr5HPtjIhHqzhcN4+PP5HMfSZOV
        rBwfBry/A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36286)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jD3oO-0006Au-Ng; Sat, 14 Mar 2020 10:14:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jD3oN-0008Dz-Q3; Sat, 14 Mar 2020 10:14:31 +0000
Date:   Sat, 14 Mar 2020 10:14:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH REPOST net-next 0/8] net: dsa: improve serdes integration
Message-ID: <20200314101431.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depends on "net: mii clause 37 helpers".

Andrew Lunn mentioned that the Serdes PCS found in Marvell DSA switches
does not automatically update the switch MACs with the link parameters.
Currently, the DSA code implements a work-around for this.

This series improves the Serdes integration, making use of the recent
phylink changes to support split MAC/PCS setups.  One noticable
improvement for userspace is that ethtool can now report the link
partner's advertisement.

This repost has no changes compared to the previous posting; however,
the regression Andrew had found which exists even without this patch
set has now been fixed by Andrew and merged into the net-next tree.

 drivers/net/dsa/mv88e6xxx/chip.c   | 437 +++++++++++++++++++++----------------
 drivers/net/dsa/mv88e6xxx/chip.h   |  35 +--
 drivers/net/dsa/mv88e6xxx/port.c   | 285 +++++-------------------
 drivers/net/dsa/mv88e6xxx/port.h   |  29 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c | 375 +++++++++++++++++++++++++------
 drivers/net/dsa/mv88e6xxx/serdes.h |  34 ++-
 net/dsa/port.c                     |   7 +-
 7 files changed, 667 insertions(+), 535 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
