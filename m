Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C01594E8
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfF1H33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:29:29 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:48014 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726497AbfF1H3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:29:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0E586C0BE4;
        Fri, 28 Jun 2019 07:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561706965; bh=7yNErk/QAK9fVx9F8eSAPJT+QXddK5CDFk6Utr/RHeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=DVNGPXIkIVlmiO+qmofVSwwpvnmYFu3/GBr90LqknkXMxSDAZOBLD3LgtsfMH56hK
         K4uzkvSjaD0bnwTx9CFvNEKJ4C7qeYujVreh5NB92IJzyK01504XtvjHWrD1CmygJT
         UxV3SMDV8R1z/WJntEZniGrYgR3xtH6spptYnoa9lkRS//Bt1wgbWiCM/rjQb9ughj
         koVClv1v9epiuN+4AqrDDTCDMZVyGylfaujHmyE310py/vjqzyVNODKlg+Fx+phgaH
         WM1IasVSKqPBUw0bAO7vsLerKyuZg13Z/8hleXGm2dtG/vBj4C3s409psI+oZHKIOg
         yq8z97RGf52JQ==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 9F612A0237;
        Fri, 28 Jun 2019 07:29:23 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 893E83E952;
        Fri, 28 Jun 2019 09:29:23 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 04/10] net: stmmac: dwxgmac: Fix the undefined burst setting
Date:   Fri, 28 Jun 2019 09:29:15 +0200
Message-Id: <eeed2cbafacb09e0d3bbb74b6c9b799ff9c6e41c.1561706801.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
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
index 42448973c36e..b739673f8842 100644
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

