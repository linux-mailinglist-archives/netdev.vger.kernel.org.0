Return-Path: <netdev+bounces-9026-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A57BA7269BE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EDF82812B8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2F33924D;
	Wed,  7 Jun 2023 19:26:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D433C39240;
	Wed,  7 Jun 2023 19:26:41 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBACF1FED;
	Wed,  7 Jun 2023 12:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=Zv6v0Ud4Iqtw/hZL8+oK2LwXWr90kM8vVAzAu9mdXKA=; b=UaR5c526P8qi/w++8oNHUn4HQ+
	aNmep+Unw0dvccW5ivpaPvh+U1S/KMBIvACCAORFy+htJaKZQsiBj/atcZHY9YO9L37vkClDVPyVJ
	INY6R9dCghVgCBKDxxsIsTPImx5sJlZlo83ccQje9ne4nuxwhDY9CSbiC8hphc+AULl6nVaLIYr3h
	9EZk9+mzGOTPfO7oLSJ9OWUJybNnXQ+er7mmsz+f2Up9aon5AnZ05GcZoxRXTlZMN72od1NMHYJXc
	y4caG7MitKMNKA33lDFL5QLDaDITLzt7V3ZtfPrIbQCyuh+dktoLsJrabLwsGoqtpTbpNAWAOePnW
	iIQWmxGQ==;
Received: from 49.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.49] helo=localhost)
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q6ynl-000CYN-0R; Wed, 07 Jun 2023 21:26:37 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
To: ast@kernel.org
Cc: andrii@kernel.org,
	martin.lau@linux.dev,
	razor@blackwall.org,
	sdf@google.com,
	john.fastabend@gmail.com,
	kuba@kernel.org,
	dxu@dxuuu.xyz,
	joe@cilium.io,
	toke@kernel.org,
	davem@davemloft.net,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 4/7] libbpf: Add link-based API for tcx
Date: Wed,  7 Jun 2023 21:26:22 +0200
Message-Id: <20230607192625.22641-5-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20230607192625.22641-1-daniel@iogearbox.net>
References: <20230607192625.22641-1-daniel@iogearbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26931/Wed Jun  7 09:23:57 2023)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement tcx BPF link support for libbpf.

The bpf_program__attach_fd_opts() API has been refactored slightly in order to
pass bpf_link_create_opts pointer as input.

A new bpf_program__attach_tcx_opts() has been added on top of this which allows
for passing all relevant data via extensible struct bpf_tcx_opts.

The program sections tcx/ingress and tcx/egress correspond to the hook locations
for tc ingress and egress, respectively.

For concrete usage examples, see the extensive selftests that have been
developed as part of this series.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/lib/bpf/bpf.c      |  5 +++++
 tools/lib/bpf/bpf.h      |  7 +++++++
 tools/lib/bpf/libbpf.c   | 44 +++++++++++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.h   | 17 ++++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 5 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index a3d1b7ebe224..c340d3cbc6bd 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -746,6 +746,11 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, tracing))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_TCX_INGRESS:
+	case BPF_TCX_EGRESS:
+		attr.link_create.tcx.relative_fd = OPTS_GET(opts, tcx.relative_fd, 0);
+		attr.link_create.tcx.expected_revision = OPTS_GET(opts, tcx.expected_revision, 0);
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 480c584a6f7f..12591516dca0 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -370,6 +370,13 @@ struct bpf_link_create_opts {
 		struct {
 			__u64 cookie;
 		} tracing;
+		struct {
+			union {
+				__u32 relative_fd;
+				__u32 relative_id;
+			};
+			__u32 expected_revision;
+		} tcx;
 	};
 	size_t :0;
 };
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b89127471c6a..d7b6ff49f02e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -133,6 +133,7 @@ static const char * const link_type_name[] = {
 	[BPF_LINK_TYPE_KPROBE_MULTI]		= "kprobe_multi",
 	[BPF_LINK_TYPE_STRUCT_OPS]		= "struct_ops",
 	[BPF_LINK_TYPE_NETFILTER]		= "netfilter",
+	[BPF_LINK_TYPE_TCX]			= "tcx",
 };
 
 static const char * const map_type_name[] = {
@@ -11685,11 +11686,10 @@ static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_li
 }
 
 static struct bpf_link *
-bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id,
-		       const char *target_name)
+bpf_program__attach_fd_opts(const struct bpf_program *prog,
+			    const struct bpf_link_create_opts *opts,
+			    int target_fd, const char *target_name)
 {
-	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
-			    .target_btf_id = btf_id);
 	enum bpf_attach_type attach_type;
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
@@ -11707,7 +11707,7 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
 	link->detach = &bpf_link__detach_fd;
 
 	attach_type = bpf_program__expected_attach_type(prog);
-	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, &opts);
+	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, opts);
 	if (link_fd < 0) {
 		link_fd = -errno;
 		free(link);
@@ -11720,6 +11720,17 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
 	return link;
 }
 
+static struct bpf_link *
+bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id,
+		       const char *target_name)
+{
+	LIBBPF_OPTS(bpf_link_create_opts, opts,
+		.target_btf_id = btf_id,
+	);
+
+	return bpf_program__attach_fd_opts(prog, &opts, target_fd, target_name);
+}
+
 struct bpf_link *
 bpf_program__attach_cgroup(const struct bpf_program *prog, int cgroup_fd)
 {
@@ -11738,6 +11749,29 @@ struct bpf_link *bpf_program__attach_xdp(const struct bpf_program *prog, int ifi
 	return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
 }
 
+struct bpf_link *
+bpf_program__attach_tcx_opts(const struct bpf_program *prog,
+			     const struct bpf_tcx_opts *opts)
+{
+	LIBBPF_OPTS(bpf_link_create_opts, link_create_opts);
+	int ifindex = OPTS_GET(opts, ifindex, 0);
+
+	if (!OPTS_VALID(opts, bpf_tcx_opts))
+		return libbpf_err_ptr(-EINVAL);
+	if (!ifindex) {
+		pr_warn("prog '%s': target netdevice ifindex cannot be zero\n",
+			prog->name);
+		return libbpf_err_ptr(-EINVAL);
+	}
+
+	link_create_opts.tcx.expected_revision = OPTS_GET(opts, expected_revision, 0);
+	link_create_opts.tcx.relative_fd = OPTS_GET(opts, relative_fd, 0);
+	link_create_opts.flags = OPTS_GET(opts, flags, 0);
+
+	/* target_fd/target_ifindex use the same field in LINK_CREATE */
+	return bpf_program__attach_fd_opts(prog, &link_create_opts, ifindex, "tc");
+}
+
 struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
 					      int target_fd,
 					      const char *attach_func_name)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 754da73c643b..8ffba0f67c60 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -718,6 +718,23 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_freplace(const struct bpf_program *prog,
 			     int target_fd, const char *attach_func_name);
 
+struct bpf_tcx_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+	int ifindex;
+	__u32 flags;
+	union {
+		__u32 relative_fd;
+		__u32 relative_id;
+	};
+	__u32 expected_revision;
+};
+#define bpf_tcx_opts__last_field expected_revision
+
+LIBBPF_API struct bpf_link *
+bpf_program__attach_tcx_opts(const struct bpf_program *prog,
+			     const struct bpf_tcx_opts *opts);
+
 struct bpf_map;
 
 LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index a29b90e9713c..f66b714512c2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -396,4 +396,5 @@ LIBBPF_1.3.0 {
 	global:
 		bpf_obj_pin_opts;
 		bpf_prog_detach_opts;
+		bpf_program__attach_tcx_opts;
 } LIBBPF_1.2.0;
-- 
2.34.1


