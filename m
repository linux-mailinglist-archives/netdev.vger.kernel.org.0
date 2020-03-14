Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799CB185370
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgCNAvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:51:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42078 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727742AbgCNAvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:51:46 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02E0i7Fr010655
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 17:51:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=in0DnIsx+K/N5zch5r2BhSfvWCwH50lQOZxBGavGdcg=;
 b=DHZZBTrt4qUinl2rAFJm47FYVNg/J2W4otbAv9Au9Xd5itJSLrsj6oc2If41FA39Evh3
 D0qWt/tUA7IN4NqxlaqYYJJv0EqlQOQHSRmmn5kSPXAUnrKguifukbQ8lNVAHvt9JLRU
 ZtAFCcCewL7GyteijpNufoNTxlrYaBZ46u8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt96f70m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 17:51:43 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 17:51:41 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 2C9272942D3D; Fri, 13 Mar 2020 17:51:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf] bpf: Sanitize the bpf_struct_ops tcp-cc name
Date:   Fri, 13 Mar 2020 17:51:40 -0700
Message-ID: <20200314005140.1079796-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 mlxlogscore=726 mlxscore=0
 phishscore=0 suspectscore=38 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003140001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_struct_ops tcp-cc name should be sanitized in order to
avoid problematic chars (e.g. whitespaces).

This patch reuses the bpf_obj_name_cpy() for accepting the same set
of characters in order to keep a consistent bpf programming experience.
A "size" param is added.  Also, the strlen is returned on success so
that the caller (like the bpf_tcp_ca here) can error out on empty name.
The existing callers of the bpf_obj_name_cpy() only need to change the
testing statement to "if (err < 0)".  For all these existing callers,
the err will be overwritten later, so no extra change is needed
for the new strlen return value.

v2:
- Save the orig_src to avoid "end - size" (Andrii)

Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/syscall.c  | 25 ++++++++++++++-----------
 net/ipv4/bpf_tcp_ca.c |  7 ++-----
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 49b1a70e12c8..212991f6f2a5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -160,6 +160,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 }
 void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 			   bool lock_src);
+int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
 
 struct bpf_offload_dev;
 struct bpf_offloaded_map;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0c7fb0d4836d..11d96a2625f2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -696,14 +696,15 @@ int bpf_get_file_flag(int flags)
 		   offsetof(union bpf_attr, CMD##_LAST_FIELD) - \
 		   sizeof(attr->CMD##_LAST_FIELD)) != NULL
 
-/* dst and src must have at least BPF_OBJ_NAME_LEN number of bytes.
- * Return 0 on success and < 0 on error.
+/* dst and src must have at least "size" number of bytes.
+ * Return strlen on success and < 0 on error.
  */
-static int bpf_obj_name_cpy(char *dst, const char *src)
+int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size)
 {
-	const char *end = src + BPF_OBJ_NAME_LEN;
+	const char *orig_src = src;
+	const char *end = src + size;
 
-	memset(dst, 0, BPF_OBJ_NAME_LEN);
+	memset(dst, 0, size);
 	/* Copy all isalnum(), '_' and '.' chars. */
 	while (src < end && *src) {
 		if (!isalnum(*src) &&
@@ -712,11 +713,11 @@ static int bpf_obj_name_cpy(char *dst, const char *src)
 		*dst++ = *src++;
 	}
 
-	/* No '\0' found in BPF_OBJ_NAME_LEN number of bytes */
+	/* No '\0' found in "size" number of bytes */
 	if (src == end)
 		return -EINVAL;
 
-	return 0;
+	return src - orig_src;
 }
 
 int map_check_no_btf(const struct bpf_map *map,
@@ -810,8 +811,9 @@ static int map_create(union bpf_attr *attr)
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
-	err = bpf_obj_name_cpy(map->name, attr->map_name);
-	if (err)
+	err = bpf_obj_name_cpy(map->name, attr->map_name,
+			       sizeof(attr->map_name));
+	if (err < 0)
 		goto free_map;
 
 	atomic64_set(&map->refcnt, 1);
@@ -2098,8 +2100,9 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 		goto free_prog;
 
 	prog->aux->load_time = ktime_get_boottime_ns();
-	err = bpf_obj_name_cpy(prog->aux->name, attr->prog_name);
-	if (err)
+	err = bpf_obj_name_cpy(prog->aux->name, attr->prog_name,
+			       sizeof(attr->prog_name));
+	if (err < 0)
 		goto free_prog;
 
 	/* run eBPF verifier */
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 574972bc7299..2bf3abeb1456 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -184,7 +184,6 @@ static int bpf_tcp_ca_init_member(const struct btf_type *t,
 {
 	const struct tcp_congestion_ops *utcp_ca;
 	struct tcp_congestion_ops *tcp_ca;
-	size_t tcp_ca_name_len;
 	int prog_fd;
 	u32 moff;
 
@@ -199,13 +198,11 @@ static int bpf_tcp_ca_init_member(const struct btf_type *t,
 		tcp_ca->flags = utcp_ca->flags;
 		return 1;
 	case offsetof(struct tcp_congestion_ops, name):
-		tcp_ca_name_len = strnlen(utcp_ca->name, sizeof(utcp_ca->name));
-		if (!tcp_ca_name_len ||
-		    tcp_ca_name_len == sizeof(utcp_ca->name))
+		if (bpf_obj_name_cpy(tcp_ca->name, utcp_ca->name,
+				     sizeof(tcp_ca->name)) <= 0)
 			return -EINVAL;
 		if (tcp_ca_find(utcp_ca->name))
 			return -EEXIST;
-		memcpy(tcp_ca->name, utcp_ca->name, sizeof(tcp_ca->name));
 		return 1;
 	}
 
-- 
2.17.1

