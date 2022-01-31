Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247B14A4E93
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356737AbiAaShN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356944AbiAaShH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:37:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF961C06173E;
        Mon, 31 Jan 2022 10:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2moysldpF3D0YrY9nWIgUUodshHFtQk8RLnSpJ4W8gk=; b=R4VYhISoOa7xhPwQXhM5O6QUPn
        sBWyA1OAHDZAZcX25S6RnLZms7pB4zxmzlGAbH2v615Fyhq7blFxBH5IEQtWYCu0p5epom0MGb+ml
        jh0aDOdxyTf/cYxhmLTJRjwAPLVfBCgTWvnanY8yuls0mgk7MUv6OUB8hFwaVYjOBGOpC5JIbEkFC
        6A4x4rOI2wtW+oEJDFx9w9cn83WZKztl/Rk3ir3zwu9z1nEJOplIg1WfCH6Bz/c8gLJe6hX/zEz5j
        vE6wCdq8wFMBY+a55ipNumVgQQf423XUoNq43RRAEz7cLA/tWxigJ0jQCDE7qTa46U2h6qBlFvqTk
        yfndph2w==;
Received: from [2001:4bb8:191:327d:83ae:cf0e:db3c:eb79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nEbXr-00AOuy-7n; Mon, 31 Jan 2022 18:36:55 +0000
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
Subject: [PATCH 5/5] bpf, docs: Better document the atomic instructions
Date:   Mon, 31 Jan 2022 19:36:38 +0100
Message-Id: <20220131183638.3934982-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220131183638.3934982-1-hch@lst.de>
References: <20220131183638.3934982-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use proper tables and RST markup to document the atomic instructions
in a structured way.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 76 +++++++++++++++++----------
 1 file changed, 49 insertions(+), 27 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 048aea0952a2e..4e79a77febd43 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -249,39 +249,65 @@ Where size is one of: ``BPF_B``, ``BPF_H``, ``BPF_W``, or ``BPF_DW``.
 Atomic operations
 -----------------
 
-eBPF includes atomic operations, which use the immediate field for extra
-encoding::
+Atomic operations are operations that operate on memory and can not be
+interrupted or corrupted by other access to the same memory region
+by other eBPF programs or means outside of this specification.
 
-   .imm = BPF_ADD, .code = BPF_ATOMIC | BPF_W  | BPF_STX: lock xadd *(u32 *)(dst_reg + off16) += src_reg
-   .imm = BPF_ADD, .code = BPF_ATOMIC | BPF_DW | BPF_STX: lock xadd *(u64 *)(dst_reg + off16) += src_reg
+All atomic operations supported by eBPF are encoded as store operations
+that use the ``BPF_ATOMIC`` mode modifier as follows:
 
-The basic atomic operations supported are::
+  * ``BPF_ATOMIC | BPF_W | BPF_STX`` for 32-bit operations
+  * ``BPF_ATOMIC | BPF_DW | BPF_STX`` for 64-bit operations
+  * 8-bit and 16-bit wide atomic operations are not supported.
 
-    BPF_ADD
-    BPF_AND
-    BPF_OR
-    BPF_XOR
+The imm field is used to encode the actual atomic operation.
+Simple atomic operation use a subset of the values defined to encode
+arithmetic operations in the imm field to encode the atomic operation:
 
-Each having equivalent semantics with the ``BPF_ADD`` example, that is: the
-memory location addresed by ``dst_reg + off`` is atomically modified, with
-``src_reg`` as the other operand. If the ``BPF_FETCH`` flag is set in the
-immediate, then these operations also overwrite ``src_reg`` with the
-value that was in memory before it was modified.
+  ========  =====  ===========
+  imm       value  description
+  ========  =====  ===========
+  BPF_ADD   0x00   atomic add
+  BPF_OR    0x40   atomic or
+  BPF_AND   0x50   atomic and
+  BPF_XOR   0xa0   atomic xor
+  ========  =====  ===========
 
-The more special operations are::
 
-    BPF_XCHG
+``BPF_ATOMIC | BPF_W  | BPF_STX`` with imm = BPF_ADD means::
 
-This atomically exchanges ``src_reg`` with the value addressed by ``dst_reg +
-off``. ::
+  *(u32 *)(dst_reg + off16) += src_reg
 
-    BPF_CMPXCHG
+``BPF_ATOMIC | BPF_DW | BPF_STX`` with imm = BPF ADD means::
 
-This atomically compares the value addressed by ``dst_reg + off`` with
-``R0``. If they match it is replaced with ``src_reg``. In either case, the
-value that was there before is zero-extended and loaded back to ``R0``.
+  *(u64 *)(dst_reg + off16) += src_reg
 
-Note that 1 and 2 byte atomic operations are not supported.
+``BPF_XADD`` is a deprecated name for ``BPF_ATOMIC | BPF_ADD``.
+
+In addition to the simple atomic operations, there also is a modifier and
+two complex atomic operations:
+
+  ===========  ================  ===========================
+  imm          value             description
+  ===========  ================  ===========================
+  BPF_FETCH    0x01              modifier: return old value
+  BPF_XCHG     0xe0 | BPF_FETCH  atomic exchange
+  BPF_CMPXCHG  0xf0 | BPF_FETCH  atomic compare and exchange
+  ===========  ================  ===========================
+
+The ``BPF_FETCH`` modifier is optional for simple atomic operations, and
+always set for the complex atomic operations.  If the ``BPF_FETCH`` flag
+is set, then the operation also overwrites ``src_reg`` with the value that
+was in memory before it was modified.
+
+The ``BPF_XCHG`` operation atomically exchanges ``src_reg`` with the value
+addressed by ``dst_reg + off``.
+
+The ``BPF_CMPXCHG`` operation atomically compares the value addressed by
+``dst_reg + off`` with ``R0``. If they match, the value addressed by
+``dst_reg + off`` is replaced with ``src_reg``. In either case, the
+value that was at ``dst_reg + off`` before the operation is zero-extended
+and loaded back to ``R0``.
 
 Clang can generate atomic instructions by default when ``-mcpu=v3`` is
 enabled. If a lower version for ``-mcpu`` is set, the only atomic instruction
@@ -289,10 +315,6 @@ Clang can generate is ``BPF_ADD`` *without* ``BPF_FETCH``. If you need to enable
 the atomics features, while keeping a lower ``-mcpu`` version, you can use
 ``-Xclang -target-feature -Xclang +alu32``.
 
-You may encounter ``BPF_XADD`` - this is a legacy name for ``BPF_ATOMIC``,
-referring to the exclusive-add operation encoded when the immediate field is
-zero.
-
 64-bit immediate instructions
 -----------------------------
 
-- 
2.30.2

