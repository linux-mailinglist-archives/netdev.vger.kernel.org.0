Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEC427AA4B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgI1JIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbgI1JIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:08:43 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB75C0613D0
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:08:42 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e11so3916822wme.0
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 02:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hgo0C+B4MaRA4y0HWxs83icuwRAx25Hc6vqvCgKEaCI=;
        b=qZ9Iq9Y7IeU4EBY/MUElVtiiiS0QAMvrZjex6udneQ8xKfu1nUGnGrxo36TYNqocel
         s7Xx75wFu9HoFkQ9qgxrQNZSYtsgpIHTD+4B7xlCTdzCKjlCF2pqOhvpVwwnvyKY1OMK
         HOvWmn1FcO8XEBNHoStCb7DNlo82+DQYMIdig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hgo0C+B4MaRA4y0HWxs83icuwRAx25Hc6vqvCgKEaCI=;
        b=CyRrG4PwG2zuzmvy2Fg5J10VWJ6E145slsGv229uL0oqnlsSH3o+lF6sJOXABSn/Qx
         yZvdbbbhj/N7/WJQKlH03KW0NgE/U5d4/Zh/1d97pSkimB49ZhCZnOgN+V3zEwn3PqXb
         zXQzoMS9op3pFumoqtODC68M1wM+RzDmxtO+Ul/ty8hhRDlJoAFkjZib2gAap3fPtN2k
         s/8yozm/ABZa+hqvFpDxdjNCNK1RRMDSuEAotXGlNGN2ZhiannSth0jvBYibDm3Qp+qr
         9pCFvouX4099fTYvDNi6HuDdFn4WUxrf4H45hVB5HV/9Bqp1iU3eaLQO13XIfnveiPkU
         66pA==
X-Gm-Message-State: AOAM530DiKtv/XF7BALYRm6ivsX1HLZB/XDRmoleS4/0pFBAAqsel+aV
        BbAzRm5i2l2A6s0Z63Br2NY+Cw==
X-Google-Smtp-Source: ABdhPJzbHz/H1+XuqgkxQKHOtkhghile3YOdp6R63ScPSEZ74n+SR0ma6flELvBAhdaOMv2J3eDG1Q==
X-Received: by 2002:a7b:cd93:: with SMTP id y19mr561874wmj.112.1601284121348;
        Mon, 28 Sep 2020 02:08:41 -0700 (PDT)
Received: from antares.lan (1.f.1.6.a.e.6.5.a.0.3.2.4.7.4.0.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:474:230a:56ea:61f1])
        by smtp.gmail.com with ESMTPSA id u13sm479631wrm.77.2020.09.28.02.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 02:08:40 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     kafai@fb.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 2/4] selftests: bpf: Add helper to compare socket cookies
Date:   Mon, 28 Sep 2020 10:08:03 +0100
Message-Id: <20200928090805.23343-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200928090805.23343-1-lmb@cloudflare.com>
References: <20200928090805.23343-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We compare socket cookies to ensure that insertion into a sockmap worked.
Pull this out into a helper function for use in other tests.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 50 +++++++++++++------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 4b7a527e7e82..67d3301bdf81 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -50,6 +50,37 @@ static int connected_socket_v4(void)
 	return -1;
 }
 
+static void compare_cookies(struct bpf_map *src, struct bpf_map *dst)
+{
+	__u32 i, max_entries = bpf_map__max_entries(src);
+	int err, duration, src_fd, dst_fd;
+
+	src_fd = bpf_map__fd(src);
+	dst_fd = bpf_map__fd(dst);
+
+	for (i = 0; i < max_entries; i++) {
+		__u64 src_cookie, dst_cookie;
+
+		err = bpf_map_lookup_elem(src_fd, &i, &src_cookie);
+		if (err && errno == ENOENT) {
+			err = bpf_map_lookup_elem(dst_fd, &i, &dst_cookie);
+			CHECK(!err, "map_lookup_elem(dst)", "element %u not deleted\n", i);
+			CHECK(err && errno != ENOENT, "map_lookup_elem(dst)", "%s\n",
+			      strerror(errno));
+			continue;
+		}
+		if (CHECK(err, "lookup_elem(src)", "%s\n", strerror(errno)))
+			continue;
+
+		err = bpf_map_lookup_elem(dst_fd, &i, &dst_cookie);
+		if (CHECK(err, "lookup_elem(dst)", "%s\n", strerror(errno)))
+			continue;
+
+		CHECK(dst_cookie != src_cookie, "cookie mismatch",
+		      "%llu != %llu (pos %u)\n", dst_cookie, src_cookie, i);
+	}
+}
+
 /* Create a map, populate it with one socket, and free the map. */
 static void test_sockmap_create_update_free(enum bpf_map_type map_type)
 {
@@ -109,9 +140,9 @@ static void test_skmsg_helpers(enum bpf_map_type map_type)
 static void test_sockmap_update(enum bpf_map_type map_type)
 {
 	struct bpf_prog_test_run_attr tattr;
-	int err, prog, src, dst, duration = 0;
+	int err, prog, src, duration = 0;
 	struct test_sockmap_update *skel;
-	__u64 src_cookie, dst_cookie;
+	struct bpf_map *dst_map;
 	const __u32 zero = 0;
 	char dummy[14] = {0};
 	__s64 sk;
@@ -127,18 +158,14 @@ static void test_sockmap_update(enum bpf_map_type map_type)
 	prog = bpf_program__fd(skel->progs.copy_sock_map);
 	src = bpf_map__fd(skel->maps.src);
 	if (map_type == BPF_MAP_TYPE_SOCKMAP)
-		dst = bpf_map__fd(skel->maps.dst_sock_map);
+		dst_map = skel->maps.dst_sock_map;
 	else
-		dst = bpf_map__fd(skel->maps.dst_sock_hash);
+		dst_map = skel->maps.dst_sock_hash;
 
 	err = bpf_map_update_elem(src, &zero, &sk, BPF_NOEXIST);
 	if (CHECK(err, "update_elem(src)", "errno=%u\n", errno))
 		goto out;
 
-	err = bpf_map_lookup_elem(src, &zero, &src_cookie);
-	if (CHECK(err, "lookup_elem(src, cookie)", "errno=%u\n", errno))
-		goto out;
-
 	tattr = (struct bpf_prog_test_run_attr){
 		.prog_fd = prog,
 		.repeat = 1,
@@ -151,12 +178,7 @@ static void test_sockmap_update(enum bpf_map_type map_type)
 		       "errno=%u retval=%u\n", errno, tattr.retval))
 		goto out;
 
-	err = bpf_map_lookup_elem(dst, &zero, &dst_cookie);
-	if (CHECK(err, "lookup_elem(dst, cookie)", "errno=%u\n", errno))
-		goto out;
-
-	CHECK(dst_cookie != src_cookie, "cookie mismatch", "%llu != %llu\n",
-	      dst_cookie, src_cookie);
+	compare_cookies(skel->maps.src, dst_map);
 
 out:
 	test_sockmap_update__destroy(skel);
-- 
2.25.1

