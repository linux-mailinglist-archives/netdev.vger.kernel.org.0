Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D7F274E61
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 03:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgIWB3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 21:29:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5778 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726921AbgIWB3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 21:29:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N1TVjY004520
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 18:29:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jvqka2tiRGVcgqLbZkf2aIBJpI7JieKM8r2NukqSuXE=;
 b=Ic4Ge345DCkhf6/gZfCPoTAKuldsYYxlQLVOQPbmh1jDvmUD3V3GrYr2CFix5gToknuE
 iKlE10zaZH/5Un1IA9o2ezmjMKU3qzDkWeVDDxu+ulbceasXrcPGnOOqUcHxYIcBvo68
 qE1HA5qLFtNVfbtxaxMR3geAEP+pvZGWXT4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp3rxpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 18:29:31 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 18:28:53 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 96AD862E50A7; Tue, 22 Sep 2020 18:28:52 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf-next 2/3] libbpf: introduce bpf_prog_test_run_xattr_opts
Date:   Tue, 22 Sep 2020 18:28:40 -0700
Message-ID: <20200923012841.2701378-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200923012841.2701378-1-songliubraving@fb.com>
References: <20200923012841.2701378-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_21:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=860
 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This API supports new field cpu_plus in bpf_attr.test.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/bpf.c      | 13 ++++++++++++-
 tools/lib/bpf/bpf.h      | 11 +++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2baa1308737c8..3228dd60fa32f 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -684,7 +684,8 @@ int bpf_prog_test_run(int prog_fd, int repeat, void *=
data, __u32 size,
 	return ret;
 }
=20
-int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
+int bpf_prog_test_run_xattr_opts(struct bpf_prog_test_run_attr *test_att=
r,
+				 const struct bpf_prog_test_run_opts *opts)
 {
 	union bpf_attr attr;
 	int ret;
@@ -693,6 +694,11 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run=
_attr *test_attr)
 		return -EINVAL;
=20
 	memset(&attr, 0, sizeof(attr));
+	if (opts) {
+		if (!OPTS_VALID(opts, bpf_prog_test_run_opts))
+			return -EINVAL;
+		attr.test.cpu_plus =3D opts->cpu_plus;
+	}
 	attr.test.prog_fd =3D test_attr->prog_fd;
 	attr.test.data_in =3D ptr_to_u64(test_attr->data_in);
 	attr.test.data_out =3D ptr_to_u64(test_attr->data_out);
@@ -712,6 +718,11 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run=
_attr *test_attr)
 	return ret;
 }
=20
+int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
+{
+	return bpf_prog_test_run_xattr_opts(test_attr, NULL);
+}
+
 static int bpf_obj_get_next_id(__u32 start_id, __u32 *next_id, int cmd)
 {
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 8c1ac4b42f908..61318f47c8e1b 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -251,6 +251,17 @@ struct bpf_prog_bind_opts {
=20
 LIBBPF_API int bpf_prog_bind_map(int prog_fd, int map_fd,
 				 const struct bpf_prog_bind_opts *opts);
+
+struct bpf_prog_test_run_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 cpu_plus;
+};
+#define bpf_prog_test_run_opts__last_field cpu_plus
+
+LIBBPF_API
+int bpf_prog_test_run_xattr_opts(struct bpf_prog_test_run_attr *test_att=
r,
+				 const struct bpf_prog_test_run_opts *opts);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 5f054dadf0829..c84a8bec57634 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -303,6 +303,7 @@ LIBBPF_0.1.0 {
 LIBBPF_0.2.0 {
 	global:
 		bpf_prog_bind_map;
+		bpf_prog_test_run_xattr_opts;
 		bpf_program__section_name;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
--=20
2.24.1

