Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEBC716A931
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgBXPDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:03:55 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50221 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgBXPDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:03:24 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j6FFz-00054v-Ti; Mon, 24 Feb 2020 16:02:52 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 28C3F10409E;
        Mon, 24 Feb 2020 16:02:45 +0100 (CET)
Message-Id: <20200224145644.708960317@linutronix.de>
User-Agent: quilt/0.65
Date:   Mon, 24 Feb 2020 15:01:53 +0100
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
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [patch V3 22/22] bpf/stackmap: Dont trylock mmap_sem with PREEMPT_RT and interrupts disabled
References: <20200224140131.461979697@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>

In a RT kernel down_read_trylock() cannot be used from NMI context and
up_read_non_owner() is another problematic issue.

So in such a configuration, simply elide the annotated stackmap and
just report the raw IPs.

In the longer term, it might be possible to provide a atomic friendly
versions of the page cache traversal which will at least provide the info
if the pages are resident and don't need to be paged in.

[ tglx: Use IS_ENABLED() to avoid the #ifdeffery, fixup the irq work
  	callback and add a comment ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/bpf/stackmap.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -40,6 +40,9 @@ static void do_up_read(struct irq_work *
 {
 	struct stack_map_irq_work *work;
 
+	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
+		return;
+
 	work = container_of(entry, struct stack_map_irq_work, irq_work);
 	up_read_non_owner(work->sem);
 	work->sem = NULL;
@@ -288,10 +291,19 @@ static void stack_map_get_build_id_offse
 	struct stack_map_irq_work *work = NULL;
 
 	if (irqs_disabled()) {
-		work = this_cpu_ptr(&up_read_work);
-		if (atomic_read(&work->irq_work.flags) & IRQ_WORK_BUSY)
-			/* cannot queue more up_read, fallback */
+		if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
+			work = this_cpu_ptr(&up_read_work);
+			if (atomic_read(&work->irq_work.flags) & IRQ_WORK_BUSY) {
+				/* cannot queue more up_read, fallback */
+				irq_work_busy = true;
+			}
+		} else {
+			/*
+			 * PREEMPT_RT does not allow to trylock mmap sem in
+			 * interrupt disabled context. Force the fallback code.
+			 */
 			irq_work_busy = true;
+		}
 	}
 
 	/*

