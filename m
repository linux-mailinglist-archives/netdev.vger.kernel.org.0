Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B7E4A4E82
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356129AbiAaSgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350681AbiAaSgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:36:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDA9C061714;
        Mon, 31 Jan 2022 10:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zPUoEqmJ2GXL60y/CrvtI2zBNZa+ALtNejAU2/BtqYs=; b=xLwaKZ+xr7dQLjswBRPgcqIGES
        FJpEqDzxGsYoOmK5oIBA1qsUmbmiDxipWL5jgNKzFetEEnG/Ty/K8OVd9nEJq8z3yoyQ6R+nVW63M
        zh+lApHe22pGlYgrtPRXstIbwjHMrtLZP6mvW+WOZnZIzsU1zx4h+XJierw8HIZ4zfVi5xgnER9TY
        efgSe1UtyWGf84RXuVSIuhQZJt9+QlVp8umHgD7LCilodAyqozgganDhiXBepylxAs8/Y0KNtDXHb
        wpIZeE0oNXgN+Q5S70BJFnKHZ63YlbGj3Tow5vPHP4uGod1/QYZ3sAenXrhzCQ3aMWjKHlDD9V64F
        j3M1xg7g==;
Received: from [2001:4bb8:191:327d:83ae:cf0e:db3c:eb79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nEbXg-00AOrb-E8; Mon, 31 Jan 2022 18:36:45 +0000
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
Subject: [PATCH 1/5] bpf, docs: Document the byte swapping instructions
Date:   Mon, 31 Jan 2022 19:36:34 +0100
Message-Id: <20220131183638.3934982-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220131183638.3934982-1-hch@lst.de>
References: <20220131183638.3934982-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a section to document the byte swapping instructions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 44 ++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 3704836fe6df6..87f6ad62633a5 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -82,9 +82,9 @@ BPF_ALU uses 32-bit wide operands while BPF_ALU64 uses 64-bit wide operands for
 otherwise identical operations.
 The code field encodes the operation as below:
 
-  ========  =====  ==========================
+  ========  =====  =================================================
   code      value  description
-  ========  =====  ==========================
+  ========  =====  =================================================
   BPF_ADD   0x00   dst += src
   BPF_SUB   0x10   dst -= src
   BPF_MUL   0x20   dst \*= src
@@ -98,8 +98,8 @@ The code field encodes the operation as below:
   BPF_XOR   0xa0   dst ^= src
   BPF_MOV   0xb0   dst = src
   BPF_ARSH  0xc0   sign extending shift right
-  BPF_END   0xd0   endianness conversion
-  ========  =====  ==========================
+  BPF_END   0xd0   byte swap operations (see separate section below)
+  ========  =====  =================================================
 
 BPF_ADD | BPF_X | BPF_ALU means::
 
@@ -118,6 +118,42 @@ BPF_XOR | BPF_K | BPF_ALU64 means::
   src_reg = src_reg ^ imm32
 
 
+Byte swap instructions
+----------------------
+
+The byte swap instructions use an instruction class of ``BFP_ALU`` and a 4-bit
+code field of ``BPF_END``.
+
+The byte swap instructions instructions operate on the destination register
+only and do not use a separate source register or immediate value.
+
+The 1-bit source operand field in the opcode is used to to select what byte
+order the operation convert from or to:
+
+  =========  =====  =================================================
+  source     value  description
+  =========  =====  =================================================
+  BPF_TO_LE  0x00   convert between host byte order and little endian
+  BPF_TO_BE  0x08   convert between host byte order and big endian
+  =========  =====  =================================================
+
+The imm field encodes the width of the swap operations.  The following widths
+are supported: 16, 32 and 64.
+
+Examples:
+
+``BPF_ALU | BPF_TO_LE | BPF_END`` with imm = 16 means::
+
+  dst_reg = htole16(dst_reg)
+
+``BPF_ALU | BPF_TO_BE | BPF_END`` with imm = 64 means::
+
+  dst_reg = htobe64(dst_reg)
+
+``BPF_FROM_LE`` and ``BPF_FROM_BE`` exist as aliases for ``BPF_TO_LE`` and
+``BPF_TO_LE`` respetively.
+
+
 Jump instructions
 -----------------
 
-- 
2.30.2

