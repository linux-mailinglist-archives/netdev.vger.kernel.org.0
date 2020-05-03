Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E561C296D
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 04:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgECCyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 22:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726737AbgECCyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 22:54:35 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394CFC061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 19:54:34 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id e44so16396516qta.9
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 19:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YiPWzu6JN+jioGoB8E1wQWY8w8NLrEX8+vsGogqxbCM=;
        b=Gs3mk1jNIRPcTVw+B0Yg173vLtnwADJQJU2MlzGM7ktAcKPcWAv5aSARy5uoO2Nrg7
         IXXKCPqGurpBQM6iOREFsghukgYfrPPtnX6ERF8Hc3ElZgClEPfLL0bjeZMqhH6lqecd
         0p77njPc4mrA7jGhNQDr/QMVyJDTsfnO22Jvah6Eew3Eu2znVO0U5RSqy/r5FWZL38rY
         Pk1asD7nAOFOWYeUWX8NXMP+7FZkBGz+0s+BD6dS5m0ki6VWh38QZt+9NA2biUnPG/ru
         y0acK0rK4GlqSRXVClQTXqIFA9rBB5Now0v/S48UVhtbI4lEMTzCLsSV1Vrr0oCXr21u
         tYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YiPWzu6JN+jioGoB8E1wQWY8w8NLrEX8+vsGogqxbCM=;
        b=EB3+J7QiKDSTome1DF867S5/azatrm83Twldughzq9wVjKyGxxf4P5QNWV8Py/3sMq
         dN0ivDXQ9hVy7Mzw1cABFgOrYuow3TMi7/DEsexV7aL+jwgPhHUiIbJaftD+5tGbVGOb
         t64f/LFCXZD0Sx/3Wmkl4sWF5l2yMcKzW4kA0gahnLpkt0cisbnazdvod/VjHRml3SfT
         A4y1KNGUkX09kw6ZaqsbQ3U9ZA3qre1s1Xsg0AsA+ZNEhu8pxrNjRKdEYg6YYuudKXgr
         1bvc5UO52bjua57NxRTyIuoSwv6hWUNAplxXZquzUgEre95JvZGfTZ/YnSvdpY0p8Vb+
         ywOg==
X-Gm-Message-State: AGi0PuZ6Q6BwZl0nepQmz3sSWL4XZ9rqgJxrZZcMf47cv/6+wS3EH1BL
        hrH6xWDqi6+P6818xkHoITAIHieasELRMA==
X-Google-Smtp-Source: APiQypLB5Afk5mNvtoH1pfut7HpZofJUQ2Tq5yq/MrvJlpXOVW0SZ0/UeMd0aJlKFOAV+Rsdl/EcuvpPGl845A==
X-Received: by 2002:a0c:b5dd:: with SMTP id o29mr11033615qvf.87.1588474473375;
 Sat, 02 May 2020 19:54:33 -0700 (PDT)
Date:   Sat,  2 May 2020 19:54:20 -0700
In-Reply-To: <20200503025422.219257-1-edumazet@google.com>
Message-Id: <20200503025422.219257-4-edumazet@google.com>
Mime-Version: 1.0
References: <20200503025422.219257-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 3/5] net_sched: sch_fq: use bulk freeing in fq_gc()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fq_gc() already builds a small array of pointers, so using
kmem_cache_free_bulk() needs very little change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 7a2b3195938ede3c14c37b90c9604185cfa3f651..56e4f3c4380c517136b22862771f9899a7fd99f2 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -218,9 +218,10 @@ static void fq_gc(struct fq_sched_data *q,
 		  struct rb_root *root,
 		  struct sock *sk)
 {
-	struct fq_flow *f, *tofree[FQ_GC_MAX];
 	struct rb_node **p, *parent;
-	int fcnt = 0;
+	void *tofree[FQ_GC_MAX];
+	struct fq_flow *f;
+	int i, fcnt = 0;
 
 	p = &root->rb_node;
 	parent = NULL;
@@ -243,15 +244,18 @@ static void fq_gc(struct fq_sched_data *q,
 			p = &parent->rb_left;
 	}
 
-	q->flows -= fcnt;
-	q->inactive_flows -= fcnt;
-	q->stat_gc_flows += fcnt;
-	while (fcnt) {
-		struct fq_flow *f = tofree[--fcnt];
+	if (!fcnt)
+		return;
 
+	for (i = fcnt; i > 0; ) {
+		f = tofree[--i];
 		rb_erase(&f->fq_node, root);
-		kmem_cache_free(fq_flow_cachep, f);
 	}
+	q->flows -= fcnt;
+	q->inactive_flows -= fcnt;
+	q->stat_gc_flows += fcnt;
+
+	kmem_cache_free_bulk(fq_flow_cachep, fcnt, tofree);
 }
 
 static struct fq_flow *fq_classify(struct sk_buff *skb, struct fq_sched_data *q)
-- 
2.26.2.526.g744177e7f7-goog

