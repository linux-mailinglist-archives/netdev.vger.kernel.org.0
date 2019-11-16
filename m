Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6831EFEDD8
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbfKPPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729654AbfKPPrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:12 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D97C2088F;
        Sat, 16 Nov 2019 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919231;
        bh=5Pdak+JPJzVEhoD/8rcgc5m8LdWqf4v8nm3VoE3IvzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxTUeGBtQno2/GyHBn/Q5+d4Y6ybRImKJB3WlcSUQVR3LOdrzuctuuiEgRYe2KVpX
         2r/gI0OplJpSdeyqWWj2sO4E6oD5ruQrER8rAatQOJVU+/USDMFzo3d1apkI99MPC5
         350/jI+CT4W8xzBsREcPT0LGECVZq7hrFnnDBrnY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 237/237] cfg80211: call disconnect_wk when AP stops
Date:   Sat, 16 Nov 2019 10:41:12 -0500
Message-Id: <20191116154113.7417-237-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e005bd7ddea06784c1eb91ac5bb6b171a94f3b05 ]

Since we now prevent regulatory restore during STA disconnect
if concurrent AP interfaces are active, we need to reschedule
this check when the AP state changes. This fixes never doing
a restore when an AP is the last interface to stop. Or to put
it another way: we need to re-check after anything we check
here changes.

Cc: stable@vger.kernel.org
Fixes: 113f3aaa81bd ("cfg80211: Prevent regulatory restore during STA disconnect in concurrent interfaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/ap.c   | 2 ++
 net/wireless/core.h | 2 ++
 net/wireless/sme.c  | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 882d97bdc6bfd..550ac9d827fe7 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -41,6 +41,8 @@ int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		cfg80211_sched_dfs_chan_update(rdev);
 	}
 
+	schedule_work(&cfg80211_disconnect_work);
+
 	return err;
 }
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 7f52ef5693203..f5d58652108dd 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -430,6 +430,8 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 bool cfg80211_does_bw_fit_range(const struct ieee80211_freq_range *freq_range,
 				u32 center_freq_khz, u32 bw_khz);
 
+extern struct work_struct cfg80211_disconnect_work;
+
 /**
  * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
  * @wiphy: the wiphy to validate against
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index c7047c7b4e80f..07c2196e9d573 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -667,7 +667,7 @@ static void disconnect_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
-static DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
+DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
 
 
 /*
-- 
2.20.1

