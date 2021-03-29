Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A3E34DB42
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhC2W06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232741AbhC2WYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 530AF619AA;
        Mon, 29 Mar 2021 22:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056612;
        bh=KJEvGHzzOuQt6ehmTQITErpDUNKmPJNKPKi8+BmVIYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gC+n6zeqDn7Y9koZAmcevLd+S4JIU1QH12PQMCn0N5r8xLD0F6LgCPQugfIMqEwdl
         ZUCuHgvhYg2XV3RPcho5URD6yzXR3FuKebClFFRpO85F9YbwlXNXsnrR7LnKfnxqH8
         3vBZElIcT+Zhhq7K9sDqCf0pEL+z9iD3fm9MFYqSFG25oZPd/BMGlLQaAbOwrNIcjQ
         dEcmnFZ4QCxakTG1bbu36Oox5ROZSCRKDi93wDGHpguaSEBIOPm+MIFl7cuGQ27t3u
         E5BU/u7aGpCM9ZCTvXupijx2kWdcujH8I571zJsnefRd9ubBN5S7SZNLiWVvDZS2em
         DAgY+ikvDVIdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Andrianov <andrianov@ispras.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/15] net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
Date:   Mon, 29 Mar 2021 18:23:15 -0400
Message-Id: <20210329222327.2383533-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
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
index ff2fea0f8b75..0d6a4e47e7a5 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1564,8 +1564,8 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 
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

