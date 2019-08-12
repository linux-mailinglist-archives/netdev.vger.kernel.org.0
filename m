Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5033E89A4D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfHLJpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:45:41 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:35314 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727525AbfHLJo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:44:26 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7FDFAC21DD;
        Mon, 12 Aug 2019 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565603065; bh=Mu5FfcCMExtM/+NUUyaIoYWn4U1FuWhjBdmEdKgXuvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Dc2AUs6hcTQHCc5Tqz3MRjAi+3x6g+gjzrL8EB2xNj4Gq9pOL7YHew3FL7d6JfJXC
         E1quAQNntpye6wb3FTzYlQUcGKkEsiPXcpqJEQxBI8XlTOWBEMUEBnxjRQfhg6RoUk
         jcMsL7Si0+1FAY08YxF2COTGgQfns/P+JY4zovWE6lTxGxi0T+l8YHzWk/Ii/C8V18
         Qi00fKGuLW1jvhsXEY+d7qbHpMPwZV15LR/8kztbMSGhz7J5yNbp2vtBhyaHSE4zg7
         PyTEJ9YyBp3moMJpPLQkx7rLxSGebZNjq7Hdd69RDAODbrbqs12Yl5JorPjjsjmtk9
         sQPSZ5yNXCceA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 1B3EEA006A;
        Mon, 12 Aug 2019 09:44:23 +0000 (UTC)
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
Subject: [PATCH net-next v2 05/12] net: stmmac: Add a counter for Split Header packets
Date:   Mon, 12 Aug 2019 11:44:04 +0200
Message-Id: <401056872393d41f8fe87ad6f08ee52aea3316f8.1565602974.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a counter that increments each time a packet with split header is
received.

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
 drivers/net/ethernet/stmicro/stmmac/common.h         | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 527f961579f4..1303ec81fd3d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -75,6 +75,7 @@ struct stmmac_extra_stats {
 	unsigned long rx_missed_cntr;
 	unsigned long rx_overflow_cntr;
 	unsigned long rx_vlan;
+	unsigned long rx_split_hdr_pkt_n;
 	/* Tx/Rx IRQ error info */
 	unsigned long tx_undeflow_irq;
 	unsigned long tx_process_stopped_irq;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 2423160ab582..eb784fdb6d32 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -65,6 +65,7 @@ static const struct stmmac_stats stmmac_gstrings_stats[] = {
 	STMMAC_STAT(rx_missed_cntr),
 	STMMAC_STAT(rx_overflow_cntr),
 	STMMAC_STAT(rx_vlan),
+	STMMAC_STAT(rx_split_hdr_pkt_n),
 	/* Tx/Rx IRQ error info */
 	STMMAC_STAT(tx_undeflow_irq),
 	STMMAC_STAT(tx_process_stopped_irq),
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 556c75803f70..1fd00e18c65a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3504,6 +3504,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 				len = hlen;
 
 				prefetch(page_address(buf->sec_page));
+				priv->xstats.rx_split_hdr_pkt_n++;
 			}
 
 			skb = netdev_alloc_skb_ip_align(priv->dev, len);
-- 
2.7.4

