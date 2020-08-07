Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A1D23F422
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgHGVHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:07:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50904 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbgHGVG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:06:59 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077Ku7Jb000456
        for <netdev@vger.kernel.org>; Fri, 7 Aug 2020 14:06:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/oZ6shCQSQWN3T4QPgd0SFha9QHU1u6WOy3MMq95hNQ=;
 b=EAVIS18Kg4bu0W2OM8YhLIZsgjog0byudOfBWBa/ilnbW9ibcKy02NLnBj8Wjq011eq+
 wPmfJo4+QE4y+2rVazLOkeZJTf4pNz8GqAxI0OdY4ukFnGhl49VrDU7tXqkwbolX2mEV
 34vTpjhMG7NzklgwMEb7PTOYZC3Vs16e94g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32rvwf4ga3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:06:58 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 7 Aug 2020 14:06:57 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C75692EC5494; Fri,  7 Aug 2020 14:06:47 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 7/7] libbpf: detect minimal BTF support and skip BTF loading, if missing
Date:   Fri, 7 Aug 2020 14:06:29 -0700
Message-ID: <20200807210629.394335-8-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200807210629.394335-1-andriin@fb.com>
References: <20200807210629.394335-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_20:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=25 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008070147
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
index 32c71a3b3aef..b4d2fd13ad42 100644
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
@@ -2531,6 +2533,15 @@ static int bpf_object__sanitize_and_load_btf(struc=
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
@@ -2554,6 +2565,7 @@ static int bpf_object__sanitize_and_load_btf(struct=
 bpf_object *obj)
 		}
 		btf__free(kern_btf);
 	}
+report:
 	if (err) {
 		btf_mandatory =3D kernel_needs_btf(obj);
 		pr_warn("Error loading .BTF into kernel: %d. %s\n", err,
@@ -3497,6 +3509,18 @@ static int probe_kern_global_data(void)
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
@@ -3628,6 +3652,9 @@ static struct kern_feature_desc {
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

