Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4A92B8551
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgKRUH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRUH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:07:27 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450EBC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:26 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id 143so2441562qkg.20
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=InYd1q+YUiZ+OtuTZaswYvG/hZu51QspPnytjgDA4O4=;
        b=ZDpEvGfKzWw6cwm0YM1T7Md0Nf7/8RVu+RbmZeNx8yAIziDj30ur11JmiWvUxSRzOR
         QvT0LOz1Gp2EdlLkdO47dAgo6MXp/LHQp45ucnHda6sc0KTm678tkgaZlIFhEyVUg37v
         9wUEyvE9EJxESqBa/ntUsNWE7Cx62LYTh9lI0N/oATuRLE+t4gDaWqF40ADdtbh5yZH3
         UdGW+ePfgBEjUlhEluH/WyN26gLEOR7cHURomiPPJEMKODJzAhwgbfBUWcrEJKDBXpFA
         MIcE9KRCDU526HjpiitnGrE1H866ecHZ7lREUR29tkrpJ/8iNmNkF9tvveVe/I9TUEi+
         mmAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=InYd1q+YUiZ+OtuTZaswYvG/hZu51QspPnytjgDA4O4=;
        b=pxHY7kd+QMK34gAavV/OMwqbODmlQxB/N9sVPvSnfKs7z+5YkMkq0noVRiM66rdhRB
         TbKgvatcmbQb/3fLwiW3eEnUXOxy2+bNdX5KvolNO0NooVX9vQGPIrCxXlfYKGJNXqVp
         Mx01MYbT8J33scb+iTpVrpRpQ8s+jusjE9VHhUBi+WCt7btkkmf+efHYBr68K3tFFrC3
         CvF2pm5/K9LEzvceldS0siWG1iZy/ZQ9nSLiFIk49fJeBQ3nf8r49U44ZWh/HS6/1fVq
         s1sStmT4MJUvR40spNrH9m4mw/PscgIMSEdbLfpI6fxosbtya4tuYOHBrRhDHYdTZAUw
         q0tA==
X-Gm-Message-State: AOAM5311uxaIPFLQnTarv8fK7ZFkDOJq+tyf9stIIjL4CjfhlMFSR+oH
        8KIhgpdDJYxT10NlGuUieejKDpxSgQM=
X-Google-Smtp-Source: ABdhPJyio2ogzQK8gGPGmDcj3pQ6jmgc0Hq0vF+VI7pdNmNB9/cnulxbfGP1Uw4OH3ySdJaXomDTXFf7wec=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:ad4:56f2:: with SMTP id cr18mr6496727qvb.62.1605730045387;
 Wed, 18 Nov 2020 12:07:25 -0800 (PST)
Date:   Wed, 18 Nov 2020 11:10:08 -0800
In-Reply-To: <20201118191009.3406652-1-weiwan@google.com>
Message-Id: <20201118191009.3406652-5-weiwan@google.com>
Mime-Version: 1.0
References: <20201118191009.3406652-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH net-next v3 4/5] net: modify kthread handler to use __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>, Wei Wang <weiwan@google.com>
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 62 +++++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a739dbbe4d89..88437cdf29f1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6840,6 +6840,15 @@ static int __napi_poll(struct napi_struct *n, bool *repoll)
 
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
@@ -6860,15 +6869,6 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
@@ -6897,40 +6897,26 @@ static int napi_thread_wait(struct napi_struct *napi)
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
2.29.2.454.gaff20da3a2-goog

