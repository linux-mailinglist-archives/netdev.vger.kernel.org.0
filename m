Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B81882E2E
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 10:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732312AbfHFIzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 04:55:17 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:28091 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731922AbfHFIzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 04:55:17 -0400
Received: from localhost.localdomain ([90.33.211.207])
        by mwinf5d26 with ME
        id lkv92000g4V2DRm03kvANn; Tue, 06 Aug 2019 10:55:14 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 06 Aug 2019 10:55:14 +0200
X-ME-IP: 90.33.211.207
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     vishal@chelsio.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: cxgb3_main: Fix a resource leak in a error path in 'init_one()'
Date:   Tue,  6 Aug 2019 10:55:12 +0200
Message-Id: <20190806085512.11729-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A call to 'kfree_skb()' is missing in the error handling path of
'init_one()'.
This is already present in 'remove_one()' but is missing here.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 1e82b9efe447..58f89f6a040f 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3269,7 +3269,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!adapter->regs) {
 		dev_err(&pdev->dev, "cannot map device registers\n");
 		err = -ENOMEM;
-		goto out_free_adapter;
+		goto out_free_adapter_nofail;
 	}
 
 	adapter->pdev = pdev;
@@ -3397,6 +3397,9 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (adapter->port[i])
 			free_netdev(adapter->port[i]);
 
+out_free_adapter_nofail:
+	kfree_skb(adapter->nofail_skb);
+
 out_free_adapter:
 	kfree(adapter);
 
-- 
2.20.1

