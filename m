Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8A538EB1A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhEXPAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233044AbhEXO6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3318161455;
        Mon, 24 May 2021 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867765;
        bh=CaRJbwEvVyUIgOBqZyWjNDLt31TvcBOvLoCPxtKykGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkuNUO1UZ/d/4w4VxG31JWCJPQs7Pe8RIeV+Z6xZsEB6q3HNUR9q3Q9sQpKoe2TGa
         WgdL/UVyZMqpELZl/dBw8ey6PhPgWGiugTfiK4GGKXHe1QKPHXKCCv609pfvA3ZmPG
         PBDmsVANbqBCpcV/TC/ANFf2TCrRZ5m7OihfCpQibo84pVSPC0Bb7kgsfo1/wRuoX2
         ROW+aONneKMLV+k2I+kXi6w/5FRcydpjV1MMNqLsrP5oKIiGmyPp5iCGY3C/4levsd
         EdyKNA7Uvk9KihqQ+OqWZkoRWNxHQBaMygu1xmnYfQrlAUfN9HyGNyXmzpN4dxO+ud
         x984KTzSoW7bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 18/52] Revert "ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()"
Date:   Mon, 24 May 2021 10:48:28 -0400
Message-Id: <20210524144903.2498518-18-sashal@kernel.org>
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
index c610fe21c85c..d27b4088b874 100644
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

