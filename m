Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA6243F449
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 03:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhJ2BOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 21:14:12 -0400
Received: from smtp100.iad3a.emailsrvr.com ([173.203.187.100]:59413 "EHLO
        smtp100.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231490AbhJ2BOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 21:14:12 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Oct 2021 21:14:12 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lynx.com;
        s=20200402-brzttuan; t=1635469365;
        bh=jMM+C2LT4KU86ldYN4hpLRQjbvr7iv6JRSnCpYFXPiA=;
        h=From:Subject:To:Date:From;
        b=RvZtQBCul4PKfrn4LzVsVM9XpJBJoC36y+V4PBnd4glqO2L2P9tJcC/92cvcNT+Iv
         TB+VAx0APRg22nVESvYCI+Zxsxai+JH4q6hanxvPKpre2JeHp58WsWKR6VU0eq3YrI
         6M/RQW/uk34jloyvp87ZQEN3hq7aySxw/is5vP/A=
X-Auth-ID: cnovikov@lynx.com
Received: by smtp37.relay.iad3a.emailsrvr.com (Authenticated sender: cnovikov-AT-lynx.com) with ESMTPSA id AC0885A2E;
        Thu, 28 Oct 2021 21:02:44 -0400 (EDT)
From:   Cyril Novikov <cnovikov@lynx.com>
Subject: [PATCH net] ixgbe: set X550 MDIO speed before talking to PHY
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Message-ID: <81be24c4-a7e4-0761-abf4-204f4849b6eb@lynx.com>
Date:   Thu, 28 Oct 2021 18:03:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Classification-ID: df0f361c-6133-4f2f-845e-777970af93a5-1-1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO bus speed must be initialized before talking to the PHY the first
time in order to avoid talking to it using a speed that the PHY doesn't
support.

This fixes HW initialization error -17 (IXGBE_ERR_PHY_ADDR_INVALID) on
Denverton CPUs (a.k.a. the Atom C3000 family) on ports with a 10Gb network
plugged in. On those devices, HLREG0[MDCSPD] resets to 1, which combined
with the 10Gb network results in a 24MHz MDIO speed, which is apparently
too fast for the connected PHY. PHY register reads over MDIO bus return
garbage, leading to initialization failure.

Signed-off-by: Cyril Novikov <cnovikov@lynx.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 3 +++
 1 file changed, 3 insertions(+)

Reproduced with Linux kernel 4.19 and 5.15-rc7. Can be reproduced using
the following setup:

* Use an Atom C3000 family system with at least one X550 LAN on the SoC
* Disable PXE or other BIOS network initialization if possible
  (the interface must not be initialized before Linux boots)
* Connect a live 10Gb Ethernet cable to an X550 port
* Power cycle (not reset, doesn't always work) the system and boot Linux
* Observe: ixgbe interfaces w/ 10GbE cables plugged in fail with error -17

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index 9724ffb16518..e4b50c7781ff 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -3405,6 +3405,9 @@ static s32 ixgbe_reset_hw_X550em(struct ixgbe_hw *hw)
 	/* flush pending Tx transactions */
 	ixgbe_clear_tx_pending(hw);
 
+	/* set MDIO speed before talking to the PHY in case it's the 1st time */
+	ixgbe_set_mdio_speed(hw);
+
 	/* PHY ops must be identified and initialized prior to reset */
 	status = hw->phy.ops.init(hw);
 	if (status == IXGBE_ERR_SFP_NOT_SUPPORTED ||
-- 
2.19.1-412.replication
