Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4D514E8E4
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 07:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgAaGkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 01:40:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:64035 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgAaGkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 01:40:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 22:40:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="309925522"
Received: from wtczc53028gn.jf.intel.com (HELO localhost.localdomain) ([10.54.87.17])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2020 22:40:50 -0800
From:   christopher.s.hall@intel.com
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, richardcochran@gmail.com,
        davem@davemloft.net, sean.v.kelley@intel.com
Cc:     Christopher Hall <christopher.s.hall@intel.com>
Subject: [Intel PMC TGPIO Driver 4/5] x86/tsc: Add TSC support functions to support ART driven Time-Aware GPIO
Date:   Wed, 11 Dec 2019 13:48:51 -0800
Message-Id: <20191211214852.26317-5-christopher.s.hall@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191211214852.26317-1-christopher.s.hall@intel.com>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christopher Hall <christopher.s.hall@intel.com>

The PMC Time-Aware GPIO (TGPIO) logic is driven by ART. Several support
functions are required to translate ART to/from nanoseconds units which
is required by the PHC clock interface. A function is also added to get
the current value of ART/TSC using get_cycles() (RDTSC). This avoids
multiple MMIO reads required to retrieve ART.

Note that rather than ART nanoseconds, TSC nanoseconds are used. These are
related by TSC = ART * CPUID[15H].EBX/CPUID[15H].EAX + K. The value of
K is the distinction between between the ART and TSC nanoseconds.

The advantage of using TSC nanoseconds to represent the device clock
because it can easily be calculated in user-space using only CPUID[15H].
The value of ART in general can't be since K isn't necessarily known to
the application.

Signed-off-by: Christopher Hall <christopher.s.hall@intel.com>
---
 arch/x86/include/asm/tsc.h |   6 ++
 arch/x86/kernel/tsc.c      | 116 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 8a0c25c6bf09..f44c92fe3cd5 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -32,6 +32,12 @@ static inline cycles_t get_cycles(void)
 
 extern struct system_counterval_t convert_art_to_tsc(u64 art);
 extern struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns);
+extern struct timespec64 get_tsc_ns_now(struct system_counterval_t
+					*system_counter);
+extern u64 convert_tsc_ns_to_art(struct timespec64 *tsc_ns);
+extern u64 convert_tsc_ns_to_art_duration(struct timespec64 *tsc_ns);
+extern struct timespec64 convert_art_to_tsc_ns(u64 art);
+extern struct timespec64 convert_art_to_tsc_ns_duration(u64 art);
 
 extern void tsc_early_init(void);
 extern void tsc_init(void);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7e322e2daaf5..fb0dc3169e6b 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1215,7 +1215,7 @@ int unsynchronized_tsc(void)
 /*
  * Convert ART to TSC given numerator/denominator found in detect_art()
  */
-struct system_counterval_t convert_art_to_tsc(u64 art)
+static struct system_counterval_t _convert_art_to_tsc(u64 art, bool dur)
 {
 	u64 tmp, res, rem;
 
@@ -1225,13 +1225,125 @@ struct system_counterval_t convert_art_to_tsc(u64 art)
 	tmp = rem * art_to_tsc_numerator;
 
 	do_div(tmp, art_to_tsc_denominator);
-	res += tmp + art_to_tsc_offset;
+	res += tmp;
+	if (!dur)
+		res += art_to_tsc_offset;
 
 	return (struct system_counterval_t) {.cs = art_related_clocksource,
 			.cycles = res};
 }
+
+struct system_counterval_t convert_art_to_tsc(u64 art)
+{
+	return _convert_art_to_tsc(art, false);
+}
 EXPORT_SYMBOL(convert_art_to_tsc);
 
+static
+struct timespec64 get_tsc_ns(struct system_counterval_t *system_counter)
+{
+	u64 tmp, res, rem;
+	u64 cycles;
+
+	cycles = system_counter->cycles;
+	rem = do_div(cycles, tsc_khz);
+
+	res = cycles * USEC_PER_SEC;
+	tmp = rem * USEC_PER_SEC;
+
+	rem = do_div(tmp, tsc_khz);
+	tmp += rem > tsc_khz >> 2 ? 1 : 0;
+	res += tmp;
+
+	rem = do_div(res, NSEC_PER_SEC);
+
+	return (struct timespec64) {.tv_sec = res, .tv_nsec = rem};
+}
+
+struct timespec64 get_tsc_ns_now(struct system_counterval_t *system_counter)
+{
+	struct system_counterval_t counterval;
+
+	if (system_counter == NULL)
+		system_counter = &counterval;
+
+	system_counter->cycles = clocksource_tsc.read(NULL);
+	system_counter->cs = art_related_clocksource;
+
+	return get_tsc_ns(system_counter);
+}
+EXPORT_SYMBOL(get_tsc_ns_now);
+
+struct timespec64 convert_art_to_tsc_ns(u64 art)
+{
+	struct system_counterval_t counterval;
+
+	counterval = _convert_art_to_tsc(art, false);
+
+	return get_tsc_ns(&counterval);
+}
+EXPORT_SYMBOL(convert_art_to_tsc_ns);
+
+struct timespec64 convert_art_to_tsc_ns_duration(u64 art)
+{
+	struct system_counterval_t counterval;
+
+	counterval = _convert_art_to_tsc(art, true);
+
+	return get_tsc_ns(&counterval);
+}
+EXPORT_SYMBOL(convert_art_to_tsc_ns_duration);
+
+static u64 convert_tsc_ns_to_tsc(struct timespec64 *tsc_ns)
+{
+	u64 tmp, res, rem;
+	u64 cycles;
+
+	cycles = timespec64_to_ns(tsc_ns);
+
+	rem = do_div(cycles, USEC_PER_SEC);
+
+	res = cycles * tsc_khz;
+	tmp = rem * tsc_khz;
+
+	do_div(tmp, USEC_PER_SEC);
+
+	return res + tmp;
+}
+
+
+static u64 _convert_tsc_ns_to_art(struct timespec64 *tsc_ns, bool dur)
+{
+	u64 tmp, res, rem;
+	u64 cycles;
+
+	cycles = convert_tsc_ns_to_tsc(tsc_ns);
+	if (!dur)
+		cycles -= art_to_tsc_offset;
+
+	rem = do_div(cycles, art_to_tsc_numerator);
+
+	res = cycles * art_to_tsc_denominator;
+	tmp = rem * art_to_tsc_denominator;
+
+	rem = do_div(tmp, art_to_tsc_numerator);
+	tmp += rem > art_to_tsc_numerator >> 2 ? 1 : 0;
+
+	return res + tmp;
+}
+
+u64 convert_tsc_ns_to_art(struct timespec64 *tsc_ns)
+{
+	return _convert_tsc_ns_to_art(tsc_ns, false);
+}
+EXPORT_SYMBOL(convert_tsc_ns_to_art);
+
+u64 convert_tsc_ns_to_art_duration(struct timespec64 *tsc_ns)
+{
+	return _convert_tsc_ns_to_art(tsc_ns, true);
+}
+EXPORT_SYMBOL(convert_tsc_ns_to_art_duration);
+
 /**
  * convert_art_ns_to_tsc() - Convert ART in nanoseconds to TSC.
  * @art_ns: ART (Always Running Timer) in unit of nanoseconds
-- 
2.21.0

