Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67661967B2
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 17:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgC1QqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 12:46:11 -0400
Received: from mx.sdf.org ([205.166.94.20]:50094 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727639AbgC1Qn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 12:43:26 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02SGhPra027632
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 28 Mar 2020 16:43:25 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02SGhPH7029961;
        Sat, 28 Mar 2020 16:43:25 GMT
Message-Id: <202003281643.02SGhPH7029961@sdf.org>
From:   George Spelvin <lkml@sdf.org>
Date:   Fri, 29 Nov 2019 17:16:39 -0500
Subject: [RFC PATCH v1 47/50] kernel/bpf/core.c: Use get_random_max32()
To:     linux-kernel@vger.kernel.org, lkml@sdf.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smaller, faster, and a smidge more uniform than %.

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 kernel/bpf/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index af6b738cf435c..61713a7f73d85 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -874,7 +874,7 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 	hdr->pages = pages;
 	hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
 		     PAGE_SIZE - sizeof(*hdr));
-	start = (get_random_int() % hole) & ~(alignment - 1);
+	start = get_random_max32(hole) & ~(alignment - 1);
 
 	/* Leave a random number of instructions before BPF code. */
 	*image_ptr = &hdr->image[start];
@@ -947,7 +947,7 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 			      bool emit_zext)
 {
 	struct bpf_insn *to = to_buff;
-	u32 imm_rnd = get_random_int();
+	u32 imm_rnd = get_random_u32();
 	s16 off;
 
 	BUILD_BUG_ON(BPF_REG_AX  + 1 != MAX_BPF_JIT_REG);
-- 
2.26.0

