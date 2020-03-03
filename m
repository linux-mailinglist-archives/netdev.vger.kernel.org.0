Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4220C178216
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbgCCSM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:12:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51902 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731208AbgCCSM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:12:57 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 023IAcrx016850
        for <netdev@vger.kernel.org>; Tue, 3 Mar 2020 10:12:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=x3ns7LX866GaJPokoQl7Qwx3KYe5wetFn4H1AsT3LYg=;
 b=HV2o9U9Kmc3n9sJR/vJjKd4TX87lcY+qRXvSqbOXf0bASwbK5Ph286S6RTnhkAemBIAO
 wHvd8g7OeA+bapIRjgd5jeN+CYBr1XyNq+QMNkuqSc7XL3GmS9T3CsaWsfdZyx219jIj
 ED9V6nj6vDxXasBlj7ZnAwKKe1w7KRD4P2E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yhscwh4h1-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 10:12:55 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 3 Mar 2020 10:08:07 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 681792EC29A2; Tue,  3 Mar 2020 10:08:03 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix handling of optional field_name in btf_dump__emit_type_decl
Date:   Tue, 3 Mar 2020 10:08:00 -0800
Message-ID: <20200303180800.3303471-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-03_06:2020-03-03,2020-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=686 clxscore=1015 impostorscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Internal functions, used by btf_dump__emit_type_decl(), assume field_name is
never going to be NULL. Ensure it's always the case.

Fixes: 9f81654eebe8 ("libbpf: Expose BTF-to-C type declaration emitting API")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf_dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index bd09ed1710f1..dc451e4de5ad 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1030,7 +1030,7 @@ int btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
 	if (!OPTS_VALID(opts, btf_dump_emit_type_decl_opts))
 		return -EINVAL;
 
-	fname = OPTS_GET(opts, field_name, NULL);
+	fname = OPTS_GET(opts, field_name, "");
 	lvl = OPTS_GET(opts, indent_level, 0);
 	btf_dump_emit_type_decl(d, id, fname, lvl);
 	return 0;
-- 
2.17.1

