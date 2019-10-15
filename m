Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFE5D73CB
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 12:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbfJOKtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 06:49:10 -0400
Received: from foss.arm.com ([217.140.110.172]:35152 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731088AbfJOKtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 06:49:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13C541000;
        Tue, 15 Oct 2019 03:49:09 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4B0163F68E;
        Tue, 15 Oct 2019 03:49:04 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [PATCH v5 3/6] timekeeping: Add clocksource to system_time_snapshot
Date:   Tue, 15 Oct 2019 18:48:19 +0800
Message-Id: <20191015104822.13890-4-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191015104822.13890-1-jianyong.wu@arm.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes, we need check current clocksource outside of
timekeeping area. Add clocksource to system_time_snapshot then
we can get clocksource as well as system time.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/timekeeping.h | 35 ++++++++++++++++++-----------------
 kernel/time/timekeeping.c   |  7 ++++---
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index a8ab0f143ac4..964c14fbbf69 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -194,23 +194,6 @@ extern bool timekeeping_rtc_skipresume(void);
 
 extern void timekeeping_inject_sleeptime64(const struct timespec64 *delta);
 
-/*
- * struct system_time_snapshot - simultaneous raw/real time capture with
- *	counter value
- * @cycles:	Clocksource counter value to produce the system times
- * @real:	Realtime system time
- * @raw:	Monotonic raw system time
- * @clock_was_set_seq:	The sequence number of clock was set events
- * @cs_was_changed_seq:	The sequence number of clocksource change events
- */
-struct system_time_snapshot {
-	u64		cycles;
-	ktime_t		real;
-	ktime_t		raw;
-	unsigned int	clock_was_set_seq;
-	u8		cs_was_changed_seq;
-};
-
 /*
  * struct system_device_crosststamp - system/device cross-timestamp
  *	(syncronized capture)
@@ -236,6 +219,24 @@ struct system_counterval_t {
 	struct clocksource	*cs;
 };
 
+/*
+ * struct system_time_snapshot - simultaneous raw/real time capture with
+ *	counter value
+ * @sc:		Contains clocksource and clocksource counter value to produce
+ * 	the system times
+ * @real:	Realtime system time
+ * @raw:	Monotonic raw system time
+ * @clock_was_set_seq:	The sequence number of clock was set events
+ * @cs_was_changed_seq:	The sequence number of clocksource change events
+ */
+struct system_time_snapshot {
+	struct system_counterval_t sc;
+	ktime_t		real;
+	ktime_t		raw;
+	unsigned int	clock_was_set_seq;
+	u8		cs_was_changed_seq;
+};
+
 /*
  * Get cross timestamp between system clock and device clock
  */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 44b726bab4bd..66ff089605b3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -983,7 +983,8 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
 		nsec_raw  = timekeeping_cycles_to_ns(&tk->tkr_raw, now);
 	} while (read_seqcount_retry(&tk_core.seq, seq));
 
-	systime_snapshot->cycles = now;
+	systime_snapshot->sc.cycles = now;
+	systime_snapshot->sc.cs = tk->tkr_mono.clock;
 	systime_snapshot->real = ktime_add_ns(base_real, nsec_real);
 	systime_snapshot->raw = ktime_add_ns(base_raw, nsec_raw);
 }
@@ -1189,12 +1190,12 @@ int get_device_system_crosststamp(int (*get_time_fn)
 		 * clocksource change
 		 */
 		if (!history_begin ||
-		    !cycle_between(history_begin->cycles,
+		    !cycle_between(history_begin->sc.cycles,
 				   system_counterval.cycles, cycles) ||
 		    history_begin->cs_was_changed_seq != cs_was_changed_seq)
 			return -EINVAL;
 		partial_history_cycles = cycles - system_counterval.cycles;
-		total_history_cycles = cycles - history_begin->cycles;
+		total_history_cycles = cycles - history_begin->sc.cycles;
 		discontinuity =
 			history_begin->clock_was_set_seq != clock_was_set_seq;
 
-- 
2.17.1

