Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B516CD18E
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 13:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfJFLJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 07:09:09 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:46806 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726261AbfJFLJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 07:09:08 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 00C65C04C3;
        Sun,  6 Oct 2019 11:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1570360147; bh=kfGEEkk2OCVMoCzX6mcsv6RlPMI0cS4QjjbKAyWAMp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=BRC5UUjXxRIUwGZLhsCCeX9Ohbm00V6xEF5gOSXSUQUz8lXS4AjTQAmApPN3sN4rB
         c5YiAUNX2ZAbjbT3L5MH+F+1iKxx25cW6PC3qwk3aZjLSnq0tdd8r3nwzs+MdeJeC4
         gXbYTpyp/aY/q0FtCrO+VhRdDL0BZEseFF2157elRKoZEIah+/exgtSOuax0pmgQiV
         iGcggrthRoxD7LaA/ytmL2UohnqT7uXZKa61u2T5T5OHF8uig3Xh3NTQRih3ycbmze
         8EGGAIEr8/icGEDzYtmN44JzrIls8VuJLuMGWYVdQVRjV5L+vGLJA+Os+s9e2rLhcj
         S+S7z5TMF7dyw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 95DCCA0065;
        Sun,  6 Oct 2019 11:09:04 +0000 (UTC)
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
Subject: [PATCH net 2/3] net: stmmac: gmac4+: Not all Unicast addresses may be available
Date:   Sun,  6 Oct 2019 13:08:56 +0200
Message-Id: <33ca4465dd54692013bf9b2da99c4ff751874fa4.1570359800.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1570359800.git.Jose.Abreu@synopsys.com>
References: <cover.1570359800.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1570359800.git.Jose.Abreu@synopsys.com>
References: <cover.1570359800.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some setups may not have all Unicast addresses filters available. Check
the number of available filters before trying to setup it.

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
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
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 2cb9c53f93b8..5a7b0aca1d31 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -448,7 +448,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	value |= GMAC_PACKET_FILTER_HPF;
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > GMAC_MAX_PERFECT_ADDRESSES) {
+	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
 		/* Switch to promiscuous mode if more than 128 addrs
 		 * are required
 		 */
-- 
2.7.4

