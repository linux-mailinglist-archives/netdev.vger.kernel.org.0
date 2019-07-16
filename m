Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5BC6A2D0
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 09:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbfGPHUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:20:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:64887 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfGPHUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 03:20:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 00:20:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="194796187"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jul 2019 00:20:48 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [RFC PATCH 1/5] x86: tsc: add tsc to art helpers
Date:   Tue, 16 Jul 2019 10:20:34 +0300
Message-Id: <20190716072038.8408-2-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 arch/x86/include/asm/tsc.h |  2 ++
 arch/x86/kernel/tsc.c      | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 8a0c25c6bf09..b7a9f4385a82 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -32,6 +32,8 @@ static inline cycles_t get_cycles(void)
 
 extern struct system_counterval_t convert_art_to_tsc(u64 art);
 extern struct system_counterval_t convert_art_ns_to_tsc(u64 art_ns);
+extern void get_tsc_ns(struct system_counterval_t *tsc_counterval, u64 *tsc_ns);
+extern u64 get_art_ns_now(void);
 
 extern void tsc_early_init(void);
 extern void tsc_init(void);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 0b29e58f288e..333fffc1db7c 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1215,6 +1215,38 @@ struct system_counterval_t convert_art_to_tsc(u64 art)
 }
 EXPORT_SYMBOL(convert_art_to_tsc);
 
+void get_tsc_ns(struct system_counterval_t *tsc_counterval, u64 *tsc_ns)
+{
+	u64 tmp, res, rem;
+	u64 cycles;
+
+	tsc_counterval->cycles = clocksource_tsc.read(NULL);
+	cycles = tsc_counterval->cycles;
+	tsc_counterval->cs = art_related_clocksource;
+
+	rem = do_div(cycles, tsc_khz);
+
+	res = cycles * USEC_PER_SEC;
+	tmp = rem * USEC_PER_SEC;
+
+	do_div(tmp, tsc_khz);
+	res += tmp;
+
+	*tsc_ns = res;
+}
+EXPORT_SYMBOL(get_tsc_ns);
+
+u64 get_art_ns_now(void)
+{
+	struct system_counterval_t tsc_cycles;
+	u64 tsc_ns;
+
+	get_tsc_ns(&tsc_cycles, &tsc_ns);
+
+	return tsc_ns;
+}
+EXPORT_SYMBOL(get_art_ns_now);
+
 /**
  * convert_art_ns_to_tsc() - Convert ART in nanoseconds to TSC.
  * @art_ns: ART (Always Running Timer) in unit of nanoseconds
-- 
2.22.0

