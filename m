Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509AC1A8B71
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505197AbgDNTsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730107AbgDNTsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:48:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB72C061A10
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 12:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4buNwgbalunjH3WvxQCwM/7UYY3Zyecd++aRGwuRJdo=; b=MiQlMo6j9X/NiWXJlCI9P86fb
        qTUPp480qtglkp6TAGe7p3VF+/sx32kEauS058GCHz5Ct3+4bkaYyk+VPsD3WWYGGG8/omIXmN9KW
        j9AHpHdhkkm7AgrKjbdszMPtZE6tl6LfYVEH3Wjn7bMNLqegNx69qsocw+zbIW2zbifwByVzVkhIP
        xCQiz2VEWASHx0XoIHTnRb7eE9CBantCzIu8SQuwYnVqQP8rFXlu8kJVTBgiSki7VEpCbZnYV9CjD
        yOxbqiwLFEV5G+bDZDhB2jCQU+FMIRjbkqpnuldzT/hwv5e5xW/gJ1KbV/FGiXL6d/38v9CdnX4Cq
        CrbbO6MMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50086)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jORXG-0001kz-3Y; Tue, 14 Apr 2020 20:47:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jORXF-0008OR-Id; Tue, 14 Apr 2020 20:47:53 +0100
Date:   Tue, 14 Apr 2020 20:47:53 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/2] Fix 88x3310 leaving power save mode
Message-ID: <20200414194753.GB25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series fixes a problem with the 88x3310 PHY on Macchiatobin
coming out of powersave mode noticed by Matteo Croce.  It seems
that certain PHY firmwares do not properly exit powersave mode,
resulting in a fibre link not coming up.

The solution appears to be to soft-reset the PHY after clearing
the powersave bit.

We add support for reporting the PHY firmware version to the kernel
log, and use it to trigger this new behaviour if we have v0.3.x.x
or more recent firmware on the PHY.  This, however, is a guess as
the firmware revision documentation does not mention this issue,
and we know that v0.2.1.0 works without this fix but v0.3.3.0 and
later does not.

 drivers/net/phy/marvell10g.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
