Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14E421041C
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgGAGpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:45:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26998 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbgGAGpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 02:45:38 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0616fAYn008221
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:45:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jqUwwYpFA1EqVwoHCCH4zCzzCGaoLEOB4aLchWeaIEY=;
 b=JF6ayrA9dM8n9z0IJdbWUqE2INztKhQPTWn0OzyLHCv29zKyzO3BwG5LD0PSujpsK02E
 T5ybzBRfbQpnL2RsypR3gmbnVyIFXF6+AaKON7F17SaJDjq/HcKfbo5VA64sOo4/tT7A
 q2B0J3Z4sGwD2JWjCtTz65IO0Oo4HAY0WQ0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 320bcdta11-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:45:38 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 23:45:35 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3ADA72EC3A2B; Tue, 30 Jun 2020 23:45:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>,
        Daniel Xu <dlxu@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] libbpf: support stripping modifiers for btf_dump
Date:   Tue, 30 Jun 2020 23:45:23 -0700
Message-ID: <20200701064527.3158178-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200701064527.3158178-1-andriin@fb.com>
References: <20200701064527.3158178-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_03:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 cotscore=-2147483648 spamscore=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One important use case when emitting const/volatile/restrict is undesirab=
le is
BPF skeleton generation of DATASEC layout. These are further memory-mappe=
d and
can be written/read from user-space directly.

For important case of .rodata variables, bpftool strips away first-level
modifiers, to make their use on user-space side simple and not requiring =
extra
type casts to override compiler complaining about writing to const variab=
les.

This logic works mostly fine, but breaks in some more complicated cases. =
E.g.:

    const volatile int params[10];

Because in BTF it's a chain of ARRAY -> CONST -> VOLATILE -> INT, bpftool
stops at ARRAY and doesn't strip CONST and VOLATILE. In skeleton this var=
iable
will be emitted as is. So when used from user-space, compiler will compla=
in
about writing to const array. This is problematic, as also mentioned in [=
0].

To solve this for arrays and other non-trivial cases (e.g., inner
const/volatile fields inside the struct), teach btf_dump to strip away an=
y
modifier, when requested.

This patch converts existing struct btf_dump_opts to modern opts "framewo=
rk"
with size field and easily extensible in the future with backwards/forwar=
d
compatibility. While this is a breaking change, there are only two known
clients of this API: bpftool and bpftrace. bpftool hasn't used opts and j=
ust
passed NULL, so is not affected and subsequent patch makes it use using
DECLARE_LIBBPF_OPTS() macro. bpftrace does use opts and I'll work with
bpftrace maintainers to adopt to a new opts style. While a bit painful, i=
t
seems like a better strategy long-term, instead of maintaining two sets o=
f
btf_dump opts and constructors.

  [0] https://github.com/iovisor/bcc/pull/2994#issuecomment-650588533

Cc: Daniel Xu <dlxu@fb.com>
Reported-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.h      |  6 ++++++
 tools/lib/bpf/btf_dump.c | 18 +++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 06cd1731c154..5c2acca8d7f4 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -115,8 +115,14 @@ LIBBPF_API int btf__dedup(struct btf *btf, struct bt=
f_ext *btf_ext,
 struct btf_dump;
=20
 struct btf_dump_opts {
+	/* size of this struct, for backward/forward compatibility */
+	size_t sz;
+	/* extra context passed to print callback */
 	void *ctx;
+	/* strip all the const/volatile/restrict mods */
+	bool strip_mods;
 };
+#define btf_dump_opts__last_field strip_mods
=20
 typedef void (*btf_dump_printf_fn_t)(void *ctx, const char *fmt, va_list=
 args);
=20
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index bbb430317260..4b843bbd8657 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -59,7 +59,8 @@ struct btf_dump {
 	const struct btf *btf;
 	const struct btf_ext *btf_ext;
 	btf_dump_printf_fn_t printf_fn;
-	struct btf_dump_opts opts;
+	void *print_ctx;
+	bool strip_mods;
=20
 	/* per-type auxiliary state */
 	struct btf_dump_type_aux_state *type_states;
@@ -115,7 +116,7 @@ static void btf_dump_printf(const struct btf_dump *d,=
 const char *fmt, ...)
 	va_list args;
=20
 	va_start(args, fmt);
-	d->printf_fn(d->opts.ctx, fmt, args);
+	d->printf_fn(d->print_ctx, fmt, args);
 	va_end(args);
 }
=20
@@ -129,6 +130,9 @@ struct btf_dump *btf_dump__new(const struct btf *btf,
 	struct btf_dump *d;
 	int err;
=20
+	if (!OPTS_VALID(opts, btf_dump_opts))
+		return ERR_PTR(-EINVAL);
+
 	d =3D calloc(1, sizeof(struct btf_dump));
 	if (!d)
 		return ERR_PTR(-ENOMEM);
@@ -136,7 +140,8 @@ struct btf_dump *btf_dump__new(const struct btf *btf,
 	d->btf =3D btf;
 	d->btf_ext =3D btf_ext;
 	d->printf_fn =3D printf_fn;
-	d->opts.ctx =3D opts ? opts->ctx : NULL;
+	d->print_ctx =3D OPTS_GET(opts, ctx, NULL);
+	d->strip_mods =3D OPTS_GET(opts, strip_mods, false);
=20
 	d->type_names =3D hashmap__new(str_hash_fn, str_equal_fn, NULL);
 	if (IS_ERR(d->type_names)) {
@@ -1045,6 +1050,10 @@ static void btf_dump_emit_type_decl(struct btf_dum=
p *d, __u32 id,
=20
 	stack_start =3D d->decl_stack_cnt;
 	for (;;) {
+		t =3D btf__type_by_id(d->btf, id);
+		if (d->strip_mods && btf_is_mod(t))
+			goto skip_mod;
+
 		err =3D btf_dump_push_decl_stack_id(d, id);
 		if (err < 0) {
 			/*
@@ -1056,12 +1065,11 @@ static void btf_dump_emit_type_decl(struct btf_du=
mp *d, __u32 id,
 			d->decl_stack_cnt =3D stack_start;
 			return;
 		}
-
+skip_mod:
 		/* VOID */
 		if (id =3D=3D 0)
 			break;
=20
-		t =3D btf__type_by_id(d->btf, id);
 		switch (btf_kind(t)) {
 		case BTF_KIND_PTR:
 		case BTF_KIND_VOLATILE:
--=20
2.24.1

