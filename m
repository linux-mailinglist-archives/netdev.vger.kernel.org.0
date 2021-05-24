Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FC138EB1E
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbhEXPAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233430AbhEXO6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 822D461457;
        Mon, 24 May 2021 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867766;
        bh=VB4Y1FojBfYAa5ucDtj+uTAZT4JTj8xqxuUainiCfUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1nw9k8/QWd79pgRSstpwteFBiJg5X0gJYN8CLKf+8ceHdkMEO4ZwTUKeRTUPVYTV
         8Q5EvcsPj7oC7kR/p11ucZrPI8+BspfjR2j25oKysA1U3Wz+KoVKDAgPQhRTfbryA8
         om2k/aTDNhp0z3p/ZCyiYxNBWBFmCV8LS6An+xW2Qom/sE/OmCLtVpwEfpxBQ/SNJq
         HvJrBvzPpg/M6Zaco7d/9gPD7xa/H9hd2zUKg8+k/1P7+5MfZLeXYFAB8pciM8Zw/j
         YdKJ5AsXaL6CVV8SI5QhAFzNeN1FfT0sVk5BlK8t9pvyvH5cauMRysE1ZSH6PLaZOF
         lULan/8T1Z4CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/52] ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()
Date:   Mon, 24 May 2021 10:48:29 -0400
Message-Id: <20210524144903.2498518-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit 54433367840b46a1555c8ed36c4c0cfc5dbf1358 ]

Propagate error code from failure of ath6kl_wmi_cmd_send() to the
caller.

Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-44-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/debug.c | 5 ++++-
 drivers/net/wireless/ath/ath6kl/wmi.c   | 4 +---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 54337d60f288..085a134069f7 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1027,14 +1027,17 @@ static ssize_t ath6kl_lrssi_roam_write(struct file *file,
 {
 	struct ath6kl *ar = file->private_data;
 	unsigned long lrssi_roam_threshold;
+	int ret;
 
 	if (kstrtoul_from_user(user_buf, count, 0, &lrssi_roam_threshold))
 		return -EINVAL;
 
 	ar->lrssi_roam_threshold = lrssi_roam_threshold;
 
-	ath6kl_wmi_set_roam_lrssi_cmd(ar->wmi, ar->lrssi_roam_threshold);
+	ret = ath6kl_wmi_set_roam_lrssi_cmd(ar->wmi, ar->lrssi_roam_threshold);
 
+	if (ret)
+		return ret;
 	return count;
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index d27b4088b874..c610fe21c85c 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -776,10 +776,8 @@ int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi)
 	cmd->info.params.roam_rssi_floor = DEF_LRSSI_ROAM_FLOOR;
 	cmd->roam_ctrl = WMI_SET_LRSSI_SCAN_PARAMS;
 
-	ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
+	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
 			    NO_SYNC_WMIFLAG);
-
-	return 0;
 }
 
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
-- 
2.30.2

