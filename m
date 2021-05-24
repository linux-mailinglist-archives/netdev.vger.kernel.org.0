Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF9B38E99A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhEXOt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233226AbhEXOsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C32F5613EE;
        Mon, 24 May 2021 14:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867631;
        bh=HJ7qAgUp3pfDTGdMoTByNj0yMeZBO441FzbToT+maD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJfEpFPYx8x2dSmwIRSfr8qHqT+HSQ00UQWK912LAoj9DnBWQgyX5Hv8Yue7CiVhG
         qWgfuhwzl+Pp5Qbokz+WvWyhy5l/659h7OITHIxOPAgSNZtfcMu2X+GLk34ZVCG0ZI
         GlDMdRWPaSz5D5BQ/lKBMvmBBeoK4UrAVFwL2T4IUl27yALY1nnyT152dmGjWbWzap
         9MHoPaASRISFOLKzaTWy275xGb87OoA+4o+aNA8WTLZqwy6Ty7c4owUA20Au/6eMlo
         9zlVsxDF4+2FtfYHT2zMBhd/klWa8ksfOvP0CSrxDQbQ6CdaTsqg4kmIxGmFUsg3Oh
         +tlhGBeQ+QWig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 39/63] Revert "net: liquidio: fix a NULL pointer dereference"
Date:   Mon, 24 May 2021 10:45:56 -0400
Message-Id: <20210524144620.2497249-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index 7c5af4beedc6..6fa570068648 100644
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

