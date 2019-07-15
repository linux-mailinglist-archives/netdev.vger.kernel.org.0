Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F61A68E4E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388109AbfGOOFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388039AbfGOOFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:05:19 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7185C206B8;
        Mon, 15 Jul 2019 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199518;
        bh=jdCVrBGq/WqfVFznp4hYp17AUmVsw3vFbaB+1H64BDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOfHPHeyyMvmsUc8YkAiZ8GSI+7hanGlsWhMNoAGU9dfYD1qt/hEr0nFWcwB5Y/c+
         QJmIulyu9qEUC27Wf2s9GrTkSaC9oMFB9JJZ0Kg5944KO8lxdLUkUZZVWCYHG27gnI
         vCxt8aA9jtbPS01InR0PIffLtBy+fb1SYpKGES80=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Joao Pinto <jpinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 030/219] net: stmmac: Prevent missing interrupts when running NAPI
Date:   Mon, 15 Jul 2019 10:00:31 -0400
Message-Id: <20190715140341.6443-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit a976ca79e23f13bff79c14e7266cea4a0ea51e67 ]

When we trigger NAPI we are disabling interrupts but in case we receive
or send a packet in the meantime, as interrupts are disabled, we will
miss this event.

Trigger both NAPI instances (RX and TX) when at least one event happens
so that we don't miss any interrupts.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a634054dcb11..f3735d0458eb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2058,6 +2058,9 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 						 &priv->xstats, chan);
 	struct stmmac_channel *ch = &priv->channel[chan];
 
+	if (status)
+		status |= handle_rx | handle_tx;
+
 	if ((status & handle_rx) && (chan < priv->plat->rx_queues_to_use)) {
 		stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
 		napi_schedule_irqoff(&ch->rx_napi);
-- 
2.20.1

