Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C0735B285
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 11:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbhDKJCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 05:02:30 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:44558 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbhDKJC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 05:02:29 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d20 with ME
        id rM28240013g7mfN03M2824; Sun, 11 Apr 2021 11:02:10 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 11 Apr 2021 11:02:10 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, paul@crapouillou.net,
        andrew@lunn.ch, gustavoars@kernel.org, paulburton@kernel.org,
        Zubair.Kakakhel@imgtec.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: davicom: Fix regulator not turned off on failed probe
Date:   Sun, 11 Apr 2021 11:02:08 +0200
Message-Id: <88d396a107aad8059cabc3eb1f05f7d325287bf2.1618131620.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the probe fails, we must disable the regulator that was previously
enabled.

This patch is a follow-up to commit ac88c531a5b3
("net: davicom: Fix regulator not turned off on failed probe") which missed
one case.

Fixes: 7994fe55a4a2 ("dm9000: Add regulator and reset support to dm9000")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/davicom/dm9000.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 252adfa5d837..8a9096aa85cd 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1471,8 +1471,10 @@ dm9000_probe(struct platform_device *pdev)
 
 	/* Init network device */
 	ndev = alloc_etherdev(sizeof(struct board_info));
-	if (!ndev)
-		return -ENOMEM;
+	if (!ndev) {
+		ret = -ENOMEM;
+		goto out_regulator_disable;
+	}
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
-- 
2.27.0

