Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8467B48E84
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbfFQT1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:27:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44186 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728949AbfFQT1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:27:11 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJD1jb027753
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Pl5xAPXopIdGKm4l/XYTyx9fAwoIIzNI7H2k3iyRlU8=;
 b=fkFlYapEaiGvCzRsyaCYSrjtwmMUnkC5MPr+goXaTTW6v7pZUHQT7xVO1h9Iz6j9BodU
 hzsqTT7QHLC5vVyExGEDfQ4+MNveAuw7e6AuZiXxecuUPhph1UCxaovlmdJeIeGNkbm1
 DDShJ4zZRYoxIkH/wxcM7mVDthujnxpWPH4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6f3rgeuk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:09 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 17 Jun 2019 12:27:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id A821286173A; Mon, 17 Jun 2019 12:27:05 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 02/11] libbpf: extract BTF loading logic
Date:   Mon, 17 Jun 2019 12:26:51 -0700
Message-ID: <20190617192700.2313445-3-andriin@fb.com>
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

As a preparetion fro adding BTF-based BPF map loading, extract .BTF and
.BTF.ext loading logic.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 93 +++++++++++++++++++++++++-----------------
 1 file changed, 55 insertions(+), 38 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e725fa86b189..49d3a808e754 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1078,6 +1078,58 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
 	}
 }
 
+static int bpf_object__load_btf(struct bpf_object *obj,
+				Elf_Data *btf_data,
+				Elf_Data *btf_ext_data)
+{
+	int err = 0;
+
+	if (btf_data) {
+		obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
+		if (IS_ERR(obj->btf)) {
+			pr_warning("Error loading ELF section %s: %d.\n",
+				   BTF_ELF_SEC, err);
+			goto out;
+		}
+		err = btf__finalize_data(obj, obj->btf);
+		if (err) {
+			pr_warning("Error finalizing %s: %d.\n",
+				   BTF_ELF_SEC, err);
+			goto out;
+		}
+		bpf_object__sanitize_btf(obj);
+		err = btf__load(obj->btf);
+		if (err) {
+			pr_warning("Error loading %s into kernel: %d.\n",
+				   BTF_ELF_SEC, err);
+			goto out;
+		}
+	}
+	if (btf_ext_data) {
+		if (!obj->btf) {
+			pr_debug("Ignore ELF section %s because its depending ELF section %s is not found.\n",
+				 BTF_EXT_ELF_SEC, BTF_ELF_SEC);
+			goto out;
+		}
+		obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
+					    btf_ext_data->d_size);
+		if (IS_ERR(obj->btf_ext)) {
+			pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
+				   BTF_EXT_ELF_SEC, PTR_ERR(obj->btf_ext));
+			obj->btf_ext = NULL;
+			goto out;
+		}
+		bpf_object__sanitize_btf_ext(obj);
+	}
+out:
+	if (err || IS_ERR(obj->btf)) {
+		if (!IS_ERR_OR_NULL(obj->btf))
+			btf__free(obj->btf);
+		obj->btf = NULL;
+	}
+	return 0;
+}
+
 static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 {
 	Elf *elf = obj->efile.elf;
@@ -1212,44 +1264,9 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 		pr_warning("Corrupted ELF file: index of strtab invalid\n");
 		return -LIBBPF_ERRNO__FORMAT;
 	}
-	if (btf_data) {
-		obj->btf = btf__new(btf_data->d_buf, btf_data->d_size);
-		if (IS_ERR(obj->btf)) {
-			pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
-				   BTF_ELF_SEC, PTR_ERR(obj->btf));
-			obj->btf = NULL;
-		} else {
-			err = btf__finalize_data(obj, obj->btf);
-			if (!err) {
-				bpf_object__sanitize_btf(obj);
-				err = btf__load(obj->btf);
-			}
-			if (err) {
-				pr_warning("Error finalizing and loading %s into kernel: %d. Ignored and continue.\n",
-					   BTF_ELF_SEC, err);
-				btf__free(obj->btf);
-				obj->btf = NULL;
-				err = 0;
-			}
-		}
-	}
-	if (btf_ext_data) {
-		if (!obj->btf) {
-			pr_debug("Ignore ELF section %s because its depending ELF section %s is not found.\n",
-				 BTF_EXT_ELF_SEC, BTF_ELF_SEC);
-		} else {
-			obj->btf_ext = btf_ext__new(btf_ext_data->d_buf,
-						    btf_ext_data->d_size);
-			if (IS_ERR(obj->btf_ext)) {
-				pr_warning("Error loading ELF section %s: %ld. Ignored and continue.\n",
-					   BTF_EXT_ELF_SEC,
-					   PTR_ERR(obj->btf_ext));
-				obj->btf_ext = NULL;
-			} else {
-				bpf_object__sanitize_btf_ext(obj);
-			}
-		}
-	}
+	err = bpf_object__load_btf(obj, btf_data, btf_ext_data);
+	if (err)
+		return err;
 	if (bpf_object__has_maps(obj)) {
 		err = bpf_object__init_maps(obj, flags);
 		if (err)
-- 
2.17.1

