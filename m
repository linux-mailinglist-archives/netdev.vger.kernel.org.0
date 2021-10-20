Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796DC43462F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 09:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhJTHu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 03:50:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34596 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229686AbhJTHu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 03:50:57 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JNwbf3021356
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:48:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hrG3WS5otBCeo7xd/9890qipChFqSKTUEocOc9YRt4k=;
 b=fDT38RrQL0vbR1XkOednz8CpIwgXYj9z9W44OvQ831Qz78PWsqTQPdl6G3Auk3o5CfIa
 uPWkV+wgNYADa9TV6TwpupJiLbkw1yR0MSBuQ+ftAqDgxlw/jVLgK8V9YJW/sGczlWDO
 G0zFK8+mc3fRSUwN9yT2tY6Wp26Quc/nAjY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bt85gj4dg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:48:43 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 20 Oct 2021 00:48:41 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 0777D84FD51C; Wed, 20 Oct 2021 00:48:30 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v3 bpf-next 1/2] bpf: add verified_insns to bpf_prog_info and fdinfo
Date:   Wed, 20 Oct 2021 00:48:17 -0700
Message-ID: <20211020074818.1017682-2-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211020074818.1017682-1-davemarchevsky@fb.com>
References: <20211020074818.1017682-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: BLuRprFZKuzfeLTb5aB2MuM3GncniI5R
X-Proofpoint-ORIG-GUID: BLuRprFZKuzfeLTb5aB2MuM3GncniI5R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=896 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This stat is currently printed in the verifier log and not stored
anywhere. To ease consumption of this data, add a field to bpf_prog_aux
so it can be exposed via BPF_OBJ_GET_INFO_BY_FD and fdinfo.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/bpf.h            | 1 +
 include/uapi/linux/bpf.h       | 1 +
 kernel/bpf/syscall.c           | 8 ++++++--
 kernel/bpf/verifier.c          | 1 +
 tools/include/uapi/linux/bpf.h | 1 +
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d604c8251d88..c93fd845a758 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -887,6 +887,7 @@ struct bpf_prog_aux {
 	struct bpf_prog *prog;
 	struct user_struct *user;
 	u64 load_time; /* ns since boottime */
+	u32 verified_insns;
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	char name[BPF_OBJ_NAME_LEN];
 #ifdef CONFIG_SECURITY
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..35571a9878ac 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5613,6 +5613,7 @@ struct bpf_prog_info {
 	__u64 run_time_ns;
 	__u64 run_cnt;
 	__u64 recursion_misses;
+	__u32 verified_insns;
 } __attribute__((aligned(8)));
=20
 struct bpf_map_info {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..5beb321b3b3b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1848,7 +1848,8 @@ static void bpf_prog_show_fdinfo(struct seq_file *m=
, struct file *filp)
 		   "prog_id:\t%u\n"
 		   "run_time_ns:\t%llu\n"
 		   "run_cnt:\t%llu\n"
-		   "recursion_misses:\t%llu\n",
+		   "recursion_misses:\t%llu\n"
+		   "verified_insns:\t%u\n",
 		   prog->type,
 		   prog->jited,
 		   prog_tag,
@@ -1856,7 +1857,8 @@ static void bpf_prog_show_fdinfo(struct seq_file *m=
, struct file *filp)
 		   prog->aux->id,
 		   stats.nsecs,
 		   stats.cnt,
-		   stats.misses);
+		   stats.misses,
+		   prog->aux->verified_insns);
 }
 #endif
=20
@@ -3625,6 +3627,8 @@ static int bpf_prog_get_info_by_fd(struct file *fil=
e,
 	info.run_cnt =3D stats.cnt;
 	info.recursion_misses =3D stats.misses;
=20
+	info.verified_insns =3D prog->aux->verified_insns;
+
 	if (!bpf_capable()) {
 		info.jited_prog_len =3D 0;
 		info.xlated_prog_len =3D 0;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 21cdff35a2f9..c6616e325803 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14033,6 +14033,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_a=
ttr *attr, bpfptr_t uattr)
=20
 	env->verification_time =3D ktime_get_ns() - start_time;
 	print_verification_stats(env);
+	env->prog->aux->verified_insns =3D env->insn_processed;
=20
 	if (log->level && bpf_verifier_log_full(log))
 		ret =3D -ENOSPC;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 6fc59d61937a..35571a9878ac 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5613,6 +5613,7 @@ struct bpf_prog_info {
 	__u64 run_time_ns;
 	__u64 run_cnt;
 	__u64 recursion_misses;
+	__u32 verified_insns;
 } __attribute__((aligned(8)));
=20
 struct bpf_map_info {
--=20
2.30.2

