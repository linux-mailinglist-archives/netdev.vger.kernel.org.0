Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A508B2F0C07
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbhAKFBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:01:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbhAKFBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:01:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EFCA224D2;
        Mon, 11 Jan 2021 05:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610341252;
        bh=tWfxmGVxPkbPfCDlqIJfsSLcejDD0RKbfpiQLiLFgJk=;
        h=From:To:Cc:Subject:Date:From;
        b=VEmdbjZ4q9PtOo2rpt+Nl5+bzlmfqwGSMFBd1BETPS8aSL6vnlQaLI6MWkgUVA42d
         39cduq8IwVJTSyepwMabg1BU8geM8Obss0Tp6yGUbtODARO/a+v0eWOTENMwv2f1aM
         z4MLZi0pcYSL2QZSbbc6SFLrWqQzZVqSegOAIFYPd7zFRsZf/2ACaNdR6N4vL4B7Ee
         YuB2nknt0eHhahGXAfYv/kOZojuLfF3Auha1CNukfKiMw6plxrgBCXxBxkZ0VG0umR
         /pW71yomzlc8XQA2PGCo2KglLr8uys1IFBTyGubkQ1NDXsmSh3JVN98oQQAMS2Zaab
         z+quIxIq+6haw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 0/4] Support for RollBall 10G copper SFP modules
Date:   Mon, 11 Jan 2021 06:00:40 +0100
Message-Id: <20210111050044.22002-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is v4 of series adding support for RollBall/Hilink SFP modules.

Checked with:
  checkpatch.pl --max-line-length=80

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

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>

Marek Behún (4):
  net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
  net: phylink: allow attaching phy for SFP modules on 802.3z mode
  net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY
    release
  net: sfp: add support for multigig RollBall transceivers

 drivers/net/mdio/mdio-i2c.c   | 319 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/phylink.c     |   5 +-
 drivers/net/phy/sfp.c         |  66 +++++--
 include/linux/mdio/mdio-i2c.h |   8 +-
 4 files changed, 378 insertions(+), 20 deletions(-)


base-commit: 73b7a6047971aa6ce4a70fc4901964d14f077171
-- 
2.26.2

