Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C243E5CAF
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfJZNSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbfJZNSf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97D0121655;
        Sat, 26 Oct 2019 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095914;
        bh=ZnwUf7S1kxzIWSSKaI2hTjSkgyg6l2w2zizALkYNYDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUcfKOStS2jbcM5FdrjfGZi2VpuyDVHDb57Q0WZ78xPASNxU3gIhzjkMIlV5GbFrQ
         fiMKQ0SddSqfFWhSyjRCSqNfrARN77ck5HoVKRgCUeu1uvJRiqsG3ZmbalZt9Mt1E1
         IsafR/Js4qD6POHZM5CPMT7E/JjKiddVM2hWf1Ic=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 86/99] net: stmmac: fix argument to stmmac_pcs_ctrl_ane()
Date:   Sat, 26 Oct 2019 09:15:47 -0400
Message-Id: <20191026131600.2507-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>

[ Upstream commit c9ad4c1049f7e0e8d59e975963dda002af47d93e ]

The stmmac_pcs_ctrl_ane() expects a register address as
argument 1, but for some reason the mac_device_info is
being passed.

Fix the warning (and possible bug) from sparse:

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17: warning: incorrect type in argument 1 (different address spaces)
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17:    expected void [noderef] <asn:2> *ioaddr
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17:    got struct mac_device_info *hw

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 374f9b49bcc14..2722778a50051 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2564,7 +2564,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	}
 
 	if (priv->hw->pcs)
-		stmmac_pcs_ctrl_ane(priv, priv->hw, 1, priv->hw->ps, 0);
+		stmmac_pcs_ctrl_ane(priv, priv->ioaddr, 1, priv->hw->ps, 0);
 
 	/* set TX and RX rings length */
 	stmmac_set_rings_length(priv);
-- 
2.20.1

