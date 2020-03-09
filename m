Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4917E134
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 14:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgCINad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 09:30:33 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:39050 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbgCINad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 09:30:33 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 568B040217;
        Mon,  9 Mar 2020 13:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583760633; bh=97U/sdHYXIUwOOXmojGePjGjAgvZEazHf2GWd8NdtTA=;
        h=From:To:Cc:Subject:Date:From;
        b=azbGtfZaswH7QBuBAURz58oiW7DrrvpSItJTvgWGtGxGnFzgj7VGRVQNK8haQiKTc
         07McFHwpGbWJ+Pt4uRJMauf4jAMRmiEjekuKx/StMXiSD/zl6Aye1B+YIa9svNlVwI
         Zym7ZCfXuQVLIf4YWFxSuIFwuyFXjhoKtoNCekcmHYpREXOcC0Hvb0ogO7lmraoWhU
         i4o0Al70y6P4siHk6mMBdn7ea9I8G+Ljx8NdP6wr7a+HsLAp83nJo4hWFaoi5ZvkzP
         Z1V61c+JxACn4nzZwW3bsm7ZLC0pTwlKLqzfF2pTgXnLzEhrQC2hGlqd3cGQL24T9w
         3v3F8X89Hhjrg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7AC59A005C;
        Mon,  9 Mar 2020 13:30:29 +0000 (UTC)
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
Subject: [PATCH net-next] net: stmmac: selftests: Fix L3/L4 Filtering test
Date:   Mon,  9 Mar 2020 14:30:22 +0100
Message-Id: <4e5d8d273498a1c1c6b8f983e5dd7590c6dfd26a.1583760590.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 319a1d19471e, stmmac only support basic HW stats type for
action. Set this field in the L3/L4 Filtering test so that it correctly
setups the filter instead of returning EOPNOTSUPP.

Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 586a657be984..07dbe4f5456e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1387,6 +1387,7 @@ static int __stmmac_test_l3filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	cls->rule = rule;
 
 	rule->action.entries[0].id = FLOW_ACTION_DROP;
+	rule->action.entries[0].hw_stats_type = FLOW_ACTION_HW_STATS_TYPE_ANY;
 	rule->action.num_entries = 1;
 
 	attr.dst = priv->dev->dev_addr;
@@ -1515,6 +1516,7 @@ static int __stmmac_test_l4filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	cls->rule = rule;
 
 	rule->action.entries[0].id = FLOW_ACTION_DROP;
+	rule->action.entries[0].hw_stats_type = FLOW_ACTION_HW_STATS_TYPE_ANY;
 	rule->action.num_entries = 1;
 
 	attr.dst = priv->dev->dev_addr;
-- 
2.7.4

