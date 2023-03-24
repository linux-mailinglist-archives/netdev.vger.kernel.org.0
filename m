Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF64E6C7B90
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjCXJg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCXJgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:36:55 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2DB1715E;
        Fri, 24 Mar 2023 02:36:53 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 52D4910000E;
        Fri, 24 Mar 2023 09:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679650611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nGkwEoCIycYJ0SUW05ydXlolQ0cbgo0HAFDl+fiDpk4=;
        b=k4I46tIm8YSHkt2AlYJSf/xeK3CNDnryU8yZ9S7zXmkdoMfJMcKV78+LJSmnd3LeeJm5B1
        x4APtoHQHQ5UdYGHM+R5C7Svy5oSk/fpyaF5TY6GcKdzrcB0njMmO/dYMbpbyrU7NSVPbf
        iFEFdBa2LNLcd2B73t773fRfucUzAICe6F3FvzLYAHJE7sJs0fuDooJ3Ad7pc2Pgv2Kmny
        HNqHbGtQ+mP9ucnctqO00ImRdW7ooJT5Zd0UnvnVPWOKm0v2qcAIhYZfRfLidIPHKfHe+3
        J+kE5UDQRyg3eBgbzLgMqPUaiU3hx9iWvDLTY0Knb+JSA98+ajvHVTrHUKE/5w==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [RFC 0/7] Introduce a generic regmap-based MDIO driver
Date:   Fri, 24 Mar 2023 10:36:37 +0100
Message-Id: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

When the Altera TSE PCS driver was initially introduced, there were
comments by Russell that the register layout looked very familiar to the
existing Lynx PCS driver, the only difference being that the TSE PCS
driver is memory-mapped whereas the Lynx PCS driver sits on an MDIO bus.

Since then, I've sent a followup to create a wrapper around Lynx, that
would create a virtual MDIO bus driver that would translate the mdio
operations to mmio operations [1].

Discussion ensued, and we agreed that we could make this more generic,
the idea being that this PCS isn't the only example of such a device,
that memory-maps an mdio-like register layout

Vladimir mentionned that some ocelot devices have the same kind of
problematic, but this time the devices sits on a SPI bus, exposing MDIO
registers.

This series therefore introduces a new "virtual" mdio driver, that would
translate MDIO accesses to an underlying regmap. That way, we can use
the whole phylink and phylib logic to configure the device (as phylink
interacts with mdiodevice's).

One issue encountered is that the MDIO registers have a stride of 1,
and we need to translate that to a higher stride for memory-mapped
devices. This is what the first 3 patches of this series do.

Then, patch 4 addresses a small inconsistency found in the only user of
regmap's reg_downshift.

Patch 5 introduces the new MDIO driver, while patch 6 makes use of it
by porting altera_tse to the Lynx PCS.

Finally patch 7 drops the TSE PCS driver, as it is no longer needed.

This series is a RFC as is still has a few shortcomings, but due to
various subsystems being involved, I'm sending it as a whole so that
reviewers can get a clear view of the big picture, the end-goal and the
various problems faces.

The existing shortcomings are :
 - The virtual MDIO bus driver can only have 1 mdio-device on it. If we
   have multiple ones that are memory-mapped onto the same range (with
   an offset, for example), we can't address them and we would have to
   create one such virtual bus driver per device. I don't know as of
   today if the problem will show-up for some users

 - With this series, we can also convert dwmac_socfpga to Lynx, but I've
   left this out for now

 - The renaming of regmap.format.reg_downshift to regmap.format.reg_shift
   can be confusing, as regmap.reg_shift also exists and has another
   meaning. I'm very bad at naming, so any suggestion is welcome.

Thanks,

Maxime

[1] : https://lore.kernel.org/all/20230210190949.1115836-1-maxime.chevallier@bootlin.com/

Maxime Chevallier (7):
  regmap: add a helper to translate the register address
  regmap: check for alignment on translated register addresses
  regmap: allow upshifting register addresses before performing
    operations
  mfd: ocelot-spi: Change the regmap stride to reflect the real one
  net: mdio: Introduce a regmap-based mdio driver
  net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
  net: pcs: Drop the TSE PCS driver

 MAINTAINERS                                   |  14 +-
 drivers/base/regmap/internal.h                |   2 +-
 drivers/base/regmap/regmap.c                  |  55 +++---
 drivers/mfd/ocelot-spi.c                      |   4 +-
 drivers/net/ethernet/altera/altera_tse.h      |   1 +
 drivers/net/ethernet/altera/altera_tse_main.c |  54 +++++-
 drivers/net/mdio/Kconfig                      |  11 ++
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/mdio-regmap.c                |  85 ++++++++++
 drivers/net/pcs/Kconfig                       |   6 -
 drivers/net/pcs/Makefile                      |   1 -
 drivers/net/pcs/pcs-altera-tse.c              | 160 ------------------
 include/linux/mdio/mdio-regmap.h              |  25 +++
 include/linux/pcs-altera-tse.h                |  17 --
 include/linux/regmap.h                        |  15 +-
 15 files changed, 223 insertions(+), 228 deletions(-)
 create mode 100644 drivers/net/mdio/mdio-regmap.c
 delete mode 100644 drivers/net/pcs/pcs-altera-tse.c
 create mode 100644 include/linux/mdio/mdio-regmap.h
 delete mode 100644 include/linux/pcs-altera-tse.h

-- 
2.39.2

