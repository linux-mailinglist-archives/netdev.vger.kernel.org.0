Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E1AB5EB0
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfIRIHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:07:50 -0400
Received: from foss.arm.com ([217.140.110.172]:36818 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbfIRIHr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 04:07:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E92F61570;
        Wed, 18 Sep 2019 01:07:46 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C115F3F59C;
        Wed, 18 Sep 2019 01:07:41 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH v3 3/6] timekeeping: Expose API allowing retrival of current clocksource and counter value
Date:   Wed, 18 Sep 2019 04:07:13 -0400
Message-Id: <20190918080716.64242-4-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918080716.64242-1-jianyong.wu@arm.com>
References: <20190918080716.64242-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Marc Zyngier <maz@kernel.org>
A number of PTP drivers (such as ptp-kvm) are assuming what the
current clock source is, which could lead to interesting effects on
systems where the clocksource can change depending on external events.

For this purpose, add a new API that retrives both the current
monotonic clock as well as its counter value.

From Jianyong Wu: export this API then modules can use it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 include/linux/timekeeping.h |  3 +++
 kernel/time/timekeeping.c   | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index a8ab0f143ac4..a5389adaa8bc 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -247,6 +247,9 @@ extern int get_device_system_crosststamp(
 			struct system_time_snapshot *history,
 			struct system_device_crosststamp *xtstamp);
 
+/* Obtain current monotonic clock and its counter value  */
+extern void get_current_counterval(struct system_counterval_t *sc);
+
 /*
  * Simultaneously snapshot realtime and monotonic raw clocks
  */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 44b726bab4bd..07a0969625b1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1098,6 +1098,19 @@ static bool cycle_between(u64 before, u64 test, u64 after)
 	return false;
 }
 
+/**
+ * get_current_counterval - Snapshot the current clocksource and counter value
+ * @sc:	Pointer to a struct containing the current clocksource and its value
+ */
+void get_current_counterval(struct system_counterval_t *sc)
+{
+	struct timekeeper *tk = &tk_core.timekeeper;
+
+	sc->cs = READ_ONCE(tk->tkr_mono.clock);
+	sc->cycles = sc->cs->read(sc->cs);
+}
+EXPORT_SYMBOL_GPL(get_current_counterval);
+
 /**
  * get_device_system_crosststamp - Synchronously capture system/device timestamp
  * @get_time_fn:	Callback to get simultaneous device time and
-- 
2.17.1

