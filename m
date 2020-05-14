Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2FC1D3C3A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgENSwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbgENSwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:52:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C81B20675;
        Thu, 14 May 2020 18:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482328;
        bh=zLUCqSvC236bu0DFeMlfYuTWti5TF2S5odgN6soGDug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nq65Yv0syFa1PMGe/HOB57YLMaviib9PK2kIhTdJW6qIBe8vvoNWlsAuMEcmzN245
         D9xR19tcavLkSnMEW6+7XgT50yXSs0F293ZeYVbzISLS/ePwvbm/fvEMJOXbVWxb9R
         PczZTj1ozaAcy8pYsoyB26xMGxGbUbXV8lX5T3gI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 15/62] net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'
Date:   Thu, 14 May 2020 14:51:00 -0400
Message-Id: <20200514185147.19716-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 10e3cc180e64385edc9890c6855acf5ed9ca1339 ]

A call to 'dma_alloc_coherent()' is hidden in 'sonic_alloc_descriptors()',
called from 'sonic_probe1()'.

This is correctly freed in the remove function, but not in the error
handling path of the probe function.
Fix it and add the missing 'dma_free_coherent()' call.

While at it, rename a label in order to be slightly more informative.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/jazzsonic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/jazzsonic.c b/drivers/net/ethernet/natsemi/jazzsonic.c
index 51fa82b429a3c..40970352d2082 100644
--- a/drivers/net/ethernet/natsemi/jazzsonic.c
+++ b/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -235,11 +235,13 @@ static int jazz_sonic_probe(struct platform_device *pdev)
 
 	err = register_netdev(dev);
 	if (err)
-		goto out1;
+		goto undo_probe1;
 
 	return 0;
 
-out1:
+undo_probe1:
+	dma_free_coherent(lp->device, SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 	release_mem_region(dev->base_addr, SONIC_MEM_SIZE);
 out:
 	free_netdev(dev);
-- 
2.20.1

