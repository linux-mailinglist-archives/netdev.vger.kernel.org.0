Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086711E4B7D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgE0RI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731156AbgE0RIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:08:55 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579DAC08C5C2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:55 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id y13so7004849eju.2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JAYN5a0KJoeE6Dvs0d4kZPvueK4ogH0zi3w+lkTlt3U=;
        b=ZzA+3ezNwa0vw+WJAixTidceDVlLqFSMivx7n0M34LgbIJKgymxptknYZ4/ldvMQtN
         Ac3A20eS1g+0fgMbyV/BcTLK8IiL/m6Pu1POBHpbPA2MatfBBm8YKoA/9in9HFfljuwP
         PJQrQlMzBJS+AnCvO22OID4yWPLaxEVsXsf7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JAYN5a0KJoeE6Dvs0d4kZPvueK4ogH0zi3w+lkTlt3U=;
        b=qdZjVFh8w6jJSSBH4/7u7y8nakmvrJhsG+vnUcP2IhRu4t8+j18koB8mLWrWmwpE22
         VzI/oJxeHgwYzsganSzPPeKEqN6utjggbLWuD/aMP2/P28THlXpTG6n9dLQ5TiwcdSde
         LUWZbZfwhdCc3thvOYaK7BHQN3tRyMazjMTsfTpcoog/Afjznp4o/vPtqNNV3aqCMtw2
         jyYWrojwbGKeVLfUkx0grYUVAPOjcEyKzsL5XrscqQsB3N4FFycQKHwmETHd/EbAWnRx
         G3eKzLFUUMhLmyoJtTY2QjtBRw+XL6Hrzm4VNcRoMf14XFzO42XVBYWKHV7o8dVmxWYY
         h7tg==
X-Gm-Message-State: AOAM532pHRaWvsHUuKbjmYTgxGOWmUxNgsk8VrvLCTU6anY8ZO3Av6Xt
        4Jx3KN8MPITbiHEruUnYYjfFXQ==
X-Google-Smtp-Source: ABdhPJwjfRhpfMcg5gnuv0i2uUUdcLn70pQpwoe1Rrux735r2ZA7ZmTFV859eJycyXBDmReJhRY+Bg==
X-Received: by 2002:a17:906:3944:: with SMTP id g4mr6905752eje.55.1590599333891;
        Wed, 27 May 2020 10:08:53 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id g21sm2580528edw.9.2020.05.27.10.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 10:08:53 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 8/8] selftests/bpf: Add tests for attaching bpf_link to netns
Date:   Wed, 27 May 2020 19:08:40 +0200
Message-Id: <20200527170840.1768178-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200527170840.1768178-1-jakub@cloudflare.com>
References: <20200527170840.1768178-1-jakub@cloudflare.com>
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
 .../bpf/prog_tests/flow_dissector_reattach.c  | 500 +++++++++++++++++-
 1 file changed, 471 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
index 1f51ba66b98b..b702226fa762 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
@@ -11,6 +11,7 @@
 #include <fcntl.h>
 #include <sched.h>
 #include <stdbool.h>
+#include <sys/stat.h>
 #include <unistd.h>
 
 #include <linux/bpf.h>
@@ -18,6 +19,8 @@
 
 #include "test_progs.h"
 
+static int init_net = -1;
+
 static bool is_attached(int netns)
 {
 	__u32 cnt;
@@ -32,7 +35,7 @@ static bool is_attached(int netns)
 	return cnt > 0;
 }
 
-static int load_prog(void)
+static int load_prog(enum bpf_prog_type type)
 {
 	struct bpf_insn prog[] = {
 		BPF_MOV64_IMM(BPF_REG_0, BPF_OK),
@@ -40,61 +43,494 @@ static int load_prog(void)
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
+static void test_prog_attach_prog_attach(int netns, int prog1, int prog2)
 {
-	int prog_fd[2] = { -1, -1 };
 	int err;
 
-	prog_fd[0] = load_prog();
-	if (prog_fd[0] < 0)
-		return;
-
-	prog_fd[1] = load_prog();
-	if (prog_fd[1] < 0)
-		goto out_close;
-
-	err = bpf_prog_attach(prog_fd[0], 0, BPF_FLOW_DISSECTOR, 0);
+	err = bpf_prog_attach(prog1, 0, BPF_FLOW_DISSECTOR, 0);
 	if (CHECK_FAIL(err)) {
-		perror("bpf_prog_attach-0");
-		goto out_close;
+		perror("bpf_prog_attach(prog1)");
+		return;
 	}
 
 	/* Expect success when attaching a different program */
-	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
+	err = bpf_prog_attach(prog2, 0, BPF_FLOW_DISSECTOR, 0);
 	if (CHECK_FAIL(err)) {
-		perror("bpf_prog_attach-1");
+		perror("bpf_prog_attach(prog2) #1");
 		goto out_detach;
 	}
 
 	/* Expect failure when attaching the same program twice */
-	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
+	err = bpf_prog_attach(prog2, 0, BPF_FLOW_DISSECTOR, 0);
 	if (CHECK_FAIL(!err || errno != EINVAL))
-		perror("bpf_prog_attach-2");
+		perror("bpf_prog_attach(prog2) #2");
 
 out_detach:
 	err = bpf_prog_detach(0, BPF_FLOW_DISSECTOR);
 	if (CHECK_FAIL(err))
 		perror("bpf_prog_detach");
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
+
+	/* Expect failure creating link when another link exists */
+	errno = 0;
+	link2 = bpf_link_create(prog2, netns, BPF_FLOW_DISSECTOR, &opts);
+	if (CHECK_FAIL(link2 != -1 || errno != E2BIG))
+		perror("bpf_prog_attach(prog2) expected E2BIG");
+	if (link2 != -1)
+		close(link2);
+
+	close(link1);
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
+
+	/* Expect failure creating link when prog attached */
+	errno = 0;
+	link = bpf_link_create(prog2, netns, BPF_FLOW_DISSECTOR, &opts);
+	if (CHECK_FAIL(link != -1 || errno != EBUSY))
+		perror("bpf_link_create(prog2) expected EBUSY");
+	if (link != -1)
+		close(link);
+
+	err = bpf_prog_detach(-1, BPF_FLOW_DISSECTOR);
+	if (CHECK_FAIL(err))
+		perror("bpf_prog_detach");
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
+
+	/* Expect failure attaching prog when link exists */
+	errno = 0;
+	err = bpf_prog_attach(prog2, -1, BPF_FLOW_DISSECTOR, 0);
+	if (CHECK_FAIL(!err || errno != EBUSY))
+		perror("bpf_prog_attach(prog2) expected EBUSY");
+
+	close(link);
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
+
+	/* Expect failure detaching prog when link exists */
+	errno = 0;
+	err = bpf_prog_detach(-1, BPF_FLOW_DISSECTOR);
+	if (CHECK_FAIL(!err || errno != EBUSY))
+		perror("bpf_prog_detach");
+
+	close(link);
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
+	if (CHECK_FAIL(!is_attached(netns)))
+		return;
+
+	err = bpf_prog_detach(0, BPF_FLOW_DISSECTOR);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_prog_detach");
+		return;
+	}
+
+	/* Expect no prog attached after successful detach */
+	CHECK_FAIL(is_attached(netns));
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
+	if (CHECK_FAIL(!is_attached(netns)))
+		return;
+
+	close(link);
+	/* Expect no prog attached after closing last link FD */
+	CHECK_FAIL(is_attached(netns));
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
+
+	/* Expect success replacing the prog when old prog not specified */
+	update_opts.flags = 0;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(err))
+		perror("bpf_link_update");
+
+	close(link);
+}
+
+static void test_link_update_replace_old_prog(int netns, int prog1, int prog2)
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
+
+	/* Expect success F_REPLACE and old prog specified to succeed */
+	update_opts.flags = BPF_F_REPLACE;
+	update_opts.old_prog_fd = prog1;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(err))
+		perror("bpf_link_update");
+
+	close(link);
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
+
+	/* Expect update to fail with invalid flags */
+	errno = 0;
+	update_opts.flags = BPF_F_ALLOW_MULTI;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(!err || errno != EINVAL))
+		perror("bpf_link_update expected EINVAL");
 
 out_close:
-	close(prog_fd[1]);
-	close(prog_fd[0]);
+	close(link);
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
+
+	close(prog3);
+out_close_link:
+	close(link);
+}
+
+static void test_link_update_netns_gone(int netns, int prog1, int prog2)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, create_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	int err, link, old_netns;
+
+	err = unshare(CLONE_NEWNET);
+	if (CHECK_FAIL(err)) {
+		perror("unshare(CLONE_NEWNET)");
+		return;
+	}
+
+	old_netns = netns;
+	netns = open("/proc/self/ns/net", O_RDONLY);
+	if (CHECK_FAIL(netns < 0)) {
+		perror("open(/proc/self/ns/net");
+		setns(old_netns, CLONE_NEWNET);
+		return;
+	}
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &create_opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+
+	close(netns);
+	err = setns(old_netns, CLONE_NEWNET);
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
+	struct bpf_prog_info prog1_info = {};
+	struct bpf_prog_info prog2_info = {};
+	struct bpf_link_info link_info1 = {};
+	struct bpf_link_info link_info2 = {};
+	struct stat netns_stat = {};
+	unsigned int info_len;
+	int err, link;
+
+	err = fstat(netns, &netns_stat);
+	if (CHECK_FAIL(err)) {
+		perror("stat(netns)");
+		return;
+	}
+
+	info_len = sizeof(prog1_info);
+	err = bpf_obj_get_info_by_fd(prog1, &prog1_info, &info_len);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_obj_get_info_by_fd(prog1)");
+		return;
+	}
+	CHECK_FAIL(info_len != sizeof(prog1_info));
+
+	info_len = sizeof(prog2_info);
+	err = bpf_obj_get_info_by_fd(prog2, &prog2_info, &info_len);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_obj_get_info_by_fd(prog1)");
+		return;
+	}
+	CHECK_FAIL(info_len != sizeof(prog2_info));
+
+	link = bpf_link_create(prog1, netns, BPF_FLOW_DISSECTOR, &create_opts);
+	if (CHECK_FAIL(link < 0)) {
+		perror("bpf_link_create(prog1)");
+		return;
+	}
+
+	info_len = sizeof(link_info1);
+	err = bpf_obj_get_info_by_fd(link, &link_info1, &info_len);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_obj_get_info");
+		goto out_close;
+	}
+	CHECK_FAIL(info_len != sizeof(link_info1));
+
+	/* Expect link info to be sane and match prog and netns details */
+	CHECK_FAIL(link_info1.type != BPF_LINK_TYPE_NETNS);
+	CHECK_FAIL(link_info1.id == 0);
+	CHECK_FAIL(link_info1.prog_id != prog1_info.id);
+	CHECK_FAIL(link_info1.netns.netns_ino != netns_stat.st_ino);
+	CHECK_FAIL(link_info1.netns.attach_type != BPF_FLOW_DISSECTOR);
+
+	update_opts.flags = 0;
+	update_opts.old_prog_fd = 0;
+	err = bpf_link_update(link, prog2, &update_opts);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_link_update(prog2)");
+		goto out_close;
+	}
+
+	info_len = sizeof(link_info2);
+	err = bpf_obj_get_info_by_fd(link, &link_info2, &info_len);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_obj_get_info");
+		goto out_close;
+	}
+	CHECK_FAIL(info_len != sizeof(link_info2));
+
+	/* Expect no info change after update except in prog id */
+	CHECK_FAIL(link_info2.type != BPF_LINK_TYPE_NETNS);
+	CHECK_FAIL(link_info2.id != link_info1.id);
+	CHECK_FAIL(link_info2.prog_id != prog2_info.id);
+	CHECK_FAIL(link_info2.netns.netns_ino != netns_stat.st_ino);
+	CHECK_FAIL(link_info2.netns.attach_type != BPF_FLOW_DISSECTOR);
+
+out_close:
+	close(link);
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
+out_close:
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
@@ -118,7 +554,7 @@ void test_flow_dissector_reattach(void)
 	}
 
 	/* First run tests in root network namespace */
-	do_flow_dissector_reattach();
+	run_tests(init_net);
 
 	/* Then repeat tests in a non-root namespace */
 	err = unshare(CLONE_NEWNET);
@@ -126,15 +562,21 @@ void test_flow_dissector_reattach(void)
 		perror("unshare(CLONE_NEWNET)");
 		goto out_setns;
 	}
-	do_flow_dissector_reattach();
+	new_net = open("/proc/self/ns/net", O_RDONLY);
+	if (CHECK_FAIL(new_net < 0)) {
+		perror("open(/proc/self/ns/net");
+		return;
+	}
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

