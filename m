Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84ED8695DE8
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjBNJDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjBNJDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:03:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5242131
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:03:30 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pRrDa-0004UC-JO; Tue, 14 Feb 2023 10:03:18 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pRrDY-004qDf-As; Tue, 14 Feb 2023 10:03:17 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pRrDX-008V5V-Ex; Tue, 14 Feb 2023 10:03:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH net-next v1 0/7] make SmartEEE support controllable 
Date:   Tue, 14 Feb 2023 10:03:07 +0100
Message-Id: <20230214090314.2026067-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs (for example AR8035) provide so called SmartEEE support. Which
allows to use EEE with MACs withotu EEE ability.

Since this functionality is usually enabled by default, it may have
negative impact in some use cases (for example PTP). Or even preventing use of
all link modes without PHY driver assistance (for example full range of
half-duplex modes).

To address at leas some of this issues we need to pass EEE ethtool access to
PHY drivers. Which is done in this patch set.

Oleksij Rempel (7):
  net: phy: add driver specific get/set_eee support
  net: phy: at803x: implement ethtool access to SmartEEE functionality
  net: phy: at803x: ar8035: fix EEE support for half duplex links
  net: phy: add PHY specifica flag to signal SmartEEE support
  net: phy: at803x: add PHY_SMART_EEE flag to AR8035
  net: phy: add phy_has_smarteee() helper
  net: fec: add support for PHYs with SmartEEE support

 drivers/net/ethernet/freescale/fec_main.c |  22 +++-
 drivers/net/phy/at803x.c                  | 142 +++++++++++++++++++++-
 drivers/net/phy/phy.c                     |   6 +
 include/linux/phy.h                       |  15 +++
 4 files changed, 175 insertions(+), 10 deletions(-)

-- 
2.30.2

