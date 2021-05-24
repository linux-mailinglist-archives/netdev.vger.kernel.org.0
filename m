Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094EE38E947
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhEXOsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233218AbhEXOsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 404CB613D0;
        Mon, 24 May 2021 14:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867608;
        bh=o2UOksS0HVOeLjuz84GvooEFiCHXaNV0PYRXLcFFWmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JF7trAxPLVnpcHbB1zV0ZLT7UJ3+Zygc0fF2X6ZaZqDp9P1oX2PnmpPLEta3jk3iS
         B1T6mCE3wV7swp4aW91uAdOnOuUyfHF7t6vHTckQRSJe+mbWDJscnpa+vKm6lM2Hlk
         RBfWGI/GWlTioqh6/D9EmQdyue2vBL5G2Anmucb8joiCA7oKtyimKlVxA62BdoVXjN
         V+5gSUPCCp7DwLi/lltVYODbnZ5VXmlHfdoSEkQC2aaFDPYVRPD//WTwu7Gi9jY2J/
         SMk7DMHyuXz5MY59Omsg6xJPfUoy4SUTsGbTXQFyGKa94EzEf2DM/tnmfM5YFgZ6DV
         9/1mN5ww1XJCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 21/63] Revert "ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()"
Date:   Mon, 24 May 2021 10:45:38 -0400
Message-Id: <20210524144620.2497249-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
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
index b137e7f34397..aca9732ec1ee 100644
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

