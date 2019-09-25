Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3662CBE49A
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 20:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437785AbfIYSat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 14:30:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7486 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392037AbfIYSas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 14:30:48 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8PITX5X013942
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 11:30:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=mgqO5gjYuxMb+aeioagpvMLMxcPQMLjzG87W7004MLI=;
 b=ig41iTlPWHHJNMUXxwIRUJT1anNtdZReXJrfEKVYKSPv8X4SkuSGrVMHabqZAIAklu9u
 LpZLxOVAicVFe2vGZWQSZ8tPgCKmWfMRDoM4Wgc2Dl9E5WC217Ve4axKF74Nm9qrhIr/
 Sy4CMKKJxWVIMznwt2vXF+JibbXpQC63ZFY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v8cfygb3h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 11:30:46 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 25 Sep 2019 11:30:44 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D46CA8619CB; Wed, 25 Sep 2019 11:30:42 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] libbpf: fix false uninitialized variable warning
Date:   Wed, 25 Sep 2019 11:30:38 -0700
Message-ID: <20190925183038.2755521-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-25_08:2019-09-25,2019-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909250158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some compilers emit warning for potential uninitialized next_id usage.
The code is correct, but control flow is too complicated for some
compilers to figure this out. Re-initialize next_id to satisfy
compiler.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf_dump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 715967762312..84b0661db7f3 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1140,60 +1140,61 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 		case BTF_KIND_ARRAY: {
 			const struct btf_array *a = btf_array(t);
 			const struct btf_type *next_t;
 			__u32 next_id;
 			bool multidim;
 			/*
 			 * GCC has a bug
 			 * (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=8354)
 			 * which causes it to emit extra const/volatile
 			 * modifiers for an array, if array's element type has
 			 * const/volatile modifiers. Clang doesn't do that.
 			 * In general, it doesn't seem very meaningful to have
 			 * a const/volatile modifier for array, so we are
 			 * going to silently skip them here.
 			 */
 			while (decls->cnt) {
 				next_id = decls->ids[decls->cnt - 1];
 				next_t = btf__type_by_id(d->btf, next_id);
 				if (btf_is_mod(next_t))
 					decls->cnt--;
 				else
 					break;
 			}
 
 			if (decls->cnt == 0) {
 				btf_dump_emit_name(d, fname, last_was_ptr);
 				btf_dump_printf(d, "[%u]", a->nelems);
 				return;
 			}
 
+			next_id = decls->ids[decls->cnt - 1];
 			next_t = btf__type_by_id(d->btf, next_id);
 			multidim = btf_is_array(next_t);
 			/* we need space if we have named non-pointer */
 			if (fname[0] && !last_was_ptr)
 				btf_dump_printf(d, " ");
 			/* no parentheses for multi-dimensional array */
 			if (!multidim)
 				btf_dump_printf(d, "(");
 			btf_dump_emit_type_chain(d, decls, fname, lvl);
 			if (!multidim)
 				btf_dump_printf(d, ")");
 			btf_dump_printf(d, "[%u]", a->nelems);
 			return;
 		}
 		case BTF_KIND_FUNC_PROTO: {
 			const struct btf_param *p = btf_params(t);
 			__u16 vlen = btf_vlen(t);
 			int i;
 
 			btf_dump_emit_mods(d, decls);
 			if (decls->cnt) {
 				btf_dump_printf(d, " (");
 				btf_dump_emit_type_chain(d, decls, fname, lvl);
 				btf_dump_printf(d, ")");
 			} else {
 				btf_dump_emit_name(d, fname, last_was_ptr);
 			}
 			btf_dump_printf(d, "(");
 			/*
 			 * Clang for BPF target generates func_proto with no
-- 
2.17.1

