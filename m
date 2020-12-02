Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB312CB175
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 01:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgLBAYy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Dec 2020 19:24:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49372 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726979AbgLBAYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 19:24:52 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0B20FX4K017733
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 16:24:11 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 355pr6m83v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 16:24:11 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 16:24:08 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 347872ECA70C; Tue,  1 Dec 2020 16:24:02 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v4 bpf-next 03/14] libbpf: add internal helper to load BTF data by FD
Date:   Tue, 1 Dec 2020 16:16:05 -0800
Message-ID: <20201202001616.3378929-4-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201202001616.3378929-1-andrii@kernel.org>
References: <20201202001616.3378929-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_12:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 suspectscore=25 spamscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a btf_get_from_fd() helper, which constructs struct btf from in-kernel BTF
data by FD. This is used for loading module BTFs.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c             | 61 +++++++++++++++++++--------------
 tools/lib/bpf/libbpf_internal.h |  1 +
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 8ff46cd30ca1..affea8318feb 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1318,35 +1318,27 @@ const char *btf__name_by_offset(const struct btf *btf, __u32 offset)
 	return btf__str_by_offset(btf, offset);
 }
 
-int btf__get_from_id(__u32 id, struct btf **btf)
+struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
 {
-	struct bpf_btf_info btf_info = { 0 };
+	struct bpf_btf_info btf_info;
 	__u32 len = sizeof(btf_info);
 	__u32 last_size;
-	int btf_fd;
+	struct btf *btf;
 	void *ptr;
 	int err;
 
-	err = 0;
-	*btf = NULL;
-	btf_fd = bpf_btf_get_fd_by_id(id);
-	if (btf_fd < 0)
-		return 0;
-
 	/* we won't know btf_size until we call bpf_obj_get_info_by_fd(). so
 	 * let's start with a sane default - 4KiB here - and resize it only if
 	 * bpf_obj_get_info_by_fd() needs a bigger buffer.
 	 */
-	btf_info.btf_size = 4096;
-	last_size = btf_info.btf_size;
+	last_size = 4096;
 	ptr = malloc(last_size);
-	if (!ptr) {
-		err = -ENOMEM;
-		goto exit_free;
-	}
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
 
-	memset(ptr, 0, last_size);
+	memset(&btf_info, 0, sizeof(btf_info));
 	btf_info.btf = ptr_to_u64(ptr);
+	btf_info.btf_size = last_size;
 	err = bpf_obj_get_info_by_fd(btf_fd, &btf_info, &len);
 
 	if (!err && btf_info.btf_size > last_size) {
@@ -1355,31 +1347,48 @@ int btf__get_from_id(__u32 id, struct btf **btf)
 		last_size = btf_info.btf_size;
 		temp_ptr = realloc(ptr, last_size);
 		if (!temp_ptr) {
-			err = -ENOMEM;
+			btf = ERR_PTR(-ENOMEM);
 			goto exit_free;
 		}
 		ptr = temp_ptr;
-		memset(ptr, 0, last_size);
+
+		len = sizeof(btf_info);
+		memset(&btf_info, 0, sizeof(btf_info));
 		btf_info.btf = ptr_to_u64(ptr);
+		btf_info.btf_size = last_size;
+
 		err = bpf_obj_get_info_by_fd(btf_fd, &btf_info, &len);
 	}
 
 	if (err || btf_info.btf_size > last_size) {
-		err = errno;
+		btf = err ? ERR_PTR(-errno) : ERR_PTR(-E2BIG);
 		goto exit_free;
 	}
 
-	*btf = btf__new((__u8 *)(long)btf_info.btf, btf_info.btf_size);
-	if (IS_ERR(*btf)) {
-		err = PTR_ERR(*btf);
-		*btf = NULL;
-	}
+	btf = btf_new(ptr, btf_info.btf_size, base_btf);
 
 exit_free:
-	close(btf_fd);
 	free(ptr);
+	return btf;
+}
 
-	return err;
+int btf__get_from_id(__u32 id, struct btf **btf)
+{
+	struct btf *res;
+	int btf_fd;
+
+	*btf = NULL;
+	btf_fd = bpf_btf_get_fd_by_id(id);
+	if (btf_fd < 0)
+		return -errno;
+
+	res = btf_get_from_fd(btf_fd, NULL);
+	close(btf_fd);
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	*btf = res;
+	return 0;
 }
 
 int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index d99bc847bf84..e569ae63808e 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -155,6 +155,7 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 			     __u32 *size);
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
 				__u32 *off);
+struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf);
 
 struct btf_ext_info {
 	/*
-- 
2.24.1

