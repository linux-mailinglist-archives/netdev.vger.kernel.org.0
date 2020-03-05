Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6BA17ABCF
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgCERP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:15:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbgCERP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:15:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D90217F4;
        Thu,  5 Mar 2020 17:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428557;
        bh=eNzdRRHaJ0+IxpR/5W49HbKbaI2NcG1Qkrx0pmi9OB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jU1ddhuFUCuuYoN87osODCDp46M0YKx5k9Yx9KRrWZLgTb2kHuoW3yuf1b6S9PJZp
         bq4lQ6DHpti9RmW0Qy71wJrxrLmLft0ZWDp1eKZ5Rl7L0tKOUZSbre6kSNf44Ci3p8
         1/LbD0kqIVA4WZm8HvQc1pyVQF7vdQqHoW/y28DA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/19] mac80211: rx: avoid RCU list traversal under mutex
Date:   Thu,  5 Mar 2020 12:15:34 -0500
Message-Id: <20200305171540.30250-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171540.30250-1-sashal@kernel.org>
References: <20200305171540.30250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 253216ffb2a002a682c6f68bd3adff5b98b71de8 ]

local->sta_mtx is held in __ieee80211_check_fast_rx_iface().
No need to use list_for_each_entry_rcu() as it also requires
a cond argument to avoid false lockdep warnings when not used in
RCU read-side section (with CONFIG_PROVE_RCU_LIST).
Therefore use list_for_each_entry();

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Link: https://lore.kernel.org/r/20200223143302.15390-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 31000622376df..7c92b1471c34c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3862,7 +3862,7 @@ void __ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata)
 
 	lockdep_assert_held(&local->sta_mtx);
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata &&
 		    (!sta->sdata->bss || sta->sdata->bss != sdata->bss))
 			continue;
-- 
2.20.1

