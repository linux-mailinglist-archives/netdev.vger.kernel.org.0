Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63FE0A8C62
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733079AbfIDQM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732538AbfIDQAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7511B2070C;
        Wed,  4 Sep 2019 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612802;
        bh=J+WLUY334ZG4D403lkSQBL5KZPw9kQ34nkZrR/am+/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDPpeUqDuuD+iFsxpiomUh0jp7tgWH/uyRXP1uNFafawM6XpEeUseIOnTOzLlTlKP
         WtkFXJ4rrjRnYnpGPUGbe8cM6wc8gwAaChcHmTpd933I/zjyiQK0X40ImaPDtU3IBU
         h+s8Fx6BdqjLV8pJvGizkbgGxD3ahl35Fp1J5mG4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 94/94] net: seeq: Fix the function used to release some memory in an error handling path
Date:   Wed,  4 Sep 2019 11:57:39 -0400
Message-Id: <20190904155739.2816-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e1e54ec7fb55501c33b117c111cb0a045b8eded2 ]

In commit 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv"),
a call to 'get_zeroed_page()' has been turned into a call to
'dma_alloc_coherent()'. Only the remove function has been updated to turn
the corresponding 'free_page()' into 'dma_free_attrs()'.
The error hndling path of the probe function has not been updated.

Fix it now.

Rename the corresponding label to something more in line.

Fixes: 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/seeq/sgiseeq.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index 7a5e6c5abb57b..276c7cae7ceeb 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -794,15 +794,16 @@ static int sgiseeq_probe(struct platform_device *pdev)
 		printk(KERN_ERR "Sgiseeq: Cannot register net device, "
 		       "aborting.\n");
 		err = -ENODEV;
-		goto err_out_free_page;
+		goto err_out_free_attrs;
 	}
 
 	printk(KERN_INFO "%s: %s %pM\n", dev->name, sgiseeqstr, dev->dev_addr);
 
 	return 0;
 
-err_out_free_page:
-	free_page((unsigned long) sp->srings);
+err_out_free_attrs:
+	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
 err_out_free_dev:
 	free_netdev(dev);
 
-- 
2.20.1

