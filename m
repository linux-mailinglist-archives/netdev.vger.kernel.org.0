Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B4183318
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731883AbfHFNnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:43:17 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:59162 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731894AbfHFNm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:42:57 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BE706C21CC;
        Tue,  6 Aug 2019 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565098977; bh=18B/BrYz2sxVzKeQcjktizOD0pcEwHNkm/ulnP89N5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ggMGdYW7W/TdZKv7lXxaEWfjmo/y1eQGWGZl5pw5rKnHNzvSgAkLa7aV9H48M6Dfj
         lKIX0EVMX4yUCAlBh7jwyxmOHlC634Z1VtYftkc29s7Bvpn8RNtQQF6HxESPKLni5s
         ZW+qzxtYrJgxeQyV5hEDPrBwz9A0TVku2Tc3JNd+pR4jHyIFiQOf0ATNnGgWBy8nnQ
         +bbxovWKCm8KTIjK1oo+9B7VNop5V6qRUv0m+j23C5EQc0Ab+ABXFaBzCGwg30rmKV
         heps87PchFFwmNn9ZaIp5NawFjLUHTkUmU6oy+qcI0EjdAeMxiRk7eCcpgswvmhRMn
         ewiG+JvHfyZqA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7B0AFA007A;
        Tue,  6 Aug 2019 13:42:55 +0000 (UTC)
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
Subject: [PATCH net-next v2 10/10] net: stmmac: selftests: Add a selftest for Flexible RX Parser
Date:   Tue,  6 Aug 2019 15:42:51 +0200
Message-Id: <486b11dcec03cb5a7d0dc166bf57c09627e53a8b.1565098881.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565098881.git.joabreu@synopsys.com>
References: <cover.1565098881.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565098881.git.joabreu@synopsys.com>
References: <cover.1565098881.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest for the Flexible RX Parser feature.

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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 98 +++++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 6b08bb15af15..abab84f2ef8b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -11,8 +11,10 @@
 #include <linux/ip.h>
 #include <linux/phy.h>
 #include <linux/udp.h>
+#include <net/pkt_cls.h>
 #include <net/tcp.h>
 #include <net/udp.h>
+#include <net/tc_act/tc_gact.h>
 #include "stmmac.h"
 
 struct stmmachdr {
@@ -229,7 +231,7 @@ static int stmmac_test_loopback_validate(struct sk_buff *skb,
 			goto out;
 	}
 	if (tpriv->packet->src) {
-		if (!ether_addr_equal(ehdr->h_source, orig_ndev->dev_addr))
+		if (!ether_addr_equal(ehdr->h_source, tpriv->packet->src))
 			goto out;
 	}
 
@@ -912,6 +914,96 @@ static int stmmac_test_dvlanfilt(struct stmmac_priv *priv)
 	return ret;
 }
 
+#ifdef CONFIG_NET_CLS_ACT
+static int stmmac_test_rxp(struct stmmac_priv *priv)
+{
+	unsigned char addr[ETH_ALEN] = {0xde, 0xad, 0xbe, 0xef, 0x00, 0x00};
+	struct tc_cls_u32_offload cls_u32 = { };
+	struct stmmac_packet_attrs attr = { };
+	struct tc_action **actions, *act;
+	struct tc_u32_sel *sel;
+	struct tcf_exts *exts;
+	int ret, i, nk = 1;
+
+	if (!tc_can_offload(priv->dev))
+		return -EOPNOTSUPP;
+	if (!priv->dma_cap.frpsel)
+		return -EOPNOTSUPP;
+
+	sel = kzalloc(sizeof(*sel) + nk * sizeof(struct tc_u32_key), GFP_KERNEL);
+	if (!sel)
+		return -ENOMEM;
+
+	exts = kzalloc(sizeof(*exts), GFP_KERNEL);
+	if (!exts) {
+		ret = -ENOMEM;
+		goto cleanup_sel;
+	}
+
+	actions = kzalloc(nk * sizeof(*actions), GFP_KERNEL);
+	if (!actions) {
+		ret = -ENOMEM;
+		goto cleanup_exts;
+	}
+
+	act = kzalloc(nk * sizeof(*act), GFP_KERNEL);
+	if (!act) {
+		ret = -ENOMEM;
+		goto cleanup_actions;
+	}
+
+	cls_u32.command = TC_CLSU32_NEW_KNODE;
+	cls_u32.common.chain_index = 0;
+	cls_u32.common.protocol = htons(ETH_P_ALL);
+	cls_u32.knode.exts = exts;
+	cls_u32.knode.sel = sel;
+	cls_u32.knode.handle = 0x123;
+
+	exts->nr_actions = nk;
+	exts->actions = actions;
+	for (i = 0; i < nk; i++) {
+		struct tcf_gact *gact = to_gact(&act[i]);
+
+		actions[i] = &act[i];
+		gact->tcf_action = TC_ACT_SHOT;
+	}
+
+	sel->nkeys = nk;
+	sel->offshift = 0;
+	sel->keys[0].off = 6;
+	sel->keys[0].val = htonl(0xdeadbeef);
+	sel->keys[0].mask = ~0x0;
+
+	ret = stmmac_tc_setup_cls_u32(priv, priv, &cls_u32);
+	if (ret)
+		goto cleanup_act;
+
+	attr.dst = priv->dev->dev_addr;
+	attr.src = addr;
+
+	ret = __stmmac_test_loopback(priv, &attr);
+	ret = !ret; /* Shall NOT receive packet */
+
+	cls_u32.command = TC_CLSU32_DELETE_KNODE;
+	stmmac_tc_setup_cls_u32(priv, priv, &cls_u32);
+
+cleanup_act:
+	kfree(act);
+cleanup_actions:
+	kfree(actions);
+cleanup_exts:
+	kfree(exts);
+cleanup_sel:
+	kfree(sel);
+	return ret;
+}
+#else
+static int stmmac_test_rxp(struct stmmac_priv *priv)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #define STMMAC_LOOPBACK_NONE	0
 #define STMMAC_LOOPBACK_MAC	1
 #define STMMAC_LOOPBACK_PHY	2
@@ -969,6 +1061,10 @@ static const struct stmmac_test {
 		.name = "Double VLAN Filtering",
 		.lb = STMMAC_LOOPBACK_PHY,
 		.fn = stmmac_test_dvlanfilt,
+	}, {
+		.name = "Flexible RX Parser   ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_rxp,
 	},
 };
 
-- 
2.7.4

