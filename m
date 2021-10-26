Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE48A43B2E6
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 15:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbhJZNJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbhJZNJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 09:09:26 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DC9C061767
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 06:07:02 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id m37-20020a4a9528000000b002b83955f771so4262399ooi.7
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 06:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=forshee.me; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bMO9aIZEjMzj+cHlABoe9RIyr+B9KaScU7qbVDmoSBU=;
        b=gs+ZGXEQlgMQw8l++1hUpXPBydjgeiTLOcEr0x4UZ0P2YBtOQW9Pb5DYjoj927k+1Y
         UXJRhbTriWliVVTFJvK74OWPMlbtHkV2JNvTzb2hrL6lMlsXU5zPqhh4nWb8JVqP1WBk
         s7XUR1HjdezHpAHa/CMU9f4ie2pcjajdxfM1X/HrRdmubWp7a1TXILI0+rIhkPtU/Ibi
         fVosNqtj1En3V0Ay3W6wlulz9tCiHPzjafhEyLM5o/rcko1cIQURuOfgPmZKmwFwgKcK
         zazGD0jmRxOX29lLM3blPnUgaAAWNeopcqSyMbmTqF6nTkhsFHIBX++x1/mxdn/6Dqn1
         rBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bMO9aIZEjMzj+cHlABoe9RIyr+B9KaScU7qbVDmoSBU=;
        b=sgRLb9XNnPFP4Jc7JWn6lrZ5+jJl4O63ikdM28wZBc03QqKDPOwBC/dU7bMbMUz/RW
         4E7PUsEHiH1tbDTM1pt9W6O12WAApeeXnY4u5e6wqCMQt3zzfDFlZOxsBabzB0W14EtO
         S9XDe1cCCE4BBUVcrF47PFKybYvvFgPXxQ1GhFx6Ghf+BsSTAuq6uLQ5JCSkfEONR9mO
         M5Rjuo/ixe1/Iqk/PElE7A8r1Sb1CifD8TjL/6QFZZD1gaF9NdL0AOdeF5BC8aaBndGH
         FFr9jwZsoLjFiC/fNtssvkd+JplBjwvzLDoXJ7k6auxfM8vDH8DZu0jEjNXVsmtrMBgO
         ftfA==
X-Gm-Message-State: AOAM530GVccfIyFBNaJ6K45t8lQ80csAKuOdfESOHq4LidUcEYauQThw
        L9pPC5DZ+RCDqTUQ189Pafmw0w==
X-Google-Smtp-Source: ABdhPJy2sHrfFA8jSlyLkeDUjCM5YfHBMuAAeutWAaVoHL1TBQCxYc1Q2cMU7HbI3XKbr/GzEzi76Q==
X-Received: by 2002:a05:6820:35a:: with SMTP id m26mr17338095ooe.45.1635253621041;
        Tue, 26 Oct 2021 06:07:01 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:fca3:95d3:b064:21ae])
        by smtp.gmail.com with ESMTPSA id bq10sm3090209oib.25.2021.10.26.06.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 06:07:00 -0700 (PDT)
From:   Seth Forshee <seth@forshee.me>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: sch: eliminate unnecessary RCU waits in mini_qdisc_pair_swap()
Date:   Tue, 26 Oct 2021 08:06:59 -0500
Message-Id: <20211026130700.121189-1-seth@forshee.me>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Seth Forshee <sforshee@digitalocean.com>

Currently rcu_barrier() is used to ensure that no readers of the
inactive mini_Qdisc buffer remain before it is reused. This waits for
any pending RCU callbacks to complete, when all that is actually
required is to wait for one RCU grace period to elapse after the buffer
was made inactive. This means that using rcu_barrier() may result in
unnecessary waits.

To improve this, store the current RCU state when a buffer is made
inactive and use poll_state_synchronize_rcu() to check whether a full
grace period has elapsed before reusing it. If a full grace period has
not elapsed, wait for a grace period to elapse, and in the non-RT case
use synchronize_rcu_expedited() to hasten it.

Since this approach eliminates the RCU callback it is no longer
necessary to synchronize_rcu() in the tp_head==NULL case. However, the
RCU state should still be saved for the previously active buffer.

Before this change I would typically see mini_qdisc_pair_swap() take
tens of milliseconds to complete. After this change it typcially
finishes in less than 1 ms, and often it takes just a few microseconds.

Thanks to Paul for walking me through the options for improving this.

Cc: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
---
v2:
 - Rebase to net-next

 include/net/sch_generic.h |  2 +-
 net/sched/sch_generic.c   | 38 +++++++++++++++++++-------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index ada02c4a4f51..22179b2fda72 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1302,7 +1302,7 @@ struct mini_Qdisc {
 	struct tcf_block *block;
 	struct gnet_stats_basic_sync __percpu *cpu_bstats;
 	struct gnet_stats_queue	__percpu *cpu_qstats;
-	struct rcu_head rcu;
+	unsigned long rcu_state;
 };
 
 static inline void mini_qdisc_bstats_cpu_update(struct mini_Qdisc *miniq,
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index b0ff0dff2773..24899efc51be 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1487,10 +1487,6 @@ void psched_ppscfg_precompute(struct psched_pktrate *r, u64 pktrate64)
 }
 EXPORT_SYMBOL(psched_ppscfg_precompute);
 
-static void mini_qdisc_rcu_func(struct rcu_head *head)
-{
-}
-
 void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
 			  struct tcf_proto *tp_head)
 {
@@ -1503,28 +1499,30 @@ void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
 
 	if (!tp_head) {
 		RCU_INIT_POINTER(*miniqp->p_miniq, NULL);
-		/* Wait for flying RCU callback before it is freed. */
-		rcu_barrier();
-		return;
-	}
+	} else {
+		miniq = !miniq_old || miniq_old == &miniqp->miniq2 ?
+			&miniqp->miniq1 : &miniqp->miniq2;
 
-	miniq = !miniq_old || miniq_old == &miniqp->miniq2 ?
-		&miniqp->miniq1 : &miniqp->miniq2;
+		/* We need to make sure that readers won't see the miniq
+		 * we are about to modify. So ensure that at least one RCU
+		 * grace period has elapsed since the miniq was made
+		 * inactive.
+		 */
+		if (IS_ENABLED(CONFIG_PREEMPT_RT))
+			cond_synchronize_rcu(miniq->rcu_state);
+		else if (!poll_state_synchronize_rcu(miniq->rcu_state))
+			synchronize_rcu_expedited();
 
-	/* We need to make sure that readers won't see the miniq
-	 * we are about to modify. So wait until previous call_rcu callback
-	 * is done.
-	 */
-	rcu_barrier();
-	miniq->filter_list = tp_head;
-	rcu_assign_pointer(*miniqp->p_miniq, miniq);
+		miniq->filter_list = tp_head;
+		rcu_assign_pointer(*miniqp->p_miniq, miniq);
+	}
 
 	if (miniq_old)
-		/* This is counterpart of the rcu barriers above. We need to
+		/* This is counterpart of the rcu sync above. We need to
 		 * block potential new user of miniq_old until all readers
 		 * are not seeing it.
 		 */
-		call_rcu(&miniq_old->rcu, mini_qdisc_rcu_func);
+		miniq_old->rcu_state = start_poll_synchronize_rcu();
 }
 EXPORT_SYMBOL(mini_qdisc_pair_swap);
 
@@ -1543,6 +1541,8 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 	miniqp->miniq1.cpu_qstats = qdisc->cpu_qstats;
 	miniqp->miniq2.cpu_bstats = qdisc->cpu_bstats;
 	miniqp->miniq2.cpu_qstats = qdisc->cpu_qstats;
+	miniqp->miniq1.rcu_state = get_state_synchronize_rcu();
+	miniqp->miniq2.rcu_state = miniqp->miniq1.rcu_state;
 	miniqp->p_miniq = p_miniq;
 }
 EXPORT_SYMBOL(mini_qdisc_pair_init);
-- 
2.30.2

