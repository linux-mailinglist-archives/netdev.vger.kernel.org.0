Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E6C3BD5BD
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239423AbhGFMYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:24:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236619AbhGFLfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FA3B61D48;
        Tue,  6 Jul 2021 11:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570631;
        bh=DLMSh4j0AnmTMlzgxM/VboZ7+8wm4ULFHQ39d2I+ppE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGkJOJsxnuVHSck6CijeAU0T50GXtXkLPX3lrnnsCfe+Ru6S7eDVJ3Sh/HwM1bEl5
         sLiraDbzBwsDHy5tqgvg0Js5eAY5vBAJ+/w2ckMVZNqxd6ChRkCduNf7bVIkNDwgbA
         y0TXiFX8yo8vyt3b5CBOQYeXCrEv/72W1vEqBsANt038KaBo6duVK2URAWQbfniYE7
         mlaO+hirGDMtKqn2gzaq3WsTCy/ss4zNJmX1Ts7yWfUWFPLt1RxiCCFL2m5av6CzwG
         RD5jmT7uw+ctWg4wiARlVQKQLDkJF2p0CD0NIFgUgM7jJK8cT/4Z6+gSt7Cx64enjY
         M3jylCazRNKBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lee Gibson <leegib@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 083/137] wl1251: Fix possible buffer overflow in wl1251_cmd_scan
Date:   Tue,  6 Jul 2021 07:21:09 -0400
Message-Id: <20210706112203.2062605-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 9547aea01b0f..ea0215246c5c 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -466,9 +466,12 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
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

