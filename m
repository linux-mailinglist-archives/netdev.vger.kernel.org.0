Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F6B2CC87B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388475AbgLBU5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388365AbgLBU5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:57:37 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4A1C061A53
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 12:55:57 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id l1so5531592wrb.9
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 12:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JXlqoqEBiKKDKku1a+ImTf8NUEd7mW8hynHEOt1YE6I=;
        b=lSZDDuYkzJmdtwJtYk6NIj7wuAWjvahaWLii5npycSlUdAo3QaxpPalEXmkoXnI2M0
         WrWQEldQrKoAK2mkuHGwM0EetQDp9MG1++64WzUUe2DCx8h8JyOr3nAkgmm2GIBXTDug
         7W8j8U2NOlZEos8Leq9nJFwoWYRv8RCxCdWCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JXlqoqEBiKKDKku1a+ImTf8NUEd7mW8hynHEOt1YE6I=;
        b=bFkU0QGBB9QPHxQWWlwbpeYhPMAmoxTv+Y0v4tlD+tW0GkXMIhTJEVprbCiGTNtm9o
         S6YXL2qcK5XSzzSmj2sIQKpiOOHpY7dgqPsTg+w2gcPR78wHRXHYYYbN4vNcVVlcEYam
         QAT4shk1FPaD8U9PQthyps+J0UAGHyVTurweXCrbSbGCC6GrVvIueB84d/x8pBO7tRcS
         PSxt5MJLY25I60qhcTcHK9xkurM3eM86T+/+bYGgc6HGslZKzsCDEagmZFg61dzbPiPS
         B6K735tyEQhertcYSHqTGZZFN6nUhgFq/36JztYsnSw19DZz2cVIqZdCzk6E3Pc404z9
         B+Pw==
X-Gm-Message-State: AOAM531c34r6/PdmDyObWkmlmxS6/25CHinUxzRrM9jBhJWSF0y3LQTE
        QdB/RDWC5dGEQU6VDJavUSkNow==
X-Google-Smtp-Source: ABdhPJw/FDI/WdpspA6dNXN9xAYhdMJOw/WdPg/yjXG3QTCmYa2PhCvUZqhKVm8IO4yNCNBg9sBzJw==
X-Received: by 2002:adf:f2d1:: with SMTP id d17mr5586973wrp.339.1606942555805;
        Wed, 02 Dec 2020 12:55:55 -0800 (PST)
Received: from revest.zrh.corp.google.com ([2a00:79e0:42:204:f693:9fff:fef4:a569])
        by smtp.gmail.com with ESMTPSA id d2sm3438486wrn.43.2020.12.02.12.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 12:55:55 -0800 (PST)
From:   Florent Revest <revest@chromium.org>
X-Google-Original-From: Florent Revest <revest@google.com>
To:     bpf@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 6/6] bpf: Test bpf_sk_storage_get in tcp iterators
Date:   Wed,  2 Dec 2020 21:55:27 +0100
Message-Id: <20201202205527.984965-6-revest@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
In-Reply-To: <20201202205527.984965-1-revest@google.com>
References: <20201202205527.984965-1-revest@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This extends the existing bpf_sk_storage_get test where a socket is
created and tagged with its creator's pid by a task_file iterator.

A TCP iterator is now also used at the end of the test to negate the
values already stored in the local storage. The test therefore expects
-getpid() to be stored in the local storage.

Signed-off-by: Florent Revest <revest@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c        | 13 +++++++++++++
 .../progs/bpf_iter_bpf_sk_storage_helpers.c    | 18 ++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index 9336d0f18331..b8362147c9e3 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -978,6 +978,8 @@ static void test_bpf_sk_storage_delete(void)
 /* This creates a socket and its local storage. It then runs a task_iter BPF
  * program that replaces the existing socket local storage with the tgid of the
  * only task owning a file descriptor to this socket, this process, prog_tests.
+ * It then runs a tcp socket iterator that negates the value in the existing
+ * socket local storage, the test verifies that the resulting value is -pid.
  */
 static void test_bpf_sk_storage_get(void)
 {
@@ -994,6 +996,10 @@ static void test_bpf_sk_storage_get(void)
 	if (CHECK(sock_fd < 0, "socket", "errno: %d\n", errno))
 		goto out;
 
+	err = listen(sock_fd, 1);
+	if (CHECK(err != 0, "listen", "errno: %d\n", errno))
+		goto out;
+
 	map_fd = bpf_map__fd(skel->maps.sk_stg_map);
 
 	err = bpf_map_update_elem(map_fd, &sock_fd, &val, BPF_NOEXIST);
@@ -1007,6 +1013,13 @@ static void test_bpf_sk_storage_get(void)
 	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
 	      getpid(), val, err);
 
+	do_dummy_read(skel->progs.negate_socket_local_storage);
+
+	err = bpf_map_lookup_elem(map_fd, &sock_fd, &val);
+	CHECK(err || val != -getpid(), "bpf_map_lookup_elem",
+	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
+	      -getpid(), val, err);
+
 close_socket:
 	close(sock_fd);
 out:
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
index dde53df37de8..6cecab2b32ba 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
@@ -45,3 +45,21 @@ int fill_socket_owner(struct bpf_iter__task_file *ctx)
 
 	return 0;
 }
+
+SEC("iter/tcp")
+int negate_socket_local_storage(struct bpf_iter__tcp *ctx)
+{
+	struct sock_common *sk_common = ctx->sk_common;
+	int *sock_tgid;
+
+	if (!sk_common)
+		return 0;
+
+	sock_tgid = bpf_sk_storage_get(&sk_stg_map, sk_common, 0, 0);
+	if (!sock_tgid)
+		return 0;
+
+	*sock_tgid = -*sock_tgid;
+
+	return 0;
+}
-- 
2.29.2.454.gaff20da3a2-goog

