Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F886475BE3
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243955AbhLOPdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhLOPdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:33:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FF4C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EjS6/74HdveiK0yFnJxz0Chysh58HHnzd1NZvs3z3zQ=; b=Fu0RNBtFdjt54/vncKn9ja3dPt
        PKSKZu4cLftcqntoGqMBhicfpNw9UI68qcL5PzxAUmovMEzckv7yh7kU/+X5pSTqJ5ob0RGzmu2Jc
        WGEP16JGo6VSfT0TPiM1iU6keg4JtWolh+i0xaD8GPy43cro+E6JuLJDccWGpXByGyxc5eBL/Q2lc
        xmSDzhzrTYcCViAhDQG4U1695nNUOTWsQYTO0VL1z3kvljuz7QrDNALYdqT981AQ/KVMu5Eif/1UX
        HwiquvUfk9eSoolP7vDow8yOi+8Admdk2QDU0XYR3qei4dIWu3jTnzR2Qm5+D5+W9UqsDU8td2bDK
        Zi3yF+NA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56306)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxWHa-0006Yo-7o; Wed, 15 Dec 2021 15:33:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxWHX-0004a5-6W; Wed, 15 Dec 2021 15:33:27 +0000
Date:   Wed, 15 Dec 2021 15:33:27 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next v2 0/7] net: phylink: add PCS validation
Message-ID: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
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

v2: fix kerneldoc typo in patch 1.

 drivers/net/ethernet/marvell/mvneta.c           | 229 ++++++++++++++++--------
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 112 ++++++------
 drivers/net/phy/phylink.c                       |  99 +++++++++-
 include/linux/phylink.h                         |  38 ++++
 5 files changed, 337 insertions(+), 144 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
