Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FA52B4266
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgKPLPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:15:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgKPLPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 06:15:20 -0500
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B392C22265;
        Mon, 16 Nov 2020 11:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605525320;
        bh=6yhNMMFsa/O9sk8AP2iPTz5RzxOq5jZWzB852AKZguQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ATBlYKTeuvpNGhu3izYr8SQlK6YW+mRTk78QLR6J8J5Qw6OMk3AruCwbYcSXQjQui
         GYOIwZLkdNjeVid06TcxIsJvfV3YT12Gm4N7TVe0GWgqdkDEsEPOmfd06/wzkIHilI
         I/zWjvTNH93UUPS5mcBvvpPKCbGbQoqOq6pfct+w=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 0/5] Support for RollBall 10G copper SFP modules
Date:   Mon, 16 Nov 2020 12:15:06 +0100
Message-Id: <20201116111511.5061-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is v3 of series adding support for RollBall/Hilink SFP modules.

Checked with:
  checkpatch.pl --max-line-length=80

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

Marek Behún (5):
  net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
  net: phylink: allow attaching phy for SFP modules on 802.3z mode
  net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY
    release
  net: phy: marvell10g: change MACTYPE if underlying MAC does not
    support it
  net: sfp: add support for multigig RollBall transceivers

 drivers/net/mdio/mdio-i2c.c   | 236 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/marvell10g.c  |  31 +++++
 drivers/net/phy/phylink.c     |   5 +-
 drivers/net/phy/sfp.c         |  65 ++++++++--
 include/linux/mdio/mdio-i2c.h |   8 +-
 5 files changed, 325 insertions(+), 20 deletions(-)


base-commit: 0064c5c1b3bf2a695c772c90e8dea38426a870ff
-- 
2.26.2

