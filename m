Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B4C58D7AE
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 12:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242622AbiHIKx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 06:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237765AbiHIKx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 06:53:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 362985F63
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 03:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660042404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t3awSX3Tq4QpWeUfA1tbizxgPGHJw6AQeDWWE3eaTyI=;
        b=gxbeOaAx2fXwUt9wlBe+YypRB60huAA/sa4ja5WZQmUbZR6sdZ/OMPbtcDbwF4HdUyL3Za
        o+bkAjDWtqYd6cGQmEWS3LxVrhKdxzSd43FEDpLIAVefDWLle1CoZ3R3o/zQ5/4v+bdAdk
        eDSwcze7dl7cGJOAvclsU3kk9bdjk2M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-PjBZ2mGmOIS8ho1mtfhAmg-1; Tue, 09 Aug 2022 06:53:19 -0400
X-MC-Unique: PjBZ2mGmOIS8ho1mtfhAmg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F551811E87;
        Tue,  9 Aug 2022 10:53:19 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E7862492C3B;
        Tue,  9 Aug 2022 10:53:18 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 028C91C031E; Tue,  9 Aug 2022 12:53:18 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next v4 3/3] selftests/bpf: add destructive kfunc test
Date:   Tue,  9 Aug 2022 12:53:17 +0200
Message-Id: <20220809105317.436682-4-asavkov@redhat.com>
In-Reply-To: <20220809105317.436682-1-asavkov@redhat.com>
References: <20220809105317.436682-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test checking that programs calling destructive kfuncs can only do
so if they have CAP_SYS_BOOT capabilities.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 net/bpf/test_run.c                            |  5 +++
 .../selftests/bpf/prog_tests/kfunc_call.c     | 36 +++++++++++++++++++
 .../bpf/progs/kfunc_call_destructive.c        | 14 ++++++++
 3 files changed, 55 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_destructive.c

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index cbc9cd5058cb..afa7125252f6 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -695,6 +695,10 @@ noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p)
 {
 }
 
+noinline void bpf_kfunc_call_test_destructive(void)
+{
+}
+
 __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
@@ -719,6 +723,7 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail1)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail2)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_destructive, KF_DESTRUCTIVE)
 BTF_SET8_END(test_sk_check_kfunc_ids)
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index c00eb974eb85..351fafa006fb 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
@@ -5,6 +5,9 @@
 #include "kfunc_call_test.lskel.h"
 #include "kfunc_call_test_subprog.skel.h"
 #include "kfunc_call_test_subprog.lskel.h"
+#include "kfunc_call_destructive.skel.h"
+
+#include "cap_helpers.h"
 
 static void test_main(void)
 {
@@ -86,6 +89,36 @@ static void test_subprog_lskel(void)
 	kfunc_call_test_subprog_lskel__destroy(skel);
 }
 
+static int test_destructive_open_and_load(void)
+{
+	struct kfunc_call_destructive *skel;
+	int err;
+
+	skel = kfunc_call_destructive__open();
+	if (!ASSERT_OK_PTR(skel, "prog_open"))
+		return -1;
+
+	err = kfunc_call_destructive__load(skel);
+
+	kfunc_call_destructive__destroy(skel);
+
+	return err;
+}
+
+static void test_destructive(void)
+{
+	__u64 save_caps = 0;
+
+	ASSERT_OK(test_destructive_open_and_load(), "succesful_load");
+
+	if (!ASSERT_OK(cap_disable_effective(1ULL << CAP_SYS_BOOT, &save_caps), "drop_caps"))
+		return;
+
+	ASSERT_EQ(test_destructive_open_and_load(), -13, "no_caps_failure");
+
+	cap_enable_effective(save_caps, NULL);
+}
+
 void test_kfunc_call(void)
 {
 	if (test__start_subtest("main"))
@@ -96,4 +129,7 @@ void test_kfunc_call(void)
 
 	if (test__start_subtest("subprog_lskel"))
 		test_subprog_lskel();
+
+	if (test__start_subtest("destructive"))
+		test_destructive();
 }
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_destructive.c b/tools/testing/selftests/bpf/progs/kfunc_call_destructive.c
new file mode 100644
index 000000000000..767472bc5a97
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_destructive.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_kfunc_call_test_destructive(void) __ksym;
+
+SEC("tc")
+int kfunc_destructive_test(void)
+{
+	bpf_kfunc_call_test_destructive();
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.37.1

