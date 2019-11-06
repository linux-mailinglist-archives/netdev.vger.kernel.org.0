Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EEBF1970
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbfKFPDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:03:45 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43154 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731955AbfKFPDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:03:13 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3CF36C0F53;
        Wed,  6 Nov 2019 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573052592; bh=8Mgy8SE+u7zp7nfFF49sdswEnUy9PwnZGeHPTqEIxvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=QUFsaUN8n6uJW35Bjts1fuCuAV7CwwSDDXMVSR/wfROz4qCGrLjgwJwyW3NBYzqTm
         4Y52+zxsSeebPHI6duugX6SENImDA+xrkCuD53HXMNQMrAXD9NlS4iQUN2LXbmp3hG
         nkfUo+OaPPldukiLn10lkSxdJDFEctjD/I524uxcST9SdnNxfwf4FYxe+XVfxr8S7g
         W1aggZr6SPa68+kwtQThFQeIK+Y0/9+ByJmuvSBgqyNkvlS7jGryNBigAV9XGIrClE
         RXU7Hr7RqscxVQ/YC8yKXaESrRhOynXHuNcXmClQQ8TmP8jQixtv8pjgtzwI/aMwYI
         I1lP3BEFgguaA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id EF2AAA0085;
        Wed,  6 Nov 2019 15:03:10 +0000 (UTC)
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
Subject: [PATCH net 10/11] net: stmmac: Fix TSO descriptor with Enhanced Addressing
Date:   Wed,  6 Nov 2019 16:03:04 +0100
Message-Id: <c9c9e9d025b2164632b24ce560ac52981f77d57e.1573052379.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using addressing > 32 bits the TSO first descriptor only has the
header so we can't set the payload field for this descriptor. Let's
reset the variable so that buffer 2 value is zero.

Fixes: a993db88d17d ("net: stmmac: Enable support for > 32 Bits addressing in XGMAC")
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1ab1eea1556a..b0a16d7c6e3d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2996,6 +2996,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		stmmac_set_desc_addr(priv, first, des);
 		tmp_pay_len = pay_len;
 		des += proto_hdr_len;
+		pay_len = 0;
 	}
 
 	stmmac_tso_allocator(priv, des, tmp_pay_len, (nfrags == 0), queue);
-- 
2.7.4

