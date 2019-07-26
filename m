Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07BF677368
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfGZVZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:25:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21412 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728162AbfGZVZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:25:00 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6QLGg98019778
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 14:24:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=GI7epV/4an4omYx2lqaRoB42fVZYo/OIOREpVv0zfeU=;
 b=PUp08BnFc7DSIAbncU8K3Hl/1gCJSVlJsh1s34NqawW3vh9cYsdH8cKPc0faZK+Jy6GG
 CZFApprtzUVWlvmVta6JOiVU5pFZVPv03up4COnYL7YUNd973agrSn1n+lW6Fp+E+Ph4
 AD5JhgKx87FzVIn8eS/Uw+1JnEC7hRU+FNQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2u04gfs6ny-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 14:24:58 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 14:24:57 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E76A6861663; Fri, 26 Jul 2019 14:24:56 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] libbpf: fix erroneous multi-closing of BTF FD
Date:   Fri, 26 Jul 2019 14:24:38 -0700
Message-ID: <20190726212438.1269599-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260241
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf stores associated BTF FD per each instance of bpf_program. When
program is unloaded, that FD is closed. This is wrong, because leads to
a race and possibly closing of unrelated files, if application
simultaneously opens new files while bpf_programs are unloaded.

It's also unnecessary, because struct btf "owns" that FD, and
btf__free(), called from bpf_object__close() will close it. Thus the fix
is to never have per-program BTF FD and fetch it from obj->btf, when
necessary.

Fixes: 2993e0515bb4 ("tools/bpf: add support to read .BTF.ext sections")
Reported-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8741c39adb1c..44a428378d48 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -181,7 +181,6 @@ struct bpf_program {
 	bpf_program_clear_priv_t clear_priv;
 
 	enum bpf_attach_type expected_attach_type;
-	int btf_fd;
 	void *func_info;
 	__u32 func_info_rec_size;
 	__u32 func_info_cnt;
@@ -312,7 +311,6 @@ void bpf_program__unload(struct bpf_program *prog)
 	prog->instances.nr = -1;
 	zfree(&prog->instances.fds);
 
-	zclose(prog->btf_fd);
 	zfree(&prog->func_info);
 	zfree(&prog->line_info);
 }
@@ -391,7 +389,6 @@ bpf_program__init(void *data, size_t size, char *section_name, int idx,
 	prog->instances.fds = NULL;
 	prog->instances.nr = -1;
 	prog->type = BPF_PROG_TYPE_UNSPEC;
-	prog->btf_fd = -1;
 
 	return 0;
 errout:
@@ -2283,9 +2280,6 @@ bpf_program_reloc_btf_ext(struct bpf_program *prog, struct bpf_object *obj,
 		prog->line_info_rec_size = btf_ext__line_info_rec_size(obj->btf_ext);
 	}
 
-	if (!insn_offset)
-		prog->btf_fd = btf__fd(obj->btf);
-
 	return 0;
 }
 
@@ -2458,7 +2452,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int log_buf_size = BPF_LOG_BUF_SIZE;
 	char *log_buf;
-	int ret;
+	int btf_fd, ret;
 
 	if (!insns || !insns_cnt)
 		return -EINVAL;
@@ -2473,7 +2467,8 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.license = license;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
-	load_attr.prog_btf_fd = prog->btf_fd >= 0 ? prog->btf_fd : 0;
+	btf_fd = bpf_object__btf_fd(prog->obj);
+	load_attr.prog_btf_fd = btf_fd >= 0 ? btf_fd : 0;
 	load_attr.func_info = prog->func_info;
 	load_attr.func_info_rec_size = prog->func_info_rec_size;
 	load_attr.func_info_cnt = prog->func_info_cnt;
-- 
2.17.1

