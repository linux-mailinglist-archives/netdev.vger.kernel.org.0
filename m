Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50093381127
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhENT4y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 May 2021 15:56:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43912 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232197AbhENT4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 15:56:54 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14EJowAu007262
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 12:55:42 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38htkfhxxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 12:55:42 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 12:55:40 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C737E2ED8F9A; Fri, 14 May 2021 12:55:35 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next] libbpf: reject static entry-point BPF programs
Date:   Fri, 14 May 2021 12:55:34 -0700
Message-ID: <20210514195534.1440970-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 51yrBRRqF2K8n0dBvtBZW-FR5WZDlWK2
X-Proofpoint-ORIG-GUID: 51yrBRRqF2K8n0dBvtBZW-FR5WZDlWK2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-14_10:2021-05-12,2021-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105140157
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Detect use of static entry-point BPF programs (those with SEC() markings) and
emit error message. This is similar to
c1cccec9c636 ("libbpf: Reject static maps") but for BPF programs.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 182bd3d3f728..e58f51b24574 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -677,6 +677,11 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
 			return -LIBBPF_ERRNO__FORMAT;
 		}
 
+		if (sec_idx != obj->efile.text_shndx && GELF_ST_BIND(sym.st_info) == STB_LOCAL) {
+			pr_warn("sec '%s': program '%s' is static and not supported\n", sec_name, name);
+			return -ENOTSUP;
+		}
+
 		pr_debug("sec '%s': found program '%s' at insn offset %zu (%zu bytes), code size %zu insns (%zu bytes)\n",
 			 sec_name, name, sec_off / BPF_INSN_SZ, sec_off, prog_sz / BPF_INSN_SZ, prog_sz);
 
-- 
2.30.2

