Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1691322AC02
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 12:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgGWJ77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 05:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgGWJ76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 05:59:58 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12591C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 02:59:58 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z24so5670784ljn.8
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 02:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+YCu61UdRIfgGgtfqTiNyVZA7tw12eV3zO14rYdK+r8=;
        b=UcKlTWJ3Fvc1OLdRwEpKYaXJpEy6em4FggJ5+39Jl2AsioWf5Ng0CyjDHrRi64xtaX
         oq5WzFxzeu2W7DQhjBiFUP31xKCjp94nb0Xo4j7g2BNYKtLKJgoOkEaXYIpOAB0dKagq
         ZOXMwT8cWuVcBNJCFeYqnAyb1zOF0m9CSTmts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+YCu61UdRIfgGgtfqTiNyVZA7tw12eV3zO14rYdK+r8=;
        b=pfWOd+VX/v8a/opW4ixpdDsdent1OYpEPw5MVBvbBVRtIH7jaK4FXhsv+10Kl/00lt
         Gaw2flO0hhILxCE6fCeww/s/daBBM4EhWiqhG6EM22qkvBXzMjPguAOLvg2r1bjsMj3E
         fQjndY1rG4L+D2Z+ZHR9iTv1XM6y1ktC7e8/Vh/UTynjZ6gzaCTkhB5CV+k82iuXeV2/
         aQxoxv5TKbEU+yLmfEvauXOSBQFKa66Hiz0qxotmfIqzuYElchkeSf3dG5yKEpkBCv7b
         RuumAktLNGA65YPCAkdRndnPII27U8zCuG25hpM/LV6tvZmNqVB52AiPAwKH/U8GbyiC
         GQXw==
X-Gm-Message-State: AOAM531RK1rcK0LqDKX+Ms5BUoXMHzLxi8dJFLErC60LN7juE/7kiojl
        82a3L3gKHJQK7W5Dfjp1KFo37g==
X-Google-Smtp-Source: ABdhPJxtU6iQ/CnhU72RZEDTQKHwUn6XCBSY5Z+KwJsWaRVbl7pAhlAA6tLwKCXFx7Hz+ncZzY29EQ==
X-Received: by 2002:a05:651c:222:: with SMTP id z2mr1701058ljn.395.1595498396415;
        Thu, 23 Jul 2020 02:59:56 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e12sm2334666ljl.94.2020.07.23.02.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 02:59:55 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf v2 1/2] bpf: Load zeros for narrow loads beyond target field
Date:   Thu, 23 Jul 2020 11:59:52 +0200
Message-Id: <20200723095953.1003302-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200723095953.1003302-1-jakub@cloudflare.com>
References: <20200723095953.1003302-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For narrow loads from context that are:

  1) as big in size as the target field, and
  2) at an offset beyond the target field,

the verifier does not emit the shift-and-mask instruction sequence
following the target field load instruction, as it happens for narrow loads
smaller in size than the target field width.

This has an unexpected effect of loading the same data, no matter what the
offset. While, arguably, the expected behavior is to load zeros for offsets
that beyond the target field.

For instance, 2-byte load from a 4-byte context field, backed by a 2-byte
target field at an offset of 2 bytes results in:

  $ cat progs/test_narrow_load.c
  [...]
  SEC("sk_reuseport/narrow_load_half_word")
  int narrow_load_half_word(struct sk_reuseport_md *ctx)
  {
  	__u16 *half;

  	half = (__u16 *)&ctx->ip_protocol;
  	if (half[0] != IPPROTO_UDP)
  		return SK_DROP;
  	if (half[1] != 0)
  		return SK_DROP;
  	return SK_PASS;
  }

  $ llvm-objdump -S --no-show-raw-insn ...
  [...]
  0000000000000000 narrow_load_half_word:
  ; {
         0:       w0 = 0
  ;       if (half[0] != IPPROTO_UDP)
         1:       r2 = *(u16 *)(r1 + 24)
         2:       if w2 != 17 goto +4 <LBB1_3>
  ;       if (half[1] != 0)
         3:       r1 = *(u16 *)(r1 + 26)
         4:       w0 = 1
         5:       if w1 == 0 goto +1 <LBB1_3>
         6:       w0 = 0

  0000000000000038 LBB1_3:
  ; }
         7:       exit

  $ bpftool prog dump xlated ...
  int narrow_load_half_word(struct sk_reuseport_md * ctx):
  ; int narrow_load_half_word(struct sk_reuseport_md *ctx)
     0: (b4) w0 = 0
  ; if (half[0] != IPPROTO_UDP)
     1: (79) r2 = *(u64 *)(r1 +8)
     2: (69) r2 = *(u16 *)(r2 +924)
  ; if (half[0] != IPPROTO_UDP)
     3: (56) if w2 != 0x11 goto pc+5
  ; if (half[1] != 0)
     4: (79) r1 = *(u64 *)(r1 +8)
     5: (69) r1 = *(u16 *)(r1 +924)
     6: (b4) w0 = 1
  ; if (half[1] != 0)
     7: (16) if w1 == 0x0 goto pc+1
     8: (b4) w0 = 0
  ; }
     9: (95) exit

In this case half[0] == half[1] == sk->sk_protocol, which is the target
field for the ctx->ip_protocol.

Fix it by emitting 'wX = 0' or 'rX = 0' instruction for all narrow loads
from an offset that is beyond the target field.

Going back to the example, with the fix in place, the upper half load from
ctx->ip_protocol yields zero:

  int narrow_load_half_word(struct sk_reuseport_md * ctx):
  ; int narrow_load_half_word(struct sk_reuseport_md *ctx)
     0: (b4) w0 = 0
  ; if (half[0] != IPPROTO_UDP)
     1: (79) r2 = *(u64 *)(r1 +8)
     2: (69) r2 = *(u16 *)(r2 +924)
  ; if (half[0] != IPPROTO_UDP)
     3: (56) if w2 != 0x11 goto pc+4
  ; if (half[1] != 0)
     4: (b4) w1 = 0
     5: (b4) w0 = 1
  ; if (half[1] != 0)
     6: (16) if w1 == 0x0 goto pc+1
     7: (b4) w0 = 0
  ; }
     8: (95) exit

Fixes: f96da09473b5 ("bpf: simplify narrower ctx access")
Suggested-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/verifier.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 94cead5a43e5..0a9dbcdd6341 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9614,11 +9614,11 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
  */
 static int convert_ctx_accesses(struct bpf_verifier_env *env)
 {
+	u32 target_size, size_default, off, access_off;
 	const struct bpf_verifier_ops *ops = env->ops;
 	int i, cnt, size, ctx_field_size, delta = 0;
 	const int insn_cnt = env->prog->len;
 	struct bpf_insn insn_buf[16], *insn;
-	u32 target_size, size_default, off;
 	struct bpf_prog *new_prog;
 	enum bpf_access_type type;
 	bool is_narrower_load;
@@ -9760,7 +9760,26 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			return -EINVAL;
 		}
 
-		if (is_narrower_load && size < target_size) {
+		/* When context field is wider than the target field,
+		 * narrow load from an offset beyond the target field
+		 * can be reduced to loading zero because there is
+		 * nothing to load from memory.
+		 */
+		access_off = off & (size_default - 1);
+		if (is_narrower_load && access_off >= target_size) {
+			cnt = 0;
+			if (ctx_field_size <= 4)
+				insn_buf[cnt++] = BPF_MOV32_IMM(insn->dst_reg, 0);
+			else
+				insn_buf[cnt++] = BPF_MOV64_IMM(insn->dst_reg, 0);
+		}
+		/* Narrow load from an offset within the target field,
+		 * smaller in size than the target field, needs
+		 * shifting and masking because convert_ctx_access
+		 * always emits full-size target field load.
+		 */
+		if (is_narrower_load && access_off < target_size &&
+		    size < target_size) {
 			u8 shift = bpf_ctx_narrow_access_offset(
 				off, size, size_default) * 8;
 			if (ctx_field_size <= 4) {
-- 
2.25.4

