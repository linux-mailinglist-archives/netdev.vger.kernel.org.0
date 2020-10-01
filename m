Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5C280934
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387403AbgJAVIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:08:23 -0400
Received: from thoth.sbs.de ([192.35.17.2]:57031 "EHLO thoth.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgJAVIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:08:21 -0400
Received: from mail3.siemens.de (mail3.siemens.de [139.25.208.14])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id 091KqPvE024446
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 22:52:25 +0200
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.50])
        by mail3.siemens.de (8.15.2/8.15.2) with ESMTP id 091KpxYa027868;
        Thu, 1 Oct 2020 22:52:24 +0200
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
Subject: [PATCH 7/7] TC-ETF support PTP clocks
Date:   Thu,  1 Oct 2020 22:51:41 +0200
Message-Id: <20201001205141.8885-8-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201001205141.8885-1-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - Add support for using a POSIX dynamic clock with
    Traffic control Earliest TxTime First (ETF) Qdisc.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 include/uapi/linux/net_tstamp.h |   5 ++
 net/sched/sch_etf.c             | 100 +++++++++++++++++++++++++++++---
 2 files changed, 97 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index 7ed0b3d1c00a..ecbaac6230d7 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -167,6 +167,11 @@ enum txtime_flags {
 	SOF_TXTIME_FLAGS_MASK = (SOF_TXTIME_FLAGS_LAST - 1) |
 				 SOF_TXTIME_FLAGS_LAST
 };
+/*
+ * Clock ID to use with POSIX clocks
+ * The ID must be u8 to fit in (struct sock)->sk_clockid
+ */
+#define SOF_TXTIME_POSIX_CLOCK_ID (0x77)
 
 struct sock_txtime {
 	__kernel_clockid_t	clockid;/* reference clockid */
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index c0de4c6f9299..8e3e0a61fa58 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -15,6 +15,7 @@
 #include <linux/rbtree.h>
 #include <linux/skbuff.h>
 #include <linux/posix-timers.h>
+#include <linux/posix-clock.h>
 #include <net/netlink.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
@@ -40,19 +41,40 @@ struct etf_sched_data {
 	struct rb_root_cached head;
 	struct qdisc_watchdog watchdog;
 	ktime_t (*get_time)(void);
+#ifdef CONFIG_POSIX_TIMERS
+	struct posix_clock *pclock; /* pointer to a posix clock */
+#endif /* CONFIG_POSIX_TIMERS */
 };
 
 static const struct nla_policy etf_policy[TCA_ETF_MAX + 1] = {
 	[TCA_ETF_PARMS]	= { .len = sizeof(struct tc_etf_qopt) },
 };
 
+static inline ktime_t get_now(struct Qdisc *sch, struct etf_sched_data *q)
+{
+#ifdef CONFIG_POSIX_TIMERS
+	if (IS_ERR_OR_NULL(q->get_time)) {
+		struct timespec64 ts;
+		int err = posix_clock_gettime(q->pclock, &ts);
+
+		if (err) {
+			pr_warn("Clock is disabled (%d) for queue %d\n",
+				err, q->queue);
+			return 0;
+		}
+		return timespec64_to_ktime(ts);
+	}
+#endif /* CONFIG_POSIX_TIMERS */
+	return q->get_time();
+}
+
 static inline int validate_input_params(struct tc_etf_qopt *qopt,
 					struct netlink_ext_ack *extack)
 {
 	/* Check if params comply to the following rules:
 	 *	* Clockid and delta must be valid.
 	 *
-	 *	* Dynamic clockids are not supported.
+	 *	* Dynamic CPU clockids are not supported.
 	 *
 	 *	* Delta must be a positive or zero integer.
 	 *
@@ -60,11 +82,22 @@ static inline int validate_input_params(struct tc_etf_qopt *qopt,
 	 * expect that system clocks have been synchronized to PHC.
 	 */
 	if (qopt->clockid < 0) {
+#ifdef CONFIG_POSIX_TIMERS
+		/**
+		 * Use of PTP clock through a posix clock.
+		 * The TC application must open the posix clock device file
+		 * and use the dynamic clockid from the file description.
+		 */
+		if (!is_clockid_fd_clock(qopt->clockid)) {
+			NL_SET_ERR_MSG(extack,
+				       "Dynamic CPU clockids are not supported");
+			return -EOPNOTSUPP;
+		}
+#else /* CONFIG_POSIX_TIMERS */
 		NL_SET_ERR_MSG(extack, "Dynamic clockids are not supported");
 		return -ENOTSUPP;
-	}
-
-	if (qopt->clockid != CLOCK_TAI) {
+#endif /* CONFIG_POSIX_TIMERS */
+	} else if (qopt->clockid != CLOCK_TAI) {
 		NL_SET_ERR_MSG(extack, "Invalid clockid. CLOCK_TAI must be used");
 		return -EINVAL;
 	}
@@ -103,7 +136,7 @@ static bool is_packet_valid(struct Qdisc *sch, struct etf_sched_data *q,
 		return false;
 
 skip:
-	now = q->get_time();
+	now = get_now(sch, q);
 	if (ktime_before(txtime, now) || ktime_before(txtime, q->last))
 		return false;
 
@@ -133,6 +166,27 @@ static void reset_watchdog(struct Qdisc *sch, struct etf_sched_data *q)
 	}
 
 	next = ktime_sub_ns(skb->tstamp, q->delta + NET_SCH_ETF_TIMER_RANGE);
+#ifdef CONFIG_POSIX_TIMERS
+	if (!IS_ERR_OR_NULL(q->pclock)) {
+		s64 now;
+		struct timespec64 ts;
+		int err = posix_clock_gettime(q->pclock, &ts);
+
+		if (err) {
+			pr_warn("Clock is disabled (%d) for queue %d\n",
+				err, q->queue);
+			return;
+		}
+		now = timespec64_to_ns(&ts);
+		if (now == 0) {
+			pr_warn("Clock is not running for queue %d\n",
+				q->queue);
+			return;
+		}
+		/* Convert PHC to CLOCK_TAI as that is the timer clock */
+		next = ktime_add(next, ktime_sub_ns(ktime_get_clocktai(), now));
+	}
+#endif /* CONFIG_POSIX_TIMERS */
 	qdisc_watchdog_schedule_soon_ns(&q->watchdog, ktime_to_ns(next),
 					NET_SCH_ETF_TIMER_RANGE);
 }
@@ -263,7 +317,7 @@ static struct sk_buff *etf_dequeue_timesortedlist(struct Qdisc *sch)
 	if (!skb)
 		return NULL;
 
-	now = q->get_time();
+	now = get_now(sch, q);
 
 	/* Drop if packet has expired while in queue. */
 	if (ktime_before(skb->tstamp, now)) {
@@ -354,6 +408,7 @@ static int etf_init(struct Qdisc *sch, struct nlattr *opt,
 	struct nlattr *tb[TCA_ETF_MAX + 1];
 	struct tc_etf_qopt *qopt;
 	int err;
+	clockid_t clockid;
 
 	if (!opt) {
 		NL_SET_ERR_MSG(extack,
@@ -391,13 +446,17 @@ static int etf_init(struct Qdisc *sch, struct nlattr *opt,
 	}
 
 	/* Everything went OK, save the parameters used. */
+	clockid = qopt->clockid;
 	q->delta = qopt->delta;
 	q->clockid = qopt->clockid;
 	q->offload = OFFLOAD_IS_ON(qopt);
 	q->deadline_mode = DEADLINE_MODE_IS_ON(qopt);
 	q->skip_sock_check = SKIP_SOCK_CHECK_IS_SET(qopt);
+#ifdef CONFIG_POSIX_TIMERS
+	q->pclock = NULL;
+#endif /* CONFIG_POSIX_TIMERS */
 
-	switch (q->clockid) {
+	switch (clockid) {
 	case CLOCK_REALTIME:
 		q->get_time = ktime_get_real;
 		break;
@@ -411,11 +470,31 @@ static int etf_init(struct Qdisc *sch, struct nlattr *opt,
 		q->get_time = ktime_get_clocktai;
 		break;
 	default:
+#ifdef CONFIG_POSIX_TIMERS
+		q->pclock = posix_clock_get_clock(clockid);
+		if (IS_ERR_OR_NULL(q->pclock)) {
+			NL_SET_ERR_MSG(extack, "Clockid does not exist");
+			return PTR_ERR(q->pclock);
+		}
+		q->clockid = SOF_TXTIME_POSIX_CLOCK_ID;
+		/**
+		 * Posix clocks do not support high-resolution timers
+		 * Using the TAI clock is close enough (for relative sleeps)
+		 */
+		clockid = CLOCK_TAI;
+		/**
+		 * Posix clock do not provide direct ktime function
+		 * We need to call posix_clock_gettime()
+		 */
+		q->get_time = NULL;
+		break;
+#else /* CONFIG_POSIX_TIMERS */
 		NL_SET_ERR_MSG(extack, "Clockid is not supported");
 		return -ENOTSUPP;
+#endif /* CONFIG_POSIX_TIMERS */
 	}
 
-	qdisc_watchdog_init_clockid(&q->watchdog, sch, q->clockid);
+	qdisc_watchdog_init_clockid(&q->watchdog, sch, clockid);
 
 	return 0;
 }
@@ -463,6 +542,11 @@ static void etf_destroy(struct Qdisc *sch)
 		qdisc_watchdog_cancel(&q->watchdog);
 
 	etf_disable_offload(dev, q);
+#ifdef CONFIG_POSIX_TIMERS
+	/* Release posix clock */
+	if (!IS_ERR_OR_NULL(q->pclock))
+		posix_clock_put_clock(q->pclock);
+#endif /* CONFIG_POSIX_TIMERS */
 }
 
 static int etf_dump(struct Qdisc *sch, struct sk_buff *skb)
-- 
2.20.1

