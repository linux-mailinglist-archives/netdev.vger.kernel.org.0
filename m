Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE96346BFEF
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbhLGPzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239121AbhLGPzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:55:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B75C061746
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 07:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mHHA4yNbkBopyxIjfJPY6MSbIpnvXuPcH/0ewslIK50=; b=Cg4u354wikJNNrDdU/27QOIjI4
        RkJugbt/S55vLhL2Y01crzU7UoJL9zp/grZEDjlU0yZMSTNIYreQ7kfTxqcWeqmOfyMwBb43cqxt7
        bgOkmEhpI5epoI18AyvfgDt+l/tEpDt4d1NfmdmFREn4D91maqdLLC2OhCW+MLTxOhulaE2iCR9Hu
        8Y1fLEwQmteH5seCtdnWKMdgHTdWhfU0+n5jsT1H9h7p+R4PPtDZZobXWTWVW9L1NOpPqwI2yp2KT
        Q0in9lqXUnAenM50ingsuV1fBaW++Q4zbH+CT8Zh5ulmntd50C+He8ddJvHqvXee7ijbkRNJWLu8f
        SSnT1xUA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56166)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mucl3-0006Od-CQ; Tue, 07 Dec 2021 15:51:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muckz-0005SZ-Ck; Tue, 07 Dec 2021 15:51:53 +0000
Date:   Tue, 7 Dec 2021 15:51:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5] net: phylink: introduce legacy mode flag
Message-ID: <Ya+DGaGmGgWrlVkW@shell.armlinux.org.uk>
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
these legacy drivers - in that we wish to allow the "modern" behaviour
where mac_config() is not called on link-up events, even if there is
no PCS attached.

In order to do that, this series of patches introduce a
"legacy_pre_march2020" which is used to permit the old behaviour - in
other words, we get the old behaviour only when there is no PCS and
this flag is true. Otherwise, we get the new behaviour.

I decided to use the date of the change in the flag as just using
"legacy" or "legacy_driver" is too non-descript. An alternative could
be to use the git sha1 hash of the set of changes.

I believe I have added the legacy flag to all the drivers which use
legacy mode - that being the mtk_eth_soc ethernet driver, and many DSA
drivers - the ones which need the old behaviour are identified by
having non-NULL phylink_mac_link_state or phylink_mac_an_restart
methods in their dsa_switch_ops structure.

ag71xx and xilinx do not need the legacy flag. ag71xx is explained in
its own commit, and xilinx only updates the inband advertisement in
the mac_config() call, which is sufficient qualification to avoid it
being marked legacy.

 drivers/net/ethernet/atheros/ag71xx.c       | 13 -------------
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  4 ++++
 drivers/net/phy/phylink.c                   | 12 ++++++------
 include/linux/phylink.h                     | 20 ++++++++++++++++++++
 net/dsa/port.c                              |  7 +++++++
 5 files changed, 37 insertions(+), 19 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
