Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F01355EE7F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiF1TyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiF1TvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47947255A1;
        Tue, 28 Jun 2022 12:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445811; x=1687981811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wbvvAWouY8kIt2EWeEUGtmZGTMgYa6RloKIfiZ8Lck0=;
  b=YK8G31fS+fBc/gZlcnuIZ+aEpXzBy4p/6KCe+MZ91lz8y1J70bJ6FDNn
   wUbk0LgylyB16QqpOKS9sGvKKgccuyNQxSsijlsKQTTn3dvjTQ/sQ97Qq
   euG7bCg6Y1yrzjq/LtxmwNsXqFUhub6eMC/eTUaiaHGQrDzHyo3/r0/Z3
   yi2CvGc6IkNicFD/3yL++5E6bkb1wliihx0KPb+6wjGNVU0nx6JWPNHVh
   qjivwr8hxMWimSbEQ1wBnD5rberzz7U2gZh/F8blSDPcLgrajQJRHStcM
   v8sviiDgs9ow2KCpnkqRvVRdw4pTSggmyjbbWhBN+MSywLCtGTcalevpM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="345828556"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="345828556"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:50:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="623054308"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 28 Jun 2022 12:50:05 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9q022013;
        Tue, 28 Jun 2022 20:50:03 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 52/52] selftests/bpf: add XDP Generic Hints selftest
Date:   Tue, 28 Jun 2022 21:48:12 +0200
Message-Id: <20220628194812.1453059-53-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new BPF selftest which checks whether XDP Generic metadata
works correctly using generic/skb XDP path. It is always available
on any interface, so must always succeed.
It uses special BPF program which works as follows:

* tries to access metadata memory via bpf_access_mem_end();
* checks the frame size. For sizes < 128 bytes, drop packets with
  metadata present, so that we could check that setting the
  threshold works;
* for sizes 128+, drop packets with no meta. Otherwise, check that
  it has correct magic and BTF ID matches with the one written by
  the verifier;
* finally, pass packets with fully correct generic meta up the
  stack.

And the test itself does the following:

1) attaches that XDP prog to veth interfaces with the threshold of
   1, i.e. enable metadata generation for every packet;
2) ensures that the prog drops frames lesser than 128 bytes as
   intended (see above);
3) raises the threshold to 128 bytes (test updating the parameters
   without replacing the prog);
4) ensures that now no drops occur and that meta for frames >= 128
   is valid.

As it involves multiple userspace prog invocation, it performs BPF
link pinning to make it freerunning. `ip netns exec` creates a new
mount namespace (including sysfs) on each execution, the script
now does a temporary persistent BPF FS mountpoint in the tests
directory, so that pinned progs/links will be accessible across
the launches.

Co-developed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../selftests/bpf/progs/test_xdp_meta.c       |  36 +++
 tools/testing/selftests/bpf/test_xdp_meta.c   | 294 ++++++++++++++++++
 tools/testing/selftests/bpf/test_xdp_meta.sh  |  51 +++
 5 files changed, 385 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/test_xdp_meta.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index ca2f47f45670..7d4de9d9002c 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -44,3 +44,4 @@ test_cpp
 xdpxceiver
 xdp_redirect_multi
 xdp_synproxy
+/test_xdp_meta
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 4fbd88a8ed9e..aca8867deb8c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -82,7 +82,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
-	xdpxceiver xdp_redirect_multi xdp_synproxy
+	xdpxceiver xdp_redirect_multi xdp_synproxy test_xdp_meta
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 
@@ -589,6 +589,8 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o \
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o,$^) $(LDLIBS) -o $@
 
+$(OUTPUT)/test_xdp_meta: | $(OUTPUT)/test_xdp_meta.skel.h
+
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR) $(HOST_SCRATCH_DIR)	\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature bpftool							\
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_meta.c b/tools/testing/selftests/bpf/progs/test_xdp_meta.c
index fe2d71ae0e71..0b05d1c3979b 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_meta.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_meta.c
@@ -2,6 +2,8 @@
 #include <linux/if_ether.h>
 #include <linux/pkt_cls.h>
 
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_endian.h>
 #include <bpf/bpf_helpers.h>
 
 #define __round_mask(x, y) ((__typeof__(x))((y) - 1))
@@ -50,4 +52,38 @@ int ing_xdp(struct xdp_md *ctx)
 	return XDP_PASS;
 }
 
+#define TEST_META_THRESH	128
+
+SEC("xdp")
+int ing_hints(struct xdp_md *ctx)
+{
+	const struct xdp_meta_generic *md;
+	__le64 genid;
+
+	md = bpf_access_mem_end(ctx->data_meta, ctx->data, sizeof(*md),
+				sizeof(*md));
+
+	/* Selftest enables metadata starting from 128 byte frame size, fail it
+	 * if we receive a shorter frame with metadata
+	 */
+	if (ctx->data_end - ctx->data < TEST_META_THRESH)
+		return md ? XDP_DROP : XDP_PASS;
+
+	if (!md)
+		return XDP_DROP;
+
+	if (md->magic_id != bpf_cpu_to_le16(XDP_META_GENERIC_MAGIC))
+		return XDP_DROP;
+
+	genid = bpf_cpu_to_le64(bpf_core_type_id_kernel(typeof(*md)));
+	if (md->full_id != genid)
+		return XDP_DROP;
+
+	/* Tx flags must be zeroed */
+	if (md->tx_flags)
+		return XDP_DROP;
+
+	return XDP_PASS;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_xdp_meta.c b/tools/testing/selftests/bpf/test_xdp_meta.c
new file mode 100644
index 000000000000..e5c147d19190
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_meta.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022, Intel Corporation. */
+
+#define _GNU_SOURCE	/* asprintf() */
+
+#include <bpf/bpf.h>
+#include <getopt.h>
+#include <net/if.h>
+#include <uapi/linux/if_link.h>
+
+#include "test_xdp_meta.skel.h"
+
+struct test_meta_op_opts {
+	struct test_xdp_meta	*skel;
+	const char		*cmd;
+	char			*path;
+	__u32			ifindex;
+	__u32			flags;
+	__u64			btf_id;
+	__u32			meta_thresh;
+};
+
+struct test_meta_opt_desc {
+	const char		*arg;
+	const char		*help;
+};
+
+#define OPT(n, a, s) {				\
+	.name			= #n,		\
+	.has_arg		= (a),		\
+	.val			= #s[0],	\
+}
+
+#define DESC(a, h) {				\
+	.arg			= (a),		\
+	.help			= (h),		\
+}
+
+static const struct option test_meta_opts[] = {
+	OPT(dev,		required_argument,	d),
+	OPT(fs,			required_argument,	f),
+	OPT(help,		no_argument,		h),
+	OPT(meta-thresh,	optional_argument,	M),
+	OPT(mode,		required_argument,	m),
+	{ /* Sentinel */ },
+};
+
+static const struct test_meta_opt_desc test_meta_descs[] = {
+	DESC("= < IFNAME | IFINDEX >", "target interface name or index"),
+	DESC("= < MOUNTPOINT >", "BPF FS mountpoint"),
+	DESC(NULL, "display this text and exit"),
+	DESC("= [ THRESH ]", "enable Generic metadata generation (frame size)"),
+	DESC("= < skb | drv | hw >", "force particular XDP mode"),
+};
+
+static void test_meta_usage(char *argv[], bool err)
+{
+	FILE *out = err ? stderr : stdout;
+	__u32 i = 0;
+
+	fprintf(out,
+		"Usage:\n\t%s COMMAND < -d | --dev= >  < IFNAME | IFINDEX > [ OPTIONS ]\n\n",
+		argv[0]);
+	fprintf(out, "OPTIONS:\n");
+
+	for (const struct option *opt = test_meta_opts; opt->name; opt++) {
+		fprintf(out, "\t-%c, --%s", opt->val, opt->name);
+		fprintf(out, "%s\t", test_meta_descs[i].arg ? : "\t\t");
+		fprintf(out, "%s\n", test_meta_descs[i++].help);
+	}
+}
+
+static int test_meta_link_attach(const struct test_meta_op_opts *opts)
+{
+	LIBBPF_OPTS(bpf_xdp_attach_opts, la_opts,
+		    .flags		= opts->flags,
+		    .btf_id		= opts->btf_id,
+		    .meta_thresh	= opts->meta_thresh);
+	struct bpf_link *link;
+	int ret;
+
+	link = bpf_program__attach_xdp_opts(opts->skel->progs.ing_hints,
+					    opts->ifindex, &la_opts);
+	ret = libbpf_get_error(link);
+	if (ret) {
+		fprintf(stderr, "Failed to attach XDP program: %s (%d)\n",
+			strerror(-ret), ret);
+		return ret;
+	}
+
+	opts->skel->links.ing_hints = link;
+
+	ret = bpf_link__pin(link, opts->path);
+	if (ret)
+		fprintf(stderr, "Failed to pin XDP link at %s: %s (%d)\n",
+			opts->path, strerror(-ret), ret);
+
+	bpf_link__disconnect(link);
+
+	return ret;
+}
+
+static int test_meta_link_update(const struct test_meta_op_opts *opts)
+{
+	LIBBPF_OPTS(bpf_link_update_opts, lu_opts,
+		    .xdp.new_btf_id		= opts->btf_id,
+		    .xdp.new_meta_thresh	= opts->meta_thresh);
+	struct bpf_link *link;
+	int ret;
+
+	link = bpf_link__open(opts->path);
+	ret = libbpf_get_error(link);
+	if (ret) {
+		fprintf(stderr, "Failed to open XDP link at %s: %s (%d)\n",
+			opts->path, strerror(-ret), ret);
+		return ret;
+	}
+
+	opts->skel->links.ing_hints = link;
+
+	ret = bpf_link_update(bpf_link__fd(link),
+			      bpf_program__fd(opts->skel->progs.ing_hints),
+			      &lu_opts);
+	if (ret)
+		fprintf(stderr, "Failed to update XDP link: %s (%d)\n",
+			strerror(-ret), ret);
+
+	return ret;
+}
+
+static int test_meta_link_detach(const struct test_meta_op_opts *opts)
+{
+	struct bpf_link *link;
+	int ret;
+
+	link = bpf_link__open(opts->path);
+	ret = libbpf_get_error(link);
+	if (ret) {
+		fprintf(stderr, "Failed to open XDP link at %s: %s (%d)\n",
+			opts->path, strerror(-ret), ret);
+		return ret;
+	}
+
+	opts->skel->links.ing_hints = link;
+
+	ret = bpf_link__unpin(link);
+	if (ret) {
+		fprintf(stderr, "Failed to unpin XDP link: %s (%d)\n",
+			strerror(-ret), ret);
+		return ret;
+	}
+
+	ret = bpf_link__detach(link);
+	if (ret)
+		fprintf(stderr, "Failed to detach XDP link: %s (%d)\n",
+			strerror(-ret), ret);
+
+	return ret;
+}
+
+static int test_meta_parse_args(struct test_meta_op_opts *opts, int argc,
+				char *argv[])
+{
+	int opt, longidx, ret;
+
+	while (1) {
+		opt = getopt_long(argc, argv, "d:f:hM::m:", test_meta_opts,
+				  &longidx);
+		if (opt < 0)
+			break;
+
+		switch (opt) {
+		case 'd':
+			opts->ifindex = if_nametoindex(optarg);
+			if (!opts->ifindex)
+				opts->ifindex = strtoul(optarg, NULL, 0);
+
+			break;
+		case 'f':
+			opts->path = optarg;
+			break;
+		case 'h':
+			test_meta_usage(argv, false);
+			return 0;
+		case 'M':
+			ret = libbpf_get_type_btf_id("struct xdp_meta_generic",
+						     &opts->btf_id);
+			if (ret) {
+				fprintf(stderr,
+					"Failed to get BTF ID: %s (%d)\n",
+					strerror(-ret), ret);
+				return ret;
+			}
+
+			/* Allow both `-M64` and `-M 64` */
+			if (!optarg && optind < argc && argv[optind] &&
+			    *argv[optind] >= '0' && *argv[optind] <= '9')
+				optarg = argv[optind];
+
+			opts->meta_thresh = strtoul(optarg ? : "1", NULL, 0);
+			break;
+		case 'm':
+			if (!strcmp(optarg, "skb"))
+				opts->flags = XDP_FLAGS_SKB_MODE;
+			else if (!strcmp(optarg, "drv"))
+				opts->flags = XDP_FLAGS_DRV_MODE;
+			else if (!strcmp(optarg, "hw"))
+				opts->flags = XDP_FLAGS_HW_MODE;
+
+			if (opts->flags)
+				break;
+
+			/* fallthrough */
+		default:
+			test_meta_usage(argv, true);
+			return -EINVAL;
+		}
+	}
+
+	if (optind >= argc || !argv[optind]) {
+		fprintf(stderr, "Command is required\n");
+		test_meta_usage(argv, true);
+
+		return -EINVAL;
+	}
+
+	opts->cmd = argv[optind];
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct test_meta_op_opts opts = { };
+	int ret;
+
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
+	if (argc < 3) {
+		test_meta_usage(argv, true);
+		return -EINVAL;
+	}
+
+	ret = test_meta_parse_args(&opts, argc, argv);
+	if (ret)
+		return ret;
+
+	if (!opts.ifindex) {
+		fprintf(stderr, "Invalid or missing device argument\n");
+		test_meta_usage(argv, true);
+
+		return -EINVAL;
+	}
+
+	opts.skel = test_xdp_meta__open_and_load();
+	ret = libbpf_get_error(opts.skel);
+	if (ret) {
+		fprintf(stderr, "Failed to load test_xdp_meta skeleton: %s (%d)\n",
+			strerror(-ret), ret);
+		return ret;
+	}
+
+	ret = asprintf(&opts.path, "%s/xdp/%s-%u", opts.path ? : "/sys/fs/bpf",
+		       opts.skel->skeleton->name, opts.ifindex);
+	ret = ret < 0 ? -errno : 0;
+	if (ret) {
+		fprintf(stderr, "Failed to allocate path string: %s (%d)\n",
+			strerror(-ret), ret);
+		goto meta_destroy;
+	}
+
+	if (!strcmp(opts.cmd, "attach")) {
+		ret = test_meta_link_attach(&opts);
+	} else if (!strcmp(opts.cmd, "update")) {
+		ret = test_meta_link_update(&opts);
+	} else if (!strcmp(opts.cmd, "detach")) {
+		ret = test_meta_link_detach(&opts);
+	} else {
+		fprintf(stderr, "Invalid command '%s'\n", opts.cmd);
+		test_meta_usage(argv, true);
+
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		fprintf(stderr, "Failed to execute command '%s': %s (%d)\n",
+			opts.cmd, strerror(-ret), ret);
+
+	free(opts.path);
+meta_destroy:
+	test_xdp_meta__destroy(opts.skel);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/bpf/test_xdp_meta.sh b/tools/testing/selftests/bpf/test_xdp_meta.sh
index 7232714e89b3..79c2ccb68dda 100755
--- a/tools/testing/selftests/bpf/test_xdp_meta.sh
+++ b/tools/testing/selftests/bpf/test_xdp_meta.sh
@@ -5,6 +5,11 @@ readonly KSFT_SKIP=4
 readonly NS1="ns1-$(mktemp -u XXXXXX)"
 readonly NS2="ns2-$(mktemp -u XXXXXX)"
 
+# We need a persistent BPF FS mointpoint. `ip netns exec` prepares a different
+# temporary one on each invocation
+readonly FS="$(mktemp -d XXXXXX)"
+mount -t bpf bpffs ${FS}
+
 cleanup()
 {
 	if [ "$?" = "0" ]; then
@@ -14,9 +19,16 @@ cleanup()
 	fi
 
 	set +e
+
+	ip netns exec ${NS1} ./test_xdp_meta detach -d veth1 -f ${FS} -m skb 2> /dev/null
+	ip netns exec ${NS2} ./test_xdp_meta detach -d veth2 -f ${FS} -m skb 2> /dev/null
+
 	ip link del veth1 2> /dev/null
 	ip netns del ${NS1} 2> /dev/null
 	ip netns del ${NS2} 2> /dev/null
+
+	umount ${FS}
+	rm -fr ${FS}
 }
 
 ip link set dev lo xdp off 2>/dev/null > /dev/null
@@ -54,4 +66,43 @@ ip netns exec ${NS2} ip link set dev veth2 up
 ip netns exec ${NS1} ping -c 1 10.1.1.22
 ip netns exec ${NS2} ping -c 1 10.1.1.11
 
+#
+# Generic metadata part
+#
+
+# Cleanup
+ip netns exec ${NS1} ip link set dev veth1 xdp off
+ip netns exec ${NS2} ip link set dev veth2 xdp off
+
+ip netns exec ${NS1} tc filter del dev veth1 ingress
+ip netns exec ${NS2} tc filter del dev veth2 ingress
+
+# Enable metadata generation for every frame
+ip netns exec ${NS1} ./test_xdp_meta attach -d veth1 -f ${FS} -m skb -M
+ip netns exec ${NS2} ./test_xdp_meta attach -d veth2 -f ${FS} -m skb -M
+
+# Those two must fail: XDP prog drops packets < 128 bytes with metadata
+set +e
+
+ip netns exec ${NS1} ping -c 1 10.1.1.22 -W 0.2
+if [ "$?" = "0" ]; then
+	exit 1
+fi
+ip netns exec ${NS2} ping -c 1 10.1.1.11 -W 0.2
+if [ "$?" = "0" ]; then
+	exit 1
+fi
+
+set -e
+
+# Enable metadata only for frames >= 128 bytes
+ip netns exec ${NS1} ./test_xdp_meta update -d veth1 -f ${FS} -m skb -M 128
+ip netns exec ${NS2} ./test_xdp_meta update -d veth2 -f ${FS} -m skb -M 128
+
+# Must succeed
+ip netns exec ${NS1} ping -c 1 10.1.1.22
+ip netns exec ${NS2} ping -c 1 10.1.1.11
+ip netns exec ${NS1} ping -c 1 10.1.1.22 -s 128
+ip netns exec ${NS2} ping -c 1 10.1.1.11 -s 128
+
 exit 0
-- 
2.36.1

