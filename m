Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F91E9650
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgEaI3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727869AbgEaI3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:29:09 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4A0C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:08 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g9so4927247edw.10
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xZGf1tofJWEpR5JJpr/JS7EPgWH4bJ7Rl5+UFQC1uls=;
        b=TR/K5qKxmVV7lLU+Yh/9XxfJSElOREKrXdO2GI3D27MaTs30UJhrbLoF3vvY72PgQx
         tSd5TX0zfxoGp5t2kuANCbIX1fr2agAa9xKpIZoOLIV/a9ncPdws0ArfadJb6Legbs++
         SZZg3dTkNtQCR5xf7GMgQc1QFbDxgY2H1z1I8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZGf1tofJWEpR5JJpr/JS7EPgWH4bJ7Rl5+UFQC1uls=;
        b=sH06UMa+M0rU5AvsgaiOfbV4zfzl+vikH4F8FxR+HWTqiG1PH2k1H4jw+TV/E2eIdO
         Z7041xTLbHzYMDOu2aHiUr+k6knxwv+H3r+rmV0sQrfdF+Q0fTC/x4bMq4EK45UUwEpb
         j20YMnGHv/4YmlK7ppOd2r6mvmJCuhe4CU1DO1ltENuxDLGNYEso8c33UWro6lulox12
         Fytbb5WSyPn+1Q1K1pTDiTXXmsuHP5bMdwKcYel5X14wPssGX7kOrbzCDRfPmetTjn4D
         f5HtUYosNUbJergmwl0wO1d9rRBSD2Ztq+/1SJInOuYb+aYD26pc81rLvkklvG6/Ojvz
         tPvw==
X-Gm-Message-State: AOAM530qXmveVxYa9OPxroRirverfI63h6J/7zqwM6xY3BIUvq8aQ0Ew
        j6RhjH9ykAPdt4YSUKZ1DUtgBuZbdO8=
X-Google-Smtp-Source: ABdhPJzBGqVaV4YCQR6LOG2ixm2848GRhfjfTxm1okxTSzaKFCaH/UzMkJ07qPrNmHeWlwlk2ZJz1w==
X-Received: by 2002:a50:a981:: with SMTP id n1mr15456697edc.377.1590913746696;
        Sun, 31 May 2020 01:29:06 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id o18sm11968840eje.40.2020.05.31.01.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:29:06 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v2 09/12] selftests/bpf: Add tests for attaching bpf_link to netns
Date:   Sun, 31 May 2020 10:28:43 +0200
Message-Id: <20200531082846.2117903-10-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
References: <20200531082846.2117903-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the existing test case for flow dissector attaching to cover:

 - link creation,
 - link updates,
 - link info querying,
 - mixing links with direct prog attachment.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../bpf/prog_tests/flow_dissector_reattach.c  | 588 ++++++++++++++++--
 1 file changed, 551 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
index 1f51ba66b98b..15cb554a66d8 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
@@ -11,6 +11,7 @@
 #include <fcntl.h>
 #include <sched.h>
 #include <stdbool.h>
+#include <sys/stat.h>
 #include <unistd.h>
 
 #include <linux/bpf.h>
@@ -18,21 +19,30 @@
 
 #include "test_progs.h"
 
-static bool is_attached(int netns)
+static int init_net = -1;
+
+static __u32 query_attached_prog_id(int netns)
 {
-	__u32 cnt;
+	__u32 prog_ids[1] = {};
+	__u32 prog_cnt = ARRAY_SIZE(prog_ids);
 	int err;
 
-	err = bpf_prog_query(netns, BPF_FLOW_DISSECTOR, 0, NULL, NULL, &cnt);
+	err = bpf_prog_query(netns, BPF_FLOW_DISSECTOR, 0, NULL,
+			     prog_ids, &prog_cnt);
 	if (CHECK_FAIL(err)) {
 		perror("bpf_prog_query");
-		return true; /* fail-safe */
+		return 0;
 	}
 
-	return cnt > 0;
+	return prog_cnt == 1 ? prog_ids[0] : 0;
+}
+
+static bool prog_is_attached(int netns)
+{
+	return query_attached_prog_id(netns) > 0;
 }
 
-static int load_prog(void)
+static int load_prog(enum bpf_prog_type type)
 {
 	struct bpf_insn prog[] = {
 		BPF_MOV64_IMM(BPF_REG_0, BPF_OK),
@@ -40,61 +50,566 @@ static int load_prog(void)
 	};
 	int fd;
 
-	fd = bpf_load_program(BPF_PROG_TYPE_FLOW_DISSECTOR, prog,
-			      ARRAY_SIZE(prog), "GPL", 0, NULL, 0);
+	fd = bpf_load_program(type, prog, ARRAY_SIZE(prog), "GPL", 0, NULL, 0);
 	if (CHECK_FAIL(fd < 0))
 		perror("bpf_load_program");
 
 	return fd;
 }
 
-static void do_flow_dissector_reattach(void)
+static __u32 query_prog_id(int prog)
 {
-	int prog_fd[2] = { -1, -1 };
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
 	int err;
 
-	prog_fd[0] = load_prog();
-	if (prog_fd[0] < 0)
-		return;
+	err = bpf_obj_get_info_by_fd(prog, &info, &info_len);
+	if (CHECK_FAIL(err || info_len != sizeof(info))) {
+		perror("bpf_obj_get_info_by_fd");
+		return 0;
+	}
 
-	prog_fd[1] = load_prog();
-	if (prog_fd[1] < 0)
-		goto out_close;
+	return info.id;
+}
+
+static int unshare_net(int old_net)
+{
+	int err, new_net;
 
-	err = bpf_prog_attach(prog_fd[0], 0, BPF_FLOW_DISSECTOR, 0);
+	err = unshare(CLONE_NEWNET);
 	if (CHECK_FAIL(err)) {
-		perror("bpf_prog_attach-0");
-		goto out_close;
+		perror("unshare(CLONE_NEWNET)");
+		return -1;
+	}
+	new_net = open("/proc/self/ns/net", O_RDONLY);
+	if (CHECK_FAIL(new_net < 0)) {
+		perror("open(/proc/self/ns/net)");
+		setns(old_net, CLONE_NEWNET);
+		return -1;
 	}
+	return new_net;
+}
+
+static void test_prog_attach_prog_attach(int netns, int prog1, int prog2)
+{
+	int err;
+
+	err = bpf_prog_attach(prog1, 0, BPF_FLOW_DISSECTOR, 0);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_attach(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
 
 	/* Expect success when attaching a different program */
-	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
+	err = bpf_prog_attach(prog2, 0, BPF_FLOW_DISSECTOR, 0);
 	if (CHECK_FAIL(err)) {
-		perror("bpf_prog_attach-1");
+		perror("bpf_prog_attach(prog2) #1");
 		goto out_detach;
 	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog2));
 
 	/* Expect failure when attaching the same program twice */
-	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
+	err = bpf_prog_attach(prog2, 0, BPF_FLOW_DISSECTOR, 0);
 	if (CHECK_FAIL(!err || errno != EINVAL))
-		perror("bpf_prog_attach-2");
+		perror("bpf_prog_attach(prog2) #2");
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog2));
 
 out_detach:
 	err = bpf_prog_detach(0, BPF_FLOW_DISSECTOR);
 	if (CHECK_FAIL(err))
 		perror("bpf_prog_detach");
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_link_create_link_create(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	int link1, link2;
+
+	link1 = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect failure creating link when another link exists */
+	errno = 0;
+	link2 = bpf_link_create(prog2, netns, BPF_FLOW_DISSECTOR, &opts);
+	if (CHECK_FAIL(link2 != -1 || errno != E2BIG))
+		perror("bpf_prog_attach(prog2) expected E2BIG");
+	if (link2 != -1)
+		close(link2);
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	close(link1);
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_prog_attach_link_create(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	int err, link;
+
+	err = bpf_prog_attach(prog1, -1, BPF_FLOW_DISSECTOR, 0);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_attach(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect failure creating link when prog attached */
+	errno = 0;
+	link = bpf_link_create(prog2, netns, BPF_FLOW_DISSECTOR, &opts);
+	if (CHECK_FAIL(link != -1 || errno != EEXIST))
+		perror("bpf_link_create(prog2) expected EEXIST");
+	if (link != -1)
+		close(link);
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	err = bpf_prog_detach(-1, BPF_FLOW_DISSECTOR);
+	if (CHECK_FAIL(err))
+		perror("bpf_prog_detach");
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_link_create_prog_attach(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	int err, link;
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect failure attaching prog when link exists */
+	errno = 0;
+	err = bpf_prog_attach(prog2, -1, BPF_FLOW_DISSECTOR, 0);
+	if (CHECK_FAIL(!err || errno != EEXIST))
+		perror("bpf_prog_attach(prog2) expected EEXIST");
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	close(link);
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_link_create_prog_detach(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	int err, link;
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect failure detaching prog when link exists */
+	errno = 0;
+	err = bpf_prog_detach(-1, BPF_FLOW_DISSECTOR);
+	if (CHECK_FAIL(!err || errno != EINVAL))
+		perror("bpf_prog_detach expected EINVAL");
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	close(link);
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_prog_attach_detach_query(int netns, int prog1, int prog2)
+{
+	int err;
+
+	err = bpf_prog_attach(prog1, 0, BPF_FLOW_DISSECTOR, 0);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_attach(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	err = bpf_prog_detach(0, BPF_FLOW_DISSECTOR);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_detach");
+		return;
+	}
+
+	/* Expect no prog attached after successful detach */
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_link_create_close_query(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	int link;
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	close(link);
+	/* Expect no prog attached after closing last link FD */
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_link_update_no_old_prog(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, create_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	int err, link;
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &create_opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect success replacing the prog when old prog not specified */
+	update_opts.flags = 0;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(err))
+		perror("bpf_link_update");
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog2));
+
+	close(link);
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_link_update_replace_old_prog(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, create_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	int err, link;
 
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &create_opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect success F_REPLACE and old prog specified to succeed */
+	update_opts.flags = BPF_F_REPLACE;
+	update_opts.old_prog_fd = prog1;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(err))
+		perror("bpf_link_update");
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog2));
+
+	close(link);
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_link_update_invalid_opts(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, create_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	int err, link;
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &create_opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect update to fail w/ old prog FD but w/o F_REPLACE*/
+	errno = 0;
+	update_opts.flags = 0;
+	update_opts.old_prog_fd = prog1;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(!err || errno != EINVAL)) {
+		perror("bpf_link_update expected EINVAL");
+		goto out_close;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect update to fail on old prog FD mismatch */
+	errno = 0;
+	update_opts.flags = BPF_F_REPLACE;
+	update_opts.old_prog_fd = prog2;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(!err || errno != EPERM)) {
+		perror("bpf_link_update expected EPERM");
+		goto out_close;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect update to fail for invalid old prog FD */
+	errno = 0;
+	update_opts.flags = BPF_F_REPLACE;
+	update_opts.old_prog_fd = -1;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(!err || errno != EBADF)) {
+		perror("bpf_link_update expected EBADF");
+		goto out_close;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect update to fail with invalid flags */
+	errno = 0;
+	update_opts.flags = BPF_F_ALLOW_MULTI;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(!err || errno != EINVAL))
+		perror("bpf_link_update expected EINVAL");
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+out_close:
+	close(link);
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_link_update_invalid_prog(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, create_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	int err, link, prog3;
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &create_opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	/* Expect failure when new prog FD is not valid */
+	errno = 0;
+	update_opts.flags = 0;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, -1, &update_opts);
+	if (CHECK_FAIL(!err || errno != EBADF)) {
+		perror("bpf_link_update expected EINVAL");
+		goto out_close_link;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	prog3 = load_prog(BPF_PROG_TYPE_SOCKET_FILTER);
+	if (prog3 < 0)
+		goto out_close_link;
+
+	/* Expect failure when new prog FD type doesn't match */
+	errno = 0;
+	update_opts.flags = 0;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, prog3, &update_opts);
+	if (CHECK_FAIL(!err || errno != EINVAL))
+		perror("bpf_link_update expected EINVAL");
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	close(prog3);
+out_close_link:
+	close(link);
+	CHECK_FAIL(prog_is_attached(netns));
+}
+
+static void test_link_update_netns_gone(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, create_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	int err, link, old_net;
+
+	old_net = netns;
+	netns = unshare_net(old_net);
+	if (netns < 0)
+		return;
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &create_opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+	CHECK_FAIL(query_attached_prog_id(netns) != query_prog_id(prog1));
+
+	close(netns);
+	err = setns(old_net, CLONE_NEWNET);
+	if (CHECK_FAIL(err)) {
+		perror("setns(CLONE_NEWNET)");
+		close(link);
+		return;
+	}
+
+	/* Expect failure when netns destroyed */
+	errno = 0;
+	update_opts.flags = 0;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(!err || errno != ENOLINK))
+		perror("bpf_link_update");
+
+	close(link);
+}
+
+static void test_link_get_info(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, create_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	struct bpf_link_info info = {};
+	struct stat netns_stat = {};
+	__u32 info_len, link_id;
+	int err, link, old_net;
+
+	old_net = netns;
+	netns = unshare_net(old_net);
+	if (netns < 0)
+		return;
+
+	err = fstat(netns, &netns_stat);
+	if (CHECK_FAIL(err)) {
+		perror("stat(netns)");
+		goto out_resetns;
+	}
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &create_opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		goto out_resetns;
+	}
+
+	info_len = sizeof(info);
+	err = bpf_obj_get_info_by_fd(link, &info, &info_len);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_obj_get_info");
+		goto out_unlink;
+	}
+	CHECK_FAIL(info_len != sizeof(info));
+
+	/* Expect link info to be sane and match prog and netns details */
+	CHECK_FAIL(info.type != BPF_LINK_TYPE_NETNS);
+	CHECK_FAIL(info.id == 0);
+	CHECK_FAIL(info.prog_id != query_prog_id(prog1));
+	CHECK_FAIL(info.netns.netns_ino != netns_stat.st_ino);
+	CHECK_FAIL(info.netns.attach_type != BPF_FLOW_DISSECTOR);
+
+	update_opts.flags = 0;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_link_update(prog2)");
+		goto out_unlink;
+	}
+
+	link_id = info.id;
+	info_len = sizeof(info);
+	err = bpf_obj_get_info_by_fd(link, &info, &info_len);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_obj_get_info");
+		goto out_unlink;
+	}
+	CHECK_FAIL(info_len != sizeof(info));
+
+	/* Expect no info change after update except in prog id */
+	CHECK_FAIL(info.type != BPF_LINK_TYPE_NETNS);
+	CHECK_FAIL(info.id != link_id);
+	CHECK_FAIL(info.prog_id != query_prog_id(prog2));
+	CHECK_FAIL(info.netns.netns_ino != netns_stat.st_ino);
+	CHECK_FAIL(info.netns.attach_type != BPF_FLOW_DISSECTOR);
+
+	/* Leave netns link is attached to and close last FD to it */
+	err = setns(old_net, CLONE_NEWNET);
+	if (CHECK_FAIL(err)) {
+		perror("setns(NEWNET)");
+		goto out_unlink;
+	}
+	close(netns);
+	old_net = -1;
+	netns = -1;
+
+	info_len = sizeof(info);
+	err = bpf_obj_get_info_by_fd(link, &info, &info_len);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_obj_get_info");
+		goto out_unlink;
+	}
+	CHECK_FAIL(info_len != sizeof(info));
+
+	/* Expect netns_ino to change to 0 */
+	CHECK_FAIL(info.type != BPF_LINK_TYPE_NETNS);
+	CHECK_FAIL(info.id != link_id);
+	CHECK_FAIL(info.prog_id != query_prog_id(prog2));
+	CHECK_FAIL(info.netns.netns_ino != 0);
+	CHECK_FAIL(info.netns.attach_type != BPF_FLOW_DISSECTOR);
+
+out_unlink:
+	close(link);
+out_resetns:
+	if (old_net != -1)
+		setns(old_net, CLONE_NEWNET);
+	if (netns != -1)
+		close(netns);
+}
+
+static void run_tests(int netns)
+{
+	struct test {
+		const char *test_name;
+		void (*test_func)(int netns, int prog1, int prog2);
+	} tests[] = {
+		{ "prog attach, prog attach",
+		  test_prog_attach_prog_attach },
+		{ "link create, link create",
+		  test_link_create_link_create },
+		{ "prog attach, link create",
+		  test_prog_attach_link_create },
+		{ "link create, prog attach",
+		  test_link_create_prog_attach },
+		{ "link create, prog detach",
+		  test_link_create_prog_detach },
+		{ "prog attach, detach, query",
+		  test_prog_attach_detach_query },
+		{ "link create, close, query",
+		  test_link_create_close_query },
+		{ "link update no old prog",
+		  test_link_update_no_old_prog },
+		{ "link update with replace old prog",
+		  test_link_update_replace_old_prog },
+		{ "link update invalid opts",
+		  test_link_update_invalid_opts },
+		{ "link update invalid prog",
+		  test_link_update_invalid_prog },
+		{ "link update netns gone",
+		  test_link_update_netns_gone },
+		{ "link get info",
+		  test_link_get_info },
+	};
+	int i, progs[2] = { -1, -1 };
+	char test_name[80];
+
+	for (i = 0; i < ARRAY_SIZE(progs); i++) {
+		progs[i] = load_prog(BPF_PROG_TYPE_FLOW_DISSECTOR);
+		if (progs[i] < 0)
+			goto out_close;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		snprintf(test_name, sizeof(test_name),
+			 "flow dissector %s%s",
+			 tests[i].test_name,
+			 netns == init_net ? " (init_net)" : "");
+		if (test__start_subtest(test_name))
+			tests[i].test_func(netns, progs[0], progs[1]);
+	}
 out_close:
-	close(prog_fd[1]);
-	close(prog_fd[0]);
+	for (i = 0; i < ARRAY_SIZE(progs); i++) {
+		if (progs[i] != -1)
+			CHECK_FAIL(close(progs[i]));
+	}
 }
 
 void test_flow_dissector_reattach(void)
 {
-	int init_net, self_net, err;
+	int err, new_net, saved_net;
 
-	self_net = open("/proc/self/ns/net", O_RDONLY);
-	if (CHECK_FAIL(self_net < 0)) {
+	saved_net = open("/proc/self/ns/net", O_RDONLY);
+	if (CHECK_FAIL(saved_net < 0)) {
 		perror("open(/proc/self/ns/net");
 		return;
 	}
@@ -111,30 +626,29 @@ void test_flow_dissector_reattach(void)
 		goto out_close;
 	}
 
-	if (is_attached(init_net)) {
+	if (prog_is_attached(init_net)) {
 		test__skip();
 		printf("Can't test with flow dissector attached to init_net\n");
 		goto out_setns;
 	}
 
 	/* First run tests in root network namespace */
-	do_flow_dissector_reattach();
+	run_tests(init_net);
 
 	/* Then repeat tests in a non-root namespace */
-	err = unshare(CLONE_NEWNET);
-	if (CHECK_FAIL(err)) {
-		perror("unshare(CLONE_NEWNET)");
+	new_net = unshare_net(init_net);
+	if (new_net < 0)
 		goto out_setns;
-	}
-	do_flow_dissector_reattach();
+	run_tests(new_net);
+	close(new_net);
 
 out_setns:
 	/* Move back to netns we started in. */
-	err = setns(self_net, CLONE_NEWNET);
+	err = setns(saved_net, CLONE_NEWNET);
 	if (CHECK_FAIL(err))
 		perror("setns(/proc/self/ns/net)");
 
 out_close:
 	close(init_net);
-	close(self_net);
+	close(saved_net);
 }
-- 
2.25.4

