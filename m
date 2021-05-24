Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5036F38EA61
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhEXOzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233580AbhEXOwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DD3F61413;
        Mon, 24 May 2021 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867689;
        bh=CYQKF+DdtAEsj/IX896Zmy3CtQSrgoPkEKKP8PgHfr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkBoYd9GTylvMCMCv1F2LJGzz9eyb2mUVAt7cq5CKuDq4gFd1IRgO9MzGBZ/oxpVy
         wSFMtupREH4pO3paYUiHn6CxM+pI3hg9OBhuwEAgI6j5rnJO6aLGF0lO5ekmY68juJ
         NyGjVO677xkt8/B+l7b2zq/tBzjYMR6uMiKCFvDX/b2XaTtfBTSwF3zKbnZ0k5ngsQ
         9qhkNcwmn27l69toobMc7wZ1A+bIyLiKijgcRca/eOpSWELkF7s0AiuOFUp5yC+3ck
         Yt841QN45oYWwwzm2VUEFrqPr87i/Wt0L5tEOSeiCoAUSlzCkHUNGYoynUmZEF6l9P
         6K1AQzstNXROw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 21/62] Revert "ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()"
Date:   Mon, 24 May 2021 10:47:02 -0400
Message-Id: <20210524144744.2497894-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit efba106f89fc6848726716c101f4c84e88720a9c ]

This reverts commit fc6a6521556c8250e356ddc6a3f2391aa62dc976.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The change being reverted does NOTHING as the caller to this function
does not even look at the return value of the call.  So the "claim" that
this fixed an an issue is not true.  It will be fixed up properly in a
future patch by propagating the error up the stack correctly.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-43-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index dbc47702a268..99be0d20f9a5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -776,8 +776,10 @@ int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi)
 	cmd->info.params.roam_rssi_floor = DEF_LRSSI_ROAM_FLOOR;
 	cmd->roam_ctrl = WMI_SET_LRSSI_SCAN_PARAMS;
 
-	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
+	ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
 			    NO_SYNC_WMIFLAG);
+
+	return 0;
 }
 
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
-- 
2.30.2

