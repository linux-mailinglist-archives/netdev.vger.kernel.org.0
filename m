Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB1E42B93A
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbhJMHgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbhJMHgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:36:16 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726D9C061570;
        Wed, 13 Oct 2021 00:34:13 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x8so1208675plv.8;
        Wed, 13 Oct 2021 00:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EMo7pDATAES3BNatEM2URhLDnK6LT9ubeVWANphHkdE=;
        b=Et4nFcNe6yuPZWjECSxOEK6ZysM4fc5y+RXgc3umqjbWH1cGEbmifTFS76SXL5ZY/H
         usb9hdR2EoD31qtGWWP/dBQOvTejcf0R38eY8knylDTfQpSTSBpPC6dzV7Z7q/VXpuQw
         az9yAOZyqaV6P1pVd93mVQdTunK2cEFwa9AKJcDUqDz3g0eSmbpNcAAtIheK6ZM9FKZ8
         1nDrbePQGZTB6+sv5/cTjNqwH5SVsy249tvWRqoXq1nZKkeUpyuoKtUoeNrMPW/FJnbT
         qIPnN39KszMJmzq+ai9phvQ+mwZXE5X883QPX9lrOoU6OoriZfMIxIQzy/VBXoLlxxWx
         XObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EMo7pDATAES3BNatEM2URhLDnK6LT9ubeVWANphHkdE=;
        b=2m+2erBG+ieVmyB+TxSPrOmvezx0nptNLSeI2nyWJh/tGm4Vks3YHONFbe80MIPRHH
         HgMwjfcnyEKr8Aw/SpjvcGDv5NlY0EkEUqGFwRYud50kd+6mWM1acX+NBGJci/Y4xZno
         NPeCe/VeYMsqiFx98sQYrleei1GNxrd29WnKZuF4zLZStlaJWzf7Y9HJK5VSftCM/4nn
         5tJ8XQcrzagm7dwsj5snx/K73IhqWt6Hwu1zkJ8rXWZdZeuuDEVmqs5KGF69hp7sW0gC
         dlBLSAWIPRSi51IXxi0ADYH+uCx9kIgvzC5m0mDzqlc3/+g5nixkB57LR8/MOdBv5tWF
         sOqg==
X-Gm-Message-State: AOAM531LGVNgZh90TR5iInTNNtKKFWIYl2X94vPXCmxKQVi9SpnI2f2E
        Xb5vWtkVbULm3y14ZNSpvOFOligfwn0=
X-Google-Smtp-Source: ABdhPJwQpmU6baUYDlYBv03ikne7OS6zO+vQBG2kA9RdlJ1ZbPghkipkzhyZWMwZme1xOqzkdL7H2w==
X-Received: by 2002:a17:90b:1b49:: with SMTP id nv9mr11406298pjb.134.1634110452859;
        Wed, 13 Oct 2021 00:34:12 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id f84sm13146786pfa.25.2021.10.13.00.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:34:12 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 7/8] selftests/bpf: Fix fd cleanup in sk_lookup test
Date:   Wed, 13 Oct 2021 13:03:47 +0530
Message-Id: <20211013073348.1611155-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013073348.1611155-1-memxor@gmail.com>
References: <20211013073348.1611155-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2422; h=from:subject; bh=Bu5So/JXoqVM207wD93/7Gz5WB5cEBI0sQdmm7wPOVA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhZovSyMjwhQv7b9eg1M18dkgR/77Xq1LbV+rDtagO 1PBywBmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWaL0gAKCRBM4MiGSL8RymzkD/ 9el5NuuxjnplwYXKqhb9zbl17zUN2Zerk2rjI0B5Wymm3wW7pNvDQ0qNPHsa9nu5WITxYb53xzKf2Z BlkjLHpfCoWWiT8X6vx6ObEWzlpUAbJvZFHhRivDKtpOTEw09/WQ3GJBZNP8NYiHqbQt/LviICuqrj 8hy1bmTfM56CQ1QR1cCjna4yEeqD69qmsfJAXI5svYx+8u2XVyi+UmsznuddGbvECXf/nETbmuygql 9ktxbOuhVOevqHw0DPQYqTpo591Q80SJeIB6JsU+hez3QHGH1VrVB9RGpVWpbMxykh10wxUhLfmcXz x3hGjMI1RK8HiJOLXf3wvOvkstI7ZUTKcvm3X9bFo69xGqllApRFLMgUYN3lpj2MrJES3WYEwgW1+v 2BxvwigSIiiz3vFAC8ATSuSZtixogYQH1fTckPtUoFgZ4X+ceE6fm/GhkRjuV8j3y0RHuqZ021Sokj s47ybdFxkStWgAuHRpLOhPFaX5CAuKDz0KjxnwBlE1vrl9ejGAErkKsN5Jazinq3JUA35HHUZtpL8N AX+4LgGNvcY8jRC5Djq7yUHMZYZavcVo1TGsy5TawEbcUiSMoXSw43MeDLugyLR20wprnMmWk1ifkY Ki+o0Wiy4vO0m4Tr6yPfvAeIqp6xEuaK2vl9osurbdNUL29IougJcYrUNV6A==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the fix in commit:
e31eec77e4ab ("bpf: selftests: Fix fd cleanup in get_branch_snapshot")

We use designated initializer to set fds to -1 without breaking on
future changes to MAX_SERVER constant denoting the array size.

The particular close(0) occurs on non-reuseport tests, so it can be seen
with -n 115/{2,3} but not 115/4. This can cause problems with future
tests if they depend on BTF fd never being acquired as fd 0, breaking
internal libbpf assumptions.

Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index aee41547e7f4..cbee46d2d525 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -598,7 +598,7 @@ static void query_lookup_prog(struct test_sk_lookup *skel)
 
 static void run_lookup_prog(const struct test *t)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };
 	int client_fd, reuse_conn_fd = -1;
 	struct bpf_link *lookup_link;
 	int i, err;
@@ -663,8 +663,9 @@ static void run_lookup_prog(const struct test *t)
 	if (reuse_conn_fd != -1)
 		close(reuse_conn_fd);
 	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
-		if (server_fds[i] != -1)
-			close(server_fds[i]);
+		if (server_fds[i] == -1)
+			break;
+		close(server_fds[i]);
 	}
 	bpf_link__destroy(lookup_link);
 }
@@ -1053,7 +1054,7 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 			  struct bpf_program *lookup_prog,
 			  const char *remote_ip, const char *local_ip)
 {
-	int server_fds[MAX_SERVERS] = { -1 };
+	int server_fds[] = { [0 ... MAX_SERVERS - 1] = -1 };
 	struct bpf_sk_lookup ctx;
 	__u64 server_cookie;
 	int i, err;
@@ -1097,8 +1098,9 @@ static void run_sk_assign(struct test_sk_lookup *skel,
 
 close_servers:
 	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
-		if (server_fds[i] != -1)
-			close(server_fds[i]);
+		if (server_fds[i] == -1)
+			break;
+		close(server_fds[i]);
 	}
 }
 
-- 
2.33.0

