Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1CA38F920
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 05:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhEYEBZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 May 2021 00:01:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230162AbhEYEBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 00:01:20 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14P3hwpt031176
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 20:59:51 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38rr050f3s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 20:59:50 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 20:59:49 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F33822EDBE05; Mon, 24 May 2021 20:59:44 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH v2 bpf-next 3/5] libbpf: streamline error reporting for low-level APIs
Date:   Mon, 24 May 2021 20:59:33 -0700
Message-ID: <20210525035935.1461796-4-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210525035935.1461796-1-andrii@kernel.org>
References: <20210525035935.1461796-1-andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-Proofpoint-GUID: n4P9ii39cjC-regzVl7r3KkFdWCtl0Ul
X-Proofpoint-ORIG-GUID: n4P9ii39cjC-regzVl7r3KkFdWCtl0Ul
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_02:2021-05-24,2021-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 priorityscore=1501 clxscore=1034 suspectscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that low-level APIs behave uniformly across the libbpf as follows:
  - in case of an error, errno is always set to the correct error code;
  - when libbpf 1.0 mode is enabled with LIBBPF_STRICT_DIRECT_ERRS option to
    libbpf_set_strict_mode(), return -Exxx error value directly, instead of -1;
  - by default, until libbpf 1.0 is released, keep returning -1 directly.

More context, justification, and discussion can be found in "Libbpf: the road
to v1.0" document ([0]).

  [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf.c             | 168 ++++++++++++++++++++++----------
 tools/lib/bpf/libbpf_internal.h |  26 +++++
 tools/lib/bpf/libbpf_legacy.h   |  12 +++
 3 files changed, 156 insertions(+), 50 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index b7c2cc12034c..86dcac44f32f 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -80,6 +80,7 @@ static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size)
 int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, '\0', sizeof(attr));
 
@@ -102,7 +103,8 @@ int bpf_create_map_xattr(const struct bpf_create_map_attr *create_attr)
 	else
 		attr.inner_map_fd = create_attr->inner_map_fd;
 
-	return sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_create_map_node(enum bpf_map_type map_type, const char *name,
@@ -160,6 +162,7 @@ int bpf_create_map_in_map_node(enum bpf_map_type map_type, const char *name,
 			       __u32 map_flags, int node)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, '\0', sizeof(attr));
 
@@ -178,7 +181,8 @@ int bpf_create_map_in_map_node(enum bpf_map_type map_type, const char *name,
 		attr.numa_node = node;
 	}
 
-	return sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_create_map_in_map(enum bpf_map_type map_type, const char *name,
@@ -222,10 +226,10 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 	int fd;
 
 	if (!load_attr->log_buf != !load_attr->log_buf_sz)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	if (load_attr->log_level > (4 | 2 | 1) || (load_attr->log_level && !load_attr->log_buf))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = load_attr->prog_type;
@@ -281,8 +285,10 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 							load_attr->func_info_cnt,
 							load_attr->func_info_rec_size,
 							attr.func_info_rec_size);
-			if (!finfo)
+			if (!finfo) {
+				errno = E2BIG;
 				goto done;
+			}
 
 			attr.func_info = ptr_to_u64(finfo);
 			attr.func_info_rec_size = load_attr->func_info_rec_size;
@@ -293,8 +299,10 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 							load_attr->line_info_cnt,
 							load_attr->line_info_rec_size,
 							attr.line_info_rec_size);
-			if (!linfo)
+			if (!linfo) {
+				errno = E2BIG;
 				goto done;
+			}
 
 			attr.line_info = ptr_to_u64(linfo);
 			attr.line_info_rec_size = load_attr->line_info_rec_size;
@@ -318,9 +326,10 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 
 	fd = sys_bpf_prog_load(&attr, sizeof(attr));
 done:
+	/* free() doesn't affect errno, so we don't need to restore it */
 	free(finfo);
 	free(linfo);
-	return fd;
+	return libbpf_err_errno(fd);
 }
 
 int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
@@ -329,7 +338,7 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	struct bpf_prog_load_params p = {};
 
 	if (!load_attr || !log_buf != !log_buf_sz)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	p.prog_type = load_attr->prog_type;
 	p.expected_attach_type = load_attr->expected_attach_type;
@@ -391,6 +400,7 @@ int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 		       int log_level)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = type;
@@ -404,13 +414,15 @@ int bpf_verify_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 	attr.kern_version = kern_version;
 	attr.prog_flags = prog_flags;
 
-	return sys_bpf_prog_load(&attr, sizeof(attr));
+	fd = sys_bpf_prog_load(&attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_map_update_elem(int fd, const void *key, const void *value,
 			__u64 flags)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_fd = fd;
@@ -418,24 +430,28 @@ int bpf_map_update_elem(int fd, const void *key, const void *value,
 	attr.value = ptr_to_u64(value);
 	attr.flags = flags;
 
-	return sys_bpf(BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_map_lookup_elem(int fd, const void *key, void *value)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_fd = fd;
 	attr.key = ptr_to_u64(key);
 	attr.value = ptr_to_u64(value);
 
-	return sys_bpf(BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_map_lookup_elem_flags(int fd, const void *key, void *value, __u64 flags)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_fd = fd;
@@ -443,19 +459,22 @@ int bpf_map_lookup_elem_flags(int fd, const void *key, void *value, __u64 flags)
 	attr.value = ptr_to_u64(value);
 	attr.flags = flags;
 
-	return sys_bpf(BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_map_lookup_and_delete_elem(int fd, const void *key, void *value)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_fd = fd;
 	attr.key = ptr_to_u64(key);
 	attr.value = ptr_to_u64(value);
 
-	return sys_bpf(BPF_MAP_LOOKUP_AND_DELETE_ELEM, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_MAP_LOOKUP_AND_DELETE_ELEM, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_map_lookup_and_delete_elem_flags(int fd, const void *key, void *value, __u64 flags)
@@ -474,34 +493,40 @@ int bpf_map_lookup_and_delete_elem_flags(int fd, const void *key, void *value, _
 int bpf_map_delete_elem(int fd, const void *key)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_fd = fd;
 	attr.key = ptr_to_u64(key);
 
-	return sys_bpf(BPF_MAP_DELETE_ELEM, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_MAP_DELETE_ELEM, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_map_get_next_key(int fd, const void *key, void *next_key)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_fd = fd;
 	attr.key = ptr_to_u64(key);
 	attr.next_key = ptr_to_u64(next_key);
 
-	return sys_bpf(BPF_MAP_GET_NEXT_KEY, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_MAP_GET_NEXT_KEY, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_map_freeze(int fd)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_fd = fd;
 
-	return sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
@@ -513,7 +538,7 @@ static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
 	int ret;
 
 	if (!OPTS_VALID(opts, bpf_map_batch_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.batch.map_fd = fd;
@@ -528,7 +553,7 @@ static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
 	ret = sys_bpf(cmd, &attr, sizeof(attr));
 	*count = attr.batch.count;
 
-	return ret;
+	return libbpf_err_errno(ret);
 }
 
 int bpf_map_delete_batch(int fd, void *keys, __u32 *count,
@@ -565,22 +590,26 @@ int bpf_map_update_batch(int fd, void *keys, void *values, __u32 *count,
 int bpf_obj_pin(int fd, const char *pathname)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.pathname = ptr_to_u64((void *)pathname);
 	attr.bpf_fd = fd;
 
-	return sys_bpf(BPF_OBJ_PIN, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_OBJ_PIN, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_obj_get(const char *pathname)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.pathname = ptr_to_u64((void *)pathname);
 
-	return sys_bpf(BPF_OBJ_GET, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_OBJ_GET, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type,
@@ -598,9 +627,10 @@ int bpf_prog_attach_xattr(int prog_fd, int target_fd,
 			  const struct bpf_prog_attach_opts *opts)
 {
 	union bpf_attr attr;
+	int ret;
 
 	if (!OPTS_VALID(opts, bpf_prog_attach_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.target_fd	   = target_fd;
@@ -609,30 +639,35 @@ int bpf_prog_attach_xattr(int prog_fd, int target_fd,
 	attr.attach_flags  = OPTS_GET(opts, flags, 0);
 	attr.replace_bpf_fd = OPTS_GET(opts, replace_prog_fd, 0);
 
-	return sys_bpf(BPF_PROG_ATTACH, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_PROG_ATTACH, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_prog_detach(int target_fd, enum bpf_attach_type type)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.target_fd	 = target_fd;
 	attr.attach_type = type;
 
-	return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.target_fd	 = target_fd;
 	attr.attach_bpf_fd = prog_fd;
 	attr.attach_type = type;
 
-	return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_link_create(int prog_fd, int target_fd,
@@ -641,15 +676,16 @@ int bpf_link_create(int prog_fd, int target_fd,
 {
 	__u32 target_btf_id, iter_info_len;
 	union bpf_attr attr;
+	int fd;
 
 	if (!OPTS_VALID(opts, bpf_link_create_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	iter_info_len = OPTS_GET(opts, iter_info_len, 0);
 	target_btf_id = OPTS_GET(opts, target_btf_id, 0);
 
 	if (iter_info_len && target_btf_id)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.link_create.prog_fd = prog_fd;
@@ -665,26 +701,30 @@ int bpf_link_create(int prog_fd, int target_fd,
 		attr.link_create.target_btf_id = target_btf_id;
 	}
 
-	return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_link_detach(int link_fd)
 {
 	union bpf_attr attr;
+	int ret;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.link_detach.link_fd = link_fd;
 
-	return sys_bpf(BPF_LINK_DETACH, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_LINK_DETACH, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_link_update(int link_fd, int new_prog_fd,
 		    const struct bpf_link_update_opts *opts)
 {
 	union bpf_attr attr;
+	int ret;
 
 	if (!OPTS_VALID(opts, bpf_link_update_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.link_update.link_fd = link_fd;
@@ -692,17 +732,20 @@ int bpf_link_update(int link_fd, int new_prog_fd,
 	attr.link_update.flags = OPTS_GET(opts, flags, 0);
 	attr.link_update.old_prog_fd = OPTS_GET(opts, old_prog_fd, 0);
 
-	return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
 
 int bpf_iter_create(int link_fd)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.iter_create.link_fd = link_fd;
 
-	return sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
@@ -719,10 +762,12 @@ int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
 	attr.query.prog_ids	= ptr_to_u64(prog_ids);
 
 	ret = sys_bpf(BPF_PROG_QUERY, &attr, sizeof(attr));
+
 	if (attach_flags)
 		*attach_flags = attr.query.attach_flags;
 	*prog_cnt = attr.query.prog_cnt;
-	return ret;
+
+	return libbpf_err_errno(ret);
 }
 
 int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
@@ -740,13 +785,15 @@ int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
 	attr.test.repeat = repeat;
 
 	ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
+
 	if (size_out)
 		*size_out = attr.test.data_size_out;
 	if (retval)
 		*retval = attr.test.retval;
 	if (duration)
 		*duration = attr.test.duration;
-	return ret;
+
+	return libbpf_err_errno(ret);
 }
 
 int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
@@ -755,7 +802,7 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
 	int ret;
 
 	if (!test_attr->data_out && test_attr->data_size_out > 0)
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.test.prog_fd = test_attr->prog_fd;
@@ -770,11 +817,13 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
 	attr.test.repeat = test_attr->repeat;
 
 	ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
+
 	test_attr->data_size_out = attr.test.data_size_out;
 	test_attr->ctx_size_out = attr.test.ctx_size_out;
 	test_attr->retval = attr.test.retval;
 	test_attr->duration = attr.test.duration;
-	return ret;
+
+	return libbpf_err_errno(ret);
 }
 
 int bpf_prog_test_run_opts(int prog_fd, struct bpf_test_run_opts *opts)
@@ -783,7 +832,7 @@ int bpf_prog_test_run_opts(int prog_fd, struct bpf_test_run_opts *opts)
 	int ret;
 
 	if (!OPTS_VALID(opts, bpf_test_run_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.test.prog_fd = prog_fd;
@@ -801,11 +850,13 @@ int bpf_prog_test_run_opts(int prog_fd, struct bpf_test_run_opts *opts)
 	attr.test.data_out = ptr_to_u64(OPTS_GET(opts, data_out, NULL));
 
 	ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
+
 	OPTS_SET(opts, data_size_out, attr.test.data_size_out);
 	OPTS_SET(opts, ctx_size_out, attr.test.ctx_size_out);
 	OPTS_SET(opts, duration, attr.test.duration);
 	OPTS_SET(opts, retval, attr.test.retval);
-	return ret;
+
+	return libbpf_err_errno(ret);
 }
 
 static int bpf_obj_get_next_id(__u32 start_id, __u32 *next_id, int cmd)
@@ -820,7 +871,7 @@ static int bpf_obj_get_next_id(__u32 start_id, __u32 *next_id, int cmd)
 	if (!err)
 		*next_id = attr.next_id;
 
-	return err;
+	return libbpf_err_errno(err);
 }
 
 int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id)
@@ -846,41 +897,49 @@ int bpf_link_get_next_id(__u32 start_id, __u32 *next_id)
 int bpf_prog_get_fd_by_id(__u32 id)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_id = id;
 
-	return sys_bpf(BPF_PROG_GET_FD_BY_ID, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_PROG_GET_FD_BY_ID, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_map_get_fd_by_id(__u32 id)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.map_id = id;
 
-	return sys_bpf(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_btf_get_fd_by_id(__u32 id)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.btf_id = id;
 
-	return sys_bpf(BPF_BTF_GET_FD_BY_ID, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_BTF_GET_FD_BY_ID, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_link_get_fd_by_id(__u32 id)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.link_id = id;
 
-	return sys_bpf(BPF_LINK_GET_FD_BY_ID, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_LINK_GET_FD_BY_ID, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len)
@@ -894,21 +953,24 @@ int bpf_obj_get_info_by_fd(int bpf_fd, void *info, __u32 *info_len)
 	attr.info.info = ptr_to_u64(info);
 
 	err = sys_bpf(BPF_OBJ_GET_INFO_BY_FD, &attr, sizeof(attr));
+
 	if (!err)
 		*info_len = attr.info.info_len;
 
-	return err;
+	return libbpf_err_errno(err);
 }
 
 int bpf_raw_tracepoint_open(const char *name, int prog_fd)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.raw_tracepoint.name = ptr_to_u64(name);
 	attr.raw_tracepoint.prog_fd = prog_fd;
 
-	return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_size,
@@ -928,12 +990,13 @@ int bpf_load_btf(const void *btf, __u32 btf_size, char *log_buf, __u32 log_buf_s
 	}
 
 	fd = sys_bpf(BPF_BTF_LOAD, &attr, sizeof(attr));
-	if (fd == -1 && !do_log && log_buf && log_buf_size) {
+
+	if (fd < 0 && !do_log && log_buf && log_buf_size) {
 		do_log = true;
 		goto retry;
 	}
 
-	return fd;
+	return libbpf_err_errno(fd);
 }
 
 int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf, __u32 *buf_len,
@@ -950,37 +1013,42 @@ int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf, __u32 *buf_len,
 	attr.task_fd_query.buf_len = *buf_len;
 
 	err = sys_bpf(BPF_TASK_FD_QUERY, &attr, sizeof(attr));
+
 	*buf_len = attr.task_fd_query.buf_len;
 	*prog_id = attr.task_fd_query.prog_id;
 	*fd_type = attr.task_fd_query.fd_type;
 	*probe_offset = attr.task_fd_query.probe_offset;
 	*probe_addr = attr.task_fd_query.probe_addr;
 
-	return err;
+	return libbpf_err_errno(err);
 }
 
 int bpf_enable_stats(enum bpf_stats_type type)
 {
 	union bpf_attr attr;
+	int fd;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.enable_stats.type = type;
 
-	return sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
+	fd = sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
+	return libbpf_err_errno(fd);
 }
 
 int bpf_prog_bind_map(int prog_fd, int map_fd,
 		      const struct bpf_prog_bind_opts *opts)
 {
 	union bpf_attr attr;
+	int ret;
 
 	if (!OPTS_VALID(opts, bpf_prog_bind_opts))
-		return -EINVAL;
+		return libbpf_err(-EINVAL);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_bind_map.prog_fd = prog_fd;
 	attr.prog_bind_map.map_fd = map_fd;
 	attr.prog_bind_map.flags = OPTS_GET(opts, flags, 0);
 
-	return sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
+	ret = sys_bpf(BPF_PROG_BIND_MAP, &attr, sizeof(attr));
+	return libbpf_err_errno(ret);
 }
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 55d9b4dca64f..04a0cc8da06e 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -11,6 +11,9 @@
 
 #include <stdlib.h>
 #include <limits.h>
+#include <errno.h>
+#include <linux/err.h>
+#include "libbpf_legacy.h"
 
 /* make sure libbpf doesn't use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
@@ -430,4 +433,27 @@ int btf_type_visit_str_offs(struct btf_type *t, str_off_visit_fn visit, void *ct
 int btf_ext_visit_type_ids(struct btf_ext *btf_ext, type_id_visit_fn visit, void *ctx);
 int btf_ext_visit_str_offs(struct btf_ext *btf_ext, str_off_visit_fn visit, void *ctx);
 
+extern enum libbpf_strict_mode libbpf_mode;
+
+/* handle direct returned errors */
+static inline int libbpf_err(int ret)
+{
+	if (ret < 0)
+		errno = -ret;
+	return ret;
+}
+
+/* handle errno-based (e.g., syscall or libc) errors according to libbpf's
+ * strict mode settings
+ */
+static inline int libbpf_err_errno(int ret)
+{
+	if (libbpf_mode & LIBBPF_STRICT_DIRECT_ERRS)
+		/* errno is already assumed to be set on error */
+		return ret < 0 ? -errno : ret;
+
+	/* legacy: on error return -1 directly and don't touch errno */
+	return ret;
+}
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/libbpf_legacy.h b/tools/lib/bpf/libbpf_legacy.h
index 7482cfe22ab2..df0d03dcffab 100644
--- a/tools/lib/bpf/libbpf_legacy.h
+++ b/tools/lib/bpf/libbpf_legacy.h
@@ -33,6 +33,18 @@ enum libbpf_strict_mode {
 	 * code so that it handles LIBBPF_STRICT_ALL mode before libbpf v1.0.
 	 */
 	LIBBPF_STRICT_NONE = 0x00,
+	/*
+	 * Return NULL pointers on error, not ERR_PTR(err).
+	 * Additionally, libbpf also always sets errno to corresponding Exx
+	 * (positive) error code.
+	 */
+	LIBBPF_STRICT_CLEAN_PTRS = 0x01,
+	/*
+	 * Return actual error codes from low-level APIs directly, not just -1.
+	 * Additionally, libbpf also always sets errno to corresponding Exx
+	 * (positive) error code.
+	 */
+	LIBBPF_STRICT_DIRECT_ERRS = 0x02,
 
 	__LIBBPF_STRICT_LAST,
 };
-- 
2.30.2

