Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DEA280909
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbgJAVDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:03:15 -0400
Received: from goliath.siemens.de ([192.35.17.28]:55485 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387429AbgJAVDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:03:15 -0400
Received: from mail3.siemens.de (mail3.siemens.de [139.25.208.14])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 091KqJ5M009276
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 22:52:19 +0200
Received: from tsnlaptop.atstm41.nbgm.siemens.de ([144.145.220.50])
        by mail3.siemens.de (8.15.2/8.15.2) with ESMTP id 091KpxYY027868;
        Thu, 1 Oct 2020 22:52:18 +0200
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
Subject: [PATCH 5/7] Traffic control using high-resolution timer issue
Date:   Thu,  1 Oct 2020 22:51:39 +0200
Message-Id: <20201001205141.8885-6-erez.geva.ext@siemens.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201001205141.8885-1-erez.geva.ext@siemens.com>
References: <20201001205141.8885-1-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - Add new schedule function for Qdisc watchdog.
    The function avoids reprogram if watchdog already expire
    before new expire.

  - Use new schedule function in ETF.

  - Add ETF range value to kernel configuration.
    as the value is characteristic to Hardware.

Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
---
 include/net/pkt_sched.h |  2 ++
 net/sched/Kconfig       |  8 ++++++++
 net/sched/sch_api.c     | 33 +++++++++++++++++++++++++++++++++
 net/sched/sch_etf.c     | 10 ++++++++--
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index ac8c890a2657..4306c2773778 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -78,6 +78,8 @@ void qdisc_watchdog_init(struct qdisc_watchdog *wd, struct Qdisc *qdisc);
 
 void qdisc_watchdog_schedule_range_ns(struct qdisc_watchdog *wd, u64 expires,
 				      u64 delta_ns);
+void qdisc_watchdog_schedule_soon_ns(struct qdisc_watchdog *wd, u64 expires,
+				     u64 delta_ns);
 
 static inline void qdisc_watchdog_schedule_ns(struct qdisc_watchdog *wd,
 					      u64 expires)
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..0f5261ee9e1b 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -195,6 +195,14 @@ config NET_SCH_ETF
 	  To compile this code as a module, choose M here: the
 	  module will be called sch_etf.
 
+config NET_SCH_ETF_TIMER_RANGE
+	int "ETF Watchdog time range delta in nano seconds"
+	depends on NET_SCH_ETF
+	default 5000
+	help
+	  Specify the time range delta for ETF watchdog
+	  Default is 5 microsecond
+
 config NET_SCH_TAPRIO
 	tristate "Time Aware Priority (taprio) Scheduler"
 	help
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index ebf59ca1faab..80bd09555f5e 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -645,6 +645,39 @@ void qdisc_watchdog_schedule_range_ns(struct qdisc_watchdog *wd, u64 expires,
 }
 EXPORT_SYMBOL(qdisc_watchdog_schedule_range_ns);
 
+void qdisc_watchdog_schedule_soon_ns(struct qdisc_watchdog *wd, u64 expires,
+				     u64 delta_ns)
+{
+	if (test_bit(__QDISC_STATE_DEACTIVATED,
+		     &qdisc_root_sleeping(wd->qdisc)->state))
+		return;
+
+	if (wd->last_expires == expires)
+		return;
+
+	/**
+	 * If expires is in [0, now + delta_ns],
+	 * do not program it.
+	 */
+	if (expires <= ktime_to_ns(hrtimer_cb_get_time(&wd->timer)) + delta_ns)
+		return;
+
+	/**
+	 * If timer is already set in [0, expires + delta_ns],
+	 * do not reprogram it.
+	 */
+	if (hrtimer_is_queued(&wd->timer) &&
+	    wd->last_expires <= expires + delta_ns)
+		return;
+
+	wd->last_expires = expires;
+	hrtimer_start_range_ns(&wd->timer,
+			       ns_to_ktime(expires),
+			       delta_ns,
+			       HRTIMER_MODE_ABS_PINNED);
+}
+EXPORT_SYMBOL(qdisc_watchdog_schedule_soon_ns);
+
 void qdisc_watchdog_cancel(struct qdisc_watchdog *wd)
 {
 	hrtimer_cancel(&wd->timer);
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index c48f91075b5c..48b2868c4672 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -20,6 +20,11 @@
 #include <net/pkt_sched.h>
 #include <net/sock.h>
 
+#ifdef CONFIG_NET_SCH_ETF_TIMER_RANGE
+#define NET_SCH_ETF_TIMER_RANGE CONFIG_NET_SCH_ETF_TIMER_RANGE
+#else
+#define NET_SCH_ETF_TIMER_RANGE (5 * NSEC_PER_USEC)
+#endif
 #define DEADLINE_MODE_IS_ON(x) ((x)->flags & TC_ETF_DEADLINE_MODE_ON)
 #define OFFLOAD_IS_ON(x) ((x)->flags & TC_ETF_OFFLOAD_ON)
 #define SKIP_SOCK_CHECK_IS_SET(x) ((x)->flags & TC_ETF_SKIP_SOCK_CHECK)
@@ -128,8 +133,9 @@ static void reset_watchdog(struct Qdisc *sch)
 		return;
 	}
 
-	next = ktime_sub_ns(skb->tstamp, q->delta);
-	qdisc_watchdog_schedule_ns(&q->watchdog, ktime_to_ns(next));
+	next = ktime_sub_ns(skb->tstamp, q->delta + NET_SCH_ETF_TIMER_RANGE);
+	qdisc_watchdog_schedule_soon_ns(&q->watchdog, ktime_to_ns(next),
+					NET_SCH_ETF_TIMER_RANGE);
 }
 
 static void report_sock_error(struct sk_buff *skb, u32 err, u8 code)
-- 
2.20.1

