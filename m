Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C547FD38A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 05:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKOEDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 23:03:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbfKOEDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 23:03:00 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF402PP016639
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 20:02:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=ejC9iTYZ85BR5qdCuIQaf1BngC+V5I0ppQHDB+wY5Eg=;
 b=MiNLjKHXUiqhRlsXF13HjDZm2yhkPCSK+6SDruD4JmrEIWUNm/fY7XePCGqCh69iAC+D
 VbTB1KEVPSWZSkzV/n6hpnKS4udVMRD98NHqxhWJlZl0uWuZNphSGhmwLXWvwlEHCuTi
 rNbeHYtFq2xxMx51NWOOL7/NDS/c/H3PaC8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8u0tk7gh-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 20:02:59 -0800
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 20:02:56 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CB3992EC1AEC; Thu, 14 Nov 2019 20:02:55 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 3/4] libbpf: make global data internal arrays mmap()-able, if possible
Date:   Thu, 14 Nov 2019 20:02:24 -0800
Message-ID: <20191115040225.2147245-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115040225.2147245-1-andriin@fb.com>
References: <20191115040225.2147245-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_07:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=8 malwarescore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911150034
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
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 96ef18cfeffb..7e2be1288fa1 100644
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
@@ -856,8 +858,6 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 		pr_warn("failed to alloc map name\n");
 		return -ENOMEM;
 	}
-	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu.\n",
-		 map_name, map->sec_idx, map->sec_offset);
 
 	def = &map->def;
 	def->type = BPF_MAP_TYPE_ARRAY;
@@ -865,6 +865,12 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
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
@@ -2160,6 +2166,27 @@ static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
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
+	int fd;
+
+	fd = bpf_create_map_xattr(&attr);
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
@@ -2168,6 +2195,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
 		bpf_object__probe_global_data,
 		bpf_object__probe_btf_func,
 		bpf_object__probe_btf_datasec,
+		bpf_object__probe_array_mmap,
 	};
 	int i, ret;
 
-- 
2.17.1

