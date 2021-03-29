Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0202A34DBAD
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhC2W3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232629AbhC2W1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:27:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2920B619D6;
        Mon, 29 Mar 2021 22:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056656;
        bh=HFYKuxpYHtQOqawdfm9OLszkbzF9HJNXJCRqgjZgVMM=;
        h=From:To:Cc:Subject:Date:From;
        b=XDq4y6ao3TTQZOI3A4bg/3PjxrcFbnUnoL4BzFR/eRzAM000SzxH/CqnUKRsCVqd/
         5V+guYpsdkSV+9riCKjowM2orwuZsbEN36Uk5qeuMi85S0cInTa4s9RjAd8MaZPXMA
         +FvAIyC6f7K96dFC5GwlMz2JhhSG8ifasGLCPGPQRvpPgQhrl9BBY7WBsHNFKZAvjK
         hoLM3TkRS3ttKLznayrJ1s1EBjf1eliMgGstXjQvaANXLf0HxPQJm2QY4dVEX4ZEUr
         cAQVPUUZpz1y7M5fISTsw5IkT4Q/AZ+JGod1DmSZABB7voezLB6V1wW4M1BS8EkobK
         G2VNrSv2TwsSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Andrianov <andrianov@ispras.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/8] net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
Date:   Mon, 29 Mar 2021 18:24:07 -0400
Message-Id: <20210329222415.2384075-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
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
index 7ace07dad6a3..9986f88618bd 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1577,8 +1577,8 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 
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

