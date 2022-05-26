Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6872A53559C
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349141AbiEZVf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349154AbiEZVfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:35:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF0DE8B94;
        Thu, 26 May 2022 14:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2985B8220C;
        Thu, 26 May 2022 21:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D24CC385B8;
        Thu, 26 May 2022 21:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600946;
        bh=55vMxTNC78HEzajfYA0GwixGzn3CPwaM3SYJnNLVFv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHIwe1W3dYizhTDrZPaEsA13j8XXlWsR6Ul9Ay3OpjtTm86u6JUr6Yg+uPyFfXSr4
         PlRyXOFZox1Tzd4gB4uS2eOBf8sHwQkJp3WLpPNez+lRQYFIxk/6nfENVXBeuWWAcq
         mr1YD6/eM8Hmwx+qZqQZisfFYIKM78KbRLUogs1GUfbUSVL12e1J0Oc7eO9mqsgcFO
         /ejzOLUOYjo+cQz5jkwHhonQdB6+llvhijcUHOt2bciK29AgfijNPfmFnMkuWFHNTy
         c7daAETXo6i2sWEcdaOX9duDcRqvOWm2BqeCkCKL2kQ96PgUff3jWTF4EHHK1HwjVn
         gt8auWIKwUkIA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 05/14] bpf: Support passing rdonly PTR_TO_BTF_ID to kfunc
Date:   Thu, 26 May 2022 23:34:53 +0200
Message-Id: <11db1566d1802780723a895da47d232aaebc5f5c.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

The kfunc must declare its argument as pointer to const struct, which
will be used to allow read only PTR_TO_BTF_ID to be only passed to such
arguments. Normal PTR_TO_BTF_ID can also be passed to functions
expecting read only PTR_TO_BTF_ID.

The kptr_get function for now doesn't support kptr_get on such kptr to
const, however it can be supported in the future (by indicating const
in the prototype of kptr_get kfunc).

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/btf.c                 | 22 ++++++++++++++++++++--
 net/netfilter/nf_conntrack_bpf.c |  4 ++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 58de6d1204ee..9b9fbb43c417 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6109,6 +6109,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		enum bpf_arg_type arg_type = ARG_DONTCARE;
 		u32 regno = i + 1;
 		struct bpf_reg_state *reg = &regs[regno];
+		bool is_ref_t_const = false;
 
 		t = btf_type_skip_modifiers(btf, args[i].type, NULL);
 		if (btf_type_is_scalar(t)) {
@@ -6132,7 +6133,14 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			return -EINVAL;
 		}
 
-		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
+		ref_id = t->type;
+		ref_t = btf_type_by_id(btf, ref_id);
+		while (btf_type_is_modifier(ref_t)) {
+			if (btf_type_is_const(ref_t))
+				is_ref_t_const = true;
+			ref_id = ref_t->type;
+			ref_t = btf_type_by_id(btf, ref_id);
+		}
 		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
 
 		if (rel && reg->ref_obj_id)
@@ -6166,6 +6174,11 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				return -EINVAL;
 			}
 
+			if (off_desc->kptr.flags & BPF_KPTR_F_RDONLY) {
+				bpf_log(log, "arg#0 cannot raise reference for pointer to const\n");
+				return -EINVAL;
+			}
+
 			if (!btf_type_is_ptr(ref_t)) {
 				bpf_log(log, "arg#0 BTF type must be a double pointer\n");
 				return -EINVAL;
@@ -6197,6 +6210,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				return -EINVAL;
 			}
 		} else if (is_kfunc && (reg->type == PTR_TO_BTF_ID ||
+			   reg->type == (PTR_TO_BTF_ID | MEM_RDONLY) ||
 			   (reg2btf_ids[base_type(reg->type)] && !type_flag(reg->type)))) {
 			const struct btf_type *reg_ref_t;
 			const struct btf *reg_btf;
@@ -6210,7 +6224,11 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				return -EINVAL;
 			}
 
-			if (reg->type == PTR_TO_BTF_ID) {
+			if (base_type(reg->type) == PTR_TO_BTF_ID) {
+				if ((reg->type & MEM_RDONLY) && !is_ref_t_const) {
+					bpf_log(log, "cannot pass read only pointer to arg#%d", i);
+					return -EINVAL;
+				}
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
 				/* Ensure only one argument is referenced PTR_TO_BTF_ID */
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 85f142739a21..195ec68d309d 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -210,11 +210,11 @@ bpf_skb_ct_lookup(struct __sk_buff *skb_ctx, struct bpf_sock_tuple *bpf_tuple,
  * @nf_conn	 - Pointer to referenced nf_conn object, obtained using
  *		   bpf_xdp_ct_lookup or bpf_skb_ct_lookup.
  */
-void bpf_ct_release(struct nf_conn *nfct)
+void bpf_ct_release(const struct nf_conn *nfct)
 {
 	if (!nfct)
 		return;
-	nf_ct_put(nfct);
+	nf_ct_put((struct nf_conn *)nfct);
 }
 
 __diag_pop()
-- 
2.35.3

