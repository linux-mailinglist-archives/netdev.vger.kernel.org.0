Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2764713E806
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392868AbgAPR3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:29:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392856AbgAPR3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:29:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64CD24710;
        Thu, 16 Jan 2020 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195786;
        bh=sqN9Ia28wx00eEWZy/Rnbw2Pe3jh79jsaCmiTr1yRgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/nk//GGKvo8XhJ73vgX3NAFtyUnrHOTyRdJfF4wwCjZnZEXpRd+A/Gt3HP0F4NFy
         H5WMgXm8xY/kUhsWM4UPWY1hvxrQEhxojneZ2IMW6G6F3ENfA9SuRh0sWiWhjr66gc
         3b9PDesfHXLO1uNpurSwh4vZ0mMDRWcJTUh6IdFg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 309/371] net: ethernet: stmmac: Fix signedness bug in ipq806x_gmac_of_parse()
Date:   Thu, 16 Jan 2020 12:23:01 -0500
Message-Id: <20200116172403.18149-252-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 231042181dc9d6122c6faba64e99ccb25f13cc6c ]

The "gmac->phy_mode" variable is an enum and in this context GCC will
treat it as an unsigned int so the error handling will never be
triggered.

Fixes: b1c17215d718 ("stmmac: add ipq806x glue layer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 866444b6c82f..11a4a81b0397 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -203,7 +203,7 @@ static int ipq806x_gmac_of_parse(struct ipq806x_gmac *gmac)
 	struct device *dev = &gmac->pdev->dev;
 
 	gmac->phy_mode = of_get_phy_mode(dev->of_node);
-	if (gmac->phy_mode < 0) {
+	if ((int)gmac->phy_mode < 0) {
 		dev_err(dev, "missing phy mode property\n");
 		return -EINVAL;
 	}
-- 
2.20.1

