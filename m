Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665DD69EEA8
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 07:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjBVGIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 01:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjBVGIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 01:08:36 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94509271E
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 22:08:35 -0800 (PST)
Received: by devvm20151.prn0.facebook.com (Postfix, from userid 115148)
        id 3BD35F67D18; Tue, 21 Feb 2023 22:08:26 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com, toke@kernel.org,
        Joanne Koong <joannekoong@gmail.com>
Subject: [PATCH v11 bpf-next 06/10] bpf: Add __uninit kfunc annotation
Date:   Tue, 21 Feb 2023 22:07:43 -0800
Message-Id: <20230222060747.2562549-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230222060747.2562549-1-joannelkoong@gmail.com>
References: <20230222060747.2562549-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,HELO_MISC_IP,NML_ADSP_CUSTOM_MED,
        RDNS_DYNAMIC,SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joanne Koong <joannekoong@gmail.com>

This patch adds __uninit as a kfunc annotation.

This will be useful for scenarios such as for example in dynptrs,
indicating whether the dynptr should be checked by the verifier as an
initialized or an uninitialized dynptr.

Without this annotation, the alternative would be needing to hard-code
in the verifier the specific kfunc to indicate that arg should be
treated as an uninitialized arg.

Signed-off-by: Joanne Koong <joannekoong@gmail.com>
---
 Documentation/bpf/kfuncs.rst | 17 +++++++++++++++++
 kernel/bpf/verifier.c        | 18 ++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index ca96ef3f6896..bbdb6ca6cadb 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -100,6 +100,23 @@ Hence, whenever a constant scalar argument is accept=
ed by a kfunc which is not a
 size parameter, and the value of the constant matters for program safety=
, __k
 suffix should be used.
=20
+2.2.2 __uninit Annotation
+--------------------
+
+This annotation is used to indicate that the argument will be treated as
+uninitialized.
+
+An example is given below::
+
+        __bpf_kfunc int bpf_dynptr_from_skb(..., struct bpf_dynptr_kern =
*ptr__uninit)
+        {
+        ...
+        }
+
+Here, the dynptr will be treated as an uninitialized dynptr. Without thi=
s
+annotation, the verifier will reject the program if the dynptr passed in=
 is
+not initialized.
+
 .. _BPF_kfunc_nodef:
=20
 2.3 Using an existing kernel function
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index babc82e93ae6..df4506c5e5f2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8706,6 +8706,11 @@ static bool is_kfunc_arg_alloc_obj(const struct bt=
f *btf, const struct btf_param
 	return __kfunc_param_match_suffix(btf, arg, "__alloc");
 }
=20
+static bool is_kfunc_arg_uninit(const struct btf *btf, const struct btf_=
param *arg)
+{
+	return __kfunc_param_match_suffix(btf, arg, "__uninit");
+}
+
 static bool is_kfunc_arg_scalar_with_name(const struct btf *btf,
 					  const struct btf_param *arg,
 					  const char *name)
@@ -9642,17 +9647,26 @@ static int check_kfunc_args(struct bpf_verifier_e=
nv *env, struct bpf_kfunc_call_
 				return ret;
 			break;
 		case KF_ARG_PTR_TO_DYNPTR:
+		{
+			enum bpf_arg_type dynptr_arg_type =3D ARG_PTR_TO_DYNPTR;
+
 			if (reg->type !=3D PTR_TO_STACK &&
 			    reg->type !=3D CONST_PTR_TO_DYNPTR) {
 				verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
 				return -EINVAL;
 			}
=20
-			ret =3D process_dynptr_func(env, regno, insn_idx,
-						  ARG_PTR_TO_DYNPTR | MEM_RDONLY);
+			if (reg->type =3D=3D CONST_PTR_TO_DYNPTR)
+				dynptr_arg_type |=3D MEM_RDONLY;
+
+			if (is_kfunc_arg_uninit(btf, &args[i]))
+				dynptr_arg_type |=3D MEM_UNINIT;
+
+			ret =3D process_dynptr_func(env, regno, insn_idx, dynptr_arg_type);
 			if (ret < 0)
 				return ret;
 			break;
+		}
 		case KF_ARG_PTR_TO_LIST_HEAD:
 			if (reg->type !=3D PTR_TO_MAP_VALUE &&
 			    reg->type !=3D (PTR_TO_BTF_ID | MEM_ALLOC)) {
--=20
2.30.2

