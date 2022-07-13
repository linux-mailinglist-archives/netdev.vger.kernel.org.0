Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63B6573523
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbiGMLPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbiGMLPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10D371014A1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657710889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTualzM4oL2vgENjqe1wfSZOmJQzk4aA4xXaa8p3Kw8=;
        b=DVMhJ6bNITrKchWvmFOEl2vAsvDPkJgtrHgpyAfPRGN1UltaMeAvOuomJSpUPF8pCn4X7h
        9pnGo5/wmGwlZQLqhUC15n50yyy0AWGF+pdwjxADQBI/kn5MWBuX1GhjQSR7TJf0Di/E5R
        DZZnz8sypanvQ6Y/sNnRAFDyT992q4c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-iuVBm8WlPZug1oUhOWhI-g-1; Wed, 13 Jul 2022 07:14:48 -0400
X-MC-Unique: iuVBm8WlPZug1oUhOWhI-g-1
Received: by mail-ed1-f72.google.com with SMTP id t5-20020a056402524500b0043a923324b2so8239103edd.22
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:14:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JTualzM4oL2vgENjqe1wfSZOmJQzk4aA4xXaa8p3Kw8=;
        b=qwyt65WvHQGMzPyp/G/EROF+/DrnUEFJsFxvEAB1nlS+KitIR6Mx+8QE4FTS1ivev0
         q1IYnEdzdBUhYfFHUdDbB9sRxedaApL+kJ/mjI6htkUUeBQWDtqIOTPZW/KLTWBe5rTy
         f+0IEvVZcvK8mLGKFTBdiTG1+CsBPGbJhCKwJbfSEB/N2iu4Pw1xz7T3zkCD58lmencl
         TGzmFKHZOJMEdbKjmmWBG/bqsoRAMyEHTNzwwuUlPs92cOBtBPxoosCp6YpaaUQvboJI
         qsKv8DMxxSdZhrZq24IXEnQEn09nJoSHhDI+jsj2unTeq3U07nbUspqzE+jBGJOOy6zK
         O7BA==
X-Gm-Message-State: AJIora8oZ1mYUrF7+MzpibmsBD/olJ14gFf2clBmRfNVVSNgTopP14NC
        iPlmTeZd4pgbVjeRHnyYoWAhPXJYSjDFVsix4KbMK8lsFa/8nxtMohtfMyQPGcI3H4cqSOV+alI
        EWIVuOk/njTwyfiEu
X-Received: by 2002:a05:6402:782:b0:43a:7387:39df with SMTP id d2-20020a056402078200b0043a738739dfmr4211345edy.251.1657710886100;
        Wed, 13 Jul 2022 04:14:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vXnNWI44L6kygD3dzfFuwC7JWimjzIW9xbUM6ULQgOQCzHJd4S0QCisMYM3N+I+KwcoXga2Q==
X-Received: by 2002:a05:6402:782:b0:43a:7387:39df with SMTP id d2-20020a056402078200b0043a738739dfmr4211225edy.251.1657710885100;
        Wed, 13 Jul 2022 04:14:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id fs13-20020a170907600d00b0072b2f95d5d1sm4938507ejc.170.2022.07.13.04.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:14:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B1C0D4D991E; Wed, 13 Jul 2022 13:14:40 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>
Subject: [RFC PATCH 16/17] selftests/bpf: Add test for XDP queueing through PIFO maps
Date:   Wed, 13 Jul 2022 13:14:24 +0200
Message-Id: <20220713111430.134810-17-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds selftests for both variants of the generic PIFO map type, and for
the dequeue program type. The XDP test uses bpf_prog_run() to run an XDP
program that puts packets into a PIFO map, and then adds tests that pull
them back out again through bpf_prog_run() of a dequeue program, as well as
by attaching a dequeue program to a veth device and scheduling transmission
there.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/pifo_map.c       | 125 ++++++++++++++
 .../bpf/prog_tests/xdp_pifo_test_run.c        | 154 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/pifo_map.c  |  54 ++++++
 .../selftests/bpf/progs/test_xdp_pifo.c       | 110 +++++++++++++
 4 files changed, 443 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pifo_map.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_pifo_test_run.c
 create mode 100644 tools/testing/selftests/bpf/progs/pifo_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_pifo.c

diff --git a/tools/testing/selftests/bpf/prog_tests/pifo_map.c b/tools/testing/selftests/bpf/prog_tests/pifo_map.c
new file mode 100644
index 000000000000..ae23bcc0683f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/pifo_map.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "pifo_map.skel.h"
+
+static int run_prog(int prog_fd, __u32 exp_retval)
+{
+	struct xdp_md ctx_in = {};
+	char data[10] = {};
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+			    .data_in = data,
+			    .data_size_in = sizeof(data),
+			    .ctx_in = &ctx_in,
+			    .ctx_size_in = sizeof(ctx_in),
+			    .repeat = 1,
+		);
+	int err;
+
+	ctx_in.data_end = sizeof(data);
+	err = bpf_prog_test_run_opts(prog_fd, &opts);
+	if (!ASSERT_OK(err, "bpf_prog_test_run(valid)"))
+		return -1;
+	if (!ASSERT_EQ(opts.retval, exp_retval, "prog retval"))
+		return -1;
+
+	return 0;
+}
+
+static void check_map_counts(int map_fd, int start, int interval, int num, int exp_val)
+{
+	__u32 val, key, next_key, *kptr = NULL;
+	int i, err;
+
+	for (i = 0; i < num; i++) {
+		err = bpf_map_get_next_key(map_fd, kptr, &next_key);
+		if (!ASSERT_OK(err, "bpf_map_get_next_key()"))
+			return;
+
+		key = next_key;
+		kptr = &key;
+
+		if (!ASSERT_EQ(key, start + i * interval, "expected key"))
+			break;
+		err = bpf_map_lookup_elem(map_fd, &key, &val);
+		if (!ASSERT_OK(err, "bpf_map_lookup_elem()"))
+			break;
+		if (!ASSERT_EQ(val, exp_val, "map value"))
+			break;
+	}
+}
+
+static void run_enqueue_fail(struct pifo_map *skel, int start, int interval, __u32 exp_retval)
+{
+	int enqueue_fd;
+
+	skel->bss->start = start;
+	skel->data->interval = interval;
+
+	enqueue_fd = bpf_program__fd(skel->progs.pifo_enqueue);
+
+	if (run_prog(enqueue_fd, exp_retval))
+		return;
+}
+
+static void run_test(struct pifo_map *skel, int start, int interval)
+{
+	int enqueue_fd, dequeue_fd;
+
+	skel->bss->start = start;
+	skel->data->interval = interval;
+
+	enqueue_fd = bpf_program__fd(skel->progs.pifo_enqueue);
+	dequeue_fd = bpf_program__fd(skel->progs.pifo_dequeue);
+
+	if (run_prog(enqueue_fd, 0))
+		return;
+	check_map_counts(bpf_map__fd(skel->maps.pifo_map),
+			 skel->bss->start, skel->data->interval,
+			 skel->rodata->num_entries, 1);
+	run_prog(dequeue_fd, 0);
+}
+
+void test_pifo_map(void)
+{
+	struct pifo_map *skel = NULL;
+	int err;
+
+	skel = pifo_map__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	run_test(skel, 0, 1);
+	run_test(skel, 0, 10);
+	run_test(skel, 0, 100);
+
+	/* do a series of runs that keep advancing the priority, to check that
+	 * we can keep rorating the two internal maps
+	 */
+	run_test(skel, 0, 125);
+	run_test(skel, 1250, 1);
+	run_test(skel, 1250, 125);
+
+	/* after rotating, starting enqueue at prio 0 will now fail */
+	run_enqueue_fail(skel, 0, 1, -ERANGE);
+
+	run_test(skel, 2500, 125);
+	run_test(skel, 3750, 125);
+	run_test(skel, 5000, 125);
+
+	pifo_map__destroy(skel);
+
+	/* reopen but change rodata */
+	skel = pifo_map__open();
+	if (!ASSERT_OK_PTR(skel, "open skel"))
+		return;
+
+	skel->rodata->num_entries = 12;
+	err = pifo_map__load(skel);
+	if (!ASSERT_OK(err, "load skel"))
+		goto out;
+
+	/* fails because the map is too small */
+	run_enqueue_fail(skel, 0, 1, -EOVERFLOW);
+out:
+	pifo_map__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_pifo_test_run.c b/tools/testing/selftests/bpf/prog_tests/xdp_pifo_test_run.c
new file mode 100644
index 000000000000..bac029731eee
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_pifo_test_run.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include <net/if.h>
+#include <linux/if_link.h>
+
+#include "test_xdp_pifo.skel.h"
+
+#define SYS(fmt, ...)						\
+	({							\
+		char cmd[1024];					\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
+		if (!ASSERT_OK(system(cmd), cmd))		\
+			goto out;				\
+	})
+
+static void run_xdp_prog(int prog_fd, void *data, size_t data_size, int repeat)
+{
+	struct xdp_md ctx_in = {};
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+			    .data_in = data,
+			    .data_size_in = data_size,
+			    .ctx_in = &ctx_in,
+			    .ctx_size_in = sizeof(ctx_in),
+			    .repeat = repeat,
+			    .flags = BPF_F_TEST_XDP_LIVE_FRAMES,
+		);
+	int err;
+
+	ctx_in.data_end = ctx_in.data + sizeof(pkt_v4);
+	err = bpf_prog_test_run_opts(prog_fd, &opts);
+	ASSERT_OK(err, "bpf_prog_test_run(valid)");
+}
+
+static void run_dequeue_prog(int prog_fd, int exp_proto)
+{
+	struct ipv4_packet data_out;
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+			    .data_out = &data_out,
+			    .data_size_out = sizeof(data_out),
+			    .repeat = 1,
+		);
+	int err;
+
+	err = bpf_prog_test_run_opts(prog_fd, &opts);
+	ASSERT_OK(err, "bpf_prog_test_run(valid)");
+	ASSERT_EQ(opts.retval, exp_proto == -1 ? 0 : 1, "valid-retval");
+	if (exp_proto >= 0) {
+		ASSERT_EQ(opts.data_size_out, sizeof(pkt_v4), "valid-datasize");
+		ASSERT_EQ(data_out.eth.h_proto, exp_proto, "valid-pkt");
+	} else {
+		ASSERT_EQ(opts.data_size_out, 0, "no-pkt-returned");
+	}
+}
+
+void test_xdp_pifo(void)
+{
+	int xdp_prog_fd, dequeue_prog_fd, i;
+	struct test_xdp_pifo *skel = NULL;
+	struct ipv4_packet data;
+
+	skel = test_xdp_pifo__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	xdp_prog_fd = bpf_program__fd(skel->progs.xdp_pifo);
+	dequeue_prog_fd = bpf_program__fd(skel->progs.dequeue_pifo);
+	data = pkt_v4;
+
+	run_xdp_prog(xdp_prog_fd, &data, sizeof(data), 3);
+
+	/* kernel program queues packets with prio 2, 1, 0 (in that order), we
+	 * should get back 0 and 1, and 2 should get dropped on dequeue
+	 */
+	run_dequeue_prog(dequeue_prog_fd, 0);
+	run_dequeue_prog(dequeue_prog_fd, 1);
+	run_dequeue_prog(dequeue_prog_fd, -1);
+
+	xdp_prog_fd = bpf_program__fd(skel->progs.xdp_pifo_inc);
+	run_xdp_prog(xdp_prog_fd, &data, sizeof(data), 1024);
+
+	skel->bss->pkt_count = 0;
+	skel->data->prio = 0;
+	skel->data->drop_above = 1024;
+	for (i = 0; i < 1024; i++)
+		run_dequeue_prog(dequeue_prog_fd, i*10);
+
+	test_xdp_pifo__destroy(skel);
+}
+
+void test_xdp_pifo_live(void)
+{
+	struct test_xdp_pifo *skel = NULL;
+	int err, ifindex_src, ifindex_dst;
+	int xdp_prog_fd, dequeue_prog_fd;
+	struct nstoken *nstoken = NULL;
+	struct ipv4_packet data;
+	struct bpf_link *link;
+	__u32 xdp_flags = XDP_FLAGS_DEQUEUE_MODE;
+	LIBBPF_OPTS(bpf_xdp_attach_opts, opts,
+		    .old_prog_fd = -1);
+
+	skel = test_xdp_pifo__open();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	SYS("ip netns add testns");
+	nstoken = open_netns("testns");
+	if (!ASSERT_OK_PTR(nstoken, "setns"))
+		goto out;
+
+	SYS("ip link add veth_src type veth peer name veth_dst");
+	SYS("ip link set dev veth_src up");
+	SYS("ip link set dev veth_dst up");
+
+	ifindex_src = if_nametoindex("veth_src");
+	ifindex_dst = if_nametoindex("veth_dst");
+	if (!ASSERT_NEQ(ifindex_src, 0, "ifindex_src") ||
+	    !ASSERT_NEQ(ifindex_dst, 0, "ifindex_dst"))
+		goto out;
+
+	skel->bss->tgt_ifindex = ifindex_src;
+	skel->data->drop_above = 3;
+
+	err = test_xdp_pifo__load(skel);
+	ASSERT_OK(err, "load skel");
+
+	link = bpf_program__attach_xdp(skel->progs.xdp_check_pkt, ifindex_dst);
+	if (!ASSERT_OK_PTR(link, "prog_attach"))
+		goto out;
+	skel->links.xdp_check_pkt = link;
+
+	xdp_prog_fd = bpf_program__fd(skel->progs.xdp_pifo);
+	dequeue_prog_fd = bpf_program__fd(skel->progs.dequeue_pifo);
+	data = pkt_v4;
+
+	err = bpf_xdp_attach(ifindex_src, dequeue_prog_fd, xdp_flags, &opts);
+	if (!ASSERT_OK(err, "attach-dequeue"))
+		goto out;
+
+	run_xdp_prog(xdp_prog_fd, &data, sizeof(data), 3);
+
+	/* wait for the packets to be flushed */
+	kern_sync_rcu();
+
+	ASSERT_EQ(skel->bss->seen_good_pkts, 3, "live packets OK");
+
+	opts.old_prog_fd = dequeue_prog_fd;
+	err = bpf_xdp_attach(ifindex_src, -1, xdp_flags, &opts);
+	ASSERT_OK(err, "dequeue-detach");
+
+out:
+	test_xdp_pifo__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/pifo_map.c b/tools/testing/selftests/bpf/progs/pifo_map.c
new file mode 100644
index 000000000000..b27bc2d0de03
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/pifo_map.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PIFO_GENERIC);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+	__uint(max_entries, 10);
+	__uint(map_extra, 1024); /* range */
+} pifo_map SEC(".maps");
+
+const volatile int num_entries = 10;
+volatile int interval = 10;
+volatile int start = 0;
+
+SEC("xdp")
+int pifo_dequeue(struct xdp_md *xdp)
+{
+	__u32 val, exp;
+	int i, ret;
+
+	for (i = 0; i < num_entries; i++) {
+		exp = start + i * interval;
+		ret = bpf_map_pop_elem(&pifo_map, &val);
+		if (ret)
+			return ret;
+		if (val != exp)
+			return 1;
+	}
+
+	return 0;
+}
+
+SEC("xdp")
+int pifo_enqueue(struct xdp_md *xdp)
+{
+	__u64 flags;
+	__u32 val;
+	int i, ret;
+
+	for (i = num_entries - 1; i >= 0; i--) {
+		val = start + i * interval;
+		flags = val;
+		ret = bpf_map_push_elem(&pifo_map, &val, flags);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_pifo.c b/tools/testing/selftests/bpf/progs/test_xdp_pifo.c
new file mode 100644
index 000000000000..702611e0cd1a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_pifo.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PIFO_XDP);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+	__uint(max_entries, 1024);
+	__uint(map_extra, 8192); /* range */
+} pifo_map SEC(".maps");
+
+__u16 prio = 3;
+int tgt_ifindex = 0;
+
+SEC("xdp")
+int xdp_pifo(struct xdp_md *xdp)
+{
+	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(long)xdp->data_end;
+	struct ethhdr *eth = data;
+	int ret;
+
+	if (eth + 1 > data_end)
+		return XDP_DROP;
+
+	/* We write the priority into the ethernet proto field so userspace can
+	 * pick it back out and confirm that it's correct
+	 */
+	eth->h_proto = --prio;
+	ret = bpf_redirect_map(&pifo_map, prio, 0);
+	if (tgt_ifindex && ret == XDP_REDIRECT)
+		bpf_schedule_iface_dequeue(xdp, tgt_ifindex, 0);
+	return ret;
+}
+
+__u16 check_prio = 0;
+__u16 seen_good_pkts = 0;
+
+SEC("xdp")
+int xdp_check_pkt(struct xdp_md *xdp)
+{
+	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(long)xdp->data_end;
+	struct ethhdr *eth = data;
+
+	if (eth + 1 > data_end)
+		return XDP_DROP;
+
+	if (eth->h_proto == check_prio) {
+		check_prio++;
+		seen_good_pkts++;
+		return XDP_DROP;
+	}
+
+	return XDP_PASS;
+}
+
+SEC("xdp")
+int xdp_pifo_inc(struct xdp_md *xdp)
+{
+	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(long)xdp->data_end;
+	struct ethhdr *eth = data;
+	int ret;
+
+	if (eth + 1 > data_end)
+		return XDP_DROP;
+
+	/* We write the priority into the ethernet proto field so userspace can
+	 * pick it back out and confirm that it's correct
+	 */
+	eth->h_proto = prio;
+	ret = bpf_redirect_map(&pifo_map, prio, 0);
+	prio += 10;
+	return ret;
+}
+
+__u16 pkt_count = 0;
+__u16 drop_above = 2;
+
+SEC("dequeue")
+void *dequeue_pifo(struct dequeue_ctx *ctx)
+{
+	__u64 prio = 0, pkt_prio = 0;
+	void *data, *data_end;
+	struct xdp_md *pkt;
+	struct ethhdr *eth;
+
+	pkt = (void *)bpf_packet_dequeue(ctx, &pifo_map, 0, &prio);
+	if (!pkt)
+		return NULL;
+
+	data = (void *)(long)pkt->data;
+	data_end = (void *)(long)pkt->data_end;
+	eth = data;
+
+	if (eth + 1 <= data_end)
+		pkt_prio = eth->h_proto;
+
+	if (pkt_prio != prio || ++pkt_count > drop_above) {
+		bpf_packet_drop(ctx, pkt);
+		return NULL;
+	}
+
+	return pkt;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.37.0

