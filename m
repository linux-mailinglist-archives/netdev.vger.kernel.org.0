Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620F73B971E
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhGAUVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:21:13 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:39668 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbhGAUVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 16:21:12 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d15 with ME
        id PwJf2500y21Fzsu03wJga7; Thu, 01 Jul 2021 22:18:40 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 01 Jul 2021 22:18:40 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, kuba@kernel.org, awogbemila@google.com,
        willemb@google.com, yangchun@google.com, bcf@google.com,
        kuozhao@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net v2 2/2] gve: Propagate error codes to caller
Date:   Thu,  1 Jul 2021 22:18:37 +0200
Message-Id: <2a1bcfa7f84f63ab2076175c6a5c0a5a181d3bcb.1625170569.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <f5dbb1ed01d13d4eac2b719db42cb02bf8166ceb.1625170569.git.christophe.jaillet@wanadoo.fr>
References: <f5dbb1ed01d13d4eac2b719db42cb02bf8166ceb.1625170569.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If 'gve_probe()' fails, we should propagate the error code, instead of
hard coding a -ENXIO value.
Make sure that all error handling paths set a correct value for 'err'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: Unchanged
    The previous serie had 3 patches. Now their are only 2
---
 drivers/net/ethernet/google/gve/gve_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 44262c9f9ec2..c03984b26db4 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1469,7 +1469,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = pci_enable_device(pdev);
 	if (err)
-		return -ENXIO;
+		return err;
 
 	err = pci_request_regions(pdev, "gvnic-cfg");
 	if (err)
@@ -1512,6 +1512,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev = alloc_etherdev_mqs(sizeof(*priv), max_tx_queues, max_rx_queues);
 	if (!dev) {
 		dev_err(&pdev->dev, "could not allocate netdev\n");
+		err = -ENOMEM;
 		goto abort_with_db_bar;
 	}
 	SET_NETDEV_DEV(dev, &pdev->dev);
@@ -1593,7 +1594,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 abort_with_enabled:
 	pci_disable_device(pdev);
-	return -ENXIO;
+	return err;
 }
 
 static void gve_remove(struct pci_dev *pdev)
-- 
2.30.2

