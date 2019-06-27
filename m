Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB553575F3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbfF0AeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfF0AeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:05 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 166E320659;
        Thu, 27 Jun 2019 00:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595644;
        bh=B+vw4Mx6McYj4L0NkRQ3Uhzpey5yO2H2Hz44qQslpnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXKRHmdYYj5snYb+w1584qtsVcy5uc6SFxStT2r/CI+t1ApHKlsvrqitl5g8dWr6Z
         kI3IQbXa9+9owxOv/vixlqamTkugRhSbXXqAOGOH1UhoA4A8M2feAQUX5MsYaHrKJ0
         Yf6yyazb4K6lvaqzPfKgmcPa/B5DQvJ3GrTFxB/Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 65/95] mac80211: do not start any work during reconfigure flow
Date:   Wed, 26 Jun 2019 20:29:50 -0400
Message-Id: <20190627003021.19867-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

[ Upstream commit f8891461a277ec0afc493fd30cd975a38048a038 ]

It is not a good idea to try to perform any work (e.g. send an auth
frame) during reconfigure flow.

Prevent this from happening, and at the end of the reconfigure flow
requeue all the works.

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 7 +++++++
 net/mac80211/util.c        | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2878ea8a01fd..53fbad3b99b8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2034,6 +2034,13 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 
 static inline bool ieee80211_can_run_worker(struct ieee80211_local *local)
 {
+	/*
+	 * It's unsafe to try to do any work during reconfigure flow.
+	 * When the flow ends the work will be requeued.
+	 */
+	if (local->in_reconfig)
+		return false;
+
 	/*
 	 * If quiescing is set, we are racing with __ieee80211_suspend.
 	 * __ieee80211_suspend flushes the workers after setting quiescing,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4c1655972565..70f5816412bb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2442,6 +2442,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_lock(&local->mtx);
 		ieee80211_start_next_roc(local);
 		mutex_unlock(&local->mtx);
+
+		/* Requeue all works */
+		list_for_each_entry(sdata, &local->interfaces, list)
+			ieee80211_queue_work(&local->hw, &sdata->work);
 	}
 
 	ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
-- 
2.20.1

