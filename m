Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A53822E3
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbfHEQpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:45:30 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:39846 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727802AbfHEQp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 12:45:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9EE9BC01AA;
        Mon,  5 Aug 2019 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565023529; bh=aTDnCXcniV6uvBzYE58A0TIJ6PhSk7VA//+4NwG8t7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=VZ3nhSd25VX1ZTWVBt76NJf/dbL5rJJvKCDZbo84nMneh3Y9RKrJ+zMM7lIDRvE6M
         FfhcpHthvaLjryhS85Ub/Lz9W/GlSGepfwy6B+uod38DJHf5CGBhOjThsgDDh0Wc/X
         6HPL/vRUZZdxQ+EKv1hhPV90jlIFIrBI/rFQ57OEywiS5N/wcpcZr97afr7DLlacII
         tRoxEieG8rgWO88xGLGc7jLTxOQhKPFOz9HrVE+8H6wer9BZtLuggIkD48A9BpHb0k
         wiepy3aucbK6a0ClVrgwRtqkOyQpp/8F7YJ1fFaTNApGHEC5aYwJ946em5XbseFddC
         TKdw2mByKGdzg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 64B02A0074;
        Mon,  5 Aug 2019 16:45:27 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/26] net: stmmac: selftests: Add RSS test
Date:   Mon,  5 Aug 2019 18:44:34 +0200
Message-Id: <060d0e29c13f75123d8dfa17de5fcbb679048fc7.1565022597.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test for RSS in the stmmac selftests.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index a97b1ea76438..83b775a8cedc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -700,6 +700,21 @@ static int stmmac_test_flowctrl(struct stmmac_priv *priv)
 	return ret;
 }
 
+static int stmmac_test_rss(struct stmmac_priv *priv)
+{
+	struct stmmac_packet_attrs attr = { };
+
+	if (!priv->dma_cap.rssen || !priv->rss.enable)
+		return -EOPNOTSUPP;
+
+	attr.dst = priv->dev->dev_addr;
+	attr.exp_hash = true;
+	attr.sport = 0x321;
+	attr.dport = 0x123;
+
+	return __stmmac_test_loopback(priv, &attr);
+}
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -745,6 +760,10 @@ static const struct stmmac_test {
 		.name = "Flow Control         ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_flowctrl,
+	}, {
+		.name = "RSS                  ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_rss,
 	},
 };
 
-- 
2.7.4

