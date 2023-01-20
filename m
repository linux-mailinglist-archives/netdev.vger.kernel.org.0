Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A668676041
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjATWkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjATWkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:40:23 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD1D7F997;
        Fri, 20 Jan 2023 14:40:21 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A704911FB;
        Fri, 20 Jan 2023 23:40:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674254419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L5ySbynlRd03+mC00y1MsXYQTBq0njvvGbWSbHrwuRo=;
        b=VVJo3ZVlk6cFNWqbF7TwzaJ47eFqfK7oyM7NJ6UvXE3gsmhXs7dvsvW7iX0qBVZcU/DzVi
        Cx6iyZiRT2oLujXfX3qd4AFkRXsmNN9AU5m7Nw9NLoU9AHenfQB4AeTGXp4SQGtnpuw8wq
        8Ngc2uZAyGegjvD8IjeU+mlB3AhAz8XTZpmFkQV2fQXzLwnwpaFPkw2TNisIqDC4Y7IdIg
        uQh6iX+nFEOLYPanu1jeTO14SpIGtevHgGlPHj5hfejIrBoncAtUyR5NCqFB5N2O6sklHw
        MjBcPRR3ulFH8Yeoh+eP2hbOUSPGuC7Ntg3NN3zwsW8n3HxxKgv7yXrbzmJlbA==
From:   Michael Walle <michael@walle.cc>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/5] net: phy: C45-over-C22 access
Date:   Fri, 20 Jan 2023 23:40:06 +0100
Message-Id: <20230120224011.796097-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the c22 and c45 access split is finally merged. This can now be
posted again. The old version can be found here:
https://lore.kernel.org/netdev/20220325213518.2668832-1-michael@walle.cc/
Although all the discussion was here:
https://lore.kernel.org/netdev/20220323183419.2278676-1-michael@walle.cc/

The goal here is to get the GYP215 and LAN8814 running on the Microchip
LAN9668 SoC. The LAN9668 suppports one external bus and unfortunately, the
LAN8814 has a bug which makes it impossible to use C45 on that bus.
Fortunately, it was the intention of the GPY215 driver to be used on a C22
bus. But I think this could have never really worked, because the
phy_get_c45_ids() will always do c45 accesses and thus gpy_probe() will
fail.

Introduce C45-over-C22 support and use it if the MDIO bus doesn't support
C45. Also enable it when a PHY is promoted from C22 to C45.

Changes since RFC v2:
 - Reased to latest net-next
 - new check_rc argument in mmd_phy_indirect() to retain old behavior
 - determine bus capabilities by bus->read and bus->read_c45
 - always set phydev->c45_over_c22 if PHY is promoted

Changes since RFC v1:
 - use __phy_mmd_indirect() in mdiobus_probe_mmd_read()
 - add new properties has_c45 c45_over_c22 (and remove is_c45)
 - drop MDIOBUS_NO_CAP handling, Andrew is preparing a series to
   add probe_capabilities to mark all C45 capable MDIO bus drivers

Michael Walle (5):
  net: phy: add error checks in mmd_phy_indirect() and export it
  net: phy: support indirect c45 access in get_phy_c45_ids()
  net: phy: add support for C45-over-C22 transfers
  phy: net: introduce phy_promote_to_c45()
  net: phy: mxl-gpy: remove unneeded ops

 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  4 +-
 drivers/net/phy/bcm84881.c                    |  2 +-
 drivers/net/phy/marvell10g.c                  |  2 +-
 drivers/net/phy/mxl-gpy.c                     | 33 +-------
 drivers/net/phy/phy-core.c                    | 48 ++++++++---
 drivers/net/phy/phy.c                         |  6 +-
 drivers/net/phy/phy_device.c                  | 80 ++++++++++++++++---
 drivers/net/phy/phylink.c                     |  8 +-
 include/linux/phy.h                           | 12 ++-
 9 files changed, 128 insertions(+), 67 deletions(-)

-- 
2.30.2

