Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2F439B2B1
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFDGfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:35:50 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:46830 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhFDGfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:35:50 -0400
Received: by mail-pj1-f67.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso5265983pjb.5;
        Thu, 03 Jun 2021 23:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bql1CSLWVtdo+ym3+LiQMgBDO2sCSamBHF3UpfjFx8Q=;
        b=L/IHMw2NESpV7xFUZZBBgC6xox+aRAs0r2uCV675ZpQ3buQX7jB/NVVpE5TnjTXLAa
         dHDF/L9JQD6QZvCX26r4B27uv+6kfU0O1aUXlPxyST1oURyBRnkiD1iv91w7VASPG7/W
         lgfXVNochO6dSF4bGOaqq9fiqZAAsaO5P+2uBHLAW84jeyhr4Y3WDIoQx0ToU/yVl9O4
         D3zgOhfQOLjRWNPGCbXk0GVTExrpTmu537qXpHH456bnv2/FpSp9kkaHd/30ouDEhdOI
         MzIPhhS75I2yfWYgwKktplKDjah4atZ72QJFfbArVw0n6dpEcQEU3Ho+CcFORhb4M7Sa
         QWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bql1CSLWVtdo+ym3+LiQMgBDO2sCSamBHF3UpfjFx8Q=;
        b=tkcB4vZ8d9e266OsFYNZqHc6kwUG0QPwvWY0r6HcKsq3XanqhWJeMPDjwNLjbHffNc
         7Wfv85ULkKA1F1xfLy5kZroxGcAw1MhVgXwfmz8fh20Lon8Hk0Ol2QaJ0nF3nr881sJw
         NXWP6GunExDNOsI5zIRcynpnwoEwSz5me8yDhnmzjv9bslJl8qI4v/82Tt+OSKIDN6NB
         H5RRwuoOtmlkL6I1YucheB7BZ+9eYN0PqtdS6rGRmgttyjt/3KQF9lDRMX6AeTQopNYW
         j7oSNhYRX7k1Wt0bt8lF/KhZN6Rq0eqa7xKMJXXB9Z5UZ/AGLscpiPDSKSuTKsqfuUFn
         BK5w==
X-Gm-Message-State: AOAM530DvPMRnSoFdBm7l6vU74j4UjAvJos6XIx7qfTV9EgpHFr/afZn
        ngbGP6v7xWqOgSLMlK5Bj3DCX61cuOA=
X-Google-Smtp-Source: ABdhPJwAvY1VAMv3gmiDxkdcqBkxIfKCRNaTAmpkNU/1PQCNpjkgTFPX7+Dnu9NZzIzhBK39iothwA==
X-Received: by 2002:a17:90a:5406:: with SMTP id z6mr3221711pjh.130.1622788368221;
        Thu, 03 Jun 2021 23:32:48 -0700 (PDT)
Received: from localhost ([2402:3a80:11cb:b599:c759:2079:3ef5:1764])
        by smtp.gmail.com with ESMTPSA id g6sm886321pfq.110.2021.06.03.23.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:32:48 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 7/7] libbpf: add selftest for bpf_link based TC-BPF management API
Date:   Fri,  4 Jun 2021 12:01:16 +0530
Message-Id: <20210604063116.234316-8-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604063116.234316-1-memxor@gmail.com>
References: <20210604063116.234316-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This covers basic attach/detach/update, and tests interaction with the
netlink API. It also exercises the bpf_link_info and fdinfo codepaths.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../selftests/bpf/prog_tests/tc_bpf_link.c    | 285 ++++++++++++++++++
 1 file changed, 285 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c b/tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
new file mode 100644
index 000000000000..beaf06e0557c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/tc_bpf_link.c
@@ -0,0 +1,285 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <linux/pkt_cls.h>
+
+#include "test_tc_bpf.skel.h"
+
+#define LO_IFINDEX 1
+
+static int test_tc_bpf_link_basic(struct bpf_tc_hook *hook,
+				  struct bpf_program *prog)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, qopts, .handle = 1, .priority = 1);
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	struct bpf_link *link, *invl;
+	int ret;
+
+	link = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
+		return PTR_ERR(link);
+
+	ret = bpf_obj_get_info_by_fd(bpf_program__fd(prog), &info, &info_len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		goto end;
+
+	ret = bpf_tc_query(hook, &qopts);
+	if (!ASSERT_OK(ret, "bpf_tc_query"))
+		goto end;
+
+	if (!ASSERT_EQ(qopts.prog_id, info.id, "prog_id match"))
+		goto end;
+
+	opts.gen_flags = ~0u;
+	invl = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_ERR_PTR(invl, "bpf_program__attach_tc with invalid flags")) {
+		bpf_link__destroy(invl);
+		ret = -EINVAL;
+	}
+
+end:
+	bpf_link__destroy(link);
+	return ret;
+}
+
+static int test_tc_bpf_link_netlink_interaction(struct bpf_tc_hook *hook,
+						struct bpf_program *prog)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, lopts,
+			    .old_prog_fd = bpf_program__fd(prog));
+	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, nopts, .handle = 1, .priority = 1);
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, dopts, .handle = 1, .priority = 1);
+	struct bpf_link *link;
+	int ret;
+
+	/* We need to test the following cases:
+	 *	1. BPF link owned filter cannot be replaced by netlink
+	 *	2. Netlink owned filter cannot be replaced by BPF link
+	 *	3. Netlink cannot do targeted delete of BPF link owned filter
+	 *	4. Filter is actually deleted (with chain cleanup)
+	 *	   We actually (ab)use the kernel behavior of returning EINVAL when
+	 *	   target chain doesn't exist on tc_get_tfilter (which maps to
+	 *	   bpf_tc_query) here, to know if the chain was really cleaned
+	 *	   up on tcf_proto destruction. Our setup is so that there is
+	 *	   only one reference to the chain.
+	 *
+	 *	   So on query, chain ? (filter ?: ENOENT) : EINVAL
+	 */
+
+	link = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
+		return PTR_ERR(link);
+
+	nopts.prog_fd = bpf_program__fd(prog);
+	ret = bpf_tc_attach(hook, &nopts);
+	if (!ASSERT_EQ(ret, -EEXIST, "bpf_tc_attach without replace"))
+		goto end;
+
+	nopts.flags = BPF_TC_F_REPLACE;
+	ret = bpf_tc_attach(hook, &nopts);
+	if (!ASSERT_EQ(ret, -EPERM, "bpf_tc_attach with replace"))
+		goto end;
+
+	ret = bpf_tc_detach(hook, &dopts);
+	if (!ASSERT_EQ(ret, -EPERM, "bpf_tc_detach"))
+		goto end;
+
+	lopts.flags = BPF_F_REPLACE;
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &lopts);
+	ASSERT_OK(ret, "bpf_link_update");
+	ret = ret < 0 ? -errno : ret;
+
+end:
+	bpf_link__destroy(link);
+	if (!ret && !ASSERT_EQ(bpf_tc_query(hook, &dopts), -EINVAL,
+			       "chain empty delete"))
+		ret = -EINVAL;
+	return ret;
+}
+
+static int test_tc_bpf_link_update_ways(struct bpf_tc_hook *hook,
+					struct bpf_program *prog)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, uopts, 0);
+	struct test_tc_bpf *skel;
+	struct bpf_link *link;
+	int ret;
+
+	skel = test_tc_bpf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
+		return PTR_ERR(skel);
+
+	link = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc")) {
+		ret = PTR_ERR(link);
+		goto end;
+	}
+
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &uopts);
+	if (!ASSERT_OK(ret, "bpf_link_update no old prog"))
+		goto end;
+
+	uopts.old_prog_fd = bpf_program__fd(prog);
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &uopts);
+	if (!ASSERT_TRUE(ret < 0 && errno == EINVAL,
+			 "bpf_link_update with old prog without BPF_F_REPLACE")) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	uopts.flags = BPF_F_REPLACE;
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &uopts);
+	if (!ASSERT_OK(ret, "bpf_link_update with old prog with BPF_F_REPLACE"))
+		goto end;
+
+	uopts.old_prog_fd = bpf_program__fd(skel->progs.cls);
+	ret = bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog),
+			      &uopts);
+	if (!ASSERT_TRUE(ret < 0 && errno == EINVAL,
+			 "bpf_link_update with wrong old prog")) {
+		ret = -EINVAL;
+		goto end;
+	}
+	ret = 0;
+
+end:
+	test_tc_bpf__destroy(skel);
+	return ret;
+}
+
+static int test_tc_bpf_link_info_api(struct bpf_tc_hook *hook,
+				     struct bpf_program *prog)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_link_opts, opts, .handle = 1, .priority = 1);
+	__u32 ifindex, parent, handle, gen_flags, priority;
+	char buf[4096], path[256], *begin;
+	struct bpf_link_info info = {};
+	__u32 info_len = sizeof(info);
+	struct bpf_link *link;
+	int ret, fdinfo;
+
+	link = bpf_program__attach_tc(prog, hook, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_tc"))
+		return PTR_ERR(link);
+
+	ret = bpf_obj_get_info_by_fd(bpf_link__fd(link), &info, &info_len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		goto end;
+
+	ret = snprintf(path, sizeof(path), "/proc/self/fdinfo/%d",
+		       bpf_link__fd(link));
+	if (!ASSERT_TRUE(!ret || ret < sizeof(path), "snprintf pathname"))
+		goto end;
+
+	fdinfo = open(path, O_RDONLY);
+	if (!ASSERT_GT(fdinfo, -1, "open fdinfo"))
+		goto end;
+
+	ret = read(fdinfo, buf, sizeof(buf));
+	if (!ASSERT_GT(ret, 0, "read fdinfo")) {
+		ret = -EINVAL;
+		goto end_file;
+	}
+
+	begin = strstr(buf, "ifindex");
+	if (!ASSERT_OK_PTR(begin, "find beginning of fdinfo info")) {
+		ret = -EINVAL;
+		goto end_file;
+	}
+
+	ret = sscanf(begin, "ifindex:\t%u\n"
+			    "parent:\t%u\n"
+			    "handle:\t%u\n"
+			    "priority:\t%u\n"
+			    "gen_flags:\t%u\n",
+			    &ifindex, &parent, &handle, &priority, &gen_flags);
+	if (!ASSERT_EQ(ret, 5, "sscanf fdinfo")) {
+		ret = -EINVAL;
+		goto end_file;
+	}
+
+	ret = -EINVAL;
+
+#define X(a, b, c) (!ASSERT_EQ(a, b, #a " == " #b) || !ASSERT_EQ(b, c, #b " == " #c))
+	if (X(info.tc.ifindex, ifindex, 1) ||
+	    X(info.tc.parent, parent,
+	      TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)) ||
+	    X(info.tc.handle, handle, 1) ||
+	    X(info.tc.gen_flags, gen_flags, TCA_CLS_FLAGS_NOT_IN_HW) ||
+	    X(info.tc.priority, priority, 1))
+#undef X
+		goto end_file;
+
+	ret = 0;
+
+end_file:
+	close(fdinfo);
+end:
+	bpf_link__destroy(link);
+	return ret;
+}
+
+void test_tc_bpf_link(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = LO_IFINDEX,
+			    .attach_point = BPF_TC_INGRESS);
+	struct test_tc_bpf *skel = NULL;
+	bool hook_created = false;
+	int ret;
+
+	skel = test_tc_bpf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_tc_bpf__open_and_load"))
+		return;
+
+	ret = bpf_tc_hook_create(&hook);
+	if (ret == 0)
+		hook_created = true;
+
+	ret = ret == -EEXIST ? 0 : ret;
+	if (!ASSERT_OK(ret, "bpf_tc_hook_create(BPF_TC_INGRESS)"))
+		goto end;
+
+	ret = test_tc_bpf_link_basic(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_basic"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	hook.attach_point = BPF_TC_EGRESS;
+	ret = test_tc_bpf_link_basic(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_basic"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	ret = test_tc_bpf_link_netlink_interaction(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_netlink_interaction"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	ret = test_tc_bpf_link_update_ways(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_update_ways"))
+		goto end;
+
+	bpf_tc_hook_destroy(&hook);
+
+	ret = test_tc_bpf_link_info_api(&hook, skel->progs.cls);
+	if (!ASSERT_OK(ret, "test_tc_bpf_link_info_api"))
+		goto end;
+
+end:
+	if (hook_created) {
+		hook.attach_point = BPF_TC_INGRESS | BPF_TC_EGRESS;
+		bpf_tc_hook_destroy(&hook);
+	}
+	test_tc_bpf__destroy(skel);
+}
-- 
2.31.1

