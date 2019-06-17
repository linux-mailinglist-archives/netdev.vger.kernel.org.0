Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8128748E9E
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbfFQT1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:27:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57238 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728433AbfFQT1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:27:23 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJFTmh008638
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=tPiVPnH5lXOHZLCiXd93EI8W8xUaD2D2TbsZRhQ9y1c=;
 b=ZfYLnvQv4df0srOGueV47DEocguo1TRdMh6UuKBpUSCkxvCj/IWugw6lB4h/Q0ytaL8l
 2WJtr+lPxTUtyv8nBTCEOqPUXZBRPzH4EH527CIiJ+0BNjljbdpk69tw5oTBDm0ZsYeb
 +3KEYw3ExMaGXs5eB/4bJwC+SVD6x1R1KGM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6gv3015f-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:21 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 17 Jun 2019 12:27:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D333486173A; Mon, 17 Jun 2019 12:27:13 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 06/11] libbpf: split initialization and loading of BTF
Date:   Mon, 17 Jun 2019 12:26:55 -0700
Message-ID: <20190617192700.2313445-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617192700.2313445-1-andriin@fb.com>
References: <20190617192700.2313445-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf does sanitization of BTF before loading it into kernel, if kernel
doesn't support some of newer BTF features. This removes some of the
important information from BTF (e.g., DATASEC and VAR description),
which will be used for map construction. This patch splits BTF
processing into initialization step, in which BTF is initialized from
ELF and all the original data is still preserved; and
sanitization/loading step, which ensures that BTF is safe to load into
kernel. This allows to use full BTF information to construct maps, while
still loading valid BTF into older kernels.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/libbpf.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b1f3ab4b39b3..da942ab2f06a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1113,7 +1113,7 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
 	}
 }
 
-static int bpf_object__load_btf(struct bpf_object *obj,
+static int bpf_object__init_btf(struct bpf_object *obj,
 				Elf_Data *btf_data,
 				Elf_Data *btf_ext_data)
 {
@@ -1132,13 +1132,6 @@ static int bpf_object__load_btf(struct bpf_object *obj,
 				   BTF_ELF_SEC, err);
 			goto out;
 		}
-		bpf_object__sanitize_btf(obj);
-		err = btf__load(obj->btf);
-		if (err) {
-			pr_warning("Error loading %s into kernel: %d.\n",
-				   BTF_ELF_SEC, err);
-			goto out;
-		}
 	}
 	if (btf_ext_data) {
 		if (!obj->btf) {
@@ -1154,7 +1147,6 @@ static int bpf_object__load_btf(struct bpf_object *obj,
 			obj->btf_ext = NULL;
 			goto out;
 		}
-		bpf_object__sanitize_btf_ext(obj);
 	}
 out:
 	if (err || IS_ERR(obj->btf)) {
@@ -1165,6 +1157,26 @@ static int bpf_object__load_btf(struct bpf_object *obj,
 	return 0;
 }
 
+static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
+{
+	int err = 0;
+
+	if (!obj->btf)
+		return 0;
+
+	bpf_object__sanitize_btf(obj);
+	bpf_object__sanitize_btf_ext(obj);
+
+	err = btf__load(obj->btf);
+	if (err) {
+		pr_warning("Error loading %s into kernel: %d.\n",
+			   BTF_ELF_SEC, err);
+		btf__free(obj->btf);
+		obj->btf = NULL;
+	}
+	return 0;
+}
+
 static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 {
 	Elf *elf = obj->efile.elf;
@@ -1296,9 +1308,11 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 		pr_warning("Corrupted ELF file: index of strtab invalid\n");
 		return -LIBBPF_ERRNO__FORMAT;
 	}
-	err = bpf_object__load_btf(obj, btf_data, btf_ext_data);
+	err = bpf_object__init_btf(obj, btf_data, btf_ext_data);
 	if (!err)
 		err = bpf_object__init_maps(obj, flags);
+	if (!err)
+		err = bpf_object__sanitize_and_load_btf(obj);
 	if (!err)
 		err = bpf_object__init_prog_names(obj);
 	return err;
-- 
2.17.1

