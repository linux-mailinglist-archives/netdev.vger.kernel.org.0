Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD9867663B
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 13:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjAUMmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 07:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjAUMmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 07:42:14 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFE230E8E
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 04:42:11 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id mg12so20192418ejc.5
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 04:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mIDvWvTceP3dMNuGMTkeWoOyskDpFQfCLlKp/mFzwdo=;
        b=NuzH8oSY+CwojhHaqnV8ct3qLg/UNiYgTEt9yZHSoTFSoEn4gh+/JcH7dTaVX0p8SE
         A7hSadvSTTKhnzzrVyt0LLINldGqp3iMLtPS1APfFZefFKm79zgcLK88iWDKoVek8uuC
         DU1s8VB9OKBUTSyji/j2QE1MFOq2nPQM+yXhQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mIDvWvTceP3dMNuGMTkeWoOyskDpFQfCLlKp/mFzwdo=;
        b=J21LNzaPhjXM5YLvq8b+rcrxyhz5ikxau+JgQfSWhv901/5y0Evd5AIMp8ZzO0Zp3r
         ZgFtVAydL9eJDaz8nIyi7o/2GZXD+2RQkgXZPzpDl10+grz1mi7N1WbuQLo3n3mAjOdn
         nZ0DbPGP3h5wS9c5E6oyjHIGhxdmrFsUFpgr9zi/xAkq7aAG1p7MhxtSd7Y3FT4O9E+a
         c2DyZzfZknKkGvPihiqrzY/1CxdLztJq+5bQ69lX4x13JS8UjRo5wc7dekqCJwiyJaii
         b0UKNtp+nwooKjO7Hql8osYlTzVHVTzAMZyWx04pNf+M84LphA70FuHvrSk95YitMuJK
         OV6A==
X-Gm-Message-State: AFqh2kq0FsS4rtvxXe+hkULA6Bt8W+b+T6BlgNB+CQUWrMlbnITocrlw
        /Mv2Wy6cXmBXgoCCpTIZorQ3GHfFJ2V3EFOr
X-Google-Smtp-Source: AMrXdXtFbT8pecR99fgmUQHrx5jAf+ki752XYVqKMOX1frknMJNuyLQcamUAwr41omvSD8U2vydHxw==
X-Received: by 2002:a17:906:368f:b0:877:593a:58d0 with SMTP id a15-20020a170906368f00b00877593a58d0mr14145005ejc.29.1674304930139;
        Sat, 21 Jan 2023 04:42:10 -0800 (PST)
Received: from cloudflare.com (79.191.179.97.ipv4.supernova.orange.pl. [79.191.179.97])
        by smtp.gmail.com with ESMTPSA id kz22-20020a17090777d600b007c1633cea13sm19651109ejc.12.2023.01.21.04.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 04:42:09 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Sat, 21 Jan 2023 13:41:45 +0100
Subject: [PATCH bpf v2 3/4] selftests/bpf: Pass BPF skeleton to
 sockmap_listen ops tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230113-sockmap-fix-v2-3-1e0ee7ac2f90@cloudflare.com>
References: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
In-Reply-To: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
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

