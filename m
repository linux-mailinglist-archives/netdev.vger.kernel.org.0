Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC6B827134
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfEVUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:54:04 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:55989 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730410AbfEVUyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:54:04 -0400
Received: by mail-yw1-f73.google.com with SMTP id l27so3205912ywa.22
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 13:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QY9qWZ3WpI+bDR3XH+UhavkeFdxps5N78C1PHSmhgK0=;
        b=AVOGP9LV/N+ZVWHDWD0mSzFZrmwTYPQ7SLzywYWeUu/GZc+4zJe4tQA2SfEKa9JljB
         +oWxxDm5d7bIVS9H8MaAKDtwaVGXS7+vi/zJaRyWbla1vl0ylZCAhHbP7rdmpu2l1N47
         L0+3FDI3KaHhS6czKzBWyWS+5wNxrCaG1T9uyO5h9PZigO6/igV/q7507yzvKaudec4z
         IWmhfwdskvnEJNz8X89Lm4Z8UEaK1kHdEortE26pfmoCScFxjXYyse83itDwa8J9ChQS
         9Fam8VCPUfBaV+t98mUtkURbHGT9mYGb5lXoV9ReUge8QXGKP9rtGXkNkR3nmymDUMyw
         7qrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QY9qWZ3WpI+bDR3XH+UhavkeFdxps5N78C1PHSmhgK0=;
        b=YfZpgPwQ4mKKSX0RVLkO3V9xMoCqLHbRScztLAcaStz4JJDoJj3gvnJ4IvlSUoLMww
         iCLsSpoBiyLgBlGnZ759p837z1QyQIHuNiHCHrJsgb/Znvl798fK8cAPTD2CYru+EaEW
         LO3ih803rvguMcf1lVd1iSUChzsJ4KhUoYJSa9Ri99ifwzoKFt0iwLb/Nma4Bu4aDtGo
         0xqliscz2/ppQd6rD8KLqHGHk2ntEvF/qibf3iP/OO6YCuzkk3RQL9J77ArV8msH1mRD
         cXSKOjd3rrJLsukPO4A2MPv2PJsJr3C4KUU82c97kkvPURzzsOKPLnPbGle8T4g92eKb
         Kuuw==
X-Gm-Message-State: APjAAAVBSCXXVqVcQ9SXQHnnaldZYF5t3NMUUDvEwEGtFlFhXdRNJVCG
        c+UqQN35gcRjOR/kaAnkWKCQ9hNSN9unDs4aOEjXuhDqaWhH9UEqwTsl16NyMOtuVcP3sgNwGpB
        T3Cw+QU1yEI8oVEZJknOuM8DMvBQUzNs5Tpms2CgIUV4mCHDjLusWhA==
X-Google-Smtp-Source: APXvYqwSnafodNT/CMgErqLqyBdVSTztpb4cK0Vtne4k1bgBpFEQfNvAF1TAttpDOdd67zwvEN8Jg/Y=
X-Received: by 2002:a81:1e15:: with SMTP id e21mr20744303ywe.200.1558558443387;
 Wed, 22 May 2019 13:54:03 -0700 (PDT)
Date:   Wed, 22 May 2019 13:53:53 -0700
In-Reply-To: <20190522205353.140648-1-sdf@google.com>
Message-Id: <20190522205353.140648-4-sdf@google.com>
Mime-Version: 1.0
References: <20190522205353.140648-1-sdf@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf-next v2 4/4] bpf: tracing: properly use bpf_prog_array api
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we don't have __rcu markers on the bpf_prog_array helpers,
let's use proper rcu_dereference_protected to obtain array pointer
under mutex.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/trace/bpf_trace.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f92d6ad5e080..766e42730318 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -19,6 +19,9 @@
 #include "trace_probe.h"
 #include "trace.h"
 
+#define bpf_event_rcu_dereference(p)					\
+	rcu_dereference_protected(p, lockdep_is_held(&bpf_event_mutex))
+
 #ifdef CONFIG_MODULES
 struct bpf_trace_module {
 	struct module *module;
@@ -1034,7 +1037,7 @@ static DEFINE_MUTEX(bpf_event_mutex);
 int perf_event_attach_bpf_prog(struct perf_event *event,
 			       struct bpf_prog *prog)
 {
-	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *old_array;
 	struct bpf_prog_array *new_array;
 	int ret = -EEXIST;
 
@@ -1052,7 +1055,7 @@ int perf_event_attach_bpf_prog(struct perf_event *event,
 	if (event->prog)
 		goto unlock;
 
-	old_array = event->tp_event->prog_array;
+	old_array = bpf_event_rcu_dereference(event->tp_event->prog_array);
 	if (old_array &&
 	    bpf_prog_array_length(old_array) >= BPF_TRACE_MAX_PROGS) {
 		ret = -E2BIG;
@@ -1075,7 +1078,7 @@ int perf_event_attach_bpf_prog(struct perf_event *event,
 
 void perf_event_detach_bpf_prog(struct perf_event *event)
 {
-	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *old_array;
 	struct bpf_prog_array *new_array;
 	int ret;
 
@@ -1084,7 +1087,7 @@ void perf_event_detach_bpf_prog(struct perf_event *event)
 	if (!event->prog)
 		goto unlock;
 
-	old_array = event->tp_event->prog_array;
+	old_array = bpf_event_rcu_dereference(event->tp_event->prog_array);
 	ret = bpf_prog_array_copy(old_array, event->prog, NULL, &new_array);
 	if (ret == -ENOENT)
 		goto unlock;
@@ -1106,6 +1109,7 @@ int perf_event_query_prog_array(struct perf_event *event, void __user *info)
 {
 	struct perf_event_query_bpf __user *uquery = info;
 	struct perf_event_query_bpf query = {};
+	struct bpf_prog_array *progs;
 	u32 *ids, prog_cnt, ids_len;
 	int ret;
 
@@ -1130,10 +1134,8 @@ int perf_event_query_prog_array(struct perf_event *event, void __user *info)
 	 */
 
 	mutex_lock(&bpf_event_mutex);
-	ret = bpf_prog_array_copy_info(event->tp_event->prog_array,
-				       ids,
-				       ids_len,
-				       &prog_cnt);
+	progs = bpf_event_rcu_dereference(event->tp_event->prog_array);
+	ret = bpf_prog_array_copy_info(progs, ids, ids_len, &prog_cnt);
 	mutex_unlock(&bpf_event_mutex);
 
 	if (copy_to_user(&uquery->prog_cnt, &prog_cnt, sizeof(prog_cnt)) ||
-- 
2.21.0.1020.gf2820cf01a-goog

