Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B735534F6D1
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhCaCd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbhCaCdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:33:07 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1EBC061574;
        Tue, 30 Mar 2021 19:33:07 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w70so18654556oie.0;
        Tue, 30 Mar 2021 19:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zJsA5AZqU+uTJz0h7iEhTFBjGQWrPnAhpQ/zHuK8xKc=;
        b=spkOC5wVCdDJKIO9YZiXnJKge4i/1KPDa//qPOz5QwQMZYpPHARuu3YfKFeZTJ5yHr
         l/sZXvSQvmAePdiXaDSm19sQOpmeIKKT4A4m9ws1BkuaMM77tiEIk81Wq68w3mFakwNl
         N2sGb0tblC2scKcKIGJ4z+zbn+8LgJ3Fh6XITjCoa6Pdvukzkmoc5yzcJKrF9PGPp0tG
         ZLBsVDvGzwQAA/mmrNT/jcRfAAyFNCTMCij2OJCKhW34SUWUjACzWnaM8QBz++JISnof
         giy3QhZNOiEM4P+XbA07jRIcHV7jhO5hq3+6FHHHXbAUjgxVxxtW6kVrTahUJI+uM/H/
         Qfnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zJsA5AZqU+uTJz0h7iEhTFBjGQWrPnAhpQ/zHuK8xKc=;
        b=noIq+6U/ClPwLm9TtV+WSBsnw9LGshRj62Fz1O3lsPOMiHVRx2G0HzSHJRCH8c7ozi
         gO6iVGbYwB+eTrLSXbVFHR4YN7mKgbVT/0WEIfeE0bEW6kFraiSw+rk9mhdM/KYuMT7u
         OvVVVTTDAIrCo1EYOW/IaLqIB6qeX6unlF6rn/rofDw/wr13E2wvnEdXddn3glG04GuO
         SgepGAE1YUl07OUIphyIyLvch7X5+4Udt6Z+s9bj8G3LH1rWU4RwavqvoD/21jxcwIe+
         t+g1RYmVip3l62nLa5LsH+lzHGaDyXIopKca+eeTWIpw822IM17xPHtmNYDHKcpz0c9r
         6YNw==
X-Gm-Message-State: AOAM5316fPS4+optQ78+P0wxywWz3SnEZ6lTC/6BFTamDL2S7BdhdpB1
        1fkYmi7OplN/RQwSrYB1iRR+04/o31UVUQ==
X-Google-Smtp-Source: ABdhPJw840JvOOhx11ku3mcL6/lrfwH2JNsJAw/RBGSz62yk5Rhz3RDl+YOjeEXh46RUeSwIuntsWg==
X-Received: by 2002:a05:6808:ab0:: with SMTP id r16mr671778oij.34.1617157986746;
        Tue, 30 Mar 2021 19:33:06 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:33:06 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v8 16/16] selftests/bpf: add a test case for loading BPF_SK_SKB_VERDICT
Date:   Tue, 30 Mar 2021 19:32:37 -0700
Message-Id: <20210331023237.41094-17-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This adds a test case to ensure BPF_SK_SKB_VERDICT and
BPF_SK_STREAM_VERDICT will never be attached at the same time.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 40 +++++++++++++++++++
 .../progs/test_sockmap_skb_verdict_attach.c   | 18 +++++++++
 2 files changed, 58 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_skb_verdict_attach.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index b8b48cac2ac3..ab77596b64e3 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -7,6 +7,7 @@
 #include "test_skmsg_load_helpers.skel.h"
 #include "test_sockmap_update.skel.h"
 #include "test_sockmap_invalid_update.skel.h"
+#include "test_sockmap_skb_verdict_attach.skel.h"
 #include "bpf_iter_sockmap.skel.h"
 
 #define TCP_REPAIR		19	/* TCP sock is under repair right now */
@@ -281,6 +282,39 @@ static void test_sockmap_copy(enum bpf_map_type map_type)
 	bpf_iter_sockmap__destroy(skel);
 }
 
+static void test_sockmap_skb_verdict_attach(enum bpf_attach_type first,
+					    enum bpf_attach_type second)
+{
+	struct test_sockmap_skb_verdict_attach *skel;
+	int err, map, verdict;
+
+	skel = test_sockmap_skb_verdict_attach__open_and_load();
+	if (CHECK_FAIL(!skel)) {
+		perror("test_sockmap_skb_verdict_attach__open_and_load");
+		return;
+	}
+
+	verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	map = bpf_map__fd(skel->maps.sock_map);
+
+	err = bpf_prog_attach(verdict, map, first, 0);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_attach");
+		goto out;
+	}
+
+	err = bpf_prog_attach(verdict, map, second, 0);
+	assert(err == -1 && errno == EBUSY);
+
+	err = bpf_prog_detach2(verdict, map, first);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_detach2");
+		goto out;
+	}
+out:
+	test_sockmap_skb_verdict_attach__destroy(skel);
+}
+
 void test_sockmap_basic(void)
 {
 	if (test__start_subtest("sockmap create_update_free"))
@@ -301,4 +335,10 @@ void test_sockmap_basic(void)
 		test_sockmap_copy(BPF_MAP_TYPE_SOCKMAP);
 	if (test__start_subtest("sockhash copy"))
 		test_sockmap_copy(BPF_MAP_TYPE_SOCKHASH);
+	if (test__start_subtest("sockmap skb_verdict attach")) {
+		test_sockmap_skb_verdict_attach(BPF_SK_SKB_VERDICT,
+						BPF_SK_SKB_STREAM_VERDICT);
+		test_sockmap_skb_verdict_attach(BPF_SK_SKB_STREAM_VERDICT,
+						BPF_SK_SKB_VERDICT);
+	}
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_skb_verdict_attach.c b/tools/testing/selftests/bpf/progs/test_sockmap_skb_verdict_attach.c
new file mode 100644
index 000000000000..2d31f66e4f23
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_skb_verdict_attach.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 2);
+	__type(key, __u32);
+	__type(value, __u64);
+} sock_map SEC(".maps");
+
+SEC("sk_skb/skb_verdict")
+int prog_skb_verdict(struct __sk_buff *skb)
+{
+	return SK_DROP;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.25.1

