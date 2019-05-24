Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8126292CE
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389512AbfEXIUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:20:39 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:35506 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389234AbfEXIUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:37 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5BC13C0120;
        Fri, 24 May 2019 08:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686044; bh=/xA5D2KU4oFCZigXo3GxuD0B41696Ac9xBvAFVj5Z6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Bae3o2bvEw06Q0eF3S+tayz5A5GOShwub/DQkIW5skGo6YQJhVQ/5ncwfHv60dxch
         t6o1iOVJ+RkUQMy9LIvTEnoui4IjtjNQZvPsJjityLweTGeV5II2UxgbZ2eOiRS0Vg
         +/YlOK3vfU5+id/DHcyU1D03FKwniClTZ/qoN0Ym4lMLQTsvkPDKlUsZXaVOz9xiNi
         8O+tLL8Pzv1TXdYBLUp+MYf3dyGRRk/8WE/E/wNkw1pWbZCVQg0uMSDBLRlduEX8EY
         LGfMspXzpoSQ6e3GjVGgSfc5rBrCl/xYSQxZSYym4lKlD7gWhBREbkAnuiBS2ixYeJ
         9THD+UecDtoOw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 77A62A00AC;
        Fri, 24 May 2019 08:20:36 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 730673FAF0;
        Fri, 24 May 2019 10:20:35 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 02/18] net: stmmac: dwmac100: Add MAC loopback support
Date:   Fri, 24 May 2019 10:20:10 +0200
Message-Id: <201a716d054b8f474a73efd18c50e7c53e1e44c7.1558685827.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the addition of stmmac selftests we implement the MAC
loopback callback in dwmac100 core.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
index b735143987e1..d621b5189c41 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
@@ -160,6 +160,18 @@ static void dwmac100_pmt(struct mac_device_info *hw, unsigned long mode)
 	return;
 }
 
+static void dwmac100_set_mac_loopback(void __iomem *ioaddr, bool enable)
+{
+	u32 value = readl(ioaddr + MAC_CONTROL);
+
+	if (enable)
+		value |= MAC_CONTROL_OM;
+	else
+		value &= ~MAC_CONTROL_OM;
+
+	writel(value, ioaddr + MAC_CONTROL);
+}
+
 const struct stmmac_ops dwmac100_ops = {
 	.core_init = dwmac100_core_init,
 	.set_mac = stmmac_set_mac,
@@ -171,6 +183,7 @@ const struct stmmac_ops dwmac100_ops = {
 	.pmt = dwmac100_pmt,
 	.set_umac_addr = dwmac100_set_umac_addr,
 	.get_umac_addr = dwmac100_get_umac_addr,
+	.set_mac_loopback = dwmac100_set_mac_loopback,
 };
 
 int dwmac100_setup(struct stmmac_priv *priv)
-- 
2.7.4

