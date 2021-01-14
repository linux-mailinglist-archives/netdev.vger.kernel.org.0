Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741982F59FD
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbhANEoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:44:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbhANEoW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:44:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21262238E5;
        Thu, 14 Jan 2021 04:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610599421;
        bh=PJcJ356rMi4m1fGE1i7tFlok0cK4u0GzoKOq8MjdIFU=;
        h=From:To:Cc:Subject:Date:From;
        b=gDpSmbyVHU0q1nWO3JYGXJUy14XWLDpS/Rrr7418SbTCCqv1CC8TH6OT3WWChamjm
         EVjsaUqmIncGQyRF6i+Dwz7j3/Cy2samDtHPRsVK8X9mEn+YGDOlVjx9b12i9Vp014
         pi+tx1+4ujIOMDB/nsOLQdAInvboEEUiveYpriYeeonfdFdVyMYYCD1Sz8I41i8YV3
         4opKxncnRnXGAT/geji3AyW1NYmh5wMnIyBoNr/RHY9Ih/z6c2JVKPKUE1hohpPmaB
         kYygG1Zr9lg5Uu6AOP3ucmq5MfazGFlUvAiFAURJC/Ir6zvtS4N2MOviZGEE1pZQkg
         XQFihstdM1Fyw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v5 0/5] Support for RollBall 10G copper SFP modules
Date:   Thu, 14 Jan 2021 05:43:26 +0100
Message-Id: <20210114044331.5073-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is v5 of series adding support for RollBall/Hilink SFP modules.

Checked with:
  checkpatch.pl --max-line-length=80

Changes from v4:
- added patch adding SFP_PASSWORD = 0x7b to sfp.h
- patch adding RollBall MDIO I2C protocol support
  - removed forgotten comment that was no longer true
  - we now try to restore the page if the I2C transfer failed
  - unfortunately we cannot simply move the code to do paged I2C
    transfers to sfp.c, because sfp.c depends on code inmdio-i2c.c,
    and if we added dependency the other way, I don't know what
    would happen to module loader (since both SFP and MDIO_I2C can
    be compiled as modules).
    This can be refactored later, when someone needs paged I2C
    accesses in sfp.c
- added Reviewed-by tags

Changes from v3:
- RollBall mdio-i2c driver now sets/restores SFP_PAGE for every MDIO
  access.
  I first wanted to achieve this operation (setting
  SFP_PAGE/doing MDIO/restoring SFP_PAGE) via one call do i2c_transfer,
  by constructing msgs array in such a way, but it turned out that this
  doesn't work on RollBall SFPs, because changed SFP_PAGE takes into
  account only after i2c_transfer ends.
  So instead I use i2c_lock_bus/serveral __i2c_transfers/i2c_unlock_bus.
- I have removed the patch which changes MACTYPE in the marvell10g
  driver, since Russell has in his net-queue a better solution. I still
  think that my patch would have sufficed temporarily (and would not
  cause regressions), but nobody wanted to review it. If you think that
  I should sent this series again with that patch, please let me know.

Changes from v2:
- added comment into the patch adding support for RollBall I2C MDIO
  protocol, saying that we expect the SFP_PAGE not to be changed by
  the SFP code, as requested by Russell. If, in the future, SFP code
  starts modifying SFP_PAGE, we will have to handle it in mdio-i2c
  somehow
- destruction of I2C MDIO bus in patch 3/5 now depends on whether the
  MDIO bus is not NULL, instead of whether PHY exists, as suggested by
  Russell
- changed waiting time for RollBall module to initialize from 30 seconds
  to 25 seconds. Testing shows that it is never longer than 21-22
  seconds, so waiting 25 seconds instead of 30 is IMO safe enough
- added Russell's Reviewed-by tags where relevant

Changes from v1:
- wrapped to 80 columns as per Russell's request
- initialization of RollBall MDIO I2C protocol moved from sfp.c to
  mdio-i2c.c as per Russell's request
- second patch removes the 802.3z check also from phylink_sfp_config
  as suggested by Russell
- creation/destruction of mdiobus for SFP now occurs before probing
  for PHY/after releasing PHY (as suggested by Russell)
- the last patch became a little simpler after the above was done

Marek

Marek Behún (5):
  net: sfp: add SFP_PASSWORD address
  net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
  net: phylink: allow attaching phy for SFP modules on 802.3z mode
  net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY
    release
  net: sfp: add support for multigig RollBall transceivers

 drivers/net/mdio/mdio-i2c.c   | 308 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/phylink.c     |   5 +-
 drivers/net/phy/sfp.c         |  66 ++++++--
 include/linux/mdio/mdio-i2c.h |   8 +-
 include/linux/sfp.h           |   1 +
 5 files changed, 368 insertions(+), 20 deletions(-)


base-commit: 0ae5b43d6dde6003070106e97cd0d41bace2eeb2
-- 
2.26.2

