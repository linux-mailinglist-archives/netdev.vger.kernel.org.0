Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7712F33372C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCJIVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:21:00 -0500
Received: from mail.ispras.ru ([83.149.199.84]:36884 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhCJIU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 03:20:27 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2021 03:20:26 EST
Received: from localhost.localdomain (unknown [185.13.112.193])
        by mail.ispras.ru (Postfix) with ESMTPSA id B9EAB40D403D;
        Wed, 10 Mar 2021 08:10:52 +0000 (UTC)
From:   Pavel Andrianov <andrianov@ispras.ru>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Pavel Andrianov <andrianov@ispras.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
Date:   Wed, 10 Mar 2021 11:10:46 +0300
Message-Id: <20210310081046.505747-1-andrianov@ispras.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pxa168_eth_remove() firstly calls unregister_netdev(),
then cancels a timeout work. unregister_netdev() shuts down a device
interface and removes it from the kernel tables. If the timeout occurs
in parallel, the timeout work (pxa168_eth_tx_timeout_task) performs stop
and open of the device. It may lead to an inconsistent state and memory
leaks.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Pavel Andrianov <andrianov@ispras.ru>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index d1e4d42e497d..3712e1786091 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1544,8 +1544,8 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 	clk_disable_unprepare(pep->clk);
 	mdiobus_unregister(pep->smi_bus);
 	mdiobus_free(pep->smi_bus);
-	unregister_netdev(dev);
 	cancel_work_sync(&pep->tx_timeout_task);
+	unregister_netdev(dev);
 	free_netdev(dev);
 	return 0;
 }
-- 
2.25.1

