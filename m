Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570F5E4930
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393365AbfJYLGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392749AbfJYLGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 07:06:08 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2F0A2084C;
        Fri, 25 Oct 2019 11:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572001567;
        bh=XAqBhj+YPcbyCxGL2lc0rr9mDgzVVxV9cJc9/9EQbsQ=;
        h=From:To:Cc:Subject:Date:From;
        b=D0l+Uek8MoPa7VB1prpeyeBv+zvX37mPQC3wW/j+tF4KiMqId5kBQWeyjfqgcxlQe
         zu1uCF15CQcOTxmB2dkoPAMkaUtObCgcwJ+FhBxZUWEk1d44KGgH/kTyA5UX/G5IMU
         xAyM0IPNVNbellBjGg4cLggGzs9PU3o/88mv6njw=
From:   Will Deacon <will@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Waisman <nico@semmle.com>
Subject: [PATCH] fjes: Handle workqueue allocation failure
Date:   Fri, 25 Oct 2019 12:06:02 +0100
Message-Id: <20191025110602.10615-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the highly unlikely event that we fail to allocate either of the
"/txrx" or "/control" workqueues, we should bail cleanly rather than
blindly march on with NULL queue pointer(s) installed in the
'fjes_adapter' instance.

Cc: "David S. Miller" <davem@davemloft.net>
Reported-by: Nicolas Waisman <nico@semmle.com>
Link: https://lore.kernel.org/lkml/CADJ_3a8WFrs5NouXNqS5WYe7rebFP+_A5CheeqAyD_p7DFJJcg@mail.gmail.com/
Signed-off-by: Will Deacon <will@kernel.org>
---

Compile-tested only.

 drivers/net/fjes/fjes_main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index bbbc1dcb6ab5..b517c1af9de0 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1237,8 +1237,17 @@ static int fjes_probe(struct platform_device *plat_dev)
 	adapter->open_guard = false;
 
 	adapter->txrx_wq = alloc_workqueue(DRV_NAME "/txrx", WQ_MEM_RECLAIM, 0);
+	if (unlikely(!adapter->txrx_wq)) {
+		err = -ENOMEM;
+		goto err_free_netdev;
+	}
+
 	adapter->control_wq = alloc_workqueue(DRV_NAME "/control",
 					      WQ_MEM_RECLAIM, 0);
+	if (unlikely(!adapter->control_wq)) {
+		err = -ENOMEM;
+		goto err_free_txrx_wq;
+	}
 
 	INIT_WORK(&adapter->tx_stall_task, fjes_tx_stall_task);
 	INIT_WORK(&adapter->raise_intr_rxdata_task,
@@ -1255,7 +1264,7 @@ static int fjes_probe(struct platform_device *plat_dev)
 	hw->hw_res.irq = platform_get_irq(plat_dev, 0);
 	err = fjes_hw_init(&adapter->hw);
 	if (err)
-		goto err_free_netdev;
+		goto err_free_control_wq;
 
 	/* setup MAC address (02:00:00:00:00:[epid])*/
 	netdev->dev_addr[0] = 2;
@@ -1277,6 +1286,10 @@ static int fjes_probe(struct platform_device *plat_dev)
 
 err_hw_exit:
 	fjes_hw_exit(&adapter->hw);
+err_free_control_wq:
+	destroy_workqueue(adapter->control_wq);
+err_free_txrx_wq:
+	destroy_workqueue(adapter->txrx_wq);
 err_free_netdev:
 	free_netdev(netdev);
 err_out:
-- 
2.24.0.rc0.303.g954a862665-goog

