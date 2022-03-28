Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82754E9E49
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239383AbiC1RzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244855AbiC1Ryj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:54:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37A5657B9;
        Mon, 28 Mar 2022 10:52:32 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0Zw6Tljz67mcQ;
        Tue, 29 Mar 2022 01:50:00 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:52:29 +0200
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
Subject: [PATCH 09/18] bpf-preload: Generate code to pin non-internal maps
Date:   Mon, 28 Mar 2022 19:50:24 +0200
Message-ID: <20220328175033.2437312-10-roberto.sassu@huawei.com>
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

Take the non-internal maps from the skeleton, and generate the code for
each of them (static variable declaration, additional code in
free_objs_and_skel(), preload() and load_skel()).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/bpf/bpftool/gen.c | 97 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index ad948f1c90b5..28b1fe718248 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -655,6 +655,8 @@ static void codegen_destroy(struct bpf_object *obj, const char *obj_name)
 static void codegen_preload_vars(struct bpf_object *obj, const char *obj_name)
 {
 	struct bpf_program *prog;
+	struct bpf_map *map;
+	char ident[256];
 
 	codegen("\
 		\n\
@@ -668,6 +670,19 @@ static void codegen_preload_vars(struct bpf_object *obj, const char *obj_name)
 			", bpf_program__name(prog));
 	}
 
+	bpf_object__for_each_map(map, obj) {
+		if (!get_map_ident(map, ident, sizeof(ident)))
+			continue;
+
+		if (bpf_map__is_internal(map))
+			continue;
+
+		codegen("\
+			\n\
+			static struct bpf_map *%s_map;			    \n\
+			", ident);
+	}
+
 	codegen("\
 		\n\
 		static struct %s *skel;					    \n\
@@ -677,6 +692,8 @@ static void codegen_preload_vars(struct bpf_object *obj, const char *obj_name)
 static void codegen_preload_free(struct bpf_object *obj, const char *obj_name)
 {
 	struct bpf_program *prog;
+	struct bpf_map *map;
+	char ident[256];
 
 	codegen("\
 		\n\
@@ -693,6 +710,20 @@ static void codegen_preload_free(struct bpf_object *obj, const char *obj_name)
 			", bpf_program__name(prog));
 	}
 
+	bpf_object__for_each_map(map, obj) {
+		if (!get_map_ident(map, ident, sizeof(ident)))
+			continue;
+
+		if (bpf_map__is_internal(map))
+			continue;
+
+		codegen("\
+			\n\
+				if (!IS_ERR_OR_NULL(%1$s_map))		    \n\
+					bpf_map_put(%1$s_map);		    \n\
+			", ident);
+	}
+
 	codegen("\
 		\n\
 		\n\
@@ -705,6 +736,8 @@ static void codegen_preload(struct bpf_object *obj, const char *obj_name)
 {
 	struct bpf_program *prog;
 	const char *link_name;
+	struct bpf_map *map;
+	char ident[256];
 
 	codegen("\
 		\n\
@@ -722,6 +755,19 @@ static void codegen_preload(struct bpf_object *obj, const char *obj_name)
 			", bpf_program__name(prog));
 	}
 
+	bpf_object__for_each_map(map, obj) {
+		if (!get_map_ident(map, ident, sizeof(ident)))
+			continue;
+
+		if (bpf_map__is_internal(map))
+			continue;
+
+		codegen("\
+			\n\
+				bpf_map_inc(%s_map);			    \n\
+			", ident);
+	}
+
 	bpf_object__for_each_program(prog, obj) {
 		link_name = bpf_program__name(prog);
 		/* These need to be hardcoded for compatibility reasons. */
@@ -743,6 +789,24 @@ static void codegen_preload(struct bpf_object *obj, const char *obj_name)
 			", link_name, bpf_program__name(prog));
 	}
 
+	bpf_object__for_each_map(map, obj) {
+		if (!get_map_ident(map, ident, sizeof(ident)))
+			continue;
+
+		if (bpf_map__is_internal(map))
+			continue;
+
+		codegen("\
+			\n\
+			\n\
+				err = bpf_obj_do_pin_kernel(parent, \"%1$s\",	\n\
+							    %1$s_map,		\n\
+							    BPF_TYPE_MAP);	\n\
+				if (err)					\n\
+					goto undo;				\n\
+			", ident);
+	}
+
 	codegen("\
 		\n\
 		\n\
@@ -757,6 +821,19 @@ static void codegen_preload(struct bpf_object *obj, const char *obj_name)
 			", bpf_program__name(prog));
 	}
 
+	bpf_object__for_each_map(map, obj) {
+		if (!get_map_ident(map, ident, sizeof(ident)))
+			continue;
+
+		if (bpf_map__is_internal(map))
+			continue;
+
+		codegen("\
+			\n\
+				bpf_map_put(%s_map);			    \n\
+			", ident);
+	}
+
 	codegen("\
 		\n\
 			return err;					    \n\
@@ -767,6 +844,8 @@ static void codegen_preload(struct bpf_object *obj, const char *obj_name)
 static void codegen_preload_load(struct bpf_object *obj, const char *obj_name)
 {
 	struct bpf_program *prog;
+	struct bpf_map *map;
+	char ident[256];
 
 	codegen("\
 		\n\
@@ -800,6 +879,24 @@ static void codegen_preload_load(struct bpf_object *obj, const char *obj_name)
 			", bpf_program__name(prog));
 	}
 
+	bpf_object__for_each_map(map, obj) {
+		if (!get_map_ident(map, ident, sizeof(ident)))
+			continue;
+
+		if (bpf_map__is_internal(map))
+			continue;
+
+		codegen("\
+			\n\
+			\n\
+				%1$s_map = bpf_map_get(skel->maps.%1$s.map_fd);			\n\
+				if (IS_ERR(%1$s_map)) {						\n\
+					err = PTR_ERR(%1$s_map);				\n\
+					goto out;						\n\
+				}								\n\
+			", ident);
+	}
+
 	codegen("\
 		\n\
 		\n\
-- 
2.32.0

