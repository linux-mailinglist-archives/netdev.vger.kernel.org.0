Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7833749B90C
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1584078AbiAYQoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584421AbiAYQjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:39:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7F3C06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iBgrG/gBISHMGfEBzvZYuR+G2ZM555TQPeqmS+L9Ggk=; b=oM9ztmc8AkDFsAaFbMlhqDErwd
        dX2m/uHjoEsWCdOyWk2+N7+3UJlDK2TK4+ztZoLVlafaSwr5z3wuCDSAFmL7sml9SJQExl3JAGqlk
        NPL5fTxh/qLFCA6S16/hWwt2YLui/UrJpdnpfLOz5SWz60uJ4ZxO32BX6dwudPMRanlQfrUQa9RR6
        zbKDI7FGFr2dO74MGWZFOsKmJxrS/ZpV34NwHdU99iFHsk/VcbNjRaPA82gkRyotrm/9s/Azl5rEe
        y2yrZE7SlcVq8azVVyzxdbzARdts7+FZgkDBwqEWpnP8rFrAi5AiY+DNpq4I+9i5BranSxU9A78D6
        AH4mhnWg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56858)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCOqI-0002Ad-J5; Tue, 25 Jan 2022 16:38:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCOqA-0003Qo-8M; Tue, 25 Jan 2022 16:38:42 +0000
Date:   Tue, 25 Jan 2022 16:38:42 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/7] net: stmmac/xpcs: modernise PCS support
Message-ID: <YfAnkuhiMoeFcVnb@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series updates xpcs and stmmac for the recent changes to phylink
to better support split PCS and to get rid of private MAC validation
functions.

This series is slightly more involved than other conversions as stmmac
has already had optional proper split PCS support.

The first six patches of this series were originally posted on 16th
December for CFT, and Wong Vee Khee reported his Intel Elkhart Lake
setup was fine the first six these. However, no tested-by was given.

The patches:

1) Provide a function to query the xpcs for the interface modes that
   are supported.

2) Populates the MAC capabilities and switches stmmac_validate() to use
   phylink_get_linkmodes(). We do not use phylink_generic_validate() yet
   as (a) we do not always have the supported interfaces populated, and
   (b) the existing code does not restrict based on interface. There
   should be no functional effect from this patch.

3) Populates phylink's supported interfaces from the xpcs when the xpcs
   is configured by firmware and also the firmware configured interface
   mode. Note: this will restrict stmmac to only supporting these
   interfaces modes - stmmac maintainers need to verify that this
   behaviour is acceptable.

4) stmmac_validate() tail-calls xpcs_validate(), but we don't need it to
   now that PCS have their own validation method. Convert stmmac and
   xpcs to use this method instead.

5) xpcs sets the poll field of phylink_pcs to true, meaning xpcs
   requires its status to be polled. There is no need to also set the
   phylink_config.pcs_poll. Remove this.

6) Switch to phylink_generic_validate(). This is probably the most
   contravertial change in this patch set as this will cause the MAC to
   restrict link modes based on the interface mode. From an inspection
   of the xpcs driver, this should be safe, as XPCS only further
   restricts the link modes to a subset of these (whether that is
   correct or not is not an issue I am addressing here.) For
   implementations that do not use xpcs, this is a more open question
   and needs feedback from stmmac maintainers.

7) Convert to use mac_select_pcs() rather than phylink_set_pcs() to set
   the PCS - the intention is to eventually remove phylink_set_pcs()
   once there are no more users of this.

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 147 +++++++---------------
 drivers/net/pcs/pcs-xpcs.c                        |  41 +++---
 include/linux/pcs/pcs-xpcs.h                      |   3 +-
 3 files changed, 73 insertions(+), 118 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
