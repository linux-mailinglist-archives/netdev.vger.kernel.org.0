Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3ACB695D3
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbfGOPA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 11:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387719AbfGOOPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:15:08 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF5E721530;
        Mon, 15 Jul 2019 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200107;
        bh=BjOl+J090RIzEtaT3kR8G4TlYxlA1Brk2oMem9nGmQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMRRODilxg5QzSqMGoqYyvYnLPipHfXpO6Rcvz68qlrSmP0Ggal9Irs/y6x2j9EF5
         +n/5Iv+VMIDKD4T5pk4JPO1U1domJPvZImsmql9kcaCHI3X0LzZ0fHb9ue1rcULOLd
         Es83e3P+v4AZ2fJBq1X5EtjzuWhCFcn0XAXwiUV4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 185/219] bnxt_en: Disable bus master during PCI shutdown and driver unload.
Date:   Mon, 15 Jul 2019 10:03:06 -0400
Message-Id: <20190715140341.6443-185-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
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
index 30cafe4cdb6e..bf1fd513fa02 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10165,10 +10165,10 @@ static void bnxt_remove_one(struct pci_dev *pdev)
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
@@ -10730,6 +10730,7 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 
 	if (system_state == SYSTEM_POWER_OFF) {
 		bnxt_clear_int_mode(bp);
+		pci_disable_device(pdev);
 		pci_wake_from_d3(pdev, bp->wol);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
-- 
2.20.1

