Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95230585B9F
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 20:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiG3S12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 14:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiG3S11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 14:27:27 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 30 Jul 2022 11:27:25 PDT
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEF1F15A3A
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 11:27:25 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id Hr41oSyrhBDYDHr41oo8rt; Sat, 30 Jul 2022 20:19:53 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 30 Jul 2022 20:19:53 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     andriy.shevchenko@linux.intel.com, vee.khee.wong@intel.com,
        weifeng.voon@intel.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] stmmac: intel: Add a missing clk_disable_unprepare() call in intel_eth_pci_remove()
Date:   Sat, 30 Jul 2022 20:19:47 +0200
Message-Id: <b5b44a0c025d0fdddd9b9d23153261363089a06a.1659204745.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove
paths") removed this clk_disable_unprepare()

This was partly revert by commit ac322f86b56c ("net: stmmac: Fix clock
handling on remove path") which removed this clk_disable_unprepare()
because:
"
   While unloading the dwmac-intel driver, clk_disable_unprepare() is
   being called twice in stmmac_dvr_remove() and
   intel_eth_pci_remove(). This causes kernel panic on the second call.
"

However later on, commit 5ec55823438e8 ("net: stmmac: add clocks management
for gmac driver") has updated stmmac_dvr_remove() which do not call
clk_disable_unprepare() anymore.

So this call should now be called from intel_eth_pci_remove().

Fixes: 5ec55823438e8 ("net: stmmac: add clocks management for gmac driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
/!\     This patch is HIGHLY speculative.     /!\

The corresponding clk_disable_unprepare() is still called within the pm
related stmmac_bus_clks_config() function.

However, with my limited understanding of the pm API, I think it that the
patch is valid.
(in other word, does the pm_runtime_put() and/or pm_runtime_disable()
and/or stmmac_dvr_remove() can end up calling .runtime_suspend())

So please review with care, as I'm not able to test the change by myself.


If I'm wrong, maybe a comment explaining why it is safe to have this
call in the error handling path of the probe and not in the remove function
would avoid erroneous patches generated from static code analyzer to be
sent.
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 52f9ed8db9c9..9f38642f86ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1134,6 +1134,7 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
+	clk_disable_unprepare(plat->stmmac_clk);
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	pcim_iounmap_regions(pdev, BIT(0));
-- 
2.34.1

