Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD51744CAE4
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 21:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhKJU5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 15:57:46 -0500
Received: from mga05.intel.com ([192.55.52.43]:28558 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233045AbhKJU5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 15:57:45 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="318969274"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="318969274"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 12:54:25 -0800
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="452440497"
Received: from wson-mobl.amr.corp.intel.com (HELO vcostago-mobl3.intel.com) ([10.209.125.254])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 12:54:24 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     bpf@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        memxor@gmail.com, kafai@fb.com, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: [PATCH net v2] bpf: Fix build when CONFIG_BPF_SYSCALL is disabled
Date:   Wed, 10 Nov 2021 12:54:18 -0800
Message-Id: <20211110205418.332403-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_DEBUG_INFO_BTF is enabled and CONFIG_BPF_SYSCALL is
disabled, the following compilation error can be seen:

  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  AR      init/built-in.a
  LD      vmlinux.o
  MODPOST vmlinux.symvers
  MODINFO modules.builtin.modinfo
  GEN     modules.builtin
  LD      .tmp_vmlinux.btf
ld: net/ipv4/tcp_cubic.o: in function `cubictcp_unregister':
net/ipv4/tcp_cubic.c:545: undefined reference to `bpf_tcp_ca_kfunc_list'
ld: net/ipv4/tcp_cubic.c:545: undefined reference to `unregister_kfunc_btf_id_set'
ld: net/ipv4/tcp_cubic.o: in function `cubictcp_register':
net/ipv4/tcp_cubic.c:539: undefined reference to `bpf_tcp_ca_kfunc_list'
ld: net/ipv4/tcp_cubic.c:539: undefined reference to `register_kfunc_btf_id_set'
  BTF     .btf.vmlinux.bin.o
pahole: .tmp_vmlinux.btf: No such file or directory
  LD      .tmp_vmlinux.kallsyms1
.btf.vmlinux.bin.o: file not recognized: file format not recognized
make: *** [Makefile:1187: vmlinux] Error 1

'bpf_tcp_ca_kfunc_list', 'register_kfunc_btf_id_set()' and
'unregister_kfunc_btf_id_set()' are only defined when
CONFIG_BPF_SYSCALL is enabled.

Fix that by moving those definitions somewhere that doesn't depend on
the bpf() syscall.

Fixes: 14f267d95fe4 ("bpf: btf: Introduce helpers for dynamic BTF set registration")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 kernel/bpf/btf.c  | 33 ---------------------------------
 kernel/bpf/core.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index dbc3ad07e21b..cc9868376345 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6344,33 +6344,8 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 
 BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
 
-/* BTF ID set registration API for modules */
-
-struct kfunc_btf_id_list {
-	struct list_head list;
-	struct mutex mutex;
-};
-
 #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 
-void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
-			       struct kfunc_btf_id_set *s)
-{
-	mutex_lock(&l->mutex);
-	list_add(&s->list, &l->list);
-	mutex_unlock(&l->mutex);
-}
-EXPORT_SYMBOL_GPL(register_kfunc_btf_id_set);
-
-void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
-				 struct kfunc_btf_id_set *s)
-{
-	mutex_lock(&l->mutex);
-	list_del_init(&s->list);
-	mutex_unlock(&l->mutex);
-}
-EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
-
 bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 			      struct module *owner)
 {
@@ -6390,11 +6365,3 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 }
 
 #endif
-
-#define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
-	struct kfunc_btf_id_list name = { LIST_HEAD_INIT(name.list),           \
-					  __MUTEX_INITIALIZER(name.mutex) };   \
-	EXPORT_SYMBOL_GPL(name)
-
-DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
-DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2405e39d800f..f2939a6d8199 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2456,6 +2456,43 @@ int __weak bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 EXPORT_SYMBOL(bpf_stats_enabled_key);
 
+/* BTF ID set registration API for modules */
+
+struct kfunc_btf_id_list {
+	struct list_head list;
+	struct mutex mutex;
+};
+
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+
+void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+			       struct kfunc_btf_id_set *s)
+{
+	mutex_lock(&l->mutex);
+	list_add(&s->list, &l->list);
+	mutex_unlock(&l->mutex);
+}
+EXPORT_SYMBOL_GPL(register_kfunc_btf_id_set);
+
+void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+				 struct kfunc_btf_id_set *s)
+{
+	mutex_lock(&l->mutex);
+	list_del_init(&s->list);
+	mutex_unlock(&l->mutex);
+}
+EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
+
+#endif
+
+#define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
+	struct kfunc_btf_id_list name = { LIST_HEAD_INIT(name.list),           \
+					  __MUTEX_INITIALIZER(name.mutex) };   \
+	EXPORT_SYMBOL_GPL(name)
+
+DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
+DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);
+
 /* All definitions of tracepoints related to BPF. */
 #define CREATE_TRACE_POINTS
 #include <linux/bpf_trace.h>
-- 
2.32.0

