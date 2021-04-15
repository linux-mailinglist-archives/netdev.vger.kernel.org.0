Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A304736047B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhDOIi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:38:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38262 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbhDOIiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:38:25 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lWxVd-0008RD-8Q; Thu, 15 Apr 2021 08:37:57 +0000
From:   Colin King <colin.king@canonical.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: stmmac: replace redundant comparison with true
Date:   Thu, 15 Apr 2021 09:37:57 +0100
Message-Id: <20210415083757.1807538-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparison of the u32 variable queue with <= zero is always true
since an unsigned can never be negative. Replace the conditional
check with the boolean true to simplify the code.  The while loop
will terminate because of the zero check on queue before queue is
decremented.

Addresses-Coverity: ("Unsigned compared against 0")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e3e22200a4fd..6e5b4c4b375c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1673,7 +1673,7 @@ static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
 	return;
 
 err_reinit_rx_buffers:
-	while (queue >= 0) {
+	while (true) {
 		dma_free_rx_skbufs(priv, queue);
 
 		if (queue == 0)
@@ -1781,7 +1781,7 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 	return 0;
 
 err_init_rx_buffers:
-	while (queue >= 0) {
+	while (true) {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 
 		if (rx_q->xsk_pool)
-- 
2.30.2

