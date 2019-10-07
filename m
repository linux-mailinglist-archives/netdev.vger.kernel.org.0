Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575C6CEA7C
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfJGRUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729006AbfJGRUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 13:20:45 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86CF87BDA1
        for <netdev@vger.kernel.org>; Mon,  7 Oct 2019 17:20:44 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id c83so1635086lfg.8
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 10:20:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=txlyftqHDQYXziOZ8DqCu+4nJOlFLc3PaJao3l+9RW8=;
        b=ixLzPrNJrPb7s5aG5AjxwYXSMMOyPvoag/BGpnVqTDOaxSA6vL38uVIQUAuwalrKg8
         KxxNEbqXT6u8FqMQME/LEVInqHECksig5HXXr297ESo/VqDk2YZx1TO9nYerzjc3KU+1
         F8FTmUILi2O6UyOK843zPl1dzs/BMqrZE6/aFEtNuLCsiKnOTF0RYJ8XdVpNpz431eS+
         yvfCXtYiYHGwa2UkSUOma90d2Ovo3trxQ7UkHMpbLw8m7Cio45xw/Cc/4Nfns1v6jbBO
         hNrT44HAuZWacipoCbjS1Ml74t2Ny8sIPdFIIDnh1MIUZVM803Dj+aYY3eire1dID9Tb
         nyBw==
X-Gm-Message-State: APjAAAU9KCCujuQ6ELrNVgw8L2xkjiZJqZcUeCuQyKVA+A4zw6fPY6p/
        VxuA3QEAAccbssz7t49v7NWuf7hkVgdwbquxgfZtrw/Dh0xJ3lxncwpvCyzSXJPUSAYBD1r4uFd
        urGMWDKfBxZJkns2I
X-Received: by 2002:a05:6512:6c:: with SMTP id i12mr17543095lfo.40.1570468842943;
        Mon, 07 Oct 2019 10:20:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw/GCPiOp1uAKIl8eu6rz49qzbLuYGC53kVzLTD1Lo6iGeQrU/IQbrBF4H1gs7RI9cp52HM4w==
X-Received: by 2002:a05:6512:6c:: with SMTP id i12mr17543068lfo.40.1570468842544;
        Mon, 07 Oct 2019 10:20:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id b10sm3234204lji.48.2019.10.07.10.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 10:20:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8D95A18063D; Mon,  7 Oct 2019 19:20:40 +0200 (CEST)
Subject: [PATCH bpf-next v3 5/5] selftests: Add tests for XDP chain calls
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Mon, 07 Oct 2019 19:20:40 +0200
Message-ID: <157046884049.2092443.15712793847213275225.stgit@alrua-x1>
In-Reply-To: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
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
 tools/testing/selftests/bpf/progs/xdp_dummy.c |    6 
 tools/testing/selftests/bpf/test_xdp_chain.sh |   77 ++++++
 tools/testing/selftests/bpf/xdp_chain.c       |  313 +++++++++++++++++++++++++
 5 files changed, 399 insertions(+), 1 deletion(-)
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
index 000000000000..4b3fa26224fa
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdp_chain.c
@@ -0,0 +1,313 @@
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
+	if ((ret = bpf_set_link_xdp_fd(ifindex, -1, xdp_flags)))
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
+		"    -c			Cleanup and exit\n"
+		"    -v			Verbose eBPF logging\n",
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
+struct bpf_program {
+	/* Index in elf obj file, for relocation use. */
+	int idx;
+	char *name;
+	int prog_ifindex;
+	char *section_name;
+	/* section_name with / replaced by _; makes recursive pinning
+	 * in bpf_object__pin_programs easier
+	 */
+	char *pin_name;
+	struct bpf_insn *insns;
+	size_t insns_cnt, main_prog_cnt;
+	enum bpf_prog_type type;
+
+	struct reloc_desc {
+		enum {
+			RELO_LD64,
+			RELO_CALL,
+			RELO_DATA,
+		} type;
+		int insn_idx;
+		union {
+			int map_idx;
+			int text_off;
+		};
+	} *reloc_desc;
+	int nr_reloc;
+	int log_level;
+
+	struct {
+		int nr;
+		int *fds;
+	} instances;
+	bpf_program_prep_t preprocessor;
+
+	struct bpf_object *obj;
+	void *priv;
+	bpf_program_clear_priv_t clear_priv;
+
+	enum bpf_attach_type expected_attach_type;
+	void *func_info;
+	__u32 func_info_rec_size;
+	__u32 func_info_cnt;
+
+	struct bpf_capabilities *caps;
+
+	void *line_info;
+	__u32 line_info_rec_size;
+	__u32 line_info_cnt;
+	__u32 prog_flags;
+};
+
+static int printfunc(enum libbpf_print_level level, const char *format, va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
+
+int main(int argc, char **argv)
+{
+	__u32 mode_flags = XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE;
+	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	bool setup_only = false, cleanup_only = false;
+	struct bpf_program *pass_prog, *drop_prog, *prog;
+	int pass_prog_fd = -1, drop_prog_fd = -1;
+	const char *filename = "xdp_dummy.o";
+	int opt, ret = 1, log_level = 0;
+	const char *optstr = "I:NSxcv";
+	struct bpf_object *obj;
+	u32 prog_id;
+
+	struct bpf_object_open_attr open_attr = {
+						 .file = filename,
+						 .prog_type = BPF_PROG_TYPE_XDP,
+	};
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
+		case 'v':
+			log_level = 7;
+			break;
+		case 'c':
+			cleanup_only = true;
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
+	if (log_level)
+		libbpf_set_print(printfunc);
+
+	obj = bpf_object__open_xattr(&open_attr);
+
+	bpf_object__for_each_program(prog, obj) {
+		bpf_program__set_type(prog, BPF_PROG_TYPE_XDP);
+		prog->prog_flags = BPF_F_CHAIN_CALLS;
+		prog->log_level = log_level;
+		if ((ret = bpf_program__load(prog, "GPL", 0))) {
+			fprintf(stderr, "unable to load program: %s\n", strerror(-ret));
+			return 1;
+		}
+	}
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
+	if ((ret = bpf_set_link_xdp_fd(ifindex, pass_prog_fd, xdp_flags)) < 0) {
+		fprintf(stderr, "Link set xdp fd failed for %s: %s\n", ifname,
+			strerror(-ret));
+		goto done;
+	}
+
+	if (!setup_only) {
+		sleep(1);
+		RUN_PING(false, "Empty map test");
+	}
+
+	if (bpf_prog_chain_add(pass_prog_fd, -1, drop_prog_fd)) {
+		fprintf(stderr, "unable to add chain prog wildcard: %s (%d)\n", strerror(errno), errno);
+		goto done;
+	}
+
+	if (bpf_prog_chain_get(pass_prog_fd, -1, &prog_id)) {
+		fprintf(stderr, "unable to get chain prog wildcard: %s (%d)\n", strerror(errno), errno);
+		goto done;
+	}
+	printf("Next program attached with ID: %u\n", prog_id);
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
+	if (bpf_prog_chain_del(pass_prog_fd, -1)) {
+		fprintf(stderr, "unable to delete chain prog: %s\n", strerror(errno));
+		goto done;
+	}
+	sleep(1);
+
+	RUN_PING(false, "Post-delete map test");
+
+	if (bpf_prog_chain_add(pass_prog_fd, XDP_PASS, drop_prog_fd)) {
+		fprintf(stderr, "unable to add chain prog PASS: %s\n", strerror(errno));
+		goto done;
+	}
+	sleep(1);
+
+	RUN_PING(true, "Pass act test");
+
+
+	if ((ret = bpf_set_link_xdp_fd(ifindex, -1, xdp_flags)) < 0) {
+		fprintf(stderr, "Link clear xdp fd failed for %s: '%s'\n", ifname, strerror(-ret));
+		goto done;
+	}
+	sleep(1);
+
+	RUN_PING(false, "Post-delete prog test");
+
+
+done:
+	if (!setup_only)
+		cleanup(ret);
+
+	if (pass_prog_fd > 0)
+		close(pass_prog_fd);
+	if (drop_prog_fd > 0)
+		close(drop_prog_fd);
+
+	return ret;
+}

