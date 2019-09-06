Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F1AAB35A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404570AbfIFHlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:41:31 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:33330 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390377AbfIFHl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:41:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 47E3DC0E3D;
        Fri,  6 Sep 2019 07:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567755688; bh=EBL9Jc4mlbrbWU2YRFXqsB+Tqzg4pzZ34sKsco1vIEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=awJF23K6k9+arQCYwI+jPTTiKkv2d8nThws2/sPR3Y/nm3WjIajWFCJz8xuvb/RJX
         3n1UMBse2Vhho1bpGAOIM7zGorF/99uTp6EthLOY467PhoG8P0e+di9VlUhIku4geT
         pVxdTCSLjViSXlutMbpsW4NAiw02XMUEf4vpNGpO39Y4uosXn2YdOYMppVO7UGF9zQ
         JiJ8pjgF4EBP0wp7FqhkJjRmF68lZZXr9c2+pqUNmW6Q9eAp17oRWDTrTdeoxaZ/oT
         M7beHJfcBibNCxiRlmeRblQJkAPPZuh4gDsUU+Brl8cVF3wHVzVxAL6pmRYOlh/mY5
         3nbE+sr8nU3rQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id E359EA0069;
        Fri,  6 Sep 2019 07:41:26 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: stmmac: selftests: Add Split Header test
Date:   Fri,  6 Sep 2019 09:41:16 +0200
Message-Id: <b789f9f19115714646565c821e10f1a1e76a55c5.1567755423.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567755423.git.joabreu@synopsys.com>
References: <cover.1567755423.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567755423.git.joabreu@synopsys.com>
References: <cover.1567755423.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test to validate that Split Header feature is working correctly.
It works by using the rececently introduced counter that increments each
time a packet with split header is received.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 42 ++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 2943943bec43..c56e89e1ae56 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1603,6 +1603,44 @@ static int stmmac_test_mjumbo(struct stmmac_priv *priv)
 	return 0;
 }
 
+static int stmmac_test_sph(struct stmmac_priv *priv)
+{
+	unsigned long cnt_end, cnt_start = priv->xstats.rx_split_hdr_pkt_n;
+	struct stmmac_packet_attrs attr = { };
+	int ret;
+
+	if (!priv->sph)
+		return -EOPNOTSUPP;
+
+	/* Check for UDP first */
+	attr.dst = priv->dev->dev_addr;
+	attr.tcp = false;
+
+	ret = __stmmac_test_loopback(priv, &attr);
+	if (ret)
+		return ret;
+
+	cnt_end = priv->xstats.rx_split_hdr_pkt_n;
+	if (cnt_end <= cnt_start)
+		return -EINVAL;
+
+	/* Check for TCP now */
+	cnt_start = cnt_end;
+
+	attr.dst = priv->dev->dev_addr;
+	attr.tcp = true;
+
+	ret = __stmmac_test_loopback(priv, &attr);
+	if (ret)
+		return ret;
+
+	cnt_end = priv->xstats.rx_split_hdr_pkt_n;
+	if (cnt_end <= cnt_start)
+		return -EINVAL;
+
+	return 0;
+}
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -1724,6 +1762,10 @@ static const struct stmmac_test {
 		.name = "Multichannel Jumbo  ",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_mjumbo,
+	}, {
+		.name = "Split Header        ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_sph,
 	},
 };
 
-- 
2.7.4

