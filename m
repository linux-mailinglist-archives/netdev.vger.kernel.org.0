Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF19C6D9EC8
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbjDFRd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbjDFRdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:33:25 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D3483FB
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:33:12 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2A60F40003;
        Thu,  6 Apr 2023 17:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680802391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Bi/tcNb0XVuudJdkTi16BcuNGK2l+0eneIuwN+9k1YI=;
        b=LT8mSwWTgQbL2M/vuNdfKU/2sSb79VXdqMHSk8X8aPJrHuGhknVtL7D0Z/JLTPd0FU0ZYm
        3sN9SZSQbOLlWW7/IENXruvnuhJiwQ3u8Vgt6xXUalQC08KEQ314uKDYBeKOKlbirxVe5J
        H36VT//2sv4rd47zug8uTbGta+DL1ssKAMsKbfHEum98DBphTsOz8k+QWhxNfDYG/K1J+j
        PCIwuMsndDWNOI6kDGAr0cybEShNxNEMNp/cjf1u9r4yascSNWWR6bN0gfck3yEfGfuRMv
        R/5YnpL3cosdrWwDFD8Ge7RwHMkEyWbtj8/zGPaAqABYRkthhAAmHF2x0CojfQ==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
        vladimir.oltean@nxp.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk,
        Kory Maincent <kory.maincent@bootlin.com>
Subject: [PATCH net-next RFC v4 0/5] net: Make MAC/PHY time stamping selectable
Date:   Thu,  6 Apr 2023 19:33:03 +0200
Message-Id: <20230406173308.401924-1-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kory Maincent <kory.maincent@bootlin.com>

Up until now, there was no way to let the user select the layer at
which time stamping occurs.  The stack assumed that PHY time stamping
is always preferred, but some MAC/PHY combinations were buggy.

This series aims to allow the user to select the desired layer
administratively.

- Patch 1 refactors get_ts_info copy/paste code.

- Patch 2 introduces sysfs files that reflect the current, static
  preference of PHY over MAC.

- Patch 3 add devicetree binding to select the default time stamping.

- Patch 4 makes the layer selectable at run time.

- Patch 5 fixes up MAC drivers that attempt to defer to the PHY layer.
  This patch is broken out for review, but it will eventually be
  squashed into Patch 4 after comments come in.

Changes in v2:
- Move selected_timestamping_layer variable of the concerned patch.
- Use sysfs_streq instead of strmcmp.
- Use the PHY timestamp only if available.

Changes in v3:
- Expose the PTP choice to ethtool instead of sysfs.
  You can test it with the ethtool source on branch feature_ptp of:
  https://github.com/kmaincent/ethtool
- Added a devicetree binding to select the preferred timestamp.

Changes in v4:
- Move on to ethtool netlink instead of ioctl.
- Add a netdev notifier to allow packet trapping by the MAC in case of PHY
  time stamping.
- Add a PHY whitelist to not break the old PHY default time-stamping
  preference API.

Kory Maincent (3):
  net: Expose available time stamping layers to user space.
  dt-bindings: net: phy: add timestamp preferred choice property
  net: Let the active time stamping layer be selectable.

Richard Cochran (2):
  net: ethtool: Refactor identical get_ts_info implementations.
  net: fix up drivers WRT phy time stamping

 .../devicetree/bindings/net/ethernet-phy.yaml |   7 +
 Documentation/networking/ethtool-netlink.rst  |  53 ++++++
 drivers/net/bonding/bond_main.c               |  14 +-
 drivers/net/ethernet/freescale/fec_main.c     |  23 ++-
 drivers/net/ethernet/mscc/ocelot_net.c        |  21 +--
 drivers/net/ethernet/ti/cpsw_priv.c           |  12 +-
 drivers/net/ethernet/ti/netcp_ethss.c         |  26 +--
 drivers/net/macvlan.c                         |  14 +-
 drivers/net/phy/phy_device.c                  |  85 +++++++++
 include/linux/ethtool.h                       |   8 +
 include/linux/netdevice.h                     |  12 ++
 include/uapi/linux/ethtool_netlink.h          |  17 ++
 include/uapi/linux/net_tstamp.h               |   8 +
 net/8021q/vlan_dev.c                          |  15 +-
 net/core/dev.c                                |   2 +-
 net/core/dev_ioctl.c                          |  56 +++++-
 net/core/timestamping.c                       |   6 +
 net/ethtool/Makefile                          |   2 +-
 net/ethtool/common.c                          |  21 ++-
 net/ethtool/netlink.c                         |  30 ++++
 net/ethtool/netlink.h                         |   4 +
 net/ethtool/ts.c                              | 168 ++++++++++++++++++
 22 files changed, 506 insertions(+), 98 deletions(-)
 create mode 100644 net/ethtool/ts.c

-- 
2.25.1

