Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E1125856F
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgIABu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4284 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbgIABuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:16 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0811jr76007764
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ebvfNM5tAkOSSBvFArksu3q6Rpb9v1j/Zzhz/TosMmo=;
 b=msH69ByEPUTDZI/WXk4vyVHgH7jRnCf9werLwzzk6tNnP8WyYSPVGpDRx7hsDDs42XEo
 xgMl7q0JoEqvctBphoiDgK/1xnrAQQXq6M8RXx+wVrz8fJR9uqWDmmqQ3lHgO0txUfJf
 UVfBg1S/pvi6bLN38wMApf06ufZsrEYQcPE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3386gt84eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:14 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:13 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A69752EC663B; Mon, 31 Aug 2020 18:50:11 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 03/14] libbpf: support CO-RE relocations for multi-prog sections
Date:   Mon, 31 Aug 2020 18:49:52 -0700
Message-ID: <20200901015003.2871861-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200901015003.2871861-1-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=8
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up CO-RE relocation code to handle relocations against ELF sections
containing multiple BPF programs. This requires lookup of a BPF program b=
y its
section name and instruction index it contains. While it could have been =
done
as a simple loop, it could run into performance issues pretty quickly, as
number of CO-RE relocations can be quite large in real-world applications=
, and
each CO-RE relocation incurs BPF program look up now. So instead of simpl=
e
loop, implement a binary search by section name + insn offset.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 82 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 74 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 57f87eee5be5..11ad230ec20c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2753,6 +2753,18 @@ static bool ignore_elf_section(GElf_Shdr *hdr, con=
st char *name)
 	return false;
 }
=20
+static int cmp_progs(const void *_a, const void *_b)
+{
+	const struct bpf_program *a =3D _a;
+	const struct bpf_program *b =3D _b;
+
+	if (a->sec_idx !=3D b->sec_idx)
+		return a->sec_idx < b->sec_idx ? -1 : 1;
+
+	/* sec_insn_off can't be the same within the section */
+	return a->sec_insn_off < b->sec_insn_off ? -1 : 1;
+}
+
 static int bpf_object__elf_collect(struct bpf_object *obj)
 {
 	Elf *elf =3D obj->efile.elf;
@@ -2887,6 +2899,11 @@ static int bpf_object__elf_collect(struct bpf_obje=
ct *obj)
 		pr_warn("elf: symbol strings section missing or invalid in %s\n", obj-=
>path);
 		return -LIBBPF_ERRNO__FORMAT;
 	}
+
+	/* sort BPF programs by section name and in-section instruction offset
+	 * for faster search */
+	qsort(obj->programs, obj->nr_programs, sizeof(*obj->programs), cmp_prog=
s);
+
 	return bpf_object__init_btf(obj, btf_data, btf_ext_data);
 }
=20
@@ -3415,6 +3432,37 @@ static int bpf_program__record_reloc(struct bpf_pr=
ogram *prog,
 	return 0;
 }
=20
+static bool prog_contains_insn(const struct bpf_program *prog, size_t in=
sn_idx)
+{
+	return insn_idx >=3D prog->sec_insn_off &&
+	       insn_idx < prog->sec_insn_off + prog->sec_insn_cnt;
+}
+
+static struct bpf_program *find_prog_by_sec_insn(const struct bpf_object=
 *obj,
+						 size_t sec_idx, size_t insn_idx)
+{
+	int l =3D 0, r =3D obj->nr_programs - 1, m;
+	struct bpf_program *prog;
+
+	while (l < r) {
+		m =3D l + (r - l + 1) / 2;
+		prog =3D &obj->programs[m];
+
+		if (prog->sec_idx < sec_idx ||
+		    (prog->sec_idx =3D=3D sec_idx && prog->sec_insn_off <=3D insn_idx)=
)
+			l =3D m;
+		else
+			r =3D m - 1;
+	}
+	/* matching program could be at index l, but it still might be the
+	 * wrong one, so we need to double check conditions for the last time
+	 */
+	prog =3D &obj->programs[l];
+	if (prog->sec_idx =3D=3D sec_idx && prog_contains_insn(prog, insn_idx))
+		return prog;
+	return NULL;
+}
+
 static int
 bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 			   Elf_Data *data, struct bpf_object *obj)
@@ -5229,6 +5277,11 @@ static int bpf_core_patch_insn(struct bpf_program =
*prog,
 	if (relo->insn_off % BPF_INSN_SZ)
 		return -EINVAL;
 	insn_idx =3D relo->insn_off / BPF_INSN_SZ;
+	/* adjust insn_idx from section frame of reference to the local
+	 * program's frame of reference; (sub-)program code is not yet
+	 * relocated, so it's enough to just subtract in-section offset
+	 */
+	insn_idx =3D insn_idx - prog->sec_insn_off;
 	insn =3D &prog->insns[insn_idx];
 	class =3D BPF_CLASS(insn->code);
=20
@@ -5619,7 +5672,7 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
 	struct bpf_program *prog;
 	struct btf *targ_btf;
 	const char *sec_name;
-	int i, err =3D 0;
+	int i, err =3D 0, insn_idx, sec_idx;
=20
 	if (obj->btf_ext->core_relo_info.len =3D=3D 0)
 		return 0;
@@ -5646,24 +5699,37 @@ bpf_object__relocate_core(struct bpf_object *obj,=
 const char *targ_btf_path)
 			err =3D -EINVAL;
 			goto out;
 		}
+		/* bpf_object's ELF is gone by now so it's not easy to find
+		 * section index by section name, but we can find *any*
+		 * bpf_program within desired section name and use it's
+		 * prog->sec_idx to do a proper search by section index and
+		 * instruction offset
+		 */
 		prog =3D NULL;
 		for (i =3D 0; i < obj->nr_programs; i++) {
-			if (!strcmp(obj->programs[i].section_name, sec_name)) {
-				prog =3D &obj->programs[i];
+			prog =3D &obj->programs[i];
+			if (strcmp(prog->section_name, sec_name) =3D=3D 0)
 				break;
-			}
 		}
 		if (!prog) {
-			pr_warn("failed to find program '%s' for CO-RE offset relocation\n",
-				sec_name);
-			err =3D -EINVAL;
-			goto out;
+			pr_warn("sec '%s': failed to find a BPF program\n", sec_name);
+			return -ENOENT;
 		}
+		sec_idx =3D prog->sec_idx;
=20
 		pr_debug("sec '%s': found %d CO-RE relocations\n",
 			 sec_name, sec->num_info);
=20
 		for_each_btf_ext_rec(seg, sec, i, rec) {
+			insn_idx =3D rec->insn_off / BPF_INSN_SZ;
+			prog =3D find_prog_by_sec_insn(obj, sec_idx, insn_idx);
+			if (!prog) {
+				pr_warn("sec '%s': failed to find program at insn #%d for CO-RE offs=
et relocation #%d\n",
+					sec_name, insn_idx, i);
+				err =3D -EINVAL;
+				goto out;
+			}
+
 			err =3D bpf_core_apply_relo(prog, rec, i, obj->btf,
 						  targ_btf, cand_cache);
 			if (err) {
--=20
2.24.1

