Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE8563BA4D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiK2HJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiK2HJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:09:32 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF4E55AB0;
        Mon, 28 Nov 2022 23:09:24 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669705762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nfQe8leo1x+sS0p7Ddc9oQNJBqu3FJUxK4SNyCHsigg=;
        b=FE8RaqluIqsuhwKUmPEw9q1VqNnJAthLy799He7Oh5BBdHdbOXxPMM/LdG1dmKWN6rmA0U
        CYYKSFpI5zVqSfrGeQpAUxaynsZyK+dC7vS7/H/BGdaEiTEKTce7rCDd6H+J5fv1Z20nVL
        ERqILQ4zY1sB8yESjCUFAZBm/ArrBbY=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 7/7] selftests/bpf: Avoid pinning prog when attaching to tc ingress in btf_skc_cls_ingress
Date:   Mon, 28 Nov 2022 23:09:00 -0800
Message-Id: <20221129070900.3142427-8-martin.lau@linux.dev>
In-Reply-To: <20221129070900.3142427-1-martin.lau@linux.dev>
References: <20221129070900.3142427-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

This patch removes the need to pin prog when attaching to tc ingress
in the btf_skc_cls_ingress test.  Instead, directly use the
bpf_tc_hook_create() and bpf_tc_attach().  The qdisc clsact
will go away together with the netns, so no need to
bpf_tc_hook_destroy().

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 .../bpf/prog_tests/btf_skc_cls_ingress.c      | 25 ++++++++-----------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
index 7a277035c275..ef4d6a3ae423 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <errno.h>
 #include <sched.h>
+#include <net/if.h>
 #include <linux/compiler.h>
 #include <bpf/libbpf.h>
 
@@ -20,10 +21,12 @@ static struct test_btf_skc_cls_ingress *skel;
 static struct sockaddr_in6 srv_sa6;
 static __u32 duration;
 
-#define PROG_PIN_FILE "/sys/fs/bpf/btf_skc_cls_ingress"
-
 static int prepare_netns(void)
 {
+	LIBBPF_OPTS(bpf_tc_hook, qdisc_lo, .attach_point = BPF_TC_INGRESS);
+	LIBBPF_OPTS(bpf_tc_opts, tc_attach,
+		    .prog_fd = bpf_program__fd(skel->progs.cls_ingress));
+
 	if (CHECK(unshare(CLONE_NEWNET), "create netns",
 		  "unshare(CLONE_NEWNET): %s (%d)",
 		  strerror(errno), errno))
@@ -33,12 +36,12 @@ static int prepare_netns(void)
 		  "ip link set dev lo up", "failed\n"))
 		return -1;
 
-	if (CHECK(system("tc qdisc add dev lo clsact"),
-		  "tc qdisc add dev lo clsact", "failed\n"))
+	qdisc_lo.ifindex = if_nametoindex("lo");
+	if (!ASSERT_OK(bpf_tc_hook_create(&qdisc_lo), "qdisc add dev lo clsact"))
 		return -1;
 
-	if (CHECK(system("tc filter add dev lo ingress bpf direct-action object-pinned " PROG_PIN_FILE),
-		  "install tc cls-prog at ingress", "failed\n"))
+	if (!ASSERT_OK(bpf_tc_attach(&qdisc_lo, &tc_attach),
+		       "filter add dev lo ingress"))
 		return -1;
 
 	/* Ensure 20 bytes options (i.e. in total 40 bytes tcp header) for the
@@ -195,19 +198,12 @@ static struct test tests[] = {
 
 void test_btf_skc_cls_ingress(void)
 {
-	int i, err;
+	int i;
 
 	skel = test_btf_skc_cls_ingress__open_and_load();
 	if (CHECK(!skel, "test_btf_skc_cls_ingress__open_and_load", "failed\n"))
 		return;
 
-	err = bpf_program__pin(skel->progs.cls_ingress, PROG_PIN_FILE);
-	if (CHECK(err, "bpf_program__pin",
-		  "cannot pin bpf prog to %s. err:%d\n", PROG_PIN_FILE, err)) {
-		test_btf_skc_cls_ingress__destroy(skel);
-		return;
-	}
-
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		if (!test__start_subtest(tests[i].desc))
 			continue;
@@ -221,6 +217,5 @@ void test_btf_skc_cls_ingress(void)
 		reset_test();
 	}
 
-	bpf_program__unpin(skel->progs.cls_ingress, PROG_PIN_FILE);
 	test_btf_skc_cls_ingress__destroy(skel);
 }
-- 
2.30.2

