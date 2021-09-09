Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCCC405086
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348194AbhIIM2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353007AbhIIMWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 438DD61AFD;
        Thu,  9 Sep 2021 11:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188269;
        bh=k7GlPxKjxxPV1E0dBBXMjRRHeWhi0zDdQc+CVA8fLYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGIJAwrJfnx4nGHSCutdFSBX+1ikz0fv69kMrH6mSDViqqWNfJSLgl2Ov3otMtQKq
         DVRX6kVKjx/9nnRB4kX4Otg+TJH5QnVosesTAjd8iNFl0EIAyNCEz5JZe/aEUuo8YU
         a5WYTLOTERzhWBZkL4iGZMF2w9AzigSOJuoaMjlxN5irSZcwqeyQ9mBydd/G6syQGM
         +ZlqPLx24B/ZhwaE4R5JQtAWRuIwIVLluBecbPYouQkX87unvZdODaklB6DsKyHBCY
         tNvKjKWTt57GO4mKkQo1Z6BJMbvErqE7W+rtmKbPEv6FayKSxIqvCo292w7uNrMcWK
         i3mHOEejO5UOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 213/219] wcn36xx: Fix missing frame timestamp for beacon/probe-resp
Date:   Thu,  9 Sep 2021 07:46:29 -0400
Message-Id: <20210909114635.143983-213-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 8678fd31f2d3eb14f2b8b39c9bc266f16fa24b22 ]

When receiving a beacon or probe response, we should update the
boottime_ns field which is the timestamp the frame was received at.
(cf mac80211.h)

This fixes a scanning issue with Android since it relies on this
timestamp to determine when the AP has been seen for the last time
(via the nl80211 BSS_LAST_SEEN_BOOTTIME parameter).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1629992768-23785-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 1b831157ede1..cab196bb38cd 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -287,6 +287,10 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 		status.rate_idx = 0;
 	}
 
+	if (ieee80211_is_beacon(hdr->frame_control) ||
+	    ieee80211_is_probe_resp(hdr->frame_control))
+		status.boottime_ns = ktime_get_boottime_ns();
+
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 
 	if (ieee80211_is_beacon(hdr->frame_control)) {
-- 
2.30.2

