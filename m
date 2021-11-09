Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8D744A314
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhKIBZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243073AbhKIBTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:19:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F38BD61350;
        Tue,  9 Nov 2021 01:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420049;
        bh=AEtsryqMgiz7txJQbTtIKhhazF22c3vMUYB4VyAzqyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQNL6PTGNxahHY22RsVD2Ah4XOaEXbVnK64rqOjRIeJZ9tDYBC3JK22d+42Nq4LWE
         8p2v6jF1Qbn/X+JqS0tTZ+wmQc6ATjCu8/bC8hpU+g8A8ULR1/rQEKSOyT8Ufmn2Dy
         piTiE/bpwzvhGVwTFRVoaSBmDeNE4Zi4mS3yTbqul77f4IWg/FHW3LoAzY8MbXAb4w
         R+TiJ2hAs37ytuofTioeESCQjNf5ANtOL7zmoTunXdipL9sr1hYVsCUAdgGTwmNEFO
         mgwyyXvdwFZtspyZjxBahHn9QDxhn1xnTX6NaZs2POOH1ocy7gIaDKEW03h/J0Zj99
         sy22wvR2agk0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 22/39] ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()
Date:   Mon,  8 Nov 2021 20:06:32 -0500
Message-Id: <20211109010649.1191041-22-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 4b6012a7830b813799a7faf40daa02a837e0fd5b ]

kzalloc() is used to allocate memory for cd->detectors, and if it fails,
channel_detector_exit() behind the label fail will be called:
  channel_detector_exit(dpd, cd);

In channel_detector_exit(), cd->detectors is dereferenced through:
  struct pri_detector *de = cd->detectors[i];

To fix this possible null-pointer dereference, check cd->detectors before
the for loop to dereference cd->detectors.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210805153854.154066-1-islituo@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 78146607f16e8..acd85e5069346 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -182,10 +182,12 @@ static void channel_detector_exit(struct dfs_pattern_detector *dpd,
 	if (cd == NULL)
 		return;
 	list_del(&cd->head);
-	for (i = 0; i < dpd->num_radar_types; i++) {
-		struct pri_detector *de = cd->detectors[i];
-		if (de != NULL)
-			de->exit(de);
+	if (cd->detectors) {
+		for (i = 0; i < dpd->num_radar_types; i++) {
+			struct pri_detector *de = cd->detectors[i];
+			if (de != NULL)
+				de->exit(de);
+		}
 	}
 	kfree(cd->detectors);
 	kfree(cd);
-- 
2.33.0

