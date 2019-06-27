Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF4B57664
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbfF0Ai2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728820AbfF0Ai1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:38:27 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39D0A214AF;
        Thu, 27 Jun 2019 00:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595906;
        bh=VePPAgNzl9cvWFPU4jZ/vJZ4UpG5DZzQSb54AbU1/6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgMqiA847AfkaMMweOVAUXoJ3MgJrZ1HOoB8ByRtBvU4Dt94aRRders4lOojpfGg3
         POI5dq84uZfIou5FmnfPWrDr7Um97c4aCU+lx6vnD8hCEiQ+jDZFyfxzgj3IrJM64d
         XKgDh8cVabbUet7vzXEleQUpuZ3PI+r9tYuzsCO4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 41/60] mac80211: do not start any work during reconfigure flow
Date:   Wed, 26 Jun 2019 20:35:56 -0400
Message-Id: <20190627003616.20767-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
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
index 6ea64cadad00..ae9cce2d41da 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1998,6 +1998,13 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 
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
index 3deaa01ebee4..f60e033f68c9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2224,6 +2224,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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

