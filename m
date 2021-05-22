Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CE938D4EC
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 11:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhEVJw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 05:52:26 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:27346 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhEVJw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 05:52:26 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d40 with ME
        id 7lqu2500J21Fzsu03lqumV; Sat, 22 May 2021 11:51:00 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 22 May 2021 11:51:00 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        bperumal@codeaurora.org, akolli@codeaurora.org,
        milehu@codeaurora.org, lkp@intel.com
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ath11k: Fix an error handling path in 'ath11k_core_fetch_board_data_api_n()'
Date:   Sat, 22 May 2021 11:50:54 +0200
Message-Id: <e959eb544f3cb04258507d8e25a6f12eab126bde.1621676864.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All error paths but this one 'goto err' in order to release some
resources.
Fix this.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ath/ath11k/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 77ce3347ab86..595e83fe0990 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -488,7 +488,8 @@ static int ath11k_core_fetch_board_data_api_n(struct ath11k_base *ab,
 		if (len < ALIGN(ie_len, 4)) {
 			ath11k_err(ab, "invalid length for board ie_id %d ie_len %zu len %zu\n",
 				   ie_id, ie_len, len);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err;
 		}
 
 		switch (ie_id) {
-- 
2.30.2

