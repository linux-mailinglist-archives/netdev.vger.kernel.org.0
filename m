Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D160F30D35A
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 07:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhBCGV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 01:21:29 -0500
Received: from m12-12.163.com ([220.181.12.12]:57036 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229605AbhBCGV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 01:21:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=3HDPhqmHgPvzBuo5bl
        I2uMvrIMia8BZyw9nwfQ+vqKI=; b=AZfLJBqPzBheUnjDXrxqNM4FE+WXMURkdC
        f/L4DL1PMLW+qgWyb8VaoeQFb3lgTHK8NGcgr6DlfZVuqdFCxnSqAK8y6EtGh9Ez
        d6/888OzeuviJzYk+evUpMgpT4AwSM8tvizV39Ma/pjmNzvv3yblYsiHWnFx2mUT
        Ru53embXs=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.55.230])
        by smtp8 (Coremail) with SMTP id DMCowAA3Z8+RPBpgAtH1Ow--.718S2;
        Wed, 03 Feb 2021 14:02:58 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] wl1251: cmd: remove redundant assignment
Date:   Wed,  3 Feb 2021 14:03:06 +0800
Message-Id: <20210203060306.2832-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DMCowAA3Z8+RPBpgAtH1Ow--.718S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF45uw15ArW5AFW8tF1DKFg_yoW5Jw13pF
        93u347tr98tr1UXrWrZw4kZa9ag3W8JrW7GrWDu34qqF1ayr4FkrZ0gFy09F98ua9YyrW3
        tFZ0gF4rWF1DCFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jNUUUUUUUU=
X-Originating-IP: [119.137.55.230]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiERIusV7+2suhNQAAs5
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


