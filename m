Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452C95F9105
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiJIWaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbiJIW0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:26:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7E32E680;
        Sun,  9 Oct 2022 15:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACB65B80DF2;
        Sun,  9 Oct 2022 22:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12165C43470;
        Sun,  9 Oct 2022 22:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353839;
        bh=KwB7yzHmIKvJrXcnQgncUVi1felkVMXMpemxmBu6DsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPWuCQqy72llXWMyJroxGjmJzSad0AEr4tMHVmlZ72xVH/OgBBmMi4z+nFX1CYE2H
         NruRMbEn4ZOYgbVP2uRD4YYT1quSTepBfE/q4JAmF9xBN4k56lXedsVSaZuorTOVoC
         vmVi5W5stwUt6GOHOLeN6bjoeH5F79S4vnAdFX4jT2xNJiF/LtzeNQkc5/1ZAW8BPL
         y0NkskhT4tJTwNcvRPg13G9wrQL5vapBirQb0zTXVxi5UcCFvg//MotV/3c1fmAogA
         geLvYdholrR5FyeX9IaSNGyTftJB0u3vtdaHGtDT1hCMvQw2bBeyUIlhaYJAHe8z1O
         FvZtHovFX2LBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 37/73] wifi: ath11k: mhi: fix potential memory leak in ath11k_mhi_register()
Date:   Sun,  9 Oct 2022 18:14:15 -0400
Message-Id: <20221009221453.1216158-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 43e7c3505ec70db3d3c6458824d5fa40f62e3e7b ]

mhi_alloc_controller() allocates a memory space for mhi_ctrl. When gets
some error, mhi_ctrl should be freed with mhi_free_controller(). But
when ath11k_mhi_read_addr_from_dt() fails, the function returns without
calling mhi_free_controller(), which will lead to a memory leak.

We can fix it by calling mhi_free_controller() when
ath11k_mhi_read_addr_from_dt() fails.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220907073704.58806-1-niejianglei2021@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index c44df17719f6..86995e8dc913 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -402,8 +402,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 	ret = ath11k_mhi_get_msi(ab_pci);
 	if (ret) {
 		ath11k_err(ab, "failed to get msi for mhi\n");
-		mhi_free_controller(mhi_ctrl);
-		return ret;
+		goto free_controller;
 	}
 
 	if (!test_bit(ATH11K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
@@ -412,7 +411,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 	if (test_bit(ATH11K_FLAG_FIXED_MEM_RGN, &ab->dev_flags)) {
 		ret = ath11k_mhi_read_addr_from_dt(mhi_ctrl);
 		if (ret < 0)
-			return ret;
+			goto free_controller;
 	} else {
 		mhi_ctrl->iova_start = 0;
 		mhi_ctrl->iova_stop = 0xFFFFFFFF;
@@ -440,18 +439,22 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 	default:
 		ath11k_err(ab, "failed assign mhi_config for unknown hw rev %d\n",
 			   ab->hw_rev);
-		mhi_free_controller(mhi_ctrl);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto free_controller;
 	}
 
 	ret = mhi_register_controller(mhi_ctrl, ath11k_mhi_config);
 	if (ret) {
 		ath11k_err(ab, "failed to register to mhi bus, err = %d\n", ret);
-		mhi_free_controller(mhi_ctrl);
-		return ret;
+		goto free_controller;
 	}
 
 	return 0;
+
+free_controller:
+	mhi_free_controller(mhi_ctrl);
+	ab_pci->mhi_ctrl = NULL;
+	return ret;
 }
 
 void ath11k_mhi_unregister(struct ath11k_pci *ab_pci)
-- 
2.35.1

