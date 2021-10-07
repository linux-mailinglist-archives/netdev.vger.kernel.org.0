Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E52424EC3
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240607AbhJGIME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:12:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60974 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240459AbhJGIMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 04:12:03 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1971WTRw027360
        for <netdev@vger.kernel.org>; Thu, 7 Oct 2021 01:10:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ifuXOoxl1ckWpXtbkBf8Qpp1mDzC9gMA6gFr8yJ3GTU=;
 b=q8BpGDtTP9jvKckucKdOT4KLuua/KM+6ASfgt9KcoTWHIUqC2akiQRncH0vIYCPOiM18
 q3olzNw0YNqQbLaM0MsI/pjS6i0wdK2dCdBosp3vq84ZG4N5C4PQMdM6wY4mCHomGxw8
 lR6hjQVd9MTV7VexfQ/E3ry2uPhYMCI1nyo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3bhnf1asq8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 01:10:09 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 7 Oct 2021 01:10:08 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 49F987AA99AA; Thu,  7 Oct 2021 01:10:01 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH bpf-next 1/2] bpf: add insn_processed to bpf_prog_info and fdinfo
Date:   Thu, 7 Oct 2021 01:09:51 -0700
Message-ID: <20211007080952.1255615-2-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007080952.1255615-1-davemarchevsky@fb.com>
References: <20211007080952.1255615-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: FWxKpOfqtGq8wjBTGF-4QfEIj3WOyLLw
X-Proofpoint-ORIG-GUID: FWxKpOfqtGq8wjBTGF-4QfEIj3WOyLLw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0
 mlxlogscore=877 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110070055
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This stat is currently printed in the verifier log and not stored
anywhere. To ease consumption of this data, add a field to bpf_prog_aux
so it can be exposed via BPF_OBJ_GET_INFO_BY_FD and fdinfo.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
---
 include/linux/bpf.h            | 1 +
 include/uapi/linux/bpf.h       | 1 +
 kernel/bpf/syscall.c           | 8 ++++++--
 kernel/bpf/verifier.c          | 1 +
 tools/include/uapi/linux/bpf.h | 1 +
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d604c8251d88..921ad62b892c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -887,6 +887,7 @@ struct bpf_prog_aux {
 	struct bpf_prog *prog;
 	struct user_struct *user;
 	u64 load_time; /* ns since boottime */
+	u64 verif_insn_processed;
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	char name[BPF_OBJ_NAME_LEN];
 #ifdef CONFIG_SECURITY
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..89be6ecf9204 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5613,6 +5613,7 @@ struct bpf_prog_info {
 	__u64 run_time_ns;
 	__u64 run_cnt;
 	__u64 recursion_misses;
+	__u64 verif_insn_processed;
 } __attribute__((aligned(8)));
=20
 struct bpf_map_info {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..ea452ced2296 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1848,7 +1848,8 @@ static void bpf_prog_show_fdinfo(struct seq_file *m=
, struct file *filp)
 		   "prog_id:\t%u\n"
 		   "run_time_ns:\t%llu\n"
 		   "run_cnt:\t%llu\n"
-		   "recursion_misses:\t%llu\n",
+		   "recursion_misses:\t%llu\n"
+		   "verif_insn_processed:\t%llu\n",
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
+		   prog->aux->verif_insn_processed);
 }
 #endif
=20
@@ -3625,6 +3627,8 @@ static int bpf_prog_get_info_by_fd(struct file *fil=
e,
 	info.run_cnt =3D stats.cnt;
 	info.recursion_misses =3D stats.misses;
=20
+	info.verif_insn_processed =3D prog->aux->verif_insn_processed;
+
 	if (!bpf_capable()) {
 		info.jited_prog_len =3D 0;
 		info.xlated_prog_len =3D 0;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 20900a1bac12..9ca301191d78 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14038,6 +14038,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_a=
ttr *attr, bpfptr_t uattr)
=20
 	env->verification_time =3D ktime_get_ns() - start_time;
 	print_verification_stats(env);
+	env->prog->aux->verif_insn_processed =3D env->insn_processed;
=20
 	if (log->level && bpf_verifier_log_full(log))
 		ret =3D -ENOSPC;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 6fc59d61937a..89be6ecf9204 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5613,6 +5613,7 @@ struct bpf_prog_info {
 	__u64 run_time_ns;
 	__u64 run_cnt;
 	__u64 recursion_misses;
+	__u64 verif_insn_processed;
 } __attribute__((aligned(8)));
=20
 struct bpf_map_info {
--=20
2.30.2

