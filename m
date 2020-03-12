Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37938183902
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgCLSut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:50:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32806 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbgCLSut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:50:49 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CIdOt3031048
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:50:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=7CqWL7njCBnzLXu3ibBgTdJkuKkrR/bNAhIh7rEjiVI=;
 b=lCFu5Nv87nA7w+vqOCT9AdpesFTpNvubz5jWcb+orw7A93DYXO0p4LpTwfz3wRaT5zK7
 Ka3RRhISiWTSGcclMb3t3JI8lX+1/4/lzBZiEOFHB5Dzj51MR0eCQqJkClOUjstLghtx
 wjEktu0xex1lHyTfdXwOT6BtIE89x3ia540= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt79g5cj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:50:47 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 12 Mar 2020 11:50:46 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F2E0A2EC2C49; Thu, 12 Mar 2020 11:50:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: split BTF presence checks into libbpf- and kernel-specific parts
Date:   Thu, 12 Mar 2020 11:50:33 -0700
Message-ID: <20200312185033.736911-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_12:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 suspectscore=25 lowpriorityscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxlogscore=774 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120094
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Needs for application BTF being present differs between user-space libbpf needs and kernel
needs. Currently, BTF is mandatory only in kernel only when BPF application is
using STRUCT_OPS. While libbpf itself relies more heavily on presense of BTF:
  - for BTF-defined maps;
  - for Kconfig externs;
  - for STRUCT_OPS as well.

Thus, checks for presence and validness of bpf_object's BPF needs to be
performed separately, which is patch does.

Fixes: 5327644614a1 ("libbpf: Relax check whether BTF is mandatory")
Reported-by: Michal Rostecki <mrostecki@opensuse.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 223be01dc466..1a787a2faf58 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2284,9 +2284,16 @@ static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
 	}
 }
 
-static bool bpf_object__is_btf_mandatory(const struct bpf_object *obj)
+static bool libbpf_needs_btf(const struct bpf_object *obj)
 {
-	return obj->efile.st_ops_shndx >= 0 || obj->nr_extern > 0;
+	return obj->efile.btf_maps_shndx >= 0 ||
+	       obj->efile.st_ops_shndx >= 0 ||
+	       obj->nr_extern > 0;
+}
+
+static bool kernel_needs_btf(const struct bpf_object *obj)
+{
+	return obj->efile.st_ops_shndx >= 0;
 }
 
 static int bpf_object__init_btf(struct bpf_object *obj,
@@ -2322,7 +2329,7 @@ static int bpf_object__init_btf(struct bpf_object *obj,
 		}
 	}
 out:
-	if (err && bpf_object__is_btf_mandatory(obj)) {
+	if (err && libbpf_needs_btf(obj)) {
 		pr_warn("BTF is required, but is missing or corrupted.\n");
 		return err;
 	}
@@ -2346,7 +2353,7 @@ static int bpf_object__finalize_btf(struct bpf_object *obj)
 	btf_ext__free(obj->btf_ext);
 	obj->btf_ext = NULL;
 
-	if (bpf_object__is_btf_mandatory(obj)) {
+	if (libbpf_needs_btf(obj)) {
 		pr_warn("BTF is required, but is missing or corrupted.\n");
 		return -ENOENT;
 	}
@@ -2410,7 +2417,7 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 			obj->btf_ext = NULL;
 		}
 
-		if (bpf_object__is_btf_mandatory(obj))
+		if (kernel_needs_btf(obj))
 			return err;
 	}
 	return 0;
-- 
2.17.1

