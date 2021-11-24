Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422FB45CB5A
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbhKXRt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbhKXRt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:49:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2261C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NEvNh19qZGwS2YZGBm/NUCvk02dxswvb6+v9hLTYvL4=; b=DB5v13SRmAHwjKRtlaR7TbR/mQ
        iNPpxT3O3yTlD9gXSY9ty2mBuZMja0wC+qd9NoxKYz43FzoBrwHeS7pze3DIVC1CwelosR+xcFFow
        xA6zRvEN6lbZ6w+wSUWZM/atvH2ZsPWgztkUXf29luN200rHF3Xd9IJ19Q4giN+vybjm1plJqOnHG
        BTSaJi/LR0P4vec4bgOP4rsw3htYioJTRqJQeAMQu8H6h9eMy15dM79MFlMG96RQ1/ATsEEd5dSsX
        fFdzEpskK8ljAvcFN7RkOYhDXwQTH10DhQFBE4qvXyXBQd+GRDEYEq+TQ+2qvh2lQDkIPsaxs86Qw
        38Y0b2Kw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55860)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpwLM-0000vR-3y; Wed, 24 Nov 2021 17:46:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpwLJ-0001No-Cg; Wed, 24 Nov 2021 17:46:01 +0000
Date:   Wed, 24 Nov 2021 17:46:01 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH RFC net-next 00/12] Allow DSA drivers to set all phylink
 capabilities
Message-ID: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

During the last cycle, I introduced a phylink_get_interfaces() method
for DSA drivers to be able to fill out the supported_interfaces member
of phylink_config. However, further phylink development allowing the
validation hook to be greatly simplified became possible when a bitmask
of MAC capabilities is used along with the supported_interfaces bitmap.

In order to allow DSA drivers to fill out both fields, we either need
to add another method, or change the existing method. As there are no
users of the phylink_get_interfaces() yet, let's take the latter
approach, and pass the phylink_config structure to the DSA driver, so
that it can set both fields. (patch 3)

We also add the capability for DSA drivers to transition to using the
phylink_generic_validate() functionality by filling out the phylink
mac_capabilities field, and removing their .phylink_validate method.
(patch 2)

This series also contains an initial patch that consolidates the logic
in DSA around the call to phylink_create(), meaning that there becomes
a single site which issues the new call, rather than two. (patch 1)

The overall effect will be that, once this series has been applied, it
becomes possible to start eliminating the phylink validation
implementations scattered throughout the DSA drivers. Patches to do
this will follow once this series is merged.

I am including nine DSA drivers that were relatively simple to convert
in this series. The more complex ones will follow later. Please note
that none of these DSA drivers have been tested beyond a build-test,
so should be checked by the DSA switch driver maintainers.

 include/net/dsa.h  |  4 ++--
 net/dsa/dsa_priv.h |  2 +-
 net/dsa/port.c     | 48 +++++++++++++++++++++++++++++++-----------------
 net/dsa/slave.c    | 19 +++----------------
 4 files changed, 37 insertions(+), 36 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
