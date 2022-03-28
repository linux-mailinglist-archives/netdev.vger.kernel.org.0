Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE73A4E9DF1
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244921AbiC1R4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244923AbiC1R4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:56:20 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B44F24582;
        Mon, 28 Mar 2022 10:53:49 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0cP5LvYz67Q7R;
        Tue, 29 Mar 2022 01:51:17 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:53:46 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <corbet@lwn.net>, <viro@zeniv.linux.org.uk>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <shuah@kernel.org>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@foss.st.com>, <zohar@linux.ibm.com>
CC:     <linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 14/18] bpf-preload: Switch to new preload registration method
Date:   Mon, 28 Mar 2022 19:50:29 +0200
Message-ID: <20220328175033.2437312-15-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220328175033.2437312-1-roberto.sassu@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the automatic generator of the light skeleton by adding three calls
to bpf_preload_set_ops() for registering and unregistering a preload
method, two in load_skel() (set and unset if there is an error) and one in
free_objs_and_skel().

Regenerate the light skeleton of the already preloaded eBPF program
iterators_bpf, which will now use the new registration method, and directly
call load_skel() and free_objs_and_skel() in the init and fini module
entrypoints.

Finally, allow users to specify a customized list of eBPF programs to
preload with the CONFIG_BPF_PRELOAD_LIST option in the kernel
configuration, at build time, or with new kernel option bpf_preload_list=,
at run-time.

By default, set CONFIG_BPF_PRELOAD_LIST to 'bpf_preload', so that the
current preloading behavior is kept unchanged.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../admin-guide/kernel-parameters.txt         |  8 ++++++
 kernel/bpf/inode.c                            | 16 ++++++++++--
 kernel/bpf/preload/Kconfig                    | 25 +++++++++++++------
 kernel/bpf/preload/bpf_preload_kern.c         | 20 ++-------------
 .../bpf/preload/iterators/iterators.lskel.h   |  9 +++++--
 tools/bpf/bpftool/gen.c                       | 15 ++++++++---
 6 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9927564db88e..732d83764e6e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -482,6 +482,14 @@
 	bgrt_disable	[ACPI][X86]
 			Disable BGRT to avoid flickering OEM logo.
 
+	bpf_preload_list= [BPF]
+			Specify a list of eBPF programs to preload.
+			Format: obj_name1,obj_name2,...
+			Default: bpf_preload
+
+			Specify the list of eBPF programs to preload when the
+			bpf filesystem is mounted.
+
 	bttv.card=	[HW,V4L] bttv (bt848 + bt878 based grabber cards)
 	bttv.radio=	Most important insmod options are available as
 			kernel args too.
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 619cdef0ba54..c1941c65ce95 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -22,7 +22,14 @@
 #include <linux/bpf_trace.h>
 #include <linux/bpf_preload.h>
 
-static char *bpf_preload_list_str;
+static char *bpf_preload_list_str = CONFIG_BPF_PRELOAD_LIST;
+
+static int __init bpf_preload_list_setup(char *str)
+{
+	bpf_preload_list_str = str;
+	return 1;
+}
+__setup("bpf_preload_list=", bpf_preload_list_setup);
 
 static void *bpf_any_get(void *raw, enum bpf_type type)
 {
@@ -732,7 +739,12 @@ static bool bpf_preload_list_mod_get(void)
 	struct bpf_preload_ops_item *cur;
 	bool ret = false;
 
-	ret |= bpf_preload_mod_get("bpf_preload", &bpf_preload_ops);
+	/*
+	 * Keep the legacy registration method, but do not attempt to load
+	 * bpf_preload.ko, as it switched to the new registration method.
+	 */
+	if (bpf_preload_ops)
+		ret |= bpf_preload_mod_get("bpf_preload", &bpf_preload_ops);
 
 	list_for_each_entry(cur, &preload_list, list)
 		ret |= bpf_preload_mod_get(cur->obj_name, &cur->ops);
diff --git a/kernel/bpf/preload/Kconfig b/kernel/bpf/preload/Kconfig
index c9d45c9d6918..f878e537b0ff 100644
--- a/kernel/bpf/preload/Kconfig
+++ b/kernel/bpf/preload/Kconfig
@@ -4,7 +4,7 @@ config USERMODE_DRIVER
 	default n
 
 menuconfig BPF_PRELOAD
-	bool "Preload BPF file system with kernel specific program and map iterators"
+	bool "Preload eBPF programs"
 	depends on BPF
 	depends on BPF_SYSCALL
 	# The dependency on !COMPILE_TEST prevents it from being enabled
@@ -12,15 +12,26 @@ menuconfig BPF_PRELOAD
 	depends on !COMPILE_TEST
 	select USERMODE_DRIVER
 	help
-	  This builds kernel module with several embedded BPF programs that are
-	  pinned into BPF FS mount point as human readable files that are
-	  useful in debugging and introspection of BPF programs and maps.
+	  This enables preloading eBPF programs chosen from the kernel
+	  configuration or from the kernel option bpf_preload_list=.
 
 if BPF_PRELOAD
 config BPF_PRELOAD_UMD
-	tristate "bpf_preload kernel module"
+	tristate "Preload BPF file system with kernel specific program and map iterators"
 	default m
 	help
-	  This builds bpf_preload kernel module with embedded BPF programs for
-	  introspection in bpffs.
+	  This builds bpf_preload kernel module with several embedded BPF
+	  programs that are pinned into BPF FS mount point as human readable
+	  files that are useful in debugging and introspection of BPF programs
+	  and maps.
+
+config BPF_PRELOAD_LIST
+	string "Ordered list of eBPF programs to preload"
+	default "bpf_preload"
+	help
+	  A comma-separated list of eBPF programs to preload. Any eBPF program
+	  left off this list will be ignored. This can be controlled at boot
+	  with the "bpf_preload_list=" parameter.
+
+	  If unsure, leave this as the default.
 endif
diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
index 3839af367200..c6d97872225b 100644
--- a/kernel/bpf/preload/bpf_preload_kern.c
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -5,22 +5,6 @@
 #include <linux/bpf_preload.h>
 #include "iterators/iterators.lskel.h"
 
-static int __init load(void)
-{
-	int err;
-
-	err = load_skel();
-	if (err)
-		return err;
-	bpf_preload_ops = &ops;
-	return err;
-}
-
-static void __exit fini(void)
-{
-	bpf_preload_ops = NULL;
-	free_objs_and_skel();
-}
-late_initcall(load);
-module_exit(fini);
+late_initcall(load_skel);
+module_exit(free_objs_and_skel);
 MODULE_LICENSE("GPL");
diff --git a/kernel/bpf/preload/iterators/iterators.lskel.h b/kernel/bpf/preload/iterators/iterators.lskel.h
index 7595fc283a65..5e999564cc7a 100644
--- a/kernel/bpf/preload/iterators/iterators.lskel.h
+++ b/kernel/bpf/preload/iterators/iterators.lskel.h
@@ -440,6 +440,8 @@ static struct iterators_bpf *skel;
 
 static void free_objs_and_skel(void)
 {
+	bpf_preload_set_ops("bpf_preload", THIS_MODULE, NULL);
+
 	if (!IS_ERR_OR_NULL(dump_bpf_map_link))
 		bpf_link_put(dump_bpf_map_link);
 	if (!IS_ERR_OR_NULL(dump_bpf_prog_link))
@@ -481,11 +483,14 @@ static struct bpf_preload_ops ops = {
 
 static int load_skel(void)
 {
-	int err;
+	int err = -ENOMEM;
+
+	if (!bpf_preload_set_ops("bpf_preload", THIS_MODULE, &ops))
+		return 0;
 
 	skel = iterators_bpf__open();
 	if (!skel)
-		return -ENOMEM;
+		goto out;
 
 	err = iterators_bpf__load(skel);
 	if (err)
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 5593cbee1846..af939183f57a 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -700,7 +700,10 @@ static void codegen_preload_free(struct bpf_object *obj, const char *obj_name)
 		\n\
 		static void free_objs_and_skel(void)			    \n\
 		{							    \n\
-		");
+			bpf_preload_set_ops(\"%s\", THIS_MODULE, NULL);     \n\
+		\n\
+		", !strcmp(obj_name, "iterators_bpf") ?
+		   "bpf_preload" : obj_name);
 
 	bpf_object__for_each_program(prog, obj) {
 		codegen("\
@@ -864,11 +867,14 @@ static void codegen_preload_load(struct bpf_object *obj, const char *obj_name)
 		\n\
 		static int load_skel(void)				    \n\
 		{							    \n\
-			int err;					    \n\
+			int err = -ENOMEM;				    \n\
+		\n\
+			if (!bpf_preload_set_ops(\"%2$s\", THIS_MODULE, &ops))	\n\
+				return 0;				    \n\
 		\n\
 			skel = %1$s__open();				    \n\
 			if (!skel)					    \n\
-				return -ENOMEM;				    \n\
+				goto out;				    \n\
 		\n\
 			err = %1$s__load(skel);				    \n\
 			if (err)					    \n\
@@ -877,7 +883,8 @@ static void codegen_preload_load(struct bpf_object *obj, const char *obj_name)
 			err = %1$s__attach(skel);			    \n\
 			if (err)					    \n\
 				goto out;				    \n\
-		", obj_name);
+		", obj_name, !strcmp(obj_name, "iterators_bpf") ?
+			     "bpf_preload" : obj_name);
 
 	bpf_object__for_each_program(prog, obj) {
 		codegen("\
-- 
2.32.0

