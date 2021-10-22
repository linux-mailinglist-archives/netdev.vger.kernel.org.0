Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1290437AC8
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbhJVQUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbhJVQUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:20:06 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8239C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 09:17:48 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id bk18so5626857oib.8
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 09:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=forshee.me; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qEG5uMlDEShJNnOz6XnTDSYbhgHxWBxfy3mReuFm6cQ=;
        b=mXPIXez/Gt5I16UP8ypVFahbxUTpy2dhUrkBfAMhRIvIqRDRFqoOuIlv6n3qlHqGVU
         0jTzMUBcgoLG1xhF/dC/HXkzW5iJux0c9zWSKtKZxtAoCw8jdxr/cyzShYW5MTcjelFX
         BAciEDlglgW5id63BU2Oak+Acj7MI8isU0QGx+SZN3deHn0bjdhGuafa2oWMV1smpONl
         4aL8rmN7iNqcpdFo/J2DIzQnYIVcvTrSgTnJip9qwi7ISMdObCzjZ+zpFLZkI9RkX0V7
         hfpKwRS5Kts/1Cde50S68s8Ejy6A+1/2Q4yRXgCmXT3IdhahZwr4/1Arv4113cql6i0O
         Zdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qEG5uMlDEShJNnOz6XnTDSYbhgHxWBxfy3mReuFm6cQ=;
        b=o7HJc+WY7GqAUNTjassZyXW6TgP8k3E270roz4S1eu9KwRDqsMdBeDRgScFObWrEg/
         5ihy4CVZ0/ccHgh8ltUGUBzYlhTDQMrUE0jmfren1Nt4OGOA+Q3BQvAFbijbFzo0NfWP
         ZJrW6ZHSWG7Zzfc4E5qwkQXaUQQueOTw6zWF7lapT3Rb4eDptsVnv5KmgXRy+XG7Tz68
         jdOxFOO23NxM+ZO8cKoJNzffA06EsjIGxUj9F1iQlAoHkqnfpwZOTR0o3Rv318DPJHKU
         AdHo/C3YZZgYBgUxGnrFeyfMts1YqGJUlYLXKu43roTfET+O1SO5wUcF6AFwCh58UmDU
         9qtg==
X-Gm-Message-State: AOAM5317trdo7lEVuf85s+8oZ6VnfSv8+YEPYzF3nx+ixL3gWRrowNeO
        k5k4NJ3DLMvltDFAxJwch1VX5w==
X-Google-Smtp-Source: ABdhPJzNXWFBSCHxbdsHSZ4ijP9y2TtQiwlL4DJ/yhHj2fQflSHhrfPdmVGUEz8jUoJvfa40o4DneA==
X-Received: by 2002:a05:6808:1246:: with SMTP id o6mr481376oiv.136.1634919468070;
        Fri, 22 Oct 2021 09:17:48 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:12a9:d5f6:9bd1:6937])
        by smtp.gmail.com with ESMTPSA id f10sm1712446otl.57.2021.10.22.09.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 09:17:47 -0700 (PDT)
From:   Seth Forshee <seth@forshee.me>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sch: eliminate unnecessary RCU waits in mini_qdisc_pair_swap()
Date:   Fri, 22 Oct 2021 11:17:46 -0500
Message-Id: <20211022161747.81609-1-seth@forshee.me>
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
 include/net/sch_generic.h |  2 +-
 net/sched/sch_generic.c   | 38 +++++++++++++++++++-------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f8631ad3c868..c725464be814 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1299,7 +1299,7 @@ struct mini_Qdisc {
 	struct tcf_block *block;
 	struct gnet_stats_basic_cpu __percpu *cpu_bstats;
 	struct gnet_stats_queue	__percpu *cpu_qstats;
-	struct rcu_head rcu;
+	unsigned long rcu_state;
 };
 
 static inline void mini_qdisc_bstats_cpu_update(struct mini_Qdisc *miniq,
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 854d2b38db85..8540c12c9a62 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1407,10 +1407,6 @@ void psched_ratecfg_precompute(struct psched_ratecfg *r,
 }
 EXPORT_SYMBOL(psched_ratecfg_precompute);
 
-static void mini_qdisc_rcu_func(struct rcu_head *head)
-{
-}
-
 void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
 			  struct tcf_proto *tp_head)
 {
@@ -1423,28 +1419,30 @@ void mini_qdisc_pair_swap(struct mini_Qdisc_pair *miniqp,
 
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
 
@@ -1463,6 +1461,8 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
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

