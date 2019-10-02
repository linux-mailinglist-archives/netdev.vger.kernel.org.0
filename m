Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5EDC89B0
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfJBNam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:30:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24461 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfJBNak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 09:30:40 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3D17C05168C
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 13:30:38 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id n5so3545091lfi.0
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 06:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QLC9KwHSSP3dhfBbVJm+BVSNFOakztKyUFvjkUTpYiQ=;
        b=Z5I24BfoQVnC0P5z+x2M728OvYtm55fmRZiDDisFJi8DYi/ndSBgcC9G72iXZ+BrMj
         jN2uemY/UKJfFbuboIdOsv91BVBDswmpXF2V8hsw8xkKeu4DwE7MMp2cRCg3p+kFvtcw
         65XTbYftuuvBgg5Dj5rqWEpvb2taeKbm1XncLuANdgwIA5PFFL0Uk/xlhXs1JHyaIdSc
         ML5Y5Y9gQfETGHI9OvXjfQMaA2iCu58OQONekQuLKwevnH1skZNXbleZWtGvTf3t7Gue
         NPWQI79uqr6tsGLJ7oPpM+onlw/6OQAXg8oZ85T0gb4D6p6AJpWw8eX6OjAywi2eehvP
         PFOQ==
X-Gm-Message-State: APjAAAWSgZG4vencmfHC0eu/aPdFfJsLik9qQLGI0stOihzrYAhh2RFl
        jMbEIiRAns89KHXZiHyn+b0b+ElqXUV/e/jIbb8hLFtkeFXxDKEhYqgPCzRXAe17WhgTi22zN/+
        Crsz0swRxBRAeTwap
X-Received: by 2002:ac2:5e9e:: with SMTP id b30mr2372182lfq.5.1570023037040;
        Wed, 02 Oct 2019 06:30:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzD9afo3HryJaCSf2PTBfYvUaWyIdp3d7VblL0TOAP5DSUMHNF6cs/y3+8Dztzb/0Hnq6iXKQ==
X-Received: by 2002:ac2:5e9e:: with SMTP id b30mr2372148lfq.5.1570023036632;
        Wed, 02 Oct 2019 06:30:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id m8sm4566785lfa.67.2019.10.02.06.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 06:30:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7236418063D; Wed,  2 Oct 2019 15:30:34 +0200 (CEST)
Subject: [PATCH bpf-next 9/9] selftests: Add tests for XDP chain calls
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 02 Oct 2019 15:30:34 +0200
Message-ID: <157002303437.1302756.12935236773789755295.stgit@alrua-x1>
In-Reply-To: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds new self tests for the XDP chain call functionality.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/.gitignore        |    1 
 tools/testing/selftests/bpf/Makefile          |    3 
 tools/testing/selftests/bpf/progs/xdp_dummy.c |    6 +
 tools/testing/selftests/bpf/test_maps.c       |   45 ++++
 tools/testing/selftests/bpf/test_xdp_chain.sh |   77 +++++++
 tools/testing/selftests/bpf/xdp_chain.c       |  271 +++++++++++++++++++++++++
 6 files changed, 402 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_chain.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_chain.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 7470327edcfe..e9d2d765cc8f 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,3 +39,4 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
+xdp_chain
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6889c19a628c..97e8f6ae4a15 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -29,7 +29,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_btf_dump test_cgroup_attach xdping
+	test_btf_dump test_cgroup_attach xdping xdp_chain
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
@@ -71,6 +71,7 @@ TEST_PROGS := test_kmod.sh \
 	test_tc_tunnel.sh \
 	test_tc_edt.sh \
 	test_xdping.sh \
+	test_xdp_chain.sh \
 	test_bpftool_build.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
diff --git a/tools/testing/selftests/bpf/progs/xdp_dummy.c b/tools/testing/selftests/bpf/progs/xdp_dummy.c
index 43b0ef1001ed..454a1f0763a1 100644
--- a/tools/testing/selftests/bpf/progs/xdp_dummy.c
+++ b/tools/testing/selftests/bpf/progs/xdp_dummy.c
@@ -10,4 +10,10 @@ int xdp_dummy_prog(struct xdp_md *ctx)
 	return XDP_PASS;
 }
 
+SEC("xdp_drop")
+int xdp_drop_prog(struct xdp_md *ctx)
+{
+	return XDP_DROP;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index e1f1becda529..44f2f8548a24 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -523,6 +523,50 @@ static void test_devmap_hash(unsigned int task, void *data)
 	close(fd);
 }
 
+static void test_xdp_chain_map(unsigned int task, void *data)
+{
+	const char *file = "./xdp_dummy.o";
+	struct xdp_chain_acts acts = {};
+	struct bpf_object *obj;
+	int map_fd, prog_fd;
+	__u32 key = 0;
+	int err;
+
+	map_fd = bpf_create_map(BPF_MAP_TYPE_XDP_CHAIN, sizeof(key), sizeof(acts),
+			    2, 0);
+	if (map_fd < 0) {
+		printf("Failed to create xdp_chain map '%s'!\n", strerror(errno));
+		exit(1);
+	}
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
+	if (err < 0) {
+		printf("Failed to load dummy prog: '%s'!\n", strerror(errno));
+		exit(1);
+	}
+
+	/* Try inserting NULL key/value - should fail */
+	assert(bpf_map_update_elem(map_fd, &key, &acts, 0) == -1 && errno == EINVAL);
+
+	/* Try inserting NULL value - should fail */
+	key = 1;
+	assert(bpf_map_update_elem(map_fd, &key, &acts, 0) == -1 && errno == EINVAL);
+
+	/* Try a real insert - should succeed */
+	acts.wildcard_act = prog_fd;
+	assert(bpf_map_update_elem(map_fd, &key, &acts, 0) == 0);
+
+	/* Replace with full table */
+	acts.drop_act = acts.pass_act = acts.tx_act = acts.redirect_act = prog_fd;
+	assert(bpf_map_update_elem(map_fd, &key, &acts, 0) == 0);
+
+	/* Try deleting element */
+	assert(bpf_map_delete_elem(map_fd, &key) == 0);
+
+	bpf_object__close(obj);
+	close(map_fd);
+}
+
 static void test_queuemap(unsigned int task, void *data)
 {
 	const int MAP_SIZE = 32;
@@ -1700,6 +1744,7 @@ static void run_all_tests(void)
 
 	test_devmap(0, NULL);
 	test_devmap_hash(0, NULL);
+	test_xdp_chain_map(0, NULL);
 	test_sockmap(0, NULL);
 
 	test_map_large();
diff --git a/tools/testing/selftests/bpf/test_xdp_chain.sh b/tools/testing/selftests/bpf/test_xdp_chain.sh
new file mode 100755
index 000000000000..3997655d4e45
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_chain.sh
@@ -0,0 +1,77 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# xdp_chain tests
+#   Here we setup and teardown configuration required to run
+#   xdp_chain, exercising its options.
+#
+#   Setup is similar to xdping tests.
+#
+# Topology:
+# ---------
+#     root namespace   |     tc_ns0 namespace
+#                      |
+#      ----------      |     ----------
+#      |  veth1  | --------- |  veth0  |
+#      ----------    peer    ----------
+#
+# Device Configuration
+# --------------------
+# Root namespace with BPF
+# Device names and addresses:
+#	veth1 IP: 10.1.1.200
+#
+# Namespace tc_ns0 with BPF
+# Device names and addresses:
+#       veth0 IPv4: 10.1.1.100
+#	xdp_chain binary run inside this
+#
+
+readonly TARGET_IP="10.1.1.100"
+readonly TARGET_NS="xdp_ns0"
+
+readonly LOCAL_IP="10.1.1.200"
+
+setup()
+{
+	ip netns add $TARGET_NS
+	ip link add veth0 type veth peer name veth1
+	ip link set veth0 netns $TARGET_NS
+	ip netns exec $TARGET_NS ip addr add ${TARGET_IP}/24 dev veth0
+	ip addr add ${LOCAL_IP}/24 dev veth1
+	ip netns exec $TARGET_NS ip link set veth0 up
+	ip link set veth1 up
+}
+
+cleanup()
+{
+	set +e
+	ip netns delete $TARGET_NS 2>/dev/null
+	ip link del veth1 2>/dev/null
+}
+
+die()
+{
+        echo "$@" >&2
+        exit 1
+}
+
+test()
+{
+	args="$1"
+
+	ip netns exec $TARGET_NS ./xdp_chain $args || die "XDP chain test error"
+}
+
+set -e
+
+server_pid=0
+
+trap cleanup EXIT
+
+setup
+
+test "-I veth0 -S $LOCAL_IP"
+
+echo "OK. All tests passed"
+exit 0
diff --git a/tools/testing/selftests/bpf/xdp_chain.c b/tools/testing/selftests/bpf/xdp_chain.c
new file mode 100644
index 000000000000..11f78bb1c2e7
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdp_chain.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <arpa/inet.h>
+#include <assert.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <sys/resource.h>
+#include <net/if.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netdb.h>
+
+#include "bpf/bpf.h"
+#include "bpf/libbpf.h"
+
+static int ifindex;
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static char *dest = NULL, *ifname = NULL;
+
+static void cleanup(int sig)
+{
+	int ret;
+
+	fprintf(stderr, "  Cleaning up\n");
+	if ((ret = bpf_set_link_xdp_chain(ifindex, -1, -1, xdp_flags)))
+		fprintf(stderr, "Warning: Unable to clear XDP prog: %s\n",
+			strerror(-ret));
+	if (sig)
+		exit(1);
+}
+
+static void show_usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] -I interface destination\n\n"
+		"OPTS:\n"
+		"    -I interface		interface name\n"
+		"    -N			Run in driver mode\n"
+		"    -S			Run in skb mode\n"
+		"    -p pin_path		path to pin chain call map\n"
+		"    -x			Exit after setup\n"
+		"    -c			Cleanup and exit\n",
+		prog);
+}
+
+static int run_ping(bool should_fail, const char *msg)
+{
+	char cmd[256];
+	bool success;
+	int ret;
+
+	snprintf(cmd, sizeof(cmd), "ping -c 1 -W 1 -I %s %s >/dev/null", ifname, dest);
+
+	printf("  %s: ", msg);
+
+	ret = system(cmd);
+
+	success = (!!ret == should_fail);
+	printf(success ? "PASS\n" : "FAIL\n");
+
+	return !success;
+}
+
+int main(int argc, char **argv)
+{
+	__u32 mode_flags = XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE;
+	int pass_prog_fd = -1, drop_prog_fd = -1, map_fd = -1;
+	const char *filename = "xdp_dummy.o", *pin_path = NULL;
+	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_program *pass_prog, *drop_prog;
+	__u32 map_key, prog_id, chain_map_id;
+	struct xdp_chain_acts acts = {};
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	const char *optstr = "I:NSp:xc";
+	bool setup_only = false, cleanup_only = false;
+	struct bpf_object *obj;
+	int opt, ret = 1;
+
+	while ((opt = getopt(argc, argv, optstr)) != -1) {
+		switch (opt) {
+		case 'I':
+			ifname = optarg;
+			ifindex = if_nametoindex(ifname);
+			if (!ifindex) {
+				fprintf(stderr, "Could not get interface %s\n",
+					ifname);
+				return 1;
+			}
+			break;
+		case 'N':
+			xdp_flags |= XDP_FLAGS_DRV_MODE;
+			break;
+		case 'S':
+			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			break;
+		case 'x':
+			setup_only = true;
+			break;
+		case 'c':
+			cleanup_only = true;
+			break;
+		case 'p':
+			pin_path = optarg;
+			break;
+		default:
+			show_usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (!ifname) {
+		show_usage(basename(argv[0]));
+		return 1;
+	}
+
+	if (cleanup_only) {
+		if (pin_path)
+			unlink(pin_path);
+		cleanup(0);
+		return 0;
+	}
+
+	if (!setup_only && optind == argc) {
+		show_usage(basename(argv[0]));
+		return 1;
+	}
+	dest = argv[optind];
+
+	if ((xdp_flags & mode_flags) == mode_flags) {
+		fprintf(stderr, "-N or -S can be specified, not both.\n");
+		show_usage(basename(argv[0]));
+		return 1;
+	}
+
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
+
+	if (bpf_prog_load(filename, BPF_PROG_TYPE_XDP, &obj, &pass_prog_fd)) {
+		fprintf(stderr, "load of %s failed\n", filename);
+		return 1;
+	}
+
+	pass_prog = bpf_object__find_program_by_title(obj, "xdp_dummy");
+	drop_prog = bpf_object__find_program_by_title(obj, "xdp_drop");
+
+	if (!pass_prog || !drop_prog) {
+		fprintf(stderr, "could not find xdp programs\n");
+		return 1;
+	}
+	pass_prog_fd = bpf_program__fd(pass_prog);
+	drop_prog_fd = bpf_program__fd(drop_prog);
+	if (pass_prog_fd < 0 || drop_prog_fd < 0) {
+		fprintf(stderr, "could not find xdp programs\n");
+		goto done;
+	}
+
+	ret = bpf_obj_get_info_by_fd(pass_prog_fd, &info, &info_len);
+	if (ret) {
+		fprintf(stderr, "unable to get program ID from kernel\n");
+		goto done;
+	}
+	map_key = info.id;
+	map_fd = bpf_create_map(BPF_MAP_TYPE_XDP_CHAIN,
+				sizeof(map_key), sizeof(acts),
+				2, 0);
+
+	if (map_fd < 0) {
+		fprintf(stderr, "unable to create chain call map: %s\n", strerror(errno));
+		goto done;
+	}
+
+	if (pin_path && (ret = bpf_obj_pin(map_fd, pin_path))) {
+		fprintf(stderr, "unable to pin map at %s: %s\n", pin_path,
+			strerror(errno));
+		goto done;
+	}
+
+
+#define RUN_PING(should_fail, err) if ((ret = run_ping(should_fail, err))) goto done;
+
+	if (!setup_only) {
+		RUN_PING(false, "Pre-setup ping test");
+
+		signal(SIGINT, cleanup);
+		signal(SIGTERM, cleanup);
+	}
+
+	if ((ret = bpf_set_link_xdp_chain(ifindex, pass_prog_fd, map_fd, xdp_flags)) < 0) {
+		fprintf(stderr, "Link set xdp fd failed for %s: %s\n", ifname,
+			strerror(-ret));
+		goto done;
+	}
+
+	if ((ret = bpf_get_link_xdp_chain(ifindex, &prog_id, &chain_map_id, 0)) < 0) {
+		fprintf(stderr, "Unable to get xdp IDs for %s: '%s'\n", ifname, strerror(-ret));
+		goto done;
+	}
+	printf("  XDP prog ID: %u Chain map ID: %u\n", prog_id, chain_map_id);
+
+	if (!setup_only) {
+		sleep(1);
+		RUN_PING(false, "Empty map test");
+	}
+
+	acts.wildcard_act = drop_prog_fd;
+	if (bpf_map_update_elem(map_fd, &map_key, &acts, 0)) {
+		fprintf(stderr, "unable to insert into map: %s\n", strerror(errno));
+		goto done;
+	}
+
+	if (setup_only) {
+		printf("Setup done; exiting.\n");
+		ret = 0;
+		goto done;
+	}
+
+	sleep(1);
+
+	RUN_PING(true, "Wildcard act test");
+
+	if (bpf_map_delete_elem(map_fd, &map_key)) {
+		fprintf(stderr, "unable to delete from map: %s\n", strerror(errno));
+		goto done;
+	}
+	sleep(1);
+
+	RUN_PING(false, "Post-delete map test");
+
+	acts.wildcard_act = 0;
+	acts.pass_act = drop_prog_fd;
+	if (bpf_map_update_elem(map_fd, &map_key, &acts, 0)) {
+		fprintf(stderr, "unable to insert into map: %s\n", strerror(errno));
+		goto done;
+	}
+	sleep(1);
+
+	RUN_PING(true, "Pass act test");
+
+
+	if ((ret = bpf_set_link_xdp_chain(ifindex, -1, -1, xdp_flags)) < 0) {
+		fprintf(stderr, "Link clear xdp fd failed for %s: '%s'\n", ifname, strerror(-ret));
+		goto done;
+	}
+	sleep(1);
+
+	RUN_PING(false, "Post-delete prog test");
+
+
+done:
+	cleanup(ret);
+
+	if (pass_prog_fd > 0)
+		close(pass_prog_fd);
+	if (drop_prog_fd > 0)
+		close(drop_prog_fd);
+	if (map_fd > 0)
+		close(map_fd);
+
+	return ret;
+}

