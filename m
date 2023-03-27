Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133096CA77D
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjC0OYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbjC0OXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:23:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5C58A5C
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:22:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnja-0008Hn-Kr; Mon, 27 Mar 2023 16:22:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjY-0076IW-Q5; Mon, 27 Mar 2023 16:22:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjW-00Fkib-OJ; Mon, 27 Mar 2023 16:22:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 0/8] Make SmartEEE support controllable 
Date:   Mon, 27 Mar 2023 16:21:54 +0200
Message-Id: <20230327142202.3754446-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v2:
- handle lack of eee_get/set directly by the ethtool framework. This
  will avoid the need to patch all ethernet controller drivers.
- add mac_supports_eee and is_smart_eee_phy flags to indicate support
  of different levels.
- reword commit logs.
- add FEC patch to indicated EEE support for some SoCs

Some PHYs, such as the AR8035, provide so-called SmartEEE support, which
enables the use of EEE with MACs that lack native EEE capabilities,
particularly the LPI support. Since this functionality is usually
enabled by default, it may have a negative impact on certain use cases
(e.g., PTP) or even prevent the use of all link modes without PHY driver
assistance (e.g., a full range of half-duplex modes).

To address at least some of these issues, this patch series aims to pass
EEE ethtool access to PHY drivers, enabling them to control SmartEEE
support more effectively. The series consists of several patches that
improve EEE handling for specific PHYs and MACs, making it possible to
enable or disable SmartEEE functionality as needed, depending on the
specific use case and requirements. As a result, users will gain more
control and flexibility over energy-saving features and compatibility in
their networking setups.

Oleksij Rempel (8):
  net: phy: Add driver-specific get/set_eee support for non-standard
    PHYs
  net: phy: add is_smart_eee_phy variable for SmartEEE support
  net: phy: Add mac_supports_eee variable for EEE support and LPI
    handling
  ethtool: eee: Rework get/set handler for SmartEEE-capable PHYs with
    non-EEE MACs
  net: phy: at803x: Indicate SmartEEE support for AR8035 and AR8031 PHYs
  net: phy: at803x: Make SmartEEE support optional and configurable via
    ethtool
  net: phy: at803x: Fix SmartEEE support for some link configurations
  net: fec: Indicate EEE (LPI) support for some FEC Ethernet controllers

 drivers/net/ethernet/freescale/fec_main.c |   2 +
 drivers/net/phy/at803x.c                  | 158 +++++++++++++++++++++-
 drivers/net/phy/phy.c                     |  10 +-
 include/linux/phy.h                       |   9 ++
 net/ethtool/common.c                      |  38 ++++++
 net/ethtool/common.h                      |   2 +
 net/ethtool/eee.c                         |  17 ++-
 7 files changed, 221 insertions(+), 15 deletions(-)

-- 
2.30.2

