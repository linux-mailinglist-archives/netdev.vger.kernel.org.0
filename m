Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2CE27DCA6
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgI2X24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:28:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40686 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbgI2X2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:28:54 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TNQXVh007560
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:28:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=l3PtNnp74smCvQsrTcW/j/aK41bN6hD3F9Rk8WvU4Tc=;
 b=GXHkvHH5ITEVQSgtBEghNmzcK5h8yQ3dEf/KkhlbKP2ABXzQ4i3UNzQ8EclOl3cZcfwO
 0ZdoaWv3ohCm/msmyky8ydkcU0Cy/WdmwY0zLYU2swUfTx1oTP/563ms0Q4qURL3yNNi
 6DojbWX6+27ZyQU3WvNCi1FXimRBWAvdXA4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33t35n83u5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:28:53 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 16:28:51 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A44642EC77D1; Tue, 29 Sep 2020 16:28:49 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 2/4] libbpf: add raw dumping of BTF types
Date:   Tue, 29 Sep 2020 16:28:41 -0700
Message-ID: <20200929232843.1249318-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200929232843.1249318-1-andriin@fb.com>
References: <20200929232843.1249318-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=25 impostorscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290198
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend btf_dump APIs with ability to dump raw textual representation of B=
TF
types, with the same format as used by `bpftool btf dump file` command. S=
uch
functionality is really useful for debugging issues with BTF, testing, BT=
F
introspection, etc. It is going to be used in BPF selftests for validatin=
g
BTF types.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.h      |   1 +
 tools/lib/bpf/btf_dump.c | 174 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.map |   1 +
 3 files changed, 176 insertions(+)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 57247240a20a..327ac6f39587 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -146,6 +146,7 @@ LIBBPF_API struct btf_dump *btf_dump__new(const struc=
t btf *btf,
 LIBBPF_API void btf_dump__free(struct btf_dump *d);
=20
 LIBBPF_API int btf_dump__dump_type(struct btf_dump *d, __u32 id);
+LIBBPF_API int btf_dump__dump_type_raw(const struct btf_dump *d, __u32 i=
d);
=20
 struct btf_dump_emit_type_decl_opts {
 	/* size of this struct, for forward/backward compatiblity */
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 2f9d685bd522..a01720b225cb 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1438,3 +1438,177 @@ static const char *btf_dump_ident_name(struct btf=
_dump *d, __u32 id)
 {
 	return btf_dump_resolve_name(d, id, d->ident_names);
 }
+
+static const char * const btf_kind_str_mapping[] =3D {
+	[BTF_KIND_UNKN]		=3D "UNKNOWN",
+	[BTF_KIND_INT]		=3D "INT",
+	[BTF_KIND_PTR]		=3D "PTR",
+	[BTF_KIND_ARRAY]	=3D "ARRAY",
+	[BTF_KIND_STRUCT]	=3D "STRUCT",
+	[BTF_KIND_UNION]	=3D "UNION",
+	[BTF_KIND_ENUM]		=3D "ENUM",
+	[BTF_KIND_FWD]		=3D "FWD",
+	[BTF_KIND_TYPEDEF]	=3D "TYPEDEF",
+	[BTF_KIND_VOLATILE]	=3D "VOLATILE",
+	[BTF_KIND_CONST]	=3D "CONST",
+	[BTF_KIND_RESTRICT]	=3D "RESTRICT",
+	[BTF_KIND_FUNC]		=3D "FUNC",
+	[BTF_KIND_FUNC_PROTO]	=3D "FUNC_PROTO",
+	[BTF_KIND_VAR]		=3D "VAR",
+	[BTF_KIND_DATASEC]	=3D "DATASEC",
+};
+
+static const char *btf_kind_str(__u16 kind)
+{
+	if (kind > BTF_KIND_DATASEC)
+		return "UNKNOWN";
+	return btf_kind_str_mapping[kind];
+}
+
+static const char *btf_int_enc_str(__u8 encoding)
+{
+	switch (encoding) {
+	case 0:
+		return "(none)";
+	case BTF_INT_SIGNED:
+		return "SIGNED";
+	case BTF_INT_CHAR:
+		return "CHAR";
+	case BTF_INT_BOOL:
+		return "BOOL";
+	default:
+		return "UNKN";
+	}
+}
+
+static const char *btf_var_linkage_str(__u32 linkage)
+{
+	switch (linkage) {
+	case BTF_VAR_STATIC:
+		return "static";
+	case BTF_VAR_GLOBAL_ALLOCATED:
+		return "global-alloc";
+	default:
+		return "(unknown)";
+	}
+}
+
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
+static const char *btf_str(const struct btf *btf, __u32 off)
+{
+	if (!off)
+		return "(anon)";
+	return btf__str_by_offset(btf, off) ?: "(invalid)";
+}
+
+int btf_dump__dump_type_raw(const struct btf_dump *d, __u32 id)
+{
+	const struct btf_type *t;
+	int kind, i;
+	__u32 vlen;
+
+	t =3D btf__type_by_id(d->btf, id);
+	if (!t)
+		return -EINVAL;
+
+	vlen =3D btf_vlen(t);
+	kind =3D btf_kind(t);
+
+	btf_dump_printf(d, "[%u] %s '%s'", id, btf_kind_str(kind), btf_str(d->b=
tf, t->name_off));
+
+	switch (kind) {
+	case BTF_KIND_INT:
+		btf_dump_printf(d, " size=3D%u bits_offset=3D%u nr_bits=3D%u encoding=3D=
%s",
+				t->size, btf_int_offset(t), btf_int_bits(t),
+				btf_int_enc_str(btf_int_encoding(t)));
+		break;
+	case BTF_KIND_PTR:
+	case BTF_KIND_CONST:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_RESTRICT:
+	case BTF_KIND_TYPEDEF:
+		btf_dump_printf(d, " type_id=3D%u", t->type);
+		break;
+	case BTF_KIND_ARRAY: {
+		const struct btf_array *arr =3D btf_array(t);
+
+		btf_dump_printf(d, " type_id=3D%u index_type_id=3D%u nr_elems=3D%u",
+				arr->type, arr->index_type, arr->nelems);
+		break;
+	}
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION: {
+		const struct btf_member *m =3D btf_members(t);
+
+		btf_dump_printf(d, " size=3D%u vlen=3D%u", t->size, vlen);
+		for (i =3D 0; i < vlen; i++, m++) {
+			__u32 bit_off, bit_sz;
+
+			bit_off =3D btf_member_bit_offset(t, i);
+			bit_sz =3D btf_member_bitfield_size(t, i);
+			btf_dump_printf(d, "\n\t'%s' type_id=3D%u bits_offset=3D%u",
+					btf_str(d->btf, m->name_off), m->type, bit_off);
+			if (bit_sz)
+				btf_dump_printf(d, " bitfield_size=3D%u", bit_sz);
+		}
+		break;
+	}
+	case BTF_KIND_ENUM: {
+		const struct btf_enum *v =3D btf_enum(t);
+
+		btf_dump_printf(d, " size=3D%u vlen=3D%u", t->size, vlen);
+		for (i =3D 0; i < vlen; i++, v++) {
+			btf_dump_printf(d, "\n\t'%s' val=3D%u",
+					btf_str(d->btf, v->name_off), v->val);
+		}
+		break;
+	}
+	case BTF_KIND_FWD:
+		btf_dump_printf(d, " fwd_kind=3D%s", btf_kflag(t) ? "union" : "struct"=
);
+		break;
+	case BTF_KIND_FUNC:
+		btf_dump_printf(d, " type_id=3D%u linkage=3D%s", t->type, btf_func_lin=
kage_str(t));
+		break;
+	case BTF_KIND_FUNC_PROTO: {
+		const struct btf_param *p =3D btf_params(t);
+
+		btf_dump_printf(d, " ret_type_id=3D%u vlen=3D%u", t->type, vlen);
+		for (i =3D 0; i < vlen; i++, p++) {
+			btf_dump_printf(d, "\n\t'%s' type_id=3D%u",
+					btf_str(d->btf, p->name_off), p->type);
+		}
+		break;
+	}
+	case BTF_KIND_VAR:
+		btf_dump_printf(d, " type_id=3D%u, linkage=3D%s",
+				t->type, btf_var_linkage_str(btf_var(t)->linkage));
+		break;
+	case BTF_KIND_DATASEC: {
+		const struct btf_var_secinfo *v =3D btf_var_secinfos(t);
+
+		btf_dump_printf(d, " size=3D%u vlen=3D%u", t->size, vlen);
+		for (i =3D 0; i < vlen; i++, v++) {
+			btf_dump_printf(d, "\n\ttype_id=3D%u offset=3D%u size=3D%u",
+					v->type, v->offset, v->size);
+		}
+		break;
+	}
+	default:
+		break;
+	}
+
+	return 0;
+}
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 4ebfadf45b47..8d357c24cf3d 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -331,6 +331,7 @@ LIBBPF_0.2.0 {
 		btf__new_empty;
 		btf__set_endianness;
 		btf__str_by_offset;
+		btf_dump__dump_type_raw;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
 		perf_buffer__epoll_fd;
--=20
2.24.1

