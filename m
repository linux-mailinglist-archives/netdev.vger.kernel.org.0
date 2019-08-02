Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB75B7FAE8
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406233AbfHBNfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390653AbfHBNUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA6F221849;
        Fri,  2 Aug 2019 13:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752034;
        bh=8wPUOlUGXjzV6VZ8sBlIypSaLC8Ku5+bs82aSrbchfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvHOOq5RkhKf6H6IlG34AnFMu7zuIgwxuQ9T52NQt4vCo13uF9Vg40k3QBo22Y0b1
         khMj5j0qX/CXt4VtZog8JGzMv/xZWD0Hr1EIas9UH6/gk9Zk2E5JgcrWfar8TZXF5o
         c4LFGMBB09rGetotPF1qQIiywLipoPtjAy0YxeS4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 28/76] mac80211: fix possible memory leak in ieee80211_assign_beacon
Date:   Fri,  2 Aug 2019 09:19:02 -0400
Message-Id: <20190802131951.11600-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit bcc27fab8cc673ddc95452674373cce618ccb3a3 ]

Free new beacon_data in ieee80211_assign_beacon whenever
ieee80211_assign_beacon fails

Fixes: 8860020e0be1 ("cfg80211: restructure AP/GO mode API")
Fixes: bc847970f432 ("mac80211: support FTM responder configuration/statistic")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/770285772543c9fca33777bb4ad4760239e56256.1562105631.git.lorenzo@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1973a26c7fc4..b8288125e05db 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -935,8 +935,10 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	err = ieee80211_set_probe_resp(sdata, params->probe_resp,
 				       params->probe_resp_len, csa);
-	if (err < 0)
+	if (err < 0) {
+		kfree(new);
 		return err;
+	}
 	if (err == 0)
 		changed |= BSS_CHANGED_AP_PROBE_RESP;
 
@@ -948,8 +950,10 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 							 params->civicloc,
 							 params->civicloc_len);
 
-		if (err < 0)
+		if (err < 0) {
+			kfree(new);
 			return err;
+		}
 
 		changed |= BSS_CHANGED_FTM_RESPONDER;
 	}
-- 
2.20.1

