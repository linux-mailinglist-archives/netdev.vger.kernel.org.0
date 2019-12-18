Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03D1124427
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLRKRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:17:55 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:36984 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726834AbfLRKRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:17:54 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1EFF9C0D6B;
        Wed, 18 Dec 2019 10:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576664273; bh=JURRi4bow/vA5Lu92PxXoSZSHyE6epfPI/NBEYqUmf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Y1/Yhc26V5ety9l/L7fk4vTbZiKONrwsVuCLKT2sOCZchVu/YkPyXEWdRz9zrAfDa
         7uEo6eyPyt/4663gK2R7yzZktdyAFHvttita8E8tpfnZjdVVT3ylYTpDB/BF02L+uF
         U8viQ7w5UmeCaAdtpQXQ+OKUasHqgtWUKmpEA0q5sf5hTaETMPW6d+odHqvZ1EogXo
         NmP+9fg1GFBxRUeoydxla6NMI+RjsY50fJUFbzxeHyomiCXEefa6yqHDuvWM1EXRMD
         G/LXQ+FvomF+JhRZzQn27zP4kHDzcDnOyJfiYZM0vHPZ3JTSei11CJzDYPKO3DTMcZ
         okNMmrWUMlVMA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A35CBA008C;
        Wed, 18 Dec 2019 10:17:51 +0000 (UTC)
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
Subject: [PATCH net v3 4/9] net: stmmac: Only the last buffer has the FCS field
Date:   Wed, 18 Dec 2019 11:17:38 +0100
Message-Id: <b66ef8250e38fd9d958ca566ae310e3e854a800a.1576664155.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576664155.git.Jose.Abreu@synopsys.com>
References: <cover.1576664155.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576664155.git.Jose.Abreu@synopsys.com>
References: <cover.1576664155.git.Jose.Abreu@synopsys.com>
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
index 8b7861909ef9..acb14a96243e 100644
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

