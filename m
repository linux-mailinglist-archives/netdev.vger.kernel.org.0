Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F5C35FC25
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353638AbhDNUCf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 16:02:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46026 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353612AbhDNUCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:02:31 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EJsiqV007345
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:09 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37wv5jbnpg-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:09 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 13:02:03 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E3D3E2ECEBDF; Wed, 14 Apr 2021 13:01:58 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 02/17] bpftool: dump more info about DATASEC members
Date:   Wed, 14 Apr 2021 13:01:31 -0700
Message-ID: <20210414200146.2663044-3-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414200146.2663044-1-andrii@kernel.org>
References: <20210414200146.2663044-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 51j8t4T0hIG86bMArfAdgts3Bk8JHJN2
X-Proofpoint-GUID: 51j8t4T0hIG86bMArfAdgts3Bk8JHJN2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_12:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dump succinct information for each member of DATASEC: its kinds and name. This
is extremely helpful to see at a quick glance what is inside each DATASEC of
a given BTF. Without this, one has to jump around BTF data to just find out
the name of a VAR or FUNC. DATASEC's var_secinfo member is special in that
regard because it doesn't itself contain the name of the member, delegating
that to the referenced VAR and FUNC kinds. Other kinds, like
STRUCT/UNION/FUNC/ENUM, encode member names directly and thus are clearly
identifiable in BTF dump.

The new output looks like this:

[35] DATASEC '.bss' size=0 vlen=6
        type_id=8 offset=0 size=4 (VAR 'input_bss1')
        type_id=13 offset=0 size=4 (VAR 'input_bss_weak')
        type_id=16 offset=0 size=4 (VAR 'output_bss1')
        type_id=17 offset=0 size=4 (VAR 'output_data1')
        type_id=18 offset=0 size=4 (VAR 'output_rodata1')
        type_id=20 offset=0 size=8 (VAR 'output_sink1')
[36] DATASEC '.data' size=0 vlen=2
        type_id=9 offset=0 size=4 (VAR 'input_data1')
        type_id=14 offset=0 size=4 (VAR 'input_data_weak')
[37] DATASEC '.kconfig' size=0 vlen=2
        type_id=25 offset=0 size=4 (VAR 'LINUX_KERNEL_VERSION')
        type_id=28 offset=0 size=1 (VAR 'CONFIG_BPF_SYSCALL')
[38] DATASEC '.ksyms' size=0 vlen=1
        type_id=30 offset=0 size=1 (VAR 'bpf_link_fops')
[39] DATASEC '.rodata' size=0 vlen=2
        type_id=12 offset=0 size=4 (VAR 'input_rodata1')
        type_id=15 offset=0 size=4 (VAR 'input_rodata_weak')
[40] DATASEC 'license' size=0 vlen=1
        type_id=24 offset=0 size=4 (VAR 'LICENSE')

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/btf.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 001749a34899..385d5c955cf3 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -100,26 +100,28 @@ static const char *btf_str(const struct btf *btf, __u32 off)
 	return btf__name_by_offset(btf, off) ? : "(invalid)";
 }
 
+static int btf_kind_safe(int kind)
+{
+	return kind <= BTF_KIND_MAX ? kind : BTF_KIND_UNKN;
+}
+
 static int dump_btf_type(const struct btf *btf, __u32 id,
 			 const struct btf_type *t)
 {
 	json_writer_t *w = json_wtr;
-	int kind, safe_kind;
-
-	kind = BTF_INFO_KIND(t->info);
-	safe_kind = kind <= BTF_KIND_MAX ? kind : BTF_KIND_UNKN;
+	int kind = btf_kind(t);
 
 	if (json_output) {
 		jsonw_start_object(w);
 		jsonw_uint_field(w, "id", id);
-		jsonw_string_field(w, "kind", btf_kind_str[safe_kind]);
+		jsonw_string_field(w, "kind", btf_kind_str[btf_kind_safe(kind)]);
 		jsonw_string_field(w, "name", btf_str(btf, t->name_off));
 	} else {
-		printf("[%u] %s '%s'", id, btf_kind_str[safe_kind],
+		printf("[%u] %s '%s'", id, btf_kind_str[btf_kind_safe(kind)],
 		       btf_str(btf, t->name_off));
 	}
 
-	switch (BTF_INFO_KIND(t->info)) {
+	switch (kind) {
 	case BTF_KIND_INT: {
 		__u32 v = *(__u32 *)(t + 1);
 		const char *enc;
@@ -302,7 +304,8 @@ static int dump_btf_type(const struct btf *btf, __u32 id,
 		break;
 	}
 	case BTF_KIND_DATASEC: {
-		const struct btf_var_secinfo *v = (const void *)(t+1);
+		const struct btf_var_secinfo *v = (const void *)(t + 1);
+		const struct btf_type *vt;
 		__u16 vlen = BTF_INFO_VLEN(t->info);
 		int i;
 
@@ -324,6 +327,13 @@ static int dump_btf_type(const struct btf *btf, __u32 id,
 			} else {
 				printf("\n\ttype_id=%u offset=%u size=%u",
 				       v->type, v->offset, v->size);
+
+				if (v->type <= btf__get_nr_types(btf)) {
+					vt = btf__type_by_id(btf, v->type);
+					printf(" (%s '%s')",
+					       btf_kind_str[btf_kind_safe(btf_kind(vt))],
+					       btf_str(btf, vt->name_off));
+				}
 			}
 		}
 		if (json_output)
-- 
2.30.2

