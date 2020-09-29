Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047CF27C13F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgI2JbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbgI2JbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:31:12 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A6EC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 02:31:12 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id s13so3888915wmh.4
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 02:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ipO6cYn3oTR0lLp1urYn9/jXtIVYmKn65Qxey0c5488=;
        b=jgtFHMzoyUxQpRQZaPshOH93q8Q8eMtG2OrRjEv1Pfm3kwZ5vlbe6+MdR0eoqo3SjL
         c2yFd5dybcefEe3zs72beZwH+zqi6hexFBdprfJ0FAMpLFXXoNRC9+GwK/KHdO1q3BAZ
         J5zrbySNkZnTRNRRpROT9brxfLLi2TrNnNvkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ipO6cYn3oTR0lLp1urYn9/jXtIVYmKn65Qxey0c5488=;
        b=N/bC2RZYUJw86N9Qy9m6TTRrFyqscqCXONi/oawunP+nnLuigPuFOchyod0hE4og9N
         VJwx2XGhEghabkYfCEdp9qTEVC0D/zDPiSEiW0wV47e0c8fhpk8FC6Lz1dpn7UBCXw8q
         spwsItXxh7nBGdrvxhU0tnYBWFNbrKwbwWjLkcHekTwI0l18rFpGED1/7YufJKiHFm9A
         pwOyRCZgNvc4gW9V99Ani8h1oZRCIHrLeLqj99GqgZ0mjinV7/PlKACnGSfxXXhlBaXG
         iwc9Tw1NEzGKec2yTm5tfEEPFFEF2Gyx0VRR4aby6Av9u8/GNDjrgkZmZOtHZDLj6KVr
         F81A==
X-Gm-Message-State: AOAM532GeSg1nCqLA1iL2owCED9eloTPH1i+tuj+uuairtDLQq4hM6Ai
        qIkbeEofkZodgiCmKUeBQJ1H8Q==
X-Google-Smtp-Source: ABdhPJz3quVaJqtTN6k6oaNrANrlBKhTM/2+kZT9ShFZ8pgdYG6oDvK8qn3Om25aCsnQlV2mRM36qw==
X-Received: by 2002:a05:600c:2283:: with SMTP id 3mr3391777wmf.37.1601371871268;
        Tue, 29 Sep 2020 02:31:11 -0700 (PDT)
Received: from antares.lan (1.f.1.6.a.e.6.5.a.0.3.2.4.7.4.0.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:474:230a:56ea:61f1])
        by smtp.gmail.com with ESMTPSA id i16sm5246798wrq.73.2020.09.29.02.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 02:31:10 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     kafai@fb.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 3/4] selftests: bpf: remove shared header from sockmap iter test
Date:   Tue, 29 Sep 2020 10:30:38 +0100
Message-Id: <20200929093039.73872-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929093039.73872-1-lmb@cloudflare.com>
References: <20200929093039.73872-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The shared header to define SOCKMAP_MAX_ENTRIES is a bit overkill.
Dynamically allocate the sock_fd array based on bpf_map__max_entries
instead.

Suggested-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 36 +++++++++----------
 .../selftests/bpf/progs/bpf_iter_sockmap.c    |  5 ++-
 .../selftests/bpf/progs/bpf_iter_sockmap.h    |  3 --
 3 files changed, 20 insertions(+), 24 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_sockmap.h

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 3596d3f3039f..316c4e271b36 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -8,8 +8,6 @@
 #include "test_sockmap_invalid_update.skel.h"
 #include "bpf_iter_sockmap.skel.h"
 
-#include "progs/bpf_iter_sockmap.h"
-
 #define TCP_REPAIR		19	/* TCP sock is under repair right now */
 
 #define TCP_REPAIR_ON		1
@@ -201,9 +199,9 @@ static void test_sockmap_iter(enum bpf_map_type map_type)
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
 	int err, len, src_fd, iter_fd, duration = 0;
 	union bpf_iter_link_info linfo = {0};
-	__s64 sock_fd[SOCKMAP_MAX_ENTRIES];
-	__u32 i, num_sockets, max_elems;
+	__u32 i, num_sockets, num_elems;
 	struct bpf_iter_sockmap *skel;
+	__s64 *sock_fd = NULL;
 	struct bpf_link *link;
 	struct bpf_map *src;
 	char buf[64];
@@ -212,22 +210,23 @@ static void test_sockmap_iter(enum bpf_map_type map_type)
 	if (CHECK(!skel, "bpf_iter_sockmap__open_and_load", "skeleton open_and_load failed\n"))
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(sock_fd); i++)
-		sock_fd[i] = -1;
-
-	/* Make sure we have at least one "empty" entry to test iteration of
-	 * an empty slot.
-	 */
-	num_sockets = ARRAY_SIZE(sock_fd) - 1;
-
 	if (map_type == BPF_MAP_TYPE_SOCKMAP) {
 		src = skel->maps.sockmap;
-		max_elems = bpf_map__max_entries(src);
+		num_elems = bpf_map__max_entries(src);
+		num_sockets = num_elems - 1;
 	} else {
 		src = skel->maps.sockhash;
-		max_elems = num_sockets;
+		num_elems = bpf_map__max_entries(src) - 1;
+		num_sockets = num_elems;
 	}
 
+	sock_fd = calloc(num_sockets, sizeof(*sock_fd));
+	if (CHECK(!sock_fd, "calloc(sock_fd)", "failed to allocate\n"))
+		goto out;
+
+	for (i = 0; i < num_sockets; i++)
+		sock_fd[i] = -1;
+
 	src_fd = bpf_map__fd(src);
 
 	for (i = 0; i < num_sockets; i++) {
@@ -258,8 +257,8 @@ static void test_sockmap_iter(enum bpf_map_type map_type)
 		goto close_iter;
 
 	/* test results */
-	if (CHECK(skel->bss->elems != max_elems, "elems", "got %u expected %u\n",
-		  skel->bss->elems, max_elems))
+	if (CHECK(skel->bss->elems != num_elems, "elems", "got %u expected %u\n",
+		  skel->bss->elems, num_elems))
 		goto close_iter;
 
 	if (CHECK(skel->bss->socks != num_sockets, "socks", "got %u expected %u\n",
@@ -271,10 +270,11 @@ static void test_sockmap_iter(enum bpf_map_type map_type)
 free_link:
 	bpf_link__destroy(link);
 out:
-	for (i = 0; i < num_sockets; i++) {
+	for (i = 0; sock_fd && i < num_sockets; i++)
 		if (sock_fd[i] >= 0)
 			close(sock_fd[i]);
-	}
+	if (sock_fd)
+		free(sock_fd);
 	bpf_iter_sockmap__destroy(skel);
 }
 
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c b/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c
index 0e27f73dd803..1af7555f6057 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c
@@ -2,7 +2,6 @@
 /* Copyright (c) 2020 Cloudflare */
 #include "bpf_iter.h"
 #include "bpf_tracing_net.h"
-#include "bpf_iter_sockmap.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <errno.h>
@@ -11,14 +10,14 @@ char _license[] SEC("license") = "GPL";
 
 struct {
 	__uint(type, BPF_MAP_TYPE_SOCKMAP);
-	__uint(max_entries, SOCKMAP_MAX_ENTRIES);
+	__uint(max_entries, 64);
 	__type(key, __u32);
 	__type(value, __u64);
 } sockmap SEC(".maps");
 
 struct {
 	__uint(type, BPF_MAP_TYPE_SOCKHASH);
-	__uint(max_entries, SOCKMAP_MAX_ENTRIES);
+	__uint(max_entries, 64);
 	__type(key, __u32);
 	__type(value, __u64);
 } sockhash SEC(".maps");
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.h b/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.h
deleted file mode 100644
index 35a675d13c0f..000000000000
--- a/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.h
+++ /dev/null
@@ -1,3 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-#define SOCKMAP_MAX_ENTRIES (64)
-- 
2.25.1

