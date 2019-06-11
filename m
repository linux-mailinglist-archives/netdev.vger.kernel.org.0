Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C7C3C308
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403910AbfFKEsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:48:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35546 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403747AbfFKEsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:48:35 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5B4jLNb013205
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:48:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=AYJBxbod3aKifNwgTVgPBUcBvNE6JScxe741jkomWoE=;
 b=Ecxdz7CYbmExWZUK/ieTlLzFQs04X1+Hu86UgwAE2C7ESOQgdkdJRZPA1M/s8W569okq
 XNxnSuzUh4ZFikLCDwmOARy9AfIMXq4fe4wl0WDGT+o5b02rAcdluQXsbXcP9jUcp8f5
 KL+GhuW9utoc89w1XzE9ph1901pFhbADjXI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t1s632vqm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:48:34 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 10 Jun 2019 21:48:20 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2F9E686186A; Mon, 10 Jun 2019 21:48:20 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 5/8] libbpf: split initialization and loading of BTF
Date:   Mon, 10 Jun 2019 21:47:44 -0700
Message-ID: <20190611044747.44839-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611044747.44839-1-andriin@fb.com>
References: <20190611044747.44839-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110033
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
---
 tools/lib/bpf/libbpf.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5e7ea7dac958..79a8143240d7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1118,7 +1118,7 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
 	}
 }
 
-static int bpf_object__load_btf(struct bpf_object *obj,
+static int bpf_object__init_btf(struct bpf_object *obj,
 				Elf_Data *btf_data,
 				Elf_Data *btf_ext_data)
 {
@@ -1137,13 +1137,6 @@ static int bpf_object__load_btf(struct bpf_object *obj,
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
@@ -1159,7 +1152,6 @@ static int bpf_object__load_btf(struct bpf_object *obj,
 			obj->btf_ext = NULL;
 			goto out;
 		}
-		bpf_object__sanitize_btf_ext(obj);
 	}
 out:
 	if (err || IS_ERR(obj->btf)) {
@@ -1170,6 +1162,26 @@ static int bpf_object__load_btf(struct bpf_object *obj,
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
@@ -1301,9 +1313,11 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
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

