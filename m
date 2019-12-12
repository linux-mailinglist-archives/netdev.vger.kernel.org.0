Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F38911D750
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfLLTm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:42:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33151 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbfLLTm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:42:57 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1ifUMN-0002lk-QV; Thu, 12 Dec 2019 19:42:51 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        John Crispin <john@phrozen.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath11k: fix missing free of skb on error return path
Date:   Thu, 12 Dec 2019 19:42:51 +0000
Message-Id: <20191212194251.108343-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error handling when the call to ath11k_hal_srng_get_entrysize fails
leaks skb, fix this by returning via the err_free return path that will
ensure the skb is free'd.

Addresses-Coverity: ("Resource leak")
Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index a8b9557c2346..7123a4fc4635 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -645,8 +645,10 @@ int ath11k_dp_tx_htt_srng_setup(struct ath11k_base *ab, u32 ring_id,
 				 HAL_ADDR_MSB_REG_SHIFT;
 
 	ret = ath11k_hal_srng_get_entrysize(ring_type);
-	if (ret < 0)
-		return -EINVAL;
+	if (ret < 0) {
+		ret = -EINVAL;
+		goto err_free;
+	}
 
 	ring_entry_sz = ret;
 
-- 
2.24.0

