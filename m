Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFB717C972
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 01:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgCGALm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 19:11:42 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52384 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgCGALm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 19:11:42 -0500
Received: by mail-pj1-f65.google.com with SMTP id lt1so1726285pjb.2;
        Fri, 06 Mar 2020 16:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=HonJRWAXFyyGOT61X0JxGVsGXEc4FDd9e9rPOVKYpUE=;
        b=tK5ne5HcNPiie4IZ8hFo0YBeqw7DNPNMtF9YTfeTFaUqh6tWMv5JjD2lNBQw7aC4Vb
         HCjoct7M78e5mqfQa2U/lFOIeRmVdidDKGyL7vbZET/z7RFVhlTi672UOOXsebjYJoCa
         F3K+MD2vUeq1Nq32vb1DtXPc2Cg8VIodkXqKhye9s9kDSCbz3CdSrBrvJfKiNEvLtAbt
         OpYQTmVEI24i9LwlUKlzfEMtf33H2K/xnrE6/8t42syrC0Sekl2b4CnuYY8hrDiyzPCP
         EKm5d5u3wkftIX9Czv0lorZT9TF13lOgBQtj2FF+P36Vc2+L+EjaFPaeg60sQo/rDm9M
         aITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=HonJRWAXFyyGOT61X0JxGVsGXEc4FDd9e9rPOVKYpUE=;
        b=MSD5GrxZih6lQFf+ySsHv970/hhyZrLa6PT85rZOzLGFYq3Hq+ibgEk+uZSqjB/nhf
         UjwSHEJvmyn3+kYbI6y7B0wGtqra9aQTclpyxKbGcaKIDi5NP8c6+LIloz+o6YPzoA34
         BsH6bPC8RB7gh9ENGlKO1ZQMi++Ft1jiIrNAPhZ5vqUOOLqt46T79PxGVdoE/lO9/gUz
         1kPbAV5jioE3TeR2awDDiX8Vltwjw96YDuHlHnf/RwY61xgnqVEhr9Sf6rdx5cf4laak
         kV4jYWiZtqgURErK03gchUpkTE5dAvQO6fLsy1CKpB/Mi39xFsYI1qXl2dJI6Tv7h/lI
         QLnA==
X-Gm-Message-State: ANhLgQ08RGc6tN9vAHGrl2CMWzMasAmmkacrAwrvlE5F9yAg+csnhlDZ
        cDsT6q5hkss1KlAUYUdX0o/Iwj1o
X-Google-Smtp-Source: ADFU+vsIyMJURgUFfFvrwGVsl37awfjbHtluQ+76EZ0ccNToe36j2lfY8JBRXm3SSx3id2kIFQAjdA==
X-Received: by 2002:a17:90a:d98a:: with SMTP id d10mr6029278pjv.178.1583539899888;
        Fri, 06 Mar 2020 16:11:39 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u19sm22960814pgf.11.2020.03.06.16.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 16:11:39 -0800 (PST)
Subject: [RFC PATCH 3/4] bpf: verifier,
 do_refine_retval_range may clamp umin to 0 incorrectly
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Sat, 07 Mar 2020 00:11:25 +0000
Message-ID: <158353988498.3451.12957006816272358246.stgit@ubuntu3-kvm2>
In-Reply-To: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
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
 0 files changed

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b937156dcf6f..44471e21ee44 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -227,8 +227,7 @@ struct bpf_call_arg_meta {
 	bool pkt_access;
 	int regno;
 	int access_size;
-	s64 msize_smax_value;
-	u64 msize_umax_value;
+	u64 msize_max_value;
 	int ref_obj_id;
 	int func_id;
 	u32 btf_id;
@@ -3771,11 +3770,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
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
@@ -4312,10 +4315,10 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
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

