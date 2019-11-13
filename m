Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360BBFA7C6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKMEAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:00:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16156 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726936AbfKMEAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:00:50 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAD3BlNq013639
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 19:15:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=eQvAR0KsDAU7VVhlbgUlS3DZ+EoDvMFnLdJUpY5bPx0=;
 b=GNR5vsJNtT+A5sLHCrFCqy1hgGDNxWfUeADudP86sxaVC293FTeb74zmjM1jSTeEWZdG
 WEiiGEt8UfB5/Pu00JSH/kj25MDb2PXHP+dyQxdfub9moU4xXBpufLZP1J3VNV+RETRV
 eqlg7+zV2dhA0Akl+GFtWja9ILY9JvHFYqA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w7pr7drj4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 19:15:31 -0800
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 12 Nov 2019 19:15:30 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A57BD2EC1B1D; Tue, 12 Nov 2019 19:15:27 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 2/3] libbpf: make global data internal arrays mmap()-able, if possible
Date:   Tue, 12 Nov 2019 19:15:17 -0800
Message-ID: <20191113031518.155618-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113031518.155618-1-andriin@fb.com>
References: <20191113031518.155618-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-12_10:2019-11-11,2019-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 mlxscore=0 suspectscore=8 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911130026
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

