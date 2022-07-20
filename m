Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6154857B5D2
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240639AbiGTLrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiGTLrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37A3472EC9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658317619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lA7Q8pZdMZk71xzbbtvh8iXkLjx/zYBnA6KK+qZ4XXo=;
        b=N/S7D28t3HQdcFFkKJFZ2vs/8ar+20LIsDfOsskFV6ghiq9wRp1U+ZJRRZ/n1Pw5STycDx
        5/BEd7RCybQDYpyCsrWoRrPQkHSO0Zm53s41tno0/HHRU7MzY8D/VsXMsfJVxgQbwqSbMw
        RSA5CckgES3Yipwe8W5ecLVaASyQqk0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-JHw3_Jd-MXiaA_9JcFo3vA-1; Wed, 20 Jul 2022 07:46:56 -0400
X-MC-Unique: JHw3_Jd-MXiaA_9JcFo3vA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 682B585A581;
        Wed, 20 Jul 2022 11:46:55 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF9CE2026D64;
        Wed, 20 Jul 2022 11:46:54 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 079301C0323; Wed, 20 Jul 2022 13:46:54 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next 3/4] selftests/bpf: add destructive kfunc tests
Date:   Wed, 20 Jul 2022 13:46:51 +0200
Message-Id: <20220720114652.3020467-4-asavkov@redhat.com>
In-Reply-To: <20220720114652.3020467-1-asavkov@redhat.com>
References: <20220720114652.3020467-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests checking that programs calling destructive kfuncs can only do
so if they have BPF_F_DESTRUCTIVE flag set and CAP_SYS_BOOT
capabilities.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 net/bpf/test_run.c                            | 12 +++++-
 .../selftests/bpf/prog_tests/kfunc_call.c     | 41 +++++++++++++++++++
 .../bpf/progs/kfunc_call_destructive.c        | 14 +++++++
 3 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_destructive.c

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2ca96acbc50a0..dc267fa308f92 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -691,6 +691,10 @@ noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
 {
 }
 
+noinline void bpf_kfunc_call_test_destructive(void)
+{
+}
+
 __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
@@ -714,6 +718,7 @@ BTF_ID(func, bpf_kfunc_call_test_fail3)
 BTF_ID(func, bpf_kfunc_call_test_mem_len_pass1)
 BTF_ID(func, bpf_kfunc_call_test_mem_len_fail1)
 BTF_ID(func, bpf_kfunc_call_test_mem_len_fail2)
+BTF_ID(func, bpf_kfunc_call_test_destructive)
 BTF_SET_END(test_sk_check_kfunc_ids)
 
 BTF_SET_START(test_sk_acquire_kfunc_ids)
@@ -738,6 +743,10 @@ BTF_SET_START(test_sk_kptr_acquire_kfunc_ids)
 BTF_ID(func, bpf_kfunc_call_test_kptr_get)
 BTF_SET_END(test_sk_kptr_acquire_kfunc_ids)
 
+BTF_SET_START(test_sk_destructive_kfunc_ids)
+BTF_ID(func, bpf_kfunc_call_test_destructive)
+BTF_SET_END(test_sk_destructive_kfunc_ids)
+
 static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
 			   u32 size, u32 headroom, u32 tailroom)
 {
@@ -1622,7 +1631,8 @@ static const struct btf_kfunc_id_set bpf_prog_test_kfunc_set = {
 	.acquire_set      = &test_sk_acquire_kfunc_ids,
 	.release_set      = &test_sk_release_kfunc_ids,
 	.ret_null_set     = &test_sk_ret_null_kfunc_ids,
-	.kptr_acquire_set = &test_sk_kptr_acquire_kfunc_ids
+	.kptr_acquire_set = &test_sk_kptr_acquire_kfunc_ids,
+	.destructive_set  = &test_sk_destructive_kfunc_ids,
 };
 
 BTF_ID_LIST(bpf_prog_test_dtor_kfunc_ids)
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_call.c b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
index c00eb974eb85e..1c2c4fdfba88b 100644
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
@@ -86,6 +89,41 @@ static void test_subprog_lskel(void)
 	kfunc_call_test_subprog_lskel__destroy(skel);
 }
 
+static int test_destructive_open_and_load(int set_flag)
+{
+	struct kfunc_call_destructive *skel;
+	int err;
+
+	skel = kfunc_call_destructive__open();
+	if (!ASSERT_OK_PTR(skel, "prog_open"))
+		return -1;
+
+	if (set_flag)
+		bpf_program__set_flags(skel->progs.kfunc_destructive_test,
+				bpf_program__flags(skel->progs.kfunc_destructive_test) | BPF_F_DESTRUCTIVE);
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
+	ASSERT_EQ(test_destructive_open_and_load(0), -13, "no_flag_failure");
+	ASSERT_OK(test_destructive_open_and_load(1), "succesful_load");
+
+	if (!ASSERT_OK(cap_disable_effective(1ULL << CAP_SYS_BOOT, &save_caps), "drop_caps"))
+		return;
+
+	ASSERT_EQ(test_destructive_open_and_load(1), -13, "no_caps_failure");
+
+	cap_enable_effective(save_caps, NULL);
+}
+
 void test_kfunc_call(void)
 {
 	if (test__start_subtest("main"))
@@ -96,4 +134,7 @@ void test_kfunc_call(void)
 
 	if (test__start_subtest("subprog_lskel"))
 		test_subprog_lskel();
+
+	if (test__start_subtest("destructive"))
+		test_destructive();
 }
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_destructive.c b/tools/testing/selftests/bpf/progs/kfunc_call_destructive.c
new file mode 100644
index 0000000000000..767472bc5a97b
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
2.35.3

