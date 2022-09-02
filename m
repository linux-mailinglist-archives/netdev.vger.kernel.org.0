Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90245AB67B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbiIBQ1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 12:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235994AbiIBQ1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 12:27:09 -0400
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr [80.12.242.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3176AC9938
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 09:27:07 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id U9VRobqH1kifIU9VSoXLOn; Fri, 02 Sep 2022 18:27:03 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 02 Sep 2022 18:27:03 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3] stmmac: intel: Simplify intel_eth_pci_remove()
Date:   Fri,  2 Sep 2022 18:26:56 +0200
Message-Id: <35ab3ac5b67716acb3f7073229b02a38fce71fb7.1662135995.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no point to call pcim_iounmap_regions() in the remove function,
this frees a managed resource that would be release by the framework
anyway.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
Change in v3:
  * (no code change)
  * what was patch 1/2 in the serie has been applied
  * synch with net-next

Change in v2:
  * (no code change)
  * Remove the text added below the --- in v1 (see link below if
    needed)
  * Add Reviewed-by:
  https://lore.kernel.org/all/2aeb1a03d07c686efd8b3e6fc8ff2d45cd7da1e8.1660659689.git.christophe.jaillet@wanadoo.fr/

v1:
  https://lore.kernel.org/all/9f82d58aa4a6c34ec3c734399a4792d3aa23297f.1659204745.git.christophe.jaillet@wanadoo.fr/
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 7d3c7ca7caf4..0a2afc1a3124 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1135,8 +1135,6 @@ static void intel_eth_pci_remove(struct pci_dev *pdev)
 
 	clk_disable_unprepare(priv->plat->stmmac_clk);
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
-
-	pcim_iounmap_regions(pdev, BIT(0));
 }
 
 static int __maybe_unused intel_eth_pci_suspend(struct device *dev)
-- 
2.34.1

