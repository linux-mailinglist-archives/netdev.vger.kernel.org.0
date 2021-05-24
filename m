Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FB838EA83
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhEXO4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhEXOyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:54:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8789661428;
        Mon, 24 May 2021 14:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867712;
        bh=IoHREpO8T5t2jYw8sNsJ9hikV2tRTqlyPUYv5iO8hbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQKLiiimKyjLrhK0aKSskYAJVPuAY5oHnHBJWJBFEy3rhiYoiRyAxoGGkYsavuTiS
         0o0PQT86UKnRBengDUJsxBj6atpA6UyFKdzbOZc24y30KjUDy2nBG+Jx2Z4YsnaXqs
         eaw7VPJ1i2VcjKYy/Rq1k9T4QMUL7doByprY72U1HJUfY0Zb0vCrIojyuP7juC3vkj
         zrkFEeg+9XthfOCisc+QotHfCED+5prbN1K/mQb54uxC49NffL1JcmqnWyO7JDgtMU
         RjkhzXhP46w/FEqW1SrT4sJ7/BlGVuKHSJmCNj6FKN1LDmcjIelU2H5E70PEk3+Upk
         kDsEkh1l9QFZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/62] Revert "net: liquidio: fix a NULL pointer dereference"
Date:   Mon, 24 May 2021 10:47:20 -0400
Message-Id: <20210524144744.2497894-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 4fd798a5a89114c1892574c50f2aebd49bc5b4f5 ]

This reverts commit fe543b2f174f34a7a751aa08b334fe6b105c4569.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

While the original commit does keep the immediate "NULL dereference"
from happening, it does not properly propagate the error back to the
callers, AND it does not fix this same identical issue in the
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c for some reason.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-65-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7d00d3a8ded4..e4c220f30040 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1166,11 +1166,6 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 	sc = (struct octeon_soft_command *)
 		octeon_alloc_soft_command(oct, OCTNET_CMD_SIZE,
 					  16, 0);
-	if (!sc) {
-		netif_info(lio, rx_err, lio->netdev,
-			   "Failed to allocate octeon_soft_command\n");
-		return;
-	}
 
 	ncmd = (union octnet_cmd *)sc->virtdptr;
 
-- 
2.30.2

