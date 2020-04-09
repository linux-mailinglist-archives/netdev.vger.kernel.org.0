Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425E01A30DD
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgDII3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:29:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36121 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgDII3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 04:29:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id n10so3808307pff.3;
        Thu, 09 Apr 2020 01:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0HXV8vx9Be0BBihyhMob71nh1LkIaEr5epGWg9GzRAU=;
        b=MUEXAxyoTdSoolqIbRRVACRTGku/CrRdwrnfri3FU7m1CGWxvVxECyJzNjlzoqEsKx
         3F4wPoUnPw9Kuzp/PVK1EZi9PKkRunyMAcxg9R/YOyGp5tIrKrpjXWEUrlpLOJOWBzUD
         obPKIv5NLJclwMiHJMYvdi7BAiqeOxWl8X/mhTECRPJ9/Eld7HjSPlVuifZme/saoNlL
         r7USy8sMvD85yB/97jF8qGDDQ2P63+yhXJqbcB5PJrASY94EGnAi3CmWe/DK9SxyfXu3
         3EUfwTX31XHnMhbzoahy0Jh91k/5CiQiM9jr7e97x7EuVBBI/A0B6jKgznf21CII8MWK
         pJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0HXV8vx9Be0BBihyhMob71nh1LkIaEr5epGWg9GzRAU=;
        b=GGAF0G0KBZSdBn9vB6CdBJkZTzgEUzkWAxNLCJyn9v9AK0n0yfpMJZL3tyonJadkrS
         /0WXo/hQzA97oVstCVoDweRjrYgu7AMYbC14+7c8xH42J9np48swbEBMwPMD1yM5CgyA
         RsuGYw69xTocHkjl2jxakGEo6c5Ei7/Zehk2QhOjlxhUiQA60yS5kNYU37KyEymfdcVz
         gOpwk8BeMx4Zec4s8eLW5uolNfEKwTadAqrwTClKCevgqcI1igV802QeZBta5q+mwG5N
         QC6+8VZWsLkxL7yeHC4q2gMXfbZFEC2yPwsdtqPiyLW8fGzET9EReA2LOltbtiifB3k/
         M9/Q==
X-Gm-Message-State: AGi0PuZ9i4kXGn5z20vtYaNGMM4fl41XQ7LyxBgr8mW1hCutRoMDwJoo
        1x9xQSIy+/C1Fu3woSfNyA==
X-Google-Smtp-Source: APiQypJMUo7McfIjWzcXnjJmz+8h35KmF64lZDJ+qnUEu0I5lgVqNGuknsQBsn/cgMScS/uFl60oLQ==
X-Received: by 2002:a63:e56:: with SMTP id 22mr10914839pgo.173.1586420939939;
        Thu, 09 Apr 2020 01:28:59 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:13be:8fdf:25a2:66e2:761f:9d4c])
        by smtp.gmail.com with ESMTPSA id h10sm17615674pgf.23.2020.04.09.01.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 01:28:59 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        joel@joelfernandes.org, paulmck@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH 2/4] net: mac80211: scan.c: Fix RCU list related warnings.
Date:   Thu,  9 Apr 2020 13:58:49 +0530
Message-Id: <20200409082849.27372-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

This patch fixes the following warning:

WARNING: suspicious RCU usage
[   84.530619] 5.6.0+ #4 Not tainted
[   84.530637] -----------------------------
[   84.530658] net/mac80211/scan.c:454 RCU-list traversed in non-reader section!!

As local->mtx is held in __ieee80211_scan_completed(), no need to use
list_for_each_entry_rcu() (use list_for_each_entry() instead.).

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fdac8192a519..0860f028ab2a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -451,7 +451,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	 * the scan was in progress; if there was none this will
 	 * just be a no-op for the particular interface.
 	 */
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
-- 
2.17.1

