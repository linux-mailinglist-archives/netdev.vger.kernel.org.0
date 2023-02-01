Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D065868667D
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjBANPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBANPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:15:31 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDE7A6A6F;
        Wed,  1 Feb 2023 05:15:29 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,263,1669042800"; 
   d="scan'208";a="148127782"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 01 Feb 2023 22:15:28 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id CA2B64005B57;
        Wed,  1 Feb 2023 22:15:28 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v5 0/5] net: renesas: rswitch: Modify initialization for SERDES and PHY
Date:   Wed,  1 Feb 2023 22:14:49 +0900
Message-Id: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- My platform has the 88x2110.
- The MACTYPE setting of strap pin on the platform is SXGMII.
- However, we realized that the SoC cannot communicate the PHY with SXGMII
  because of mismatching hardware specification.
- We have a lot of boards which mismatch the MACTYPE setting.

So, I would like to change the MACTYPE as SGMII by software for the platform.

The patch [1/5] sets phydev->host_interfaces by phylink for Marvell PHY
driver (marvell10g) to initialize the MACTYPE.

- The patch [1/5] siplifies the rswitch driver.
- The patch [2/5] converts to phy_device from phylink.
- The patch [3/5] sets phydev->host_interfaces from this driver without
  any new functions of phylib.
- The patch [4/5] adds phy_power_on() calling to initialize the Ethernet
  SERDES PHY driver (r8a779f0-eth-serdes) for each channel.
- The patch [5/5] adds "max-speed" handling.

Changes from v4:
https://lore.kernel.org/all/20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com/
 - No modification of phylink API.
 - Convert to phylib instead of phylink.
 - Add "max-speed" handling.

Changes from v3:
https://lore.kernel.org/all/20230127014812.1656340-1-yoshihiro.shimoda.uh@renesas.com/
 - Keep a pointer of "port" and more simplify the code.

Yoshihiro Shimoda (5):
  net: renesas: rswitch: Simplify struct phy * handling
  net: renesas: rswitch: Convert to phy_device
  net: renesas: rswitch: Add host_interfaces setting
  net: renesas: rswitch: Add phy_power_{on,off}() calling
  net: renesas: rswitch: Add "max-speed" handling

 drivers/net/ethernet/renesas/rswitch.c | 231 ++++++++++++-------------
 drivers/net/ethernet/renesas/rswitch.h |   4 +-
 2 files changed, 111 insertions(+), 124 deletions(-)

-- 
2.25.1

