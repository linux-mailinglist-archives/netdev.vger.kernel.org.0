Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B51E5B34
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfJZNVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbfJZNVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0BCF222BD;
        Sat, 26 Oct 2019 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096078;
        bh=fZ5b/0CjTl/y0q4mG/aNFlc0SydL+UI5brBMk+5wOI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udwb1UfGDwohNqRgye6PC04tzo9gr09nUKD99WwGimTCFoXMsRKH3jM+IkXmkeoXx
         q+842h3dcN3uM5fn8mXqjk6NeKkzDfH19EHczxNnINnl4cN6oJCtN/dJ6xR6ikZK9P
         Bq4n8RyI62O15o+qv/lYpCdavDiigFnZOzyFGClc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/33] mac80211: accept deauth frames in IBSS mode
Date:   Sat, 26 Oct 2019 09:20:44 -0400
Message-Id: <20191026132110.4026-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 95697f9907bfe3eab0ef20265a766b22e27dde64 ]

We can process deauth frames and all, but we drop them very
early in the RX path today - this could never have worked.

Fixes: 2cc59e784b54 ("mac80211: reply to AUTH with DEAUTH if sta allocation fails in IBSS")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20191004123706.15768-2-luca@coelho.fi
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4a6b3c7b35e37..31000622376df 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3227,9 +3227,18 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 	case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
 		/* process for all: mesh, mlme, ibss */
 		break;
+	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+		if (is_multicast_ether_addr(mgmt->da) &&
+		    !is_broadcast_ether_addr(mgmt->da))
+			return RX_DROP_MONITOR;
+
+		/* process only for station/IBSS */
+		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+			return RX_DROP_MONITOR;
+		break;
 	case cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP):
 	case cpu_to_le16(IEEE80211_STYPE_REASSOC_RESP):
-	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
 	case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
 		if (is_multicast_ether_addr(mgmt->da) &&
 		    !is_broadcast_ether_addr(mgmt->da))
-- 
2.20.1

