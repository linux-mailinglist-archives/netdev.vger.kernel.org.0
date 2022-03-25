Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C1E4E7CD2
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiCYVhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbiCYVhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:37:04 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370EC49CA0;
        Fri, 25 Mar 2022 14:35:26 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 58EB022247;
        Fri, 25 Mar 2022 22:35:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648244125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RBr8QAEuo8HHbbztFI4VB6EfKz9bI4G2lxNCA6d5X+s=;
        b=jXNr0n2LpUG6EMjEhNvNjTXchnP+C+AQyZkK2EkBwoJcNZlY9W1qnKsZ1KUsG62oUlApzz
        EGG5tWzz9uNLdUwVxwsJKoNTwWks6KG+f5ESEFh4vN9BPQwDDwuPjQcTEi0kn2RjuKUCUj
        vF8XU1QtvfFMo8jA7mFkxkcfg5JDR6o=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 0/8] net: phy: C45-over-C22 access
Date:   Fri, 25 Mar 2022 22:35:10 +0100
Message-Id: <20220325213518.2668832-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the result of this discussion:
https://lore.kernel.org/netdev/240354b0a54b37e8b5764773711b8aa3@walle.cc/

The goal here is to get the GYP215 and LAN8814 running on the Microchip
LAN9668 SoC. The LAN9668 suppports one external bus and unfortunately, the
LAN8814 has a bug which makes it impossible to use C45 on that bus.
Fortunately, it was the intention of the GPY215 driver to be used on a C22
bus. But I think this could have never really worked, because the
phy_get_c45_ids() will always do c45 accesses and thus on MDIO bus drivers
which will correctly check for the MII_ADDR_C45 flag and return -EOPNOTSUPP
the function call will fail and thus gpy_probe() will fail. This series
tries to fix that and will lay the foundation to add a workaround for the
LAN8814 bug by forcing an MDIO bus to be c22-only.

At the moment, the probe_capabilities is taken into account to decide if
we have to use C45-over-C22. What is still missing from this series is the
handling of a device tree property to restrict the probe_capabilities to
c22-only.

Since net-next is closed, this is marked as RFC to get some early feedback.

Changes since RFC v1:
 - use __phy_mmd_indirect() in mdiobus_probe_mmd_read()
 - add new properties has_c45 c45_over_c22 (and remove is_c45)
 - drop MDIOBUS_NO_CAP handling, Andrew is preparing a series to
   add probe_capabilities to mark all C45 capable MDIO bus drivers

Michael Walle (8):
  net: phy: mscc-miim: reject clause 45 register accesses
  net: phy: mscc-miim: add probe_capabilities
  net: phy: add error checks in __phy_mmd_indirect() and export it
  net: phy: add error handling for __phy_{read,write}_mmd
  net: phy: support indirect c45 access in get_phy_c45_ids()
  net: phy: add support for C45-over-C22 transfers
  phy: net: introduce phy_promote_to_c45()
  net: phy: mxl-gpy: remove unneeded ops

 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  4 +-
 drivers/net/mdio/mdio-mscc-miim.c             |  7 ++
 drivers/net/phy/bcm84881.c                    |  2 +-
 drivers/net/phy/marvell10g.c                  |  2 +-
 drivers/net/phy/mxl-gpy.c                     | 31 +------
 drivers/net/phy/phy-core.c                    | 47 +++++++---
 drivers/net/phy/phy.c                         |  6 +-
 drivers/net/phy/phy_device.c                  | 87 ++++++++++++++++---
 drivers/net/phy/phylink.c                     |  8 +-
 include/linux/phy.h                           | 12 ++-
 10 files changed, 136 insertions(+), 70 deletions(-)

-- 
2.30.2

