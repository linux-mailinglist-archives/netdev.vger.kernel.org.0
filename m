Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEBABE68C
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 22:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392425AbfIYUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 16:37:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47064 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727102AbfIYUht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 16:37:49 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8PKZHgb015793
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 13:37:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=lzsDUuD4RFn3Pihhe8prxWChS09LuhaNIPTK1yuHjwo=;
 b=SXOfBa6B+7FARx2+0y4hl5NZsfcTQ2la4Ki/VaGiGYT/8JYZd3QTZv6NI/SCcHw38JKf
 oL0jNf18y47OLBZ9B/BSxKqmtS1rvC1qbFOdPV9epFseeuHk87QR94ILth0bkmHl0/x1
 S4U1HASsRBF7Y6f/hUqdh0ns4rka+K2I9IA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v7q74egt9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 13:37:48 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 25 Sep 2019 13:37:47 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 3F7FF861975; Wed, 25 Sep 2019 13:37:47 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] libbpf: teach btf_dumper to emit stand-alone anonymous enum definitions
Date:   Wed, 25 Sep 2019 13:37:45 -0700
Message-ID: <20190925203745.3173184-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-25_09:2019-09-25,2019-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 priorityscore=1501 suspectscore=2 lowpriorityscore=0
 mlxscore=0 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909250165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF-to-C converter previously skipped anonymous enums in an assumption
that those are embedded in struct's field definitions. This is not
always the case and a lot of kernel constants are defined as part of
anonymous enums. This change fixes the logic by eagerly marking all
types as either referenced by any other type or not. This is enough to
distinguish two classes of anonymous enums and emit previously omitted
enum definitions.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf_dump.c | 93 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 87 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 84b0661db7f3..ede55fec3618 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -48,6 +48,8 @@ struct btf_dump_type_aux_state {
 	__u8 fwd_emitted: 1;
 	/* whether unique non-duplicate name was already assigned */
 	__u8 name_resolved: 1;
+	/* whether type is referenced from any other type */
+	__u8 referenced: 1;
 };
 
 struct btf_dump {
@@ -173,6 +175,7 @@ void btf_dump__free(struct btf_dump *d)
 	free(d);
 }
 
+static int btf_dump_mark_referenced(struct btf_dump *d);
 static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr);
 static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id);
 
@@ -213,6 +216,11 @@ int btf_dump__dump_type(struct btf_dump *d, __u32 id)
 		/* VOID is special */
 		d->type_states[0].order_state = ORDERED;
 		d->type_states[0].emit_state = EMITTED;
+
+		/* eagerly determine referenced types for anon enums */
+		err = btf_dump_mark_referenced(d);
+		if (err)
+			return err;
 	}
 
 	d->emit_queue_cnt = 0;
@@ -226,6 +234,79 @@ int btf_dump__dump_type(struct btf_dump *d, __u32 id)
 	return 0;
 }
 
+/*
+ * Mark all types that are referenced from any other type. This is used to
+ * determine top-level anonymous enums that need to be emitted as an
+ * independent type declarations.
+ * Anonymous enums come in two flavors: either embedded in a struct's field
+ * definition, in which case they have to be declared inline as part of field
+ * type declaration; or as a top-level anonymous enum, typically used for
+ * declaring global constants. It's impossible to distinguish between two
+ * without knowning whether given enum type was referenced from other type:
+ * top-level anonymous enum won't be referenced by anything, while embedded
+ * one will.
+ */
+static int btf_dump_mark_referenced(struct btf_dump *d)
+{
+	int i, j, n = btf__get_nr_types(d->btf);
+	const struct btf_type *t;
+	__u16 vlen;
+
+	for (i = 1; i <= n; i++) {
+		t = btf__type_by_id(d->btf, i);
+		vlen = btf_vlen(t);
+
+		switch (btf_kind(t)) {
+		case BTF_KIND_INT:
+		case BTF_KIND_ENUM:
+		case BTF_KIND_FWD:
+			break;
+
+		case BTF_KIND_VOLATILE:
+		case BTF_KIND_CONST:
+		case BTF_KIND_RESTRICT:
+		case BTF_KIND_PTR:
+		case BTF_KIND_TYPEDEF:
+		case BTF_KIND_FUNC:
+		case BTF_KIND_VAR:
+			d->type_states[t->type].referenced = 1;
+			break;
+
+		case BTF_KIND_ARRAY: {
+			const struct btf_array *a = btf_array(t);
+
+			d->type_states[a->index_type].referenced = 1;
+			d->type_states[a->type].referenced = 1;
+			break;
+		}
+		case BTF_KIND_STRUCT:
+		case BTF_KIND_UNION: {
+			const struct btf_member *m = btf_members(t);
+
+			for (j = 0; j < vlen; j++, m++)
+				d->type_states[m->type].referenced = 1;
+			break;
+		}
+		case BTF_KIND_FUNC_PROTO: {
+			const struct btf_param *p = btf_params(t);
+
+			for (j = 0; j < vlen; j++, p++)
+				d->type_states[p->type].referenced = 1;
+			break;
+		}
+		case BTF_KIND_DATASEC: {
+			const struct btf_var_secinfo *v = btf_var_secinfos(t);
+
+			for (j = 0; j < vlen; j++, v++)
+				d->type_states[v->type].referenced = 1;
+			break;
+		}
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
 static int btf_dump_add_emit_queue_id(struct btf_dump *d, __u32 id)
 {
 	__u32 *new_queue;
@@ -395,7 +476,12 @@ static int btf_dump_order_type(struct btf_dump *d, __u32 id, bool through_ptr)
 	}
 	case BTF_KIND_ENUM:
 	case BTF_KIND_FWD:
-		if (t->name_off != 0) {
+		/*
+		 * non-anonymous or non-referenced enums are top-level
+		 * declarations and should be emitted. Same logic can be
+		 * applied to FWDs, it won't hurt anyways.
+		 */
+		if (t->name_off != 0 || !tstate->referenced) {
 			err = btf_dump_add_emit_queue_id(d, id);
 			if (err)
 				return err;
@@ -536,11 +622,6 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 	t = btf__type_by_id(d->btf, id);
 	kind = btf_kind(t);
 
-	if (top_level_def && t->name_off == 0) {
-		pr_warning("unexpected nameless definition, id:[%u]\n", id);
-		return;
-	}
-
 	if (tstate->emit_state == EMITTING) {
 		if (tstate->fwd_emitted)
 			return;
-- 
2.17.1

