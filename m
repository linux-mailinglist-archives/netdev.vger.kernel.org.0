Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1B7F66BF
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfKJClT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbfKJClR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:41:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 345D9215EA;
        Sun, 10 Nov 2019 02:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353675;
        bh=0o0S7Wo9i1/gjx7t8f6sdM3bNtyEYb15PcbUreEvHys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJluvpAJJdVSQVMKsuIaa4lhcLeV6s+1wiVN5/9lybCdkOn12+XgrwyLJet2naS4o
         Dc/IDZUhgGzBIUwRlu3+VN7OowyEQGKj4oieisKOCuHDXI6Un5/V7maEgCTkXUupYX
         v89ZFSd7HM69CjLXNUZ3bv4M3hKY95aGCeZxL6eQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 039/191] net: mvpp2: fix the number of queues per cpu for PPv2.2
Date:   Sat,  9 Nov 2019 21:37:41 -0500
Message-Id: <20191110024013.29782-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit 70afb58e9856a70ff9e45760af2d0ebeb7c46ac2 ]

The Marvell PPv2.2 engine only has 8 Rx queues per CPU, while PPv2.1 has
16 of them. This patch updates the code so that the Rx queues mask width
is selected given the version of the network controller used.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 3 ++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 67b9e81b7c024..46911b67b0398 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -253,7 +253,8 @@
 #define     MVPP2_ISR_ENABLE_INTERRUPT(mask)	((mask) & 0xffff)
 #define     MVPP2_ISR_DISABLE_INTERRUPT(mask)	(((mask) << 16) & 0xffff0000)
 #define MVPP2_ISR_RX_TX_CAUSE_REG(port)		(0x5480 + 4 * (port))
-#define     MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK	0xffff
+#define     MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK(version) \
+					((version) == MVPP21 ? 0xffff : 0xff)
 #define     MVPP2_CAUSE_TXQ_OCCUP_DESC_ALL_MASK	0xff0000
 #define     MVPP2_CAUSE_TXQ_OCCUP_DESC_ALL_OFFSET	16
 #define     MVPP2_CAUSE_RX_FIFO_OVERRUN_MASK	BIT(24)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9b608d23ff7ee..29f1260535325 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -908,7 +908,7 @@ static void mvpp2_interrupts_unmask(void *arg)
 	u32 val;
 
 	val = MVPP2_CAUSE_MISC_SUM_MASK |
-		MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK;
+		MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK(port->priv->hw_version);
 	if (port->has_tx_irqs)
 		val |= MVPP2_CAUSE_TXQ_OCCUP_DESC_ALL_MASK;
 
@@ -928,7 +928,7 @@ mvpp2_shared_interrupt_mask_unmask(struct mvpp2_port *port, bool mask)
 	if (mask)
 		val = 0;
 	else
-		val = MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK;
+		val = MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK(MVPP22);
 
 	for (i = 0; i < port->nqvecs; i++) {
 		struct mvpp2_queue_vector *v = port->qvecs + i;
@@ -3059,7 +3059,8 @@ static int mvpp2_poll(struct napi_struct *napi, int budget)
 	}
 
 	/* Process RX packets */
-	cause_rx = cause_rx_tx & MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK;
+	cause_rx = cause_rx_tx &
+		   MVPP2_CAUSE_RXQ_OCCUP_DESC_ALL_MASK(port->priv->hw_version);
 	cause_rx <<= qv->first_rxq;
 	cause_rx |= qv->pending_cause_rx;
 	while (cause_rx && budget > 0) {
-- 
2.20.1

