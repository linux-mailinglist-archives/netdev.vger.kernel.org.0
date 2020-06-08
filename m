Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC4F1F2FD4
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgFHXJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728158AbgFHXJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 613BF208A9;
        Mon,  8 Jun 2020 23:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657774;
        bh=0kTjp2ybDUM0ctaeDR3fOgYBPE7QHYAKia5yuuniklk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qaCIio5yiI8x6cdUsoS2EKA9TBu/7diQy425MnvghBzAaymzwJ9qDsKF4s0KA19S6
         6c4MflzThtnDIZWVTGaatFToMIJoXaBJFpvYT2j3VmJwaTgJrVH4WhqHNzA1UbkkJe
         pXADBhIcgKvLEl8RcFXG0SX361g611OVssyPwqlM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 157/274] ath11k: fix error return code in ath11k_dp_alloc()
Date:   Mon,  8 Jun 2020 19:04:10 -0400
Message-Id: <20200608230607.3361041-157-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit f76f750aeea47fd98b6502eb6d37f84ca33662bf ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: d0998eb84ed3 ("ath11k: optimise ath11k_dp_tx_completion_handler")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200427104621.23752-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index 50350f77b309..2f35d325f7a5 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -909,8 +909,10 @@ int ath11k_dp_alloc(struct ath11k_base *ab)
 		dp->tx_ring[i].tx_status_head = 0;
 		dp->tx_ring[i].tx_status_tail = DP_TX_COMP_RING_SIZE - 1;
 		dp->tx_ring[i].tx_status = kmalloc(size, GFP_KERNEL);
-		if (!dp->tx_ring[i].tx_status)
+		if (!dp->tx_ring[i].tx_status) {
+			ret = -ENOMEM;
 			goto fail_cmn_srng_cleanup;
+		}
 	}
 
 	for (i = 0; i < HAL_DSCP_TID_MAP_TBL_NUM_ENTRIES_MAX; i++)
-- 
2.25.1

