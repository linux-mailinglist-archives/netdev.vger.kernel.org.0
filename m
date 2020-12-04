Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5962CED32
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388109AbgLDLhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388093AbgLDLhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 06:37:52 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21A1C08E862
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 03:36:23 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id u12so5029515wrt.0
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 03:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fXpQWRWHbOSLcuiT66TfavvJzdpZxX+kQ2onWRpZPLs=;
        b=fSH7qd/o/iD7J59zfLTAyuMUqIr5Uq1gqP7zmJUuogp/9wEc6Fb1kScLGwgUVfpOkj
         VztdXhJh3/xz+8GBQuLWr5QSU8LMaBf3f+MdyjR86gmOnL5ShKtaioQyrxVv6Wm4O6ap
         IZOkBS2ERiXmBoHaintWdS6Hv9zidL9UB25FM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fXpQWRWHbOSLcuiT66TfavvJzdpZxX+kQ2onWRpZPLs=;
        b=FSxt5ymDuVPTgh2GcJGu9Gx84zCORGCPDuF1rS1v7fNqbqfvIoNu2wDyEJJkYPEwfR
         fG+YWZa9mB+6RBkfjbZAChz1+vQHhL0N5+DNRrm+XH4+8WJOpuWqadqsLRxpYMHINRvT
         foLEObgq4f+LUuBVz+kQw2aK3Nxti6SwnToHD2NaQHQ2I2ktefonHnHQe8O0jkwJ1iLa
         7ZEjLBgfHGW7krVM7/9apLOvMD2Q1lx2WAlcjUPgPiKfiww4M3Mpey0YGSiublKQEpv4
         ID9rr3Sv061AYQ4iZl6fqPSxOOS7x1hAp9SPeJJ/HrrPzfIq7mvYOHjoI8MuzwTBvdmi
         oJhQ==
X-Gm-Message-State: AOAM533PwX+cz6OV/LTjyPMZy21lUXwTwV66WYkRzFrNdvG8Sm3qJ0GX
        n2A7WI4A6P0p7QhHHLQjkC4OSw==
X-Google-Smtp-Source: ABdhPJyeAQ6dMQHyLzw7wHLSE+f5lcq2eruAyS653LBDoUaeBqR53E4yrzHJU94Powxizg9UrM9znQ==
X-Received: by 2002:adf:f304:: with SMTP id i4mr4499284wro.268.1607081782663;
        Fri, 04 Dec 2020 03:36:22 -0800 (PST)
Received: from revest.zrh.corp.google.com ([2a00:79e0:42:204:f693:9fff:fef4:a569])
        by smtp.gmail.com with ESMTPSA id j6sm3202750wrq.38.2020.12.04.03.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 03:36:22 -0800 (PST)
From:   Florent Revest <revest@chromium.org>
X-Google-Original-From: Florent Revest <revest@google.com>
To:     bpf@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 5/6] selftests/bpf: Add an iterator selftest for bpf_sk_storage_get
Date:   Fri,  4 Dec 2020 12:36:08 +0100
Message-Id: <20201204113609.1850150-5-revest@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201204113609.1850150-1-revest@google.com>
References: <20201204113609.1850150-1-revest@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eBPF program iterates over all files and tasks. For all socket
files, it stores the tgid of the last task it encountered with a handle
to that socket. This is a heuristic for finding the "owner" of a socket
similar to what's done by lsof, ss, netstat or fuser. Potentially, this
information could be used from a cgroup_skb/*gress hook to try to
associate network traffic with processes.

The test makes sure that a socket it created is tagged with prog_tests's
pid.

Signed-off-by: Florent Revest <revest@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 40 +++++++++++++++++++
 .../progs/bpf_iter_bpf_sk_storage_helpers.c   | 24 +++++++++++
 2 files changed, 64 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index bb4a638f2e6f..9336d0f18331 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -975,6 +975,44 @@ static void test_bpf_sk_storage_delete(void)
 	bpf_iter_bpf_sk_storage_helpers__destroy(skel);
 }
 
+/* This creates a socket and its local storage. It then runs a task_iter BPF
+ * program that replaces the existing socket local storage with the tgid of the
+ * only task owning a file descriptor to this socket, this process, prog_tests.
+ */
+static void test_bpf_sk_storage_get(void)
+{
+	struct bpf_iter_bpf_sk_storage_helpers *skel;
+	int err, map_fd, val = -1;
+	int sock_fd = -1;
+
+	skel = bpf_iter_bpf_sk_storage_helpers__open_and_load();
+	if (CHECK(!skel, "bpf_iter_bpf_sk_storage_helpers__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (CHECK(sock_fd < 0, "socket", "errno: %d\n", errno))
+		goto out;
+
+	map_fd = bpf_map__fd(skel->maps.sk_stg_map);
+
+	err = bpf_map_update_elem(map_fd, &sock_fd, &val, BPF_NOEXIST);
+	if (CHECK(err, "bpf_map_update_elem", "map_update_failed\n"))
+		goto close_socket;
+
+	do_dummy_read(skel->progs.fill_socket_owner);
+
+	err = bpf_map_lookup_elem(map_fd, &sock_fd, &val);
+	CHECK(err || val != getpid(), "bpf_map_lookup_elem",
+	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
+	      getpid(), val, err);
+
+close_socket:
+	close(sock_fd);
+out:
+	bpf_iter_bpf_sk_storage_helpers__destroy(skel);
+}
+
 static void test_bpf_sk_storage_map(void)
 {
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
@@ -1131,6 +1169,8 @@ void test_bpf_iter(void)
 		test_bpf_sk_storage_map();
 	if (test__start_subtest("bpf_sk_storage_delete"))
 		test_bpf_sk_storage_delete();
+	if (test__start_subtest("bpf_sk_storage_get"))
+		test_bpf_sk_storage_get();
 	if (test__start_subtest("rdonly-buf-out-of-bound"))
 		test_rdonly_buf_out_of_bound();
 	if (test__start_subtest("buf-neg-offset"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
index 01ff3235e413..dde53df37de8 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
@@ -21,3 +21,27 @@ int delete_bpf_sk_storage_map(struct bpf_iter__bpf_sk_storage_map *ctx)
 
 	return 0;
 }
+
+SEC("iter/task_file")
+int fill_socket_owner(struct bpf_iter__task_file *ctx)
+{
+	struct task_struct *task = ctx->task;
+	struct file *file = ctx->file;
+	struct socket *sock;
+	int *sock_tgid;
+
+	if (!task || !file)
+		return 0;
+
+	sock = bpf_sock_from_file(file);
+	if (!sock)
+		return 0;
+
+	sock_tgid = bpf_sk_storage_get(&sk_stg_map, sock->sk, 0, 0);
+	if (!sock_tgid)
+		return 0;
+
+	*sock_tgid = task->tgid;
+
+	return 0;
+}
-- 
2.29.2.576.ga3fc446d84-goog

