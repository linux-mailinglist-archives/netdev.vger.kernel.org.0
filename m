Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FA12FC914
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731907AbhATC32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbhATB26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89E6B2333C;
        Wed, 20 Jan 2021 01:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105998;
        bh=WnYGfdtWhQjlRaYO46+WG7tduw02H5398tfUFmXkLN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYLrXryRCd/xhD6F3y4nCpAFlUew85b71urrEkgSKaw1hVjlPMUM5uWcJcZyd4j+2
         njTf7TQthUSvpQCkb0XaODc+HjmMpF2SudE+3BV8z7ZGWD9VDwAZmFSMOWSxqv4eA+
         eLoztbajIg9EMe0n/b4RINXrN6cLisTHMuL5DY2vqO8veWCVs3oAJJi2A1tMXJ5opw
         3F3TCAx79gxTQh/Qz5B1pTE0e9fce0Ai9jAf1sdOfBnYuD0k6P2IBAqQSwHlNtl5OS
         P5YSmfqtu2nevDUFRwIiH+Dn8aOi43ePKLVxwK5xscgmbgvVYH15WqRTp4zXeHp1c1
         Y6sWOEFewjzsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seb Laveze <sebastien.laveze@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 27/45] net: stmmac: use __napi_schedule() for PREEMPT_RT
Date:   Tue, 19 Jan 2021 20:25:44 -0500
Message-Id: <20210120012602.769683-27-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Seb Laveze <sebastien.laveze@nxp.com>

[ Upstream commit 1f02efd1bb35bee95feed6aab46d1217f29d555b ]

Use of __napi_schedule_irqoff() is not safe with PREEMPT_RT in which
hard interrupts are not disabled while running the threaded interrupt.

Using __napi_schedule() works for both PREEMPT_RT and mainline Linux,
just at the cost of an additional check if interrupts are disabled for
mainline (since they are already disabled).

Similar to the fix done for enetc commit 215602a8d212 ("enetc: use
napi_schedule to be compatible with PREEMPT_RT")

Signed-off-by: Seb Laveze <sebastien.laveze@nxp.com>
Link: https://lore.kernel.org/r/20210112140121.1487619-1-sebastien.laveze@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c33db79cdd0ad..cb39f6dbf72b8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2158,7 +2158,7 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 			spin_lock_irqsave(&ch->lock, flags);
 			stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 0);
 			spin_unlock_irqrestore(&ch->lock, flags);
-			__napi_schedule_irqoff(&ch->rx_napi);
+			__napi_schedule(&ch->rx_napi);
 		}
 	}
 
@@ -2167,7 +2167,7 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 			spin_lock_irqsave(&ch->lock, flags);
 			stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 0, 1);
 			spin_unlock_irqrestore(&ch->lock, flags);
-			__napi_schedule_irqoff(&ch->tx_napi);
+			__napi_schedule(&ch->tx_napi);
 		}
 	}
 
-- 
2.27.0

