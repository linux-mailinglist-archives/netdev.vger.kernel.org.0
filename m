Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CABE72D32A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 03:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfE2BOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 21:14:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39530 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726225AbfE2BOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 21:14:44 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4T1Ba42009519
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=DhGpjBrXl8oTq83Xjbib56/xXIEmD5STS4XKY0B7c9s=;
 b=kCZZMIOTnJLP/KDimcKAMjDfv1yYzLSXcbOzhQ5tuIgt0QoxcwewWsJ5ZsXDrPzoHzk0
 CzS+6unMXlgRvN/x0Bvo7jEGAaLZf3kFcQw9dadZ8w3+fheUpLGd5wjvgzkX5Jg/D+ZU
 Y8uJnZ8CRZjF+pNyV0woy5Y9YFfl3THfFu4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2ss7tv1uny-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:42 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 18:14:42 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 211EA8617AA; Tue, 28 May 2019 18:14:41 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 6/9] libbpf: use negative fd to specify missing BTF
Date:   Tue, 28 May 2019 18:14:23 -0700
Message-ID: <20190529011426.1328736-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529011426.1328736-1-andriin@fb.com>
References: <20190529011426.1328736-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0 is a valid FD, so it's better to initialize it to -1, as is done in
other places. Also, technically, BTF type ID 0 is valid (it's a VOID
type), so it's more reliable to check btf_fd, instead of
btf_key_type_id, to determine if there is any BTF associated with a map.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9c45856e7fd6..292ea9a2dc3d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1751,7 +1751,7 @@ bpf_object__create_maps(struct bpf_object *obj)
 		create_attr.key_size = def->key_size;
 		create_attr.value_size = def->value_size;
 		create_attr.max_entries = def->max_entries;
-		create_attr.btf_fd = 0;
+		create_attr.btf_fd = -1;
 		create_attr.btf_key_type_id = 0;
 		create_attr.btf_value_type_id = 0;
 		if (bpf_map_type__is_map_in_map(def->type) &&
@@ -1765,11 +1765,11 @@ bpf_object__create_maps(struct bpf_object *obj)
 		}
 
 		*pfd = bpf_create_map_xattr(&create_attr);
-		if (*pfd < 0 && create_attr.btf_key_type_id) {
+		if (*pfd < 0 && create_attr.btf_fd >= 0) {
 			cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
 			pr_warning("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n",
 				   map->name, cp, errno);
-			create_attr.btf_fd = 0;
+			create_attr.btf_fd = -1;
 			create_attr.btf_key_type_id = 0;
 			create_attr.btf_value_type_id = 0;
 			map->btf_key_type_id = 0;
@@ -2053,6 +2053,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	char *log_buf;
 	int ret;
 
+	if (!insns || !insns_cnt)
+		return -EINVAL;
+
 	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
 	load_attr.prog_type = prog->type;
 	load_attr.expected_attach_type = prog->expected_attach_type;
@@ -2063,7 +2066,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.license = license;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
-	load_attr.prog_btf_fd = prog->btf_fd >= 0 ? prog->btf_fd : 0;
+	load_attr.prog_btf_fd = prog->btf_fd;
 	load_attr.func_info = prog->func_info;
 	load_attr.func_info_rec_size = prog->func_info_rec_size;
 	load_attr.func_info_cnt = prog->func_info_cnt;
@@ -2072,8 +2075,6 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.line_info_cnt = prog->line_info_cnt;
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
-	if (!load_attr.insns || !load_attr.insns_cnt)
-		return -EINVAL;
 
 retry_load:
 	log_buf = malloc(log_buf_size);
-- 
2.17.1

