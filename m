Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F3138EB5A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhEXPCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234429AbhEXO7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4DF5613F2;
        Mon, 24 May 2021 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867787;
        bh=W4hzXqoHG/3EjJjFlzLnc/9WzCpZO4RrGgLy7YdQrX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOTX0yx8NOHJn2xLGeeQbkx84lxYG6j9jCF1Z2YtGexhQ/grtXKeIgok2l69GMnlE
         DkqriWrHX/LbguiWe238Lw6UYoplXHnjMRks81aYo+SudHbI23vjGpGTPjRSzVBXcB
         YxcsUVBW0ac1p79jGStrLfEFrQDMJfM5oTgxNQYSKbbj3wjMkz1DwuFxH0H/OMBF44
         F9inGiMLHSgoupkldf6bshrd/ysz8WWsKq4xVi+wpsW+t06Zfi3yNCkcbX6VsNpqyN
         zBJGHgrQsF+52Qxs7Qyqro8t9iQIPPKqMIknW4aTNOR2WvWgY82AI570CumtvWAl46
         yZjrYtV8G4+VQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 36/52] Revert "net: liquidio: fix a NULL pointer dereference"
Date:   Mon, 24 May 2021 10:48:46 -0400
Message-Id: <20210524144903.2498518-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
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
index 7f3b2e3b0868..f2d486583e2f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1192,11 +1192,6 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
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

