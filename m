Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C94E149A2C
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgAZKof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:44:35 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:44911 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729145AbgAZKoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 05:44:34 -0500
Received: from localhost.localdomain ([92.140.214.230])
        by mwinf5d67 with ME
        id uykX2100J4ypjRG03ykYnL; Sun, 26 Jan 2020 11:44:33 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 26 Jan 2020 11:44:33 +0100
X-ME-IP: 92.140.214.230
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     isubramanian@apm.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, tinamdar@apm.com, kdinh@apm.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] drivers: net: xgene: Fix the order
Date:   Sun, 26 Jan 2020 11:44:29 +0100
Message-Id: <20200126104429.15156-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'alloc_etherdev_mqs()' expects first 'tx', then 'rx'. The semantic here
looks reversed.

Reorder the arguments passed to 'alloc_etherdev_mqs()' in order to keep
the correct semantic.

In fact, this is a no-op because both XGENE_NUM_[RT]X_RING are 8.

Fixes: 107dec2749fe ("drivers: net: xgene: Add support for multiple queues")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index d8612131c55e..cc8031ae9aa3 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -2020,7 +2020,7 @@ static int xgene_enet_probe(struct platform_device *pdev)
 	int ret;
 
 	ndev = alloc_etherdev_mqs(sizeof(struct xgene_enet_pdata),
-				  XGENE_NUM_RX_RING, XGENE_NUM_TX_RING);
+				  XGENE_NUM_TX_RING, XGENE_NUM_RX_RING);
 	if (!ndev)
 		return -ENOMEM;
 
-- 
2.20.1

