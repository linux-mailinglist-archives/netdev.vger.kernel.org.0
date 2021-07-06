Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09AE3BD2E9
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhGFLrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234629AbhGFLgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEB8D61DF0;
        Tue,  6 Jul 2021 11:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570955;
        bh=JVs+USAqbQwyWosver9IEvaSkLoC7t8CAAanoNskeOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQygBGF0aTBi71QHO4d1pjCQeYGUOh6+xbrtUdai9aSPx4Hck3JjwSpKttwblOo0+
         7BG0EEFTWEJrw8J6p/gxl5L7C0rBLzd4bxdbY26OjDANMeyaGD3zrtPLpG3yEFj8kO
         q5CyTKr1XoIBJmAx165MsWID9Ps1ErE0ceTejQq5MiP3zHQqJPJU7vxG1QeUgGU3FL
         ai+sCEeAupqFnViJVfDeCuJTglZ4juFzxrQQZx0lrHAIXjJd48mjVXUypXzd+B8RE+
         EuMlPJ7Z9Y8yLEHiGZUuEhANyIEV52eFrG16aVoNOkGpG2FH3CfMWV/56hAZ9NgDFT
         yIHY3olkJ7Nsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lee Gibson <leegib@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 22/35] wl1251: Fix possible buffer overflow in wl1251_cmd_scan
Date:   Tue,  6 Jul 2021 07:28:34 -0400
Message-Id: <20210706112848.2066036-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lee Gibson <leegib@gmail.com>

[ Upstream commit d10a87a3535cce2b890897914f5d0d83df669c63 ]

Function wl1251_cmd_scan calls memcpy without checking the length.
Harden by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210428115508.25624-1-leegib@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl1251/cmd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index ede31f048ef9..247f4310a38f 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -465,9 +465,12 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 		cmd->channels[i].channel = channels[i]->hw_value;
 	}
 
-	cmd->params.ssid_len = ssid_len;
-	if (ssid)
-		memcpy(cmd->params.ssid, ssid, ssid_len);
+	if (ssid) {
+		int len = clamp_val(ssid_len, 0, IEEE80211_MAX_SSID_LEN);
+
+		cmd->params.ssid_len = len;
+		memcpy(cmd->params.ssid, ssid, len);
+	}
 
 	ret = wl1251_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd));
 	if (ret < 0) {
-- 
2.30.2

