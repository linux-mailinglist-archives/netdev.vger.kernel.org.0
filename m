Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F12F6EB22
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 21:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfGSTdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 15:33:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727535AbfGSTdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 15:33:09 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6JJWH9t028873
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 12:33:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=oBVAlP5OdqHQ13sW6oBkZNi0/zxK4Iikfgxs4MAsi1I=;
 b=C/RyGLYKfp9AbLOzOYCg6LW7CucNyIzK5GFWIUW0cPdBkBnACCoR4CEcqibveBY/afzi
 iBOtyzgWW6pc1bVR1etesQRlvlfJRFTd/Nc81EjjW624zwVmrGwtv84v+dXb153EhQVz
 sa1k4KPj7US+GriwOLIxiVW7RbWnQBKot9A= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tues59a8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 12:33:08 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 19 Jul 2019 12:33:07 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 49A4786161E; Fri, 19 Jul 2019 12:33:02 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] libbpf: fix SIGSEGV when BTF loading fails, but .BTF.ext exists
Date:   Fri, 19 Jul 2019 12:32:42 -0700
Message-ID: <20190719193242.2658962-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=831 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190209
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case when BTF loading fails despite sanitization, but BPF object has
.BTF.ext loaded as well, we free and null obj->btf, but not
obj->btf_ext. This leads to an attempt to relocate .BTF.ext later on
during bpf_object__load(), which assumes obj->btf is present. This leads
to SIGSEGV on null pointer access. Fix bug by freeing and nulling
obj->btf_ext as well.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 794dd5064ae8..87168f21ef43 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1500,6 +1500,12 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 			   BTF_ELF_SEC, err);
 		btf__free(obj->btf);
 		obj->btf = NULL;
+		/* btf_ext can't exist without btf, so free it as well */
+		if (obj->btf_ext) {
+			btf_ext__free(obj->btf_ext);
+			obj->btf_ext = NULL;
+		}
+
 		if (bpf_object__is_btf_mandatory(obj))
 			return err;
 	}
-- 
2.17.1

