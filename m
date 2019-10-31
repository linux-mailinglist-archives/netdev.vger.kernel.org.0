Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A261AEAE2B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfJaLBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:01:07 -0400
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:59436 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727348AbfJaLBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:01:03 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7ADC1C08AF;
        Thu, 31 Oct 2019 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572519662; bh=WOrHnH2Cw3T6U8+gS8Ru/YnMbaTqsbVhoS8x//3uSik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=JasDuHEj5pNvCLT7DTbMtslrySsnWajObl0IO41Afnp2rMgs+oUQyaTwwsyYSbBUA
         9Vv6MET2sj9KRxtYHiKomn8goinSwGSoNTKphJQFQw+RD677vTj1x6Sb4IqpXcoQiO
         gYnk2rlpGE1tWfyOqqvv+rFitdSjCdrbs3b+pobv+GKdGGqqCV6FkcR1QEfcMvgks0
         fgJ5cZx+hwSbzW9Sbjd8/gLOE+ZuVjqR/GqSUINK8ihs0AnbD2gnPShGoOfuwhmY4Y
         EM40obcCRZ+KJ5+WMophT1zsLjTAlC851qjFp8IsbNpZxPmz8DTlVRo9fbdsnGhul9
         VAgG52/blLdgQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 21584A0073;
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
Subject: [PATCH net v2 05/10] net: stmmac: xgmac: Only get SPH header len if available
Date:   Thu, 31 Oct 2019 12:00:43 +0100
Message-Id: <f9d2377bce79f8ab4dae272aa5856452600acfba.1572519070.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1572519070.git.Jose.Abreu@synopsys.com>
References: <cover.1572519070.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split Header length is only available when L34T != 0. Fix this by
correctly checking if L34T is not zero before trying to get Header length.

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

