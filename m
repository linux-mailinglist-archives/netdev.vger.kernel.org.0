Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A895E51B
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfGCNQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:16:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39778 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCNQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:16:25 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so1246870pls.6;
        Wed, 03 Jul 2019 06:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GiFv2EA+bBdV592muv3lufPOSc1KsSYLwomVffCNWDo=;
        b=YJAvuaA9j9vqhIcsZeIdgHU0kxJGnc9W4CurWahS8IewKSCaYAF01Rs/JX7Jy64o8M
         +2t2fteMA6ib8irWsZRdxL3MYCXdHKqt26fxXbOHczC2aHfcCWy7T6bKJwNS+jAFjNpN
         OZS4tKVSy+xsoLREtTKLe/HP5adxQFQs6u0wt1M/Rvbj467xjQQkv8/eWLp+iOzNmHx8
         tR4ecCGXd/TUB9Hi8zpOVYtpzw81NNmIec4FoeKNcSYTvlqFGNQM5/D92rsAT7idFSkM
         JSUxUdcvoKHD3LpV5iZEjHBvI0eb6RFFSr1JSG4UGlXTk2ibk245qjhPkCK7+q6E7u3K
         Mopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GiFv2EA+bBdV592muv3lufPOSc1KsSYLwomVffCNWDo=;
        b=lBreKHL6Jn/FND86pti3vuZsuB13ICJuf317O5sb3y2Yt/seybOx9vfPsFf+wtwyje
         ZvKQU7PDvNxbpTSXcTmWdzeJoqbPfhtRrHI3pRBGABjPUs+rjElcy9Ko0koP8tz2OCGz
         X+OgELmeDvDUuuleLYQ4KUeNwIqwJfCaV0gTmCCyJ5m/5KSCuhfYlxChPpi36/P4Sj/M
         7HSRfR9Z35Q1hO+WnPP+9nVq1K5Kw13aWHr9P4L/5g/wTAqOk2bH9Q/bRa57Bm/mGDYG
         yaKFns+m/6XZVHoBDm4tuCu30TwJYukezeSQgulcp44U3VBsKGzD7PeSyPXzW19P3ohZ
         uSPA==
X-Gm-Message-State: APjAAAXE3Mcc7ntPkjbDr0Cynknkwa29b132aM9EVKPQJylB6cvXtRl6
        BTs+Noztv98s7dRusNww/0g=
X-Google-Smtp-Source: APXvYqy44KrwCUfsUtsWCLFQ65LRCdYqiAGqWDrtRUHuMDm3r2/A2G7x9DQS0LHIEE9oIcYZsuAVVQ==
X-Received: by 2002:a17:902:42a5:: with SMTP id h34mr43844472pld.16.1562159785038;
        Wed, 03 Jul 2019 06:16:25 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id h14sm2057859pgn.51.2019.07.03.06.16.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 06:16:24 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 16/30] net/wireless: Use kmemdup rather than duplicating its implementation
Date:   Wed,  3 Jul 2019 21:16:14 +0800
Message-Id: <20190703131614.25408-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memset, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memset.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c  | 6 ++----
 drivers/net/wireless/st/cw1200/queue.c | 3 +--
 drivers/net/wireless/ti/wlcore/main.c  | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 68854c45d0a4..7452a0f587fe 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3643,7 +3643,7 @@ static int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id,
 	if (wait)
 		return -EINVAL; /* Offload for wait not supported */
 
-	buf = kmalloc(data_len, GFP_KERNEL);
+	buf = kmemdup(data, data_len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -3654,7 +3654,6 @@ static int ath6kl_wmi_send_action_cmd(struct wmi *wmi, u8 if_idx, u32 id,
 	}
 
 	kfree(wmi->last_mgmt_tx_frame);
-	memcpy(buf, data, data_len);
 	wmi->last_mgmt_tx_frame = buf;
 	wmi->last_mgmt_tx_frame_len = data_len;
 
@@ -3682,7 +3681,7 @@ static int __ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id,
 	if (wait)
 		return -EINVAL; /* Offload for wait not supported */
 
-	buf = kmalloc(data_len, GFP_KERNEL);
+	buf = kmemdup(data, data_len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -3693,7 +3692,6 @@ static int __ath6kl_wmi_send_mgmt_cmd(struct wmi *wmi, u8 if_idx, u32 id,
 	}
 
 	kfree(wmi->last_mgmt_tx_frame);
-	memcpy(buf, data, data_len);
 	wmi->last_mgmt_tx_frame = buf;
 	wmi->last_mgmt_tx_frame_len = data_len;
 
diff --git a/drivers/net/wireless/st/cw1200/queue.c b/drivers/net/wireless/st/cw1200/queue.c
index 14133eedb3b6..12952b1c29df 100644
--- a/drivers/net/wireless/st/cw1200/queue.c
+++ b/drivers/net/wireless/st/cw1200/queue.c
@@ -79,10 +79,9 @@ static void cw1200_queue_register_post_gc(struct list_head *gc_list,
 					  struct cw1200_queue_item *item)
 {
 	struct cw1200_queue_item *gc_item;
-	gc_item = kmalloc(sizeof(struct cw1200_queue_item),
+	gc_item = kmemdup(item, sizeof(struct cw1200_queue_item),
 			GFP_ATOMIC);
 	BUG_ON(!gc_item);
-	memcpy(gc_item, item, sizeof(struct cw1200_queue_item));
 	list_add_tail(&gc_item->head, gc_list);
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c9a485ecee7b..297207856494 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1434,7 +1434,7 @@ int wl1271_rx_filter_alloc_field(struct wl12xx_rx_filter *filter,
 
 	field = &filter->fields[filter->num_fields];
 
-	field->pattern = kzalloc(len, GFP_KERNEL);
+	field->pattern = kmemdup(pattern, len, GFP_KERNEL);
 	if (!field->pattern) {
 		wl1271_warning("Failed to allocate RX filter pattern");
 		return -ENOMEM;
@@ -1445,7 +1445,6 @@ int wl1271_rx_filter_alloc_field(struct wl12xx_rx_filter *filter,
 	field->offset = cpu_to_le16(offset);
 	field->flags = flags;
 	field->len = len;
-	memcpy(field->pattern, pattern, len);
 
 	return 0;
 }
-- 
2.11.0

