Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237DF1D88BD
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgERUCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:02:47 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FB1C061A0C;
        Mon, 18 May 2020 13:02:47 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h10so12029982iob.10;
        Mon, 18 May 2020 13:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mtWZlrGOIDYWU5A0cqRih5f0ht2YzMcHfkailvCxd6U=;
        b=fTEKeNUQ8qD2Z7cdhLlA1rOETQWrxhTWvRU59ct+Xe4kaXo4bNkkWVg9nkEwY/sX4q
         Y2D4/N+g7QL1bhVb/tfjHZM3mheRSr1XBvo2HBem1q7hihdDyz77OlM4eNbUkjAInblQ
         wWKrmIERZYaLik9FnjXHBgLMoQHghO42ycptgbjp361jtoGNuIr2djutlPVm9pXVsgd/
         /vBUpm97d7a8PZZhd6lGse5qkJvUUPYypk40adcDuR5IHIkTOm5YOFC+8skEMoqP5TLI
         pp/RYiDVeRv7PcGyfOelVhP89Os5I+WMUKw3ZjnQXcjzDju0yRsaf9kbYsNxR7TiuKeI
         eUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mtWZlrGOIDYWU5A0cqRih5f0ht2YzMcHfkailvCxd6U=;
        b=LvsVHwzLzzi0YUhWlN0Q1nxSyG5B8TJpcWWOxJykwWUgsu7oOm8Y6GR02didczO2p9
         aYBIwNHK+znZ5H6yqu2eRV8nEsCGTPDT3vIzT7ISUsB0oU68eyXspq44AjrEOlyNtlvq
         +2jtqPfIdguhptWJNYvuKjanAmlODydssUMpuqoY6jKENfkT9vCiPPs41QQjMKBygvZ8
         65biBZ2JB3g4xN8dmeH51Ki3zRQbjRI7lFfPZB/pkcjLHFseic/M7zfvIo7Aq/pKKKxB
         1P+t2fp2jd8q+3LuLjEYKPGQ1qy6dxzFbUu+jb3LIe4gMK3wCp17xPCrrzGkWACwP6yI
         OaMw==
X-Gm-Message-State: AOAM531sFUuq+7OEtxE/GJuydSSR/0hJ7h78XvaeTePt3sz9JtnRIbnu
        JICQNzB+nehaUJ7vmBegNKhBnCNr
X-Google-Smtp-Source: ABdhPJy1tTZe/E3vKovr5P4VIYcB1PKsokIVsN58nsPwCljOK8+kk9a9wQVtv5D33GbHmm4cjwdlIQ==
X-Received: by 2002:a05:6638:45d:: with SMTP id r29mr16451933jap.93.1589832166377;
        Mon, 18 May 2020 13:02:46 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a13sm4232762ioa.42.2020.05.18.13.02.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 13:02:45 -0700 (PDT)
Subject: [bpf-next PATCH 1/4] bpf: verifier track null pointer branch_taken
 with JNE and JEQ
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 18 May 2020 13:02:33 -0700
Message-ID: <158983215367.6512.2773569595786906135.stgit@john-Precision-5820-Tower>
In-Reply-To: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current verifier when considering which branch may be taken on a
conditional test with pointer returns -1 meaning either branch may
be taken. But, we track if pointers can be NULL by using dedicated
types for valid pointers (pointers that can not be NULL). For example,
we have PTR_TO_SOCK and PTR_TO_SOCK_OR_NULL to indicate a pointer
that is valid or not, PTR_TO_SOCK being the validated pointer type.

We can then use this extra information when we encounter null tests
against pointers. Consider,

  if (sk_ptr == NULL) ... else ...

if the sk_ptr has type PTR_TO_SOCK we know the null check will fail
and the null branch can not be taken.

In this patch we extend is_branch_taken to consider this extra
information and to return only the branch that will be taken. This
resolves a verifier issue reported with this C code,

 sk = bpf_sk_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
 bpf_printk("sk=%d\n", sk ? 1 : 0);
 if (sk)
   bpf_sk_release(sk);
 return sk ? TC_ACT_OK : TC_ACT_UNSPEC;

The generated asm then looks like this,

 43: (85) call bpf_sk_lookup_tcp#84
 44: (bf) r6 = r0                    <- do the lookup and put result in r6
 ...                                 <- do some more work
 51: (55) if r6 != 0x0 goto pc+1     <- test sk ptr for printk use
 ...
 56: (85) call bpf_trace_printk#6
 ...
 61: (15) if r6 == 0x0 goto pc+1     <- do the if (sk) test from C code
 62: (b7) r0 = 0                     <- skip release because both branches
                                        are taken in verifier
 63: (95) exit
 Unreleased reference id=3 alloc_insn=43

In the verifier path the flow is,

 51 -> 53 ... 61 -> 62

Because at 51->53 jmp verifier promoted reg6 from type PTR_TO_SOCK_OR_NULL
to PTR_TO_SOCK but then at 62 we still test both paths ignoring that we
already promoted the type. So we incorrectly conclude an unreleased
reference. To fix this we add logic in is_branch_taken to test the
OR_NULL portion of the type and if its not possible for a pointer to
be NULL we can prune the branch taken where 'r6 == 0x0'.

After the above additional logic is added the C code above passes
as expected.

This makes the assumption that all pointer types PTR_TO_* that can be null
have an equivalent type PTR_TO_*_OR_NULL logic.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Reported-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 0 files changed

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 180933f..8f576e2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -393,6 +393,14 @@ static bool type_is_sk_pointer(enum bpf_reg_type type)
 		type == PTR_TO_XDP_SOCK;
 }
 
+static bool reg_type_not_null(enum bpf_reg_type type)
+{
+	return type == PTR_TO_SOCKET ||
+		type == PTR_TO_TCP_SOCK ||
+		type == PTR_TO_MAP_VALUE ||
+		type == PTR_TO_SOCK_COMMON;
+}
+
 static bool reg_type_may_be_null(enum bpf_reg_type type)
 {
 	return type == PTR_TO_MAP_VALUE_OR_NULL ||
@@ -1970,8 +1978,9 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 	if (regno >= 0) {
 		reg = &func->regs[regno];
 		if (reg->type != SCALAR_VALUE) {
-			WARN_ONCE(1, "backtracing misuse");
-			return -EFAULT;
+			if (unlikely(!reg_type_not_null(reg->type)))
+				WARN_ONCE(1, "backtracing misuse");
+			return 0;
 		}
 		if (!reg->precise)
 			new_marks = true;
@@ -6306,8 +6315,26 @@ static int is_branch64_taken(struct bpf_reg_state *reg, u64 val, u8 opcode)
 static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
 			   bool is_jmp32)
 {
-	if (__is_pointer_value(false, reg))
-		return -1;
+	if (__is_pointer_value(false, reg)) {
+		if (!reg_type_not_null(reg->type))
+			return -1;
+
+		/* If pointer is valid tests against zero will fail so we can
+		 * use this to direct branch taken.
+		 */
+		switch (opcode) {
+		case BPF_JEQ:
+			if (val == 0)
+				return 0;
+			return 1;
+		case BPF_JNE:
+			if (val == 0)
+				return 1;
+			return 0;
+		default:
+			return -1;
+		}
+	}
 
 	if (is_jmp32)
 		return is_branch32_taken(reg, val, opcode);

