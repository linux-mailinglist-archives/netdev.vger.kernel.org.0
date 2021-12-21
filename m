Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B7C47B7E0
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhLUCCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:02:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35066 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbhLUCBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:01:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32F1CB81107;
        Tue, 21 Dec 2021 02:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0178CC36AEC;
        Tue, 21 Dec 2021 02:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052071;
        bh=+N6VHVgiZXIqmaPwaFeNl+UHTNP6/oEcCoFu3pD8c40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTsRf+vokl5YthwwzJ0MVaz3tCiAxo3V3V0pYqxzsBEVs4238gCwG2oxZICgaSd6F
         jSN+h/VFHhaIkwvrTaOAOrhnwbmB4Cf8Oa+JluJHJbVSpx2RvXVexnRUGA7frWTKY0
         TpnFJ94Kn05+D0soEZrzAByiNooqboHYCpSps/qb6xrHj1C++FWq8QliEfA+1dffUe
         OqX2ZP9oqu07HhvCUUEqap+rxuGI4/Lcc/cWM7IPmCxYBUuQN15DCADKa7vOwa/VjO
         XRxMSDARrsaW5Z67Rthpgqrjcm4pk8h8elVTB4udsifTE4TBnN2ypwiV+nCqDozF/3
         Lp/CvBVNguQIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ahmed Zaki <anzaki@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/11] mac80211: fix a memory leak where sta_info is not freed
Date:   Mon, 20 Dec 2021 21:00:22 -0500
Message-Id: <20211221020030.117225-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020030.117225-1-sashal@kernel.org>
References: <20211221020030.117225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Zaki <anzaki@gmail.com>

[ Upstream commit 8f9dcc29566626f683843ccac6113a12208315ca ]

The following is from a system that went OOM due to a memory leak:

wlan0: Allocated STA 74:83:c2:64:0b:87
wlan0: Allocated STA 74:83:c2:64:0b:87
wlan0: IBSS finish 74:83:c2:64:0b:87 (---from ieee80211_ibss_add_sta)
wlan0: Adding new IBSS station 74:83:c2:64:0b:87
wlan0: moving STA 74:83:c2:64:0b:87 to state 2
wlan0: moving STA 74:83:c2:64:0b:87 to state 3
wlan0: Inserted STA 74:83:c2:64:0b:87
wlan0: IBSS finish 74:83:c2:64:0b:87 (---from ieee80211_ibss_work)
wlan0: Adding new IBSS station 74:83:c2:64:0b:87
wlan0: moving STA 74:83:c2:64:0b:87 to state 2
wlan0: moving STA 74:83:c2:64:0b:87 to state 3
.
.
wlan0: expiring inactive not authorized STA 74:83:c2:64:0b:87
wlan0: moving STA 74:83:c2:64:0b:87 to state 2
wlan0: moving STA 74:83:c2:64:0b:87 to state 1
wlan0: Removed STA 74:83:c2:64:0b:87
wlan0: Destroyed STA 74:83:c2:64:0b:87

The ieee80211_ibss_finish_sta() is called twice on the same STA from 2
different locations. On the second attempt, the allocated STA is not
destroyed creating a kernel memory leak.

This is happening because sta_info_insert_finish() does not call
sta_info_free() the second time when the STA already exists (returns
-EEXIST). Note that the caller sta_info_insert_rcu() assumes STA is
destroyed upon errors.

Same fix is applied to -ENOMEM.

Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
Link: https://lore.kernel.org/r/20211002145329.3125293-1-anzaki@gmail.com
[change the error path label to use the existing code]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3a907ba7f7634..03f4358020796 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -574,13 +574,13 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	/* check if STA exists already */
 	if (sta_info_get_bss(sdata, sta->sta.addr)) {
 		err = -EEXIST;
-		goto out_err;
+		goto out_cleanup;
 	}
 
 	sinfo = kzalloc(sizeof(struct station_info), GFP_KERNEL);
 	if (!sinfo) {
 		err = -ENOMEM;
-		goto out_err;
+		goto out_cleanup;
 	}
 
 	local->num_sta++;
@@ -636,8 +636,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
  out_drop_sta:
 	local->num_sta--;
 	synchronize_net();
+ out_cleanup:
 	cleanup_single_sta(sta);
- out_err:
 	mutex_unlock(&local->sta_mtx);
 	kfree(sinfo);
 	rcu_read_lock();
-- 
2.34.1

