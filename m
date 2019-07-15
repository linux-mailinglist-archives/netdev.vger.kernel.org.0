Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A1F6922F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392097AbfGOOf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404580AbfGOOfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:35:15 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E4BB204FD;
        Mon, 15 Jul 2019 14:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201314;
        bh=sBrDCeY41yZibmOhrq/uiQA+9bnmb6iEQSAPNEjSEq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSNGJj/+FJ8hWQ7PJ4xtLXO+4A1hPe3J6CRCB7WjWOs8oguM+f547Or9HUS7i33M0
         9yB/TtT0VuO8cP3rykRTqjWZ/aCSBEdFyTUF9S2BP3aOkLjPCe1zoeBBDbjZ3ycAdt
         QHRKVW26RhLax1clwz+xGoBdVRSquQsEaU1I6GUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 105/105] net: mvmdio: defer probe of orion-mdio if a clock is not ready
Date:   Mon, 15 Jul 2019 10:28:39 -0400
Message-Id: <20190715142839.9896-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 433a06d7d74e677c40b1148c70c48677ff62fb6b ]

Defer probing of the orion-mdio interface when getting a clock returns
EPROBE_DEFER. This avoids locking up the Armada 8k SoC when mdio is used
before all clocks have been enabled.

Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvmdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 0495487f7b42..c8e3c1119313 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -321,6 +321,10 @@ static int orion_mdio_probe(struct platform_device *pdev)
 
 	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
 		dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
+		if (PTR_ERR(dev->clk[i]) == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto out_clk;
+		}
 		if (IS_ERR(dev->clk[i]))
 			break;
 		clk_prepare_enable(dev->clk[i]);
@@ -365,6 +369,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
 	if (dev->err_interrupt > 0)
 		writel(0, dev->regs + MVMDIO_ERR_INT_MASK);
 
+out_clk:
 	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
 		if (IS_ERR(dev->clk[i]))
 			break;
-- 
2.20.1

