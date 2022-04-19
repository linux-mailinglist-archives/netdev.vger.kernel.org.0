Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E8E507066
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353269AbiDSO0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347442AbiDSO0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:26:33 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9676A2AE11;
        Tue, 19 Apr 2022 07:23:47 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KjQyf1Kt1zhXZm;
        Tue, 19 Apr 2022 22:23:38 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 22:23:45 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 22:23:44 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <pulehui@huawei.com>
Subject: [PATCH v2 bpf-next 1/2] libbpf: Fix usdt_cookie being cast to 32 bits
Date:   Tue, 19 Apr 2022 22:52:37 +0800
Message-ID: <20220419145238.482134-2-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220419145238.482134-1-pulehui@huawei.com>
References: <20220419145238.482134-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usdt_cookie is defined as __u64, which should not be
used as a long type because it will be cast to 32 bits
in 32-bit platforms.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 tools/lib/bpf/libbpf.c          | 2 +-
 tools/lib/bpf/libbpf_internal.h | 2 +-
 tools/lib/bpf/usdt.c            | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bf4f7ac54..33d21ed7c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10982,7 +10982,7 @@ struct bpf_link *bpf_program__attach_usdt(const struct bpf_program *prog,
 	char resolved_path[512];
 	struct bpf_object *obj = prog->obj;
 	struct bpf_link *link;
-	long usdt_cookie;
+	__u64 usdt_cookie;
 	int err;
 
 	if (!OPTS_VALID(opts, bpf_uprobe_opts))
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 080272421..054cd8e93 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -571,6 +571,6 @@ struct bpf_link * usdt_manager_attach_usdt(struct usdt_manager *man,
 					   const struct bpf_program *prog,
 					   pid_t pid, const char *path,
 					   const char *usdt_provider, const char *usdt_name,
-					   long usdt_cookie);
+					   __u64 usdt_cookie);
 
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index 934c25301..8e77a7260 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -557,10 +557,10 @@ static int parse_usdt_note(Elf *elf, const char *path, long base_addr,
 			   GElf_Nhdr *nhdr, const char *data, size_t name_off, size_t desc_off,
 			   struct usdt_note *usdt_note);
 
-static int parse_usdt_spec(struct usdt_spec *spec, const struct usdt_note *note, long usdt_cookie);
+static int parse_usdt_spec(struct usdt_spec *spec, const struct usdt_note *note, __u64 usdt_cookie);
 
 static int collect_usdt_targets(struct usdt_manager *man, Elf *elf, const char *path, pid_t pid,
-				const char *usdt_provider, const char *usdt_name, long usdt_cookie,
+				const char *usdt_provider, const char *usdt_name, __u64 usdt_cookie,
 				struct usdt_target **out_targets, size_t *out_target_cnt)
 {
 	size_t off, name_off, desc_off, seg_cnt = 0, lib_seg_cnt = 0, target_cnt = 0;
@@ -939,7 +939,7 @@ static int allocate_spec_id(struct usdt_manager *man, struct hashmap *specs_hash
 struct bpf_link *usdt_manager_attach_usdt(struct usdt_manager *man, const struct bpf_program *prog,
 					  pid_t pid, const char *path,
 					  const char *usdt_provider, const char *usdt_name,
-					  long usdt_cookie)
+					  __u64 usdt_cookie)
 {
 	int i, fd, err, spec_map_fd, ip_map_fd;
 	LIBBPF_OPTS(bpf_uprobe_opts, opts);
@@ -1141,7 +1141,7 @@ static int parse_usdt_note(Elf *elf, const char *path, long base_addr,
 
 static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg);
 
-static int parse_usdt_spec(struct usdt_spec *spec, const struct usdt_note *note, long usdt_cookie)
+static int parse_usdt_spec(struct usdt_spec *spec, const struct usdt_note *note, __u64 usdt_cookie)
 {
 	const char *s;
 	int len;
-- 
2.25.1

