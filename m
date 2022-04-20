Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DBB508C06
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 17:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354744AbiDTP0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 11:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351566AbiDTP0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 11:26:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8411545784;
        Wed, 20 Apr 2022 08:23:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0221A618EF;
        Wed, 20 Apr 2022 15:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CDAC385A1;
        Wed, 20 Apr 2022 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650468231;
        bh=fGoYvTCERq6W+4c1n/bIy8S4IsI8Y/53T0F5nkCUz/0=;
        h=From:To:Cc:Subject:Date:From;
        b=d02SIrWFUjLs3gpjnr72vQQbxEbBHNSx47OM8gzk3Lxb7GxwD6I74Lp8hIZTrTurf
         AMFRqY2MoGSlpV2SjW6kvPhCVBjdNHBU93OS5t4/Kv+XPEUmqMsO5n1uCUb+dxs2JU
         dZnLSny1UXKCC9VGiBTxEcHnKX+rpq7vnhZqClheAFR/MKpeN9+5zCv1EhtxWUm/1w
         +65vfutAqtgOvnDQ2USvBliFIQXRrJeA0sNcCgV9reOAj0aDjcOvQa9YHn4t06OT58
         kNZEdjQeUastUozhr3jmHJOyNQf2z8YjKRZ/YUXhlHDDCeabCXOwJaolHM/8hWrNij
         jdKp23lyik0ew==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     davem@davemloft.net
Cc:     dinguyen@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-stable <stable@vger.kernel.org>
Subject: [PATCH] net: ethernet: stmmac: fix write to sgmii_adapter_base
Date:   Wed, 20 Apr 2022 10:23:45 -0500
Message-Id: <20220420152345.27415-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I made a mistake with the commit a6aaa0032424 ("net: ethernet: stmmac:
fix altr_tse_pcs function when using a fixed-link"). I should have
tested against both scenario of having a SGMII interface and one
without.

Without the SGMII PCS TSE adpater, the sgmii_adapter_base address is
NULL, thus a write to this address will fail.

Fixes: a6aaa0032424 ("net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index ac9e6c7a33b5..6b447d8f0bd8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -65,8 +65,9 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 	struct phy_device *phy_dev = ndev->phydev;
 	u32 val;
 
-	writew(SGMII_ADAPTER_DISABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	if (sgmii_adapter_base)
+		writew(SGMII_ADAPTER_DISABLE,
+		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 
 	if (splitter_base) {
 		val = readl(splitter_base + EMAC_SPLITTER_CTRL_REG);
@@ -88,10 +89,11 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 		writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
 	}
 
-	writew(SGMII_ADAPTER_ENABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-	if (phy_dev)
+	if (phy_dev && sgmii_adapter_base) {
+		writew(SGMII_ADAPTER_ENABLE,
+		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 		tse_pcs_fix_mac_speed(&dwmac->pcs, phy_dev, speed);
+	}
 }
 
 static int socfpga_dwmac_parse_data(struct socfpga_dwmac *dwmac, struct device *dev)
-- 
2.25.1

