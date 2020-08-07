Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562AA23F1F0
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgHGRaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:30:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726058AbgHGRaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 13:30:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596821453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=+N5fdgs+uhYlRTgonDxBbLny5jQj7lMBNfhd4oFnrSo=;
        b=BCLzCPl5b7pNSvKPDZNAaBk+lbePiBtp877432p9t2UAjgVzOWWYmXVLnykRFmGkMfvkT2
        Cm7pFM2wArqH/n2YPU1kn2dkZmOrInR8L4dsR6DdSsXFJZG5xHL0rnL1IfUE7bddIJRwtb
        etXcMNXkGKgp68RHOgYOnx48SsRN4w4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-GR4slS27N3OhfGngYGMwpQ-1; Fri, 07 Aug 2020 13:30:50 -0400
X-MC-Unique: GR4slS27N3OhfGngYGMwpQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D034106B253;
        Fri,  7 Aug 2020 17:30:48 +0000 (UTC)
Received: from krava (unknown [10.40.193.136])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4AF49712DB;
        Fri,  7 Aug 2020 17:30:46 +0000 (UTC)
Date:   Fri, 7 Aug 2020 19:30:45 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [RFC] bpf: verifier check for dead branch
Message-ID: <20200807173045.GC561444@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
we have a customer facing some odd verifier fails on following
sk_skb program:

   0. r2 = *(u32 *)(r1 + data_end)
   1. r4 = *(u32 *)(r1 + data)
   2. r3 = r4
   3. r3 += 42
   4. r1 = 0
   5. if r3 > r2 goto 8
   6. r4 += 14
   7. r1 = r4
   8. if r3 > r2 goto 10
   9. r2 = *(u8 *)(r1 + 9)
  10. r0 = 0
  11. exit

The code checks if the skb data is big enough (5) and if it is,
it prepares pointer in r1 (7), then there's again size check (8)
and finally data load from r1 (9).

It's and odd code, but apparently this is something that can
get produced by clang.

I made selftest out of it and it fails to load with:

  # test_verifier -v 267
  #267/p dead path check FAIL
  Failed to load prog 'Success'!
  0: (61) r2 = *(u32 *)(r1 +80)
  1: (61) r4 = *(u32 *)(r1 +76)
  2: (bf) r3 = r4
  3: (07) r3 += 42
  4: (b7) r1 = 0
  5: (2d) if r3 > r2 goto pc+2

  from 5 to 8: R1_w=inv0 R2_w=pkt_end(id=0,off=0,imm=0) R3_w=pkt(id=0,off=42,r=0,imm=0) R4_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
  8: (2d) if r3 > r2 goto pc+1
   R1_w=inv0 R2_w=pkt_end(id=0,off=0,imm=0) R3_w=pkt(id=0,off=42,r=42,imm=0) R4_w=pkt(id=0,off=0,r=42,imm=0) R10=fp0
  9: (69) r2 = *(u16 *)(r1 +9)
  R1 invalid mem access 'inv'
  processed 15 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0

The verifier does not seem to take into account that code can't
ever reach instruction 9 if the size check fails and r1 will be
always valid when size check succeeds.

My guess is that verifier does not have such check, but I'm still
scratching on the surface of it, so I could be totally wrong and
missing something.. before I dive in I was wondering you guys
could help me out with some insights or suggestions.

thanks,
jirka


---
 .../testing/selftests/bpf/verifier/ctx_skb.c  | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/ctx_skb.c b/tools/testing/selftests/bpf/verifier/ctx_skb.c
index 2e16b8e268f2..54578f1fb662 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_skb.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_skb.c
@@ -346,6 +346,27 @@
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_SK_SKB,
 },
+{
+	"dead path check",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,		//  0. r2 = *(u32 *)(r1 + data_end)
+		    offsetof(struct __sk_buff, data_end)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1,		//  1. r4 = *(u32 *)(r1 + data)
+		    offsetof(struct __sk_buff, data)),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_4),			//  2. r3 = r4
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 42),			//  3. r3 += 42
+	BPF_MOV64_IMM(BPF_REG_1, 0),				//  4. r1 = 0
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 2),		//  5. if r3 > r2 goto 8
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, 14),			//  6. r4 += 14
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_4),			//  7. r1 = r4
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 1),		//  8. if r3 > r2 goto 10
+	BPF_LDX_MEM(BPF_H, BPF_REG_2, BPF_REG_1, 9),		//  9. r2 = *(u8 *)(r1 + 9)
+	BPF_MOV64_IMM(BPF_REG_0, 0),				// 10. r0 = 0
+	BPF_EXIT_INSN(),					// 11. exit
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_SK_SKB,
+},
 {
 	"overlapping checks for direct packet access SK_SKB",
 	.insns = {
-- 
2.25.4

