Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9C015E5E2
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405513AbgBNQoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:44:24 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55573 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393028AbgBNQVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:38 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diC-0003I4-9O; Fri, 14 Feb 2020 17:21:04 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 03740101DF6;
        Fri, 14 Feb 2020 17:21:04 +0100 (CET)
Message-Id: <20200214161503.070487511@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:19 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC patch 02/19] sched: Provide cant_migrate()
References: <20200214133917.304937432@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some code pathes rely on preempt_disable() to prevent migration on a non RT
enabled kernel. These preempt_disable/enable() pairs are substituted by
migrate_disable/enable() pairs or other forms of RT specific protection. On
RT these protections prevent migration but not preemption. Obviously a
cant_sleep() check in such a section will trigger on RT because preemption
is not disabled.

Provide a cant_migrate() macro which maps to cant_sleep() on a non RT
kernel and an empty placeholder for RT for now. The placeholder will be
changed to a proper debug check along with the RT specific migration
protection mechanism.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/kernel.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -257,6 +257,13 @@ extern void __cant_sleep(const char *fil
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
+#ifndef CONFIG_PREEMPT_RT
+# define cant_migrate()		cant_sleep()
+#else
+  /* Placeholder for now */
+# define cant_migrate()		do { } while (0)
+#endif
+
 /**
  * abs - return absolute value of an argument
  * @x: the value.  If it is unsigned type, it is converted to signed type first.

