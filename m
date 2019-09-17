Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A733B4CC7
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 13:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfIQLZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 07:25:11 -0400
Received: from foss.arm.com ([217.140.110.172]:54654 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbfIQLZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 07:25:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 331E81570;
        Tue, 17 Sep 2019 04:25:10 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5CFDB3F59C;
        Tue, 17 Sep 2019 04:25:07 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, Steve.Capper@arm.com,
        Kaly.Xin@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        nd@arm.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/6] Timer: expose monotonic clock and counter value
Date:   Tue, 17 Sep 2019 07:24:27 -0400
Message-Id: <20190917112430.45680-4-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190917112430.45680-1-jianyong.wu@arm.com>
References: <20190917112430.45680-1-jianyong.wu@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of PTP drivers (such as ptp-kvm) are assuming what the
current clock source is, which could lead to interesting effects on
systems where the clocksource can change depending on external events.

For this purpose, add a new API that retrives both the current
monotonic clock as well as its counter value.

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

