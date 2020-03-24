Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9CEA1917C8
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgCXRiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:38:11 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40010 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:38:10 -0400
Received: by mail-pj1-f66.google.com with SMTP id kx8so1778158pjb.5;
        Tue, 24 Mar 2020 10:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=jyjUeD6zuoXyhDLMSL9cDCavDT6zPCUdtuDCvs0xSJc=;
        b=CBRtrL9nVmoJgfeqndPjSJJlxNOcupvUQqCEG3UKI9QGIEEJxsiHFEU81GBjE0RQ3s
         Q8M9kFhJ5KBnocrqtjomGRTRO2y8cpVHfoFo75BvFigdkVsijuA/wD+f5VeS/cn9Eesy
         PPbCiXf1DnKOhOrDcLcirFcLy24NdBeTLYLd/YVd936+oCxyE854Iqt1pK9+iMb5NbEu
         TSlFtPyeZ9kMPFwD+jj4l6KP13/+jHBoJ9L9KgeK06uvhLheOsGOSrfGVWm8iJ0obnrA
         jVmuTKm+5ASTuXqGdciItQyZeXtzzPHux2EC2BuAF+/HDQ62IkeWOU8lh/OFj6EYs8cd
         DiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jyjUeD6zuoXyhDLMSL9cDCavDT6zPCUdtuDCvs0xSJc=;
        b=GWrwgD5os+DqVXLWT41+tT/MUd1mTeb3IGYak2ui49qIsThDm0q7jwlDYroVoaA4MT
         9H4Y1jYUmaWSDHb1a15PErAuj60h61GmvOOvUpDiREiVeWPg1xHhLreW3g5fYMe1pYRt
         vO5u9TH5E58LXnJKInA7trV6n7IJK0JHiAh03B6UsE09vUf+jO/TtyaWPD4ETJWa4Ahf
         GViVJZRauqKIjaZwbnlFI8Zh4zRy+YfOwIGCxeORHM0yRxMFGEN+oI+rmYoXbK5cVMY3
         7gYSryG5zB3oCTZpTxOY6OpZSCIQwLS86uAKk23HIW7shy3LAyHHC8tqyWdnqM5XbWAm
         f4Ug==
X-Gm-Message-State: ANhLgQ3OVbHKrA8X2nX9Cs2j7Dk4Epm/3TzXEUWji3+M2m7DbAKAQZf8
        FBh6zcWLw4dNCajqQngH4hA=
X-Google-Smtp-Source: ADFU+vslUzmlB9AI4iTqG9J52w4DCNiuO97FpQC7Nvrg0YEc99CNFz987dZB36DvVshtJNNAU5lvqg==
X-Received: by 2002:a17:90b:3d1:: with SMTP id go17mr6012724pjb.99.1585071489030;
        Tue, 24 Mar 2020 10:38:09 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s137sm13574105pfs.45.2020.03.24.10.37.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:38:08 -0700 (PDT)
Subject: [bpf-next PATCH 01/10] bpf: verifier,
 do_refine_retval_range may clamp umin to 0 incorrectly
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:37:54 -0700
Message-ID: <158507147386.15666.12903539309039973826.stgit@john-Precision-5820-Tower>
In-Reply-To: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
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
index 745f3cfd..57d3351 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -228,8 +228,7 @@ struct bpf_call_arg_meta {
 	bool pkt_access;
 	int regno;
 	int access_size;
-	s64 msize_smax_value;
-	u64 msize_umax_value;
+	u64 msize_max_value;
 	int ref_obj_id;
 	int func_id;
 	u32 btf_id;
@@ -3577,11 +3576,15 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
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
@@ -4124,10 +4127,10 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
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

