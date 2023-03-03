Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517D86A9BF3
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCCQm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCCQm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:42:58 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1E330EC;
        Fri,  3 Mar 2023 08:42:56 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 52ECC4000C;
        Fri,  3 Mar 2023 16:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677861774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=csamStH77sJnPtDrYLR0tMq3UeHvDQUiPkz/YlTPbIM=;
        b=YGzJbpYZNE5r3p0wRdTwWTiraPIcTLdMTlpjLSYMDTSUsa6v0TkVAS9ENLio8IU6xSFEEo
        YEzMUlCgb/dhfs9FTBHxq5hMHjtk5Bz8/R5r4kbVQh7xGiEzA22vyCQ5KBKg6zoDQEjXiP
        xPdSbwIlPs/Bhk4I7V2m1+2g4+/WUlmhw1wqs6oitqfXelJRl1jhb3STM7Fs1n/B76WC52
        CdTPgNn9qqBpO258EovFmr91EBYge+VUDaaKWoh/zozA9BcTZXWWnw5loe3YcX2mEBIvVL
        PNcILevEluL4QohOUTZc//9pb8/3qfgWBWIlVyeDpKshbZ2LrCp+nlc9WVReYw==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sven Eckelmann <sven@narfation.org>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>
Subject: [PATCH v2 0/4] Up until now, there was no way to let the user select the layer at which time stamping occurs.  The stack assumed that PHY time stamping is always preferred, but some MAC/PHY combinations were buggy.
Date:   Fri,  3 Mar 2023 17:42:37 +0100
Message-Id: <20230303164248.499286-1-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kory Maincent <kory.maincent@bootlin.com>

This series aims to allow the user to select the desired layer
administratively.

- Patch 1 refactors get_ts_info copy/paste code.

- Patch 2 introduces sysfs files that reflect the current, static
  preference of PHY over MAC.

- Patch 3 makes the layer selectable at run time.

- Patch 4 fixes up MAC drivers that attempt to defer to the PHY layer.
  This patch is broken out for review, but it will eventually be
  squashed into Patch 3 after comments come in.

Changes in v2:
- Move selected_timestamping_layer variable of the concerned patch.
- Use sysfs_streq instead of strmcmp.
- Use the PHY timestamp only if available.

Richard Cochran (4):
  net: ethtool: Refactor identical get_ts_info implementations.
  net: Expose available time stamping layers to user space.
  net: Let the active time stamping layer be selectable.
  net: fix up drivers WRT phy time stamping

 .../ABI/testing/sysfs-class-net-timestamping  |  20 ++++
 drivers/net/bonding/bond_main.c               |  14 +--
 drivers/net/ethernet/freescale/fec_main.c     |  23 ++--
 drivers/net/ethernet/mscc/ocelot_net.c        |  21 ++--
 drivers/net/ethernet/ti/cpsw_priv.c           |  12 +--
 drivers/net/ethernet/ti/netcp_ethss.c         |  26 +----
 drivers/net/macvlan.c                         |  14 +--
 drivers/net/phy/phy_device.c                  |   6 ++
 include/linux/ethtool.h                       |   8 ++
 include/linux/netdevice.h                     |  10 ++
 net/8021q/vlan_dev.c                          |  15 +--
 net/core/dev_ioctl.c                          |  44 +++++++-
 net/core/net-sysfs.c                          | 102 ++++++++++++++++++
 net/core/timestamping.c                       |   6 ++
 net/ethtool/common.c                          |  24 ++++-
 15 files changed, 248 insertions(+), 97 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-timestamping

-- 
2.25.1

