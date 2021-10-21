Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6678B4365C4
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhJUPSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbhJUPST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:18:19 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9E2C06122A
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 08:16:03 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so37529wmz.2
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 08:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wPEEI/42En9uKSJ0rR6svxJibQPpLgl3/xd+Q1CAzs4=;
        b=ArwVTh3EaIjsFaD/Zbzk2v9QkwA3pWqH34r8L0lMMOpk5RFI4xI5zowgC5WNu3NqO5
         1kyrUBKSFJi7H2zK6/4d5xiODpuHqkWpcmN4WOp0LS6RRGmtvOpZ9JCaxt8m2Cz714ai
         QDV0et2cSifjt23YweKmZ8SMST9HKxMXkJCDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wPEEI/42En9uKSJ0rR6svxJibQPpLgl3/xd+Q1CAzs4=;
        b=GYICugr1bLJJtM1+w5XKDXJbYgpsWrttxVwX3ibSoIS0QBGw1OTY1lIMjiihgjkEi5
         SpZ+DnG0uyDzEXaTJKMXzr7eWDfKv9G2kGeeY9RGNRGDwSa76WYN4MgGDg0q3GNuFg5t
         VeRuO+pzTsZieAJQPjM1DFm9lw4RtJnKh+23fomG9bWXiETTkEyk8jsx3YRxuWHlMc0f
         YVNuJtMgzYC5jmEVTn4u9km8k5y+WVjqaag2eX1C0blOU83JO7UpJWnRJg7Spc58ChTt
         qLi1GQb1alYz4pm9n1kWzYjhmwmF1bm000jdwBOiKjkPm+Gas2qFkFjP4Hv9tLxbClSw
         n8oA==
X-Gm-Message-State: AOAM533VlkIHyzMFm/WMWtheZ8spT4nClEh0DbEsCCQmtRIVwsOwid32
        LU5myqQ+u+Izv8lHZjTKm2nd5Q==
X-Google-Smtp-Source: ABdhPJydPjkzgQW2iWvviw52oqi+ooJKj874Q5kNQJaDXzYi3gfB4tnn05PuwBzIoPhuvzR9ZiHLVQ==
X-Received: by 2002:a7b:c30c:: with SMTP id k12mr22015678wmj.38.1634829362115;
        Thu, 21 Oct 2021 08:16:02 -0700 (PDT)
Received: from altair.lan (7.2.6.0.8.8.2.4.4.c.c.f.b.1.5.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:451b:fcc4:4288:627])
        by smtp.googlemail.com with ESMTPSA id z1sm5098562wrt.94.2021.10.21.08.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:16:01 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 3/3] selftests: bpf: test RENAME_EXCHANGE and RENAME_NOREPLACE on bpffs
Date:   Thu, 21 Oct 2021 16:15:28 +0100
Message-Id: <20211021151528.116818-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211021151528.116818-1-lmb@cloudflare.com>
References: <20211021151528.116818-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to exercise the behaviour of RENAME_EXCHANGE and RENAME_NOREPLACE
on bpffs. The former checks that after an exchange the inode of two
directories has changed. The latter checks that the source still exists
after a failed rename.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/test_bpffs.c     | 65 ++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_bpffs.c b/tools/testing/selftests/bpf/prog_tests/test_bpffs.c
index 533e3f3a459a..d29ebfeef9c5 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_bpffs.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_bpffs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
 #define _GNU_SOURCE
+#include <stdio.h>
 #include <sched.h>
 #include <sys/mount.h>
 #include <sys/stat.h>
@@ -29,7 +30,8 @@ static int read_iter(char *file)
 
 static int fn(void)
 {
-	int err;
+	struct stat a, b, c;
+	int err, map;
 
 	err = unshare(CLONE_NEWNS);
 	if (!ASSERT_OK(err, "unshare"))
@@ -67,6 +69,67 @@ static int fn(void)
 	err = read_iter(TDIR "/fs2/progs.debug");
 	if (!ASSERT_OK(err, "reading " TDIR "/fs2/progs.debug"))
 		goto out;
+
+	err = mkdir(TDIR "/fs1/a", 0777);
+	if (!ASSERT_OK(err, "creating " TDIR "/fs1/a"))
+		goto out;
+	err = mkdir(TDIR "/fs1/a/1", 0777);
+	if (!ASSERT_OK(err, "creating " TDIR "/fs1/a/1"))
+		goto out;
+	err = mkdir(TDIR "/fs1/b", 0777);
+	if (!ASSERT_OK(err, "creating " TDIR "/fs1/b"))
+		goto out;
+
+	map = bpf_create_map(BPF_MAP_TYPE_ARRAY, 4, 4, 1, 0);
+	if (!ASSERT_GT(map, 0, "create_map(ARRAY)"))
+		goto out;
+	err = bpf_obj_pin(map, TDIR "/fs1/c");
+	if (!ASSERT_OK(err, "pin map"))
+		goto out;
+	close(map);
+
+	/* Check that RENAME_EXCHANGE works for directories. */
+	err = stat(TDIR "/fs1/a", &a);
+	if (!ASSERT_OK(err, "stat(" TDIR "/fs1/a)"))
+		goto out;
+	err = renameat2(0, TDIR "/fs1/a", 0, TDIR "/fs1/b", RENAME_EXCHANGE);
+	if (!ASSERT_OK(err, "renameat2(/fs1/a, /fs1/b, RENAME_EXCHANGE)"))
+		goto out;
+	err = stat(TDIR "/fs1/b", &b);
+	if (!ASSERT_OK(err, "stat(" TDIR "/fs1/b)"))
+		goto out;
+	if (!ASSERT_EQ(a.st_ino, b.st_ino, "b should have a's inode"))
+		goto out;
+	err = access(TDIR "/fs1/b/1", F_OK);
+	if (!ASSERT_OK(err, "access(" TDIR "/fs1/b/1)"))
+		goto out;
+
+	/* Check that RENAME_EXCHANGE works for mixed file types. */
+	err = stat(TDIR "/fs1/c", &c);
+	if (!ASSERT_OK(err, "stat(" TDIR "/fs1/map)"))
+		goto out;
+	err = renameat2(0, TDIR "/fs1/c", 0, TDIR "/fs1/b", RENAME_EXCHANGE);
+	if (!ASSERT_OK(err, "renameat2(/fs1/c, /fs1/b, RENAME_EXCHANGE)"))
+		goto out;
+	err = stat(TDIR "/fs1/b", &b);
+	if (!ASSERT_OK(err, "stat(" TDIR "/fs1/b)"))
+		goto out;
+	if (!ASSERT_EQ(c.st_ino, b.st_ino, "b should have c's inode"))
+		goto out;
+	err = access(TDIR "/fs1/c/1", F_OK);
+	if (!ASSERT_OK(err, "access(" TDIR "/fs1/c/1)"))
+		goto out;
+
+	/* Check that RENAME_NOREPLACE works. */
+	err = renameat2(0, TDIR "/fs1/b", 0, TDIR "/fs1/a", RENAME_NOREPLACE);
+	if (!ASSERT_ERR(err, "renameat2(RENAME_NOREPLACE)")) {
+		err = -EINVAL;
+		goto out;
+	}
+	err = access(TDIR "/fs1/b", F_OK);
+	if (!ASSERT_OK(err, "access(" TDIR "/fs1/b)"))
+		goto out;
+
 out:
 	umount(TDIR "/fs1");
 	umount(TDIR "/fs2");
-- 
2.32.0

