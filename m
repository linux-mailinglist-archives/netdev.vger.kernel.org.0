Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1C6147845
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 06:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgAXFn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 00:43:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19546 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730222AbgAXFn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 00:43:26 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00O5dPLM013928
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 21:43:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=2G4lXtcToFB2NdopEStSCnKLTLVCre0jAHe0BamVmkM=;
 b=fJnW9pu4JIwulrG+iP6KyDdELGyweOr58m64QZi1Rwy4l7gETSZEc3sYkiaVaDtQZ7eY
 Sv69bXsnqgZcU0U9LjsRAMZjwu66xfVnGk6GPoi5nRoy6TNwITyoFtxzRtDzyrCdImfJ
 PWm28I0ISurx2bBSNcDkr2I3diko3el4O34= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpu2180h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 21:43:25 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 21:43:24 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 44F6A2EC1D16; Thu, 23 Jan 2020 21:43:19 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpftool: print function linkage in BTF dump
Date:   Thu, 23 Jan 2020 21:43:17 -0800
Message-ID: <20200124054317.2459436-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_01:2020-01-23,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=8 adultscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add printing out BTF_KIND_FUNC's linkage.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/btf.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 4ba90d81b6a1..b3745ed711ba 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -77,6 +77,20 @@ static const char *btf_var_linkage_str(__u32 linkage)
 	}
 }
 
+static const char *btf_func_linkage_str(const struct btf_type *t)
+{
+	switch (btf_vlen(t)) {
+	case BTF_FUNC_STATIC:
+		return "static";
+	case BTF_FUNC_GLOBAL:
+		return "global";
+	case BTF_FUNC_EXTERN:
+		return "extern";
+	default:
+		return "(unknown)";
+	}
+}
+
 static const char *btf_str(const struct btf *btf, __u32 off)
 {
 	if (!off)
@@ -231,12 +245,17 @@ static int dump_btf_type(const struct btf *btf, __u32 id,
 			printf(" fwd_kind=%s", fwd_kind);
 		break;
 	}
-	case BTF_KIND_FUNC:
-		if (json_output)
+	case BTF_KIND_FUNC: {
+		const char *linkage = btf_func_linkage_str(t);
+
+		if (json_output) {
 			jsonw_uint_field(w, "type_id", t->type);
-		else
-			printf(" type_id=%u", t->type);
+			jsonw_string_field(w, "linkage", linkage);
+		} else {
+			printf(" type_id=%u linkage=%s", t->type, linkage);
+		}
 		break;
+	}
 	case BTF_KIND_FUNC_PROTO: {
 		const struct btf_param *p = (const void *)(t + 1);
 		__u16 vlen = BTF_INFO_VLEN(t->info);
-- 
2.17.1

