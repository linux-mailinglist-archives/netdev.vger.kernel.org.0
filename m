Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69981062C9
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfKVGG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbfKVGCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 995E72071B;
        Fri, 22 Nov 2019 06:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402538;
        bh=u+OorGplPoo4KPqhEBpJTPq5149qy2NJwf/txWg4fFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXgJjJ3ruAg+ZnWEG4nlZuu2VwZgRarF3io5WInLGNUH1hUQWk2YxUU0eYS5Bwg0n
         0JRfy4gVHKwiNnoSjmpKCzfi1Eaw3ryOEKYDNYzj21p3voZW8dPQNWWsIUk9KCjOaL
         yeE0vTupW9lJEJef2Kjw4nSRoepIH1WcZx/vz14s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Roeschley <kyle.roeschley@ni.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 45/91] ath6kl: Only use match sets when firmware supports it
Date:   Fri, 22 Nov 2019 01:00:43 -0500
Message-Id: <20191122060129.4239-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kyle Roeschley <kyle.roeschley@ni.com>

[ Upstream commit fb376a495fbdb886f38cfaf5a3805401b9e46f13 ]

Commit dd45b7598f1c ("ath6kl: Include match ssid list in scheduled scan")
merged the probed and matched SSID lists before sending them to the
firmware. In the process, it assumed match set support is always available
in ath6kl_set_probed_ssids, which breaks scans for hidden SSIDs. Now, check
that the firmware supports matching SSIDs in scheduled scans before setting
MATCH_SSID_FLAG.

Fixes: dd45b7598f1c ("ath6kl: Include match ssid list in scheduled scan")
Signed-off-by: Kyle Roeschley <kyle.roeschley@ni.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b7fe0af4cb240..0cce5a2bca161 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -934,7 +934,7 @@ static int ath6kl_set_probed_ssids(struct ath6kl *ar,
 		else
 			ssid_list[i].flag = ANY_SSID_FLAG;
 
-		if (n_match_ssid == 0)
+		if (ar->wiphy->max_match_sets != 0 && n_match_ssid == 0)
 			ssid_list[i].flag |= MATCH_SSID_FLAG;
 	}
 
-- 
2.20.1

