Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911AE4E9E3D
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244769AbiC1RzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244849AbiC1Ryj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:54:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB154657AE;
        Mon, 28 Mar 2022 10:52:31 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0cC5Qj6z67yj3;
        Tue, 29 Mar 2022 01:51:07 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:52:28 +0200
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
Subject: [PATCH 08/18] bpf-preload: Generate load_skel()
Date:   Mon, 28 Mar 2022 19:50:23 +0200
Message-ID: <20220328175033.2437312-9-roberto.sassu@huawei.com>
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

Generate load_skel() to load and attach the eBPF program, and to retrieve
the objects to be pinned.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 kernel/bpf/preload/bpf_preload_kern.c         | 36 -----------
 .../bpf/preload/iterators/iterators.lskel.h   | 42 ++++++++++++
 tools/bpf/bpftool/gen.c                       | 64 +++++++++++++++++++
 3 files changed, 106 insertions(+), 36 deletions(-)

diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
index 0869c889255c..35e9abd1a668 100644
--- a/kernel/bpf/preload/bpf_preload_kern.c
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -10,42 +10,6 @@ static struct bpf_preload_ops ops = {
 	.owner = THIS_MODULE,
 };
 
-static int load_skel(void)
-{
-	int err;
-
-	skel = iterators_bpf__open();
-	if (!skel)
-		return -ENOMEM;
-	err = iterators_bpf__load(skel);
-	if (err)
-		goto out;
-	err = iterators_bpf__attach(skel);
-	if (err)
-		goto out;
-	dump_bpf_map_link = bpf_link_get_from_fd(skel->links.dump_bpf_map_fd);
-	if (IS_ERR(dump_bpf_map_link)) {
-		err = PTR_ERR(dump_bpf_map_link);
-		goto out;
-	}
-	dump_bpf_prog_link = bpf_link_get_from_fd(skel->links.dump_bpf_prog_fd);
-	if (IS_ERR(dump_bpf_prog_link)) {
-		err = PTR_ERR(dump_bpf_prog_link);
-		goto out;
-	}
-	/* Avoid taking over stdin/stdout/stderr of init process. Zeroing out
-	 * makes skel_closenz() a no-op later in iterators_bpf__destroy().
-	 */
-	close_fd(skel->links.dump_bpf_map_fd);
-	skel->links.dump_bpf_map_fd = 0;
-	close_fd(skel->links.dump_bpf_prog_fd);
-	skel->links.dump_bpf_prog_fd = 0;
-	return 0;
-out:
-	free_objs_and_skel();
-	return err;
-}
-
 static int __init load(void)
 {
 	int err;
diff --git a/kernel/bpf/preload/iterators/iterators.lskel.h b/kernel/bpf/preload/iterators/iterators.lskel.h
index 75b2e94b7547..6faf3708be01 100644
--- a/kernel/bpf/preload/iterators/iterators.lskel.h
+++ b/kernel/bpf/preload/iterators/iterators.lskel.h
@@ -474,4 +474,46 @@ static int preload(struct dentry *parent)
 	return err;
 }
 
+static int load_skel(void)
+{
+	int err;
+
+	skel = iterators_bpf__open();
+	if (!skel)
+		return -ENOMEM;
+
+	err = iterators_bpf__load(skel);
+	if (err)
+		goto out;
+
+	err = iterators_bpf__attach(skel);
+	if (err)
+		goto out;
+
+	dump_bpf_map_link = bpf_link_get_from_fd(skel->links.dump_bpf_map_fd);
+	if (IS_ERR(dump_bpf_map_link)) {
+		err = PTR_ERR(dump_bpf_map_link);
+		goto out;
+	}
+
+	dump_bpf_prog_link = bpf_link_get_from_fd(skel->links.dump_bpf_prog_fd);
+	if (IS_ERR(dump_bpf_prog_link)) {
+		err = PTR_ERR(dump_bpf_prog_link);
+		goto out;
+	}
+
+	/* Avoid taking over stdin/stdout/stderr of init process. Zeroing out
+	 * makes skel_closenz() a no-op later in iterators_bpf__destroy().
+	 */
+	close_fd(skel->links.dump_bpf_map_fd);
+	skel->links.dump_bpf_map_fd = 0;
+	close_fd(skel->links.dump_bpf_prog_fd);
+	skel->links.dump_bpf_prog_fd = 0;
+
+	return 0;
+out:
+	free_objs_and_skel();
+	return err;
+}
+
 #endif /* __ITERATORS_BPF_SKEL_H__ */
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index fa2c6022b80d..ad948f1c90b5 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -764,6 +764,69 @@ static void codegen_preload(struct bpf_object *obj, const char *obj_name)
 		");
 }
 
+static void codegen_preload_load(struct bpf_object *obj, const char *obj_name)
+{
+	struct bpf_program *prog;
+
+	codegen("\
+		\n\
+		\n\
+		static int load_skel(void)				    \n\
+		{							    \n\
+			int err;					    \n\
+		\n\
+			skel = %1$s__open();				    \n\
+			if (!skel)					    \n\
+				return -ENOMEM;				    \n\
+		\n\
+			err = %1$s__load(skel);				    \n\
+			if (err)					    \n\
+				goto out;				    \n\
+		\n\
+			err = %1$s__attach(skel);			    \n\
+			if (err)					    \n\
+				goto out;				    \n\
+		", obj_name);
+
+	bpf_object__for_each_program(prog, obj) {
+		codegen("\
+			\n\
+			\n\
+				%1$s_link = bpf_link_get_from_fd(skel->links.%1$s_fd);		\n\
+				if (IS_ERR(%1$s_link)) {					\n\
+					err = PTR_ERR(%1$s_link);				\n\
+					goto out;						\n\
+				}								\n\
+			", bpf_program__name(prog));
+	}
+
+	codegen("\
+		\n\
+		\n\
+			/* Avoid taking over stdin/stdout/stderr of init process. Zeroing out	\n\
+			 * makes skel_closenz() a no-op later in iterators_bpf__destroy().	\n\
+			 */									\n\
+		");
+
+	bpf_object__for_each_program(prog, obj) {
+		codegen("\
+			\n\
+				close_fd(skel->links.%1$s_fd);		    \n\
+				skel->links.%1$s_fd = 0;		    \n\
+			", bpf_program__name(prog));
+	}
+
+	codegen("\
+		\n\
+		\n\
+			return 0;					    \n\
+		out:							    \n\
+			free_objs_and_skel();				    \n\
+			return err;					    \n\
+		}							    \n\
+		");
+}
+
 static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *header_guard)
 {
 	DECLARE_LIBBPF_OPTS(gen_loader_opts, opts);
@@ -916,6 +979,7 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 		codegen_preload_vars(obj, obj_name);
 		codegen_preload_free(obj, obj_name);
 		codegen_preload(obj, obj_name);
+		codegen_preload_load(obj, obj_name);
 	}
 
 	codegen("\
-- 
2.32.0

