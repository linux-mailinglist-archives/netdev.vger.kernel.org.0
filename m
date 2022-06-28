Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3543555EE45
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiF1Tvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiF1Tuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BC43A723;
        Tue, 28 Jun 2022 12:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445763; x=1687981763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KbJE5i/cRb03yyCvDDOc+EAdI2CUGvTU4bgCehvnLDQ=;
  b=D6udilx3ynGdEGjhEKdwYxnco3wySIGNFDkZ1hqEB0L+I5AGbxksNqy5
   GbcVA9/fSW7Nlvd7kEc2UNv4TZmZoucXNVGoXurRuZkf0k7KhCdxfcj2R
   9o+IMHjN1RV2VGycfP9mi0IT83ghkIWrwH+yRdhBkYbQuMN9outhApJk/
   BIrjr2tUsUOy5q8kaa0e9mxsb2I1XBZ/8ligj0qcsPvIq3qAeJFvRJ9Ps
   H100sVpDPn4oBVjeD2rTNAf7/XOvZpGDlXfrhkSpFT/X4zdU/cGUXH5nw
   5lsyZgYUNeqOPZ5sNNXDC3Q5M8UGAY6jnC9N6jyV14KFk6RLvBJeQQILu
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="345828388"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="345828388"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="565181222"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 28 Jun 2022 12:49:18 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9H022013;
        Tue, 28 Jun 2022 20:49:16 +0100
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
Subject: [PATCH RFC bpf-next 17/52] samples/bpf: pass a struct to sample_install_xdp()
Date:   Tue, 28 Jun 2022 21:47:37 +0200
Message-Id: <20220628194812.1453059-18-alexandr.lobakin@intel.com>
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

In order to be able to pass more flags and/or other options to
sample_install_xdp() from userland programs built on top of this
framework, make it consume a const pointer to a structure with
all the parameters needed to initialize the sample instead of
a set of standalone parameters which doesn't scale.
Adjust all the samples accordingly.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 samples/bpf/xdp_redirect_cpu_user.c       | 24 +++++++++++------------
 samples/bpf/xdp_redirect_map_multi_user.c | 19 +++++++++---------
 samples/bpf/xdp_redirect_map_user.c       | 15 +++++++-------
 samples/bpf/xdp_redirect_user.c           | 15 +++++++-------
 samples/bpf/xdp_router_ipv4_user.c        | 13 ++++++------
 samples/bpf/xdp_sample_user.c             | 12 +++++++-----
 samples/bpf/xdp_sample_user.h             | 10 ++++++++--
 7 files changed, 58 insertions(+), 50 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index a12381c37d2b..15745d8cb5c2 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -306,6 +306,9 @@ int main(int argc, char **argv)
 {
 	const char *redir_interface = NULL, *redir_map = NULL;
 	const char *mprog_filename = NULL, *mprog_name = NULL;
+	struct sample_install_opts opts = {
+		.ifindex = -1,
+	};
 	struct xdp_redirect_cpu *skel;
 	struct bpf_map_info info = {};
 	struct bpf_cpumap_val value;
@@ -315,13 +318,10 @@ int main(int argc, char **argv)
 	bool stress_mode = false;
 	struct bpf_program *prog;
 	const char *prog_name;
-	bool generic = false;
-	bool force = false;
 	int added_cpus = 0;
 	bool error = true;
 	int longindex = 0;
 	int add_cpu = -1;
-	int ifindex = -1;
 	int *cpu, i, opt;
 	__u32 qsize;
 	int n_cpus;
@@ -391,10 +391,10 @@ int main(int argc, char **argv)
 				usage(argv, long_options, __doc__, mask, true, skel->obj);
 				goto end_cpu;
 			}
-			ifindex = if_nametoindex(optarg);
-			if (!ifindex)
-				ifindex = strtoul(optarg, NULL, 0);
-			if (!ifindex) {
+			opts.ifindex = if_nametoindex(optarg);
+			if (!opts.ifindex)
+				opts.ifindex = strtoul(optarg, NULL, 0);
+			if (!opts.ifindex) {
 				fprintf(stderr, "Bad interface index or name (%d): %s\n",
 					errno, strerror(errno));
 				usage(argv, long_options, __doc__, mask, true, skel->obj);
@@ -408,7 +408,7 @@ int main(int argc, char **argv)
 			interval = strtoul(optarg, NULL, 0);
 			break;
 		case 'S':
-			generic = true;
+			opts.generic = true;
 			break;
 		case 'x':
 			stress_mode = true;
@@ -456,7 +456,7 @@ int main(int argc, char **argv)
 			qsize = strtoul(optarg, NULL, 0);
 			break;
 		case 'F':
-			force = true;
+			opts.force = true;
 			break;
 		case 'v':
 			sample_switch_mode();
@@ -470,7 +470,7 @@ int main(int argc, char **argv)
 	}
 
 	ret = EXIT_FAIL_OPTION;
-	if (ifindex == -1) {
+	if (opts.ifindex == -1) {
 		fprintf(stderr, "Required option --dev missing\n");
 		usage(argv, long_options, __doc__, mask, true, skel->obj);
 		goto end_cpu;
@@ -483,7 +483,7 @@ int main(int argc, char **argv)
 		goto end_cpu;
 	}
 
-	skel->rodata->from_match[0] = ifindex;
+	skel->rodata->from_match[0] = opts.ifindex;
 	if (redir_interface)
 		skel->rodata->to_match[0] = if_nametoindex(redir_interface);
 
@@ -540,7 +540,7 @@ int main(int argc, char **argv)
 	}
 
 	ret = EXIT_FAIL_XDP;
-	if (sample_install_xdp(prog, ifindex, generic, force) < 0)
+	if (sample_install_xdp(prog, &opts) < 0)
 		goto end_cpu;
 
 	ret = sample_run(interval, stress_mode ? stress_cpumap : NULL, &value);
diff --git a/samples/bpf/xdp_redirect_map_multi_user.c b/samples/bpf/xdp_redirect_map_multi_user.c
index 9e24f2705b67..85e66f9dc259 100644
--- a/samples/bpf/xdp_redirect_map_multi_user.c
+++ b/samples/bpf/xdp_redirect_map_multi_user.c
@@ -77,6 +77,7 @@ static int update_mac_map(struct bpf_map *map)
 int main(int argc, char **argv)
 {
 	struct bpf_devmap_val devmap_val = {};
+	struct sample_install_opts opts = { };
 	struct xdp_redirect_map_multi *skel;
 	struct bpf_program *ingress_prog;
 	bool xdp_devmap_attached = false;
@@ -84,9 +85,6 @@ int main(int argc, char **argv)
 	int ret = EXIT_FAIL_OPTION;
 	unsigned long interval = 2;
 	char ifname[IF_NAMESIZE];
-	unsigned int ifindex;
-	bool generic = false;
-	bool force = false;
 	bool tried = false;
 	bool error = true;
 	int i, opt;
@@ -95,13 +93,13 @@ int main(int argc, char **argv)
 				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'S':
-			generic = true;
+			opts.generic = true;
 			/* devmap_xmit tracepoint not available */
 			mask &= ~(SAMPLE_DEVMAP_XMIT_CNT |
 				  SAMPLE_DEVMAP_XMIT_CNT_MULTI);
 			break;
 		case 'F':
-			force = true;
+			opts.force = true;
 			break;
 		case 'X':
 			xdp_devmap_attached = true;
@@ -186,13 +184,13 @@ int main(int argc, char **argv)
 	forward_map = skel->maps.forward_map_native;
 
 	for (i = 0; ifaces[i] > 0; i++) {
-		ifindex = ifaces[i];
+		opts.ifindex = ifaces[i];
 
 		ret = EXIT_FAIL_XDP;
 restart:
 		/* bind prog_fd to each interface */
-		if (sample_install_xdp(ingress_prog, ifindex, generic, force) < 0) {
-			if (generic && !tried) {
+		if (sample_install_xdp(ingress_prog, &opts) < 0) {
+			if (opts.generic && !tried) {
 				fprintf(stderr,
 					"Trying fallback to sizeof(int) as value_size for devmap in generic mode\n");
 				ingress_prog = skel->progs.xdp_redirect_map_general;
@@ -206,10 +204,11 @@ int main(int argc, char **argv)
 		/* Add all the interfaces to forward group and attach
 		 * egress devmap program if exist
 		 */
-		devmap_val.ifindex = ifindex;
+		devmap_val.ifindex = opts.ifindex;
 		if (xdp_devmap_attached)
 			devmap_val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_devmap_prog);
-		ret = bpf_map_update_elem(bpf_map__fd(forward_map), &ifindex, &devmap_val, 0);
+		ret = bpf_map_update_elem(bpf_map__fd(forward_map),
+					  &opts.ifindex, &devmap_val, 0);
 		if (ret < 0) {
 			fprintf(stderr, "Failed to update devmap value: %s\n",
 				strerror(errno));
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index b6e4fc849577..d09ef866e62b 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -43,6 +43,7 @@ static const struct option long_options[] = {
 int main(int argc, char **argv)
 {
 	struct bpf_devmap_val devmap_val = {};
+	struct sample_install_opts opts = { };
 	bool xdp_devmap_attached = false;
 	struct xdp_redirect_map *skel;
 	char str[2 * IF_NAMESIZE + 1];
@@ -53,8 +54,6 @@ int main(int argc, char **argv)
 	unsigned long interval = 2;
 	int ret = EXIT_FAIL_OPTION;
 	struct bpf_program *prog;
-	bool generic = false;
-	bool force = false;
 	bool tried = false;
 	bool error = true;
 	int opt, key = 0;
@@ -63,13 +62,13 @@ int main(int argc, char **argv)
 				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'S':
-			generic = true;
+			opts.generic = true;
 			/* devmap_xmit tracepoint not available */
 			mask &= ~(SAMPLE_DEVMAP_XMIT_CNT |
 				  SAMPLE_DEVMAP_XMIT_CNT_MULTI);
 			break;
 		case 'F':
-			force = true;
+			opts.force = true;
 			break;
 		case 'X':
 			xdp_devmap_attached = true;
@@ -157,13 +156,14 @@ int main(int argc, char **argv)
 	prog = skel->progs.xdp_redirect_map_native;
 	tx_port_map = skel->maps.tx_port_native;
 restart:
-	if (sample_install_xdp(prog, ifindex_in, generic, force) < 0) {
+	opts.ifindex = ifindex_in;
+	if (sample_install_xdp(prog, &opts) < 0) {
 		/* First try with struct bpf_devmap_val as value for generic
 		 * mode, then fallback to sizeof(int) for older kernels.
 		 */
 		fprintf(stderr,
 			"Trying fallback to sizeof(int) as value_size for devmap in generic mode\n");
-		if (generic && !tried) {
+		if (opts.generic && !tried) {
 			prog = skel->progs.xdp_redirect_map_general;
 			tx_port_map = skel->maps.tx_port_general;
 			tried = true;
@@ -174,7 +174,8 @@ int main(int argc, char **argv)
 	}
 
 	/* Loading dummy XDP prog on out-device */
-	sample_install_xdp(skel->progs.xdp_redirect_dummy_prog, ifindex_out, generic, force);
+	opts.ifindex = ifindex_out;
+	sample_install_xdp(skel->progs.xdp_redirect_dummy_prog, &opts);
 
 	devmap_val.ifindex = ifindex_out;
 	if (xdp_devmap_attached)
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 8663dd631b6e..2da686a9b8a0 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -41,6 +41,7 @@ static const struct option long_options[] = {
 
 int main(int argc, char **argv)
 {
+	struct sample_install_opts opts = { };
 	int ifindex_in, ifindex_out, opt;
 	char str[2 * IF_NAMESIZE + 1];
 	char ifname_out[IF_NAMESIZE];
@@ -48,20 +49,18 @@ int main(int argc, char **argv)
 	int ret = EXIT_FAIL_OPTION;
 	unsigned long interval = 2;
 	struct xdp_redirect *skel;
-	bool generic = false;
-	bool force = false;
 	bool error = true;
 
 	while ((opt = getopt_long(argc, argv, "hSFi:vs",
 				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'S':
-			generic = true;
+			opts.generic = true;
 			mask &= ~(SAMPLE_DEVMAP_XMIT_CNT |
 				  SAMPLE_DEVMAP_XMIT_CNT_MULTI);
 			break;
 		case 'F':
-			force = true;
+			opts.force = true;
 			break;
 		case 'i':
 			interval = strtoul(optarg, NULL, 0);
@@ -132,13 +131,13 @@ int main(int argc, char **argv)
 	}
 
 	ret = EXIT_FAIL_XDP;
-	if (sample_install_xdp(skel->progs.xdp_redirect_prog, ifindex_in,
-			       generic, force) < 0)
+	opts.ifindex = ifindex_in;
+	if (sample_install_xdp(skel->progs.xdp_redirect_prog, &opts) < 0)
 		goto end_destroy;
 
 	/* Loading dummy XDP prog on out-device */
-	sample_install_xdp(skel->progs.xdp_redirect_dummy_prog, ifindex_out,
-			   generic, force);
+	opts.ifindex = ifindex_out;
+	sample_install_xdp(skel->progs.xdp_redirect_dummy_prog, &opts);
 
 	ret = EXIT_FAIL;
 	if (!if_indextoname(ifindex_in, ifname_in)) {
diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index 294fc15ad1cb..48e9bcb38c8e 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -549,13 +549,14 @@ static void usage(char *argv[], const struct option *long_options,
 
 int main(int argc, char **argv)
 {
-	bool error = true, generic = false, force = false;
+	struct sample_install_opts opts = { };
 	int opt, ret = EXIT_FAIL_BPF;
 	struct xdp_router_ipv4 *skel;
 	int i, total_ifindex = argc - 1;
 	char **ifname_list = argv + 1;
 	pthread_t routes_thread;
 	int longindex = 0;
+	bool error = true;
 
 	if (libbpf_set_strict_mode(LIBBPF_STRICT_ALL) < 0) {
 		fprintf(stderr, "Failed to set libbpf strict mode: %s\n",
@@ -606,12 +607,12 @@ int main(int argc, char **argv)
 			ifname_list += 2;
 			break;
 		case 'S':
-			generic = true;
+			opts.generic = true;
 			total_ifindex--;
 			ifname_list++;
 			break;
 		case 'F':
-			force = true;
+			opts.force = true;
 			total_ifindex--;
 			ifname_list++;
 			break;
@@ -661,15 +662,15 @@ int main(int argc, char **argv)
 
 	ret = EXIT_FAIL_XDP;
 	for (i = 0; i < total_ifindex; i++) {
-		int index = if_nametoindex(ifname_list[i]);
+		opts.ifindex = if_nametoindex(ifname_list[i]);
 
-		if (!index) {
+		if (!opts.ifindex) {
 			fprintf(stderr, "Interface %s not found %s\n",
 				ifname_list[i], strerror(-tx_port_map_fd));
 			goto end_destroy;
 		}
 		if (sample_install_xdp(skel->progs.xdp_router_ipv4_prog,
-				       index, generic, force) < 0)
+				       &opts) < 0)
 			goto end_destroy;
 	}
 
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index 158682852162..8bc23b4c5f19 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -1280,9 +1280,10 @@ static int __sample_remove_xdp(int ifindex, __u32 prog_id, int xdp_flags)
 	return bpf_xdp_detach(ifindex, xdp_flags, NULL);
 }
 
-int sample_install_xdp(struct bpf_program *xdp_prog, int ifindex, bool generic,
-		       bool force)
+int sample_install_xdp(struct bpf_program *xdp_prog,
+		       const struct sample_install_opts *opts)
 {
+	__u32 ifindex = opts->ifindex;
 	int ret, xdp_flags = 0;
 	__u32 prog_id = 0;
 
@@ -1292,8 +1293,8 @@ int sample_install_xdp(struct bpf_program *xdp_prog, int ifindex, bool generic,
 		return -ENOTSUP;
 	}
 
-	xdp_flags |= !force ? XDP_FLAGS_UPDATE_IF_NOEXIST : 0;
-	xdp_flags |= generic ? XDP_FLAGS_SKB_MODE : XDP_FLAGS_DRV_MODE;
+	xdp_flags |= !opts->force ? XDP_FLAGS_UPDATE_IF_NOEXIST : 0;
+	xdp_flags |= opts->generic ? XDP_FLAGS_SKB_MODE : XDP_FLAGS_DRV_MODE;
 	ret = bpf_xdp_attach(ifindex, bpf_program__fd(xdp_prog), xdp_flags, NULL);
 	if (ret < 0) {
 		ret = -errno;
@@ -1301,7 +1302,8 @@ int sample_install_xdp(struct bpf_program *xdp_prog, int ifindex, bool generic,
 			"Failed to install program \"%s\" on ifindex %d, mode = %s, "
 			"force = %s: %s\n",
 			bpf_program__name(xdp_prog), ifindex,
-			generic ? "skb" : "native", force ? "true" : "false",
+			opts->generic ? "skb" : "native",
+			opts->force ? "true" : "false",
 			strerror(-ret));
 		return ret;
 	}
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index f45051679977..22afe844ae30 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -30,14 +30,20 @@ enum stats_mask {
 #define EXIT_FAIL_BPF		4
 #define EXIT_FAIL_MEM		5
 
+struct sample_install_opts {
+	int ifindex;
+	__u32 force:1;
+	__u32 generic:1;
+};
+
 int sample_setup_maps(struct bpf_map **maps);
 int __sample_init(int mask);
 void sample_exit(int status);
 int sample_run(int interval, void (*post_cb)(void *), void *ctx);
 
 void sample_switch_mode(void);
-int sample_install_xdp(struct bpf_program *xdp_prog, int ifindex, bool generic,
-		       bool force);
+int sample_install_xdp(struct bpf_program *xdp_prog,
+		       const struct sample_install_opts *opts);
 void sample_usage(char *argv[], const struct option *long_options,
 		  const char *doc, int mask, bool error);
 
-- 
2.36.1

