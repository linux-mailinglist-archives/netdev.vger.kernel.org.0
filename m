Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C961BFA6A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgD3NxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgD3NxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CAE824956;
        Thu, 30 Apr 2020 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254795;
        bh=YNOc2verFZCxdF+PEr0mt3qsZBXxUQ4tOaOWm46Gf7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWiGgEUT6PW9INt36D/nlG+DZ+jFWVDE1lhK7UyPTweI90J8uaS1RXv1efkhZKHGX
         SpEEA8NLEkiVOG+hp65N51EJ9GDEwWAA48eTVmQe6ETNuNMX5Q2t9q8Z9fL4iRmomc
         Sf7aa7VlVWdfSFzRsu7NsTR5ioWe3FybpH98Rcss=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 50/57] mac80211: sta_info: Add lockdep condition for RCU list usage
Date:   Thu, 30 Apr 2020 09:52:11 -0400
Message-Id: <20200430135218.20372-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 8ca47eb9f9e4e10e7e7fa695731a88941732c38d ]

The function sta_info_get_by_idx() uses RCU list primitive.
It is called with  local->sta_mtx held from mac80211/cfg.c.
Add lockdep expression to avoid any false positive RCU list warnings.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Link: https://lore.kernel.org/r/20200409082906.27427-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 21b1422b1b1c3..b1669f0244706 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -217,7 +217,8 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	int i = 0;
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry_rcu(sta, &local->sta_list, list,
+				lockdep_is_held(&local->sta_mtx)) {
 		if (sdata != sta->sdata)
 			continue;
 		if (i < idx) {
-- 
2.20.1

