Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195CCC1CF8
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbfI3IUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:20:11 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:46062 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730018AbfI3IT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:19:27 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 030FEC0378;
        Mon, 30 Sep 2019 08:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569831566; bh=F4S+1xHJRXUdoEUQwWWHucAMwa7NK06xIl14jQE+6AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=fjXstvOU18eShkFdAOSybuVAihkK3XUtr6CMjZxY0AadH2cr3dyrFadMOvcZit/hT
         dnmaEvcUtDwDZgGsgKnlwq7KJVsH9eSJhfus4MmHgk/4R6Jzmi8Pyh8B0Xjc6wThs2
         mHIphP0adsJoV9EV/lk+g/sPEtPfu4mIUilyueAPCtMXZzRr3OCLc17F864OXZl289
         NQrSb9QGGSAjEQSF79zzADmo1bysj43/hqGKRyJ+7cc7QcHEbPKtv4ETKh+DtDottn
         NwsiFRzg6URlBz/uIf+7XgrtQ7n6mMq1hJGwah/8blTMfvzxjuHd6Tsk6FaRqXQtS7
         IMYzZYbgOCZdw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4BDA6A005D;
        Mon, 30 Sep 2019 08:19:23 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 1/9] net: stmmac: xgmac: Not all Unicast addresses may be available
Date:   Mon, 30 Sep 2019 10:19:05 +0200
Message-Id: <8db4940cc20518eb9e2dffa1277f600365a01404.1569831229.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some setups may not have all Unicast addresses filters available. Let's
check this before trying to setup filters.

Fixes: 0efedbf11f07 ("net: stmmac: xgmac: Fix XGMAC selftests")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 2b277b2c586b..6d8ac2ef4fc2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -472,7 +472,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 	dwxgmac2_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > XGMAC_ADDR_MAX) {
+	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
 		value |= XGMAC_FILTER_PR;
 	} else {
 		struct netdev_hw_addr *ha;
-- 
2.7.4

