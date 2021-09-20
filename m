Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCEC4117EE
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbhITPNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:13:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2172 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232118AbhITPND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:13:03 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KALb67031444
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:11:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Wfo4D6bGx0psxdGz31HyFVLjxtFxNOZejRJ31RUGuTc=;
 b=J9vcfagdXeTKIL9162ifOTgn0K1Qn+1gcuWwWTNMEHBM7BCT3FTa3j3AdAH/LsEYuRZF
 kKNtrjeaC8o4aLqpzqTqlQ9sYpf5EkJLASrQrBERwdoUb2y6EBPLrqXIr/SOhanyPqFE
 3x/YeyGxGxQDcpbAof9JwalixrXPnb7MRrg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b6f2rbvfh-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:11:36 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 20 Sep 2021 08:11:35 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id D0E3D6E18CBE; Mon, 20 Sep 2021 08:11:25 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [RFC PATCH bpf-next 1/2] bpf: add verifier stats to bpf_prog_info and fdinfo
Date:   Mon, 20 Sep 2021 08:11:11 -0700
Message-ID: <20210920151112.3770991-2-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210920151112.3770991-1-davemarchevsky@fb.com>
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: ZTSOxojrK_qUWwhvSTt8ZLqfriF2rB0q
X-Proofpoint-GUID: ZTSOxojrK_qUWwhvSTt8ZLqfriF2rB0q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200098
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These stats are currently printed in the verifier log and not stored
anywhere. To ease consumption of this data, add a bpf_prog_verif_stats
struct to bpf_prog_aux so they can be exposed via BPF_OBJ_GET_INFO_BY_FD
and fdinfo.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 10 ++++++++++
 kernel/bpf/syscall.c           | 20 ++++++++++++++++++--
 kernel/bpf/verifier.c          | 13 +++++++++++++
 tools/include/uapi/linux/bpf.h | 10 ++++++++++
 5 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b6c45a6cbbba..206c19b253b7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -876,6 +876,7 @@ struct bpf_prog_aux {
 	struct bpf_kfunc_desc_tab *kfunc_tab;
 	u32 size_poke_tab;
 	struct bpf_ksym ksym;
+	struct bpf_prog_verif_stats verif_stats;
 	const struct bpf_prog_ops *ops;
 	struct bpf_map **used_maps;
 	struct mutex used_maps_mutex; /* mutex for used_maps and used_map_cnt *=
/
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..cb0fa49e62d7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5576,6 +5576,15 @@ struct sk_reuseport_md {
=20
 #define BPF_TAG_SIZE	8
=20
+struct bpf_prog_verif_stats {
+	__u64 verification_time;
+	__u32 insn_processed;
+	__u32 max_states_per_insn;
+	__u32 total_states;
+	__u32 peak_states;
+	__u32 longest_mark_read_walk;
+};
+
 struct bpf_prog_info {
 	__u32 type;
 	__u32 id;
@@ -5613,6 +5622,7 @@ struct bpf_prog_info {
 	__u64 run_time_ns;
 	__u64 run_cnt;
 	__u64 recursion_misses;
+	struct bpf_prog_verif_stats verif_stats;
 } __attribute__((aligned(8)));
=20
 struct bpf_map_info {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..0fa95ebd4276 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1836,9 +1836,11 @@ static void bpf_prog_show_fdinfo(struct seq_file *=
m, struct file *filp)
 {
 	const struct bpf_prog *prog =3D filp->private_data;
 	char prog_tag[sizeof(prog->tag) * 2 + 1] =3D { };
+	struct bpf_prog_verif_stats *verif_stats;
 	struct bpf_prog_stats stats;
=20
 	bpf_prog_get_stats(prog, &stats);
+	verif_stats =3D &prog->aux->verif_stats;
 	bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
 	seq_printf(m,
 		   "prog_type:\t%u\n"
@@ -1848,7 +1850,13 @@ static void bpf_prog_show_fdinfo(struct seq_file *=
m, struct file *filp)
 		   "prog_id:\t%u\n"
 		   "run_time_ns:\t%llu\n"
 		   "run_cnt:\t%llu\n"
-		   "recursion_misses:\t%llu\n",
+		   "recursion_misses:\t%llu\n"
+		   "verification_time:\t%llu\n"
+		   "verif_insn_processed:\t%u\n"
+		   "verif_max_states_per_insn:\t%u\n"
+		   "verif_total_states:\t%u\n"
+		   "verif_peak_states:\t%u\n"
+		   "verif_longest_mark_read_walk:\t%u\n",
 		   prog->type,
 		   prog->jited,
 		   prog_tag,
@@ -1856,7 +1864,13 @@ static void bpf_prog_show_fdinfo(struct seq_file *=
m, struct file *filp)
 		   prog->aux->id,
 		   stats.nsecs,
 		   stats.cnt,
-		   stats.misses);
+		   stats.misses,
+		   verif_stats->verification_time,
+		   verif_stats->insn_processed,
+		   verif_stats->max_states_per_insn,
+		   verif_stats->total_states,
+		   verif_stats->peak_states,
+		   verif_stats->longest_mark_read_walk);
 }
 #endif
=20
@@ -3625,6 +3639,8 @@ static int bpf_prog_get_info_by_fd(struct file *fil=
e,
 	info.run_cnt =3D stats.cnt;
 	info.recursion_misses =3D stats.misses;
=20
+	info.verif_stats =3D prog->aux->verif_stats;
+
 	if (!bpf_capable()) {
 		info.jited_prog_len =3D 0;
 		info.xlated_prog_len =3D 0;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e76b55917905..97cd3b71d5ae 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13245,6 +13245,18 @@ static void print_verification_stats(struct bpf_=
verifier_env *env)
 		env->peak_states, env->longest_mark_read_walk);
 }
=20
+static void populate_aux_verif_stats(struct bpf_verifier_env *env)
+{
+	struct bpf_prog_verif_stats *verif_stats =3D &env->prog->aux->verif_sta=
ts;
+
+	verif_stats->verification_time =3D env->verification_time;
+	verif_stats->insn_processed =3D env->insn_processed;
+	verif_stats->max_states_per_insn =3D env->max_states_per_insn;
+	verif_stats->total_states =3D env->total_states;
+	verif_stats->peak_states =3D env->peak_states;
+	verif_stats->longest_mark_read_walk =3D env->longest_mark_read_walk;
+}
+
 static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 {
 	const struct btf_type *t, *func_proto;
@@ -13826,6 +13838,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_a=
ttr *attr, bpfptr_t uattr)
=20
 	env->verification_time =3D ktime_get_ns() - start_time;
 	print_verification_stats(env);
+	populate_aux_verif_stats(env);
=20
 	if (log->level && bpf_verifier_log_full(log))
 		ret =3D -ENOSPC;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 6fc59d61937a..cb0fa49e62d7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5576,6 +5576,15 @@ struct sk_reuseport_md {
=20
 #define BPF_TAG_SIZE	8
=20
+struct bpf_prog_verif_stats {
+	__u64 verification_time;
+	__u32 insn_processed;
+	__u32 max_states_per_insn;
+	__u32 total_states;
+	__u32 peak_states;
+	__u32 longest_mark_read_walk;
+};
+
 struct bpf_prog_info {
 	__u32 type;
 	__u32 id;
@@ -5613,6 +5622,7 @@ struct bpf_prog_info {
 	__u64 run_time_ns;
 	__u64 run_cnt;
 	__u64 recursion_misses;
+	struct bpf_prog_verif_stats verif_stats;
 } __attribute__((aligned(8)));
=20
 struct bpf_map_info {
--=20
2.30.2

