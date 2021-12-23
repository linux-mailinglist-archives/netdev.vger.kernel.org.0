Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB9B47E14E
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 11:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347671AbhLWKUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 05:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347682AbhLWKTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 05:19:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA087C061401;
        Thu, 23 Dec 2021 02:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YXA9bNbu70qCMUKMU1gqidDciHX65bz6vVCKVKz0r7I=; b=FVOVE7Nb0V3sHmy/eGPPRBgkp6
        9IWtM+8HfpxA2qXkQWiH1oyRZYZMEuKIXxr8RaYxoZGH5R5h/iCD2npy6/rX0ILPwxn7ovuv9X8XA
        hw9TODB5mQeUpqr0sc0WZ+k1bJpoZZB7tdSMUlOWDsS+nimGFGdpp8SR29AcbzWrFAQs1N3Vrdtgz
        6VD/KPLRhZ8pSr1gmy3tQx6JtTUrfXpUwGs4UYcL456PZh0rfj6f4A19ZvfmvpGN1+zveiXqwrhaO
        YyaCcRlWKvQsL3m+7zS4zq0iiQYxwA18KNu13hk9VnonGDBQAd+vsxVoxuTxAnOnv/Ji/fZcUdscS
        8QfVjyQA==;
Received: from [46.183.103.8] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0LC3-00CTmy-3G; Thu, 23 Dec 2021 10:19:27 +0000
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
Subject: [PATCH 4/4] bpf, docs: Move the packet access instructions last in instruction-set.rst
Date:   Thu, 23 Dec 2021 11:19:06 +0100
Message-Id: <20211223101906.977624-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211223101906.977624-1-hch@lst.de>
References: <20211223101906.977624-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packet access instructions are a convoluted leftover from classic
BPF.  Move them last past the much more important atomic operations,
and improve the rendering of the code example.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 55 +++++++++++++--------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 4e3041cf04325..922635f0c18b7 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -171,34 +171,6 @@ BPF_MEM | <size> | BPF_LDX means::
 
 Where size is one of: BPF_B or BPF_H or BPF_W or BPF_DW.
 
-Packet access instructions
---------------------------
-
-eBPF has two non-generic instructions: (BPF_ABS | <size> | BPF_LD) and
-(BPF_IND | <size> | BPF_LD) which are used to access packet data.
-
-They had to be carried over from classic BPF to have strong performance of
-socket filters running in eBPF interpreter. These instructions can only
-be used when interpreter context is a pointer to ``struct sk_buff`` and
-have seven implicit operands. Register R6 is an implicit input that must
-contain pointer to sk_buff. Register R0 is an implicit output which contains
-the data fetched from the packet. Registers R1-R5 are scratch registers
-and must not be used to store the data across BPF_ABS | BPF_LD or
-BPF_IND | BPF_LD instructions.
-
-These instructions have implicit program exit condition as well. When
-eBPF program is trying to access the data beyond the packet boundary,
-the interpreter will abort the execution of the program. JIT compilers
-therefore must preserve this property. src_reg and imm32 fields are
-explicit inputs to these instructions.
-
-For example::
-
-  BPF_IND | BPF_W | BPF_LD means:
-
-    R0 = ntohl(*(u32 *) (((struct sk_buff *) R6)->data + src_reg + imm32))
-    and R1 - R5 were scratched.
-
 Atomic operations
 -----------------
 
@@ -252,3 +224,30 @@ zero.
 eBPF has one 16-byte instruction: ``BPF_LD | BPF_DW | BPF_IMM`` which consists
 of two consecutive ``struct bpf_insn`` 8-byte blocks and interpreted as single
 instruction that loads 64-bit immediate value into a dst_reg.
+
+Packet access instructions
+--------------------------
+
+eBPF has two non-generic instructions: (BPF_ABS | <size> | BPF_LD) and
+(BPF_IND | <size> | BPF_LD) which are used to access packet data.
+
+They had to be carried over from classic BPF to have strong performance of
+socket filters running in eBPF interpreter. These instructions can only
+be used when interpreter context is a pointer to ``struct sk_buff`` and
+have seven implicit operands. Register R6 is an implicit input that must
+contain pointer to sk_buff. Register R0 is an implicit output which contains
+the data fetched from the packet. Registers R1-R5 are scratch registers
+and must not be used to store the data across BPF_ABS | BPF_LD or
+BPF_IND | BPF_LD instructions.
+
+These instructions have implicit program exit condition as well. When
+eBPF program is trying to access the data beyond the packet boundary,
+the interpreter will abort the execution of the program. JIT compilers
+therefore must preserve this property. src_reg and imm32 fields are
+explicit inputs to these instructions.
+
+For example, BPF_IND | BPF_W | BPF_LD means::
+
+  R0 = ntohl(*(u32 *) (((struct sk_buff *) R6)->data + src_reg + imm32))
+
+and R1 - R5 are clobbered.
-- 
2.30.2

