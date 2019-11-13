Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81808FBA2E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfKMUsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:48:00 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36559 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfKMUsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:48:00 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so2111461pgh.3;
        Wed, 13 Nov 2019 12:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ek+TLf1CXwJrIPqivXOJg2aEotmC6xWAV555CANs9r4=;
        b=cfWRPvGi1tHdDVzjUMXohrkUBzD8c0z3UapFGbHilR6Eq304oTehWnhTRsZgRdK4++
         OysFuJ+8iTDPullcO747oktlVddnfPeSuYlSxsiL+2nI3Dpywgl1hrNFq/PAPtimebPk
         9ShAOmKJmC3H5JrEvXjWCD4RofWSr1zI8qOm1uFaw1vtWX/OmfU6SF/YXr98Dge6JO4E
         hTCQe7+2vDsZ0NIoJ20m5NWg/8ZkEIZw1D9CzziMjYkjjQGbZ0LZ8sz6exjAbZyYoS2M
         svCzaPGg1Bz8pR5y3zq29UU2fvHa2/kUyGf1WHmox3yaZuI3Z+znBNGbjodGUWhB9IcF
         aNpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ek+TLf1CXwJrIPqivXOJg2aEotmC6xWAV555CANs9r4=;
        b=mOM04EtIudb6N/F64pWluAB6OR7ZupNREdi3o7/wuoAx/l7xX9Bv6A5HezmJGh7OXV
         KszFaBiEPCQmsMJPj9QJIyprLd0Q7NHC4RyEDZUg3IhoT/jYPLQiZ42qa8gnbP/ltTkZ
         50iVTxbAUE+ATS4DYQ8QtzSe+nanZz7fWa3pfHHKnNJ5JMpeOYiyz/ef7jLNzKNyx7sS
         RTWLzX/VhkjVZEOqwN5OJc4dAlEB6KPsfRGMrkdkb/sxj+iQ3YJJuha8YL/VajFJVk3Q
         N5SI/BcfwhNN6xRXVYtUOPtExuVBd9lZKISXEpYK/qqtzyIapvAPjBqdSbYoPA/D4q0e
         sV9w==
X-Gm-Message-State: APjAAAU+Z17f3xanBmfCU+DOBq3yRbKummKaIREwAmZx90ItvATWIj2J
        TNp7WLpCY6owHQNHbqZJV9ecTtF7iho=
X-Google-Smtp-Source: APXvYqxbtF0mWSC7qDYPFwRf9dTrlpGQx3rDJfihOCG+Qhj0IPQo1OxM7SdS1YLkSXwnBvJt8oqBlA==
X-Received: by 2002:a17:90a:51:: with SMTP id 17mr7751200pjb.71.1573678079316;
        Wed, 13 Nov 2019 12:47:59 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id g20sm3235861pgk.46.2019.11.13.12.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 12:47:58 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 1/4] bpf: teach bpf_arch_text_poke() jumps
Date:   Wed, 13 Nov 2019 21:47:34 +0100
Message-Id: <20191113204737.31623-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113204737.31623-1-bjorn.topel@gmail.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The BPF dispatcher, introduced in future commits, hijacks a trampoline
function. This commit teaches the text poker to emit jmpq in addtion
to callq.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 arch/x86/net/bpf_jit_comp.c | 34 +++++++++++++++++++++++++++++-----
 include/linux/bpf.h         |  3 +++
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 79157d886a3e..28782a1c386e 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -481,7 +481,7 @@ static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
 	*pprog = prog;
 }
 
-static int emit_call(u8 **pprog, void *func, void *ip)
+static int emit_call_jmp(u8 **pprog, void *func, void *ip, u8 insn)
 {
 	u8 *prog = *pprog;
 	int cnt = 0;
@@ -492,17 +492,28 @@ static int emit_call(u8 **pprog, void *func, void *ip)
 		pr_err("Target call %p is out of range\n", func);
 		return -EINVAL;
 	}
-	EMIT1_off32(0xE8, offset);
+	EMIT1_off32(insn, offset);
 	*pprog = prog;
 	return 0;
 }
 
+static int emit_call(u8 **pprog, void *func, void *ip)
+{
+	return emit_call_jmp(pprog, func, ip, 0xE8);
+}
+
+/* Emits tail-call */
+static int emit_jmp(u8 **pprog, void *func, void *ip)
+{
+	return emit_call_jmp(pprog, func, ip, 0xE9);
+}
+
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *old_addr, void *new_addr)
 {
 	u8 old_insn[X86_CALL_SIZE] = {};
 	u8 new_insn[X86_CALL_SIZE] = {};
-	u8 *prog;
+	u8 *prog, insn;
 	int ret;
 
 	if (!is_kernel_text((long)ip) &&
@@ -510,31 +521,44 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		/* BPF trampoline in modules is not supported */
 		return -EINVAL;
 
+	switch (t) {
+	case BPF_MOD_NOP_TO_CALL:
+	case BPF_MOD_CALL_TO_CALL:
+	case BPF_MOD_CALL_TO_NOP:
+		insn = 0xE8;
+		break;
+	default:
+		insn = 0xE9;
+	}
+
 	if (old_addr) {
 		prog = old_insn;
-		ret = emit_call(&prog, old_addr, (void *)ip);
+		ret = emit_call_jmp(&prog, old_addr, (void *)ip, insn);
 		if (ret)
 			return ret;
 	}
 	if (new_addr) {
 		prog = new_insn;
-		ret = emit_call(&prog, new_addr, (void *)ip);
+		ret = emit_call_jmp(&prog, new_addr, (void *)ip, insn);
 		if (ret)
 			return ret;
 	}
 	ret = -EBUSY;
 	mutex_lock(&text_mutex);
 	switch (t) {
+	case BPF_MOD_NOP_TO_JMP:
 	case BPF_MOD_NOP_TO_CALL:
 		if (memcmp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE))
 			goto out;
 		text_poke(ip, new_insn, X86_CALL_SIZE);
 		break;
+	case BPF_MOD_JMP_TO_JMP:
 	case BPF_MOD_CALL_TO_CALL:
 		if (memcmp(ip, old_insn, X86_CALL_SIZE))
 			goto out;
 		text_poke(ip, new_insn, X86_CALL_SIZE);
 		break;
+	case BPF_MOD_JMP_TO_NOP:
 	case BPF_MOD_CALL_TO_NOP:
 		if (memcmp(ip, old_insn, X86_CALL_SIZE))
 			goto out;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6a80af092048..38b0715050a9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1270,6 +1270,9 @@ enum bpf_text_poke_type {
 	BPF_MOD_NOP_TO_CALL,
 	BPF_MOD_CALL_TO_CALL,
 	BPF_MOD_CALL_TO_NOP,
+	BPF_MOD_NOP_TO_JMP,
+	BPF_MOD_JMP_TO_JMP,
+	BPF_MOD_JMP_TO_NOP,
 };
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
-- 
2.20.1

