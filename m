Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23FA2C597E
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 17:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403930AbgKZQpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 11:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391548AbgKZQpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 11:45:44 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76967C0617A7
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 08:45:44 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id x22so2690610wmc.5
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 08:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JquaGZ4n6vRq9oOS/Nn0a4TRgj4BlG1HC7wCqFjNeO4=;
        b=nmlDob9p8DccospaPcW6JURvwmTYAbhm1w3tIUeM0PxqDr7GYt8vl5kY6/lAbTV8nT
         9NvIIsPmaJJ4KruAfekKCYZkjjkg4tiWKKrhy/TpGX5K59vkwvedP+pXmF6CIGQOtsXr
         iwWrb+2T1gzU01eS5C811TkU4kOcqnPObScrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JquaGZ4n6vRq9oOS/Nn0a4TRgj4BlG1HC7wCqFjNeO4=;
        b=Xg/+NMrGFO7Wu6PT+sBGbcD8L9xz9XYPWVdwUjcBf55cYzHJh6P/V6/jvijjl6Z166
         gWYlkMyjN1VvlSwuAT0WTEBslfhl29x7g9NRPoJCBaCwSGtPi7LbhhFrCs2eBke0143c
         aWDd3YeLxSK5GNIeIT1ghecz3KbL+zq0SYIIz3eNgxTxjFxEIfYJKHT0fbviLvL4HVHW
         TWtn4iRjufsUiZSYgxefq5T+KQwbgtPmNsH0FiqA44kE+vqS2tr3anMGXIlZrveWcc2U
         c89X31Z6IVDfpOrLbBJdf+gp0q982n7CPsMmDW3NdCWQvJP7H4cUzapTo2t7hkoXcigV
         JtJw==
X-Gm-Message-State: AOAM531+EKA+UCZwdA9PwilFVQ2MsCIR0aPJQKbcbhoy+HmS0zee+MJz
        7C7Cfj/1OKr637vsbfAju1766g==
X-Google-Smtp-Source: ABdhPJyPS0o+jWO5pjI5vTxr6yRbjDbxrtdz23Gp1AI3CvBSTTBdSm2ZxoxPDebDlSzYjJR/qt960Q==
X-Received: by 2002:a1c:96cb:: with SMTP id y194mr4292036wmd.62.1606409143233;
        Thu, 26 Nov 2020 08:45:43 -0800 (PST)
Received: from revest.zrh.corp.google.com ([2a00:79e0:42:204:f693:9fff:fef4:a569])
        by smtp.gmail.com with ESMTPSA id f17sm8805824wmh.10.2020.11.26.08.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 08:45:42 -0800 (PST)
From:   Florent Revest <revest@chromium.org>
X-Google-Original-From: Florent Revest <revest@google.com>
To:     bpf@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 5/6] bpf: Add an iterator selftest for bpf_sk_storage_get
Date:   Thu, 26 Nov 2020 17:44:48 +0100
Message-Id: <20201126164449.1745292-5-revest@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
In-Reply-To: <20201126164449.1745292-1-revest@google.com>
References: <20201126164449.1745292-1-revest@google.com>
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
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 40 +++++++++++++++++++
 .../progs/bpf_iter_bpf_sk_storage_helpers.c   | 25 ++++++++++++
 2 files changed, 65 insertions(+)

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
index 01ff3235e413..d7a7a802d172 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
@@ -21,3 +21,28 @@ int delete_bpf_sk_storage_map(struct bpf_iter__bpf_sk_storage_map *ctx)
 
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
+	if (!task || !file || task->tgid != task->pid)
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
+
-- 
2.29.2.454.gaff20da3a2-goog

