Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D081C735B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 16:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbgEFOy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 10:54:59 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:44863 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729078AbgEFOy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 10:54:59 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 20DBA22EDE;
        Wed,  6 May 2020 16:54:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588776897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zolYeUhjgGOAZ1l2pBLLJhfufCbpl7VPTkzn4MCpjFo=;
        b=DJqQ5bZJ7QL13ss2Pj/EU4PvZNf9rNaxIKDKd+DnWULltK9HFBFldIrmMBpb/shtjcLIeY
        X8Snv6A6f5ipupw5gH+i6Cr8iT3G+ZUXPaWaSDKAMPPGODnp3biNalChTZLxpm4FXEdg8X
        N6pytg7t3E3D4yuJORKDlutYS8C2FFE=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 0/3] add phy shared storage
Date:   Wed,  6 May 2020 16:53:12 +0200
Message-Id: <20200506145315.13967-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the concept of a shared PHY storage which can be used by some
QSGMII PHYs to ease initialization and access to global per-package
registers.

Changes since v2:
 - restore page to standard after reading the base address in the mscc
   driver, thanks Antoine.

Changes since v1:
 - fix typos and add a comment, thanks Florian.
 - check for "addr < 0" in phy_package_join()
 - remove multiple blank lines and make "checkpatch.pl --strict" happy

Changes since RFC:
 - check return code of kzalloc()
 - fix local variable ordering (reverse christmas tree)
 - add priv_size argument to phy_package_join()
 - add Tested-by tag, thanks Vladimir.

Michael Walle (3):
  net: phy: add concept of shared storage for PHYs
  net: phy: bcm54140: use phy_package_shared
  net: phy: mscc: use phy_package_shared

 drivers/net/phy/bcm54140.c       |  57 +++----------
 drivers/net/phy/mdio_bus.c       |   1 +
 drivers/net/phy/mscc/mscc.h      |   1 -
 drivers/net/phy/mscc/mscc_main.c | 101 +++++++---------------
 drivers/net/phy/phy_device.c     | 138 +++++++++++++++++++++++++++++++
 include/linux/phy.h              |  90 ++++++++++++++++++++
 6 files changed, 271 insertions(+), 117 deletions(-)

-- 
2.20.1

