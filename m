Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC229280931
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733216AbgJAVIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:08:15 -0400
Received: from thoth.sbs.de ([192.35.17.2]:56967 "EHLO thoth.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgJAVIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:08:14 -0400
Received: from mail3.siemens.de (mail3.siemens.de [139.25.208.14])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id 091KqMDn024403
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 22:52:22 +0200
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.50])
        by mail3.siemens.de (8.15.2/8.15.2) with ESMTP id 091KpxYZ027868;
        Thu, 1 Oct 2020 22:52:21 +0200
From:   Erez Geva <erez.geva.ext@siemens.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Andreas Bucher <andreas.bucher@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andreas Zirkler <andreas.zirkler@siemens.com>,
        Ermin Sakic <ermin.sakic@siemens.com>,
        An Ninh Nguyen <anninh.nguyen@siemens.com>,
        Michael Saenger <michael.saenger@siemens.com>,
        Bernd Maehringer <bernd.maehringer@siemens.com>,
        Gisela Greinert <gisela.greinert@siemens.com>,
        Erez Geva <erez.geva.ext@siemens.com>,
        Erez Geva <ErezGeva2@gmail.com>
Subject: [PATCH 6/7] TC-ETF code improvements
Date:   Thu,  1 Oct 2020 22:51:40 +0200
Message-Id: <20201001205141.8885-7-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201001205141.8885-1-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - Change clockid to use clockid_t type.

  - Pass pointer to ETF private structure to
    local function instead of retrieving it
    from Qdisc object again.

  - fix comment.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 net/sched/sch_etf.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index 48b2868c4672..c0de4c6f9299 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -33,7 +33,7 @@ struct etf_sched_data {
 	bool offload;
 	bool deadline_mode;
 	bool skip_sock_check;
-	int clockid;
+	clockid_t clockid;
 	int queue;
 	s32 delta; /* in ns */
 	ktime_t last; /* The txtime of the last skb sent to the netdevice. */
@@ -54,7 +54,7 @@ static inline int validate_input_params(struct tc_etf_qopt *qopt,
 	 *
 	 *	* Dynamic clockids are not supported.
 	 *
-	 *	* Delta must be a positive integer.
+	 *	* Delta must be a positive or zero integer.
 	 *
 	 * Also note that for the HW offload case, we must
 	 * expect that system clocks have been synchronized to PHC.
@@ -77,9 +77,9 @@ static inline int validate_input_params(struct tc_etf_qopt *qopt,
 	return 0;
 }
 
-static bool is_packet_valid(struct Qdisc *sch, struct sk_buff *nskb)
+static bool is_packet_valid(struct Qdisc *sch, struct etf_sched_data *q,
+			    struct sk_buff *nskb)
 {
-	struct etf_sched_data *q = qdisc_priv(sch);
 	ktime_t txtime = nskb->tstamp;
 	struct sock *sk = nskb->sk;
 	ktime_t now;
@@ -122,9 +122,8 @@ static struct sk_buff *etf_peek_timesortedlist(struct Qdisc *sch)
 	return rb_to_skb(p);
 }
 
-static void reset_watchdog(struct Qdisc *sch)
+static void reset_watchdog(struct Qdisc *sch, struct etf_sched_data *q)
 {
-	struct etf_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb = etf_peek_timesortedlist(sch);
 	ktime_t next;
 
@@ -173,7 +172,7 @@ static int etf_enqueue_timesortedlist(struct sk_buff *nskb, struct Qdisc *sch,
 	ktime_t txtime = nskb->tstamp;
 	bool leftmost = true;
 
-	if (!is_packet_valid(sch, nskb)) {
+	if (!is_packet_valid(sch, q, nskb)) {
 		report_sock_error(nskb, EINVAL,
 				  SO_EE_CODE_TXTIME_INVALID_PARAM);
 		return qdisc_drop(nskb, sch, to_free);
@@ -198,15 +197,14 @@ static int etf_enqueue_timesortedlist(struct sk_buff *nskb, struct Qdisc *sch,
 	sch->q.qlen++;
 
 	/* Now we may need to re-arm the qdisc watchdog for the next packet. */
-	reset_watchdog(sch);
+	reset_watchdog(sch, q);
 
 	return NET_XMIT_SUCCESS;
 }
 
-static void timesortedlist_drop(struct Qdisc *sch, struct sk_buff *skb,
-				ktime_t now)
+static void timesortedlist_drop(struct Qdisc *sch, struct etf_sched_data *q,
+				struct sk_buff *skb, ktime_t now)
 {
-	struct etf_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *to_free = NULL;
 	struct sk_buff *tmp = NULL;
 
@@ -234,10 +232,9 @@ static void timesortedlist_drop(struct Qdisc *sch, struct sk_buff *skb,
 	kfree_skb_list(to_free);
 }
 
-static void timesortedlist_remove(struct Qdisc *sch, struct sk_buff *skb)
+static void timesortedlist_remove(struct Qdisc *sch, struct etf_sched_data *q,
+				  struct sk_buff *skb)
 {
-	struct etf_sched_data *q = qdisc_priv(sch);
-
 	rb_erase_cached(&skb->rbnode, &q->head);
 
 	/* The rbnode field in the skb re-uses these fields, now that
@@ -270,7 +267,7 @@ static struct sk_buff *etf_dequeue_timesortedlist(struct Qdisc *sch)
 
 	/* Drop if packet has expired while in queue. */
 	if (ktime_before(skb->tstamp, now)) {
-		timesortedlist_drop(sch, skb, now);
+		timesortedlist_drop(sch, q, skb, now);
 		skb = NULL;
 		goto out;
 	}
@@ -279,7 +276,7 @@ static struct sk_buff *etf_dequeue_timesortedlist(struct Qdisc *sch)
 	 * txtime from deadline to (now + delta).
 	 */
 	if (q->deadline_mode) {
-		timesortedlist_remove(sch, skb);
+		timesortedlist_remove(sch, q, skb);
 		skb->tstamp = now;
 		goto out;
 	}
@@ -288,13 +285,13 @@ static struct sk_buff *etf_dequeue_timesortedlist(struct Qdisc *sch)
 
 	/* Dequeue only if now is within the [txtime - delta, txtime] range. */
 	if (ktime_after(now, next))
-		timesortedlist_remove(sch, skb);
+		timesortedlist_remove(sch, q, skb);
 	else
 		skb = NULL;
 
 out:
 	/* Now we may need to re-arm the qdisc watchdog for the next packet. */
-	reset_watchdog(sch);
+	reset_watchdog(sch, q);
 
 	return skb;
 }
@@ -423,9 +420,8 @@ static int etf_init(struct Qdisc *sch, struct nlattr *opt,
 	return 0;
 }
 
-static void timesortedlist_clear(struct Qdisc *sch)
+static void timesortedlist_clear(struct Qdisc *sch, struct etf_sched_data *q)
 {
-	struct etf_sched_data *q = qdisc_priv(sch);
 	struct rb_node *p = rb_first_cached(&q->head);
 
 	while (p) {
@@ -448,7 +444,7 @@ static void etf_reset(struct Qdisc *sch)
 		qdisc_watchdog_cancel(&q->watchdog);
 
 	/* No matter which mode we are on, it's safe to clear both lists. */
-	timesortedlist_clear(sch);
+	timesortedlist_clear(sch, q);
 	__qdisc_reset_queue(&sch->q);
 
 	sch->qstats.backlog = 0;
-- 
2.20.1

