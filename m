Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9D4119806
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbfLJVfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730377AbfLJVft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFF2C24654;
        Tue, 10 Dec 2019 21:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013748;
        bh=eGZb0mLut5CLjKtIi5QfNOaQefvgGgYuUtmdojA4tRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6SMdv2XcMsDV0NUofEn0WxRkoTtQfYQPCblmRYSvCCcSkZ2C5GwAKg4VqCTM3B/F
         LamB7Ry5MudgQ3CpWpTnqkdQET/rWs05Wi7cl9oj3TZenr2cPnsprHSlpGnosiOREQ
         JVumMHkYs5ze+5RP5pA+LIX1edOkuJryKIh5yk3E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Pedersen <thomas@adapt-ip.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 170/177] mac80211: consider QoS Null frames for STA_NULLFUNC_ACKED
Date:   Tue, 10 Dec 2019 16:32:14 -0500
Message-Id: <20191210213221.11921-170-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Pedersen <thomas@adapt-ip.com>

[ Upstream commit 08a5bdde3812993cb8eb7aa9124703df0de28e4b ]

Commit 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing")
let STAs send QoS Null frames as PS triggers if the AP was
a QoS STA.  However, the mac80211 PS stack relies on an
interface flag IEEE80211_STA_NULLFUNC_ACKED for
determining trigger frame ACK, which was not being set for
acked non-QoS Null frames. The effect is an inability to
trigger hardware sleep via IEEE80211_CONF_PS since the QoS
Null frame was seemingly never acked.

This bug only applies to drivers which set both
IEEE80211_HW_REPORTS_TX_ACK_STATUS and
IEEE80211_HW_PS_NULLFUNC_STACK.

Detect the acked QoS Null frame to restore STA power save.

Fixes: 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing")
Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
Link: https://lore.kernel.org/r/20191119053538.25979-4-thomas@adapt-ip.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/status.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 534a604b75c26..f895c656407b5 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -867,7 +867,8 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 			I802_DEBUG_INC(local->dot11FailedCount);
 	}
 
-	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
+	if ((ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc)) &&
+	    ieee80211_has_pm(fc) &&
 	    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS) &&
 	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 	    local->ps_sdata && !(local->scanning)) {
-- 
2.20.1

