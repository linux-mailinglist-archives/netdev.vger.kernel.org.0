Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17403128F1
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 03:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBHC1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 21:27:48 -0500
Received: from m12-16.163.com ([220.181.12.16]:34658 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBHC1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 21:27:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=3HDPhqmHgPvzBuo5bl
        I2uMvrIMia8BZyw9nwfQ+vqKI=; b=Y4ota/G6yNF4/LUE1s52Kq4wpCSuEi4eTD
        0r68GOs2swLcQxe5vJ7hnpY/T6FKrRMn6uv9bIHf5zi+Emry9vpRC6oVHxyjHgbq
        9kIZGIYAxaOU8f+bhdiyBy3jGPKgBqNraDbi8JO6ncEjtsAhi+oa8PW51wq1JgYk
        HxcZPZRPk=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.53.134])
        by smtp12 (Coremail) with SMTP id EMCowAAnK08goSBgmyBxbA--.45753S2;
        Mon, 08 Feb 2021 10:25:37 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        lee.jones@linaro.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH RESEND] wl1251: cmd: remove redundant assignment
Date:   Mon,  8 Feb 2021 10:25:35 +0800
Message-Id: <20210208022535.17672-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EMCowAAnK08goSBgmyBxbA--.45753S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF45uw15ArW5AFW8tF1DKFg_yoW5Jw13pF
        93u347tr98tr1UXrWrZw4kZa9ag3W8JrW7GrWDu34qqF1ayr4FkrZ0gFy09F98ua9YyrW3
        tFZ0gF4rWF1DCFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jtBMtUUUUU=
X-Originating-IP: [119.137.53.134]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiHQIzsVSIpToLCwAAse
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

-ENOMEM has been used as a return value,it is not necessary to
assign it, and if kzalloc fail,not need free it,so just return
-ENOMEM when kzalloc fail.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/ti/wl1251/cmd.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index e1095b8..498c8db 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -175,10 +175,8 @@ int wl1251_cmd_vbm(struct wl1251 *wl, u8 identity,
 	wl1251_debug(DEBUG_CMD, "cmd vbm");
 
 	vbm = kzalloc(sizeof(*vbm), GFP_KERNEL);
-	if (!vbm) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!vbm)
+		return -ENOMEM;
 
 	/* Count and period will be filled by the target */
 	vbm->tim.bitmap_ctrl = bitmap_control;
@@ -213,10 +211,8 @@ int wl1251_cmd_data_path_rx(struct wl1251 *wl, u8 channel, bool enable)
 	wl1251_debug(DEBUG_CMD, "cmd data path");
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!cmd)
+		return -ENOMEM;
 
 	cmd->channel = channel;
 
@@ -279,10 +275,8 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 	u8 *bssid;
 
 	join = kzalloc(sizeof(*join), GFP_KERNEL);
-	if (!join) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!join)
+		return -ENOMEM;
 
 	wl1251_debug(DEBUG_CMD, "cmd join%s ch %d %d/%d",
 		     bss_type == BSS_TYPE_IBSS ? " ibss" : "",
@@ -324,10 +318,8 @@ int wl1251_cmd_ps_mode(struct wl1251 *wl, u8 ps_mode)
 	wl1251_debug(DEBUG_CMD, "cmd set ps mode");
 
 	ps_params = kzalloc(sizeof(*ps_params), GFP_KERNEL);
-	if (!ps_params) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!ps_params)
+		return -ENOMEM;
 
 	ps_params->ps_mode = ps_mode;
 	ps_params->send_null_data = 1;
@@ -356,10 +348,8 @@ int wl1251_cmd_read_memory(struct wl1251 *wl, u32 addr, void *answer,
 	wl1251_debug(DEBUG_CMD, "cmd read memory");
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!cmd)
+		return -ENOMEM;
 
 	WARN_ON(len > MAX_READ_SIZE);
 	len = min_t(size_t, len, MAX_READ_SIZE);
@@ -401,10 +391,8 @@ int wl1251_cmd_template_set(struct wl1251 *wl, u16 cmd_id,
 	cmd_len = ALIGN(sizeof(*cmd) + buf_len, 4);
 
 	cmd = kzalloc(cmd_len, GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!cmd)
+		return -ENOMEM;
 
 	cmd->size = cpu_to_le16(buf_len);
 
-- 
1.9.1


