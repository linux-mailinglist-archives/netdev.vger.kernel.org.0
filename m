Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9432655EE40
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiF1Tvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiF1Tuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA7A27162;
        Tue, 28 Jun 2022 12:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445768; x=1687981768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IwD1xgC8YcxcPkOhlwX1jFE7MQDmCVGifCPPmYbvVTg=;
  b=NQJzYvFJYsk03tB7pX6ZzA578GfrgNBmKOvqK/CzJicspYBiyugbwWaw
   yjkcKQXg8be/Q6K+XR2POI4Lu7hDdLWc8BUlgcW/KUhRTO7KED/Hp1vLl
   RIfsZB8kHfD1/99dcBq9WxYIKbrCRtJ+pqC78lXn6BDhYe6V0Iz4vFFGc
   Zilzd0tWTjYd6LbZL5PwUoleTonpw85oPr+ibC8HrU1u4XHuE6I/PGmB9
   Xo6kWhZiV+jxwAgijTpiHkkL7E258TUdr1jSdWHrHYQoLuek4eTBhB+DF
   Ew6z0dVQAYXoAduQftkgtUXLZiCG7lr9RXn/xZM7O0yHyxGe7x9kG0C8u
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282927829"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282927829"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="836809462"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jun 2022 12:49:19 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9I022013;
        Tue, 28 Jun 2022 20:49:18 +0100
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
Subject: [PATCH RFC bpf-next 18/52] samples/bpf: add ability to specify metadata threshold
Date:   Tue, 28 Jun 2022 21:47:38 +0200
Message-Id: <20220628194812.1453059-19-alexandr.lobakin@intel.com>
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

For all of the users of sample_install_xdp() infra (primarily for
xdp_redirect_cpu), add the ability to enable/disable/control generic
metadata generation using the new UAPI.
The format is either just '-M' to enable it unconditionally or
'--meta-thresh=<frame_size>' to enable it starting from frames
bigger than <frame_size>.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 samples/bpf/xdp_redirect_cpu_user.c       |  7 +++++-
 samples/bpf/xdp_redirect_map_multi_user.c |  7 +++++-
 samples/bpf/xdp_redirect_map_user.c       |  7 +++++-
 samples/bpf/xdp_redirect_user.c           |  6 ++++-
 samples/bpf/xdp_router_ipv4_user.c        |  7 +++++-
 samples/bpf/xdp_sample_user.c             | 28 +++++++++++++++++++----
 samples/bpf/xdp_sample_user.h             |  1 +
 7 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 15745d8cb5c2..ca457c34eb0f 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -60,6 +60,7 @@ static const struct option long_options[] = {
 	{ "mprog-filename", required_argument, NULL, 'f' },
 	{ "redirect-device", required_argument, NULL, 'r' },
 	{ "redirect-map", required_argument, NULL, 'm' },
+	{ "meta-thresh", optional_argument, NULL, 'M' },
 	{}
 };
 
@@ -382,7 +383,7 @@ int main(int argc, char **argv)
 	}
 
 	prog = skel->progs.xdp_prognum5_lb_hash_ip_pairs;
-	while ((opt = getopt_long(argc, argv, "d:si:Sxp:f:e:r:m:c:q:Fvh",
+	while ((opt = getopt_long(argc, argv, "d:si:Sxp:f:e:r:m:c:q:FMvh",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
@@ -461,6 +462,10 @@ int main(int argc, char **argv)
 		case 'v':
 			sample_switch_mode();
 			break;
+		case 'M':
+			opts.meta_thresh = optarg ? strtoul(optarg, NULL, 0) :
+					   1;
+			break;
 		case 'h':
 			error = false;
 		default:
diff --git a/samples/bpf/xdp_redirect_map_multi_user.c b/samples/bpf/xdp_redirect_map_multi_user.c
index 85e66f9dc259..b1c575f3d5f6 100644
--- a/samples/bpf/xdp_redirect_map_multi_user.c
+++ b/samples/bpf/xdp_redirect_map_multi_user.c
@@ -43,6 +43,7 @@ static const struct option long_options[] = {
 	{ "stats", no_argument, NULL, 's' },
 	{ "interval", required_argument, NULL, 'i' },
 	{ "verbose", no_argument, NULL, 'v' },
+	{ "meta-thresh", optional_argument, NULL, 'M' },
 	{}
 };
 
@@ -89,7 +90,7 @@ int main(int argc, char **argv)
 	bool error = true;
 	int i, opt;
 
-	while ((opt = getopt_long(argc, argv, "hSFXi:vs",
+	while ((opt = getopt_long(argc, argv, "hSFMXi:vs",
 				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'S':
@@ -98,6 +99,10 @@ int main(int argc, char **argv)
 			mask &= ~(SAMPLE_DEVMAP_XMIT_CNT |
 				  SAMPLE_DEVMAP_XMIT_CNT_MULTI);
 			break;
+		case 'M':
+			opts.meta_thresh = optarg ? strtoul(optarg, NULL, 0) :
+					   1;
+			break;
 		case 'F':
 			opts.force = true;
 			break;
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index d09ef866e62b..29dd7df804dc 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -37,6 +37,7 @@ static const struct option long_options[] = {
 	{ "stats", no_argument, NULL, 's' },
 	{ "interval", required_argument, NULL, 'i' },
 	{ "verbose", no_argument, NULL, 'v' },
+	{ "meta-thresh", optional_argument, NULL, 'M' },
 	{}
 };
 
@@ -58,7 +59,7 @@ int main(int argc, char **argv)
 	bool error = true;
 	int opt, key = 0;
 
-	while ((opt = getopt_long(argc, argv, "hSFXi:vs",
+	while ((opt = getopt_long(argc, argv, "hSFMXi:vs",
 				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'S':
@@ -67,6 +68,10 @@ int main(int argc, char **argv)
 			mask &= ~(SAMPLE_DEVMAP_XMIT_CNT |
 				  SAMPLE_DEVMAP_XMIT_CNT_MULTI);
 			break;
+		case 'M':
+			opts.meta_thresh = optarg ? strtoul(optarg, NULL, 0) :
+					   1;
+			break;
 		case 'F':
 			opts.force = true;
 			break;
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 2da686a9b8a0..f37c570877ca 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -36,6 +36,7 @@ static const struct option long_options[] = {
 	{"stats",	no_argument,		NULL, 's' },
 	{"interval",	required_argument,	NULL, 'i' },
 	{"verbose",	no_argument,		NULL, 'v' },
+	{"meta-thresh",	optional_argument,	NULL, 'M' },
 	{}
 };
 
@@ -51,7 +52,7 @@ int main(int argc, char **argv)
 	struct xdp_redirect *skel;
 	bool error = true;
 
-	while ((opt = getopt_long(argc, argv, "hSFi:vs",
+	while ((opt = getopt_long(argc, argv, "hSFMi:vs",
 				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'S':
@@ -59,6 +60,9 @@ int main(int argc, char **argv)
 			mask &= ~(SAMPLE_DEVMAP_XMIT_CNT |
 				  SAMPLE_DEVMAP_XMIT_CNT_MULTI);
 			break;
+		case 'M':
+			opts.meta_thresh = optarg ? strtoul(optarg, NULL, 0) :
+					   1;
 		case 'F':
 			opts.force = true;
 			break;
diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index 48e9bcb38c8e..5ff12688a31b 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -53,6 +53,7 @@ static const struct option long_options[] = {
 	{ "interval", required_argument, NULL, 'i' },
 	{ "verbose", no_argument, NULL, 'v' },
 	{ "stats", no_argument, NULL, 's' },
+	{ "meta-thresh", optional_argument, NULL, 'M' },
 	{}
 };
 
@@ -593,7 +594,7 @@ int main(int argc, char **argv)
 		goto end_destroy;
 	}
 
-	while ((opt = getopt_long(argc, argv, "si:SFvh",
+	while ((opt = getopt_long(argc, argv, "si:SFMvh",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 's':
@@ -621,6 +622,10 @@ int main(int argc, char **argv)
 			total_ifindex--;
 			ifname_list++;
 			break;
+		case 'M':
+			opts.meta_thresh = optarg ? strtoul(optarg, NULL, 0) :
+					   1;
+			break;
 		case 'h':
 			error = false;
 		default:
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index 8bc23b4c5f19..354352541c5e 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -1283,6 +1283,8 @@ static int __sample_remove_xdp(int ifindex, __u32 prog_id, int xdp_flags)
 int sample_install_xdp(struct bpf_program *xdp_prog,
 		       const struct sample_install_opts *opts)
 {
+	LIBBPF_OPTS(bpf_xdp_attach_opts, attach_opts,
+		    .meta_thresh = opts->meta_thresh);
 	__u32 ifindex = opts->ifindex;
 	int ret, xdp_flags = 0;
 	__u32 prog_id = 0;
@@ -1293,18 +1295,34 @@ int sample_install_xdp(struct bpf_program *xdp_prog,
 		return -ENOTSUP;
 	}
 
+	if (attach_opts.meta_thresh) {
+		ret = libbpf_get_type_btf_id("struct xdp_meta_generic",
+					     &attach_opts.btf_id);
+		if (ret) {
+			fprintf(stderr, "Failed to retrieve BTF ID: %s\n",
+				strerror(-ret));
+			return ret;
+		}
+	}
+
 	xdp_flags |= !opts->force ? XDP_FLAGS_UPDATE_IF_NOEXIST : 0;
 	xdp_flags |= opts->generic ? XDP_FLAGS_SKB_MODE : XDP_FLAGS_DRV_MODE;
-	ret = bpf_xdp_attach(ifindex, bpf_program__fd(xdp_prog), xdp_flags, NULL);
+	ret = bpf_xdp_attach(ifindex, bpf_program__fd(xdp_prog), xdp_flags,
+			     &attach_opts);
 	if (ret < 0) {
 		ret = -errno;
 		fprintf(stderr,
-			"Failed to install program \"%s\" on ifindex %d, mode = %s, "
-			"force = %s: %s\n",
+			"Failed to install program \"%s\" on ifindex %d, mode = %s, force = %s, metadata = ",
 			bpf_program__name(xdp_prog), ifindex,
 			opts->generic ? "skb" : "native",
-			opts->force ? "true" : "false",
-			strerror(-ret));
+			opts->force ? "true" : "false");
+		if (attach_opts.meta_thresh)
+			fprintf(stderr,
+				"true (from %u bytes, BTF ID is 0x%16llx)",
+				attach_opts.meta_thresh, attach_opts.btf_id);
+		else
+			fprintf(stderr, "false");
+		fprintf(stderr, ": %s\n", strerror(-ret));
 		return ret;
 	}
 
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index 22afe844ae30..207953406ee1 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -34,6 +34,7 @@ struct sample_install_opts {
 	int ifindex;
 	__u32 force:1;
 	__u32 generic:1;
+	__u32 meta_thresh;
 };
 
 int sample_setup_maps(struct bpf_map **maps);
-- 
2.36.1

