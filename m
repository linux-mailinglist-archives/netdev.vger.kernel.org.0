Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964651A30D7
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDII2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:28:43 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33057 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDII2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 04:28:43 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay1so3603284plb.0;
        Thu, 09 Apr 2020 01:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+fG/Gev7HaxlZXPpDg5ZggbcqVNpIERCkV8tz6C91rI=;
        b=VrAgMiavqperU/qmbs/nYjs3R21Z28HnwtwMqUnz+kDRaWK1/ZgKpBoHUtv5W1KCFZ
         bxslrV0uDn0OCQeOo3WZ5AJUYGxXqQ695kC9UHyoy7gG1XspSihCx+CU89l6wPOp6V5y
         hG+eMGGzgOuXBePYk7ka5BB+R9mdIcab0K+N7UEN15opjjWlE9NlBFzQuTKI/KH/Q/fA
         ncXvjCpHv2RMY0sUgIwoIwdP52Vt7INaIGjY7NG+KiKG2CUqb408W/RlxvB1PtQ/XfIj
         qDzBcNS1EyfWfqV8yTUdHDLHOkGJnRiUSOfHBdwnSn1avhWyQL3LV14rk7VVZ2vUcDhZ
         ZZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+fG/Gev7HaxlZXPpDg5ZggbcqVNpIERCkV8tz6C91rI=;
        b=tUerkIQH8fZIiTRSv9tNj6qyFCXhcrmuH8oMAWrdJN3UwH8UYAucsQCY5Ll99dV0vk
         Qk/4l7WhlrxrDsIuWO25sWNmhbIzetqiGB3tXxkx+uYUTh9G/mcoXHZjP05HZg5/nNr1
         //UyD93AAGUj1yQVWlk9/37PTCVkZ/86ReDkNsa6VPtjDNRSctGcF7P1dWjD4QLAnSHD
         5nCXrepA6hmWsfE9/mgmAQUknQ7ZxaSc7UZ5qZYsCqF4aRFKMcmpGJsksZzjcoWqwa0C
         oFr46ZPIsw9EIiIiHP6ZIrAisubbultAJZlWANBzl3HFD/sYOczaXykkEzfiLANS86nm
         IzUA==
X-Gm-Message-State: AGi0PuYioGT1f7dsSz/Yp9XyUz15T13MOsa3BTQ3TsCkZgWtA3BM8VBm
        iON+rWEl3m/E1SJSujxnmQ==
X-Google-Smtp-Source: APiQypJLoXasAxeWqbcLrxY25TSunFHpWMUBhjAxPsjLnDLzDMGnFUlBC1/m+GQba0kNmUo48yAUvg==
X-Received: by 2002:a17:90a:8c18:: with SMTP id a24mr10599111pjo.43.1586420922983;
        Thu, 09 Apr 2020 01:28:42 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:13be:8fdf:25a2:66e2:761f:9d4c])
        by smtp.gmail.com with ESMTPSA id r189sm17762095pgr.31.2020.04.09.01.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 01:28:42 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        joel@joelfernandes.org, paulmck@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH 1/4] net: mac80211: util.c: Fix RCU list usage warnings
Date:   Thu,  9 Apr 2020 13:58:22 +0530
Message-Id: <20200409082822.27314-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

This patch fixes the following warning (CONIG_PROVE_RCU_LIST)
in ieee80211_check_combinations().

WARNING: suspicious RCU usage
[   80.933723] 5.6.0+ #4 Not tainted
[   80.933733] -----------------------------
[   80.933746] net/mac80211/util.c:3934 RCU-list traversed in non-reader section!!

Also, fix the other uses of list_for_each_entry_rcu() by either using
list_for_each_entry() instead (When mutex or spinlock is always held
in the function) or pass the necessary lockdep condition.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/mac80211/util.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 20436c86b9bf..f4b0434024c0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -254,7 +254,7 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 
 	sdata->vif.txqs_stopped[ac] = false;
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata)
 			continue;
 
@@ -719,7 +719,8 @@ static void __iterate_interfaces(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 	bool active_only = iter_flags & IEEE80211_IFACE_ITER_ACTIVE;
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	list_for_each_entry_rcu(sdata, &local->interfaces, list,
+				(lockdep_is_held(&local->iflist_mtx)|| lockdep_rtnl_is_held())) {
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_MONITOR:
 			if (!(sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE))
@@ -3931,7 +3932,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		params.num_different_channels++;
 	}
 
-	list_for_each_entry_rcu(sdata_iter, &local->interfaces, list) {
+	list_for_each_entry(sdata_iter, &local->interfaces, list) {
 		struct wireless_dev *wdev_iter;
 
 		wdev_iter = &sdata_iter->wdev;
@@ -3982,7 +3983,7 @@ int ieee80211_max_num_channels(struct ieee80211_local *local)
 			ieee80211_chanctx_radar_detect(local, ctx);
 	}
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+	list_for_each_entry(sdata, &local->interfaces, list)
 		params.iftype_num[sdata->wdev.iftype]++;
 
 	err = cfg80211_iter_combinations(local->hw.wiphy, &params,
-- 
2.17.1

