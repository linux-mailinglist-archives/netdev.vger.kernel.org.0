Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0EA23F41D
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgHGVGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:06:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30904 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726825AbgHGVGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:06:46 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077Ku8DN000508
        for <netdev@vger.kernel.org>; Fri, 7 Aug 2020 14:06:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=n+JELzjK3JaJE2mrP8GcRwWHFGwRMDRrATAS1ZE54nk=;
 b=Rdpl88pEbjRCLthUWjcB5U+FfHNghPN8vwpY4uYdnrmcxaVpVSX9BYyGd1xna59pWUH9
 F/dQRAKenKjXdKikJPAEdkxKM7WWyyiByyVfLQzS8dLeNWyZ4puRhVSRGB0h1toMJlyr
 +5ymxdzbAND2DOLq2I/WX4tuOo8z/r74RpQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32rvwf4g96-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:06:45 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 7 Aug 2020 14:06:43 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 39B992EC5494; Fri,  7 Aug 2020 14:06:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 4/7] libbpf: sanitize BPF program code for bpf_probe_read_{kernel,user}[_str]
Date:   Fri, 7 Aug 2020 14:06:26 -0700
Message-ID: <20200807210629.394335-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200807210629.394335-1-andriin@fb.com>
References: <20200807210629.394335-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_20:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008070147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF program code sanitization pass, replacing calls to BPF
bpf_probe_read_{kernel,user}[_str]() helpers with bpf_probe_read[_str](),=
 if
libbpf detects that kernel doesn't support new variants.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 80 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 24c806559867..32c71a3b3aef 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -180,6 +180,8 @@ enum kern_feature_id {
 	FEAT_ARRAY_MMAP,
 	/* kernel support for expected_attach_type in BPF_PROG_LOAD */
 	FEAT_EXP_ATTACH_TYPE,
+	/* bpf_probe_read_{kernel,user}[_str] helpers */
+	FEAT_PROBE_READ_KERN,
 	__FEAT_CNT,
 };
=20
@@ -3586,6 +3588,27 @@ static int probe_kern_exp_attach_type(void)
 	return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
 }
=20
+static int probe_kern_probe_read_kernel(void)
+{
+	struct bpf_load_program_attr attr;
+	struct bpf_insn insns[] =3D {
+		BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),	/* r1 =3D r10 (fp) */
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),	/* r1 +=3D -8 */
+		BPF_MOV64_IMM(BPF_REG_2, 8),		/* r2 =3D 8 */
+		BPF_MOV64_IMM(BPF_REG_3, 0),		/* r3 =3D 0 */
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_probe_read_kernel),
+		BPF_EXIT_INSN(),
+	};
+
+	memset(&attr, 0, sizeof(attr));
+	attr.prog_type =3D BPF_PROG_TYPE_KPROBE;
+	attr.insns =3D insns;
+	attr.insns_cnt =3D ARRAY_SIZE(insns);
+	attr.license =3D "GPL";
+
+	return probe_fd(bpf_load_program_xattr(&attr, NULL, 0));
+}
+
 enum kern_feature_result {
 	FEAT_UNKNOWN =3D 0,
 	FEAT_SUPPORTED =3D 1,
@@ -3621,6 +3644,9 @@ static struct kern_feature_desc {
 		"BPF_PROG_LOAD expected_attach_type attribute",
 		probe_kern_exp_attach_type,
 	},
+	[FEAT_PROBE_READ_KERN] =3D {
+		"bpf_probe_read_kernel() helper", probe_kern_probe_read_kernel,
+	}
 };
=20
 static bool kernel_supports(enum kern_feature_id feat_id)
@@ -5326,6 +5352,53 @@ static int bpf_object__collect_reloc(struct bpf_ob=
ject *obj)
 	return 0;
 }
=20
+static bool insn_is_helper_call(struct bpf_insn *insn, enum bpf_func_id =
*func_id)
+{
+	__u8 class =3D BPF_CLASS(insn->code);
+
+	if ((class =3D=3D BPF_JMP || class =3D=3D BPF_JMP32) &&
+	    BPF_OP(insn->code) =3D=3D BPF_CALL &&
+	    BPF_SRC(insn->code) =3D=3D BPF_K &&
+	    insn->src_reg =3D=3D 0 && insn->dst_reg =3D=3D 0) {
+		    if (func_id)
+			    *func_id =3D insn->imm;
+		    return true;
+	}
+	return false;
+}
+
+static int bpf_object__sanitize_prog(struct bpf_object* obj, struct bpf_=
program *prog)
+{
+	struct bpf_insn *insn =3D prog->insns;
+	enum bpf_func_id func_id;
+	int i;
+
+	for (i =3D 0; i < prog->insns_cnt; i++, insn++) {
+		if (!insn_is_helper_call(insn, &func_id))
+			continue;
+
+		/* on kernels that don't yet support
+		 * bpf_probe_read_{kernel,user}[_str] helpers, fall back
+		 * to bpf_probe_read() which works well for old kernels
+		 */
+		switch (func_id) {
+		case BPF_FUNC_probe_read_kernel:
+		case BPF_FUNC_probe_read_user:
+			if (!kernel_supports(FEAT_PROBE_READ_KERN))
+				insn->imm =3D BPF_FUNC_probe_read;
+			break;
+		case BPF_FUNC_probe_read_kernel_str:
+		case BPF_FUNC_probe_read_user_str:
+			if (!kernel_supports(FEAT_PROBE_READ_KERN))
+				insn->imm =3D BPF_FUNC_probe_read_str;
+			break;
+		default:
+			break;
+		}
+	}
+	return 0;
+}
+
 static int
 load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns=
_cnt,
 	     char *license, __u32 kern_version, int *pfd)
@@ -5540,6 +5613,13 @@ bpf_object__load_progs(struct bpf_object *obj, int=
 log_level)
 	size_t i;
 	int err;
=20
+	for (i =3D 0; i < obj->nr_programs; i++) {
+		prog =3D &obj->programs[i];
+		err =3D bpf_object__sanitize_prog(obj, prog);
+		if (err)
+			return err;
+	}
+
 	for (i =3D 0; i < obj->nr_programs; i++) {
 		prog =3D &obj->programs[i];
 		if (bpf_program__is_function_storage(prog, obj))
--=20
2.24.1

