Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3092354C8
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 03:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgHBBca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 21:32:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64632 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727945AbgHBBca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 21:32:30 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0721WQGF001863
        for <netdev@vger.kernel.org>; Sat, 1 Aug 2020 18:32:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dIRQgYPm2Ig0B9ZcNS3cvoWgnUdf0N22Gx5j7REbWhE=;
 b=BoKRvvOeesLfJa4pnQPJkOfb2ZAfz8LfMy9v51/F59Id/LqywGqX1VBO4YlzN6t6Acvy
 QmPN3bRV56MViX2No9VPeeQWZyN25pQFRnE+51bd8ltD/fHqPr29H8nLXVPkU/wRaLxr
 hiCFm5NQsrYbcJzyM4WqpQdbgWb8wzU+gnM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 32n80t1syc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 18:32:29 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 1 Aug 2020 18:32:27 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E7BF32EC50C3; Sat,  1 Aug 2020 18:32:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] libbpf: add btf__parse_raw() and generic btf__parse() APIs
Date:   Sat, 1 Aug 2020 18:32:17 -0700
Message-ID: <20200802013219.864880-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200802013219.864880-1-andriin@fb.com>
References: <20200802013219.864880-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-02_01:2020-07-31,2020-08-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=25 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=798 phishscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008020009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add public APIs to parse BTF from raw data file (e.g.,
/sys/kernel/btf/vmlinux), as well as generic btf__parse(), which will try=
 to
determine correct format, currently either raw or ELF.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c      | 114 ++++++++++++++++++++++++++-------------
 tools/lib/bpf/btf.h      |   5 +-
 tools/lib/bpf/libbpf.map |   2 +
 3 files changed, 83 insertions(+), 38 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index ded5b29965f9..856b09a04563 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -562,6 +562,83 @@ struct btf *btf__parse_elf(const char *path, struct =
btf_ext **btf_ext)
 	return btf;
 }
=20
+struct btf *btf__parse_raw(const char *path)
+{
+	void *data =3D NULL;
+	struct btf *btf;
+	FILE *f =3D NULL;
+	__u16 magic;
+	int err =3D 0;
+	long sz;
+
+	f =3D fopen(path, "rb");
+	if (!f) {
+		err =3D -errno;
+		goto err_out;
+	}
+
+	/* check BTF magic */
+	if (fread(&magic, 1, sizeof(magic), f) < sizeof(magic)) {
+		err =3D -EIO;
+		goto err_out;
+	}
+	if (magic !=3D BTF_MAGIC) {
+		/* definitely not a raw BTF */
+		err =3D -EPROTO;
+		goto err_out;
+	}
+
+	/* get file size */
+	if (fseek(f, 0, SEEK_END)) {
+		err =3D -errno;
+		goto err_out;
+	}
+	sz =3D ftell(f);
+	if (sz < 0) {
+		err =3D -errno;
+		goto err_out;
+	}
+	/* rewind to the start */
+	if (fseek(f, 0, SEEK_SET)) {
+		err =3D -errno;
+		goto err_out;
+	}
+
+	/* pre-alloc memory and read all of BTF data */
+	data =3D malloc(sz);
+	if (!data) {
+		err =3D -ENOMEM;
+		goto err_out;
+	}
+	if (fread(data, 1, sz, f) < sz) {
+		err =3D -EIO;
+		goto err_out;
+	}
+
+	/* finally parse BTF data */
+	btf =3D btf__new(data, sz);
+
+err_out:
+	free(data);
+	if (f)
+		fclose(f);
+	return err ? ERR_PTR(err) : btf;
+}
+
+struct btf *btf__parse(const char *path, struct btf_ext **btf_ext)
+{
+	struct btf *btf;
+
+	if (btf_ext)
+		*btf_ext =3D NULL;
+
+	btf =3D btf__parse_raw(path);
+	if (!IS_ERR(btf) || PTR_ERR(btf) !=3D -EPROTO)
+		return btf;
+
+	return btf__parse_elf(path, btf_ext);
+}
+
 static int compare_vsi_off(const void *_a, const void *_b)
 {
 	const struct btf_var_secinfo *a =3D _a;
@@ -2951,41 +3028,6 @@ static int btf_dedup_remap_types(struct btf_dedup =
*d)
 	return 0;
 }
=20
-static struct btf *btf_load_raw(const char *path)
-{
-	struct btf *btf;
-	size_t read_cnt;
-	struct stat st;
-	void *data;
-	FILE *f;
-
-	if (stat(path, &st))
-		return ERR_PTR(-errno);
-
-	data =3D malloc(st.st_size);
-	if (!data)
-		return ERR_PTR(-ENOMEM);
-
-	f =3D fopen(path, "rb");
-	if (!f) {
-		btf =3D ERR_PTR(-errno);
-		goto cleanup;
-	}
-
-	read_cnt =3D fread(data, 1, st.st_size, f);
-	fclose(f);
-	if (read_cnt < st.st_size) {
-		btf =3D ERR_PTR(-EBADF);
-		goto cleanup;
-	}
-
-	btf =3D btf__new(data, read_cnt);
-
-cleanup:
-	free(data);
-	return btf;
-}
-
 /*
  * Probe few well-known locations for vmlinux kernel image and try to lo=
ad BTF
  * data out of it to use for target BTF.
@@ -3021,7 +3063,7 @@ struct btf *libbpf_find_kernel_btf(void)
 			continue;
=20
 		if (locations[i].raw_btf)
-			btf =3D btf_load_raw(path);
+			btf =3D btf__parse_raw(path);
 		else
 			btf =3D btf__parse_elf(path, NULL);
=20
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 491c7b41ffdc..f4a1a1d2b9a3 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -64,8 +64,9 @@ struct btf_ext_header {
=20
 LIBBPF_API void btf__free(struct btf *btf);
 LIBBPF_API struct btf *btf__new(const void *data, __u32 size);
-LIBBPF_API struct btf *btf__parse_elf(const char *path,
-				      struct btf_ext **btf_ext);
+LIBBPF_API struct btf *btf__parse(const char *path, struct btf_ext **btf=
_ext);
+LIBBPF_API struct btf *btf__parse_elf(const char *path, struct btf_ext *=
*btf_ext);
+LIBBPF_API struct btf *btf__parse_raw(const char *path);
 LIBBPF_API int btf__finalize_data(struct bpf_object *obj, struct btf *bt=
f);
 LIBBPF_API int btf__load(struct btf *btf);
 LIBBPF_API __s32 btf__find_by_name(const struct btf *btf,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index ca49a6a7e5b2..edf6a38807ea 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -291,5 +291,7 @@ LIBBPF_0.1.0 {
 		bpf_program__is_sk_lookup;
 		bpf_program__set_autoload;
 		bpf_program__set_sk_lookup;
+		btf__parse;
+		btf__parse_raw;
 		btf__set_fd;
 } LIBBPF_0.0.9;
--=20
2.24.1

