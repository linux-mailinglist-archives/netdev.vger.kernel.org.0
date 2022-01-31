Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4DA4A4E90
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356766AbiAaShM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355341AbiAaSg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:36:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF83EC061741;
        Mon, 31 Jan 2022 10:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=65otJvu39ooLKVvhHd+SvuR6Mo3UfWkuAnUb1bbOYag=; b=UeHcL8g4gJ35U3zHmJblK5s1xz
        Zkhml0kDhnJEYRV4Kzn7ap7nq8UHgXVVeanNobsAbm2lqaOYqSatNUB9qLwIQPoHeo6xuVGJCqLMF
        qsIj0T5C1f08yYSgqF3d0hOsFaD+KLSONghgJVPoyUoZP/y1f/Dw2GnzoCB9CM0CtY5/ZywIREX3q
        ZTxuse/WehiBBdMP3js2M+3BhZfZd7QUah9ohHXtIHiKPIZsAQoRKlYzl0OpZiDOLOgn0GvrfI35S
        hd5mgSPPzL0bh+yCWRyPqdWkQFzZIAkPu5svZ1+owK7JG+Y1cDGuMRJ8NON6aq9M3EIHWTDd2VnU1
        IU0463bA==;
Received: from [2001:4bb8:191:327d:83ae:cf0e:db3c:eb79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nEbXo-00AOtf-Fm; Mon, 31 Jan 2022 18:36:53 +0000
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
Subject: [PATCH 4/5] bpf, docs: Better document the extended instruction format
Date:   Mon, 31 Jan 2022 19:36:37 +0100
Message-Id: <20220131183638.3934982-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220131183638.3934982-1-hch@lst.de>
References: <20220131183638.3934982-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In addition to the normal 64-bit instruction encoding, eBPF also has
a single instruction that uses a second 64-bit bits for a second
immediate value.  Instead of only documenting this format deep down
in the document mention it in the instruction encoding section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index b3c2621216c97..048aea0952a2e 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -22,7 +22,13 @@ necessary across calls.
 Instruction encoding
 ====================
 
-eBPF uses 64-bit instructions with the following encoding:
+eBPF has two instruction encodings:
+
+ * the basic instruction encoding, which uses 64 bits to encode an instruction
+ * the wide instruction encoding, which appends a second 64-bit immediate value
+   (imm64) after the basic instruction for a total of 128 bits.
+
+The basic instruction encoding looks as follows:
 
  =============  =======  ===============  ====================  ============
  32 bits (MSB)  16 bits  4 bits           4 bits                8 bits (LSB)
@@ -212,7 +218,7 @@ The mode modifier is one of:
   =============  =====  ====================================
   mode modifier  value  description
   =============  =====  ====================================
-  BPF_IMM        0x00   used for 64-bit mov
+  BPF_IMM        0x00   64-bit immediate instructions
   BPF_ABS        0x20   legacy BPF packet access (absolute)
   BPF_IND        0x40   legacy BPF packet access (indirect)
   BPF_MEM        0x60   regular load and store operations
@@ -287,12 +293,18 @@ You may encounter ``BPF_XADD`` - this is a legacy name for ``BPF_ATOMIC``,
 referring to the exclusive-add operation encoded when the immediate field is
 zero.
 
-16-byte instructions
---------------------
+64-bit immediate instructions
+-----------------------------
+
+Instructions with the ``BPF_IMM`` mode modifier use the wide instruction
+encoding for an extra imm64 value.
+
+There is currently only one such instruction.
+
+``BPF_LD | BPF_DW | BPF_IMM`` means::
+
+  dst_reg = imm64
 
-eBPF has one 16-byte instruction: ``BPF_LD | BPF_DW | BPF_IMM`` which consists
-of two consecutive ``struct bpf_insn`` 8-byte blocks and interpreted as single
-instruction that loads 64-bit immediate value into a dst_reg.
 
 Legacy BPF Packet access instructions
 -------------------------------------
-- 
2.30.2

