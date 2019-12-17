Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D6A122A78
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfLQLn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:43:27 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:36534 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727216AbfLQLmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:42:54 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3B7D0C00AE;
        Tue, 17 Dec 2019 11:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576582973; bh=4JXJjVE53ev4CfJxLlgwEg4UYykJKXcBztnhJOlrhd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=XSN08CLAx/e8IwL0UGtZXT6EP42WewjKso9AIB/RVn6GD5J2EVHtPfizHOqlu4Aft
         5eqSdhtSytTv/LSydejeKa/9F70NZzB2E7obdowhLyCFE9hMsooor4XO0mH++AV13L
         SXNd7ASjMJ+oMhQ4aSkbmDhQqEwDogntMbt77vdDjHSalyENM51EJtFjNVGnIULOjX
         EOWdfNfxrAoGUjwTeC/WC0+S992Qkf7r5OG2Aj+/xomg8YgAw5oBYySBEL5IJispv3
         90s8f+BCCMSpsBclZ8M16Oudl3vpHRLhFKwFF1+wZ4XS03gX/rSspPjqoYtKvEnUfG
         vcEUr0OLLLRVw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id E4488A0095;
        Tue, 17 Dec 2019 11:42:50 +0000 (UTC)
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
Subject: [PATCH net v2 4/8] net: stmmac: Only the last buffer has the FCS field
Date:   Tue, 17 Dec 2019 12:42:34 +0100
Message-Id: <b8e23536316451076155f4de5cc25516ab679e2e.1576581853.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576581853.git.Jose.Abreu@synopsys.com>
References: <cover.1576581853.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576581853.git.Jose.Abreu@synopsys.com>
References: <cover.1576581853.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only the last received buffer contains the FCS field. Check for end of
packet before trying to strip the FCS field.

Fixes: 88ebe2cf7f3f ("net: stmmac: Rework stmmac_rx()")
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2ebac89049ed..8c191e4d35d0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3644,8 +3644,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		 * feature is always disabled and packets need to be
 		 * stripped manually.
 		 */
-		if (unlikely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
-		    unlikely(status != llc_snap)) {
+		if (likely(!(status & rx_not_ls)) &&
+		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
+		     unlikely(status != llc_snap))) {
 			if (buf2_len)
 				buf2_len -= ETH_FCS_LEN;
 			else
-- 
2.7.4

