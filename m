Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6B837BABD
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhELKgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhELKgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 06:36:32 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AD1C061574;
        Wed, 12 May 2021 03:35:23 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so3052235pjb.4;
        Wed, 12 May 2021 03:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HbA1y7nSMlUm7rYKU6hzxN3ZCukiyw2IXwzZ0Q2FyTc=;
        b=RLyu5XJVAfUuWGjdQgzoZncWSNdW30pQxMJrvsapSKmPv4znGoGrtNFDMTZzyldLNo
         07IiXK0zlrOaSnNf01LR6r3fphkjnAhwrpLun6BFAPaVaHQqQkJQGWd0nB+vOYohIPQs
         QrrPlde+qcABw88pIes0fIowTRvxa33ewnheiXuNKXGReMlJWNxBBTVU2gUG6xbNh+M3
         w/XrJV2IyZoLymLNh539+gIkVoH5MMd8MZqCBZGzTv9QifBWxtwJuJBEK7otCjcvLA6U
         z5pl+luJi3jjxscqO+cGYoE61Ul5QsBdNyRH4UAxGW0NtwgBw6U8AMKPLoixIM1OEt3x
         KFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HbA1y7nSMlUm7rYKU6hzxN3ZCukiyw2IXwzZ0Q2FyTc=;
        b=A2py/tJ/w8okIxmo4WAhtx/jQuhPeiFIDF//i+suImvOQuHSm/hdkZXpf2HSmvjjPm
         zfN/4yYZDixA7K+qW5bb7Kw4a8wJwnsOx5i0ZyxrZU/ksqEtboTjR1Y14SP51R/aTl2P
         hXsPvHg5/XiOo5a4cKV7mqo9Pho1hom8Vc7b8K1O6u7LjA3PJamUk4MyIPcW+xORIST/
         y/DFCc0dZxOnEu4Ob/k2mdc+JDySuGlnIeYbKqjqs3vkkMlIokWpQntmL/bb7f1U6uXK
         8wjKZKmo3F8pzZ0B7a0TxbqErxphniB0YVhRjAHG7jEZk8VyBu2NFkNVWIa+z48yHQAR
         tIeQ==
X-Gm-Message-State: AOAM531Mnd6YmuSX/az1/13976FPixiSvLCQizAfmryjvz/pLdYqmAOg
        vfnNSwOUVcpIbWwSfvhk0Gao+EH1LyUpow==
X-Google-Smtp-Source: ABdhPJyRjZp/NwC78wL5yHvA7LyrKFoLRsvpuB9/weqEouBd4pmRq7FtwiElN8kIn5V4XcWyMtZORg==
X-Received: by 2002:a17:90a:d255:: with SMTP id o21mr10122873pjw.136.1620815722111;
        Wed, 12 May 2021 03:35:22 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:45ac:887c:70aa:e004:d014])
        by smtp.gmail.com with ESMTPSA id x10sm15629302pjq.53.2021.05.12.03.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 03:35:21 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Shaun Crampton <shaun@tigera.io>, netdev@vger.kernel.org
Subject: [PATCH bpf-next v7 2/3] libbpf: add low level TC-BPF API
Date:   Wed, 12 May 2021 16:04:50 +0530
Message-Id: <20210512103451.989420-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512103451.989420-1-memxor@gmail.com>
References: <20210512103451.989420-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds functions that wrap the netlink API used for adding,
manipulating, and removing traffic control filters.

An API summary:

A bpf_tc_hook represents a location where a TC-BPF filter can be
attached. This means that creating a hook leads to creation of the
backing qdisc, while destruction either removes all filters attached to
a hook, or destroys qdisc if requested explicitly (as discussed below).

The TC-BPF API functions operate on this bpf_tc_hook to attach, replace,
query, and detach tc filters.

All functions return 0 on success, and a negative error code on failure.

bpf_tc_hook_create - Create a hook
Parameters:
	@hook - Cannot be NULL, ifindex > 0, attach_point must be set to
		proper enum constant. Note that parent must be unset when
		attach_point is one of BPF_TC_INGRESS or BPF_TC_EGRESS. Note
		that as an exception BPF_TC_INGRESS|BPF_TC_EGRESS is also a
		valid value for attach_point.

		Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.

bpf_tc_hook_destroy - Destroy the hook
Parameters:
        @hook - Cannot be NULL. The behaviour depends on value of
		attach_point.

		If BPF_TC_INGRESS, all filters attached to the ingress
		hook will be detached.
		If BPF_TC_EGRESS, all filters attached to the egress hook
		will be detached.
		If BPF_TC_INGRESS|BPF_TC_EGRESS, the clsact qdisc will be
		deleted, also detaching all filters.

		As before, parent must be unset for these attach_points,
		and set for BPF_TC_CUSTOM.

		It is advised that if the qdisc is operated on by many programs,
		then the program at least check that there are no other existing
		filters before deleting the clsact qdisc. An example is shown
		below:

		DECLARE_LIBBPF_OPTS(bpf_tc_hook, .ifindex = if_nametoindex("lo"),
				    .attach_point = BPF_TC_INGRESS);
		/* set opts as NULL, as we're not really interested in
		 * getting any info for a particular filter, but just
	 	 * detecting its presence.
		 */
		r = bpf_tc_query(&hook, NULL);
		if (r == -ENOENT) {
			/* no filters */
			hook.attach_point = BPF_TC_INGRESS|BPF_TC_EGREESS;
			return bpf_tc_hook_destroy(&hook);
		} else {
			/* failed or r == 0, the latter means filters do exist */
			return r;
		}

		Note that there is a small race between checking for no
		filters and deleting the qdisc. This is currently unavoidable.

		Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.

bpf_tc_attach - Attach a filter to a hook
Parameters:
	@hook - Cannot be NULL. Represents the hook the filter will be
		attached to. Requirements for ifindex and attach_point are
		same as described in bpf_tc_hook_create, but BPF_TC_CUSTOM
		is also supported.  In that case, parent must be set to the
		handle where the filter will be attached (using BPF_TC_PARENT).

		E.g. To set parent to 1:16 like in tc command line,
		     the equivalent would be BPF_TC_PARENT(1, 16).

	@opts - Cannot be NULL.

		The following opts are optional:
			handle - The handle of the filter
			priority - The priority of the filter
				   Must be >= 0 and <= UINT16_MAX
		Note that when left unset, they will be auto-allocated
		by the kernel.
		The following opts must be set:
			prog_fd - The fd of the loaded SCHED_CLS prog
		The following opts must be unset:
			prog_id - The ID of the BPF prog
		The following opts are optional:
			flags - Currently only BPF_TC_F_REPLACE is
				allowed. It allows replacing an existing
				filter instead of failing with -EEXIST.

		The following opts will be filled by bpf_tc_attach on a
		successful attach operation if they are unset:
			handle - The handle of the attached filter
			priority - The priority of the attached filter
			prog_id - The ID of the attached SCHED_CLS prog

		This way, the user can know what the auto allocated
		values for optional opts like handle and priority are
		for the newly attached filter, if they were unset.

		Note that some other attributes are set to some default
		values listed below (this holds for all bpf_tc_* APIs):
			protocol - ETH_P_ALL
			mode - direct action
			chain index - 0
			class ID - 0 (this can be set by writing to the
			skb->tc_classid field from the BPF program)

bpf_tc_detach
Parameters:
	@hook: Cannot be NULL. Represents the hook the filter will be
		detached from. Requirements are same as described above
		in bpf_tc_attach.

	@opts:	Cannot be NULL.

		The following opts must be set:
			handle
			priority
		The following opts must be unset:
			prog_fd
			prog_id
			flags

bpf_tc_query
Parameters:
	@hook: Cannot be NULL. Represents the hook where the filter
	       lookup will be performed. Requirements are same as described
	       above in bpf_tc_attach.

	@opts: Cannot be NULL.

	       The following opts must be set:
			handle
			priority
	       The following opts must be unset:
			prog_fd
			prog_id
			flags

	       The following fields will be filled by bpf_tc_query on a
	       successful lookup:
			prog_id

Some usage examples (using bpf skeleton infrastructure):

BPF program (test_tc_bpf.c):

	#include <linux/bpf.h>
	#include <bpf/bpf_helpers.h>

	SEC("classifier")
	int cls(struct __sk_buff *skb)
	{
		return 0;
	}

Userspace loader:

	struct test_tc_bpf *skel = NULL;
	int fd, r;

	skel = test_tc_bpf__open_and_load();
	if (!skel)
		return -ENOMEM;

	fd = bpf_program__fd(skel->progs.cls);

	DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =
			    if_nametoindex("lo"), .attach_point =
			    BPF_TC_INGRESS);
	/* Create clsact qdisc */
	r = bpf_tc_hook_create(&hook);
	if (r < 0)
		goto end;

	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .prog_fd = fd);
	r = bpf_tc_attach(&hook, &opts);
	if (r < 0)
		goto end;
	/* Print the auto allocated handle and priority */
	printf("Handle=%u", opts.handle);
	printf("Priority=%u", opts.priority);

	opts.prog_fd = opts.prog_id = 0;
	bpf_tc_detach(&hook, &opts);
end:
	test_tc_bpf__destroy(skel);

This is equivalent to doing the following using tc command line:
  # tc qdisc add dev lo clsact
  # tc filter add dev lo ingress bpf obj foo.o sec classifier da
  # tc filter del dev lo ingress handle <h> prio <p> bpf

... where the handle and priority can be found using:
  # tc filter show dev lo ingress

Another example replacing a filter (extending prior example):

	/* We can also choose both (or one), let's try replacing an
	 * existing filter.
	 */
	DECLARE_LIBBPF_OPTS(bpf_tc_opts, replace_opts, .handle =
			    opts.handle, .priority = opts.priority,
			    .prog_fd = fd);
	r = bpf_tc_attach(&hook, &replace_opts);
	if (r == -EEXIST) {
		/* Expected, now use BPF_TC_F_REPLACE to replace it */
		replace_opts.flags = BPF_TC_F_REPLACE;
		return bpf_tc_attach(&hook, &replace_opts);
	} else if (r < 0) {
		return r;
	}
	/* There must be no existing filter with these
	 * attributes, so cleanup and return an error.
	 */
	replace_opts.prog_fd = replace_opts.prog_id = 0;
	bpf_tc_detach(&hook, &replace_opts);
	return -1;

To obtain info of a particular filter:

	/* Find info for filter with handle 1 and priority 50 */
	DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts, .handle = 1,
			    .priority = 50);
	r = bpf_tc_query(&hook, &info_opts);
	if (r == -ENOENT)
		printf("Filter not found");
	else if (r < 0)
		return r;
	printf("Prog ID: %u", info_opts.prog_id);
	return 0;

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.h   |  43 ++++
 tools/lib/bpf/libbpf.map |   5 +
 tools/lib/bpf/netlink.c  | 440 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 487 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 3f3a24763459..0f28172db18d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -783,6 +783,49 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker,
 LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
 LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
 
+enum bpf_tc_attach_point {
+	BPF_TC_INGRESS = 1 << 0,
+	BPF_TC_EGRESS  = 1 << 1,
+	BPF_TC_CUSTOM  = 1 << 2,
+};
+
+#define BPF_TC_PARENT(a, b) ((((a) << 16) & 0xFFFF0000U) | ((b) & 0x0000FFFFU))
+
+enum bpf_tc_flags {
+	BPF_TC_F_REPLACE = 1 << 0,
+};
+
+struct bpf_tc_hook {
+	size_t sz;
+	int ifindex;
+	enum bpf_tc_attach_point attach_point;
+	__u32 parent;
+	size_t :0;
+};
+
+#define bpf_tc_hook__last_field parent
+
+struct bpf_tc_opts {
+	size_t sz;
+	int prog_fd;
+	__u32 flags;
+	__u32 prog_id;
+	__u32 handle;
+	__u32 priority;
+	size_t :0;
+};
+
+#define bpf_tc_opts__last_field priority
+
+LIBBPF_API int bpf_tc_hook_create(struct bpf_tc_hook *hook);
+LIBBPF_API int bpf_tc_hook_destroy(struct bpf_tc_hook *hook);
+LIBBPF_API int bpf_tc_attach(const struct bpf_tc_hook *hook,
+			     struct bpf_tc_opts *opts);
+LIBBPF_API int bpf_tc_detach(const struct bpf_tc_hook *hook,
+			     const struct bpf_tc_opts *opts);
+LIBBPF_API int bpf_tc_query(const struct bpf_tc_hook *hook,
+			    struct bpf_tc_opts *opts);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b9b29baf1df8..6c96729050dc 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -361,4 +361,9 @@ LIBBPF_0.4.0 {
 		bpf_linker__new;
 		bpf_map__inner_map;
 		bpf_object__set_kversion;
+		bpf_tc_attach;
+		bpf_tc_detach;
+		bpf_tc_hook_create;
+		bpf_tc_hook_destroy;
+		bpf_tc_query;
 } LIBBPF_0.3.0;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index e78d03a76110..2716f9457e15 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -4,7 +4,10 @@
 #include <stdlib.h>
 #include <memory.h>
 #include <unistd.h>
+#include <arpa/inet.h>
 #include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/pkt_cls.h>
 #include <linux/rtnetlink.h>
 #include <sys/socket.h>
 #include <errno.h>
@@ -73,6 +76,12 @@ static int libbpf_netlink_open(__u32 *nl_pid)
 	return ret;
 }
 
+enum {
+	NL_CONT,
+	NL_NEXT,
+	NL_DONE,
+};
+
 static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 			    __dump_nlmsg_t _fn, libbpf_dump_nlmsg_t fn,
 			    void *cookie)
@@ -84,6 +93,7 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	int len, ret;
 
 	while (multipart) {
+start:
 		multipart = false;
 		len = recv(sock, buf, sizeof(buf), 0);
 		if (len < 0) {
@@ -121,8 +131,18 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 			}
 			if (_fn) {
 				ret = _fn(nh, fn, cookie);
-				if (ret)
+				if (ret < 0)
+					return ret;
+				switch (ret) {
+				case NL_CONT:
+					break;
+				case NL_NEXT:
+					goto start;
+				case NL_DONE:
+					return 0;
+				default:
 					return ret;
+				}
 			}
 		}
 	}
@@ -358,3 +378,421 @@ static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t parse_msg,
 	close(sock);
 	return ret;
 }
+
+/* TC-HOOK */
+
+typedef int (*qdisc_config_t)(struct nlmsghdr *nh, struct tcmsg *t,
+			      size_t maxsz);
+
+static int clsact_config(struct nlmsghdr *nh, struct tcmsg *t, size_t maxsz)
+{
+	t->tcm_parent = TC_H_CLSACT;
+	t->tcm_handle = TC_H_MAKE(TC_H_CLSACT, 0);
+
+	return nlattr_add(nh, maxsz, TCA_KIND, "clsact", sizeof("clsact"));
+}
+
+static int attach_point_to_config(struct bpf_tc_hook *hook, qdisc_config_t *configp)
+{
+	switch (OPTS_GET(hook, attach_point, 0)) {
+	case BPF_TC_INGRESS:
+	case BPF_TC_EGRESS:
+	case BPF_TC_INGRESS | BPF_TC_EGRESS:
+		if (OPTS_GET(hook, parent, 0))
+			return -EINVAL;
+		*configp = &clsact_config;
+		return 0;
+	case BPF_TC_CUSTOM:
+		return -EOPNOTSUPP;
+	default:
+		return -EINVAL;
+	}
+}
+
+static long long tc_get_tcm_parent(enum bpf_tc_attach_point attach_point,
+				       __u32 parent)
+{
+	switch (attach_point) {
+	case BPF_TC_INGRESS:
+		if (parent)
+			return -EINVAL;
+		return TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS);
+	case BPF_TC_EGRESS:
+		if (parent)
+			return -EINVAL;
+		return TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS);
+	case BPF_TC_CUSTOM:
+		if (!parent)
+			return -EINVAL;
+		return parent;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int tc_qdisc_modify(struct bpf_tc_hook *hook, int cmd, int flags)
+{
+	qdisc_config_t config;
+	int ret;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req;
+
+	ret = attach_point_to_config(hook, &config);
+	if (ret < 0)
+		return ret;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
+	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | flags;
+	req.nh.nlmsg_type = cmd;
+	req.t.tcm_family = AF_UNSPEC;
+	req.t.tcm_ifindex = OPTS_GET(hook, ifindex, 0);
+
+	ret = config(&req.nh, &req.t, sizeof(req));
+	if (ret < 0)
+		return ret;
+
+	return libbpf_nl_send_recv(&req.nh, NULL, NULL, NULL);
+}
+
+static int tc_qdisc_create_excl(struct bpf_tc_hook *hook)
+{
+	return tc_qdisc_modify(hook, RTM_NEWQDISC, NLM_F_CREATE);
+}
+
+static int tc_qdisc_delete(struct bpf_tc_hook *hook)
+{
+	return tc_qdisc_modify(hook, RTM_DELQDISC, 0);
+}
+
+int bpf_tc_hook_create(struct bpf_tc_hook *hook)
+{
+	int ifindex;
+
+	if (!hook || !OPTS_VALID(hook, bpf_tc_hook))
+		return -EINVAL;
+
+	ifindex = OPTS_GET(hook, ifindex, 0);
+
+	if (ifindex <= 0)
+		return -EINVAL;
+
+	return tc_qdisc_create_excl(hook);
+}
+
+static int tc_cls_detach(const struct bpf_tc_hook *hook, const struct bpf_tc_opts *opts,
+			 bool flush);
+
+int bpf_tc_hook_destroy(struct bpf_tc_hook *hook)
+{
+	if (!hook || !OPTS_VALID(hook, bpf_tc_hook) || OPTS_GET(hook, ifindex, 0) <= 0)
+		return -EINVAL;
+
+	switch (OPTS_GET(hook, attach_point, 0)) {
+	case BPF_TC_INGRESS:
+	case BPF_TC_EGRESS:
+		return tc_cls_detach(hook, NULL, true);
+	case BPF_TC_INGRESS | BPF_TC_EGRESS:
+		return tc_qdisc_delete(hook);
+	case BPF_TC_CUSTOM:
+		return -EOPNOTSUPP;
+	default:
+		return -EINVAL;
+	}
+}
+
+struct pass_info {
+	struct bpf_tc_opts *opts;
+	bool processed;
+};
+
+/* TC-BPF */
+
+static int tc_cls_add_fd_and_name(struct nlmsghdr *nh, size_t maxsz, int fd)
+{
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	char name[256];
+	int len, ret;
+
+	ret = bpf_obj_get_info_by_fd(fd, &info, &info_len);
+	if (ret < 0)
+		return ret;
+
+	ret = nlattr_add(nh, maxsz, TCA_BPF_FD, &fd, sizeof(fd));
+	if (ret < 0)
+		return ret;
+
+	len = snprintf(name, sizeof(name), "%s:[%u]", info.name, info.id);
+	if (len < 0)
+		return -errno;
+	if (len >= sizeof(name))
+		return -ENAMETOOLONG;
+
+	return nlattr_add(nh, maxsz, TCA_BPF_NAME, name, len + 1);
+}
+
+
+static int cls_get_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn, void *cookie);
+
+int bpf_tc_attach(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
+{
+	__u32 protocol, bpf_flags, handle, priority, parent, prog_id, flags;
+	int ret, ifindex, attach_point, prog_fd;
+	struct pass_info info = {};
+	long long tcm_parent;
+	struct nlattr *nla;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req;
+
+	if (!hook || !opts || !OPTS_VALID(hook, bpf_tc_hook) || !OPTS_VALID(opts, bpf_tc_opts))
+		return -EINVAL;
+
+	ifindex = OPTS_GET(hook, ifindex, 0);
+	parent = OPTS_GET(hook, parent, 0);
+	attach_point = OPTS_GET(hook, attach_point, 0);
+
+	handle = OPTS_GET(opts, handle, 0);
+	priority = OPTS_GET(opts, priority, 0);
+	prog_fd = OPTS_GET(opts, prog_fd, 0);
+	prog_id = OPTS_GET(opts, prog_id, 0);
+	flags = OPTS_GET(opts, flags, 0);
+
+	if (ifindex <= 0 || !prog_fd || prog_id)
+		return -EINVAL;
+	if (priority > UINT16_MAX)
+		return -EINVAL;
+	if (flags & ~BPF_TC_F_REPLACE)
+		return -EINVAL;
+
+	protocol = ETH_P_ALL;
+	flags = (flags & BPF_TC_F_REPLACE) ? NLM_F_REPLACE : NLM_F_EXCL;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
+	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE | NLM_F_ECHO | flags;
+	req.nh.nlmsg_type = RTM_NEWTFILTER;
+	req.t.tcm_family = AF_UNSPEC;
+	req.t.tcm_handle = handle;
+	req.t.tcm_ifindex = ifindex;
+	req.t.tcm_info = TC_H_MAKE(priority << 16, htons(protocol));
+
+	tcm_parent = tc_get_tcm_parent(attach_point, parent);
+	if (tcm_parent < 0)
+		return tcm_parent;
+	req.t.tcm_parent = tcm_parent;
+
+	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		return ret;
+
+	nla = nlattr_begin_nested(&req.nh, sizeof(req), TCA_OPTIONS);
+	if (!nla)
+		return -EMSGSIZE;
+
+	ret = tc_cls_add_fd_and_name(&req.nh, sizeof(req), prog_fd);
+	if (ret < 0)
+		return ret;
+
+	/* direct action mode is always enabled */
+	bpf_flags = TCA_BPF_FLAG_ACT_DIRECT;
+	ret = nlattr_add(&req.nh, sizeof(req), TCA_BPF_FLAGS, &bpf_flags, sizeof(bpf_flags));
+	if (ret < 0)
+		return ret;
+
+	nlattr_end_nested(&req.nh, nla);
+
+	info.opts = opts;
+
+	ret = libbpf_nl_send_recv(&req.nh, &cls_get_info, NULL, &info);
+	if (ret < 0)
+		return ret;
+
+	/* Failed to process unicast response */
+	if (!info.processed)
+		return -ENOENT;
+
+	return ret;
+}
+
+static int tc_cls_detach(const struct bpf_tc_hook *hook, const struct bpf_tc_opts *opts,
+			 bool flush)
+{
+	__u32 protocol = 0, handle, priority, parent, prog_id, flags;
+	int ret, ifindex, attach_point, prog_fd;
+	long long tcm_parent;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req;
+
+	if (!hook || !OPTS_VALID(hook, bpf_tc_hook) || !OPTS_VALID(opts, bpf_tc_opts))
+		return -EINVAL;
+
+	ifindex = OPTS_GET(hook, ifindex, 0);
+	parent = OPTS_GET(hook, parent, 0);
+	attach_point = OPTS_GET(hook, attach_point, 0);
+
+	handle = OPTS_GET(opts, handle, 0);
+	priority = OPTS_GET(opts, priority, 0);
+	prog_fd = OPTS_GET(opts, prog_fd, 0);
+	prog_id = OPTS_GET(opts, prog_id, 0);
+	flags = OPTS_GET(opts, flags, 0);
+
+	if (ifindex <= 0 || flags || prog_fd || prog_id)
+		return -EINVAL;
+	if (priority > UINT16_MAX)
+		return -EINVAL;
+	if (!flush) {
+		if (!handle || !priority)
+			return -EINVAL;
+		protocol = ETH_P_ALL;
+	} else {
+		if (handle || priority)
+			return -EINVAL;
+	}
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
+	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
+	req.nh.nlmsg_type = RTM_DELTFILTER;
+	req.t.tcm_family = AF_UNSPEC;
+	req.t.tcm_ifindex = ifindex;
+
+	if (!flush) {
+		req.t.tcm_handle = handle;
+		req.t.tcm_info = TC_H_MAKE(priority << 16, htons(protocol));
+	}
+
+	tcm_parent = tc_get_tcm_parent(attach_point, parent);
+	if (tcm_parent < 0)
+		return tcm_parent;
+	req.t.tcm_parent = tcm_parent;
+
+	if (!flush) {
+		ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+		if (ret < 0)
+			return ret;
+	}
+
+	return libbpf_nl_send_recv(&req.nh, NULL, NULL, NULL);
+}
+
+int bpf_tc_detach(const struct bpf_tc_hook *hook, const struct bpf_tc_opts *opts)
+{
+	if (!opts)
+		return -EINVAL;
+
+	return tc_cls_detach(hook, opts, false);
+}
+
+static int __cls_get_info(void *cookie, void *msg, struct nlattr **tb, bool unicast)
+{
+	struct nlattr *tbb[TCA_BPF_MAX + 1];
+	struct pass_info *info = cookie;
+	struct tcmsg *t = msg;
+
+	if (!info || !info->opts)
+		return -EINVAL;
+	if (unicast && info->processed)
+		return -EINVAL;
+	if (!tb[TCA_OPTIONS])
+		return NL_CONT;
+
+	libbpf_nla_parse_nested(tbb, TCA_BPF_MAX, tb[TCA_OPTIONS], NULL);
+
+	if (!tbb[TCA_BPF_ID])
+		return -EINVAL;
+
+	OPTS_SET(info->opts, handle, t->tcm_handle);
+	OPTS_SET(info->opts, priority, TC_H_MAJ(t->tcm_info) >> 16);
+	OPTS_SET(info->opts, prog_id, libbpf_nla_getattr_u32(tbb[TCA_BPF_ID]));
+
+	info->processed = true;
+	return unicast ? NL_NEXT : NL_DONE;
+}
+
+static int cls_get_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn, void *cookie)
+{
+	struct tcmsg *t = NLMSG_DATA(nh);
+	struct nlattr *tb[TCA_MAX + 1];
+
+	libbpf_nla_parse(tb, TCA_MAX,
+			 (struct nlattr *)((char *)t + NLMSG_ALIGN(sizeof(*t))),
+			 NLMSG_PAYLOAD(nh, sizeof(*t)), NULL);
+
+	if (!tb[TCA_KIND])
+		return NL_CONT;
+
+	return __cls_get_info(cookie, t, tb, nh->nlmsg_flags & NLM_F_ECHO);
+}
+
+/* This is the analogue of `tc filter get`, i.e. RTM_GETTFILTER without NLM_F_DUMP */
+int bpf_tc_query(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
+{
+	__u32 protocol, handle, priority, parent, prog_id, flags;
+	int ret, ifindex, attach_point, prog_fd;
+	struct pass_info pinfo = {};
+	long long tcm_parent;
+	struct {
+		struct nlmsghdr nh;
+		struct tcmsg t;
+		char buf[256];
+	} req;
+
+	if (!hook || !opts || !OPTS_VALID(hook, bpf_tc_hook) || !OPTS_VALID(opts, bpf_tc_opts))
+		return -EINVAL;
+
+	ifindex = OPTS_GET(hook, ifindex, 0);
+	parent = OPTS_GET(hook, parent, 0);
+	attach_point = OPTS_GET(hook, attach_point, 0);
+
+	handle = OPTS_GET(opts, handle, 0);
+	priority = OPTS_GET(opts, priority, 0);
+	prog_fd = OPTS_GET(opts, prog_fd, 0);
+	prog_id = OPTS_GET(opts, prog_id, 0);
+	flags = OPTS_GET(opts, flags, 0);
+
+	if (ifindex <= 0 || !handle || !priority || flags || prog_fd || prog_id)
+		return -EINVAL;
+	if (priority > UINT16_MAX)
+		return -EINVAL;
+
+	protocol = ETH_P_ALL;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
+	req.nh.nlmsg_flags = NLM_F_REQUEST;
+	req.nh.nlmsg_type = RTM_GETTFILTER;
+	req.t.tcm_family = AF_UNSPEC;
+	req.t.tcm_handle = handle;
+	req.t.tcm_ifindex = ifindex;
+	req.t.tcm_info = TC_H_MAKE(priority << 16, htons(protocol));
+
+	tcm_parent = tc_get_tcm_parent(attach_point, parent);
+	if (tcm_parent < 0)
+		return tcm_parent;
+	req.t.tcm_parent = tcm_parent;
+
+	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	if (ret < 0)
+		return ret;
+
+	pinfo.opts = opts;
+
+	ret = libbpf_nl_send_recv(&req.nh, &cls_get_info, NULL, &pinfo);
+	if (ret < 0)
+		return ret;
+
+	if (!pinfo.processed)
+		return -ENOENT;
+
+	return ret;
+}
-- 
2.31.1

