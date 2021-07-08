Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBC73BF7C8
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 11:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhGHJv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 05:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhGHJv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 05:51:57 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B23C061574;
        Thu,  8 Jul 2021 02:49:15 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1m1Qea-0000RX-Dl; Thu, 08 Jul 2021 12:49:08 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net] atl1c: fix Mikrotik 10/25G NIC detection
Date:   Thu,  8 Jul 2021 12:49:04 +0300
Message-Id: <20210708094904.3613365-1-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since Mikrotik 10/25G NIC MDIO op emulation is not 100% reliable,
on rare occasions it can happen that some physical functions of
the NIC do not get initialized due to timeouted early MDIO op.

This changes the atl1c probe on Mikrotik 10/25G NIC not to
depend on MDIO op emulation.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
index 7dff20350865..f19370c33444 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
@@ -594,6 +594,11 @@ int atl1c_phy_init(struct atl1c_hw *hw)
 	int ret_val;
 	u16 mii_bmcr_data = BMCR_RESET;
 
+	if (hw->nic_type == athr_mt) {
+		hw->phy_configured = true;
+		return 0;
+	}
+
 	if ((atl1c_read_phy_reg(hw, MII_PHYSID1, &hw->phy_id1) != 0) ||
 		(atl1c_read_phy_reg(hw, MII_PHYSID2, &hw->phy_id2) != 0)) {
 		dev_err(&pdev->dev, "Error get phy ID\n");
-- 
2.31.1

