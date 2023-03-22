Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B326C49C4
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjCVL7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjCVL7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:59:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867A0570B2;
        Wed, 22 Mar 2023 04:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=js6wrcSboZp6fwXx17fVuydPet14APg414QbExASmX4=; b=On/jQ7qsZf3BuTxUJeQZPWpgYP
        UQCuAtAOcwCJWwCXahZGnC0pwmo6myigtM0UXirMiGcGsanafNLfEGk8eyqEYGGfaG6NCP+o3A2/l
        QLk8m2pkdZ6nk89J0aHpQxF2Bij6fKIeol65BgjwzJbvz5B3rrhI6GuY6Z45iIoZHbW9BubIi8NYa
        fkz8Q/1RuUiTCTfFESw0KfQfYZ23vVNdFb41xRx8ml8HA6nOHCCDwEnh+xx6orAK8TSplZUvCMmo2
        gsfIKYkZ7dF1vOE4Am26r80o8r26fA3WYAL5biKNPl2nZtHOhUgE+nYW6NHZ9ux54kAwaJhGvJwau
        GO4F3/LQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60718)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pex7z-00034v-Fj; Wed, 22 Mar 2023 11:59:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pex7w-0000KZ-H6; Wed, 22 Mar 2023 11:59:36 +0000
Date:   Wed, 22 Mar 2023 11:59:36 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 0/7] Another attempt at moving mv88e6xxx forward
Message-ID: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is another attempt to move the mv88e6xxx driver forward so that we
can eventually switch it to use phylink_pcs and become a non-legacy
driver.

The issue is that in order to switch to phylink_pcs, we need DSA and CPU
ports to be known to phylink, otherwise the PCS code will not be called.
In order for such ports to be known to phylink, we need to provide
phylink with a configuration, and mv88e6xxx has a history of not
specifying the configuration in firmware, but the driver internally
handling that. This is fine, but it means we can't use phylink for such
ports - and thus converting them to phylink_pcs can cause regressions.

Therefore, this series provides a way for a software-node configuration
to be provided to DSA by the driver, which will then be used only for
phylink to parse.

Some of this patch set comes from an idea from Vladimir, but
re-implemented in a substantially different way.

 drivers/base/swnode.c            |  14 +++-
 drivers/net/dsa/mv88e6xxx/chip.c | 157 ++++++++++++++++++++++++++++-----------
 drivers/net/phy/phylink.c        |  32 ++++++++
 include/linux/phylink.h          |   1 +
 include/linux/property.h         |   4 +
 include/net/dsa.h                |   3 +
 net/dsa/port.c                   |  33 ++++++--
 7 files changed, 191 insertions(+), 53 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
