Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEBDC5E8F3
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfGCQ3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:29:43 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46825 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfGCQ3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:29:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id i8so1488474pgm.13;
        Wed, 03 Jul 2019 09:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dSl0J6l/7YvXHcRbb+oMFogCJ9HH7sc8QAmK2O6dBSo=;
        b=YVkfUN0gNf88gD0DYqkZLrcIjxUWVIcAXb5lOEWon1hPzSx4FCZic+AOzgVlVRC25L
         QAOOL5/UsBbRpHFrfpVjHrs4gUBiaYJK6Vo9yzhzpSAZ1RQqx0tGwoWQYJl4hBdj+Sxl
         RFvvr1y5ZnZ+FlykOm35Na2mQBCWJHRtEehpDvHwuK8xZVf639WtdS7aWpr0WzmnZyhx
         QyxQiJESGKXQpkcbYnhfhXCEVZmgbnsYbPHpIYA/mISmJHM/KrNN9n4cJDK+EmnALfjW
         CRifKP6/yeukUIZT7iEJ1+gCGHd/PzHaUVDhJ8AP3LO53TtNRt7KUbezaBC/bPKONxfy
         HAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dSl0J6l/7YvXHcRbb+oMFogCJ9HH7sc8QAmK2O6dBSo=;
        b=c1R6QRuN7WqOcPh62doOGuDd2rcfj1k72gOGivgP1z5j1jsjliSo375n+9WaZ2bI+Z
         i4YSu2mrSjYEpEPsZAc3llke02O49QOUNc3lUaO5VTNZZqyiXkGbf0FhubS8p5AbIuYZ
         LE6GFRf/lSe+reKXcTEhbehZl80VsHq6wwjU8RKWgLcUmsaQkGtQbo2ZvRJ26BrMSNJO
         UdiwGJaR+s+ZBCSqOCH5OssHd26gwfWQf/M6lL8EcTlEddi9nj2a/K1hf6qFUKqQgEZj
         RwGB2OCu52k8cmGyT9+CM8kd5f9Kqmp+gnFe0bqYQ4Wfcs9lPnQKxPVvBAf+Nj/220TT
         Xrsw==
X-Gm-Message-State: APjAAAVtD6tIhYf40SY2JaErv0gj/NH8tkDySjdatpasch9l4KL2cKYI
        rwelaa+pGPM5cQpjLx/caQGj7Qp/fU8=
X-Google-Smtp-Source: APXvYqz/LfWOz9+cDE+wkN6u4LE4y+yGtk/tjQgkZBy64KYdrbk5QpuX8VZPCcE9jGSKJ9ZD7FxvRw==
X-Received: by 2002:a65:530c:: with SMTP id m12mr38409055pgq.363.1562171382468;
        Wed, 03 Jul 2019 09:29:42 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id q126sm4894175pfq.123.2019.07.03.09.29.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:29:42 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Solomon Peachy <pizza@shaftnet.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2 17/35] net/wireless: Use kmemdup rather than duplicating its implementation
Date:   Thu,  4 Jul 2019 00:29:34 +0800
Message-Id: <20190703162934.32645-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Fix a typo in commit message (memset -> memcpy)

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

