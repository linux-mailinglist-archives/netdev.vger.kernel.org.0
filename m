Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6005644776
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbiLFPGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiLFPGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:06:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0684432BBA
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 06:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670338788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HSdZJQSYji1CS/LRhNVKICa1dzFhmYVtK87Hjv0Ja0w=;
        b=h41oMgkIoIw+JYGhIC9ISUe7n5aB/IFI2LhhdRu9agc4A8S8Iy54JATI0RDK9pJIadHcHR
        2vwbniQgpUjFWT3Y7IL2IKY5K32shgVEE7EhyrBmJ60sFEULq33xoQrZhRaS4NZXOq7c6D
        5+yeVAtZw/KhgYz7EICIjhuMZvgzRHs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-R7RqIA-_P6q66p73UY98ng-1; Tue, 06 Dec 2022 09:59:45 -0500
X-MC-Unique: R7RqIA-_P6q66p73UY98ng-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74B2C3C0F42A;
        Tue,  6 Dec 2022 14:59:44 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C77AB4A9254;
        Tue,  6 Dec 2022 14:59:42 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v3 1/5] bpf: do not rely on ALLOW_ERROR_INJECTION for fmod_ret
Date:   Tue,  6 Dec 2022 15:59:32 +0100
Message-Id: <20221206145936.922196-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
References: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current way of expressing that a non-bpf kernel component is willing
to accept that bpf programs can be attached to it and that they can change
the return value is to abuse ALLOW_ERROR_INJECTION.
This is debated in the link below, and the result is that it is not a
reasonable thing to do.

Reuse the kfunc declaration structure to also tag the kernel functions
we want to be fmodret. This way we can control from any subsystem which
functions are being modified by bpf without touching the verifier.


Link: https://lore.kernel.org/all/20221121104403.1545f9b5@gandalf.local.home/
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- renamed btf_kern_func_is_modify_return() into btf_kfunc_is_modify_return()
- removed copy/paste in register_btf_fmodret_id_set()

changes in v2:
- compared to https://lore.kernel.org/all/c9912b24-f611-29b8-28e1-5e8be0d5ad41@redhat.com/
- make use of register_btf_kfunc_id_set() so we don't have to include
  hid-bpf.h in bpf core.
---
 include/linux/btf.h   |  2 ++
 kernel/bpf/btf.c      | 30 +++++++++++++++++++++++++-----
 kernel/bpf/verifier.c | 17 +++++++++++++++--
 net/bpf/test_run.c    | 14 +++++++++++---
 4 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index f9aababc5d78..6a0808e7845c 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -412,8 +412,10 @@ struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
 u32 *btf_kfunc_id_set_contains(const struct btf *btf,
 			       enum bpf_prog_type prog_type,
 			       u32 kfunc_btf_id);
+u32 *btf_kfunc_is_modify_return(const struct btf *btf, u32 kfunc_btf_id);
 int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 			      const struct btf_kfunc_id_set *s);
+int register_btf_fmodret_id_set(const struct btf_kfunc_id_set *kset);
 s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id);
 int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_cnt,
 				struct module *owner);
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 35c07afac924..c1df506293e4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -204,6 +204,7 @@ enum btf_kfunc_hook {
 	BTF_KFUNC_HOOK_STRUCT_OPS,
 	BTF_KFUNC_HOOK_TRACING,
 	BTF_KFUNC_HOOK_SYSCALL,
+	BTF_KFUNC_HOOK_FMODRET,
 	BTF_KFUNC_HOOK_MAX,
 };
 
@@ -7448,11 +7449,14 @@ u32 *btf_kfunc_id_set_contains(const struct btf *btf,
 	return __btf_kfunc_id_set_contains(btf, hook, kfunc_btf_id);
 }
 
-/* This function must be invoked only from initcalls/module init functions */
-int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
-			      const struct btf_kfunc_id_set *kset)
+u32 *btf_kfunc_is_modify_return(const struct btf *btf, u32 kfunc_btf_id)
+{
+	return __btf_kfunc_id_set_contains(btf, BTF_KFUNC_HOOK_FMODRET, kfunc_btf_id);
+}
+
+static int __register_btf_kfunc_id_set(enum btf_kfunc_hook hook,
+				       const struct btf_kfunc_id_set *kset)
 {
-	enum btf_kfunc_hook hook;
 	struct btf *btf;
 	int ret;
 
@@ -7471,13 +7475,29 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 	if (IS_ERR(btf))
 		return PTR_ERR(btf);
 
-	hook = bpf_prog_type_to_kfunc_hook(prog_type);
 	ret = btf_populate_kfunc_set(btf, hook, kset->set);
 	btf_put(btf);
 	return ret;
 }
+
+/* This function must be invoked only from initcalls/module init functions */
+int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
+			      const struct btf_kfunc_id_set *kset)
+{
+	enum btf_kfunc_hook hook;
+
+	hook = bpf_prog_type_to_kfunc_hook(prog_type);
+	return __register_btf_kfunc_id_set(hook, kset);
+}
 EXPORT_SYMBOL_GPL(register_btf_kfunc_id_set);
 
+/* This function must be invoked only from initcalls/module init functions */
+int register_btf_fmodret_id_set(const struct btf_kfunc_id_set *kset)
+{
+	return __register_btf_kfunc_id_set(BTF_KFUNC_HOOK_FMODRET, kset);
+}
+EXPORT_SYMBOL_GPL(register_btf_fmodret_id_set);
+
 s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id)
 {
 	struct btf_id_dtor_kfunc_tab *tab = btf->dtor_kfunc_tab;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 225666307bba..ec2e6ec7309e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15021,12 +15021,22 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 			ret = -EINVAL;
 			switch (prog->type) {
 			case BPF_PROG_TYPE_TRACING:
-				/* fentry/fexit/fmod_ret progs can be sleepable only if they are
+
+				/* fentry/fexit/fmod_ret progs can be sleepable if they are
 				 * attached to ALLOW_ERROR_INJECTION and are not in denylist.
 				 */
 				if (!check_non_sleepable_error_inject(btf_id) &&
 				    within_error_injection_list(addr))
 					ret = 0;
+				/* fentry/fexit/fmod_ret progs can also be sleepable if they are
+				 * in the fmodret id set with the KF_SLEEPABLE flag.
+				 */
+				else {
+					u32 *flags = btf_kfunc_is_modify_return(btf, btf_id);
+
+					if (flags && (*flags & KF_SLEEPABLE))
+						ret = 0;
+				}
 				break;
 			case BPF_PROG_TYPE_LSM:
 				/* LSM progs check that they are attached to bpf_lsm_*() funcs.
@@ -15047,7 +15057,10 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 				bpf_log(log, "can't modify return codes of BPF programs\n");
 				return -EINVAL;
 			}
-			ret = check_attach_modify_return(addr, tname);
+			ret = -EINVAL;
+			if (btf_kfunc_is_modify_return(btf, btf_id) ||
+			    !check_attach_modify_return(addr, tname))
+				ret = 0;
 			if (ret) {
 				bpf_log(log, "%s() is not modifiable\n", tname);
 				return ret;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 13d578ce2a09..5079fb089b5f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -489,7 +489,6 @@ int noinline bpf_fentry_test1(int a)
 	return a + 1;
 }
 EXPORT_SYMBOL_GPL(bpf_fentry_test1);
-ALLOW_ERROR_INJECTION(bpf_fentry_test1, ERRNO);
 
 int noinline bpf_fentry_test2(int a, u64 b)
 {
@@ -733,7 +732,15 @@ noinline void bpf_kfunc_call_test_destructive(void)
 
 __diag_pop();
 
-ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
+BTF_SET8_START(bpf_test_modify_return_ids)
+BTF_ID_FLAGS(func, bpf_modify_return_test)
+BTF_ID_FLAGS(func, bpf_fentry_test1, KF_SLEEPABLE)
+BTF_SET8_END(bpf_test_modify_return_ids)
+
+static const struct btf_kfunc_id_set bpf_test_modify_return_set = {
+	.owner = THIS_MODULE,
+	.set   = &bpf_test_modify_return_ids,
+};
 
 BTF_SET8_START(test_sk_check_kfunc_ids)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test1)
@@ -1668,7 +1675,8 @@ static int __init bpf_prog_test_run_init(void)
 	};
 	int ret;
 
-	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
+	ret = register_btf_fmodret_id_set(&bpf_test_modify_return_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_prog_test_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &bpf_prog_test_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_prog_test_kfunc_set);
 	return ret ?: register_btf_id_dtor_kfuncs(bpf_prog_test_dtor_kfunc,
-- 
2.38.1

