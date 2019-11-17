Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E77FFAED
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 18:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfKQR2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 12:28:23 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbfKQR2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 12:28:20 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAHHPf2I023626
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 09:28:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=9cDQKABTP46VQhYMyTMEld1LWTgfKVYS/6ldiraza8g=;
 b=Lrkzr5yM6adAoN+ocdMIbgHmUi+vmbRY0SpwIhK43de2df+cFqc6vdUOFPS9WrGyiUQi
 m+9IZVt4E8wour07rulBeEhYHp7Ep2TiSHq3bKRelwOlQkINpVf61sBZWsq5up+J63i2
 AN6odXgDta/+0nOkpN66hmc4vKIT3U9R3zo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wb1nk23rb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 09:28:19 -0800
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 17 Nov 2019 09:28:17 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DC6A42EC0551; Sun, 17 Nov 2019 09:28:16 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v6 bpf-next 4/5] libbpf: make global data internal arrays mmap()-able, if possible
Date:   Sun, 17 Nov 2019 09:28:05 -0800
Message-ID: <20191117172806.2195367-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191117172806.2195367-1-andriin@fb.com>
References: <20191117172806.2195367-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_03:2019-11-15,2019-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=8 adultscore=0 mlxscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170167
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

