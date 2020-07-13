Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A1621E390
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 01:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgGMXZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 19:25:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32210 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbgGMXZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 19:25:00 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DNJo3v000406
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 16:24:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=iO6Z0rbAmQVRyf6UvboOnbNBq/HdRiy1eI3jgGDd/Rc=;
 b=cfpj6LfuWImMP8XTnnfufB6ULlp14Z0j+v8zGWF81kBQBYiOl6fHJAu/JV12SXcuxd7V
 uyBa6SXm146gBGrmBHdYOKsF7BtMBYDeH80DQXpXJhLoTUGYmCLshehVOVF3K2ytEK56
 UMkJxcx/xLIAv8xMZJOu/0tWavhyvYsVjWg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 327b5p26f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 16:24:58 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 16:24:57 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0BAC42EC4105; Mon, 13 Jul 2020 16:24:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/2] libbpf: support stripping modifiers for btf_dump
Date:   Mon, 13 Jul 2020 16:24:08 -0700
Message-ID: <20200713232409.3062144-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200713232409.3062144-1-andriin@fb.com>
References: <20200713232409.3062144-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_17:2020-07-13,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=8 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130170
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
modifier, when requested. This is done as an extra option on
btf_dump__emit_type_decl() API.

Reported-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.h      |  2 ++
 tools/lib/bpf/btf_dump.c | 10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 70c1b7ec2bd0..be98dd75b791 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -143,6 +143,8 @@ struct btf_dump_emit_type_decl_opts {
 	 * necessary indentation already
 	 */
 	int indent_level;
+	/* strip all the const/volatile/restrict mods */
+	bool strip_mods;
 };
 #define btf_dump_emit_type_decl_opts__last_field indent_level
=20
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index bbb430317260..e1c344504cae 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -60,6 +60,7 @@ struct btf_dump {
 	const struct btf_ext *btf_ext;
 	btf_dump_printf_fn_t printf_fn;
 	struct btf_dump_opts opts;
+	bool strip_mods;
=20
 	/* per-type auxiliary state */
 	struct btf_dump_type_aux_state *type_states;
@@ -1032,7 +1033,9 @@ int btf_dump__emit_type_decl(struct btf_dump *d, __=
u32 id,
=20
 	fname =3D OPTS_GET(opts, field_name, "");
 	lvl =3D OPTS_GET(opts, indent_level, 0);
+	d->strip_mods =3D OPTS_GET(opts, strip_mods, false);
 	btf_dump_emit_type_decl(d, id, fname, lvl);
+	d->strip_mods =3D false;
 	return 0;
 }
=20
@@ -1045,6 +1048,10 @@ static void btf_dump_emit_type_decl(struct btf_dum=
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
@@ -1056,12 +1063,11 @@ static void btf_dump_emit_type_decl(struct btf_du=
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

