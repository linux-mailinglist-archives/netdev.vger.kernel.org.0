Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AEA38EBC0
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhEXPHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234665AbhEXPEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 11:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD9166161E;
        Mon, 24 May 2021 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867850;
        bh=vRVKd8aP6MEZC8gUSh+RA2V/eOJAldxLD22c3ZLJy8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSFRJJE3lcJjJnbY5V1F2okWnaXN8C+68HuDsEhgbb+7Kv8Mpzh290LtIG9d6Q5Df
         R1swR6qlo3n02lyvQk2yHYf5M0R3KLeIQGrGIr1oZDa50vfWo+BLSUmxMBCyDuYB+o
         qY7FH16w6b1bCzMWuQowU5dVhpjwQYpTqn/KWrCQn2Hl3bHCl0TT8SxbfOC5O3a8um
         JdDO30pHxlI3ka1pxldXmHLXkGqDF8VaUvTJsa/2lOhjF4ThUER3n3xStEeVVqtaei
         sU/XdgOQB2r7MDZJkKBS6Ti8w+ZBcDD6zxmzgH38mMXnM+XDXu+0emo2RDdJsmQUZJ
         lxIgbpk1/OWyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>, Kangjie Lu <kjlu@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/21] ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()
Date:   Mon, 24 May 2021 10:50:27 -0400
Message-Id: <20210524145040.2499322-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145040.2499322-1-sashal@kernel.org>
References: <20210524145040.2499322-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit fc6a6521556c8250e356ddc6a3f2391aa62dc976 ]

ath6kl_wmi_cmd_send could fail, so let's return its error code upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/debug.c | 5 ++++-
 drivers/net/wireless/ath/ath6kl/wmi.c   | 4 +---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 1eea6c23976f..19b005cc8b00 100644
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
index f80f1757b58f..9deaeb72b2b4 100644
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

