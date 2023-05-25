Return-Path: <netdev+bounces-5300-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E93710A73
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B9071C20EB6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81694FBF5;
	Thu, 25 May 2023 11:01:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D07BFBF2;
	Thu, 25 May 2023 11:01:23 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BC7C5;
	Thu, 25 May 2023 04:01:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1q28id-0004ic-LO; Thu, 25 May 2023 13:01:19 +0200
From: Florian Westphal <fw@strlen.de>
To: <bpf@vger.kernel.org>
Cc: andrii.nakryiko@gmail.com,
	ast@kernel.org,
	<netdev@vger.kernel.org>,
	dxu@dxuuu.xyz,
	qde@naccy.de,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next 1/2] tools: libbpf: add netfilter link attach helper
Date: Thu, 25 May 2023 13:00:59 +0200
Message-Id: <20230525110100.8212-2-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230525110100.8212-1-fw@strlen.de>
References: <20230525110100.8212-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add new api function: bpf_program__attach_netfilter_opts.

It takes a bpf program (netfilter type), and a pointer to a option struct
that contains the desired attachment (protocol family, priority, hook
location, ...).

It returns a pointer to a 'bpf_link' structure or NULL on error.

Next patch adds new netfilter_basic test that uses this function to
attach a program to a few pf/hook/priority combinations.

Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/lib/bpf/libbpf.c   | 51 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   | 15 ++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 67 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5cca00979aae..033447aa0773 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11811,6 +11811,57 @@ static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_l
 	return libbpf_get_error(*link);
 }
 
+struct bpf_link *bpf_program__attach_netfilter_opts(const struct bpf_program *prog,
+						    const struct bpf_netfilter_opts *opts)
+{
+	const size_t attr_sz = offsetofend(union bpf_attr, link_create);
+	struct bpf_link *link;
+	int prog_fd, link_fd;
+	union bpf_attr attr;
+
+	if (!OPTS_VALID(opts, bpf_netfilter_opts))
+		return libbpf_err_ptr(-EINVAL);
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
+		return libbpf_err_ptr(-EINVAL);
+	}
+
+	link = calloc(1, sizeof(*link));
+	if (!link)
+		return libbpf_err_ptr(-ENOMEM);
+	link->detach = &bpf_link__detach_fd;
+
+	memset(&attr, 0, attr_sz);
+
+	attr.link_create.prog_fd = prog_fd;
+	attr.link_create.netfilter.pf = OPTS_GET(opts, pf, 0);
+	attr.link_create.netfilter.hooknum = OPTS_GET(opts, hooknum, 0);
+	attr.link_create.netfilter.priority = OPTS_GET(opts, priority, 0);
+	attr.link_create.netfilter.flags = OPTS_GET(opts, flags, 0);
+
+	link_fd = syscall(__NR_bpf, BPF_LINK_CREATE, &attr, attr_sz);
+
+	link->fd = ensure_good_fd(link_fd);
+
+	if (link->fd < 0) {
+		char errmsg[STRERR_BUFSIZE];
+
+		link_fd = -errno;
+		free(link);
+		pr_warn("prog '%s': failed to attach to pf:%d,hooknum:%d:prio:%d: %s\n",
+			prog->name,
+			OPTS_GET(opts, pf, 0),
+			OPTS_GET(opts, hooknum, 0),
+			OPTS_GET(opts, priority, 0),
+			libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
+		return libbpf_err_ptr(link_fd);
+	}
+
+	return link;
+}
+
 struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
 {
 	struct bpf_link *link = NULL;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 754da73c643b..081beb95a097 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -718,6 +718,21 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_freplace(const struct bpf_program *prog,
 			     int target_fd, const char *attach_func_name);
 
+struct bpf_netfilter_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+
+	__u32 pf;
+	__u32 hooknum;
+	__s32 priority;
+	__u32 flags;
+};
+#define bpf_netfilter_opts__last_field flags
+
+LIBBPF_API struct bpf_link *
+bpf_program__attach_netfilter_opts(const struct bpf_program *prog,
+				   const struct bpf_netfilter_opts *opts);
+
 struct bpf_map;
 
 LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 7521a2fb7626..e13d60608bf3 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -395,4 +395,5 @@ LIBBPF_1.2.0 {
 LIBBPF_1.3.0 {
 	global:
 		bpf_obj_pin_opts;
+		bpf_program__attach_netfilter_opts;
 } LIBBPF_1.2.0;
-- 
2.39.3


