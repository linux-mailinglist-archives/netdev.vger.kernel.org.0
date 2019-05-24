Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F398D292E7
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389765AbfEXIVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:21:21 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:35558 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389488AbfEXIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:38 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 16CB1C012F;
        Fri, 24 May 2019 08:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686046; bh=vbiINay3aeS1idUVvkAwFPMq+uSnPPCE9dguIoQsROg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=YizF1BnjeoJ/dc9xyh5d7ZLfWtrjb01BG4nsvX9r7Zg0RZBWE6U+6EcEXMTH9rGTY
         wCQ1W+ZhM8OpuRwdXmEPr0beV72rUxDMfIaJTXoPsf1QslErCFNXgi9AP+wqqarKB6
         aCfl/hXSY3pWo/kT6GBWq+ZgEta58WVcASkpf1xihqpRmiww7uAi7fvaZ1eAxm1CZ8
         +/Jb1XmAKicIGzZx/H2T5cEoWu0PrQfqIfuEPfVyM+SjxwppqfPQBl0nNATXtdTEh4
         DlYa54XgO5/ScqpGXqzyY4Ts46mNMJb00rW1OQWaPJqzCRy6z/1tO+utP2MA3s9QSf
         gsottXG7x69aw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 5A70CA0257;
        Fri, 24 May 2019 08:20:38 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 6437D3FB1B;
        Fri, 24 May 2019 10:20:36 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 14/18] net: stmmac: dwmac4/5: Fix Hash Filter
Date:   Fri, 24 May 2019 10:20:22 +0200
Message-Id: <a9e133f9b4b501fa862eeb8aa6b567ebbbc2b38b.1558685828.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for hash filter to work we need to set the HPF bit.

Fout out while running stmmac selftests

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index c3cbca804bcd..01c10893b7a5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -65,6 +65,7 @@
 #define GMAC_PACKET_FILTER_HMC		BIT(2)
 #define GMAC_PACKET_FILTER_PM		BIT(4)
 #define GMAC_PACKET_FILTER_PCF		BIT(7)
+#define GMAC_PACKET_FILTER_HPF		BIT(10)
 
 #define GMAC_MAX_PERFECT_ADDRESSES	128
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 31679480564a..4038fe914f72 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -440,6 +440,8 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 		writel(mc_filter[1], ioaddr + GMAC_HASH_TAB_32_63);
 	}
 
+	value |= GMAC_PACKET_FILTER_HPF;
+
 	/* Handle multiple unicast addresses */
 	if (netdev_uc_count(dev) > GMAC_MAX_PERFECT_ADDRESSES) {
 		/* Switch to promiscuous mode if more than 128 addrs
-- 
2.7.4

