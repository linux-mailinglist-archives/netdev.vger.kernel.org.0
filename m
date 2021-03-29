Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C034DB04
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhC2WYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232433AbhC2WXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC4456198F;
        Mon, 29 Mar 2021 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056590;
        bh=PlR3//CR3E3bW4LpvP76DI4ReevmAjaFNMtqUBmlR3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvokAnBo9Tc+Wd9svfaa2Y+gk/Yn2MD7w4bXO1rZcXU2k8PzoREN0t3Vi/MfK84Hn
         p490Wca4dd0m23mJ8tMlRR1wW0G3wshSL6Cd69snLNfIwyVoT7x1XMDuX5hcS9RfXD
         R9Et9unZO5IlmUSWlKZEAPpMcrw8OLDf0Ko+QLfVP0MT3U/Lr2ZgWwvWhbIkF6u2OY
         Fqn2gqraHF5s7JzRYWSKEQvCoyaSExzWC648pgmJvFa+QojO2+SD4F2EZPZw45zq2F
         KIplpFsYOCDibBb2jS8YYNd3YcWla1aceQ3Fi0A/vxCkVjpvfWfmE0u+MzYFc4tWSY
         z1QGPds7xJkww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Andrianov <andrianov@ispras.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/19] net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
Date:   Mon, 29 Mar 2021 18:22:49 -0400
Message-Id: <20210329222303.2383319-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222303.2383319-1-sashal@kernel.org>
References: <20210329222303.2383319-1-sashal@kernel.org>
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
index 51b77c2de400..235bbb2940a8 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1554,8 +1554,8 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 
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

