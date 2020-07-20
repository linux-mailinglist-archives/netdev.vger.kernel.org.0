Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C57226A71
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389000AbgGTQeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:34:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59584 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388989AbgGTQeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 12:34:12 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KGY88Z019197
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=IPGHMB686m/6Ual+13vtkstExaGWgZVIMyQdj6sfna8=;
 b=Q9mXyi7Qs6X75FGvSK0xBcsXmtIa+vjS+KyeTguco9MnvZUS6TEUrLG5IAXSZoK2NLIL
 ksTMyN6SL6M0MLuhg4/Oe2uIyLLYJAsjDsj95dO3Wd12Y5N6pIhBIrFaf4SN5JM9fJIB
 QAkn0DpGleYSQkBArAWsDdi652FDmlu+Jb8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32bxwfqg10-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 09:34:11 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Jul 2020 09:34:02 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 16705370209A; Mon, 20 Jul 2020 09:34:01 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 3/5] bpf: add BTF_ID_LIST_GLOBAL in btf_ids.h
Date:   Mon, 20 Jul 2020 09:34:01 -0700
Message-ID: <20200720163401.1393159-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200720163358.1392964-1-yhs@fb.com>
References: <20200720163358.1392964-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=813 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200111
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing BTF_ID_LIST used a local static variable
to store btf_ids. This patch provided a new macro
BTF_ID_LIST_GLOBAL to store btf_ids in a global
variable which can be shared among multiple files.

The existing BTF_ID_LIST is still retained.
Two reasons. First, BTF_ID_LIST is also used to build
btf_ids for helper arguments which typically
is an array of 5. Since typically different
helpers have different signature, it makes
little sense to share them. Second, some
current computed btf_ids are indeed local.
If later those btf_ids are shared between
different files, they can use BTF_ID_LIST_GLOBAL then.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/btf_ids.h                       | 10 ++++--
 tools/include/linux/btf_ids.h                 | 10 ++++--
 .../selftests/bpf/prog_tests/resolve_btfids.c | 33 ++++++++++++++-----
 3 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 1cdb56950ffe..77ab45baa095 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -57,17 +57,20 @@ asm(							\
  * .zero 4
  *
  */
-#define __BTF_ID_LIST(name)				\
+#define __BTF_ID_LIST(name, scope)			\
 asm(							\
 ".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
-".local " #name ";                             \n"	\
+"." #scope " " #name ";                        \n"	\
 #name ":;                                      \n"	\
 ".popsection;                                  \n");	\
=20
 #define BTF_ID_LIST(name)				\
-__BTF_ID_LIST(name)					\
+__BTF_ID_LIST(name, local)				\
 extern u32 name[];
=20
+#define BTF_ID_LIST_GLOBAL(name)			\
+__BTF_ID_LIST(name, globl)
+
 /*
  * The BTF_ID_UNUSED macro defines 4 zero bytes.
  * It's used when we want to define 'unused' entry
@@ -90,6 +93,7 @@ asm(							\
 #define BTF_ID_LIST(name) static u32 name[5];
 #define BTF_ID(prefix, name)
 #define BTF_ID_UNUSED
+#define BTF_ID_LIST_GLOBAL(name) u32 name[1];
=20
 #endif /* CONFIG_DEBUG_INFO_BTF */
=20
diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.=
h
index 1cdb56950ffe..77ab45baa095 100644
--- a/tools/include/linux/btf_ids.h
+++ b/tools/include/linux/btf_ids.h
@@ -57,17 +57,20 @@ asm(							\
  * .zero 4
  *
  */
-#define __BTF_ID_LIST(name)				\
+#define __BTF_ID_LIST(name, scope)			\
 asm(							\
 ".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
-".local " #name ";                             \n"	\
+"." #scope " " #name ";                        \n"	\
 #name ":;                                      \n"	\
 ".popsection;                                  \n");	\
=20
 #define BTF_ID_LIST(name)				\
-__BTF_ID_LIST(name)					\
+__BTF_ID_LIST(name, local)				\
 extern u32 name[];
=20
+#define BTF_ID_LIST_GLOBAL(name)			\
+__BTF_ID_LIST(name, globl)
+
 /*
  * The BTF_ID_UNUSED macro defines 4 zero bytes.
  * It's used when we want to define 'unused' entry
@@ -90,6 +93,7 @@ asm(							\
 #define BTF_ID_LIST(name) static u32 name[5];
 #define BTF_ID(prefix, name)
 #define BTF_ID_UNUSED
+#define BTF_ID_LIST_GLOBAL(name) u32 name[1];
=20
 #endif /* CONFIG_DEBUG_INFO_BTF */
=20
diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/to=
ols/testing/selftests/bpf/prog_tests/resolve_btfids.c
index 22d83bba4e91..3b127cab4864 100644
--- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
+++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
@@ -28,7 +28,17 @@ struct symbol test_symbols[] =3D {
 	{ "func",    BTF_KIND_FUNC,    -1 },
 };
=20
-BTF_ID_LIST(test_list)
+BTF_ID_LIST(test_list_local)
+BTF_ID_UNUSED
+BTF_ID(typedef, S)
+BTF_ID(typedef, T)
+BTF_ID(typedef, U)
+BTF_ID(struct,  S)
+BTF_ID(union,   U)
+BTF_ID(func,    func)
+
+extern __u32 test_list_global[];
+BTF_ID_LIST_GLOBAL(test_list_global)
 BTF_ID_UNUSED
 BTF_ID(typedef, S)
 BTF_ID(typedef, T)
@@ -94,18 +104,25 @@ static int resolve_symbols(void)
=20
 int test_resolve_btfids(void)
 {
-	unsigned int i;
+	__u32 *test_list, *test_lists[] =3D { test_list_local, test_list_global=
 };
+	unsigned int i, j;
 	int ret =3D 0;
=20
 	if (resolve_symbols())
 		return -1;
=20
-	/* Check BTF_ID_LIST(test_list) IDs */
-	for (i =3D 0; i < ARRAY_SIZE(test_symbols) && !ret; i++) {
-		ret =3D CHECK(test_list[i] !=3D test_symbols[i].id,
-			    "id_check",
-			    "wrong ID for %s (%d !=3D %d)\n", test_symbols[i].name,
-			    test_list[i], test_symbols[i].id);
+	/* Check BTF_ID_LIST(test_list_local) and
+	 * BTF_ID_LIST_GLOBAL(test_list_global) IDs
+	 */
+	for (j =3D 0; j < ARRAY_SIZE(test_lists); j++) {
+		test_list =3D test_lists[j];
+		for (i =3D 0; i < ARRAY_SIZE(test_symbols) && !ret; i++) {
+			ret =3D CHECK(test_list[i] !=3D test_symbols[i].id,
+				    "id_check",
+				    "wrong ID for %s (%d !=3D %d)\n",
+				    test_symbols[i].name,
+				    test_list[i], test_symbols[i].id);
+		}
 	}
=20
 	return ret;
--=20
2.24.1

