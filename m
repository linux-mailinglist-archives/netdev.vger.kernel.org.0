Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1851A48370A
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiACSgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbiACSgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:36:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA282C061792;
        Mon,  3 Jan 2022 10:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7+pxu6cDD4g2E8lG+K1S7eqbHuoDNUuSCiRxnDV66sg=; b=MqA3Hqi4WE303YbcKTI4usg9TS
        M4FJ98wRqebNFJlP1onyD495XPZhh2ddIv5RwcK7yPGotXDJkfc5APn/6F1ytF1BKSgIvk8hk2gI7
        I0ByNfV/TjdWPjTmocznGnoXp5yR18s4skUTDVl0W1pyD/daS1Xa/AGI//7G8APSGYsTaOwAJlkSU
        GTJ+slZcojF7G23bTmb49LzXLB4uJuNGfjdGuHv56SU8A9vj+O96OZwe5mWxQRqAitZZd1SDSOyvG
        vfWB6CNO+2vOSrx5EbTpitLfSgWAT6BgIxSKrsC2hGP2QmO1zU145YgYaw1mj06MlRCJgZLU+/OAo
        oEZoHM+Q==;
Received: from [2001:4bb8:184:3f95:b8f7:97d6:6b53:b9be] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4SBi-009qRr-IN; Mon, 03 Jan 2022 18:36:07 +0000
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
Subject: [PATCH 2/6] bpf, docs: Add subsections for ALU and JMP instructions
Date:   Mon,  3 Jan 2022 19:35:52 +0100
Message-Id: <20220103183556.41040-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220103183556.41040-1-hch@lst.de>
References: <20220103183556.41040-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a little more stucture to the ALU/JMP documentation with sections and
improve the example text.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 52 ++++++++++++++++-----------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 80f42984b5942..03bf3c6c55771 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -74,7 +74,13 @@ The 4th bit encodes the source operand:
 
 The four MSB bits store the operation code.
 
-For class BPF_ALU or BPF_ALU64:
+
+Arithmetic instructions
+-----------------------
+
+BPF_ALU uses 32-bit wide operands while BPF_ALU64 uses 64-bit wide operands for
+otherwise identical operations.
+The code field encodes the operation as below:
 
   ========  =====  =========================
   code      value  description
@@ -95,7 +101,29 @@ For class BPF_ALU or BPF_ALU64:
   BPF_END   0xd0   endianness conversion
   ========  =====  =========================
 
-For class BPF_JMP or BPF_JMP32:
+BPF_ADD | BPF_X | BPF_ALU means::
+
+  dst_reg = (u32) dst_reg + (u32) src_reg;
+
+BPF_ADD | BPF_X | BPF_ALU64 means::
+
+  dst_reg = dst_reg + src_reg
+
+BPF_XOR | BPF_K | BPF_ALU means::
+
+  src_reg = (u32) src_reg ^ (u32) imm32
+
+BPF_XOR | BPF_K | BPF_ALU64 means::
+
+  src_reg = src_reg ^ imm32
+
+
+Jump instructions
+-----------------
+
+BPF_JMP32 uses 32-bit wide operands while BPF_JMP uses 64-bit wide operands for
+otherwise identical operations.
+The code field encodes the operation as below:
 
   ========  =====  =========================
   code      value  description
@@ -116,24 +144,8 @@ For class BPF_JMP or BPF_JMP32:
   BPF_JSLE  0xd0   signed '<='
   ========  =====  =========================
 
-So BPF_ADD | BPF_X | BPF_ALU means::
-
-  dst_reg = (u32) dst_reg + (u32) src_reg;
-
-Similarly, BPF_XOR | BPF_K | BPF_ALU means::
-
-  src_reg = (u32) src_reg ^ (u32) imm32
-
-eBPF is using BPF_MOV | BPF_X | BPF_ALU to represent A = B moves.  BPF_ALU64
-is used to mean exactly the same operations as BPF_ALU, but with 64-bit wide
-operands instead. So BPF_ADD | BPF_X | BPF_ALU64 means 64-bit addition, i.e.::
-
-  dst_reg = dst_reg + src_reg
-
-BPF_JMP | BPF_EXIT means function exit only. The eBPF program needs to store
-the return value into register R0 before doing a BPF_EXIT. Class 6 is used as
-BPF_JMP32 to mean exactly the same operations as BPF_JMP, but with 32-bit wide
-operands for the comparisons instead.
+The eBPF program needs to store the return value into register R0 before doing a
+BPF_EXIT.
 
 
 Load and store instructions
-- 
2.30.2

