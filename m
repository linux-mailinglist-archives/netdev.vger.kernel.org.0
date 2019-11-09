Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0FF2F5DFE
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 09:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfKIIHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 03:07:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10184 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726301AbfKIIHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 03:07:02 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA984tY0031200
        for <netdev@vger.kernel.org>; Sat, 9 Nov 2019 00:07:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=kQyk6ZTQKfvod+yRKy0eWswT6wNyPhLM/cEbxQ3VpAk=;
 b=CfMJudFmNu/ty7Rg0inVFCFMPuzi/inNsA6KSjgUTh3La2F46kYubKUPytSHrzJag4ev
 pU58727N+GiPhm8kQ02FesbXSd0HBGSqaU4Xq+ks6tqmdz0uSLcTFmStELfasBiiIOly
 eQZ/2QehNh2YNEd5uj+w5Hh4Cf0SmU8CZsU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5p7xrhhr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 00:07:01 -0800
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 9 Nov 2019 00:06:40 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 817DA2EC1AC6; Sat,  9 Nov 2019 00:06:38 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] libbpf: make global data internal arrays mmap()-able, if possible
Date:   Sat, 9 Nov 2019 00:06:31 -0800
Message-ID: <20191109080633.2855561-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109080633.2855561-1-andriin@fb.com>
References: <20191109080633.2855561-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-09_02:2019-11-08,2019-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0 phishscore=0
 suspectscore=8 malwarescore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911090085
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add detection of BPF_F_MMAPABLE flag support for arrays and add it as an extra
flag to internal global data maps, if supported by kernel. This allows users
to memory-map global data and use it without BPF map operations, greatly
simplifying user experience.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fde6cb3e5d41..d32899e50f8a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -142,6 +142,8 @@ struct bpf_capabilities {
 	__u32 btf_func:1;
 	/* BTF_KIND_VAR and BTF_KIND_DATASEC support */
 	__u32 btf_datasec:1;
+	/* BPF_F_MMAPABLE is supported for arrays */
+	__u32 array_mmap:1;
 };
 
 /*
@@ -855,8 +857,6 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 		pr_warn("failed to alloc map name\n");
 		return -ENOMEM;
 	}
-	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu.\n",
-		 map_name, map->sec_idx, map->sec_offset);
 
 	def = &map->def;
 	def->type = BPF_MAP_TYPE_ARRAY;
@@ -864,6 +864,12 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 	def->value_size = data->d_size;
 	def->max_entries = 1;
 	def->map_flags = type == LIBBPF_MAP_RODATA ? BPF_F_RDONLY_PROG : 0;
+	if (obj->caps.array_mmap)
+		def->map_flags |= BPF_F_MMAPABLE;
+
+	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu, flags %x.\n",
+		 map_name, map->sec_idx, map->sec_offset, def->map_flags);
+
 	if (data_buff) {
 		*data_buff = malloc(data->d_size);
 		if (!*data_buff) {
@@ -2158,6 +2164,26 @@ static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
 	return 0;
 }
 
+static int bpf_object__probe_array_mmap(struct bpf_object *obj)
+{
+	struct bpf_create_map_attr attr = {
+		.map_type = BPF_MAP_TYPE_ARRAY,
+		.map_flags = BPF_F_MMAPABLE,
+		.key_size = sizeof(int),
+		.value_size = sizeof(int),
+		.max_entries = 1,
+	};
+	int fd = bpf_create_map_xattr(&attr);
+
+	if (fd >= 0) {
+		obj->caps.array_mmap = 1;
+		close(fd);
+		return 1;
+	}
+
+	return 0;
+}
+
 static int
 bpf_object__probe_caps(struct bpf_object *obj)
 {
@@ -2166,6 +2192,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
 		bpf_object__probe_global_data,
 		bpf_object__probe_btf_func,
 		bpf_object__probe_btf_datasec,
+		bpf_object__probe_array_mmap,
 	};
 	int i, ret;
 
-- 
2.17.1

