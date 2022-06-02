Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA5D53BAF0
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiFBOiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235647AbiFBOiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:38:13 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A2B14478C;
        Thu,  2 Jun 2022 07:38:07 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDT9x3gzxz684y4;
        Thu,  2 Jun 2022 22:37:09 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 16:38:05 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 2/9] libbpf: Introduce bpf_obj_get_flags()
Date:   Thu, 2 Jun 2022 16:37:41 +0200
Message-ID: <20220602143748.673971-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602143748.673971-1-roberto.sassu@huawei.com>
References: <20220602143748.673971-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the bpf_obj_get_flags() function, so that it is possible to
specify the needed permissions for obtaining a file descriptor from a
pinned object.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/lib/bpf/bpf.c      | 8 +++++++-
 tools/lib/bpf/bpf.h      | 1 +
 tools/lib/bpf/libbpf.map | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 33bac2006043..a5fc40f6ce13 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -670,18 +670,24 @@ int bpf_obj_pin(int fd, const char *pathname)
 	return libbpf_err_errno(ret);
 }
 
-int bpf_obj_get(const char *pathname)
+int bpf_obj_get_flags(const char *pathname, __u32 flags)
 {
 	union bpf_attr attr;
 	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.pathname = ptr_to_u64((void *)pathname);
+	attr.file_flags = flags;
 
 	fd = sys_bpf_fd(BPF_OBJ_GET, &attr, sizeof(attr));
 	return libbpf_err_errno(fd);
 }
 
+int bpf_obj_get(const char *pathname)
+{
+	return bpf_obj_get_flags(pathname, 0);
+}
+
 int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type,
 		    unsigned int flags)
 {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 20e4c852362d..6d0ceb2e90c4 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -339,6 +339,7 @@ LIBBPF_API int bpf_map_update_batch(int fd, const void *keys, const void *values
 				    const struct bpf_map_batch_opts *opts);
 
 LIBBPF_API int bpf_obj_pin(int fd, const char *pathname);
+LIBBPF_API int bpf_obj_get_flags(const char *pathname, __u32 flags);
 LIBBPF_API int bpf_obj_get(const char *pathname);
 
 struct bpf_prog_attach_opts {
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 019278e66836..6c3ace12b27b 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -467,6 +467,7 @@ LIBBPF_1.0.0 {
 		libbpf_bpf_map_type_str;
 		libbpf_bpf_prog_type_str;
 		bpf_map_get_fd_by_id_flags;
+		bpf_obj_get_flags;
 
 	local: *;
 };
-- 
2.25.1

