Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F89459F8F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 10:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhKWJ4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 04:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhKWJ4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 04:56:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BC2C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 01:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JYTFw20Aliur826yDh9Z24rOItlz7fSKajI2iQUIiX8=; b=Yo5f0SjEg9Wh3UxlfGJuxZ+WQV
        dAHwd5WaUxJlf9Iu6bL3REtmMg/0/Lwm5nWdWsPOBFcp/ioL9trUi/wmizlnt5GVAfNZb5IsAiKJm
        W6neUohco6UibmMiF/FCeAcghv0kUvxPwttW3LIA/KkEjsX9CQtZUaGA8ZTHYKoXnsBH2MIzJBoao
        JIbTKcO578taMyUhLNto/S8QOgJL/XsXIEoOKvH5cBTr8PeJ82WIEcnWLxbUvdilfncLbZjI19f56
        fLIYOb58vPS8xtMxnR6cSKXBce3h8xVa71GXCRK5Mqpw8Jt2//pIWYu+qKWnM2MMZ0XRY7sOTvprB
        Q3n5/NAA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55808)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpSTy-0007gp-Ut; Tue, 23 Nov 2021 09:52:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpSTs-00007E-Pi; Tue, 23 Nov 2021 09:52:52 +0000
Date:   Tue, 23 Nov 2021 09:52:52 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 0/8] net: phylink: introduce legacy mode flag
Message-ID: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

In March 2020, phylink gained support to split the PCS support out of
the MAC callbacks. By doing so, a slight behavioural difference was
introduced when a PCS is present, specifically:

1) the call to mac_config() when the link comes up or advertisement
   changes were eliminated
2) mac_an_restart() will never be called
3) mac_pcs_get_state() will never be called

The intention was to eventually remove this support once all phylink
users were converted. Unfortunately, this still hasn't happened - and
in some cases, it looks like it may never happen.

Through discussion with Sean Anderson, we now need to allow the PCS to
be optional for modern drivers, so we need a different way to identify
these legacy drivers.

In order to do that, this series of patches introduce a
"legacy_pre_march2020" which is used to allow the old behaviour - in
other words, we get the old behaviour only when there is no PCS and
this flag is true. Otherwise, we get the new behaviour.

I decided to use the date of the change in the flag as just using
"legacy" or "legacy_driver" is too non-descript. An alternative could
be to use the git sha1 hash of the set of changes.

As part of this series, I have consolidated DSA's phylink creation, so
only one place needs maintenance. This reduces the size of subsequent
changes, including further changes I have lined up.

I believe I have added the legacy flag to all the drivers which use
legacy mode - that being the ag71xx, mtk_eth_soc and axienet ethernet
drivers, and many DSA drivers - the ones which need the old behaviour
are identified by having non-NULL phylink_mac_link_state or
phylink_mac_an_restart methods in their dsa_switch_ops structure.

 drivers/net/ethernet/atheros/ag71xx.c             |  1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c       |  4 ++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  1 +
 drivers/net/phy/phylink.c                         | 32 +++++++++-----
 include/linux/phylink.h                           | 20 +++++++++
 net/dsa/dsa_priv.h                                |  2 +-
 net/dsa/port.c                                    | 51 ++++++++++++++++-------
 net/dsa/slave.c                                   | 19 ++-------
 8 files changed, 86 insertions(+), 44 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
