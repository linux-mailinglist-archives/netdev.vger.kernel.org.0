Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFEA1986A3
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgC3Vge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:36:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42914 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbgC3Vge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:36:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id h8so9300028pgs.9;
        Mon, 30 Mar 2020 14:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=DqOUTijGS+aQJn340MyvZiFr6Gn+HCKeGFPApzvLUpo=;
        b=bNnLpHl9og1iYfAHSkEIuVARDdV7zVn8CUJEq823uu+ZuxtbnBHqgO4EsRadloIayM
         3AZkFj9DLwsCvoyTm6/WcyMtZ6T0wMWP5sKYHevfobWBXyjiOgKAk9+Eo86giV7dK7wR
         YBEdyAHEXdNPc9h0J1qy4HRZ6Nyz5KMJPwu/1Gch0pmIPU+URjd99YIiNWEuuN+MgBFE
         2RZ2IP9WrA3umCC0cil3ubqjOuYdxv/iv2Cp93sWgP/ayJ1CYwBgTL1GuAf623L3iC2c
         uDqWG/2IjhQQQOIYYLnxVwFeV8ZqR9DxUsCB3wSpGt1q+tvyDNBsiXAZSN+9oez7x7kw
         Mf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DqOUTijGS+aQJn340MyvZiFr6Gn+HCKeGFPApzvLUpo=;
        b=W+mentEo64u0kk1kHZINnEyqpdSHOdh6a/ywkdpwxxkQku/S4/dFv+Wpu31Xf93IV/
         K6CghBllN4iJH827gCt8KuY02e5ItdI/yZ1+NYYqmfDDrFKj0UPtnmc72n9nA3bQqZQk
         +hr1QpxLMYq7gzbs8WWTM6Xl9CbZUkB2qtN1DT1OBM8jBebV75BruNLh16CJysz4VVt3
         bQBb5BK40ZLdTg6MrNWIrPQMeaeFV4/JXel2Eekti7aNcelsQlE+AH3w5l9ZSM1N5kln
         3cSJwMviU4aUYzta7ZmM7a3GGjmJ1f4vpLadnt8QJ0zKfAQBfUzllPJGUsTErkKntpMw
         YKaw==
X-Gm-Message-State: ANhLgQ1dAomAOKaZdl2OpTRkUGejYWouD7CcwNWr3Iggzh5B2g9XvxMO
        eRkr/OOLOzh8E0fSjCSIRqktVGjl2n8=
X-Google-Smtp-Source: ADFU+vuGlpbg94k6xxrRIAHPfi3Xxt87tV5bYMF21ToOpI+jNeSSC5Gebg3fuqXW1OJ5wKE+sr8Gqg==
X-Received: by 2002:a62:687:: with SMTP id 129mr15537152pfg.209.1585604192765;
        Mon, 30 Mar 2020 14:36:32 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c128sm10819740pfa.11.2020.03.30.14.36.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2020 14:36:32 -0700 (PDT)
Subject: [bpf-next PATCH v2 1/7] bpf: verifier,
 do_refine_retval_range may clamp umin to 0 incorrectly
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 30 Mar 2020 14:36:19 -0700
Message-ID: <158560417900.10843.14351995140624628941.stgit@john-Precision-5820-Tower>
In-Reply-To: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
References: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

do_refine_retval_range() is called to refine return values from specified
helpers, probe_read_str and get_stack at the moment, the reasoning is
because both have a max value as part of their input arguments and
because the helper ensure the return value will not be larger than this
we can set smax values of the return register, r0.

However, the return value is a signed integer so setting umax is incorrect
It leads to further confusion when the do_refine_retval_range() then calls,
__reg_deduce_bounds() which will see a umax value as meaning the value is
unsigned and then assuming it is unsigned set the smin = umin which in this
case results in 'smin = 0' and an 'smax = X' where X is the input argument
from the helper call.

Here are the comments from _reg_deduce_bounds() on why this would be safe
to do.

 /* Learn sign from unsigned bounds.  Signed bounds cross the sign
  * boundary, so we must be careful.
  */
 if ((s64)reg->umax_value >= 0) {
	/* Positive.  We can't learn anything from the smin, but smax
	 * is positive, hence safe.
	 */
	reg->smin_value = reg->umin_value;
	reg->smax_value = reg->umax_value = min_t(u64, reg->smax_value,
						  reg->umax_value);

But now we incorrectly have a return value with type int with the
signed bounds (0,X). Suppose the return value is negative, which is
possible the we have the verifier and reality out of sync. Among other
things this may result in any error handling code being falsely detected
as dead-code and removed. For instance the example below shows using
bpf_probe_read_str() causes the error path to be identified as dead
code and removed.

>>From the 'llvm-object -S' dump,

 r2 = 100
 call 45
 if r0 s< 0 goto +4
 r4 = *(u32 *)(r7 + 0)

But from dump xlate

  (b7) r2 = 100
  (85) call bpf_probe_read_compat_str#-96768
  (61) r4 = *(u32 *)(r7 +0)  <-- dropped if goto

Due to verifier state after call being

 R0=inv(id=0,umax_value=100,var_off=(0x0; 0x7f))

To fix omit setting the umax value because its not safe. The only
actual bounds we know is the smax. This results in the correct bounds
(SMIN, X) where X is the max length from the helper. After this the
new verifier state looks like the following after call 45.

R0=inv(id=0,smax_value=100)

Then xlated version no longer removed dead code giving the expected
result,

  (b7) r2 = 100
  (85) call bpf_probe_read_compat_str#-96768
  (c5) if r0 s< 0x0 goto pc+4
  (61) r4 = *(u32 *)(r7 +0)

Note, bpf_probe_read_* calls are root only so we wont hit this case
with non-root bpf users.

v3: comment had some documentation about meta set to null case which
is not relevant here and confusing to include in the comment.

v2 note: In original version we set msize_smax_value from check_func_arg()
and propagated this into smax of retval. The logic was smax is the bound
on the retval we set and because the type in the helper is ARG_CONST_SIZE
we know that the reg is a positive tnum_const() so umax=smax. Alexei
pointed out though this is a bit odd to read because the register in
check_func_arg() has a C type of u32 and the umax bound would be the
normally relavent bound here. Pulling in extra knowledge about future
checks makes reading the code a bit tricky. Further having a signed
meta data that can only ever be positive is also a bit odd. So dropped
the msize_smax_value metadata and made it a u64 msize_max_value to
indicate its unsigned. And additionally save bound from umax value in
check_arg_funcs which is the same as smax due to as noted above tnumx_cont
and negative check but reads better. By my analysis nothing functionally
changes in v2 but it does get easier to read so that is win.

Fixes: 849fa50662fbc ("bpf/verifier: refine retval R0 state for bpf_get_stack helper")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b558420..dda3b94 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -229,8 +229,7 @@ struct bpf_call_arg_meta {
 	bool pkt_access;
 	int regno;
 	int access_size;
-	s64 msize_smax_value;
-	u64 msize_umax_value;
+	u64 msize_max_value;
 	int ref_obj_id;
 	int func_id;
 	u32 btf_id;
@@ -3571,11 +3570,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 	} else if (arg_type_is_mem_size(arg_type)) {
 		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
 
-		/* remember the mem_size which may be used later
-		 * to refine return values.
+		/* This is used to refine r0 return value bounds for helpers
+		 * that enforce this value as an upper bound on return values.
+		 * See do_refine_retval_range() for helpers that can refine
+		 * the return value. C type of helper is u32 so we pull register
+		 * bound from umax_value however, if negative verifier errors
+		 * out. Only upper bounds can be learned because retval is an
+		 * int type and negative retvals are allowed.
 		 */
-		meta->msize_smax_value = reg->smax_value;
-		meta->msize_umax_value = reg->umax_value;
+		meta->msize_max_value = reg->umax_value;
 
 		/* The register is SCALAR_VALUE; the access check
 		 * happens using its boundaries.
@@ -4118,10 +4121,10 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
 	     func_id != BPF_FUNC_probe_read_str))
 		return;
 
-	ret_reg->smax_value = meta->msize_smax_value;
-	ret_reg->umax_value = meta->msize_umax_value;
+	ret_reg->smax_value = meta->msize_max_value;
 	__reg_deduce_bounds(ret_reg);
 	__reg_bound_offset(ret_reg);
+	__update_reg_bounds(ret_reg);
 }
 
 static int

