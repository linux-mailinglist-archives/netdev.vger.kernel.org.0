Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09782354CE
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 03:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHBBdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 21:33:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15402 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727058AbgHBBdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 21:33:08 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0721X7eh000616
        for <netdev@vger.kernel.org>; Sat, 1 Aug 2020 18:33:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PanqNMzEtSuUeGcMc/l/EAz0nB+82neT9PLhQBzBWl8=;
 b=m9GSJ3LhMpqGtzgGRP7xCpjtfChbQ+vRS9EB74tA8r+mtSEBPlPYfqFDCeDTRIrQmDZW
 1uIQFd8nPBKoKAD8tHxb2ioBO6gC4OPz2P5FYjdmm/Sv4uS5+EcwINvSG2+H5ZioBFCb
 aJOxQAr9NU2mjuVl3Ug0/MpIGoo9see7Wng= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32n7u5st13-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 18:33:07 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 1 Aug 2020 18:32:30 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1A4462EC50C3; Sat,  1 Aug 2020 18:32:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] tools/bpftool: use libbpf's btf__parse() API for parsing BTF from file
Date:   Sat, 1 Aug 2020 18:32:18 -0700
Message-ID: <20200802013219.864880-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200802013219.864880-1-andriin@fb.com>
References: <20200802013219.864880-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-02_01:2020-07-31,2020-08-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 impostorscore=0 phishscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 suspectscore=25 mlxlogscore=861 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008020010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use generic libbpf API to parse BTF data from file, instead of re-impleme=
nting
it in bpftool.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/btf.c | 54 +----------------------------------------
 1 file changed, 1 insertion(+), 53 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index fc9bc7a23db6..42d1df2c1939 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -422,54 +422,6 @@ static int dump_btf_c(const struct btf *btf,
 	return err;
 }
=20
-static struct btf *btf__parse_raw(const char *file)
-{
-	struct btf *btf;
-	struct stat st;
-	__u8 *buf;
-	FILE *f;
-
-	if (stat(file, &st))
-		return NULL;
-
-	f =3D fopen(file, "rb");
-	if (!f)
-		return NULL;
-
-	buf =3D malloc(st.st_size);
-	if (!buf) {
-		btf =3D ERR_PTR(-ENOMEM);
-		goto exit_close;
-	}
-
-	if ((size_t) st.st_size !=3D fread(buf, 1, st.st_size, f)) {
-		btf =3D ERR_PTR(-EINVAL);
-		goto exit_free;
-	}
-
-	btf =3D btf__new(buf, st.st_size);
-
-exit_free:
-	free(buf);
-exit_close:
-	fclose(f);
-	return btf;
-}
-
-static bool is_btf_raw(const char *file)
-{
-	__u16 magic =3D 0;
-	int fd, nb_read;
-
-	fd =3D open(file, O_RDONLY);
-	if (fd < 0)
-		return false;
-
-	nb_read =3D read(fd, &magic, sizeof(magic));
-	close(fd);
-	return nb_read =3D=3D sizeof(magic) && magic =3D=3D BTF_MAGIC;
-}
-
 static int do_dump(int argc, char **argv)
 {
 	struct btf *btf =3D NULL;
@@ -547,11 +499,7 @@ static int do_dump(int argc, char **argv)
 		}
 		NEXT_ARG();
 	} else if (is_prefix(src, "file")) {
-		if (is_btf_raw(*argv))
-			btf =3D btf__parse_raw(*argv);
-		else
-			btf =3D btf__parse_elf(*argv, NULL);
-
+		btf =3D btf__parse(*argv, NULL);
 		if (IS_ERR(btf)) {
 			err =3D -PTR_ERR(btf);
 			btf =3D NULL;
--=20
2.24.1

