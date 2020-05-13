Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F7A1D1F12
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390552AbgEMT0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:26:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10442 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390449AbgEMT0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:26:13 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04DJQ70H011611
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LJLH95qbJ8TPH3V/6PS/akLdfKIx47Z5kPqOpf5GDjA=;
 b=V6lOQiKaKMmKRinsf1UCm73+V2Lppfh0XYx9fIiIFDrpLFEAnRwsTyJrHl4ToylugHuu
 JeXn0hSTQM/WYBSgQMOVBANz8bzDhp6z8yGVjIs/dT65BokZr2I++woZwp/LyXBFETRm
 Fx4gH0yOQDEMYe+0zahCvDcOPUasy4TZnME= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3100xh6v0v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:11 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 12:26:09 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5534A2EC3007; Wed, 13 May 2020 12:26:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/6] bpf: track reference type in verifier
Date:   Wed, 13 May 2020 12:25:29 -0700
Message-ID: <20200513192532.4058934-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200513192532.4058934-1-andriin@fb.com>
References: <20200513192532.4058934-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=25 mlxlogscore=999 phishscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends verifier's reference tracking logic with tracking
a reference type and ensuring acquire()/release() functions accept only t=
he
right types of references. Currently, ambiguity between socket and ringbu=
f
record references is resolved through use of different types of input
arguments to bpf_sk_release() and bpf_ringbuf_commit(): ARG_PTR_TO_SOCK_C=
OMMON
and ARG_PTR_TO_ALLOC_MEM, respectively. It is thus impossible to pass rin=
gbuf
record pointer to bpf_sk_release() (and vice versa for socket).

On the other hand, patch #1 added ARG_PTR_TO_ALLOC_MEM arg type, which, f=
rom
the point of view of verifier, is a pointer to a fixed-sized allocated me=
mory
region. This is generic enough concept that could be used for other BPF
helpers (e.g., malloc/free pair, if added). once we have that, there will=
 be
nothing to prevent passing ringbuf record to bpf_mem_free() (or whatever)
helper. To that end, this patch adds a capability to specify and track
reference types, that would be validated by verifier to ensure correct ma=
tch
between acquire() and release() helpers.

This patch can be postponed for later, so is posted separate from other
verifier changes.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf_verifier.h |  8 +++
 kernel/bpf/verifier.c        | 96 +++++++++++++++++++++++++++++-------
 2 files changed, 86 insertions(+), 18 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index c94a736e53cd..2a6d961570cb 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -164,6 +164,12 @@ struct bpf_stack_state {
 	u8 slot_type[BPF_REG_SIZE];
 };
=20
+enum bpf_ref_type {
+	BPF_REF_INVALID,
+	BPF_REF_SOCKET,
+	BPF_REF_RINGBUF,
+};
+
 struct bpf_reference_state {
 	/* Track each reference created with a unique id, even if the same
 	 * instruction creates the reference multiple times (eg, via CALL).
@@ -173,6 +179,8 @@ struct bpf_reference_state {
 	 * is used purely to inform the user of a reference leak.
 	 */
 	int insn_idx;
+	/* Type of reference being tracked */
+	enum bpf_ref_type ref_type;
 };
=20
 /* state of the program:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b8f0158d2327..dc741a631089 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -436,6 +436,19 @@ static bool is_release_function(enum bpf_func_id fun=
c_id)
 	       func_id =3D=3D BPF_FUNC_ringbuf_discard;
 }
=20
+static enum bpf_ref_type get_release_ref_type(enum bpf_func_id func_id)
+{
+	switch (func_id) {
+	case BPF_FUNC_sk_release:
+		return BPF_REF_SOCKET;
+	case BPF_FUNC_ringbuf_submit:
+	case BPF_FUNC_ringbuf_discard:
+		return BPF_REF_RINGBUF;
+	default:
+		return BPF_REF_INVALID;
+	}
+}
+
 static bool may_be_acquire_function(enum bpf_func_id func_id)
 {
 	return func_id =3D=3D BPF_FUNC_sk_lookup_tcp ||
@@ -464,6 +477,28 @@ static bool is_acquire_function(enum bpf_func_id fun=
c_id,
 	return false;
 }
=20
+static enum bpf_ref_type get_acquire_ref_type(enum bpf_func_id func_id,
+					      const struct bpf_map *map)
+{
+	enum bpf_map_type map_type =3D map ? map->map_type : BPF_MAP_TYPE_UNSPE=
C;
+
+	switch (func_id) {
+	case BPF_FUNC_sk_lookup_tcp:
+	case BPF_FUNC_sk_lookup_udp:
+	case BPF_FUNC_skc_lookup_tcp:
+		return BPF_REF_SOCKET;
+	case BPF_FUNC_map_lookup_elem:
+		if (map_type =3D=3D BPF_MAP_TYPE_SOCKMAP ||
+		    map_type =3D=3D BPF_MAP_TYPE_SOCKHASH)
+			return BPF_REF_SOCKET;
+		return BPF_REF_INVALID;
+	case BPF_FUNC_ringbuf_reserve:
+		return BPF_REF_RINGBUF;
+	default:
+		return BPF_REF_INVALID;
+	}
+}
+
 static bool is_ptr_cast_function(enum bpf_func_id func_id)
 {
 	return func_id =3D=3D BPF_FUNC_tcp_sock ||
@@ -736,7 +771,8 @@ static int realloc_func_state(struct bpf_func_state *=
state, int stack_size,
  * On success, returns a valid pointer id to associate with the register
  * On failure, returns a negative errno.
  */
-static int acquire_reference_state(struct bpf_verifier_env *env, int ins=
n_idx)
+static int acquire_reference_state(struct bpf_verifier_env *env,
+				   int insn_idx, enum bpf_ref_type ref_type)
 {
 	struct bpf_func_state *state =3D cur_func(env);
 	int new_ofs =3D state->acquired_refs;
@@ -748,25 +784,32 @@ static int acquire_reference_state(struct bpf_verif=
ier_env *env, int insn_idx)
 	id =3D ++env->id_gen;
 	state->refs[new_ofs].id =3D id;
 	state->refs[new_ofs].insn_idx =3D insn_idx;
+	state->refs[new_ofs].ref_type =3D ref_type;
=20
 	return id;
 }
=20
 /* release function corresponding to acquire_reference_state(). Idempote=
nt. */
-static int release_reference_state(struct bpf_func_state *state, int ptr=
_id)
+static int release_reference_state(struct bpf_func_state *state, int ptr=
_id,
+				   enum bpf_ref_type ref_type)
 {
+	struct bpf_reference_state *ref;
 	int i, last_idx;
=20
 	last_idx =3D state->acquired_refs - 1;
 	for (i =3D 0; i < state->acquired_refs; i++) {
-		if (state->refs[i].id =3D=3D ptr_id) {
-			if (last_idx && i !=3D last_idx)
-				memcpy(&state->refs[i], &state->refs[last_idx],
-				       sizeof(*state->refs));
-			memset(&state->refs[last_idx], 0, sizeof(*state->refs));
-			state->acquired_refs--;
-			return 0;
-		}
+		ref =3D &state->refs[i];
+		if (ref->id !=3D ptr_id)
+			continue;
+
+		if (ref_type !=3D BPF_REF_INVALID && ref->ref_type !=3D ref_type)
+			return -EINVAL;
+
+		if (i !=3D last_idx)
+			memcpy(ref, &state->refs[last_idx], sizeof(*ref));
+		memset(&state->refs[last_idx], 0, sizeof(*ref));
+		state->acquired_refs--;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -4295,14 +4338,13 @@ static void release_reg_references(struct bpf_ver=
ifier_env *env,
 /* The pointer with the specified id has released its reference to kerne=
l
  * resources. Identify all copies of the same pointer and clear the refe=
rence.
  */
-static int release_reference(struct bpf_verifier_env *env,
-			     int ref_obj_id)
+static int release_reference(struct bpf_verifier_env *env, int ref_obj_i=
d,
+			     enum bpf_ref_type ref_type)
 {
 	struct bpf_verifier_state *vstate =3D env->cur_state;
-	int err;
-	int i;
+	int err, i;
=20
-	err =3D release_reference_state(cur_func(env), ref_obj_id);
+	err =3D release_reference_state(cur_func(env), ref_obj_id, ref_type);
 	if (err)
 		return err;
=20
@@ -4661,7 +4703,16 @@ static int check_helper_call(struct bpf_verifier_e=
nv *env, int func_id, int insn
 			return err;
 		}
 	} else if (is_release_function(func_id)) {
-		err =3D release_reference(env, meta.ref_obj_id);
+		enum bpf_ref_type ref_type;
+
+		ref_type =3D get_release_ref_type(func_id);
+		if (ref_type =3D=3D BPF_REF_INVALID) {
+			verbose(env, "unrecognized reference accepted by func %s#%d\n",
+				func_id_name(func_id), func_id);
+			return -EFAULT;
+		}
+
+		err =3D release_reference(env, meta.ref_obj_id, ref_type);
 		if (err) {
 			verbose(env, "func %s#%d reference has not been acquired before\n",
 				func_id_name(func_id), func_id);
@@ -4744,8 +4795,17 @@ static int check_helper_call(struct bpf_verifier_e=
nv *env, int func_id, int insn
 		/* For release_reference() */
 		regs[BPF_REG_0].ref_obj_id =3D meta.ref_obj_id;
 	} else if (is_acquire_function(func_id, meta.map_ptr)) {
-		int id =3D acquire_reference_state(env, insn_idx);
+		enum bpf_ref_type ref_type;
+		int id;
+
+		ref_type =3D get_acquire_ref_type(func_id, meta.map_ptr);
+		if (ref_type =3D=3D BPF_REF_INVALID) {
+			verbose(env, "unrecognized reference returned by func %s#%d\n",
+				func_id_name(func_id), func_id);
+			return -EINVAL;
+		}
=20
+		id =3D acquire_reference_state(env, insn_idx, ref_type);
 		if (id < 0)
 			return id;
 		/* For mark_ptr_or_null_reg() */
@@ -6728,7 +6788,7 @@ static void mark_ptr_or_null_regs(struct bpf_verifi=
er_state *vstate, u32 regno,
 		 * No one could have freed the reference state before
 		 * doing the NULL check.
 		 */
-		WARN_ON_ONCE(release_reference_state(state, id));
+		WARN_ON_ONCE(release_reference_state(state, id, BPF_REF_INVALID));
=20
 	for (i =3D 0; i <=3D vstate->curframe; i++)
 		__mark_ptr_or_null_regs(vstate->frame[i], id, is_null);
--=20
2.24.1

