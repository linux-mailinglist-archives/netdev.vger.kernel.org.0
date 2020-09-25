Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CF12792BD
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgIYUzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:55:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbgIYUzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:55:04 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PKt2LE012698
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 13:55:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=WqwVJQ15qXef5bizheAVJGHf7CkcYkS1/DuR9WoX+Mc=;
 b=dk9aEbZ66o0efvqnjlN8eJMQAF+KOTaZLQ/OnoU5devczrF/g4wcv7yqrtDzJ0rHldfw
 DEX5J5yZRs1qWOI7TFDfS0rFGzSUUTcGvI1MrS4fSIGcNZbFpblunX21p3UQiQH6C8NT
 z4/5QQPJEryeDJQjWtGpGa0HRbjYsTggY48= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp71rs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 13:55:02 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 13:54:47 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id D268F62E54A2; Fri, 25 Sep 2020 13:54:44 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v6 bpf-next 2/3] libbpf: support test run of raw tracepoint programs
Date:   Fri, 25 Sep 2020 13:54:30 -0700
Message-ID: <20200925205432.1777-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925205432.1777-1-songliubraving@fb.com>
References: <20200925205432.1777-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250151
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_prog_test_run_opts() with support of new fields in bpf_attr.test,
namely, flags and cpu. Also extend _opts operations to support outputs vi=
a
opts.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/bpf.c             | 31 +++++++++++++++++++++++++++++++
 tools/lib/bpf/bpf.h             | 26 ++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.map        |  1 +
 tools/lib/bpf/libbpf_internal.h |  5 +++++
 4 files changed, 63 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2baa1308737c8..c5a4d8444bf68 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -712,6 +712,37 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run=
_attr *test_attr)
 	return ret;
 }
=20
+int bpf_prog_test_run_opts(int prog_fd, struct bpf_test_run_opts *opts)
+{
+	union bpf_attr attr;
+	int ret;
+
+	if (!OPTS_VALID(opts, bpf_test_run_opts))
+		return -EINVAL;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.test.prog_fd =3D prog_fd;
+	attr.test.cpu =3D OPTS_GET(opts, cpu, 0);
+	attr.test.flags =3D OPTS_GET(opts, flags, 0);
+	attr.test.repeat =3D OPTS_GET(opts, repeat, 0);
+	attr.test.duration =3D OPTS_GET(opts, duration, 0);
+	attr.test.ctx_size_in =3D OPTS_GET(opts, ctx_size_in, 0);
+	attr.test.ctx_size_out =3D OPTS_GET(opts, ctx_size_out, 0);
+	attr.test.data_size_in =3D OPTS_GET(opts, data_size_in, 0);
+	attr.test.data_size_out =3D OPTS_GET(opts, data_size_out, 0);
+	attr.test.ctx_in =3D ptr_to_u64(OPTS_GET(opts, ctx_in, NULL));
+	attr.test.ctx_out =3D ptr_to_u64(OPTS_GET(opts, ctx_out, NULL));
+	attr.test.data_in =3D ptr_to_u64(OPTS_GET(opts, data_in, NULL));
+	attr.test.data_out =3D ptr_to_u64(OPTS_GET(opts, data_out, NULL));
+
+	ret =3D sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
+	OPTS_SET(opts, data_size_out, attr.test.data_size_out);
+	OPTS_SET(opts, ctx_size_out, attr.test.ctx_size_out);
+	OPTS_SET(opts, duration, attr.test.duration);
+	OPTS_SET(opts, retval, attr.test.retval);
+	return ret;
+}
+
 static int bpf_obj_get_next_id(__u32 start_id, __u32 *next_id, int cmd)
 {
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 8c1ac4b42f908..4f3568e55527c 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -251,6 +251,32 @@ struct bpf_prog_bind_opts {
=20
 LIBBPF_API int bpf_prog_bind_map(int prog_fd, int map_fd,
 				 const struct bpf_prog_bind_opts *opts);
+
+struct bpf_test_run_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	const void *data_in; /* optional */
+	void *data_out;      /* optional */
+	__u32 data_size_in;
+	__u32 data_size_out; /* in: max length of data_out
+			      * out: length of data_out
+			      */
+	const void *ctx_in; /* optional */
+	void *ctx_out;      /* optional */
+	__u32 ctx_size_in;
+	__u32 ctx_size_out; /* in: max length of ctx_out
+			     * out: length of cxt_out
+			     */
+	__u32 retval;        /* out: return code of the BPF program */
+	int repeat;
+	__u32 duration;      /* out: average per repetition in ns */
+	__u32 flags;
+	__u32 cpu;
+};
+#define bpf_test_run_opts__last_field cpu
+
+LIBBPF_API int bpf_prog_test_run_opts(int prog_fd,
+				      struct bpf_test_run_opts *opts);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 5f054dadf0829..0623e7a99b1ec 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -303,6 +303,7 @@ LIBBPF_0.1.0 {
 LIBBPF_0.2.0 {
 	global:
 		bpf_prog_bind_map;
+		bpf_prog_test_run_opts;
 		bpf_program__section_name;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index 4d1c366fca2ca..d2fff18f4cd12 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -136,6 +136,11 @@ static inline bool libbpf_validate_opts(const char *=
opts,
 	((opts) && opts->sz >=3D offsetofend(typeof(*(opts)), field))
 #define OPTS_GET(opts, field, fallback_value) \
 	(OPTS_HAS(opts, field) ? (opts)->field : fallback_value)
+#define OPTS_SET(opts, field, value)		\
+	do {					\
+		if (OPTS_HAS(opts, field))	\
+			(opts)->field =3D value;	\
+	} while (0)
=20
 int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz);
 int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz);
--=20
2.24.1

