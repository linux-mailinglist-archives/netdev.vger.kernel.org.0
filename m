Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB4145B6C0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241513AbhKXIqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:46:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241518AbhKXIoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:44:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637743296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TEGty5S/MnI3NiIWNNHzLjNLkbyjP+A5VllGm4cA+aw=;
        b=M3Ip/qr4fU1qDP5i2jOxl8DKQmS9wNwNHSU1YaMpu6yohyYSiSSR0RbS0KF+CXgwrLty86
        kH2iAQiBNrb/N5gLJdjBBT5fbBqeRPQk7FQAlkno8PfLb36h7eG76KmKtJmKDE3NwFmQ5M
        9dOZxhGZGV91y0GwwoAZ5YJ0gsnKAeM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-VTEK9yhLOLuDjCZFLXRIaA-1; Wed, 24 Nov 2021 03:41:35 -0500
X-MC-Unique: VTEK9yhLOLuDjCZFLXRIaA-1
Received: by mail-wm1-f69.google.com with SMTP id 187-20020a1c02c4000000b003335872db8dso973028wmc.2
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 00:41:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TEGty5S/MnI3NiIWNNHzLjNLkbyjP+A5VllGm4cA+aw=;
        b=l4y2j6Jnxgl5hE63p5erg3apB1+lUufVqX11Dnb9a13sGyN1LwAYyjTvefvxNfFtdl
         KpmDaZtgX5JSFfxGiTjtQdFgWFsFZZu2cFuqgghpuFCDorMDfoytbw3uWuYRo3XVVk41
         SyU7Lfm998aw6zl1X8v5ZVUER7d5pwQR5D4idzvkB7mMVT92b5pg+C72M1L7fYHKW7DI
         ZWgi+X36TomKTMS+BB5V6iZ2ygFw7/r9z3n3an/r70yhx9UbOoPkQPGDOWOIa7bdZ3zT
         cGFb8vyWDBJ8fXWH4ab5WR/3umE0sNRzZl2Jh/W1VGSqObTbtOrDi+LW0mdR0pvC913/
         wbtQ==
X-Gm-Message-State: AOAM532TrGQXi9u+02SDjTboUy5otYaeLtYTWaYWRsb1BMcEtRh1PzIu
        brRak1K76KkzzH7+vZXUExN52Lhy92XC7ERSWsolgcrtC6Sf5EvsXTHyEkF7gqJ8itkqLE8NmkK
        xQS2Fm5YqRDemi/8Q
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr17159656wrv.400.1637743293202;
        Wed, 24 Nov 2021 00:41:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwI7+MCbH/0LRtHQRj1Ak5dKI/T/EbW7gnhXeM+Qj2gSXz4xXENHoxa80KTXP2iFAtxZHClfQ==
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr17159619wrv.400.1637743292936;
        Wed, 24 Nov 2021 00:41:32 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id c6sm5096710wmq.46.2021.11.24.00.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 00:41:32 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 2/8] perf/uprobe: Add support to create multiple probes
Date:   Wed, 24 Nov 2021 09:41:13 +0100
Message-Id: <20211124084119.260239-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124084119.260239-1-jolsa@kernel.org>
References: <20211124084119.260239-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to create multiple probes within single perf event.
This way we can associate single bpf program with multiple uprobes,
because bpf program gets associated with the perf event.

The perf_event_attr is not extended, current fields for uprobe
attachment are used for multi attachment.

For current uprobe atachment we use:

   uprobe_path (in config1) + probe_offset (in config2)

to define kprobe by executable path with offset.

For multi probe attach the same fields point to array of values
with the same semantic. Each probe is defined as set of values
with the same array index (idx) as:

   uprobe_path[idx] (in config1) + probe_offset[idx] (in config2)

to define uprobe executable path with offset.

The number of probes is passed in probe_cnt value, which shares
the union with wakeup_events/wakeup_watermark values which are
not used for uprobes.

Since [1] it's possible to stack multiple probes events under
one head event. Using the same code to allow that for probes
defined under perf uprobe interface.

[1] https://lore.kernel.org/lkml/156095682948.28024.14190188071338900568.stgit@devnote2/

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/trace_event_perf.c | 108 +++++++++++++++++++++++++++-----
 kernel/trace/trace_probe.h      |   3 +-
 kernel/trace/trace_uprobe.c     |  43 +++++++++++--
 3 files changed, 133 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 26078e40c299..fb5db6a43d37 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -379,34 +379,114 @@ void perf_kprobe_destroy(struct perf_event *p_event)
 #endif /* CONFIG_KPROBE_EVENTS */
 
 #ifdef CONFIG_UPROBE_EVENTS
-int perf_uprobe_init(struct perf_event *p_event,
-		     unsigned long ref_ctr_offset, bool is_retprobe)
+static struct trace_event_call*
+uprobe_init(u64 uprobe_path, u64 probe_offset, unsigned long ref_ctr_offset,
+	    bool is_retprobe, struct trace_event_call *old)
 {
 	int ret;
 	char *path = NULL;
 	struct trace_event_call *tp_event;
 
-	if (!p_event->attr.uprobe_path)
-		return -EINVAL;
+	if (!uprobe_path)
+		return ERR_PTR(-EINVAL);
 
-	path = strndup_user(u64_to_user_ptr(p_event->attr.uprobe_path),
+	path = strndup_user(u64_to_user_ptr(uprobe_path),
 			    PATH_MAX);
 	if (IS_ERR(path)) {
 		ret = PTR_ERR(path);
-		return (ret == -EINVAL) ? -E2BIG : ret;
+		return ERR_PTR((ret == -EINVAL) ? -E2BIG : ret);
 	}
 	if (path[0] == '\0') {
-		ret = -EINVAL;
-		goto out;
+		kfree(path);
+		return ERR_PTR(-EINVAL);
 	}
 
-	tp_event = create_local_trace_uprobe(path, p_event->attr.probe_offset,
-					     ref_ctr_offset, is_retprobe);
-	if (IS_ERR(tp_event)) {
-		ret = PTR_ERR(tp_event);
-		goto out;
+	tp_event = create_local_trace_uprobe(path, probe_offset,
+				ref_ctr_offset, is_retprobe, old);
+	kfree(path);
+	return tp_event;
+}
+
+static struct trace_event_call*
+uprobe_init_multi(struct perf_event *p_event, unsigned long ref_ctr_offset,
+		  bool is_retprobe)
+{
+	void __user *probe_offset = u64_to_user_ptr(p_event->attr.probe_offset);
+	void __user *uprobe_path = u64_to_user_ptr(p_event->attr.uprobe_path);
+	struct trace_event_call *tp_event, *tp_old = NULL;
+	u32 i, cnt = p_event->attr.probe_cnt;
+	u64 *paths = NULL, *offs = NULL;
+	int ret = -EINVAL;
+	size_t size;
+
+	if (!cnt)
+		return ERR_PTR(-EINVAL);
+
+	size = cnt * sizeof(u64);
+	if (uprobe_path) {
+		ret = -ENOMEM;
+		paths = kmalloc(size, GFP_KERNEL);
+		if (!paths)
+			goto out;
+		ret = -EFAULT;
+		if (copy_from_user(paths, uprobe_path, size))
+			goto out;
 	}
 
+	if (probe_offset) {
+		ret = -ENOMEM;
+		offs = kmalloc(size, GFP_KERNEL);
+		if (!offs)
+			goto out;
+		ret = -EFAULT;
+		if (copy_from_user(offs, probe_offset, size))
+			goto out;
+	}
+
+	for (i = 0; i < cnt; i++) {
+		tp_event = uprobe_init(paths ? paths[i] : 0, offs ? offs[i] : 0,
+				       ref_ctr_offset, is_retprobe, tp_old);
+		if (IS_ERR(tp_event)) {
+			if (tp_old)
+				destroy_local_trace_uprobe(tp_old);
+			ret = PTR_ERR(tp_event);
+			goto out;
+		}
+		if (!tp_old)
+			tp_old = tp_event;
+	}
+	ret = 0;
+
+out:
+	kfree(paths);
+	kfree(offs);
+	return ret ? ERR_PTR(ret) : tp_old;
+}
+
+static struct trace_event_call*
+uprobe_init_single(struct perf_event *p_event, unsigned long ref_ctr_offset,
+		   bool is_retprobe)
+{
+	struct perf_event_attr *attr = &p_event->attr;
+
+	return uprobe_init(attr->uprobe_path, attr->probe_offset,
+			   ref_ctr_offset, is_retprobe, NULL);
+}
+
+int perf_uprobe_init(struct perf_event *p_event,
+		     unsigned long ref_ctr_offset, bool is_retprobe)
+{
+	struct trace_event_call *tp_event;
+	int ret;
+
+	if (p_event->attr.probe_cnt)
+		tp_event = uprobe_init_multi(p_event, ref_ctr_offset, is_retprobe);
+	else
+		tp_event = uprobe_init_single(p_event, ref_ctr_offset, is_retprobe);
+
+	if (IS_ERR(tp_event))
+		return PTR_ERR(tp_event);
+
 	/*
 	 * local trace_uprobe need to hold event_mutex to call
 	 * uprobe_buffer_enable() and uprobe_buffer_disable().
@@ -417,8 +497,6 @@ int perf_uprobe_init(struct perf_event *p_event,
 	if (ret)
 		destroy_local_trace_uprobe(tp_event);
 	mutex_unlock(&event_mutex);
-out:
-	kfree(path);
 	return ret;
 }
 
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index ba8e46c7efe8..6c81926874ff 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -383,7 +383,8 @@ extern void destroy_local_trace_kprobe(struct trace_event_call *event_call);
 
 extern struct trace_event_call *
 create_local_trace_uprobe(char *name, unsigned long offs,
-			  unsigned long ref_ctr_offset, bool is_return);
+			  unsigned long ref_ctr_offset, bool is_return,
+			  struct trace_event_call *old);
 extern void destroy_local_trace_uprobe(struct trace_event_call *event_call);
 #endif
 extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index f5f0039d31e5..ca76f9ab6811 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -358,15 +358,20 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	return ERR_PTR(ret);
 }
 
+static void __free_trace_uprobe(struct trace_uprobe *tu)
+{
+	path_put(&tu->path);
+	kfree(tu->filename);
+	kfree(tu);
+}
+
 static void free_trace_uprobe(struct trace_uprobe *tu)
 {
 	if (!tu)
 		return;
 
-	path_put(&tu->path);
 	trace_probe_cleanup(&tu->tp);
-	kfree(tu->filename);
-	kfree(tu);
+	__free_trace_uprobe(tu);
 }
 
 static struct trace_uprobe *find_probe_event(const char *event, const char *group)
@@ -1584,7 +1589,8 @@ static int unregister_uprobe_event(struct trace_uprobe *tu)
 #ifdef CONFIG_PERF_EVENTS
 struct trace_event_call *
 create_local_trace_uprobe(char *name, unsigned long offs,
-			  unsigned long ref_ctr_offset, bool is_return)
+			  unsigned long ref_ctr_offset, bool is_return,
+			  struct trace_event_call *old)
 {
 	enum probe_print_type ptype;
 	struct trace_uprobe *tu;
@@ -1619,6 +1625,24 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 	tu->path = path;
 	tu->ref_ctr_offset = ref_ctr_offset;
 	tu->filename = kstrdup(name, GFP_KERNEL);
+
+	if (old) {
+		struct trace_uprobe *tu_old;
+
+		tu_old = trace_uprobe_primary_from_call(old);
+		if (!tu_old) {
+			ret = -EINVAL;
+			goto error;
+		}
+
+		/* Append to existing event */
+		ret = trace_probe_append(&tu->tp, &tu_old->tp);
+		if (ret)
+			goto error;
+
+		return trace_probe_event_call(&tu->tp);
+	}
+
 	init_trace_event_call(tu);
 
 	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
@@ -1635,11 +1659,20 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 
 void destroy_local_trace_uprobe(struct trace_event_call *event_call)
 {
+	struct trace_probe_event *event;
+	struct trace_probe *pos, *tmp;
 	struct trace_uprobe *tu;
 
 	tu = trace_uprobe_primary_from_call(event_call);
 
-	free_trace_uprobe(tu);
+	event = tu->tp.event;
+	list_for_each_entry_safe(pos, tmp, &event->probes, list) {
+		tu = container_of(pos, struct trace_uprobe, tp);
+		list_del_init(&pos->list);
+		__free_trace_uprobe(tu);
+	}
+
+	trace_probe_event_free(event);
 }
 #endif /* CONFIG_PERF_EVENTS */
 
-- 
2.33.1

