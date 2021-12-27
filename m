Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9F3480285
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 17:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhL0Q6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 11:58:17 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:64709 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhL0Q6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 11:58:17 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 1tK8nHljvHQrl1tK9nV4EA; Mon, 27 Dec 2021 17:58:14 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 27 Dec 2021 17:58:14 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ath: dfs_pattern_detector: Avoid open coded arithmetic in memory allocation
Date:   Mon, 27 Dec 2021 17:58:10 +0100
Message-Id: <0fbcd32a0384ac1f87c5a3549e505e4becc60226.1640624216.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmalloc_array()/kcalloc() should be used to avoid potential overflow when
a multiplication is needed to compute the size of the requested memory.

kmalloc_array() can be used here instead of kcalloc() because the array is
fully initialized in the next 'for' loop.

Finally, 'cd->detectors' is defined as 'struct pri_detector **detectors;'.
So 'cd->detectors' and '*cd->detectors' are both some pointer.
So use a more logical 'sizeof(*cd->detectors)'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 75cb53a3ec15..27f4d74a41c8 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -197,7 +197,7 @@ static void channel_detector_exit(struct dfs_pattern_detector *dpd,
 static struct channel_detector *
 channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
 {
-	u32 sz, i;
+	u32 i;
 	struct channel_detector *cd;
 
 	cd = kmalloc(sizeof(*cd), GFP_ATOMIC);
@@ -206,8 +206,8 @@ channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
 
 	INIT_LIST_HEAD(&cd->head);
 	cd->freq = freq;
-	sz = sizeof(cd->detectors) * dpd->num_radar_types;
-	cd->detectors = kzalloc(sz, GFP_ATOMIC);
+	cd->detectors = kmalloc_array(dpd->num_radar_types,
+				      sizeof(*cd->detectors), GFP_ATOMIC);
 	if (cd->detectors == NULL)
 		goto fail;
 
-- 
2.32.0

