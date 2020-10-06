Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC2A2843FE
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 04:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgJFCPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 22:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgJFCPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 22:15:19 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2787C0613CE;
        Mon,  5 Oct 2020 19:15:17 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k8so8138036pfk.2;
        Mon, 05 Oct 2020 19:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fjDPfGjNC204PQtu2+64xYwVRdnbGQEEQskQTfu5T04=;
        b=dQwPIdQ2ndtgszpYBf4IoUyUQV1zhLG7bZxgH37BSA53S6lpk7nhvHP0Z2+U43xlil
         q9cSO2MqlBtb8szTXRqhU50TGNA4mq5Ck5XsIgZDq/6ohUYuJs25NItdKScQngNzRm6l
         51ZgCVa6lags3NtlMNfFO3jCR/K/oYMubCOb2SfkaoU+RyCzYVXTtdm2XAqvPr0Xyr/b
         tysLcBYG+KOz20MjhOCw+9UNCJN0qwsUTMhEhgyq0/E/3tlTFEKUnDPiATlFSMHggMYW
         IAafc6P6FZuaJJOWg6hcYi4Ae3OgN4A58H7yac6hYs7JygHfIqJ2E+1NSJXUKQxc7qkz
         VgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fjDPfGjNC204PQtu2+64xYwVRdnbGQEEQskQTfu5T04=;
        b=e1Hl2heKmxDsAx9n1iG8O6Wxv0Rf/ghSKrigqD8dkWSiZtRBeorbXghiE4q50U/6NI
         xfBUmGeIc8jBCQ4uk0l26y3254Lq9HLrkd6N500pXJrYC4fn8ccqv1P4Ssi80m0MqqBe
         nfFaLEBgHDbeBz7vw5TlIRWOYef6N2wlB9cRzNL3guoq4pk9bEGpDTnnhtvvuYFsOzXd
         /8x/Ch4U8KxUtdus7IQ0DHicF3dLHINA7lWibBHqdt8DAZC9Y0kmA9Cv4jVikWWlQOpF
         n2FMd9/KVj0HNYenugve5q1efxRp6PfICt/y5YEVGT8X3cFVJYyPClCm+3v1FWS5Tchp
         FO6g==
X-Gm-Message-State: AOAM532ttXr0RnU5pN1bi9GtEq3Fr5HPqL8pZiyEYd5jBHKpGDoP4u3N
        Vki/rizM4Khi6EiSIP26SxJ42VwYbKS3dQ==
X-Google-Smtp-Source: ABdhPJwtehk5Fo+7nkr28NhgDns9FsdtnsaxgShGdv4+W7g6dZPauIIrtxN1dnehj4C2hErGqoVxww==
X-Received: by 2002:a63:784:: with SMTP id 126mr2102981pgh.428.1601950517404;
        Mon, 05 Oct 2020 19:15:17 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1301594pfc.96.2020.10.05.19.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 19:15:16 -0700 (PDT)
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
Subject: [PATCHv3 bpf 3/3] selftest/bpf: test pinning map with reused map fd
Date:   Tue,  6 Oct 2020 10:13:45 +0800
Message-Id: <20201006021345.3817033-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201006021345.3817033-1-liuhangbin@gmail.com>
References: <20201003085505.3388332-1-liuhangbin@gmail.com>
 <20201006021345.3817033-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This add a test to make sure that we can still pin maps with
reused map fd.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v3: use CHECK() for bpf_object__open_file() and close map fd on error
v2: no update
---
 .../selftests/bpf/prog_tests/pinning.c        | 49 ++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testing/selftests/bpf/prog_tests/pinning.c
index 041952524c55..fcf54b3a1dd0 100644
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
@@ -213,6 +213,53 @@ void test_pinning(void)
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
+	err = libbpf_get_error(obj);
+	if (CHECK(err, "default open", "err %d errno %d\n", err, errno)) {
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
+		goto close_map_fd;
+
+	err = bpf_map__reuse_fd(map, map_fd);
+	if (CHECK(err, "reuse pinmap fd", "err %d errno %d\n", err, errno))
+		goto close_map_fd;
+
+	err = bpf_map__set_pin_path(map, custpinpath);
+	if (CHECK(err, "set pin path", "err %d errno %d\n", err, errno))
+		goto close_map_fd;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "custom load", "err %d errno %d\n", err, errno))
+		goto close_map_fd;
+
+	/* check that pinmap was pinned at the custom path */
+	err = stat(custpinpath, &statbuf);
+	if (CHECK(err, "stat custpinpath", "err %d errno %d\n", err, errno))
+		goto close_map_fd;
+
+close_map_fd:
+	close(map_fd);
 out:
 	unlink(pinpath);
 	unlink(nopinpath);
-- 
2.25.4

