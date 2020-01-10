Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7819137111
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgAJPX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:23:58 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:56098 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728175AbgAJPX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:23:58 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8B25C40617;
        Fri, 10 Jan 2020 15:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578669837; bh=Tzgqy5mfUlP11G5dMWBkE/G8KGSMMm7VMyafaqnQDXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=cEIRMwFA8tzWI52Mf0b+XRxJ8m31NaIlnuS2buIgJzZFW6greSb7+tKbOa++vSBzc
         7QfhqR4Pnt2nzLdpGZzWCoNBcIZyOSGxG71vrVEk/Dsitals59/yLHGY6GYqRygRz3
         O2WHatELCgFuXJ5DSeSIX0WIj2EHiUlcVIrq/JJCcG+f/R2t3yPTbSqsXVkcJQl+R1
         niylholPlKGCga+uPJASd9SIPEpf3yLRSefr+MeJ0fp+sIlv2czdIdw1cVCc7w0zap
         4+gD2SpBFThWV73nKErJ19Ap6GL/dyqHQaEVa/nOpfcu4oeBBvedEMBEK9U6sB998Y
         0za0xDOu4nQXg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4CF13A0067;
        Fri, 10 Jan 2020 15:23:56 +0000 (UTC)
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
Subject: [PATCH net 2/2] net: stmmac: tc: Do not setup flower filtering if RSS is enabled
Date:   Fri, 10 Jan 2020 16:23:53 +0100
Message-Id: <9d6b1bbc1878c33a281ef1c8d3a8541bc181655a.1578669661.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578669661.git.Jose.Abreu@synopsys.com>
References: <cover.1578669661.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578669661.git.Jose.Abreu@synopsys.com>
References: <cover.1578669661.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RSS, when enabled, will bypass the L3 and L4 filtering causing it not
to work. Add a check before trying to setup the filters.

Fixes: 425eabddaf0f ("net: stmmac: Implement L3/L4 Filters using TC Flower")
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 7d972e0fd2b0..9ffae12a2122 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -577,6 +577,10 @@ static int tc_setup_cls(struct stmmac_priv *priv,
 {
 	int ret = 0;
 
+	/* When RSS is enabled, the filtering will be bypassed */
+	if (priv->rss.enable)
+		return -EBUSY;
+
 	switch (cls->command) {
 	case FLOW_CLS_REPLACE:
 		ret = tc_add_flow(priv, cls);
-- 
2.7.4

