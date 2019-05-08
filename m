Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637E917EFE
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 19:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfEHRS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 13:18:59 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:34938 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbfEHRS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 13:18:58 -0400
Received: by mail-pl1-f202.google.com with SMTP id x5so11921055pll.2
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 10:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Oc7kGTxNNeGPMnF+md75kkPiq5ynkJFXLqMqAf1RaYg=;
        b=sCcoidYMTgO8wDHVNyo0zWkArtuSb7+lrPRlpqwpffe0Qu3asnZmSU3fYLKVcgq4OG
         cvdqIziG4VFAUaXw5hlGpmPAxzyN2fGyhXIxCqwCd8PMTgb62S7MPB/6SvM0fYeaPRC5
         q5l24qgY2+rD3nsgx2QYGgw0ohAfXfww3oU0BAJYO8NOJCMFCl57QvdEDJVw1K0FgmHe
         WIuGspqMa+feZ7XQbBsTFd+qPatPsh++1NPW4i7A+9AnoLE19Df3PcrZBikTobBqcYvl
         jNaFIyOo+H3IwNWC4JxrOZMKaUXa4dyZ7nuQEVCN/ubWWz/j4q1Z8xwepbS6J6GmdR2C
         K8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Oc7kGTxNNeGPMnF+md75kkPiq5ynkJFXLqMqAf1RaYg=;
        b=hLko2Qcc9D4LhELCdgz7uM/2+qq9LN3icnQT88jQ3dJAZ2x5g3dDXsGMHrIs4WIYmF
         1GIqTRrABwBBqva3Czjps5OGPxBo170GF9DGdF/POK5DGxwEIUsb7oT+ojLzyr3DPR4w
         g2q/ltWdAlFlzB7RrLcmEJRaGlULAe0JQRQNZC/gwTwCO9uxRI2VbQxldv+aYf5rp9Nz
         YpOmhamNRmjFp9vSJZ2DvBHFZ2Fo0w4eOSaMleLknGwlIkCmb1I8oTyNvpGzHgN209BH
         uhMoCSu0ULWRvjh+OsRwcXjUgkojMCyAIUQQbrmqbQbTk4OEPbt6OdOMDALU3PsmSHZH
         VqVw==
X-Gm-Message-State: APjAAAUhyKQLa9PrRCI+iTLx9KHdhf6WLiiAXGWUPbSP840bX9vl4KjZ
        nFlFWv313EwViO6sWfXuO+Dg+fTPkc78a4lWsNQNpegRn0Wy8yiJRZBGvtcvqekuJ+qyvU1JHli
        vsEIuXSfHwq0Yl/eWff3xbfm3dKmWijs6kp++xFuznDcgNOJ2je9XFw==
X-Google-Smtp-Source: APXvYqzuMXoR4vtaeQnTo9Th5W6+ExYtT4hBDJZP8CCSEYSCPHu3PrFjoogcKMz4CIiw8wE10YkgZkI=
X-Received: by 2002:a63:191b:: with SMTP id z27mr48733425pgl.327.1557335937408;
 Wed, 08 May 2019 10:18:57 -0700 (PDT)
Date:   Wed,  8 May 2019 10:18:45 -0700
In-Reply-To: <20190508171845.201303-1-sdf@google.com>
Message-Id: <20190508171845.201303-5-sdf@google.com>
Mime-Version: 1.0
References: <20190508171845.201303-1-sdf@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf 4/4] bpf: tracing: properly use bpf_prog_array api
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we don't have __rcu markers on the bpf_prog_array helpers,
let's use proper rcu_dereference_protected to obtain array pointer
under mutex.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/trace/bpf_trace.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d64c00afceb5..5f8f7fdbe27c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -17,6 +17,9 @@
 #include "trace_probe.h"
 #include "trace.h"
 
+#define bpf_event_dereference(p)					\
+	rcu_dereference_protected(p, lockdep_is_held(&bpf_event_mutex))
+
 #ifdef CONFIG_MODULES
 struct bpf_trace_module {
 	struct module *module;
@@ -999,7 +1002,7 @@ static DEFINE_MUTEX(bpf_event_mutex);
 int perf_event_attach_bpf_prog(struct perf_event *event,
 			       struct bpf_prog *prog)
 {
-	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *old_array;
 	struct bpf_prog_array *new_array;
 	int ret = -EEXIST;
 
@@ -1017,7 +1020,7 @@ int perf_event_attach_bpf_prog(struct perf_event *event,
 	if (event->prog)
 		goto unlock;
 
-	old_array = event->tp_event->prog_array;
+	old_array = bpf_event_dereference(event->tp_event->prog_array);
 	if (old_array &&
 	    bpf_prog_array_length(old_array) >= BPF_TRACE_MAX_PROGS) {
 		ret = -E2BIG;
@@ -1040,7 +1043,7 @@ int perf_event_attach_bpf_prog(struct perf_event *event,
 
 void perf_event_detach_bpf_prog(struct perf_event *event)
 {
-	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *old_array;
 	struct bpf_prog_array *new_array;
 	int ret;
 
@@ -1049,7 +1052,7 @@ void perf_event_detach_bpf_prog(struct perf_event *event)
 	if (!event->prog)
 		goto unlock;
 
-	old_array = event->tp_event->prog_array;
+	old_array = bpf_event_dereference(event->tp_event->prog_array);
 	ret = bpf_prog_array_copy(old_array, event->prog, NULL, &new_array);
 	if (ret == -ENOENT)
 		goto unlock;
@@ -1071,6 +1074,7 @@ int perf_event_query_prog_array(struct perf_event *event, void __user *info)
 {
 	struct perf_event_query_bpf __user *uquery = info;
 	struct perf_event_query_bpf query = {};
+	struct bpf_prog_array *progs;
 	u32 *ids, prog_cnt, ids_len;
 	int ret;
 
@@ -1095,10 +1099,8 @@ int perf_event_query_prog_array(struct perf_event *event, void __user *info)
 	 */
 
 	mutex_lock(&bpf_event_mutex);
-	ret = bpf_prog_array_copy_info(event->tp_event->prog_array,
-				       ids,
-				       ids_len,
-				       &prog_cnt);
+	progs = bpf_event_dereference(event->tp_event->prog_array);
+	ret = bpf_prog_array_copy_info(progs, ids, ids_len, &prog_cnt);
 	mutex_unlock(&bpf_event_mutex);
 
 	if (copy_to_user(&uquery->prog_cnt, &prog_cnt, sizeof(prog_cnt)) ||
-- 
2.21.0.1020.gf2820cf01a-goog

