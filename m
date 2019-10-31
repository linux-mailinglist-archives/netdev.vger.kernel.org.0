Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED087EAE15
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfJaLBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:01:03 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:59358 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727277AbfJaLBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:01:03 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 88CCFC08B0;
        Thu, 31 Oct 2019 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572519662; bh=DPNAHIwdStIvNykZvPNI9Q22maKuz31rS0G+68nojiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ZTj/R19eSI2iloeTgQl4aJ1mHlGqvKW3H0tLYv9z/VN8ooDloOlTK2MCzI79lnjhC
         Unqq8WMfO0mwk1rAoGLbGd+4BIit+foUoT5j3ZcOp1+aA2MRBcaBubUa8W/0l8tmlD
         oCxnDhEAg4x2ernhMVCwzlpOdVKDUUmeL0hUR4C36jF5N3F4QugdtgMOGGxGrTMqPF
         YD8wuQQk1d1NiQymWOXUux7Bhy0Madz99s7dmXzwyVROug3lAj/Z1WcOtHY8GbeImf
         nPwXiXfoT9Jx5YHWUofMzt9NMeVzDMCt2wtCs9zpMhxaSE5jA0sI+PATcCMa3KSJE2
         PCrSiSRbOC3bQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 441D3A0077;
        Thu, 31 Oct 2019 11:01:00 +0000 (UTC)
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
Subject: [PATCH net v2 06/10] net: stmmac: xgmac: Fix TSA selection
Date:   Thu, 31 Oct 2019 12:00:44 +0100
Message-Id: <538f8fa299d6527d6ab108c441d37f511297cce9.1572519070.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
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
index b58522b8f782..082f5ee9e525 100644
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

