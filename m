Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C0B4E9E42
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244877AbiC1RzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244836AbiC1Ryj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:54:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C6E65796;
        Mon, 28 Mar 2022 10:52:29 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0bd1xkWz67PnL;
        Tue, 29 Mar 2022 01:50:37 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:52:26 +0200
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
Subject: [PATCH 06/18] bpf-preload: Generate free_objs_and_skel()
Date:   Mon, 28 Mar 2022 19:50:21 +0200
Message-ID: <20220328175033.2437312-7-roberto.sassu@huawei.com>
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

Generate free_objs_and_skel() (renamed from free_links_and_skel()) to
decrease the reference count of pinned objects, and to destroy the
skeleton.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 kernel/bpf/preload/bpf_preload_kern.c         | 13 ++-------
 .../bpf/preload/iterators/iterators.lskel.h   | 10 +++++++
 tools/bpf/bpftool/gen.c                       | 28 +++++++++++++++++++
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
index 485589e03bd2..8b49beb2b2d6 100644
--- a/kernel/bpf/preload/bpf_preload_kern.c
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -5,15 +5,6 @@
 #include <linux/bpf_preload.h>
 #include "iterators/iterators.lskel.h"
 
-static void free_links_and_skel(void)
-{
-	if (!IS_ERR_OR_NULL(dump_bpf_map_link))
-		bpf_link_put(dump_bpf_map_link);
-	if (!IS_ERR_OR_NULL(dump_bpf_prog_link))
-		bpf_link_put(dump_bpf_prog_link);
-	iterators_bpf__destroy(skel);
-}
-
 static int preload(struct dentry *parent)
 {
 	int err;
@@ -75,7 +66,7 @@ static int load_skel(void)
 	skel->links.dump_bpf_prog_fd = 0;
 	return 0;
 out:
-	free_links_and_skel();
+	free_objs_and_skel();
 	return err;
 }
 
@@ -93,7 +84,7 @@ static int __init load(void)
 static void __exit fini(void)
 {
 	bpf_preload_ops = NULL;
-	free_links_and_skel();
+	free_objs_and_skel();
 }
 late_initcall(load);
 module_exit(fini);
diff --git a/kernel/bpf/preload/iterators/iterators.lskel.h b/kernel/bpf/preload/iterators/iterators.lskel.h
index 9794acdfacf9..4afd983ad40e 100644
--- a/kernel/bpf/preload/iterators/iterators.lskel.h
+++ b/kernel/bpf/preload/iterators/iterators.lskel.h
@@ -438,4 +438,14 @@ static struct bpf_link *dump_bpf_map_link;
 static struct bpf_link *dump_bpf_prog_link;
 static struct iterators_bpf *skel;
 
+static void free_objs_and_skel(void)
+{
+	if (!IS_ERR_OR_NULL(dump_bpf_map_link))
+		bpf_link_put(dump_bpf_map_link);
+	if (!IS_ERR_OR_NULL(dump_bpf_prog_link))
+		bpf_link_put(dump_bpf_prog_link);
+
+	iterators_bpf__destroy(skel);
+}
+
 #endif /* __ITERATORS_BPF_SKEL_H__ */
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index c62c4c65b631..e167aa092b7f 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -674,6 +674,33 @@ static void codegen_preload_vars(struct bpf_object *obj, const char *obj_name)
 		", obj_name);
 }
 
+static void codegen_preload_free(struct bpf_object *obj, const char *obj_name)
+{
+	struct bpf_program *prog;
+
+	codegen("\
+		\n\
+		\n\
+		static void free_objs_and_skel(void)			    \n\
+		{							    \n\
+		");
+
+	bpf_object__for_each_program(prog, obj) {
+		codegen("\
+			\n\
+				if (!IS_ERR_OR_NULL(%1$s_link))		    \n\
+					bpf_link_put(%1$s_link);	    \n\
+			", bpf_program__name(prog));
+	}
+
+	codegen("\
+		\n\
+		\n\
+			%s__destroy(skel);				    \n\
+		}							    \n\
+		", obj_name);
+}
+
 static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *header_guard)
 {
 	DECLARE_LIBBPF_OPTS(gen_loader_opts, opts);
@@ -824,6 +851,7 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 
 	if (gen_preload_methods) {
 		codegen_preload_vars(obj, obj_name);
+		codegen_preload_free(obj, obj_name);
 	}
 
 	codegen("\
-- 
2.32.0

