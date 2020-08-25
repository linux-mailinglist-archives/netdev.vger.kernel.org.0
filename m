Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4496525240E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHYXUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:20:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726627AbgHYXUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:20:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07PNJX5s019359
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=6hP5mUKG/j4pRCIHETlDk5rGb7u5IR+keJvIHYWiKi4=;
 b=h4HDgXe423usHrrmubcMu4Ztvdwqyn0R/8FdSR2E2aLqetI9I+Rs5Z4Kkm17ya/QhBZW
 uqI3DhsFDdZ/J64Hz0IhsXym7VsH8PsrlFAB6Rl6wUKx5Oq+4IG7SXH1eplkJPzEB8iW
 BmhnGPSzoBKvLERH8wDNsmr1t2ebbmu134k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3359k9ryd1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:45 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 16:20:44 -0700
Received: by devbig218.frc2.facebook.com (Postfix, from userid 116055)
        id A03182077AE; Tue, 25 Aug 2020 16:20:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Udip Pant <udippant@fb.com>
Smtp-Origin-Hostname: devbig218.frc2.facebook.com
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Smtp-Origin-Cluster: frc2c02
Subject: [PATCH bpf-next v3 1/4] bpf: verifier: use target program's type for access verifications
Date:   Tue, 25 Aug 2020 16:20:00 -0700
Message-ID: <20200825232003.2877030-2-udippant@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200825232003.2877030-1-udippant@fb.com>
References: <20200825232003.2877030-1-udippant@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_10:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008250173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds changes in verifier to make decisions such as granting
of read / write access or enforcement of return code status based on
the program type of the target program while using dynamic program
extension (of type BPF_PROG_TYPE_EXT).

The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, SKB
and others. Since the BPF_PROG_TYPE_EXT program type on itself is just a
placeholder for those, we need this extended check for those extended
programs to actually work with proper access, while using this option.

Specifically, it introduces following changes:
- may_access_direct_pkt_data:
    allow access to packet data based on the target prog
- check_return_code:
    enforce return code based on the target prog
    (currently, this check is skipped for EXT program)
- check_ld_abs:
    check for 'may_access_skb' based on the target prog
- check_map_prog_compatibility:
    enforce the map compatibility check based on the target prog
- may_update_sockmap:
    allow sockmap update based on the target prog

Some other occurrences of prog->type is left as it without replacing
with the 'resolved' type:
- do_check_common() and check_attach_btf_id():
    already have specific logic to handle the EXT prog type
- jit_subprogs() and bpf_check():
    Not changed for jit compilation or while inferring env->ops

Next few patches in this series include selftests for some of these cases=
.

Signed-off-by: Udip Pant <udippant@fb.com>
---
 kernel/bpf/verifier.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 38748794518e..95c715508034 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2625,11 +2625,19 @@ static int check_map_access(struct bpf_verifier_e=
nv *env, u32 regno,
=20
 #define MAX_PACKET_OFF 0xffff
=20
+static enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
+{
+	return prog->aux->linked_prog ? prog->aux->linked_prog->type
+				      : prog->type;
+}
+
 static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
 				       const struct bpf_call_arg_meta *meta,
 				       enum bpf_access_type t)
 {
-	switch (env->prog->type) {
+	enum bpf_prog_type prog_type =3D resolve_prog_type(env->prog);
+
+	switch (prog_type) {
 	/* Program types only with direct read access go here! */
 	case BPF_PROG_TYPE_LWT_IN:
 	case BPF_PROG_TYPE_LWT_OUT:
@@ -4181,7 +4189,7 @@ static int check_func_arg(struct bpf_verifier_env *=
env, u32 arg,
 static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id=
)
 {
 	enum bpf_attach_type eatype =3D env->prog->expected_attach_type;
-	enum bpf_prog_type type =3D env->prog->type;
+	enum bpf_prog_type type =3D resolve_prog_type(env->prog);
=20
 	if (func_id !=3D BPF_FUNC_map_update_elem)
 		return false;
@@ -7366,7 +7374,7 @@ static int check_ld_abs(struct bpf_verifier_env *en=
v, struct bpf_insn *insn)
 	u8 mode =3D BPF_MODE(insn->code);
 	int i, err;
=20
-	if (!may_access_skb(env->prog->type)) {
+	if (!may_access_skb(resolve_prog_type(env->prog))) {
 		verbose(env, "BPF_LD_[ABS|IND] instructions not allowed for this progr=
am type\n");
 		return -EINVAL;
 	}
@@ -7454,11 +7462,12 @@ static int check_return_code(struct bpf_verifier_=
env *env)
 	const struct bpf_prog *prog =3D env->prog;
 	struct bpf_reg_state *reg;
 	struct tnum range =3D tnum_range(0, 1);
+	enum bpf_prog_type prog_type =3D resolve_prog_type(env->prog);
 	int err;
=20
 	/* LSM and struct_ops func-ptr's return type could be "void" */
-	if ((env->prog->type =3D=3D BPF_PROG_TYPE_STRUCT_OPS ||
-	     env->prog->type =3D=3D BPF_PROG_TYPE_LSM) &&
+	if ((prog_type =3D=3D BPF_PROG_TYPE_STRUCT_OPS ||
+	     prog_type =3D=3D BPF_PROG_TYPE_LSM) &&
 	    !prog->aux->attach_func_proto->type)
 		return 0;
=20
@@ -7477,7 +7486,7 @@ static int check_return_code(struct bpf_verifier_en=
v *env)
 		return -EACCES;
 	}
=20
-	switch (env->prog->type) {
+	switch (prog_type) {
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 		if (env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP4_RECVMSG ||
 		    env->prog->expected_attach_type =3D=3D BPF_CGROUP_UDP6_RECVMSG ||
@@ -9233,6 +9242,7 @@ static int check_map_prog_compatibility(struct bpf_=
verifier_env *env,
 					struct bpf_prog *prog)
=20
 {
+	enum bpf_prog_type prog_type =3D resolve_prog_type(prog);
 	/*
 	 * Validate that trace type programs use preallocated hash maps.
 	 *
@@ -9250,8 +9260,8 @@ static int check_map_prog_compatibility(struct bpf_=
verifier_env *env,
 	 * now, but warnings are emitted so developers are made aware of
 	 * the unsafety and can fix their programs before this is enforced.
 	 */
-	if (is_tracing_prog_type(prog->type) && !is_preallocated_map(map)) {
-		if (prog->type =3D=3D BPF_PROG_TYPE_PERF_EVENT) {
+	if (is_tracing_prog_type(prog_type) && !is_preallocated_map(map)) {
+		if (prog_type =3D=3D BPF_PROG_TYPE_PERF_EVENT) {
 			verbose(env, "perf_event programs can only use preallocated hash map\=
n");
 			return -EINVAL;
 		}
@@ -9263,8 +9273,8 @@ static int check_map_prog_compatibility(struct bpf_=
verifier_env *env,
 		verbose(env, "trace type programs with run-time allocated hash maps ar=
e unsafe. Switch to preallocated hash maps.\n");
 	}
=20
-	if ((is_tracing_prog_type(prog->type) ||
-	     prog->type =3D=3D BPF_PROG_TYPE_SOCKET_FILTER) &&
+	if ((is_tracing_prog_type(prog_type) ||
+	     prog_type =3D=3D BPF_PROG_TYPE_SOCKET_FILTER) &&
 	    map_value_has_spin_lock(map)) {
 		verbose(env, "tracing progs cannot use bpf_spin_lock yet\n");
 		return -EINVAL;
@@ -9976,7 +9986,7 @@ static int convert_ctx_accesses(struct bpf_verifier=
_env *env)
 				insn->code =3D BPF_LDX | BPF_PROBE_MEM |
 					BPF_SIZE((insn)->code);
 				env->prog->aux->num_exentries++;
-			} else if (env->prog->type !=3D BPF_PROG_TYPE_STRUCT_OPS) {
+			} else if (resolve_prog_type(env->prog) !=3D BPF_PROG_TYPE_STRUCT_OPS=
) {
 				verbose(env, "Writes through BTF pointers are not allowed\n");
 				return -EINVAL;
 			}
--=20
2.24.1

