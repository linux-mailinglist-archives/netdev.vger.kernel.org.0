Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079B25F4C87
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 01:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiJDXMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 19:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJDXMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 19:12:13 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A35564FD;
        Tue,  4 Oct 2022 16:12:12 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ofr58-000AJx-Ne; Wed, 05 Oct 2022 01:12:10 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 08/10] libbpf: Add support for BPF tc link
Date:   Wed,  5 Oct 2022 01:11:41 +0200
Message-Id: <20221004231143.19190-9-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221004231143.19190-1-daniel@iogearbox.net>
References: <20221004231143.19190-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26679/Tue Oct  4 09:56:50 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement tc BPF link support for libbpf. The bpf_program__attach_fd()
API has been refactored slightly in order to pass bpf_link_create_opts.
A new bpf_program__attach_tc() has been added on top of this which allows
for passing ifindex and prio parameters.

New sections are tc/ingress and tc/egress which map to BPF_NET_INGRESS
and BPF_NET_EGRESS, respectively.

Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/lib/bpf/bpf.c      |  4 ++++
 tools/lib/bpf/bpf.h      |  3 +++
 tools/lib/bpf/libbpf.c   | 31 ++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.h   |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 5 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index d1e338ac9a62..f73fdecbb5f8 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -752,6 +752,10 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, tracing))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_NET_INGRESS:
+	case BPF_NET_EGRESS:
+		attr.link_create.tc.priority = OPTS_GET(opts, tc.priority, 0);
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 96de58fecdbc..937583421327 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -334,6 +334,9 @@ struct bpf_link_create_opts {
 		struct {
 			__u64 cookie;
 		} tracing;
+		struct {
+			__u32 priority;
+		} tc;
 	};
 	size_t :0;
 };
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 184ce1684dcd..6eb33e4324ad 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8474,6 +8474,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("kretsyscall+",		KPROBE, 0, SEC_NONE, attach_ksyscall),
 	SEC_DEF("usdt+",		KPROBE,	0, SEC_NONE, attach_usdt),
 	SEC_DEF("tc",			SCHED_CLS, 0, SEC_NONE),
+	SEC_DEF("tc/ingress",		SCHED_CLS, BPF_NET_INGRESS, SEC_ATTACHABLE_OPT),
+	SEC_DEF("tc/egress",		SCHED_CLS, BPF_NET_EGRESS, SEC_ATTACHABLE_OPT),
 	SEC_DEF("classifier",		SCHED_CLS, 0, SEC_NONE),
 	SEC_DEF("action",		SCHED_ACT, 0, SEC_NONE),
 	SEC_DEF("tracepoint+",		TRACEPOINT, 0, SEC_NONE, attach_tp),
@@ -11238,11 +11240,10 @@ static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_li
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
@@ -11260,7 +11261,7 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
 	link->detach = &bpf_link__detach_fd;
 
 	attach_type = bpf_program__expected_attach_type(prog);
-	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, &opts);
+	link_fd = bpf_link_create(prog_fd, target_fd, attach_type, opts);
 	if (link_fd < 0) {
 		link_fd = -errno;
 		free(link);
@@ -11273,6 +11274,16 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
 	return link;
 }
 
+static struct bpf_link *
+bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id,
+		       const char *target_name)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
+			    .target_btf_id = btf_id);
+
+	return bpf_program__attach_fd_opts(prog, &opts, target_fd, target_name);
+}
+
 struct bpf_link *
 bpf_program__attach_cgroup(const struct bpf_program *prog, int cgroup_fd)
 {
@@ -11291,6 +11302,16 @@ struct bpf_link *bpf_program__attach_xdp(const struct bpf_program *prog, int ifi
 	return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
 }
 
+struct bpf_link *bpf_program__attach_tc(const struct bpf_program *prog,
+					int ifindex, __u32 priority)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
+			    .tc.priority = priority);
+
+	/* target_fd/target_ifindex use the same field in LINK_CREATE */
+	return bpf_program__attach_fd_opts(prog, &opts, ifindex, "tc");
+}
+
 struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
 					      int target_fd,
 					      const char *attach_func_name)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index eee883f007f9..7e64cec9a1ba 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -645,6 +645,8 @@ bpf_program__attach_netns(const struct bpf_program *prog, int netns_fd);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_xdp(const struct bpf_program *prog, int ifindex);
 LIBBPF_API struct bpf_link *
+bpf_program__attach_tc(const struct bpf_program *prog, int ifindex, __u32 priority);
+LIBBPF_API struct bpf_link *
 bpf_program__attach_freplace(const struct bpf_program *prog,
 			     int target_fd, const char *attach_func_name);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 0c94b4862ebb..473ed71829c6 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -378,4 +378,5 @@ LIBBPF_1.1.0 {
 		user_ring_buffer__reserve_blocking;
 		user_ring_buffer__submit;
 		bpf_prog_detach_opts;
+		bpf_program__attach_tc;
 } LIBBPF_1.0.0;
-- 
2.34.1

