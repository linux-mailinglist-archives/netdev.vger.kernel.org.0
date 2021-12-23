Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7416C47E148
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 11:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347664AbhLWKTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 05:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347665AbhLWKTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 05:19:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C23BC061756;
        Thu, 23 Dec 2021 02:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FRxh4CNjE6PE3Xy1P8JzDb1rCQo5bFb/fD480b8aLwA=; b=lJ+XboMSq9WIlPLO0Kf2RXOY5z
        y6txD+dBDinkgZElJT4dps3etp2C6BPDH505XqfJifpdguWqEM44NCIuxV1PdJwStQCzbps8K43TS
        tgxSVO0socN2srkJGoQiXm5K8wXAIhuBPfahMyuVpEfARyeWT1nK7W6jd5C/W51efqkOQOdbpSV3k
        dZ6eDI8vWuCCwp39lE08aLPTbyTOVMCEPOwW6ByoURThxLMh26KNSLnTLn1lTXXnt21WY/16qV0Gg
        VKiqgk+N/aBFSomr8MdR4DpfRF6iSc1wav/+8a2nfBgdlHwm7NmpJznEwBmJomu+/8k93clsjqEty
        33tLeTuA==;
Received: from [46.183.103.8] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0LBz-00CTmF-SP; Thu, 23 Dec 2021 10:19:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 3/4] bpf, docs: Generate nicer tables for instruction encodings
Date:   Thu, 23 Dec 2021 11:19:05 +0100
Message-Id: <20211223101906.977624-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211223101906.977624-1-hch@lst.de>
References: <20211223101906.977624-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use RST tables that are nicely readable both in plain ascii as well as
in html to render the instruction encodings, and add a few subheadings
to better structure the text.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 158 ++++++++++++++++----------
 1 file changed, 95 insertions(+), 63 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 3967842e00234..4e3041cf04325 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -19,19 +19,10 @@ The eBPF calling convention is defined as:
 R0 - R5 are scratch registers and eBPF programs needs to spill/fill them if
 necessary across calls.
 
-eBPF opcode encoding
-====================
-
-For arithmetic and jump instructions the 8-bit 'opcode' field is divided into
-three parts::
-
-  +----------------+--------+--------------------+
-  |   4 bits       |  1 bit |   3 bits           |
-  | operation code | source | instruction class  |
-  +----------------+--------+--------------------+
-  (MSB)                                      (LSB)
+Instruction classes
+===================
 
-Three LSB bits store instruction class which is one of:
+The three LSB bits of the 'opcode' field store the instruction class:
 
   ========= =====
   class     value
@@ -46,17 +37,34 @@ Three LSB bits store instruction class which is one of:
   BPF_ALU64 0x07
   ========= =====
 
-When BPF_CLASS(code) == BPF_ALU or BPF_JMP, 4th bit encodes source operand ...
+Arithmetic and jump instructions
+================================
+
+For arithmetic and jump instructions (BPF_ALU, BPF_ALU64, BPF_JMP and
+BPF_JMP32), the 8-bit 'opcode' field is divided into three parts:
 
-::
+  ==============  ======  =================
+  4 bits (MSB)    1 bit   3 bits (LSB)
+  ==============  ======  =================
+  operation code  source  instruction class
+  ==============  ======  =================
 
-  BPF_K     0x00 /* use 32-bit immediate as source operand */
-  BPF_X     0x08 /* use 'src_reg' register as source operand */
+The 4th bit encodes the source operand:
 
-... and four MSB bits store operation code.
+  ======  =====  ========================================
+  source  value  description
+  ======  =====  ========================================
+  BPF_K   0x00   use 32-bit immediate as source operand
+  BPF_X   0x08   use 'src_reg' register as source operand
+  ======  =====  ========================================
 
-If BPF_CLASS(code) == BPF_ALU or BPF_ALU64 BPF_OP(code) is one of::
+The four MSB bits store the operation code.
 
+For class BPF_ALU or BPF_ALU64:
+
+  ========  =====  =========================
+  code      value  description
+  ========  =====  =========================
   BPF_ADD   0x00
   BPF_SUB   0x10
   BPF_MUL   0x20
@@ -68,26 +76,31 @@ If BPF_CLASS(code) == BPF_ALU or BPF_ALU64 BPF_OP(code) is one of::
   BPF_NEG   0x80
   BPF_MOD   0x90
   BPF_XOR   0xa0
-  BPF_MOV   0xb0  /* mov reg to reg */
-  BPF_ARSH  0xc0  /* sign extending shift right */
-  BPF_END   0xd0  /* endianness conversion */
+  BPF_MOV   0xb0   mov reg to reg
+  BPF_ARSH  0xc0   sign extending shift right
+  BPF_END   0xd0   endianness conversion
+  ========  =====  =========================
 
-If BPF_CLASS(code) == BPF_JMP or BPF_JMP32 BPF_OP(code) is one of::
+For class BPF_JMP or BPF_JMP32:
 
-  BPF_JA    0x00  /* BPF_JMP only */
+  ========  =====  =========================
+  code      value  description
+  ========  =====  =========================
+  BPF_JA    0x00   BPF_JMP only
   BPF_JEQ   0x10
   BPF_JGT   0x20
   BPF_JGE   0x30
   BPF_JSET  0x40
-  BPF_JNE   0x50  /* jump != */
-  BPF_JSGT  0x60  /* signed '>' */
-  BPF_JSGE  0x70  /* signed '>=' */
-  BPF_CALL  0x80  /* function call */
-  BPF_EXIT  0x90  /*  function return */
-  BPF_JLT   0xa0  /* unsigned '<' */
-  BPF_JLE   0xb0  /* unsigned '<=' */
-  BPF_JSLT  0xc0  /* signed '<' */
-  BPF_JSLE  0xd0  /* signed '<=' */
+  BPF_JNE   0x50   jump '!='
+  BPF_JSGT  0x60   signed '>'
+  BPF_JSGE  0x70   signed '>='
+  BPF_CALL  0x80   function call
+  BPF_EXIT  0x90   function return
+  BPF_JLT   0xa0   unsigned '<'
+  BPF_JLE   0xb0   unsigned '<='
+  BPF_JSLT  0xc0   signed '<'
+  BPF_JSLE  0xd0   signed '<='
+  ========  =====  =========================
 
 So BPF_ADD | BPF_X | BPF_ALU means::
 
@@ -108,37 +121,58 @@ the return value into register R0 before doing a BPF_EXIT. Class 6 is used as
 BPF_JMP32 to mean exactly the same operations as BPF_JMP, but with 32-bit wide
 operands for the comparisons instead.
 
-For load and store instructions the 8-bit 'code' field is divided as::
 
-  +--------+--------+-------------------+
-  | 3 bits | 2 bits |   3 bits          |
-  |  mode  |  size  | instruction class |
-  +--------+--------+-------------------+
-  (MSB)                             (LSB)
+Load and store instructions
+===========================
+
+For load and store instructions (BPF_LD, BPF_LDX, BPF_ST and BPF_STX), the
+8-bit 'opcode' field is divided as:
+
+  ============  ======  =================
+  3 bits (MSB)  2 bits  3 bits (LSB)
+  ============  ======  =================
+  mode          size    instruction class
+  ============  ======  =================
+
+The size modifier is one of:
 
-Size modifier is one of ...
+  =============  =====  =====================
+  size modifier  value  description
+  =============  =====  =====================
+  BPF_W          0x00   word        (4 bytes)
+  BPF_H          0x08   half word   (2 bytes)
+  BPF_B          0x10   byte
+  BPF_DW         0x18   double word (8 bytes)
+  =============  =====  =====================
 
-::
+The mode modifier is one of:
 
-  BPF_W   0x00    /* word */
-  BPF_H   0x08    /* half word */
-  BPF_B   0x10    /* byte */
-  BPF_DW  0x18    /* double word */
+  =============  =====  =====================
+  mode modifier  value  description
+  =============  =====  =====================
+  BPF_IMM        0x00   used for 64-bit mov
+  BPF_ABS        0x20
+  BPF_IND        0x40
+  BPF_MEM        0x60
+  BPF_ATOMIC     0xc0   atomic operations 
+  =============  =====  =====================
 
-... which encodes size of load/store operation::
+BPF_MEM | <size> | BPF_STX means::
 
- B  - 1 byte
- H  - 2 byte
- W  - 4 byte
- DW - 8 byte
+  *(size *) (dst_reg + off) = src_reg
 
-Mode modifier is one of::
+BPF_MEM | <size> | BPF_ST means::
 
-  BPF_IMM     0x00  /* used for 64-bit mov */
-  BPF_ABS     0x20
-  BPF_IND     0x40
-  BPF_MEM     0x60
-  BPF_ATOMIC  0xc0  /* atomic operations */
+  *(size *) (dst_reg + off) = imm32
+
+BPF_MEM | <size> | BPF_LDX means::
+
+  dst_reg = *(size *) (src_reg + off)
+
+Where size is one of: BPF_B or BPF_H or BPF_W or BPF_DW.
+
+Packet access instructions
+--------------------------
 
 eBPF has two non-generic instructions: (BPF_ABS | <size> | BPF_LD) and
 (BPF_IND | <size> | BPF_LD) which are used to access packet data.
@@ -165,15 +199,10 @@ For example::
     R0 = ntohl(*(u32 *) (((struct sk_buff *) R6)->data + src_reg + imm32))
     and R1 - R5 were scratched.
 
-eBPF has generic load/store operations::
+Atomic operations
+-----------------
 
-    BPF_MEM | <size> | BPF_STX:  *(size *) (dst_reg + off) = src_reg
-    BPF_MEM | <size> | BPF_ST:   *(size *) (dst_reg + off) = imm32
-    BPF_MEM | <size> | BPF_LDX:  dst_reg = *(size *) (src_reg + off)
-
-Where size is one of: BPF_B or BPF_H or BPF_W or BPF_DW.
-
-It also includes atomic operations, which use the immediate field for extra
+eBPF includes atomic operations, which use the immediate field for extra
 encoding::
 
    .imm = BPF_ADD, .code = BPF_ATOMIC | BPF_W  | BPF_STX: lock xadd *(u32 *)(dst_reg + off16) += src_reg
@@ -217,6 +246,9 @@ You may encounter ``BPF_XADD`` - this is a legacy name for ``BPF_ATOMIC``,
 referring to the exclusive-add operation encoded when the immediate field is
 zero.
 
+16-byte instructions
+--------------------
+
 eBPF has one 16-byte instruction: ``BPF_LD | BPF_DW | BPF_IMM`` which consists
 of two consecutive ``struct bpf_insn`` 8-byte blocks and interpreted as single
 instruction that loads 64-bit immediate value into a dst_reg.
-- 
2.30.2

