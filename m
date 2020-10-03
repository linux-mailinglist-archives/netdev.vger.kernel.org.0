Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0353A2822BC
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgJCIze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgJCIza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:55:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004E1C0613D0;
        Sat,  3 Oct 2020 01:55:29 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id x2so2427683pjk.0;
        Sat, 03 Oct 2020 01:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nuGVlYXVa1ADtayePQ599HBG7S1v+QC4V52l2CtSHRg=;
        b=JOzOz+1IBVA+4o8aa42xbdQQGYjAeZ64RH9FdmpHdTH1XvcxXJ5dYx8eZmYxZdpbIw
         S8Fb2Qg/KNrAeSeSAbAFEH1jCewTP+JudjXpDmV8HZv/tCl1mLkQg+/khQxtcL0qo8hg
         EjvB0jSKZbayFrmSqf9IZNIZcsjToo8MDPYahU91ovXJXKLddr/Gse8znhQaRBWx7bPN
         NA78+EQhLG4P8I/huWAY1A+P3nK3SEV6Mw6DErKhwyTj9A3C5z+T56jC8DAeuOX5PncK
         J18Cm3ijTnlv4+eihrHkYbFc7NtkCBP4ekJ7VKCFuOMbY+CMFFq2Xa5u5DTLeKu9oEF0
         2oBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nuGVlYXVa1ADtayePQ599HBG7S1v+QC4V52l2CtSHRg=;
        b=btPkymV8UUnQu2fU8qSHby1lfVtqiOMyQjU8F8j7AzRrKKuqnwP1Jh9Lg3WJkeMcXu
         A9UoZLSQuT+1vUzAUBVAGz6XN6tnXNa9tZ4jbne070zOpTEzxwVaSm2Pp/3+nkjTN9CF
         1cLvq1nBhRKcRpvI2ELpND4djQwBDyHHdogbUDPgKnkS2XcxdJtm5gftctyZKtNMCRU4
         kYciv2ma7A9xvmPuGe0axO/kGJvI7klynl3cMI3NxaPZ/LQhji3D/Yz8dW2iMvSIRarX
         yIyhnUsDlD/mW4/U4j9F4h5G/E0f2TDdmNJ1lFF7h29XyPQaJiWfI+s+rFtsSbmeBiqv
         HMAQ==
X-Gm-Message-State: AOAM532cnojJRxx74NdmYBRkHXU4zOPm2Uu1YMPrCKqmQnTmG1a3axnr
        RwG3TA/DXk3GPv9JTNViMHVDL4j0081q/w==
X-Google-Smtp-Source: ABdhPJyuKtdm+fyQDBh92MQpMN97ZInscOQN+Q12U44h7Gs+f0llwwDuwP8WdxXyOuNpkNXTGKyRog==
X-Received: by 2002:a17:90a:71c3:: with SMTP id m3mr7043719pjs.68.1601715329314;
        Sat, 03 Oct 2020 01:55:29 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a15sm4566374pgi.69.2020.10.03.01.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 01:55:28 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf 3/3] selftest/bpf: test pinning map with reused map fd
Date:   Sat,  3 Oct 2020 16:55:05 +0800
Message-Id: <20201003085505.3388332-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201003085505.3388332-1-liuhangbin@gmail.com>
References: <20201002075750.1978298-1-liuhangbin@gmail.com>
 <20201003085505.3388332-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This add a test to make sure that we can still pin maps with
reused map fd.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/bpf/prog_tests/pinning.c        | 46 ++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testing/selftests/bpf/prog_tests/pinning.c
index 041952524c55..299f99ef92b2 100644
--- a/tools/testing/selftests/bpf/prog_tests/pinning.c
+++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
@@ -37,7 +37,7 @@ void test_pinning(void)
 	struct stat statbuf = {};
 	struct bpf_object *obj;
 	struct bpf_map *map;
-	int err;
+	int err, map_fd;
 	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
 		.pin_root_path = custpath,
 	);
@@ -213,6 +213,50 @@ void test_pinning(void)
 	if (CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno))
 		goto out;
 
+	/* remove the custom pin path to re-test it with reuse fd below */
+	err = unlink(custpinpath);
+	if (CHECK(err, "unlink custpinpath", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = rmdir(custpath);
+	if (CHECK(err, "rmdir custpindir", "err %d errno %d\n", err, errno))
+		goto out;
+
+	bpf_object__close(obj);
+
+	/* test pinning at custom path with reuse fd */
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK_FAIL(libbpf_get_error(obj))) {
+		obj = NULL;
+		goto out;
+	}
+
+	map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, sizeof(__u32),
+				sizeof(__u64), 1, 0);
+	if (CHECK(map_fd < 0, "create pinmap manually", "fd %d\n", map_fd))
+		goto out;
+
+	map = bpf_object__find_map_by_name(obj, "pinmap");
+	if (CHECK(!map, "find map", "NULL map"))
+		goto out;
+
+	err = bpf_map__reuse_fd(map, map_fd);
+	if (CHECK(err, "reuse pinmap fd", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = bpf_map__set_pin_path(map, custpinpath);
+	if (CHECK(err, "set pin path", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "custom load", "err %d errno %d\n", err, errno))
+		goto out;
+
+	/* check that pinmap was pinned at the custom path */
+	err = stat(custpinpath, &statbuf);
+	if (CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno))
+		goto out;
+
 out:
 	unlink(pinpath);
 	unlink(nopinpath);
-- 
2.25.4

