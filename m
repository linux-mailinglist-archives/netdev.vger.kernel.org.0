Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376A11E3F15
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgE0Kdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgE0Kdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:33:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EABC061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ihrPTYO/YkIEIQ1nSovj10P5ECoY8+Ut7ylWDo9K52I=; b=tj1DWSODeBm4ZPIVft8EFENy9
        D8OUr1LTrPyPoZN8KDAKxSwicQfZ6FnO0wFN+AFjgkinKj15URoVqyBh2cKau7SdZ66jlxqIxQJm6
        p8GMX9G0CnDN1YzpWzMLQ0cMvrR1EbTee5oICF2AxHQFBKBdJyJ5izMAWa38mbYtG+2Aslhq/FxWB
        TdFCA6RKzZVNvqCsqP9Dj2DoRDuufxtxZkNlxKDVXQwkpktvcNmPfAdQ08S04tsRJlWkGJjnFDdOk
        d+AS4oVPLj5sfvJ/rwWD7kSDAW5w64cl7xgtgEICiVH+ewHddNKiTI8iJQoVV1+342w8o5NwftHuj
        m4kmCUQZA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45686)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jdtNB-0001wE-5y; Wed, 27 May 2020 11:33:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jdtN8-0006La-Nu; Wed, 27 May 2020 11:33:18 +0100
Date:   Wed, 27 May 2020 11:33:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Subject: [PATCH RFC v2 0/9] Clause 45 PHY probing cleanups
Message-ID: <20200527103318.GK1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is version 2 of my proposal to expand our Clause 45 PHY probing.
This series does not change the functionality beyond probing further
MMDs.

The first four patches clean up get_phy_device() and called functions,
updating the kernel doc, adding information about the various error
return values.

This is not against net-next nor net trees, but against my own private
tree, but I'm posting it to serve as an illustration of what I think
should be done - I knocked this up this morning.

I haven't tested the new changes in version 2 yet beyond compile
testing.

Given the proximity of the merge window, this *isn't* code I'd like to
see merged into net-next - it's way too risky at this point.  So, we
have time to consider our options.

If we want to start scanning for Clause 45 PHYs like we do for Clause
22 PHYs, we definitely need to have indications from the MDIO drivers
that they support Clause 45 accesses, or all MDIO drivers audited to
add the necessary rejection; many of them do not explicitly reject a
request to perform Clause 45 accesses, and will just try and fit the
unmasked register address into their registers, potentially setting
invalid bits when writing their registers.

Changes from v2:
- Further cleanups to get_phy_c45_ids(), get_phy_c22_id() and
  get_phy_device(), with kerneldoc updates to better describe what
  is going on, and what the error return codes signify.

- Only read status register 2 to detect device presence for the
  two vendor MMDs which we know are a potential problem on 88x3310
  PHYs.  We can expand to also check MMDs 1 through 6 if necessary,
  but that would be a behaviour change beyond what this series is
  trying to do.

Unaddressed issues:
- Reading zero from PHY ID registers - OUI 00:00:00 is allocated to
  Xerox Corporation, but it's unlikely that there is a PHY out there
  validly using this OUI. However, I believe that we do know that
  there are PHYs with zero PHY ID registers (in DSA switches, Andrew?)

- mmds_present - I have a patch on top of this which clears the vendor
  MMDs if the devices-present field in status register 2 indicates
  not-present.  We may wish to do this for MMDs 1 through 6 as well
  which have status register 2, but that comes with some risk.

Discussion points:
- drivers/net/phy is becoming quite large, do we want to split it
  into separate subdirectories for PHY drivers, MDIO drivers, and
  core code?
- I have a patch that splits the "genphy" clause 22 code like I did
  with the clause 45 code, which will need refreshing before I
  submit - do my fellow phylib maintainers think that's a good move?

 drivers/net/phy/phy-c45.c    |   4 +-
 drivers/net/phy/phy_device.c | 159 ++++++++++++++++++++++++++++---------------
 drivers/net/phy/phylink.c    |   8 +--
 include/linux/phy.h          |   8 ++-
 4 files changed, 117 insertions(+), 62 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
