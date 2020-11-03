Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FD82A5725
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbgKCVgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731528AbgKCVfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:35:22 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27422C0613D1;
        Tue,  3 Nov 2020 13:35:22 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id o205so9919295qke.10;
        Tue, 03 Nov 2020 13:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=JZNeWwfG+RzwsvSKrdXl43pAjm6jFSLlkhpa18kNvDM=;
        b=R47MB9V27NmluIHEgJr6RpNr9k/k6I+vgvboY4hbvHIsRi/n0oZLWcUl7R2YvJ8sGG
         CEat9GY+wZigB18fEeDtBHUfIWkDA5kAivcN/yt5l9kxC2q6wjblG2v3VKSzoyQfaTYf
         BRC45DqzAZCW9nm/tfmr8OlDhrf+v1fO1e7pnXL3VtJI0ziEe7kHRVo2+QMYgeWQQI5k
         T1BIeDrdCsAFjf46+g0ZIExyJlBzJ5veYwnHy/N3Zm0boEvR266ME1xFJ2XwYts64/bX
         RqqLeXPqikuOscoayciP185ceo9Cpe3DOiHGZhPJOSNqgAmgI38KnVCqhx+TE2J2MmoJ
         kqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JZNeWwfG+RzwsvSKrdXl43pAjm6jFSLlkhpa18kNvDM=;
        b=Rjxe6WZrr94uSGP/4a7vsET2owzrkSungm9VyPzy2nSTJj/ht2F73tlwR29I3MTrqR
         OMZFb/6IgRWWhfUmq/XF/KoBKblcy4W6pAz03ZDbok6tZwGpWbaKTfAYCYS3MqWzSUqw
         wX8WUZirrUUx1XruOD1u5jpbaDlINl13JHLLnkHt62EZGDBZJ+OLr2Ah2pWI1C4+vZL/
         idhMe24Bjph5uuVNBYAHMaWV+ATYnTVhY1fIvi6g2V77yrz9HoxmyVlyd7jKnnGdpqIy
         EtA2OUkMoZLN/V9rBghTkl4XUVtQ5QC0NcRyxWLZ+yTXltP8IbNgWiCw5G13dFSK09X2
         V8Sw==
X-Gm-Message-State: AOAM532kw5T1AUpRu1gQw8Y9rBrpDbsRPyHPnwl0FTY/FHKxp5hYJX22
        U8hd2pi4HENq2zzWM8tE8FA=
X-Google-Smtp-Source: ABdhPJya7v+iFnrWrxwZkWnm/CkdyNku8yqmjAURJx9aZwYKYhA3NPG35rsu9fAjQI0BRZhkqLfWFA==
X-Received: by 2002:a37:9acb:: with SMTP id c194mr21833824qke.288.1604439321294;
        Tue, 03 Nov 2020 13:35:21 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id g15sm11675683qki.107.2020.11.03.13.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 13:35:20 -0800 (PST)
Subject: [bpf-next PATCH v3 5/5] selftest/bpf: Use global variables instead of
 maps for test_tcpbpf_kern
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Tue, 03 Nov 2020 13:35:19 -0800
Message-ID: <160443931900.1086697.6588858453575682351.stgit@localhost.localdomain>
In-Reply-To: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
References: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Use global variables instead of global_map and sockopt_results_map to track
test data. Doing this greatly simplifies the code as there is not need to
take the extra steps of updating the maps or looking up elements.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   51 ++++--------
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |   86 +++-----------------
 tools/testing/selftests/bpf/test_tcpbpf.h          |    2 
 3 files changed, 31 insertions(+), 108 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index bef81648797a..ab5281475f44 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -10,7 +10,7 @@
 
 static __u32 duration;
 
-static void verify_result(int map_fd, int sock_map_fd)
+static void verify_result(struct tcpbpf_globals *result)
 {
 	__u32 expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
 				 (1 << BPF_SOCK_OPS_RWND_INIT) |
@@ -20,46 +20,31 @@ static void verify_result(int map_fd, int sock_map_fd)
 				 (1 << BPF_SOCK_OPS_NEEDS_ECN) |
 				 (1 << BPF_SOCK_OPS_STATE_CB) |
 				 (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
-	struct tcpbpf_globals result;
-	__u32 key = 0;
-	int res, rv;
-
-	rv = bpf_map_lookup_elem(map_fd, &key, &result);
-	if (CHECK(rv, "bpf_map_lookup_elem(map_fd)", "err:%d errno:%d",
-		  rv, errno))
-		return;
 
 	/* check global map */
-	CHECK(expected_events != result.event_map, "event_map",
+	CHECK(expected_events != result->event_map, "event_map",
 	      "unexpected event_map: actual 0x%08x != expected 0x%08x\n",
-	      result.event_map, expected_events);
+	      result->event_map, expected_events);
 
-	ASSERT_EQ(result.bytes_received, 501, "bytes_received");
-	ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
-	ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
-	ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
-	ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
-	ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
-	ASSERT_EQ(result.num_listen, 1, "num_listen");
+	ASSERT_EQ(result->bytes_received, 501, "bytes_received");
+	ASSERT_EQ(result->bytes_acked, 1002, "bytes_acked");
+	ASSERT_EQ(result->data_segs_in, 1, "data_segs_in");
+	ASSERT_EQ(result->data_segs_out, 1, "data_segs_out");
+	ASSERT_EQ(result->bad_cb_test_rv, 0x80, "bad_cb_test_rv");
+	ASSERT_EQ(result->good_cb_test_rv, 0, "good_cb_test_rv");
+	ASSERT_EQ(result->num_listen, 1, "num_listen");
 
 	/* 3 comes from one listening socket + both ends of the connection */
-	ASSERT_EQ(result.num_close_events, 3, "num_close_events");
+	ASSERT_EQ(result->num_close_events, 3, "num_close_events");
 
 	/* check setsockopt for SAVE_SYN */
-	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
-	CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
-	      rv, errno);
-	ASSERT_EQ(res, 0, "bpf_setsockopt(TCP_SAVE_SYN)");
+	ASSERT_EQ(result->tcp_save_syn, 0, "tcp_save_syn");
 
 	/* check getsockopt for SAVED_SYN */
-	key = 1;
-	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
-	CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
-	      rv, errno);
-	ASSERT_EQ(res, 1, "bpf_getsockopt(TCP_SAVED_SYN)");
+	ASSERT_EQ(result->tcp_saved_syn, 1, "tcp_saved_syn");
 }
 
-static void run_test(int map_fd, int sock_map_fd)
+static void run_test(struct tcpbpf_globals *result)
 {
 	int listen_fd = -1, cli_fd = -1, accept_fd = -1;
 	char buf[1000];
@@ -126,13 +111,12 @@ static void run_test(int map_fd, int sock_map_fd)
 		close(listen_fd);
 
 	if (!err)
-		verify_result(map_fd, sock_map_fd);
+		verify_result(result);
 }
 
 void test_tcpbpf_user(void)
 {
 	struct test_tcpbpf_kern *skel;
-	int map_fd, sock_map_fd;
 	int cg_fd = -1;
 
 	skel = test_tcpbpf_kern__open_and_load();
@@ -144,14 +128,11 @@ void test_tcpbpf_user(void)
 		  "cg_fd:%d errno:%d", cg_fd, errno))
 		goto err;
 
-	map_fd = bpf_map__fd(skel->maps.global_map);
-	sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
-
 	skel->links.bpf_testcb = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
 	if (!ASSERT_OK_PTR(skel->links.bpf_testcb, "attach_cgroup(bpf_testcb)"))
 		goto err;
 
-	run_test(map_fd, sock_map_fd);
+	run_test(&skel->bss->global);
 
 err:
 	if (cg_fd != -1)
diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index 3e6912e4df3d..e85e49deba70 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -14,40 +14,7 @@
 #include <bpf/bpf_endian.h>
 #include "test_tcpbpf.h"
 
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 4);
-	__type(key, __u32);
-	__type(value, struct tcpbpf_globals);
-} global_map SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 2);
-	__type(key, __u32);
-	__type(value, int);
-} sockopt_results SEC(".maps");
-
-static inline void update_event_map(int event)
-{
-	__u32 key = 0;
-	struct tcpbpf_globals g, *gp;
-
-	gp = bpf_map_lookup_elem(&global_map, &key);
-	if (gp == NULL) {
-		struct tcpbpf_globals g = {0};
-
-		g.event_map |= (1 << event);
-		bpf_map_update_elem(&global_map, &key, &g,
-			    BPF_ANY);
-	} else {
-		g = *gp;
-		g.event_map |= (1 << event);
-		bpf_map_update_elem(&global_map, &key, &g,
-			    BPF_ANY);
-	}
-}
-
+struct tcpbpf_globals global = {};
 int _version SEC("version") = 1;
 
 SEC("sockops")
@@ -105,29 +72,15 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 
 	op = (int) skops->op;
 
-	update_event_map(op);
+	global.event_map |= (1 << op);
 
 	switch (op) {
 	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
 		/* Test failure to set largest cb flag (assumes not defined) */
-		bad_call_rv = bpf_sock_ops_cb_flags_set(skops, 0x80);
+		global.bad_cb_test_rv = bpf_sock_ops_cb_flags_set(skops, 0x80);
 		/* Set callback */
-		good_call_rv = bpf_sock_ops_cb_flags_set(skops,
+		global.good_cb_test_rv = bpf_sock_ops_cb_flags_set(skops,
 						 BPF_SOCK_OPS_STATE_CB_FLAG);
-		/* Update results */
-		{
-			__u32 key = 0;
-			struct tcpbpf_globals g, *gp;
-
-			gp = bpf_map_lookup_elem(&global_map, &key);
-			if (!gp)
-				break;
-			g = *gp;
-			g.bad_cb_test_rv = bad_call_rv;
-			g.good_cb_test_rv = good_call_rv;
-			bpf_map_update_elem(&global_map, &key, &g,
-					    BPF_ANY);
-		}
 		break;
 	case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
 		skops->sk_txhash = 0x12345f;
@@ -143,10 +96,8 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 
 				thdr = (struct tcphdr *)(header + offset);
 				v = thdr->syn;
-				__u32 key = 1;
 
-				bpf_map_update_elem(&sockopt_results, &key, &v,
-						    BPF_ANY);
+				global.tcp_saved_syn = v;
 			}
 		}
 		break;
@@ -156,25 +107,16 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 		break;
 	case BPF_SOCK_OPS_STATE_CB:
 		if (skops->args[1] == BPF_TCP_CLOSE) {
-			__u32 key = 0;
-			struct tcpbpf_globals g, *gp;
-
-			gp = bpf_map_lookup_elem(&global_map, &key);
-			if (!gp)
-				break;
-			g = *gp;
 			if (skops->args[0] == BPF_TCP_LISTEN) {
-				g.num_listen++;
+				global.num_listen++;
 			} else {
-				g.total_retrans = skops->total_retrans;
-				g.data_segs_in = skops->data_segs_in;
-				g.data_segs_out = skops->data_segs_out;
-				g.bytes_received = skops->bytes_received;
-				g.bytes_acked = skops->bytes_acked;
+				global.total_retrans = skops->total_retrans;
+				global.data_segs_in = skops->data_segs_in;
+				global.data_segs_out = skops->data_segs_out;
+				global.bytes_received = skops->bytes_received;
+				global.bytes_acked = skops->bytes_acked;
 			}
-			g.num_close_events++;
-			bpf_map_update_elem(&global_map, &key, &g,
-					    BPF_ANY);
+			global.num_close_events++;
 		}
 		break;
 	case BPF_SOCK_OPS_TCP_LISTEN_CB:
@@ -182,9 +124,7 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 		v = bpf_setsockopt(skops, IPPROTO_TCP, TCP_SAVE_SYN,
 				   &save_syn, sizeof(save_syn));
 		/* Update global map w/ result of setsock opt */
-		__u32 key = 0;
-
-		bpf_map_update_elem(&sockopt_results, &key, &v, BPF_ANY);
+		global.tcp_save_syn = v;
 		break;
 	default:
 		rv = -1;
diff --git a/tools/testing/selftests/bpf/test_tcpbpf.h b/tools/testing/selftests/bpf/test_tcpbpf.h
index 6220b95cbd02..0ed33521cbbb 100644
--- a/tools/testing/selftests/bpf/test_tcpbpf.h
+++ b/tools/testing/selftests/bpf/test_tcpbpf.h
@@ -14,5 +14,7 @@ struct tcpbpf_globals {
 	__u64 bytes_acked;
 	__u32 num_listen;
 	__u32 num_close_events;
+	__u32 tcp_save_syn;
+	__u32 tcp_saved_syn;
 };
 #endif


