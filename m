Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3A0F1964
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731999AbfKFPDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:03:14 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43082 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731943AbfKFPDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:03:12 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0BD37C0F4C;
        Wed,  6 Nov 2019 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573052592; bh=/tE+oQIQA2jqvpF/cTAJUXNupu7zNSj0ZPechBJ4a80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Hr+1PAtLSqexo2ssdltOXhZE5pwsCZsv1gLLmikMcjaUFfrwvjBoqAqfkSIroAHUF
         xIikutERC8i4ysVxt+mIRlnLLuz83SmeCfcN35VhFwAFVq3Bgix8kVIn7NxpUS8RT6
         Ykv1c7I0nVu6MovpI61/gVf/taiCl59Xoh0OdAlkxWeLHAt9Sv34GewsTxKyVRallf
         PaMtpQD7OUwHWMR9FxbwAthr4vdwJ0zhl8c5mS/QATBSove2gtDNzxz1eCF1+vx928
         pDZ3I1k81Nub6GHpC66bu5Y6LDjAR78If5+YFfcUTRxmQo8dmMJ85uUSJKh7YlnkAt
         URW+fg++oGOFg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id B6D3FA0070;
        Wed,  6 Nov 2019 15:03:10 +0000 (UTC)
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
Subject: [PATCH net 05/11] net: stmmac: xgmac: Fix TSA selection
Date:   Wed,  6 Nov 2019 16:02:59 +0100
Message-Id: <c1342c865938cc087d5c9400bbe11b71cd6c0062.1573052379.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we change between Transmission Scheduling Algorithms, we need to
clear previous values so that the new chosen algorithm is correctly
selected.

Fixes: ec6ea8e3eee9 ("net: stmmac: Add CBS support in XGMAC2")
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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 01075a955c66..070bd7d1ae4c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -224,6 +224,7 @@ static void dwxgmac2_config_cbs(struct mac_device_info *hw,
 	writel(low_credit, ioaddr + XGMAC_MTL_TCx_LOCREDIT(queue));
 
 	value = readl(ioaddr + XGMAC_MTL_TCx_ETS_CONTROL(queue));
+	value &= ~XGMAC_TSA;
 	value |= XGMAC_CC | XGMAC_CBS;
 	writel(value, ioaddr + XGMAC_MTL_TCx_ETS_CONTROL(queue));
 }
-- 
2.7.4

