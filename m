Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAEC1E9651
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgEaI3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbgEaI3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:29:15 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B9DC03E969
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:13 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e2so6244579eje.13
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=01x38t0xTk7+DfmoaUEjlRqGIKh1P8FrwxiKsjkB7Q0=;
        b=M47TiDPQiix4JzD5xbIyYxnvk+SV3J2SG9KC/B1Q43LjhLe2Ov7y6KaWBqBvFXprN5
         x3v12joXadiWi/ztMU06F2ifMulrywdyqrmTdU+7yyLfxtxu9/labftjnJU+omwzL+J7
         kwd/tfrGdALTvY0z0a7FnnjvPjqnrKc+viKgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=01x38t0xTk7+DfmoaUEjlRqGIKh1P8FrwxiKsjkB7Q0=;
        b=ryqAEFcSeXvM3ZG7nX+BVXlSiia9tEjIPHRk3ASJGnFGYltXW2MTv/Wz+oHnq4Hfu4
         lNJI0XjPDRT0vnGU3oL36HF930mMP3hnDtqig4KvtXbd/haOEyX6r4ougZixgBxDor5w
         H7lD2KAFcgr4TxhJXRMV+VPJLV3zKATP5qyPmw9bZMTyw0uLxhIuJaZpm3W3qeZXf3oz
         MNjyNoRVdpW3LXdzCgvfplGh/9LZvfl8Wr/V2AnMqadDIwqNEwhj0rICHycLjK3o2OvN
         E+Ch3xUzWwW5xTzfy9HSW/xag+07e3vtXpxvuhfUGwb/aplswQ95JdM9R9/cBCJ5iMVa
         Vojg==
X-Gm-Message-State: AOAM530sfHhisXVgUn4Zy3vQa3O9RxHDzZ2qiZXFXrIZhFwvuMs3+e99
        Gj40AJWARzwstFTa3ffV7Vgu4dJWuC4=
X-Google-Smtp-Source: ABdhPJz8WjaZwgilQvvQsoR/axJltqOCpIRaF8bSEDEd+xTahOmxmxgPMFlyGjDJ+QM6chfo/sET4w==
X-Received: by 2002:a17:906:9149:: with SMTP id y9mr9343813ejw.153.1590913752225;
        Sun, 31 May 2020 01:29:12 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id g13sm11778021ejh.119.2020.05.31.01.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:29:11 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v2 12/12] selftests/bpf: Extend test_flow_dissector to cover link creation
Date:   Sun, 31 May 2020 10:28:46 +0200
Message-Id: <20200531082846.2117903-13-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
References: <20200531082846.2117903-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the existing flow_dissector test case to run tests once using direct
prog attachments, and then for the second time using indirect attachment
via link.

The intention is to exercises the newly added high-level API for attaching
programs to network namespace with links (bpf_program__attach_netns).

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/flow_dissector.c | 115 +++++++++++++-----
 1 file changed, 82 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index b6370c0b3b7a..ea14e3ece812 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -103,6 +103,7 @@ struct test {
 
 #define VLAN_HLEN	4
 
+static __u32 duration;
 struct test tests[] = {
 	{
 		.name = "ipv4",
@@ -474,11 +475,87 @@ static int init_prog_array(struct bpf_object *obj, struct bpf_map *prog_array)
 	return 0;
 }
 
+static void run_tests_skb_less(int tap_fd, struct bpf_map *keys)
+{
+	int i, err, keys_fd;
+
+	keys_fd = bpf_map__fd(keys);
+	if (CHECK(keys_fd < 0, "bpf_map__fd", "err %d\n", keys_fd))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		/* Keep in sync with 'flags' from eth_get_headlen. */
+		__u32 eth_get_headlen_flags =
+			BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG;
+		struct bpf_prog_test_run_attr tattr = {};
+		struct bpf_flow_keys flow_keys = {};
+		__u32 key = (__u32)(tests[i].keys.sport) << 16 |
+			    tests[i].keys.dport;
+
+		/* For skb-less case we can't pass input flags; run
+		 * only the tests that have a matching set of flags.
+		 */
+
+		if (tests[i].flags != eth_get_headlen_flags)
+			continue;
+
+		err = tx_tap(tap_fd, &tests[i].pkt, sizeof(tests[i].pkt));
+		CHECK(err < 0, "tx_tap", "err %d errno %d\n", err, errno);
+
+		err = bpf_map_lookup_elem(keys_fd, &key, &flow_keys);
+		CHECK_ATTR(err, tests[i].name, "bpf_map_lookup_elem %d\n", err);
+
+		CHECK_ATTR(err, tests[i].name, "skb-less err %d\n", err);
+		CHECK_FLOW_KEYS(tests[i].name, flow_keys, tests[i].keys);
+
+		err = bpf_map_delete_elem(keys_fd, &key);
+		CHECK_ATTR(err, tests[i].name, "bpf_map_delete_elem %d\n", err);
+	}
+}
+
+static void test_skb_less_prog_attach(struct bpf_flow *skel, int tap_fd)
+{
+	int err, prog_fd;
+
+	prog_fd = bpf_program__fd(skel->progs._dissect);
+	if (CHECK(prog_fd < 0, "bpf_program__fd", "err %d\n", prog_fd))
+		return;
+
+	err = bpf_prog_attach(prog_fd, 0, BPF_FLOW_DISSECTOR, 0);
+	if (CHECK(err, "bpf_prog_attach", "err %d errno %d\n", err, errno))
+		return;
+
+	run_tests_skb_less(tap_fd, skel->maps.last_dissection);
+
+	err = bpf_prog_detach(prog_fd, BPF_FLOW_DISSECTOR);
+	CHECK(err, "bpf_prog_detach", "err %d errno %d\n", err, errno);
+}
+
+static void test_skb_less_link_create(struct bpf_flow *skel, int tap_fd)
+{
+	struct bpf_link *link;
+	int err, net_fd;
+
+	net_fd = open("/proc/self/ns/net", O_RDONLY);
+	if (CHECK(net_fd < 0, "open(/proc/self/ns/net)", "err %d\n", errno))
+		return;
+
+	link = bpf_program__attach_netns(skel->progs._dissect, net_fd);
+	if (CHECK(IS_ERR(link), "attach_netns", "err %ld\n", PTR_ERR(link)))
+		goto out_close;
+
+	run_tests_skb_less(tap_fd, skel->maps.last_dissection);
+
+	err = bpf_link__destroy(link);
+	CHECK(err, "bpf_link__destroy", "err %d\n", err);
+out_close:
+	close(net_fd);
+}
+
 void test_flow_dissector(void)
 {
 	int i, err, prog_fd, keys_fd = -1, tap_fd;
 	struct bpf_flow *skel;
-	__u32 duration = 0;
 
 	skel = bpf_flow__open_and_load();
 	if (CHECK(!skel, "skel", "failed to open/load skeleton\n"))
@@ -526,45 +603,17 @@ void test_flow_dissector(void)
 	 * via BPF map in this case.
 	 */
 
-	err = bpf_prog_attach(prog_fd, 0, BPF_FLOW_DISSECTOR, 0);
-	CHECK(err, "bpf_prog_attach", "err %d errno %d\n", err, errno);
-
 	tap_fd = create_tap("tap0");
 	CHECK(tap_fd < 0, "create_tap", "tap_fd %d errno %d\n", tap_fd, errno);
 	err = ifup("tap0");
 	CHECK(err, "ifup", "err %d errno %d\n", err, errno);
 
-	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		/* Keep in sync with 'flags' from eth_get_headlen. */
-		__u32 eth_get_headlen_flags =
-			BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG;
-		struct bpf_prog_test_run_attr tattr = {};
-		struct bpf_flow_keys flow_keys = {};
-		__u32 key = (__u32)(tests[i].keys.sport) << 16 |
-			    tests[i].keys.dport;
-
-		/* For skb-less case we can't pass input flags; run
-		 * only the tests that have a matching set of flags.
-		 */
-
-		if (tests[i].flags != eth_get_headlen_flags)
-			continue;
-
-		err = tx_tap(tap_fd, &tests[i].pkt, sizeof(tests[i].pkt));
-		CHECK(err < 0, "tx_tap", "err %d errno %d\n", err, errno);
-
-		err = bpf_map_lookup_elem(keys_fd, &key, &flow_keys);
-		CHECK_ATTR(err, tests[i].name, "bpf_map_lookup_elem %d\n", err);
-
-		CHECK_ATTR(err, tests[i].name, "skb-less err %d\n", err);
-		CHECK_FLOW_KEYS(tests[i].name, flow_keys, tests[i].keys);
-
-		err = bpf_map_delete_elem(keys_fd, &key);
-		CHECK_ATTR(err, tests[i].name, "bpf_map_delete_elem %d\n", err);
-	}
+	/* Test direct prog attachment */
+	test_skb_less_prog_attach(skel, tap_fd);
+	/* Test indirect prog attachment via link */
+	test_skb_less_link_create(skel, tap_fd);
 
 	close(tap_fd);
-	bpf_prog_detach(prog_fd, BPF_FLOW_DISSECTOR);
 out_destroy_skel:
 	bpf_flow__destroy(skel);
 }
-- 
2.25.4

