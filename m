Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46EE0E5B73
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbfJZNXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729631AbfJZNXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:23:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68F4A214DA;
        Sat, 26 Oct 2019 13:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096186;
        bh=EW4/IRrOJwj5qEvaxtF3QoKN+4u+9FMx9SWDEIYwjus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUOV1bTgQMJ825LYwXZQL+bonuY7I1Di7BuLgK6xIiWVZf6M/HbLzqgb7ngLLZxnu
         nvibuVSsmUts1eFgWn9keKn0He9t+WuC6oC6xFNH/roX322YLqrNDK4g3roapdqzhs
         3p7Y6F+zpDgkVYbrxs0VXgE5dBrb7wyAwcAfWjC0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 03/17] mac80211: accept deauth frames in IBSS mode
Date:   Sat, 26 Oct 2019 09:22:47 -0400
Message-Id: <20191026132302.4622-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132302.4622-1-sashal@kernel.org>
References: <20191026132302.4622-1-sashal@kernel.org>
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
index 3b8e2f97d8151..2b7975c4dac7b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3040,9 +3040,18 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
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

