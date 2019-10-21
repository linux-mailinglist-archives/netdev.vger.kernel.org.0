Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00E9DE84E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 11:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfJUJkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 05:40:04 -0400
Received: from regular1.263xmail.com ([211.150.70.203]:58456 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfJUJkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 05:40:03 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 05:40:02 EDT
Received: from localhost (unknown [192.168.167.209])
        by regular1.263xmail.com (Postfix) with ESMTP id B8DB1428;
        Mon, 21 Oct 2019 17:31:38 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.69])
        by smtp.263.net (postfix) whith ESMTP id P469T140195813033728S1571650292121018_;
        Mon, 21 Oct 2019 17:31:39 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <6d3ea6ca7491250ed483a3c849e1089c>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: yili@winhong.com
X-SENDER-IP: 14.18.236.69
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From:   Yi Li <yili@winhong.com>
Cc:     yili@winhong.com, Yi Li <yilikernel@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Changbin Du <changbin.du@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] perf tools: Use of the macro IS_ERR_OR_NULL
Date:   Mon, 21 Oct 2019 17:29:33 +0800
Message-Id: <1571650178-15686-1-git-send-email-yili@winhong.com>
X-Mailer: git-send-email 2.7.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi Li <yilikernel@gmail.com>

This patch introduces the use of the macro IS_ERR_OR_NULL in place of
tests for NULL and IS_ERR.

The following Coccinelle semantic patch was used for making the change:

@@
expression e;
@@

- !e || IS_ERR(e)
+ IS_ERR_OR_NULL(e)
 || ...

Signed-off-by: Yi Li <yilikernel@gmail.com>
---
 tools/perf/util/bpf-loader.c   | 13 +++++++------
 tools/perf/util/parse-events.c |  2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index 10c187b..b14d224 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -426,7 +426,7 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
 	size_t prologue_cnt = 0;
 	int i, err;
 
-	if (IS_ERR(priv) || !priv || priv->is_tp)
+	if (IS_ERR_OR_NULL(priv) || priv->is_tp)
 		goto errout;
 
 	pev = &priv->pev;
@@ -578,7 +578,7 @@ static int hook_load_preprocessor(struct bpf_program *prog)
 	bool need_prologue = false;
 	int err, i;
 
-	if (IS_ERR(priv) || !priv) {
+	if (IS_ERR_OR_NULL(priv)) {
 		pr_debug("Internal error when hook preprocessor\n");
 		return -BPF_LOADER_ERRNO__INTERNAL;
 	}
@@ -650,8 +650,9 @@ int bpf__probe(struct bpf_object *obj)
 			goto out;
 
 		priv = bpf_program__priv(prog);
-		if (IS_ERR(priv) || !priv) {
-			err = PTR_ERR(priv);
+		if (IS_ERR_OR_NULL(priv)) {
+			pr_debug("bpf: failed to get private field\n");
+			err = -BPF_LOADER_ERRNO__INTERNAL;
 			goto out;
 		}
 
@@ -701,7 +702,7 @@ int bpf__unprobe(struct bpf_object *obj)
 		struct bpf_prog_priv *priv = bpf_program__priv(prog);
 		int i;
 
-		if (IS_ERR(priv) || !priv || priv->is_tp)
+		if (IS_ERR_OR_NULL(priv) || priv->is_tp)
 			continue;
 
 		for (i = 0; i < priv->pev.ntevs; i++) {
@@ -759,7 +760,7 @@ int bpf__foreach_event(struct bpf_object *obj,
 		struct perf_probe_event *pev;
 		int i, fd;
 
-		if (IS_ERR(priv) || !priv) {
+		if (IS_ERR_OR_NULL(priv)) {
 			pr_debug("bpf: failed to get private field\n");
 			return -BPF_LOADER_ERRNO__INTERNAL;
 		}
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b5e2ade..609c31f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -690,7 +690,7 @@ int parse_events_load_bpf_obj(struct parse_events_state *parse_state,
 	struct __add_bpf_event_param param = {parse_state, list, head_config};
 	static bool registered_unprobe_atexit = false;
 
-	if (IS_ERR(obj) || !obj) {
+	if (IS_ERR_OR_NULL(obj)) {
 		snprintf(errbuf, sizeof(errbuf),
 			 "Internal error: load bpf obj with NULL");
 		err = -EINVAL;
-- 
2.7.5



