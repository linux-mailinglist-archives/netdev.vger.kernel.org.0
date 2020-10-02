Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0564281E47
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgJBWZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJBWZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:25:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287C3C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:25:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n13so3146599ybk.9
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 15:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=0e+7IEbYcjux0MzEdsGB+Kd6sxVaCkN3KuJ4/wrBOPU=;
        b=dd93fBN2s95RJPg5HzDE/4OQUnFwEEe1/tA9O66EEr5oXOBlEtkwHoJsW73U/lFBdU
         6RPFdXwnb4ZlnAx+yr6Z1Tj/BrIkWxvuQpovX/LREM71rA6a3HMWw4yoWQYr5L82LaSl
         U8mPRz0LqPibBLbCRsJqCfcAVcSc0Yy+HRLVZXEe0Ax6kJP8KyJKg8MwxRw1kOZ86gU3
         7VyBQG3rKT24YSglsWOFoQkHo1+NV+E64kzmjlDAACjK7HBJzaLzi1WPs8bE4w9nSjOO
         92biOyWmYUP1DV8/BJsT36qljOQGGHXjf17l8/ZQklSfa5u6dfnpb6iIfMLLiy9fDcHT
         hfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0e+7IEbYcjux0MzEdsGB+Kd6sxVaCkN3KuJ4/wrBOPU=;
        b=ndbxJ0oqEto2nV2Estfsk8ftGxNPW3puVHadcP4WDfFPOu9iOU/KxVFfEMZFgrMkJy
         iBn+xVi68PbxgT1L6vN+2PnDxBUs4zRbsHC/jyAOUYkKEp1JcaXswWTRNg9caBmR+l8x
         U2dEDWWmjLMj2Qs7Be99uk5UaM0qC8JksHCGYMIalAwEZTN1r6JPdITTMrfCX2dCbB43
         ukAQBL0adUG5Sd8axHsIwGaVSp+RQPBmtZ64E7PAkX1Mat7ZaF9bw+qhKe9/ZVlE0bj3
         uuohuFyD2S+UhB8K3SPPrsr4kkqxsVRx/ljDm1T37XsZThT6lMs9uLyrVoHD3ibamWC6
         q5Fw==
X-Gm-Message-State: AOAM530Hd/YIUbvrueROMr8nW4Biun+P/PbIWoXlscRblTKXTc2Q36kP
        pVHjckYFfmYEONBbKSIambePAgU0T0U=
X-Google-Smtp-Source: ABdhPJyI+rd6pxsGPq+vCAusSogCB7tZcybC6IR47SY2Ec7vOYgnj1Yo7qrB4VMmJVR6xu3hAcuEq7tzxJI=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:ab8e:: with SMTP id v14mr5754235ybi.465.1601677541283;
 Fri, 02 Oct 2020 15:25:41 -0700 (PDT)
Date:   Fri,  2 Oct 2020 15:25:13 -0700
In-Reply-To: <20201002222514.1159492-1-weiwan@google.com>
Message-Id: <20201002222514.1159492-5-weiwan@google.com>
Mime-Version: 1.0
References: <20201002222514.1159492-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH net-next v2 4/5] net: modify kthread handler to use __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
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
2.28.0.806.g8561365e88-goog

