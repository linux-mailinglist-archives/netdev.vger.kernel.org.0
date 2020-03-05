Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889FC17ABDE
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgCERQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgCERQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:16:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0593B21556;
        Thu,  5 Mar 2020 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428570;
        bh=CEZE2M2M19p/tI/qitCnZMFSK+sh5USz35jRAEJmX4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnfKHpd2xcOs2rkVtjpn0P1UlX0mSjn35GG7GVx7yqdluY3gDdLU8CZkUG8vIGPXJ
         ZBJNDsk3USQHKUrzfpks+7Azs2KQOqM1FNC9zIcKcqmD0d6vS++mfmdTUoBR+joh2B
         A8AY85z+CyOO969F9Ruj86QOq7/T0ksT7zcuwM4Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/12] mac80211: rx: avoid RCU list traversal under mutex
Date:   Thu,  5 Mar 2020 12:15:56 -0500
Message-Id: <20200305171559.30422-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171559.30422-1-sashal@kernel.org>
References: <20200305171559.30422-1-sashal@kernel.org>
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
index 74652eb2f90fd..a6f265262f151 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3841,7 +3841,7 @@ void __ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata)
 
 	lockdep_assert_held(&local->sta_mtx);
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata &&
 		    (!sta->sdata->bss || sta->sdata->bss != sdata->bss))
 			continue;
-- 
2.20.1

