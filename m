Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611B369A422
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjBQDH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQDHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:07:24 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8885382B
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=oxa+oDttL2CTSaQNVBE30YPnEQvr0ZrureSlJH1IzN8=; b=Xp3TK86LgOGPa6bs5+F3i46eBT
        AZImKL9sBT9/tIpPytJ6rxktouXr3mmFHCZZuBa3LR2UrovlbsBPSNhxrlvekotGmzUKBbk89CCPP
        QvGwHtCEghfr5kT8LsJk537YiD6E56xHF3WFeZRaQI9WzIO3stydiCnzkFbW88466y2A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSr5k-005EvU-TA; Fri, 17 Feb 2023 04:07:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/2] Add additional phydev locks
Date:   Fri, 17 Feb 2023 04:07:12 +0100
Message-Id: <20230217030714.1249009-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phydev lock should be held when accessing members of phydev, or
calling into the driver. Some of the phy_ethtool_ functions are
missing locks. Add them. To avoid deadlock the marvell driver is
modified since it calls one of the functions which gain locks, which
would result in a deadlock.

The missing locks have not caused noticeable issues, so these patches
are for net-next.

Andrew Lunn (2):
  net: phy: marvell: Use the unlocked genphy_c45_ethtool_get_eee()
  net: phy: Add locks to ethtool functions

 drivers/net/phy/marvell.c |  2 +-
 drivers/net/phy/phy.c     | 84 ++++++++++++++++++++++++++++++---------
 drivers/net/usb/lan78xx.c |  2 -
 3 files changed, 67 insertions(+), 21 deletions(-)

-- 
2.39.1

