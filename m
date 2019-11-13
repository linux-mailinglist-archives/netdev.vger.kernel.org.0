Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B3AFB34F
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfKMPMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:12:22 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:51236 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727112AbfKMPMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:12:21 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 35925C0E96;
        Wed, 13 Nov 2019 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573657941; bh=Ip3ZDkHX7NjVjcJ1Wnwx1pavIU7mIEYu8qbPr6qGCVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=RKjwJjIbQR+b7Qw8AJQTa1EuVAYkdBYBwdUPUj3HKxK5nhKYKRWpDhx4POpCBI6iX
         sVkFCKeRJssVtG6zlC3NP2ZtrCHf74fupWBYwmK6Cl4m4nS/BYkb0SpRvXvPVJsXSw
         utshHfdZHSs+9K5iyd8GS63XWDYic+ccPqomEDcUHGXJA1Z9zaoY/kX8YB8XBRzFU/
         PxewJ9qPxkGL2xWv51Nm/89hQFqUpw5gvXggVdVfaet7xu0OWOjJq/uHdIk+QTvCUC
         W+6fZLi9+pecHIpgLmfZq4i27xMVKWE2Ety9HT/8Ru/WDY4df82Ap8VvaJdFegOaQM
         OM4kvyazqqGzg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id B5DBDA008F;
        Wed, 13 Nov 2019 15:12:19 +0000 (UTC)
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
Subject: [PATCH net-next 5/7] net: stmmac: xgmac: Remove uneeded computation for RFA/RFD
Date:   Wed, 13 Nov 2019 16:12:06 +0100
Message-Id: <6c27de99de61a9dfa65ba163b5d870cac9f6a249.1573657592.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573657592.git.Jose.Abreu@synopsys.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573657592.git.Jose.Abreu@synopsys.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFA and RFD should not be dependent on FIFO size. In fact, the more FIFO
space we have, the later we can activate Flow Control. Let's use
hard-coded values for RFA and RFD for all FIFO sizes with the exception
of 4k, which is a special case.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index f148cb2061d8..22a7f0cc1b90 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -183,19 +183,9 @@ static void dwxgmac2_dma_rx_mode(void __iomem *ioaddr, int mode,
 			rfa = 0x01; /* Full-1.5K */
 			break;
 
-		case 8192:
-			rfd = 0x06; /* Full-4K */
-			rfa = 0x0a; /* Full-6K */
-			break;
-
-		case 16384:
-			rfd = 0x06; /* Full-4K */
-			rfa = 0x12; /* Full-10K */
-			break;
-
 		default:
-			rfd = 0x06; /* Full-4K */
-			rfa = 0x1e; /* Full-16K */
+			rfd = 0x07; /* Full-4.5K */
+			rfa = 0x04; /* Full-3K */
 			break;
 		}
 
-- 
2.7.4

