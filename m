Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2012D328
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 03:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfE2BOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 21:14:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57454 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfE2BOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 21:14:42 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4T1DHaH030282
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=nZLzpkETa6Mj/lJWthz/SVJm/DqV5enq5Aef2r3VzOQ=;
 b=V7pFepA9BPj+bSz8DuhLUHPRLblhMGHIVtmulaYdwaWTlDYOgkZeTPeyxASno9XGd9Kf
 NCMHlNH6urz/aSJsQlsZlMJaqSf3Re2aO/mrO1SLveXnk1636NP6+CepQSKBQWSy+dyE
 q29ks5AkZsiychWn48lVLbTKKGgqfsrVoGA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss6cst7pg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 18:14:41 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 18:14:38 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 075DE8617AA; Tue, 28 May 2019 18:14:36 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 4/9] libbpf: check map name retrieved from ELF
Date:   Tue, 28 May 2019 18:14:21 -0700
Message-ID: <20190529011426.1328736-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529011426.1328736-1-andriin@fb.com>
References: <20190529011426.1328736-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate there was no error retrieving symbol name corresponding to
a BPF map.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c98f9942fba4..7abe71ee507a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -920,6 +920,11 @@ bpf_object__init_maps(struct bpf_object *obj, int flags)
 		map_name = elf_strptr(obj->efile.elf,
 				      obj->efile.strtabidx,
 				      sym.st_name);
+		if (!map_name) {
+			pr_warning("failed to get map #%d name sym string for obj %s\n",
+				   map_idx, obj->path);
+			return -LIBBPF_ERRNO__FORMAT;
+		}
 
 		obj->maps[map_idx].libbpf_type = LIBBPF_MAP_UNSPEC;
 		obj->maps[map_idx].offset = sym.st_value;
-- 
2.17.1

