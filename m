Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7697723F419
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgHGVGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:06:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726481AbgHGVGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:06:42 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077Ktfnr010398
        for <netdev@vger.kernel.org>; Fri, 7 Aug 2020 14:06:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=exejpQS4Xf210ksgmsXtLC9zPEx/c/WbPnj+Q8tmWsI=;
 b=NUTRVL3ZPqYpVBp8F+LyraN2uibGIiSTuPuNRDiTBLpmxMW0ceEL102fY3pLrd8xlb51
 AAuuEcX58bzyYmjtMFGoU51FROJE7zz0iMoaYsgZHOU3Qb+tfVc5F0lhAXylrVFF9D4P
 huriy2LP0Lg09xWRmclaZFzR1wUFpunNq7U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32qy25mk2p-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:06:41 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 7 Aug 2020 14:06:39 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0AD592EC5494; Fri,  7 Aug 2020 14:06:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 3/7] libbpf: factor out common logic of testing and closing FD
Date:   Fri, 7 Aug 2020 14:06:25 -0700
Message-ID: <20200807210629.394335-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200807210629.394335-1-andriin@fb.com>
References: <20200807210629.394335-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_20:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 suspectscore=9 mlxscore=0 adultscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070147
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
index 8e329c57be51..24c806559867 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3427,6 +3427,13 @@ bpf_object__probe_loading(struct bpf_object *obj)
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
@@ -3445,12 +3452,7 @@ static int probe_kern_prog_name(void)
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
@@ -3490,12 +3492,7 @@ static int probe_kern_global_data(void)
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
@@ -3511,16 +3508,9 @@ static int probe_kern_btf_func(void)
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
@@ -3536,16 +3526,9 @@ static int probe_kern_btf_func_global(void)
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
@@ -3562,16 +3545,9 @@ static int probe_kern_btf_datasec(void)
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
@@ -3583,14 +3559,8 @@ static int probe_kern_array_mmap(void)
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
@@ -3600,7 +3570,6 @@ static int probe_kern_exp_attach_type(void)
 		BPF_MOV64_IMM(BPF_REG_0, 0),
 		BPF_EXIT_INSN(),
 	};
-	int fd;
=20
 	memset(&attr, 0, sizeof(attr));
 	/* use any valid combination of program type and (optional)
@@ -3614,12 +3583,7 @@ static int probe_kern_exp_attach_type(void)
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

