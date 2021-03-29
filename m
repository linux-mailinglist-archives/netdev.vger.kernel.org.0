Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5723734DA8E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhC2WW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhC2WWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E36761976;
        Mon, 29 Mar 2021 22:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056549;
        bh=izmVQE2q3oDBL9Q6aBDQ5xvG32ynTHTbr234NfHzkp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iw4xBIQVNjcKV7zlpKa4koWQ+eRt8rphiXMIKs3MjiGIzSVABJ+5ZcwNoXNuQG5JV
         ToiG1CniT772LKvjZZzS9T2gaqEhXDbJziFCWomT/dXGYL3v3ZGpESIM9oyVPnzd75
         +jmfS7yqHgzxDL7M0MA58xhm1ev3W04/jaGPWz4pn7w2BU11xxHAKTbiGPwycge5+Y
         P++cYRe+syB0paz6YrY2j0ganmbN/Ax/CWR3uJ6XnwkSXNRcVhc3D/OZmDbO1uXA0e
         e9r7afc4PpntAPhPOFSaAM1TSenKKw/I8IQG3NU3dPaZq6m+PPHSWp2q3YSVKTSUz6
         qawhcawgqghCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Andrianov <andrianov@ispras.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/33] net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
Date:   Mon, 29 Mar 2021 18:21:54 -0400
Message-Id: <20210329222222.2382987-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Andrianov <andrianov@ispras.ru>

[ Upstream commit 0571a753cb07982cc82f4a5115e0b321da89e1f3 ]

pxa168_eth_remove() firstly calls unregister_netdev(),
then cancels a timeout work. unregister_netdev() shuts down a device
interface and removes it from the kernel tables. If the timeout occurs
in parallel, the timeout work (pxa168_eth_tx_timeout_task) performs stop
and open of the device. It may lead to an inconsistent state and memory
leaks.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Pavel Andrianov <andrianov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.30.1

