Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDEDFF824
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 07:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfKQGux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 01:50:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15938 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726037AbfKQGuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 01:50:51 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAH6nVq7020641
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 22:50:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=9cDQKABTP46VQhYMyTMEld1LWTgfKVYS/6ldiraza8g=;
 b=f/Btx+wj+7OEKJTdMBIO+1xa6ZX6ZAdFbyZ8HtDAJBTDdR+x7g6b4iJ69WiFTh2ajWmU
 xeX2aFaQNtR5Wo9jqJvWnZ0HFVpkcA7aVdP1+nlIs7d156tk+YU4hyBqIRWikm5lq6uU
 ROTwye7cCUjxLSebR3VHLXlEfrPuplH9QMA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2wadg0u0g0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 22:50:50 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 16 Nov 2019 22:50:48 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 422592EC18AA; Sat, 16 Nov 2019 22:50:47 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 4/5] libbpf: make global data internal arrays mmap()-able, if possible
Date:   Sat, 16 Nov 2019 22:50:34 -0800
Message-ID: <20191117065035.202462-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117065035.202462-1-andriin@fb.com>
References: <20191117065035.202462-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=8 malwarescore=0 impostorscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170064
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
index 7132c6bdec02..15e91a1d6c11 100644
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
@@ -857,8 +859,6 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
 		pr_warn("failed to alloc map name\n");
 		return -ENOMEM;
 	}
-	pr_debug("map '%s' (global data): at sec_idx %d, offset %zu.\n",
-		 map_name, map->sec_idx, map->sec_offset);
 
 	def = &map->def;
 	def->type = BPF_MAP_TYPE_ARRAY;
@@ -866,6 +866,12 @@ bpf_object__init_internal_map(struct bpf_object *obj, enum libbpf_map_type type,
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
@@ -2161,6 +2167,27 @@ static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
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
@@ -2169,6 +2196,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
 		bpf_object__probe_global_data,
 		bpf_object__probe_btf_func,
 		bpf_object__probe_btf_datasec,
+		bpf_object__probe_array_mmap,
 	};
 	int i, ret;
 
-- 
2.17.1

