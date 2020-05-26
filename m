Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8501E2412
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgEZOaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgEZO37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 10:29:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF74C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 07:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tk6M32A7RpCZN/TdsUs8DZ3QM4091WZNUulcpczGgaI=; b=st2zJOzARG0vCXu3QoRcq0ux7
        7JWjxVJnrfyXn3SR1SuZBANBOnHayLa4/FmEHO92ylbk8zzJh8415mqIQnvQQixCwj0zDRiQvnymg
        MLyPTLCZwzhhVcSxd7VbQthP2OTENmfmht0rwToKzoK+xGxxoGCyOkftg/JYzOyNtcZXjT9uc5Zlf
        fhgdu875mDPfn8EuLQ/B9D5bTv44IjYWYVmXAnC+CA0bCZ9OzQ18BzSexDistffRReX3FCNZyNIZu
        vjWwRcfLNZzdd4ekxDrFyiBRIAGqko5WkAjPly1yHKv+RWUwXsV/CHFjeOxSSY4sI68qCRnjwidDB
        E9BIz9Heg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37244)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdaaU-000804-C8; Tue, 26 May 2020 15:29:50 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdaaS-0005Rf-Ej; Tue, 26 May 2020 15:29:48 +0100
Date:   Tue, 26 May 2020 15:29:48 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Subject: [PATCH RFC 0/7] Clause 45 PHY probing cleanups
Message-ID: <20200526142948.GY1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In response to the patch set that Jeremy posted, this is my proposal
to expand our Clause 45 PHY probing.

I've taken a slightly different approach, with the view to avoiding
as much behavioural change as possible.  The biggest difference is
to do with "devices_in_package" - we were using it for two different
purposes, which are now separated.

This is not against net-next nor net trees, but against my own private
tree, but I'm posting it to serve as an illustration of what I think
should be done - I knocked this up this morning.

The only potential regression that I'm expecting is with 88x3310 PHYs
of the later revision, which have the clause 22 registers implemented.
I haven't yet checked whether they set bit 0, but if they do, the
various decision points that we have based on that bit could adversely
affect this PHY - it needs testing, which I'll do when I dig out the
appropriate hardware.  Probably also needs the 2110 PHYs checked as
well.

I haven't tested this series yet beyond compile testing.

Given the proximity of the merge window, this *isn't* code I'd like to
see merged into net-next - it's way too risky at this point.  So, we
have time to consider our options.

 drivers/net/phy/bcm87xx.c    |   2 +-
 drivers/net/phy/cortina.c    |   3 +-
 drivers/net/phy/phy-c45.c    |   4 +-
 drivers/net/phy/phy-core.c   |  11 ++--
 drivers/net/phy/phy.c        |   4 +-
 drivers/net/phy/phy_device.c | 141 +++++++++++++++++++++++++++----------------
 drivers/net/phy/phylink.c    |  19 +++---
 include/linux/mdio.h         |  31 ++++++++++
 include/linux/phy.h          |  14 ++---
 9 files changed, 146 insertions(+), 83 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
