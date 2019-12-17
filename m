Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60A0122A7B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfLQLmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:42:53 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:48802 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbfLQLmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:42:53 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 860A842657;
        Tue, 17 Dec 2019 11:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576582973; bh=Q+mn6nGIE2m/MwzUx3zhn1TL+1xPevthZYqgen3IL6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=CPyPQiS7cNBDuHT0EPyG8Qnw8jPFHmY8oLgXRC3+o/XTrrZZpVeomapftaQ98C90+
         wdCsPOdwiIA4v7n8vdEyW6wNuEdbfENPOwvGdfM0g60+CHQVYeVd3I0L6mR9cnKh/l
         VPOjidREOLXL/nmu9B5Fi8SM/A+moR6pdUoFt+bBejwAL1l0IN7QYgQOvocG4X1J9g
         6xQeJ6CEQY6U0sFN26YW7ozGGvI18gjFI+Z2kWeuG8w6TkIA/x//PwY2DL2CGLgGPO
         sHCnL2/XMuGe+3nCbm1wTQLkiNLyMRlZUci6MLNHwxeBjx4AFW7vogcDefCuEFYicE
         ccBgaCba6QFxg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 16CA6A00AB;
        Tue, 17 Dec 2019 11:42:51 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 7/8] net: stmmac: 16KB buffer must be 16 byte aligned
Date:   Tue, 17 Dec 2019 12:42:37 +0100
Message-Id: <83241d7ac5df5c39711a666403ee36b68029a01a.1576581853.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576581853.git.Jose.Abreu@synopsys.com>
References: <cover.1576581853.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576581853.git.Jose.Abreu@synopsys.com>
References: <cover.1576581853.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 16KB RX Buffer must also be 16 byte aligned. Fix it.

Fixes: 7ac6653a085b ("stmmac: Move the STMicroelectronics driver")
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
 drivers/net/ethernet/stmicro/stmmac/common.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index b210e987a1db..94f94686cf7d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -365,9 +365,8 @@ struct dma_features {
 	unsigned int arpoffsel;
 };
 
-/* GMAC TX FIFO is 8K, Rx FIFO is 16K */
-#define BUF_SIZE_16KiB 16384
-/* RX Buffer size must be < 8191 and multiple of 4/8/16 bytes */
+/* RX Buffer size must be multiple of 4/8/16 bytes */
+#define BUF_SIZE_16KiB 16368
 #define BUF_SIZE_8KiB 8188
 #define BUF_SIZE_4KiB 4096
 #define BUF_SIZE_2KiB 2048
-- 
2.7.4

