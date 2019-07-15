Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC8968D9D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733144AbfGOOAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387410AbfGON75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:59:57 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4418B212F5;
        Mon, 15 Jul 2019 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199196;
        bh=Y89c70ExzTxcWGPHXa29Z8C41o1QTD76E423cWYFRAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjQFbG1Q6sViSnzlcj1FctjtncsdyjRc6FoeYgZpY8Ig1yHKLey5i+Hp/jeqWmJTo
         2hgWSpgq6hPYZIcatGJ0JKkSOs2ZSa1YERaSjtcWN2XGzFgsnrRuHSeTW4rjWWnzFz
         i/fAERhKooudTYoXIhGR4RArJ7u2XUge0XNoOdDo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 212/249] bnxt_en: Disable bus master during PCI shutdown and driver unload.
Date:   Mon, 15 Jul 2019 09:46:17 -0400
Message-Id: <20190715134655.4076-212-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit c20dc142dd7b2884b8570eeab323bcd4a84294fa ]

Some chips with older firmware can continue to perform DMA read from
context memory even after the memory has been freed.  In the PCI shutdown
method, we need to call pci_disable_device() to shutdown DMA to prevent
this DMA before we put the device into D3hot.  DMA memory request in
D3hot state will generate PCI fatal error.  Similarly, in the driver
remove method, the context memory should only be freed after DMA has
been shutdown for correctness.

Fixes: 98f04cf0f1fc ("bnxt_en: Check context memory requirements from firmware.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f758b2e0591f..b9bc829aa9da 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10262,10 +10262,10 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_dcb_free(bp);
 	kfree(bp->edev);
 	bp->edev = NULL;
+	bnxt_cleanup_pci(bp);
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
-	bnxt_cleanup_pci(bp);
 	bnxt_free_port_stats(bp);
 	free_netdev(dev);
 }
@@ -10859,6 +10859,7 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 
 	if (system_state == SYSTEM_POWER_OFF) {
 		bnxt_clear_int_mode(bp);
+		pci_disable_device(pdev);
 		pci_wake_from_d3(pdev, bp->wol);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
-- 
2.20.1

