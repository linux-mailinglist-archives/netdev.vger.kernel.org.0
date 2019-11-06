Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782DEF197B
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732159AbfKFPEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:04:05 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43066 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731913AbfKFPDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:03:12 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EACE8C0F4B;
        Wed,  6 Nov 2019 15:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573052592; bh=lSRQ99cSkNF5cr5WxPR/Dx/0LMZ4CIS9zons/16DEj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Pw/P8DdssfrTW3yDFcoXSMSgTx5+bn4QCogK5YhSBJazfIS/dYqu7ydVb+0g+ar1V
         v4BP1bkXd0MeACdt8e6KRZt/VC4V/4lTeMiQSSsnmTRQnbZZR3g0TUXbXCeK8do3HC
         9Ksmsok+8xTucUCB7+90Ca3kxSbz1EN8yIOaalYQjuo3RaF2OBLm+U/8AeeTpz0A7O
         eIy7g6LP4QQqyIsW8A9s8sSORSQaTWlQeU4OaogImXfaxs4yGPV0Fc93a9w7P/hwnq
         1okPm/to7hcmIpbx7EwP06iLRhcBn8GdDydOfsUkuy8TiicOqH90vv72YT5jBiU2m3
         xJsyeyOpaBDdg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A2F9CA006C;
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
Subject: [PATCH net 04/11] net: stmmac: xgmac: Only get SPH header len if available
Date:   Wed,  6 Nov 2019 16:02:58 +0100
Message-Id: <58ba72cfcc373c2f98a6a89da3da12a4fc9f7b3b.1573052379.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split Header length is only available when L34T == 0. Fix this by
correctly checking if L34T is zero before trying to get Header length.

Fixes: 67afd6d1cfdf ("net: stmmac: Add Split Header support and enable it in XGMAC cores")
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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index ae48154f933c..bd5838ce1e8a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -288,7 +288,8 @@ static int dwxgmac2_get_rx_hash(struct dma_desc *p, u32 *hash,
 
 static int dwxgmac2_get_rx_header_len(struct dma_desc *p, unsigned int *len)
 {
-	*len = le32_to_cpu(p->des2) & XGMAC_RDES2_HL;
+	if (le32_to_cpu(p->des3) & XGMAC_RDES3_L34T)
+		*len = le32_to_cpu(p->des2) & XGMAC_RDES2_HL;
 	return 0;
 }
 
-- 
2.7.4

