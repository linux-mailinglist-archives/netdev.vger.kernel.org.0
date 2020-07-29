Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B6C232285
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgG2QXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2QXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:23:08 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75902C061794;
        Wed, 29 Jul 2020 09:23:08 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id l17so9702927ilq.13;
        Wed, 29 Jul 2020 09:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=KHEIk+blUK4cnPgU9e6ig7KXfxN7MW8Zfcz6Dt34oB4=;
        b=DGDbaxtdt74IOwy6Oyff8VvmLdDYG1jFZEouzMgb3sN1bFa1umlrHJi6A/DYa+vv46
         R2b8esjmYJ6E8rlGqkJxW9nM28zH3RrbhAjFr/JJMDF33cXil6LtCiZ/UekANJkh48So
         EofOMXK+XIvW23/6Sur4nFHzGQPpzpYrnrA1+JwwLZ+CagtngvABMu7PckXCcKi3QHVb
         bAwyuKiVTYJuTOUKoWnPaP1ARANEHM8QLkZdyvjOhEHX4pJODYMAr8Dw6CRjrWJdcbLD
         rZ4S2axE5G4p97u7HSV+Ngv9u3EaEZrsmN66MH/GOe75dVipPv11ubnLV4rIzoXMuNlq
         B0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KHEIk+blUK4cnPgU9e6ig7KXfxN7MW8Zfcz6Dt34oB4=;
        b=sFYARfslckxXzuBoknZQxg/20nD57B/885Fh/HYDRWb4uh2Ofccjy7QKglOGvOkpxu
         UmE2HwlTJHXK33fi2pEuEptpn+lkZlARk0KtYCwqA+Pbm2U7nase/OYNv2ebhEyY+61i
         udy62hA30sY3dRKvVQW9C2F2JrpCMc7K6nMrVOuh2/yuMedt7z/JIrIZizrxJEZOFimQ
         z3e86mz9/qxf9AJ9C0gvM4SrhBEgjRdqMhJ05MwCsdPsQfoQv0oTPhRZxHytuyDKi98s
         9mBZV3tPwRcPXK5ohz57fiLYDE7B4EM4OBawkkBEY9PFceePg8nniw7Tx283N+EcnIz4
         KjEA==
X-Gm-Message-State: AOAM5335HREYljuLq1Q86tmT5cYMnBXw6Wwc71zk/3/b5SoJjJR0tbtx
        mb9ptsEzrNQLu2CbSGpeTQQ=
X-Google-Smtp-Source: ABdhPJwHqUY/v++9DMmwEv9p7Z1rKFzRv35+I/mIcNFqDsgo82QHNbWhrGMrYWP9wsA7gRmNjB9M1w==
X-Received: by 2002:a92:8e01:: with SMTP id c1mr34975879ild.140.1596039787672;
        Wed, 29 Jul 2020 09:23:07 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u9sm440664iog.7.2020.07.29.09.23.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2020 09:23:07 -0700 (PDT)
Subject: [bpf PATCH v2 1/5] bpf: sock_ops ctx access may stomp registers in
 corner case
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 29 Jul 2020 09:22:54 -0700
Message-ID: <159603977489.4454.16012925913901625071.stgit@john-Precision-5820-Tower>
In-Reply-To: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I had a sockmap program that after doing some refactoring started spewing
this splat at me:

[18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
[...]
[18610.807359] Call Trace:
[18610.807370]  ? 0xffffffffc114d0d5
[18610.807382]  __cgroup_bpf_run_filter_sock_ops+0x7d/0xb0
[18610.807391]  tcp_connect+0x895/0xd50
[18610.807400]  tcp_v4_connect+0x465/0x4e0
[18610.807407]  __inet_stream_connect+0xd6/0x3a0
[18610.807412]  ? __inet_stream_connect+0x5/0x3a0
[18610.807417]  inet_stream_connect+0x3b/0x60
[18610.807425]  __sys_connect+0xed/0x120

After some debugging I was able to build this simple reproducer,

 __section("sockops/reproducer_bad")
 int bpf_reproducer_bad(struct bpf_sock_ops *skops)
 {
        volatile __maybe_unused __u32 i = skops->snd_ssthresh;
        return 0;
 }

And along the way noticed that below program ran without splat,

__section("sockops/reproducer_good")
int bpf_reproducer_good(struct bpf_sock_ops *skops)
{
        volatile __maybe_unused __u32 i = skops->snd_ssthresh;
        volatile __maybe_unused __u32 family;

        compiler_barrier();

        family = skops->family;
        return 0;
}

So I decided to check out the code we generate for the above two
programs and noticed each generates the BPF code you would expect,

0000000000000000 <bpf_reproducer_bad>:
;       volatile __maybe_unused __u32 i = skops->snd_ssthresh;
       0:       r1 = *(u32 *)(r1 + 96)
       1:       *(u32 *)(r10 - 4) = r1
;       return 0;
       2:       r0 = 0
       3:       exit

0000000000000000 <bpf_reproducer_good>:
;       volatile __maybe_unused __u32 i = skops->snd_ssthresh;
       0:       r2 = *(u32 *)(r1 + 96)
       1:       *(u32 *)(r10 - 4) = r2
;       family = skops->family;
       2:       r1 = *(u32 *)(r1 + 20)
       3:       *(u32 *)(r10 - 8) = r1
;       return 0;
       4:       r0 = 0
       5:       exit

So we get reasonable assembly, but still something was causing the null
pointer dereference. So, we load the programs and dump the xlated version
observing that line 0 above 'r* = *(u32 *)(r1 +96)' is going to be
translated by the skops access helpers.

int bpf_reproducer_bad(struct bpf_sock_ops * skops):
; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
   0: (61) r1 = *(u32 *)(r1 +28)
   1: (15) if r1 == 0x0 goto pc+2
   2: (79) r1 = *(u64 *)(r1 +0)
   3: (61) r1 = *(u32 *)(r1 +2340)
; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
   4: (63) *(u32 *)(r10 -4) = r1
; return 0;
   5: (b7) r0 = 0
   6: (95) exit

int bpf_reproducer_good(struct bpf_sock_ops * skops):
; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
   0: (61) r2 = *(u32 *)(r1 +28)
   1: (15) if r2 == 0x0 goto pc+2
   2: (79) r2 = *(u64 *)(r1 +0)
   3: (61) r2 = *(u32 *)(r2 +2340)
; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
   4: (63) *(u32 *)(r10 -4) = r2
; family = skops->family;
   5: (79) r1 = *(u64 *)(r1 +0)
   6: (69) r1 = *(u16 *)(r1 +16)
; family = skops->family;
   7: (63) *(u32 *)(r10 -8) = r1
; return 0;
   8: (b7) r0 = 0
   9: (95) exit

Then we look at lines 0 and 2 above. In the good case we do the zero
check in r2 and then load 'r1 + 0' at line 2. Do a quick cross-check
into the bpf_sock_ops check and we can confirm that is the 'struct
sock *sk' pointer field. But, in the bad case,

   0: (61) r1 = *(u32 *)(r1 +28)
   1: (15) if r1 == 0x0 goto pc+2
   2: (79) r1 = *(u64 *)(r1 +0)

Oh no, we read 'r1 +28' into r1, this is skops->fullsock and then in
line 2 we read the 'r1 +0' as a pointer. Now jumping back to our spat,

[18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001

The 0x01 makes sense because that is exactly the fullsock value. And
its not a valid dereference so we splat.

To fix we need to guard the case when a program is doing a sock_ops field
access with src_reg == dst_reg. This is already handled in the load case
where the ctx_access handler uses a tmp register being careful to
store the old value and restore it. To fix the get case test if
src_reg == dst_reg and in this case do the is_fullsock test in the
temporary register. Remembering to restore the temporary register before
writing to either dst_reg or src_reg to avoid smashing the pointer into
the struct holding the tmp variable.

Adding this inline code to test_tcpbpf_kern will now be generated
correctly from,

  9: r2 = *(u32 *)(r2 + 96)

to xlated code,

  13: (61) r9 = *(u32 *)(r2 +28)
  14: (15) if r9 == 0x0 goto pc+4
  15: (79) r9 = *(u64 *)(r2 +32)
  16: (79) r2 = *(u64 *)(r2 +0)
  17: (61) r2 = *(u32 *)(r2 +2348)
  18: (05) goto pc+1
  19: (79) r9 = *(u64 *)(r2 +32)

And in the normal case we keep the original code, because really this
is an edge case. From this,

  9: r2 = *(u32 *)(r6 + 96)

to xlated code,

  22: (61) r2 = *(u32 *)(r6 +28)
  23: (15) if r2 == 0x0 goto pc+2
  24: (79) r2 = *(u64 *)(r6 +0)
  25: (61) r2 = *(u32 *)(r2 +2348)

So three additional instructions if dst == src register, but I scanned
my current code base and did not see this pattern anywhere so should
not be a big deal. Further, it seems no one else has hit this or at
least reported it so it must a fairly rare pattern.

Fixes: 9b1f3d6e5af29 ("bpf: Refactor sock_ops_convert_ctx_access")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/filter.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 29e34551..15a0842 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8314,15 +8314,31 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 /* Helper macro for adding read access to tcp_sock or sock fields. */
 #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
 	do {								      \
+		int fullsock_reg = si->dst_reg, reg = BPF_REG_9, jmp = 2;     \
 		BUILD_BUG_ON(sizeof_field(OBJ, OBJ_FIELD) >		      \
 			     sizeof_field(struct bpf_sock_ops, BPF_FIELD));   \
+		if (si->dst_reg == reg || si->src_reg == reg)		      \
+			reg--;						      \
+		if (si->dst_reg == reg || si->src_reg == reg)		      \
+			reg--;						      \
+		if (si->dst_reg == si->src_reg) {			      \
+			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg,	      \
+					  offsetof(struct bpf_sock_ops_kern,  \
+					  temp));			      \
+			fullsock_reg = reg;				      \
+			jmp += 2;					      \
+		}							      \
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
 						struct bpf_sock_ops_kern,     \
 						is_fullsock),		      \
-				      si->dst_reg, si->src_reg,		      \
+				      fullsock_reg, si->src_reg,	      \
 				      offsetof(struct bpf_sock_ops_kern,      \
 					       is_fullsock));		      \
-		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 2);	      \
+		*insn++ = BPF_JMP_IMM(BPF_JEQ, fullsock_reg, 0, jmp);	      \
+		if (si->dst_reg == si->src_reg)				      \
+			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
+				      offsetof(struct bpf_sock_ops_kern,      \
+				      temp));				      \
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
 						struct bpf_sock_ops_kern, sk),\
 				      si->dst_reg, si->src_reg,		      \
@@ -8331,6 +8347,12 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 						       OBJ_FIELD),	      \
 				      si->dst_reg, si->dst_reg,		      \
 				      offsetof(OBJ, OBJ_FIELD));	      \
+		if (si->dst_reg == si->src_reg)	{			      \
+			*insn++ = BPF_JMP_A(1);				      \
+			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
+				      offsetof(struct bpf_sock_ops_kern,      \
+				      temp));				      \
+		}							      \
 	} while (0)
 
 #define SOCK_OPS_GET_TCP_SOCK_FIELD(FIELD) \

