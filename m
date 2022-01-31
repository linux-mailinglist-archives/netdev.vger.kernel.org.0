Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E264A4E89
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356756AbiAaSg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356415AbiAaSgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:36:55 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A16C061714;
        Mon, 31 Jan 2022 10:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eQ9pR5g/eaZwRC6wov6WHMP3xNbN9HX9luYppfnhbmY=; b=tT/gDvWqYlJModAOkH63wmGjzZ
        0juOmGjCDh+ic0klZx++cILrNAMetf8W166x193ouswWOaR6OJmgrKIyAuv3VHNBZHGRpugjkLu0r
        gfabiHiVCjoGKb728wvyM94HERnSadKa8TXzkAco6bSzvSAUuF6bBh88ejsgNFtMmoqGgqQy037Yy
        Hzx6cx/Q+tz2pSszHMnyDIPRW626ZG8Y7DEKi6srbHrLadhbUAjCXw5wirXn2J5cXRGI1PML1LPoL
        fjlWDxphNdKRPKWQF4ea9UGyamaY7AMm3h6E21xcUAeGa6v8L3y7jx2M7oiptyfUmzr98zpjyCrNk
        Tu/ZkbRQ==;
Received: from [2001:4bb8:191:327d:83ae:cf0e:db3c:eb79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nEbXl-00AOsr-Ry; Mon, 31 Jan 2022 18:36:50 +0000
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
Subject: [PATCH 3/5] bpf, docs: Better document the legacy packet access instruction
Date:   Mon, 31 Jan 2022 19:36:36 +0100
Message-Id: <20220131183638.3934982-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220131183638.3934982-1-hch@lst.de>
References: <20220131183638.3934982-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use consistent terminology and structured RST elements to better document
these two oddball instructions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 54 ++++++++++++++++-----------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 03da885301722..b3c2621216c97 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -213,8 +213,8 @@ The mode modifier is one of:
   mode modifier  value  description
   =============  =====  ====================================
   BPF_IMM        0x00   used for 64-bit mov
-  BPF_ABS        0x20   legacy BPF packet access
-  BPF_IND        0x40   legacy BPF packet access
+  BPF_ABS        0x20   legacy BPF packet access (absolute)
+  BPF_IND        0x40   legacy BPF packet access (indirect)
   BPF_MEM        0x60   regular load and store operations
   BPF_ATOMIC     0xc0   atomic operations
   =============  =====  ====================================
@@ -294,29 +294,39 @@ eBPF has one 16-byte instruction: ``BPF_LD | BPF_DW | BPF_IMM`` which consists
 of two consecutive ``struct bpf_insn`` 8-byte blocks and interpreted as single
 instruction that loads 64-bit immediate value into a dst_reg.
 
-Packet access instructions
---------------------------
+Legacy BPF Packet access instructions
+-------------------------------------
 
-eBPF has two non-generic instructions: (BPF_ABS | <size> | BPF_LD) and
-(BPF_IND | <size> | BPF_LD) which are used to access packet data.
+eBPF has special instructions for access to packet data that have been
+carried over from classic BPF to retain the performance of legacy socket
+filters running in the eBPF interpreter.
 
-They had to be carried over from classic BPF to have strong performance of
-socket filters running in eBPF interpreter. These instructions can only
-be used when interpreter context is a pointer to ``struct sk_buff`` and
-have seven implicit operands. Register R6 is an implicit input that must
-contain pointer to sk_buff. Register R0 is an implicit output which contains
-the data fetched from the packet. Registers R1-R5 are scratch registers
-and must not be used to store the data across BPF_ABS | BPF_LD or
-BPF_IND | BPF_LD instructions.
+The instructions come in two forms: ``BPF_ABS | <size> | BPF_LD`` and
+``BPF_IND | <size> | BPF_LD``.
 
-These instructions have implicit program exit condition as well. When
-eBPF program is trying to access the data beyond the packet boundary,
-the interpreter will abort the execution of the program. JIT compilers
-therefore must preserve this property. src_reg and imm32 fields are
-explicit inputs to these instructions.
+These instructions are used to access packet data and can only be used when
+the interpreter context is a pointer to networking packet.  ``BPF_ABS``
+accesses packet data at an absolute offset specified by the immediate data
+and ``BPF_IND`` access packet data at an offset that includes the value of
+a register in addition to the immediate data.
 
-For example, BPF_IND | BPF_W | BPF_LD means::
+These instructions have seven implicit operands:
 
-  R0 = ntohl(*(u32 *) (((struct sk_buff *) R6)->data + src_reg + imm32))
+ * Register R6 is an implicit input that must contain pointer to a
+   struct sk_buff.
+ * Register R0 is an implicit output which contains the data fetched from
+   the packet.
+ * Registers R1-R5 are scratch registers that are clobbered after a call to
+   ``BPF_ABS | BPF_LD`` or ``BPF_IND`` | BPF_LD instructions.
+
+These instructions have an implicit program exit condition as well. When an
+eBPF program is trying to access the data beyond the packet boundary, the
+interpreter will abort the execution of the program.
+
+``BPF_ABS | BPF_W | BPF_LD`` means::
 
-and R1 - R5 are clobbered.
+  R0 = ntohl(*(u32 *) (((struct sk_buff *) R6)->data + imm32))
+
+``BPF_IND | BPF_W | BPF_LD`` means::
+
+  R0 = ntohl(*(u32 *) (((struct sk_buff *) R6)->data + src_reg + imm32))
-- 
2.30.2

