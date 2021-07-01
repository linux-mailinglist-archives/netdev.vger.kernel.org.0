Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5353B8D94
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 07:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhGAGBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 02:01:14 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:49886 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbhGAGBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 02:01:13 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d58 with ME
        id Phyh2500921Fzsu03hyhlr; Thu, 01 Jul 2021 07:58:42 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 01 Jul 2021 07:58:42 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, kuba@kernel.org, awogbemila@google.com,
        willemb@google.com, yangchun@google.com, bcf@google.com,
        kuozhao@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/3] gve: Fix an error handling path in 'gve_probe()'
Date:   Thu,  1 Jul 2021 07:58:40 +0200
Message-Id: <25de65aff4df2f0f0a67dd81b34be59b018e34c9.1625118581.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1625118581.git.christophe.jaillet@wanadoo.fr>
References: <cover.1625118581.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the 'register_netdev() call fails, we must release the resources
allocated by the previous 'gve_init_priv()' call, as already done in the
remove function.

Add a new label and the missing 'gve_teardown_priv_resources()' in the
error handling path.

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/google/gve/gve_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 867e87af3432..32166ebc0f01 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1565,7 +1565,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = register_netdev(dev);
 	if (err)
-		goto abort_with_wq;
+		goto abort_with_vge_init;
 
 	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
 	dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queue_format);
@@ -1573,6 +1573,9 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	queue_work(priv->gve_wq, &priv->service_task);
 	return 0;
 
+abort_with_vge_init:
+	gve_teardown_priv_resources(priv);
+
 abort_with_wq:
 	destroy_workqueue(priv->gve_wq);
 
-- 
2.30.2

