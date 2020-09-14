Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADAC269347
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINR1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgINR00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:26:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1715EC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e190so433325ybf.18
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=LYZ1+juOAoa/emu0bMvEoA7YWrA+PmRXyRdY+YEq8Tw=;
        b=O+YSkcEpuAZmFQfPD/KixyL1MdeWGfam/Ed3HgnOtiD19nRsM+q4hIJNZ8iYDCMXO2
         OJhS/UQ9yAQKswOrSJE1+layYfB8EHSM0LZCBEFM0qe7R+8cA8FCTTyqDQ6K5q7fmrvv
         1cIgi5hBumdLaHswaWxlWz2ErltL0lngGk8vM/jEeqnUXFvU8ibUfY9kBg2qoPv2BT6H
         6Z53xZdqI92Ng9VOmihDhUg9pELtMpnjrjKQZhx2lVOjGpoyCSz0q/GUaSHMMD8y6Ljx
         2ee1aDgP9frXEOGveJv4p3HePBWaE7qa2C3lCG+tZl1myP6jlZ4w64dITo90N/JDZVQU
         NQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LYZ1+juOAoa/emu0bMvEoA7YWrA+PmRXyRdY+YEq8Tw=;
        b=rvfio7kuGitLYBEYmVJ50iG/dzYKWXdzWdBHpgVPyn9vB7c6QKhEdalklI6COMu7z1
         dnThRUHh+BCzTWFJ0VhvsbL3zUV0YM2CMq+zxhuM2I4ZrX9iSj6aLzlxOMuV4EaNaABr
         NPUUs42QwfmfbdEDEoFomfMdHboDu1Sxm2R4CQ4pQWDkyq/hQ4LagGzMR1Ycv1bShyB3
         3rEIkz/v7QSuEisEsV91vAw/2Tt5F/u+4LEm+96uSSeIbuHwvg709i/8hwpd2e8qYbf4
         wjQTXJ35ciIlOabU6TUfcXNV6o/by6lvSfT4MZbSNafGi2zie4fkSiYllBz+TqKjZnsp
         f5Vg==
X-Gm-Message-State: AOAM5326S/2RiJIhieq4MpqxWn2L3oviE0YgyKO/RIphMpsKATVYEKuX
        oB3aPdxzCPDk7ZZkxz8NpjFpDl/qBps=
X-Google-Smtp-Source: ABdhPJzEDpRe07jBYHx33+e1peTFcjdq7HiVHjsAcCt51s3ColGJm2b58l6xOeggCjSPidNXsF0UTCaMdp8=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:f20d:: with SMTP id i13mr20998124ybe.152.1600104385278;
 Mon, 14 Sep 2020 10:26:25 -0700 (PDT)
Date:   Mon, 14 Sep 2020 10:24:51 -0700
In-Reply-To: <20200914172453.1833883-1-weiwan@google.com>
Message-Id: <20200914172453.1833883-5-weiwan@google.com>
Mime-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [RFC PATCH net-next 4/6] net: modify kthread handler to use __napi_poll()
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
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
index bc2a7681b239..be676c21bdc4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6763,6 +6763,15 @@ static int __napi_poll(struct napi_struct *n, bool *repoll)
 
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
@@ -6783,15 +6792,6 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
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
@@ -6820,40 +6820,26 @@ static int napi_thread_wait(struct napi_struct *napi)
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
2.28.0.618.gf4bc123cb7-goog

