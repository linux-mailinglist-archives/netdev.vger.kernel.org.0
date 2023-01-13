Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC54669B5A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjAMPFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjAMPE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:04:57 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E697B840B3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:56:30 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id u9so52958288ejo.0
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIDvWvTceP3dMNuGMTkeWoOyskDpFQfCLlKp/mFzwdo=;
        b=GzTy4J5xXqTXF4Jw+mLcdbqI2yMawGLiUvGCYBM1LyBD57VFTxVY7TDieiskByvqEd
         eXs3ubeSrFZE29KA+Emjgwr274+J0QFPMm/Js9kJSooQiGDTSZPRF8YtVGazcXcKMKt/
         usoXQ1DvgKt0blFGXo3k58LGoBe9SKR5MgjJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mIDvWvTceP3dMNuGMTkeWoOyskDpFQfCLlKp/mFzwdo=;
        b=aQhqt+SOa33b5kHyDYvNJWRJ4OKcC3oNRAr/e0nFZvr6wD4CQqpNiLFoxEfjlxX0Rc
         2XN5h6AC5Yq3OUKSI9qDComcBIOFEd+k+dopswhhaod8z0kMua/lk/SRlaL2FcqfgvLj
         OVtuqltxLgzO2L6vMav100AM2yeGu+/yxDI2GjtyJNFEMOoGMRj+K13KSNPYuEoGZ00T
         QuzmZwGfvzzTlDmFpfcPn5DxiD/4iCu8NCzUY39sJd6O4Oc4YLT/blDcoM+rIK3INf1p
         DUs1gYC4ts1AFQcTY7UYs3BLAZVfgB4+APkTpSUxPlGNub+4tgCg/6gBcV3E7Lb8ZWji
         LTtw==
X-Gm-Message-State: AFqh2koL+X5BZMrP/h7vI1G6hvDzgvWNPkyJvpQI/sq8PXHxkhhWioDL
        UE+k8W8RZwopJZMGDPBYly0LB3OFRREexXev
X-Google-Smtp-Source: AMrXdXsx3Bg3ETDgCUDmg2wWRk1RcdxV5L2gpmU5Z42R+vRNrSxtd24irNcFI4HpaSd3/k307RcUjQ==
X-Received: by 2002:a17:907:874c:b0:7fc:4242:f9ec with SMTP id qo12-20020a170907874c00b007fc4242f9ecmr69143299ejc.43.1673621789067;
        Fri, 13 Jan 2023 06:56:29 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id d9-20020a1709063ec900b007bd9e683639sm8564377ejj.130.2023.01.13.06.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 06:56:28 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH bpf 2/3] selftests/bpf: Pass BPF skeleton to sockmap_listen ops tests
Date:   Fri, 13 Jan 2023 15:56:22 +0100
Message-Id: <20230113-sockmap-fix-v1-2-d3cad092ee10@cloudflare.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113-sockmap-fix-v1-0-d3cad092ee10@cloudflare.com>
References: <20230113-sockmap-fix-v1-0-d3cad092ee10@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following patch extends the sockmap ops tests to cover the scenario when a
sockmap with attached programs holds listening sockets.

Pass the BPF skeleton to sockmap ops test so that the can access and attach
the BPF programs.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 55 +++++++++++++++-------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 2cf0c7a3fe23..499fba8f55b9 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -30,6 +30,8 @@
 #define MAX_STRERR_LEN 256
 #define MAX_TEST_NAME 80
 
+#define __always_unused	__attribute__((__unused__))
+
 #define _FAIL(errnum, fmt...)                                                  \
 	({                                                                     \
 		error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
@@ -321,7 +323,8 @@ static int socket_loopback(int family, int sotype)
 	return socket_loopback_reuseport(family, sotype, -1);
 }
 
-static void test_insert_invalid(int family, int sotype, int mapfd)
+static void test_insert_invalid(struct test_sockmap_listen *skel __always_unused,
+				int family, int sotype, int mapfd)
 {
 	u32 key = 0;
 	u64 value;
@@ -338,7 +341,8 @@ static void test_insert_invalid(int family, int sotype, int mapfd)
 		FAIL_ERRNO("map_update: expected EBADF");
 }
 
-static void test_insert_opened(int family, int sotype, int mapfd)
+static void test_insert_opened(struct test_sockmap_listen *skel __always_unused,
+			       int family, int sotype, int mapfd)
 {
 	u32 key = 0;
 	u64 value;
@@ -359,7 +363,8 @@ static void test_insert_opened(int family, int sotype, int mapfd)
 	xclose(s);
 }
 
-static void test_insert_bound(int family, int sotype, int mapfd)
+static void test_insert_bound(struct test_sockmap_listen *skel __always_unused,
+			      int family, int sotype, int mapfd)
 {
 	struct sockaddr_storage addr;
 	socklen_t len;
@@ -386,7 +391,8 @@ static void test_insert_bound(int family, int sotype, int mapfd)
 	xclose(s);
 }
 
-static void test_insert(int family, int sotype, int mapfd)
+static void test_insert(struct test_sockmap_listen *skel __always_unused,
+			int family, int sotype, int mapfd)
 {
 	u64 value;
 	u32 key;
@@ -402,7 +408,8 @@ static void test_insert(int family, int sotype, int mapfd)
 	xclose(s);
 }
 
-static void test_delete_after_insert(int family, int sotype, int mapfd)
+static void test_delete_after_insert(struct test_sockmap_listen *skel __always_unused,
+				     int family, int sotype, int mapfd)
 {
 	u64 value;
 	u32 key;
@@ -419,7 +426,8 @@ static void test_delete_after_insert(int family, int sotype, int mapfd)
 	xclose(s);
 }
 
-static void test_delete_after_close(int family, int sotype, int mapfd)
+static void test_delete_after_close(struct test_sockmap_listen *skel __always_unused,
+				    int family, int sotype, int mapfd)
 {
 	int err, s;
 	u64 value;
@@ -442,7 +450,8 @@ static void test_delete_after_close(int family, int sotype, int mapfd)
 		FAIL_ERRNO("map_delete: expected EINVAL/EINVAL");
 }
 
-static void test_lookup_after_insert(int family, int sotype, int mapfd)
+static void test_lookup_after_insert(struct test_sockmap_listen *skel __always_unused,
+				     int family, int sotype, int mapfd)
 {
 	u64 cookie, value;
 	socklen_t len;
@@ -470,7 +479,8 @@ static void test_lookup_after_insert(int family, int sotype, int mapfd)
 	xclose(s);
 }
 
-static void test_lookup_after_delete(int family, int sotype, int mapfd)
+static void test_lookup_after_delete(struct test_sockmap_listen *skel __always_unused,
+				     int family, int sotype, int mapfd)
 {
 	int err, s;
 	u64 value;
@@ -493,7 +503,8 @@ static void test_lookup_after_delete(int family, int sotype, int mapfd)
 	xclose(s);
 }
 
-static void test_lookup_32_bit_value(int family, int sotype, int mapfd)
+static void test_lookup_32_bit_value(struct test_sockmap_listen *skel __always_unused,
+				     int family, int sotype, int mapfd)
 {
 	u32 key, value32;
 	int err, s;
@@ -523,7 +534,8 @@ static void test_lookup_32_bit_value(int family, int sotype, int mapfd)
 	xclose(s);
 }
 
-static void test_update_existing(int family, int sotype, int mapfd)
+static void test_update_existing(struct test_sockmap_listen *skel __always_unused,
+				 int family, int sotype, int mapfd)
 {
 	int s1, s2;
 	u64 value;
@@ -551,7 +563,8 @@ static void test_update_existing(int family, int sotype, int mapfd)
 /* Exercise the code path where we destroy child sockets that never
  * got accept()'ed, aka orphans, when parent socket gets closed.
  */
-static void test_destroy_orphan_child(int family, int sotype, int mapfd)
+static void test_destroy_orphan_child(struct test_sockmap_listen *skel __always_unused,
+				      int family, int sotype, int mapfd)
 {
 	struct sockaddr_storage addr;
 	socklen_t len;
@@ -585,7 +598,8 @@ static void test_destroy_orphan_child(int family, int sotype, int mapfd)
 /* Perform a passive open after removing listening socket from SOCKMAP
  * to ensure that callbacks get restored properly.
  */
-static void test_clone_after_delete(int family, int sotype, int mapfd)
+static void test_clone_after_delete(struct test_sockmap_listen *skel __always_unused,
+				    int family, int sotype, int mapfd)
 {
 	struct sockaddr_storage addr;
 	socklen_t len;
@@ -621,7 +635,8 @@ static void test_clone_after_delete(int family, int sotype, int mapfd)
  * SOCKMAP, but got accept()'ed only after the parent has been removed
  * from SOCKMAP, gets cloned without parent psock state or callbacks.
  */
-static void test_accept_after_delete(int family, int sotype, int mapfd)
+static void test_accept_after_delete(struct test_sockmap_listen *skel __always_unused,
+				     int family, int sotype, int mapfd)
 {
 	struct sockaddr_storage addr;
 	const u32 zero = 0;
@@ -675,7 +690,8 @@ static void test_accept_after_delete(int family, int sotype, int mapfd)
 /* Check that child socket that got created and accepted while parent
  * was in a SOCKMAP is cloned without parent psock state or callbacks.
  */
-static void test_accept_before_delete(int family, int sotype, int mapfd)
+static void test_accept_before_delete(struct test_sockmap_listen *skel __always_unused,
+				      int family, int sotype, int mapfd)
 {
 	struct sockaddr_storage addr;
 	const u32 zero = 0, one = 1;
@@ -784,7 +800,8 @@ static void *connect_accept_thread(void *arg)
 	return NULL;
 }
 
-static void test_syn_recv_insert_delete(int family, int sotype, int mapfd)
+static void test_syn_recv_insert_delete(struct test_sockmap_listen *skel __always_unused,
+					int family, int sotype, int mapfd)
 {
 	struct connect_accept_ctx ctx = { 0 };
 	struct sockaddr_storage addr;
@@ -847,7 +864,8 @@ static void *listen_thread(void *arg)
 	return NULL;
 }
 
-static void test_race_insert_listen(int family, int socktype, int mapfd)
+static void test_race_insert_listen(struct test_sockmap_listen *skel __always_unused,
+				    int family, int socktype, int mapfd)
 {
 	struct connect_accept_ctx ctx = { 0 };
 	const u32 zero = 0;
@@ -1473,7 +1491,8 @@ static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
 		     int family, int sotype)
 {
 	const struct op_test {
-		void (*fn)(int family, int sotype, int mapfd);
+		void (*fn)(struct test_sockmap_listen *skel,
+			   int family, int sotype, int mapfd);
 		const char *name;
 		int sotype;
 	} tests[] = {
@@ -1520,7 +1539,7 @@ static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
 		if (!test__start_subtest(s))
 			continue;
 
-		t->fn(family, sotype, map_fd);
+		t->fn(skel, family, sotype, map_fd);
 		test_ops_cleanup(map);
 	}
 }

-- 
2.39.0
