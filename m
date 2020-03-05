Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6865817AC76
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCERUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727805AbgCEROs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802B021744;
        Thu,  5 Mar 2020 17:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428487;
        bh=/y4YRKLmqcpeFP+pPVW27yC67xqccznREWtav/5wFDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ok14nVaT8DJ+SFU9ym2AqHcKd7ih1gLG4ddwdar9wIIu6TgFMSNwaCj2iS5udR0B8
         R9V9pqVIO6KMZ8t2az3McEI/EjwSmsysseE1nMVna6J5KjriuL7QD1J4HC5nB+Ea7B
         SwTcZ+Zcw3T0sEhwZkv6Y2vWU7vDNiKqSN4vjkpA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/58] mac80211: Remove a redundant mutex unlock
Date:   Thu,  5 Mar 2020 12:13:43 -0500
Message-Id: <20200305171420.29595-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit 0daa63ed4c6c4302790ce67b7a90c0997ceb7514 ]

The below-mentioned commit changed the code to unlock *inside*
the function, but previously the unlock was *outside*. It failed
to remove the outer unlock, however, leading to double unlock.

Fix this.

Fixes: 33483a6b88e4 ("mac80211: fix missing unlock on error in ieee80211_mark_sta_auth()")
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Link: https://lore.kernel.org/r/20200221104719.cce4741cf6eb.I671567b185c8a4c2409377e483fd149ce590f56d@changeid
[rewrite commit message to better explain what happened]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1e3b9d34aaa46..c7d8044ff0fa6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2959,7 +2959,7 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	    (auth_transaction == 2 &&
 	     ifmgd->auth_data->expected_transaction == 2)) {
 		if (!ieee80211_mark_sta_auth(sdata, bssid))
-			goto out_err;
+			return; /* ignore frame -- wait for timeout */
 	} else if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
 		   auth_transaction == 2) {
 		sdata_info(sdata, "SAE peer confirmed\n");
@@ -2967,10 +2967,6 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	}
 
 	cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
-	return;
- out_err:
-	mutex_unlock(&sdata->local->sta_mtx);
-	/* ignore frame -- wait for timeout */
 }
 
 #define case_WLAN(type) \
-- 
2.20.1

