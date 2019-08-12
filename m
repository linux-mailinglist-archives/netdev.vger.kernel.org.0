Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57ADB8AB29
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 01:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHLXao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 19:30:44 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37214 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLXao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 19:30:44 -0400
Received: by mail-pf1-f193.google.com with SMTP id 129so3572215pfa.4;
        Mon, 12 Aug 2019 16:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2gJlSNsVCPEuwBRcAX7D48apSUE/JUhmE9FblgqpTu0=;
        b=AUW/LUImRIRH1XESGfwHQJZNnHcrA8h4ZXhLBzGpafDJ5XIMPgeJuHlgve+CqhaRoM
         8wCzJHvCv5cur4+bsYsWNEIQurHaKyy19MVKwHkEjGgkWTauTBgli9etQYY8wBHjsZ0Z
         eNdu1AwD4wznaf/DP1DbLOX0hFjkWU+awpep4cjdv9o002Oxgxe5hdNOs4ZnE0wdf/wr
         OCaYLO53+wh0w5tlVCXV70NsgNjGyGJwhNO5gaQrZIt0hn8Tth1qn3Ae9WaemeENgC2t
         eLLFSS1dDAHa3I5QEfllTt7+wfBu+RM1FUQL4O3Q/5ZPFgt+ewP09Iyts3CVDNYov0iW
         eJqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2gJlSNsVCPEuwBRcAX7D48apSUE/JUhmE9FblgqpTu0=;
        b=BS2vMNbu3Yg/1f0exW5Jp3s3wMRnQxnVZIjlGgzMGIvntcMphdQWuYdd/wAZ6xSzkO
         cnXsrnoPZdEUNfjLBsDM2htTTolEl7RKNRyiMQP/LxaSdpxDPbMTg4eQo+/X3hb1zHP6
         Hgx/VKeLoix5g7G/oIKVnFxqsqzqis5puq+oEAvmo6lFYcghPscoja+ptMWHWLhcDOwb
         M2BvvJQFOBB3zh4Fs39gFHnnRogVyTXArujCGqwfGDlIp+H/6dCOTKIUMfVYbbUmwsiW
         RGa5biAY7HiUeDD5kkEVSL+3MNY5j+BYN2aWIpw7xsGTtshlnoJxvc3IYE5eCpwQeQ1p
         TwWg==
X-Gm-Message-State: APjAAAW/v2c+stOU3ZErrtR67MlbprocLxZU6oQQzRVibTZODwLBxVFK
        OlHubPc3zBnBAcAV6orFLLoX6InI
X-Google-Smtp-Source: APXvYqxohYr7LRkD2PlOr6AMYcsrR7wZKYyo5oNPRxUB3eOKpN0P85yX64NbArDJ3K81mH02/sVgmg==
X-Received: by 2002:a63:1d0e:: with SMTP id d14mr32327309pgd.324.1565652642905;
        Mon, 12 Aug 2019 16:30:42 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id o128sm114846239pfb.42.2019.08.12.16.30.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 16:30:42 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        sdf@google.com, Petar Penkov <ppenkov@google.com>
Subject: [bpf-next] selftests/bpf: fix race in flow dissector tests
Date:   Mon, 12 Aug 2019 16:30:39 -0700
Message-Id: <20190812233039.173067-1-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

Since the "last_dissection" map holds only the flow keys for the most
recent packet, there is a small race in the skb-less flow dissector
tests if a new packet comes between transmitting the test packet, and
reading its keys from the map. If this happens, the test packet keys
will be overwritten and the test will fail.

Changing the "last_dissection" map to a hash map, keyed on the
source/dest port pair resolves this issue. Additionally, let's clear the
last test results from the map between tests to prevent previous test
cases from interfering with the following test cases.

Fixes: 0905beec9f52 ("selftests/bpf: run flow dissector tests in skb-less mode")
Signed-off-by: Petar Penkov <ppenkov@google.com>
---
 .../selftests/bpf/prog_tests/flow_dissector.c | 22 ++++++++++++++++++-
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 13 +++++------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index 700d73d2f22a..6892b88ae065 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -109,6 +109,8 @@ struct test tests[] = {
 			.iph.protocol = IPPROTO_TCP,
 			.iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
 			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
 		},
 		.keys = {
 			.nhoff = ETH_HLEN,
@@ -116,6 +118,8 @@ struct test tests[] = {
 			.addr_proto = ETH_P_IP,
 			.ip_proto = IPPROTO_TCP,
 			.n_proto = __bpf_constant_htons(ETH_P_IP),
+			.sport = 80,
+			.dport = 8080,
 		},
 	},
 	{
@@ -125,6 +129,8 @@ struct test tests[] = {
 			.iph.nexthdr = IPPROTO_TCP,
 			.iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
 			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
 		},
 		.keys = {
 			.nhoff = ETH_HLEN,
@@ -132,6 +138,8 @@ struct test tests[] = {
 			.addr_proto = ETH_P_IPV6,
 			.ip_proto = IPPROTO_TCP,
 			.n_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.sport = 80,
+			.dport = 8080,
 		},
 	},
 	{
@@ -143,6 +151,8 @@ struct test tests[] = {
 			.iph.protocol = IPPROTO_TCP,
 			.iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
 			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
 		},
 		.keys = {
 			.nhoff = ETH_HLEN + VLAN_HLEN,
@@ -150,6 +160,8 @@ struct test tests[] = {
 			.addr_proto = ETH_P_IP,
 			.ip_proto = IPPROTO_TCP,
 			.n_proto = __bpf_constant_htons(ETH_P_IP),
+			.sport = 80,
+			.dport = 8080,
 		},
 	},
 	{
@@ -161,6 +173,8 @@ struct test tests[] = {
 			.iph.nexthdr = IPPROTO_TCP,
 			.iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
 			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
 		},
 		.keys = {
 			.nhoff = ETH_HLEN + VLAN_HLEN * 2,
@@ -169,6 +183,8 @@ struct test tests[] = {
 			.addr_proto = ETH_P_IPV6,
 			.ip_proto = IPPROTO_TCP,
 			.n_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.sport = 80,
+			.dport = 8080,
 		},
 	},
 	{
@@ -487,7 +503,8 @@ void test_flow_dissector(void)
 			BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG;
 		struct bpf_prog_test_run_attr tattr = {};
 		struct bpf_flow_keys flow_keys = {};
-		__u32 key = 0;
+		__u32 key = (__u32)(tests[i].keys.sport) << 16 |
+			    tests[i].keys.dport;
 
 		/* For skb-less case we can't pass input flags; run
 		 * only the tests that have a matching set of flags.
@@ -504,6 +521,9 @@ void test_flow_dissector(void)
 
 		CHECK_ATTR(err, tests[i].name, "skb-less err %d\n", err);
 		CHECK_FLOW_KEYS(tests[i].name, flow_keys, tests[i].keys);
+
+		err = bpf_map_delete_elem(keys_fd, &key);
+		CHECK_ATTR(err, tests[i].name, "bpf_map_delete_elem %d\n", err);
 	}
 
 	bpf_prog_detach(prog_fd, BPF_FLOW_DISSECTOR);
diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index 08bd8b9d58d0..040a44206f29 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -65,8 +65,8 @@ struct {
 } jmp_table SEC(".maps");
 
 struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__uint(max_entries, 1);
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1024);
 	__type(key, __u32);
 	__type(value, struct bpf_flow_keys);
 } last_dissection SEC(".maps");
@@ -74,12 +74,11 @@ struct {
 static __always_inline int export_flow_keys(struct bpf_flow_keys *keys,
 					    int ret)
 {
-	struct bpf_flow_keys *val;
-	__u32 key = 0;
+	__u32 key = (__u32)(keys->sport) << 16 | keys->dport;
+	struct bpf_flow_keys val;
 
-	val = bpf_map_lookup_elem(&last_dissection, &key);
-	if (val)
-		memcpy(val, keys, sizeof(*val));
+	memcpy(&val, keys, sizeof(val));
+	bpf_map_update_elem(&last_dissection, &key, &val, BPF_ANY);
 	return ret;
 }
 
-- 
2.23.0.rc1.153.gdeed80330f-goog

