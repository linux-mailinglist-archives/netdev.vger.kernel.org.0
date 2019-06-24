Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4023350599
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 11:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfFXJYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 05:24:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42238 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbfFXJYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 05:24:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=t52uwsZ5CS16wjZkH/9lP0ZEe/KSj6WTDcY9RTylZiU=; b=pPZckTeXk7GUNaGNfbBK8q0PET
        Psm8el7YAywshXMcwevA7aur0wDPpnp4QcJ+KqJ1uwvD5z0H8AUlfcQVnD1GHLXxRvLJDT1LJpdF+
        ArrXtpfxk76E2n8Y9P8oh/5r2UERyrrXl/s571fHUrdkz7DdsEVFgEQDYPshcUhoeRMWokvmtEIUi
        rV1OSQHDdsa9DeouIVSVaYHFlZRr+BHJiwf37wWPkUxGop+I4Gl+MVMNIGjW1SN4ZBSP9mBD+Jziz
        YZdsR77vZh1Wq7Q673JGai165+G3fDHIn4+Xk1z2UVtgN5RlURm45MF+2cWBzMWqVE6sTF8AKNA2u
        fK5uCIxA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfLCm-0006v0-M0; Mon, 24 Jun 2019 09:24:04 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 5518620A0EF24; Mon, 24 Jun 2019 11:24:02 +0200 (CEST)
Message-Id: <20190624092109.805742823@infradead.org>
User-Agent: quilt/0.65
Date:   Mon, 24 Jun 2019 11:18:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, ast@kernel.org, daniel@iogearbox.net,
        akpm@linux-foundation.org, peterz@infradead.org
Cc:     Robert Richter <rric@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        oprofile-list@lists.sf.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 2/3] module: Fix up module_notifier return values.
References: <20190624091843.859714294@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While auditing all module notifiers I noticed a whole bunch of fail
wrt the return value. Notifiers have a 'special' return semantics.

Cc: Robert Richter <rric@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: oprofile-list@lists.sf.net
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 drivers/oprofile/buffer_sync.c |    4 ++--
 kernel/module.c                |    9 +++++----
 kernel/trace/bpf_trace.c       |    8 ++++++--
 kernel/trace/trace.c           |    2 +-
 kernel/trace/trace_events.c    |    2 +-
 kernel/trace/trace_printk.c    |    4 ++--
 kernel/tracepoint.c            |    2 +-
 7 files changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -116,7 +116,7 @@ module_load_notify(struct notifier_block
 {
 #ifdef CONFIG_MODULES
 	if (val != MODULE_STATE_COMING)
-		return 0;
+		return NOTIFY_DONE;
 
 	/* FIXME: should we process all CPU buffers ? */
 	mutex_lock(&buffer_mutex);
@@ -124,7 +124,7 @@ module_load_notify(struct notifier_block
 	add_event_entry(MODULE_LOADED_CODE);
 	mutex_unlock(&buffer_mutex);
 #endif
-	return 0;
+	return NOTIFY_OK;
 }
 
 
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1302,10 +1302,11 @@ static int bpf_event_notify(struct notif
 {
 	struct bpf_trace_module *btm, *tmp;
 	struct module *mod = module;
+	int ret = 0;
 
 	if (mod->num_bpf_raw_events == 0 ||
 	    (op != MODULE_STATE_COMING && op != MODULE_STATE_GOING))
-		return 0;
+		goto out;
 
 	mutex_lock(&bpf_module_mutex);
 
@@ -1315,6 +1316,8 @@ static int bpf_event_notify(struct notif
 		if (btm) {
 			btm->module = module;
 			list_add(&btm->list, &bpf_trace_modules);
+		} else {
+			ret = -ENOMEM;
 		}
 		break;
 	case MODULE_STATE_GOING:
@@ -1330,7 +1333,8 @@ static int bpf_event_notify(struct notif
 
 	mutex_unlock(&bpf_module_mutex);
 
-	return 0;
+out:
+	return notifier_from_errno(ret);
 }
 
 static struct notifier_block bpf_module_nb = {
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8685,7 +8685,7 @@ static int trace_module_notify(struct no
 		break;
 	}
 
-	return 0;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block trace_module_nb = {
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2450,7 +2450,7 @@ static int trace_module_notify(struct no
 	mutex_unlock(&trace_types_lock);
 	mutex_unlock(&event_mutex);
 
-	return 0;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block trace_module_nb = {
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -95,7 +95,7 @@ static int module_trace_bprintk_format_n
 		if (val == MODULE_STATE_COMING)
 			hold_module_trace_bprintk_format(start, end);
 	}
-	return 0;
+	return NOTIFY_OK;
 }
 
 /*
@@ -173,7 +173,7 @@ __init static int
 module_trace_bprintk_format_notify(struct notifier_block *self,
 		unsigned long val, void *data)
 {
-	return 0;
+	return NOTIFY_OK;
 }
 static inline const char **
 find_next_mod_format(int start_index, void *v, const char **fmt, loff_t *pos)
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -538,7 +538,7 @@ static int tracepoint_module_notify(stru
 	case MODULE_STATE_UNFORMED:
 		break;
 	}
-	return ret;
+	return notifier_from_errno(ret);
 }
 
 static struct notifier_block tracepoint_module_nb = {


