Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF7D56B18
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfFZNsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:48:13 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:56922 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727884AbfFZNrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:47:55 -0400
Received: from mailhost.synopsys.com (unknown [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1BC51C0B30;
        Wed, 26 Jun 2019 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561556874; bh=m6cq/58qywc+Zi9zwQZw9m9QY1yf0HOycoMjeviOj14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=gbqYP5hk5j69vyylFhU0SKWEWbi/WRe81d6cUJv+MqvgRNOAZ2Z+0N+EqdWZ5SXw2
         /3s7+3L4Sgi8v9ZiETsWCGZRJpA5yit8YUY3S8E3NvIc8IrTTh8L1MttS++AkIDOD7
         8k+4IapmEX3r0rdNFVaIMGA4rwEjb/w+fSXb4gYZrwa66CYCS+SWX1w5fC7J7bYoXm
         MtfLF9V2HGz20KPaDO+TLbScYrsz37x6sPPoHTk3JFxbUXphpXlnAkRZiufryLCFjC
         vc605kkUwZzHFHAwR3gUgNtaL5lIbjbsnltzvT7ONjIz8G4DHxxd3swbpz4PHPqUao
         QsFkDZ39MnMvw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 35824A022E;
        Wed, 26 Jun 2019 13:47:51 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id DCB493B565;
        Wed, 26 Jun 2019 15:47:51 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 04/10] net: stmmac: dwxgmac: Fix the undefined burst setting
Date:   Wed, 26 Jun 2019 15:47:38 +0200
Message-Id: <8896ac1a2afdec01c5afcd20a3e01c691beff94f.1561556556.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Undefined burst shall only be set if pdata asks to.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index a1ad49680c07..3f84271da836 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -91,11 +91,11 @@ static void dwxgmac2_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 	value |= (axi->axi_rd_osr_lmt << XGMAC_RD_OSR_LMT_SHIFT) &
 		XGMAC_RD_OSR_LMT;
 
+	if (!axi->axi_fb)
+		value |= XGMAC_UNDEF;
+
 	value &= ~XGMAC_BLEN;
 	for (i = 0; i < AXI_BLEN; i++) {
-		if (axi->axi_blen[i])
-			value &= ~XGMAC_UNDEF;
-
 		switch (axi->axi_blen[i]) {
 		case 256:
 			value |= XGMAC_BLEN256;
-- 
2.7.4

