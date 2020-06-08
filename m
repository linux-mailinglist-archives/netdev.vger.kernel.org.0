Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688E91F2FE1
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731537AbgFIAy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbgFHXJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2562C208FE;
        Mon,  8 Jun 2020 23:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657773;
        bh=IAdVph0fG5ogOIukRAnscPJyX0P9LSD/fmItIjoQA6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQfSHCDrQL6b7JgP2w1D5u+3u7UgUrMstqS62Z4xg44YjmKC5ZjZPrtG5Ku8vC8Ny
         3dxmczQP6TeUeou2TXLtHMSFMDBvtWg8ZCpQ4ucEB1GOhrPbBWzDdvyd+Ae2rtQnO7
         Y+KJMyk2Kp4NhQO4mPQsx9TKzRo6mys1w6JShqPw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 156/274] ath10k: fix possible memory leak in ath10k_bmi_lz_data_large()
Date:   Mon,  8 Jun 2020 19:04:09 -0400
Message-Id: <20200608230607.3361041-156-sashal@kernel.org>
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

[ Upstream commit 2326aa011967f0afbcba7fe1a005d01f8b12900b ]

'cmd' is malloced in ath10k_bmi_lz_data_large() and should be freed
before leaving from the error handling cases, otherwise it will cause
memory leak.

Fixes: d58f466a5dee ("ath10k: add large size for BMI download data for SDIO")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200427104348.13570-1-weiyongjun1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/bmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
index ea908107581d..5b6db6e66f65 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.c
+++ b/drivers/net/wireless/ath/ath10k/bmi.c
@@ -380,6 +380,7 @@ static int ath10k_bmi_lz_data_large(struct ath10k *ar, const void *buffer, u32 l
 						  NULL, NULL);
 		if (ret) {
 			ath10k_warn(ar, "unable to write to the device\n");
+			kfree(cmd);
 			return ret;
 		}
 
-- 
2.25.1

