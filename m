Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B59724902D
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgHRVec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:34:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53832 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726870AbgHRVe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:34:28 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07ILYMOt000900
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:34:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Qba6TtLd7ff/329K8MaTklR0w5dpisYe4n+bCVWlBrk=;
 b=p6EhBSVSAcNiN7gP/z3hKCtXi0PWhN3jwKl7I07qM+3WSTH1HQv8H4c82Glg1h4EzUDl
 twzs1XAgvBh2hWN8iiv9hkBGbRATEFdRvRJTNHWkdQCcjKavswe7mfpY3zc/a3PT3Odx
 tNJRv3Qjv+3JIzulvfGi+31Q3suncgs3cgk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3304jq55sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:34:27 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 14:34:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F23A62EC5EAC; Tue, 18 Aug 2020 14:34:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 7/7] libbpf: detect minimal BTF support and skip BTF loading, if missing
Date:   Tue, 18 Aug 2020 14:33:56 -0700
Message-ID: <20200818213356.2629020-8-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818213356.2629020-1-andriin@fb.com>
References: <20200818213356.2629020-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_15:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 suspectscore=25 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Detect whether a kernel supports any BTF at all, and if not, don't even
attempt loading BTF to avoid unnecessary log messages like:

  libbpf: Error loading BTF: Invalid argument(22)
  libbpf: Error loading .BTF into kernel: -22. BTF is optional, ignoring.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bdc08f89a5c0..5f971796d196 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -170,6 +170,8 @@ enum kern_feature_id {
 	FEAT_PROG_NAME,
 	/* v5.2: kernel support for global data sections. */
 	FEAT_GLOBAL_DATA,
+	/* BTF support */
+	FEAT_BTF,
 	/* BTF_KIND_FUNC and BTF_KIND_FUNC_PROTO support */
 	FEAT_BTF_FUNC,
 	/* BTF_KIND_VAR and BTF_KIND_DATASEC support */
@@ -2533,6 +2535,15 @@ static int bpf_object__sanitize_and_load_btf(struc=
t bpf_object *obj)
 	if (!obj->btf)
 		return 0;
=20
+	if (!kernel_supports(FEAT_BTF)) {
+		if (kernel_needs_btf(obj)) {
+			err =3D -EOPNOTSUPP;
+			goto report;
+		}
+		pr_debug("Kernel doesn't support BTF, skipping uploading it.\n");
+		return 0;
+	}
+
 	sanitize =3D btf_needs_sanitization(obj);
 	if (sanitize) {
 		const void *raw_data;
@@ -2558,6 +2569,7 @@ static int bpf_object__sanitize_and_load_btf(struct=
 bpf_object *obj)
 		}
 		btf__free(kern_btf);
 	}
+report:
 	if (err) {
 		btf_mandatory =3D kernel_needs_btf(obj);
 		pr_warn("Error loading .BTF into kernel: %d. %s\n", err,
@@ -3502,6 +3514,18 @@ static int probe_kern_global_data(void)
 	return probe_fd(ret);
 }
=20
+static int probe_kern_btf(void)
+{
+	static const char strs[] =3D "\0int";
+	__u32 types[] =3D {
+		/* int */
+		BTF_TYPE_INT_ENC(1, BTF_INT_SIGNED, 0, 32, 4),
+	};
+
+	return probe_fd(libbpf__load_raw_btf((char *)types, sizeof(types),
+					     strs, sizeof(strs)));
+}
+
 static int probe_kern_btf_func(void)
 {
 	static const char strs[] =3D "\0int\0x\0a";
@@ -3633,6 +3657,9 @@ static struct kern_feature_desc {
 	[FEAT_GLOBAL_DATA] =3D {
 		"global variables", probe_kern_global_data,
 	},
+	[FEAT_BTF] =3D {
+		"minimal BTF", probe_kern_btf,
+	},
 	[FEAT_BTF_FUNC] =3D {
 		"BTF functions", probe_kern_btf_func,
 	},
--=20
2.24.1

