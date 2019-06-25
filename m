Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0107A557F6
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbfFYTnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:43:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45234 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbfFYTmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:42:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so19187731wre.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 12:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GYjG1Lhb9GkhJWf8rDSOngzQUr27dwmTkilGHyOxJxo=;
        b=ezwmmbpI96qn7d0nlps1vQougMm1Q9ZuKhHJA061LKCWfJcuSek677hYBYPt2GrQNp
         4jjfw7i3AH34Wyj1cm0NTZmery0+yNQHa5FApjy2583ztCDP79XP10eQPocFOoMGzUAr
         +tNcFBJCfZygJnhjwrQ+emFbHw8lHXCe2ryqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GYjG1Lhb9GkhJWf8rDSOngzQUr27dwmTkilGHyOxJxo=;
        b=XWJHCkkcQ97QsXTwFEhv/TsyeY4hCrYB2ZmcrZ5nlMp9WBLB8cjAdmihQc0XCLvzHY
         ZsMkCBQsjB/OKrJx3hDlj+0CTYJgFDLSvlzShawBSQSsI4XS/ziQEGO0bnJFLFP0vB+2
         3PFh24rGGtzp12SWQZAPzmNYLO8PNQEie0C69QhAx4FTSM2vWo1PHdUjhSLJ4nnyWS8Z
         s9gP7WjHzhgmNXjLNG3iYI3Hp5+tV5jMqASaCJOgue1TqduvN7ake66iCLbxc74wBBfg
         W7V2eZH8G0XwAMQVscwdBc6LoFden92B1+swvlQm30nt7l545Ssu75uXdutyoNBWMptE
         rsWQ==
X-Gm-Message-State: APjAAAXRAhOHUvAR05JLPgDVbAumtorzgpD55AmAfBGSQpV8NTitJP+J
        UcV4mbC1qkRfRn+jlijbR8czDjYeJYej+g==
X-Google-Smtp-Source: APXvYqxbqFLK0tCw8AhS5eD7rC076M0sJB+W5TjrXXMQc7znJkawkEk+T+05gkWan1hamp4QCoDVkA==
X-Received: by 2002:adf:a38b:: with SMTP id l11mr35432560wrb.325.1561491773041;
        Tue, 25 Jun 2019 12:42:53 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedb6.dynamic.kabel-deutschland.de. [95.90.237.182])
        by smtp.gmail.com with ESMTPSA id q193sm84991wme.8.2019.06.25.12.42.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:42:52 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     netdev@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v2 08/10] bpf: Implement bpf_prog_test_run for perf event programs
Date:   Tue, 25 Jun 2019 21:42:13 +0200
Message-Id: <20190625194215.14927-9-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625194215.14927-1-krzesimir@kinvolk.io>
References: <20190625194215.14927-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As an input, test run for perf event program takes struct
bpf_perf_event_data as ctx_in and struct bpf_perf_event_value as
data_in. For an output, it basically ignores ctx_out and data_out.

The implementation sets an instance of struct bpf_perf_event_data_kern
in such a way that the BPF program reading data from context will
receive what we passed to the bpf prog test run in ctx_in. Also BPF
program can call bpf_perf_prog_read_value to receive what was passed
in data_in.

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 kernel/trace/bpf_trace.c                      | 107 ++++++++++++++++++
 .../bpf/verifier/perf_event_sample_period.c   |   8 ++
 2 files changed, 115 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c102c240bb0b..2fa49ea8a475 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -16,6 +16,8 @@
 
 #include <asm/tlb.h>
 
+#include <trace/events/bpf_test_run.h>
+
 #include "trace_probe.h"
 #include "trace.h"
 
@@ -1160,7 +1162,112 @@ const struct bpf_verifier_ops perf_event_verifier_ops = {
 	.convert_ctx_access	= pe_prog_convert_ctx_access,
 };
 
+static int pe_prog_test_run(struct bpf_prog *prog,
+			    const union bpf_attr *kattr,
+			    union bpf_attr __user *uattr)
+{
+	void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
+	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
+	u32 data_size_in = kattr->test.data_size_in;
+	u32 ctx_size_in = kattr->test.ctx_size_in;
+	u32 repeat = kattr->test.repeat;
+	u32 retval = 0, duration = 0;
+	int err = -EINVAL;
+	u64 time_start, time_spent = 0;
+	int i;
+	struct perf_sample_data sample_data = {0, };
+	struct perf_event event = {0, };
+	struct bpf_perf_event_data_kern real_ctx = {0, };
+	struct bpf_perf_event_data fake_ctx = {0, };
+	struct bpf_perf_event_value value = {0, };
+
+	if (ctx_size_in != sizeof(fake_ctx))
+		goto out;
+	if (data_size_in != sizeof(value))
+		goto out;
+
+	if (copy_from_user(&fake_ctx, ctx_in, ctx_size_in)) {
+		err = -EFAULT;
+		goto out;
+	}
+	if (copy_from_user(&value, data_in, data_size_in)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	real_ctx.regs = &fake_ctx.regs;
+	real_ctx.data = &sample_data;
+	real_ctx.event = &event;
+	perf_sample_data_init(&sample_data, fake_ctx.addr,
+			      fake_ctx.sample_period);
+	event.cpu = smp_processor_id();
+	event.oncpu = -1;
+	event.state = PERF_EVENT_STATE_OFF;
+	local64_set(&event.count, value.counter);
+	event.total_time_enabled = value.enabled;
+	event.total_time_running = value.running;
+	/* make self as a leader - it is used only for checking the
+	 * state field
+	 */
+	event.group_leader = &event;
+
+	/* slightly changed copy pasta from bpf_test_run() in
+	 * net/bpf/test_run.c
+	 */
+	if (!repeat)
+		repeat = 1;
+
+	rcu_read_lock();
+	preempt_disable();
+	time_start = ktime_get_ns();
+	for (i = 0; i < repeat; i++) {
+		retval = BPF_PROG_RUN(prog, &real_ctx);
+
+		if (signal_pending(current)) {
+			err = -EINTR;
+			preempt_enable();
+			rcu_read_unlock();
+			goto out;
+		}
+
+		if (need_resched()) {
+			time_spent += ktime_get_ns() - time_start;
+			preempt_enable();
+			rcu_read_unlock();
+
+			cond_resched();
+
+			rcu_read_lock();
+			preempt_disable();
+			time_start = ktime_get_ns();
+		}
+	}
+	time_spent += ktime_get_ns() - time_start;
+	preempt_enable();
+	rcu_read_unlock();
+
+	do_div(time_spent, repeat);
+	duration = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
+	/* end of slightly changed copy pasta from bpf_test_run() in
+	 * net/bpf/test_run.c
+	 */
+
+	if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval))) {
+		err = -EFAULT;
+		goto out;
+	}
+	if (copy_to_user(&uattr->test.duration, &duration, sizeof(duration))) {
+		err = -EFAULT;
+		goto out;
+	}
+	err = 0;
+out:
+	trace_bpf_test_finish(&err);
+	return err;
+}
+
 const struct bpf_prog_ops perf_event_prog_ops = {
+	.test_run	= pe_prog_test_run,
 };
 
 static DEFINE_MUTEX(bpf_event_mutex);
diff --git a/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
index 471c1a5950d8..16e9e5824d14 100644
--- a/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
+++ b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
@@ -13,6 +13,8 @@
 	},
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.ctx_len = sizeof(struct bpf_perf_event_data),
+	.data_len = sizeof(struct bpf_perf_event_value),
 },
 {
 	"check bpf_perf_event_data->sample_period half load permitted",
@@ -29,6 +31,8 @@
 	},
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.ctx_len = sizeof(struct bpf_perf_event_data),
+	.data_len = sizeof(struct bpf_perf_event_value),
 },
 {
 	"check bpf_perf_event_data->sample_period word load permitted",
@@ -45,6 +49,8 @@
 	},
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.ctx_len = sizeof(struct bpf_perf_event_data),
+	.data_len = sizeof(struct bpf_perf_event_value),
 },
 {
 	"check bpf_perf_event_data->sample_period dword load permitted",
@@ -56,4 +62,6 @@
 	},
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.ctx_len = sizeof(struct bpf_perf_event_data),
+	.data_len = sizeof(struct bpf_perf_event_value),
 },
-- 
2.20.1

