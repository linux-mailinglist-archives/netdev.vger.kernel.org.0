Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6315E249024
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgHRVeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:34:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726745AbgHRVeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:34:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ILQLLB010540
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:34:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=2T63H5iEs9HmCVlDk6EnrGSsHoawP53c907ry2JY1OU=;
 b=RXJkSqgxyzCwixT/EXVsPfiEg42DrYn8lKkCp5ZLdNJSkAh7MY7c/1UmD30CkOnBQ8CT
 t64H8rsdZ9l9Zzp3+kZrGeTxS7DD5i4LMeJBbDMdgRb0OTJJYN7mgVS0RK+P7kMInieY
 3NreOJulcZbDv4cp5u1WXdevSm0ZTqnaBzU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304paw4u8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:34:10 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 14:34:08 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1CA4F2EC5EAC; Tue, 18 Aug 2020 14:34:08 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/7] libbpf: factor out common logic of testing and closing FD
Date:   Tue, 18 Aug 2020 14:33:52 -0700
Message-ID: <20200818213356.2629020-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818213356.2629020-1-andriin@fb.com>
References: <20200818213356.2629020-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_15:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=9 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out common piece of logic that detects support for a feature based=
 on
successfully created FD. Also take care of closing FD, if it was created.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 70 ++++++++++--------------------------------
 1 file changed, 17 insertions(+), 53 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9cf22361f945..ab0c3a409eea 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3431,6 +3431,13 @@ bpf_object__probe_loading(struct bpf_object *obj)
 	return 0;
 }
=20
+static int probe_fd(int fd)
+{
+	if (fd >=3D 0)
+		close(fd);
+	return fd >=3D 0;
+}
+
 static int probe_kern_prog_name(void)
 {
 	struct bpf_load_program_attr attr;
@@ -3449,12 +3456,7 @@ static int probe_kern_prog_name(void)
 	attr.license =3D "GPL";
 	attr.name =3D "test";
 	ret =3D bpf_load_program_xattr(&attr, NULL, 0);
-	if (ret >=3D 0) {
-		close(ret);
-		return 1;
-	}
-
-	return 0;
+	return probe_fd(ret);
 }
=20
 static int probe_kern_global_data(void)
@@ -3495,12 +3497,7 @@ static int probe_kern_global_data(void)
=20
 	ret =3D bpf_load_program_xattr(&prg_attr, NULL, 0);
 	close(map);
-	if (ret >=3D 0) {
-		close(ret);
-		return 1;
-	}
-
-	return 0;
+	return probe_fd(ret);
 }
=20
 static int probe_kern_btf_func(void)
@@ -3516,16 +3513,9 @@ static int probe_kern_btf_func(void)
 		/* FUNC x */                                    /* [3] */
 		BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0), 2),
 	};
-	int btf_fd;
=20
-	btf_fd =3D libbpf__load_raw_btf((char *)types, sizeof(types),
-				      strs, sizeof(strs));
-	if (btf_fd >=3D 0) {
-		close(btf_fd);
-		return 1;
-	}
-
-	return 0;
+	return probe_fd(libbpf__load_raw_btf((char *)types, sizeof(types),
+					     strs, sizeof(strs)));
 }
=20
 static int probe_kern_btf_func_global(void)
@@ -3541,16 +3531,9 @@ static int probe_kern_btf_func_global(void)
 		/* FUNC x BTF_FUNC_GLOBAL */                    /* [3] */
 		BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, BTF_FUNC_GLOBAL), 2),
 	};
-	int btf_fd;
=20
-	btf_fd =3D libbpf__load_raw_btf((char *)types, sizeof(types),
-				      strs, sizeof(strs));
-	if (btf_fd >=3D 0) {
-		close(btf_fd);
-		return 1;
-	}
-
-	return 0;
+	return probe_fd(libbpf__load_raw_btf((char *)types, sizeof(types),
+					     strs, sizeof(strs)));
 }
=20
 static int probe_kern_btf_datasec(void)
@@ -3567,16 +3550,9 @@ static int probe_kern_btf_datasec(void)
 		BTF_TYPE_ENC(3, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 1), 4),
 		BTF_VAR_SECINFO_ENC(2, 0, 4),
 	};
-	int btf_fd;
=20
-	btf_fd =3D libbpf__load_raw_btf((char *)types, sizeof(types),
-				      strs, sizeof(strs));
-	if (btf_fd >=3D 0) {
-		close(btf_fd);
-		return 1;
-	}
-
-	return 0;
+	return probe_fd(libbpf__load_raw_btf((char *)types, sizeof(types),
+					     strs, sizeof(strs)));
 }
=20
 static int probe_kern_array_mmap(void)
@@ -3588,14 +3564,8 @@ static int probe_kern_array_mmap(void)
 		.value_size =3D sizeof(int),
 		.max_entries =3D 1,
 	};
-	int fd;
=20
-	fd =3D bpf_create_map_xattr(&attr);
-	if (fd >=3D 0) {
-		close(fd);
-		return 1;
-	}
-	return 0;
+	return probe_fd(bpf_create_map_xattr(&attr));
 }
=20
 static int probe_kern_exp_attach_type(void)
@@ -3605,7 +3575,6 @@ static int probe_kern_exp_attach_type(void)
 		BPF_MOV64_IMM(BPF_REG_0, 0),
 		BPF_EXIT_INSN(),
 	};
-	int fd;
=20
 	memset(&attr, 0, sizeof(attr));
 	/* use any valid combination of program type and (optional)
@@ -3619,12 +3588,7 @@ static int probe_kern_exp_attach_type(void)
 	attr.insns_cnt =3D ARRAY_SIZE(insns);
 	attr.license =3D "GPL";
=20
-	fd =3D bpf_load_program_xattr(&attr, NULL, 0);
-	if (fd >=3D 0) {
-		close(fd);
-		return 1;
-	}
-	return 0;
+	return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
 }
=20
 enum kern_feature_result {
--=20
2.24.1

