Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6864474580
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbhLNOrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbhLNOrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:47:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58146C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 06:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5pTNdABUj4qCdZs8ARcYb2AMhIl6UoCels6b1GNCGPk=; b=QeYDduwgl/7YAnutRRwR/mvuWy
        M7HZybzbLxIUZ+m/rDDlJkoj+Pue8CEe8Z8KmEix1B6+k1ElX3hAOnuw/kt21lS7L/st5pl4V8+kl
        +lVTwxS5cDgmpCnvr2/+GNrykN0njkqLplLs1+wUhBpkYSs6zAZfxhJrGruyqQB6A9EzIWNbIzkPS
        EYyYtzclZ0F1PSj3i628b4XJR0xqtyMGTC1L64BgFTPGEX+xRpTh9tZHb9/3KA4PKpowAVkMCOKiZ
        rZByjMNSZSvA/z5nThG492Cwh9EF6SQ6CggIgMKYLcm83Vy8lyZK2pmyYbQofiPxtVxDnxNuqgl+R
        a5ba0TBQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56276)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mx95R-00053w-R0; Tue, 14 Dec 2021 14:47:25 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mx95P-0003aK-3o; Tue, 14 Dec 2021 14:47:23 +0000
Date:   Tue, 14 Dec 2021 14:47:23 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next 0/7] net: phylink: add PCS validation
Message-ID: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series allows phylink to include the PCS in its validation step.
There are two reasons to make this change:

1. Some of the network drivers that are making use of the split PCS
   support are already manually calling into their PCS drivers to
   perform validation. E.g. stmmac with xpcs.

2. Logically, some network drivers such as mvneta and mvpp2, the
   restriction we impose in the validate() callback is a property of
   the "PCS" block that we provide rather than the MAC.

This series:

1. Gives phylink a mechanism to query the MAC driver which PCS is
   wishes to use for the PHY interface mode. This is necessary to allow
   the PCS to be involved in the validation step without making changes
   to the configuration.

2. Provide a pcs_validate() method that PCS can implement. This follows
   a similar model to the MAC's validate() callback, but with some minor
   differences due to observations from the various implementations.
   E.g. returning an error code for not-supported and the way the
   advertising bitmap is masked.

3. Convert mvpp2 and mvneta to this as examples of its use. Further
   Conversions are in the pipeline, including for stmmac+xpcs, as well
   as some DSA drivers. Note that DSA conversion to this is conditional
   upon all DSA drivers populating their supported_interfaces bitmap,
   since this is required before mac_select_pcs() can be used.

Existing drivers that set a PCS in mac_prepare() or mac_config(), or
shortly after phylink_create() will continue to work. However, it should
be noted that mac_select_pcs() will be called during phylink_create(),
and thus any PCS returned by mac_select_pcs() must be available by this
time - or we drop the check in phylink_create().

 drivers/net/ethernet/marvell/mvneta.c           | 229 ++++++++++++++++--------
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 112 ++++++------
 drivers/net/phy/phylink.c                       |  99 +++++++++-
 include/linux/phylink.h                         |  38 ++++
 5 files changed, 337 insertions(+), 144 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
