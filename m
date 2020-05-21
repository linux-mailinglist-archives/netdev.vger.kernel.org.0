Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002851DD7FE
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgEUUHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUUHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 16:07:40 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C770C061A0E;
        Thu, 21 May 2020 13:07:40 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k22so3349267pls.10;
        Thu, 21 May 2020 13:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=TCVD6+yfk34nLQ1xHOTwLukgJOFw4TUtPDO+S8omJ3g=;
        b=f0Eib8iXI8440YsGETTfyjp1QyK2JZ3Gb0EkjhVFCm5ifT4NDikPTJkxJtcr1N6zsl
         tQu5XVAXHao+e6b4Cuyq5WNyHc2pNnoUjkYyCgnx65JwZ0+Edi91O3Z00KvzmzQusXMI
         t4hKy9oog+hl2YmShkFSU4bVM//bglfZb9Y1E8qrLBNVKhSFZyYwOGyXDo6ivwAD7UQw
         nO3wPhInJO8CnOuKkKHiaOWRwZL9zr7EixtedcdFoGDtW3BPoSSyhWZIYmQK4eEuq6EI
         iYr5/UwmJHEdpd/+nGenDOG70QIagaSXlOdVJ6uOy0xT6alTZaUS/luYomd/km8hmpDn
         nkxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TCVD6+yfk34nLQ1xHOTwLukgJOFw4TUtPDO+S8omJ3g=;
        b=BGPjVk+/nc2F/dYil2KApUCYjICTWupOaAuJeDE4nVYw2ecZ3cf0sfExu0RXrJV57/
         UIaFnPwOvGU3PTcif5E36eLbKkRO+BrgJ6IT599lyvIWAo8Al0Ctum63L6nbTHHCzvHm
         awnLKrMUqQlI8zns5fqgZJ/iybuwQ0E8vk51gc1vW8BZQfiPEpwoVI7jo//SsmDYzXhk
         QMGQws82/bSMGUtX+H/IoeO4jBrOPIQKPZFBRf2ErEbMToZwNNv9eaNWiKEyfpz87E+s
         /icQHl59ANjCFrjyAsKwk8XQm96GTIjwsjIUI7qmYg/donveVm1yfXMCoBjQU9RJNBr9
         EbMg==
X-Gm-Message-State: AOAM531rYCjcNHq0hI/RaML0JU9pD82/7tj+/R4PDsh3UHm3Q5AHn3Fz
        RAr/HbMaZUl3xDn7iDhgaUs=
X-Google-Smtp-Source: ABdhPJzzyUoghwkf7nmnwyNVIB36t2+7xpkgAx64vbDqnA2yzTRQIr7rjQ9JOQvpyvV+7rvbHL/3Ww==
X-Received: by 2002:a17:902:bf47:: with SMTP id u7mr10945579pls.159.1590091660007;
        Thu, 21 May 2020 13:07:40 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z29sm5267585pff.120.2020.05.21.13.07.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 13:07:39 -0700 (PDT)
Subject: [bpf-next PATCH v2 1/4] bpf: verifier track null pointer
 branch_taken with JNE and JEQ
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 21 May 2020 13:07:26 -0700
Message-ID: <159009164651.6313.380418298578070501.stgit@john-Precision-5820-Tower>
In-Reply-To: <159009128301.6313.11384218513010252427.stgit@john-Precision-5820-Tower>
References: <159009128301.6313.11384218513010252427.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when considering the branches that may be taken for a jump
instruction if the register being compared is a pointer the verifier
assumes both branches may be taken. But, if the jump instruction
is comparing if a pointer is NULL we have this information in the
verifier encoded in the reg->type so we can do better in these cases.
Specifically, these two common cases can be handled.

 * If the instruction is BPF_JEQ and we are comparing against a
   zero value. This test is 'if ptr == 0 goto +X' then using the
   type information in reg->type we can decide if the ptr is not
   null. This allows us to avoid pushing both branches onto the
   stack and instead only use the != 0 case. For example
   PTR_TO_SOCK and PTR_TO_SOCK_OR_NULL encode the null pointer.
   Note if the type is PTR_TO_SOCK_OR_NULL we can not learn anything.
   And also if the value is non-zero we learn nothing because it
   could be any arbitrary value a different pointer for example

 * If the instruction is BPF_JNE and ware comparing against a zero
   value then a similar analysis as above can be done. The test in
   asm looks like 'if ptr != 0 goto +X'. Again using the type
   information if the non null type is set (from above PTR_TO_SOCK)
   we know the jump is taken.

In this patch we extend is_branch_taken() to consider this extra
information and to return only the branch that will be taken. This
resolves a verifier issue reported with C code like the following.
See progs/test_sk_lookup_kern.c in selftests.

 sk = bpf_sk_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
 bpf_printk("sk=%d\n", sk ? 1 : 0);
 if (sk)
   bpf_sk_release(sk);
 return sk ? TC_ACT_OK : TC_ACT_UNSPEC;

In the above the bpf_printk() will resolve the pointer from
PTR_TO_SOCK_OR_NULL to PTR_TO_SOCK. Then the second test guarding
the release will cause the verifier to walk both paths resulting
in the an unreleased sock reference. See verifier/ref_tracking.c
in selftests for an assembly version of the above.

After the above additional logic is added the C code above passes
as expected.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Reported-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9c7d67d..4e0dc44 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -393,6 +393,15 @@ static bool type_is_sk_pointer(enum bpf_reg_type type)
 		type == PTR_TO_XDP_SOCK;
 }
 
+static bool reg_type_not_null(enum bpf_reg_type type)
+{
+	return type == PTR_TO_SOCKET ||
+		type == PTR_TO_TCP_SOCK ||
+		type == PTR_TO_MAP_VALUE ||
+		type == PTR_TO_SOCK_COMMON ||
+	        type == PTR_TO_BTF_ID;
+}
+
 static bool reg_type_may_be_null(enum bpf_reg_type type)
 {
 	return type == PTR_TO_MAP_VALUE_OR_NULL ||
@@ -6308,8 +6317,25 @@ static int is_branch64_taken(struct bpf_reg_state *reg, u64 val, u8 opcode)
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
+		if (val != 0)
+			return -1;
+
+		switch (opcode) {
+		case BPF_JEQ:
+			return 0;
+		case BPF_JNE:
+			return 1;
+		default:
+			return -1;
+		}
+	}
 
 	if (is_jmp32)
 		return is_branch32_taken(reg, val, opcode);
@@ -6808,7 +6834,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	}
 
 	if (pred >= 0) {
-		err = mark_chain_precision(env, insn->dst_reg);
+		/* If we get here with a dst_reg pointer type it is because
+		 * above is_branch_taken() special cased the 0 comparison.
+		 */
+		if (!__is_pointer_value(false, dst_reg))
+			err = mark_chain_precision(env, insn->dst_reg);
 		if (BPF_SRC(insn->code) == BPF_X && !err)
 			err = mark_chain_precision(env, insn->src_reg);
 		if (err)

