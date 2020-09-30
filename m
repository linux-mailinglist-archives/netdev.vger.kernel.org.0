Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0049527F286
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbgI3TWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3TWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:22:37 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5569C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:36 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d20so1519936plr.18
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=q0P1tSMlNAWIV7zQIDv2HdEMyoD3KRTuWxJZUM97nVU=;
        b=Y2I3C0RCK6Hx5PXS6nbwME5Pvk1+4meeGGrm/v21y0zr4shYRlAZOsphdLF8wNwg9l
         N5a/lQ6DAko9cFZTCHzfuSeD638v3BV7zSmha7G7xwyr33divE0ZyAVcZZRuWihjXpXX
         BpX3/+4dmLzxjjvHBVOeUPYDKPfXFzVl3jTdOxOc/muAi6YKXxsllNUXlwZD4VeW82J4
         cFCSpiwpRlsl7ZW94qiaxqBDzvGUyWVwuO1oBegX0q4ur6x/Fizkux9jU990LdRtepLq
         Zxn71aX+PKh9+tSB4aaLUxeuhyQgKS6MKv/lev5P69NqYPW/1slpUBfBlHViXbS1Zo8X
         4vBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q0P1tSMlNAWIV7zQIDv2HdEMyoD3KRTuWxJZUM97nVU=;
        b=QcR6EeNWAd2vM41VPYIL8uiQmlOBgw/WjpzQoecavAj2hUb3Biz5CkSVON9nQg7sYX
         NltkFobB9YZgOyxIXKzTuEuLfbCGdp4fy7pUBwBmgwWS/AN9B8rRiLuomsAZRelzkBvM
         klVsqfxeIObIIK8SdmlUQogoa9NH6gwxpQdki+2MRgldDZU0CBRtuhp1T9LbdTXD7g7z
         aRyof7y2hFP4+/HkE9xc23Lp1gOCQODDFmbxrcYAoQE/PsOXOrXnMig5Ku5p0HtR9rZY
         bTMK+t93G22AwZ/3AvLSbqJpRljLabK9o90pWzrHXG38eS4J669jo+PUfOeqzR+3CXtK
         uYbw==
X-Gm-Message-State: AOAM533iK7jbwlJkhfJFHXTW9Dp7Cl3CSiRVWLTAHJjR5dO87ILEpz0p
        thWwRY8HcFxQKgEcqnGvlSX0quJVKhg=
X-Google-Smtp-Source: ABdhPJzsjnyILZ8+Xe9eHao7/1qdUQkUum8OCbGs+2flAKvowDAZdkEI876QVRQXgB0rRm24MDSwVDvfs4A=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a65:5185:: with SMTP id h5mr3325872pgq.37.1601493756340;
 Wed, 30 Sep 2020 12:22:36 -0700 (PDT)
Date:   Wed, 30 Sep 2020 12:21:39 -0700
In-Reply-To: <20200930192140.4192859-1-weiwan@google.com>
Message-Id: <20200930192140.4192859-5-weiwan@google.com>
Mime-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH net-next 4/5] net: modify kthread handler to use __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org> 

The current kthread handler calls napi_poll() and has to pass a dummy
repoll list to the function, which seems redundent. The new proposed
kthread handler calls the newly proposed __napi_poll(), and respects
napi->weight as before. If repoll is needed, cond_resched() is called
first to give other tasks a chance to run before repolling.
This change is proposed by Jakub Kicinski <kuba@kernel.org> on top of
the previous patch.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 net/core/dev.c | 62 +++++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c82522262ca8..b4f33e442b5e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6827,6 +6827,15 @@ static int __napi_poll(struct napi_struct *n, bool *repoll)
 
 	gro_normal_list(n);
 
+	/* Some drivers may have called napi_schedule
+	 * prior to exhausting their budget.
+	 */
+	if (unlikely(!list_empty(&n->poll_list))) {
+		pr_warn_once("%s: Budget exhausted after napi rescheduled\n",
+			     n->dev ? n->dev->name : "backlog");
+		return work;
+	}
+
 	*repoll = true;
 
 	return work;
@@ -6847,15 +6856,6 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	if (!do_repoll)
 		goto out_unlock;
 
-	/* Some drivers may have called napi_schedule
-	 * prior to exhausting their budget.
-	 */
-	if (unlikely(!list_empty(&n->poll_list))) {
-		pr_warn_once("%s: Budget exhausted after napi rescheduled\n",
-			     n->dev ? n->dev->name : "backlog");
-		goto out_unlock;
-	}
-
 	list_add_tail(&n->poll_list, repoll);
 
 out_unlock:
@@ -6884,40 +6884,26 @@ static int napi_thread_wait(struct napi_struct *napi)
 static int napi_threaded_poll(void *data)
 {
 	struct napi_struct *napi = data;
+	void *have;
 
 	while (!napi_thread_wait(napi)) {
-		struct list_head dummy_repoll;
-		int budget = netdev_budget;
-		unsigned long time_limit;
-		bool again = true;
+		for (;;) {
+			bool repoll = false;
 
-		INIT_LIST_HEAD(&dummy_repoll);
-		local_bh_disable();
-		time_limit = jiffies + 2;
-		do {
-			/* ensure that the poll list is not empty */
-			if (list_empty(&dummy_repoll))
-				list_add(&napi->poll_list, &dummy_repoll);
-
-			budget -= napi_poll(napi, &dummy_repoll);
-			if (unlikely(budget <= 0 ||
-				     time_after_eq(jiffies, time_limit))) {
-				cond_resched();
-
-				/* refresh the budget */
-				budget = netdev_budget;
-				__kfree_skb_flush();
-				time_limit = jiffies + 2;
-			}
+			local_bh_disable();
 
-			if (napi_disable_pending(napi))
-				again = false;
-			else if (!test_bit(NAPI_STATE_SCHED, &napi->state))
-				again = false;
-		} while (again);
+			have = netpoll_poll_lock(napi);
+			__napi_poll(napi, &repoll);
+			netpoll_poll_unlock(have);
 
-		__kfree_skb_flush();
-		local_bh_enable();
+			__kfree_skb_flush();
+			local_bh_enable();
+
+			if (!repoll)
+				break;
+
+			cond_resched();
+		}
 	}
 	return 0;
 }
-- 
2.28.0.709.gb0816b6eb0-goog

