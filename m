Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD00911940E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfLJVNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729176AbfLJVNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D04A8205C9;
        Tue, 10 Dec 2019 21:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012384;
        bh=QoJ3Syg8hUz1vs8n0YpMB+KOSVDZG36nwZBkQSVjOBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JM1XRGj/48nZgf2TFEay/oGbrPTXZUPO80Oebzd3oD8ZZ3vmsN1IobvcLjk1zFncU
         gEPJvTSYjos2SI21VdwHiPgh8iopK9VhSEou8CQob3qXL7Yj9SDTiX55+zJ6zHvimM
         Gqgcqe5a34B4sNjk0xRkLbeXoAjSqFGgS2DVyRww=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 307/350] selftests, bpf: Workaround an alu32 sub-register spilling issue
Date:   Tue, 10 Dec 2019 16:06:52 -0500
Message-Id: <20191210210735.9077-268-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 2ea2612b987ad703235c92be21d4e98ee9c2c67c ]

Currently, with latest llvm trunk, selftest test_progs failed obj
file test_seg6_loop.o with the following error in verifier:

  infinite loop detected at insn 76

The byte code sequence looks like below, and noted that alu32 has been
turned off by default for better generated codes in general:

      48:       w3 = 100
      49:       *(u32 *)(r10 - 68) = r3
      ...
  ;             if (tlv.type == SR6_TLV_PADDING) {
      76:       if w3 == 5 goto -18 <LBB0_19>
      ...
      85:       r1 = *(u32 *)(r10 - 68)
  ;     for (int i = 0; i < 100; i++) {
      86:       w1 += -1
      87:       if w1 == 0 goto +5 <LBB0_20>
      88:       *(u32 *)(r10 - 68) = r1

The main reason for verification failure is due to partial spills at
r10 - 68 for induction variable "i".

Current verifier only handles spills with 8-byte values. The above 4-byte
value spill to stack is treated to STACK_MISC and its content is not
saved. For the above example:

    w3 = 100
      R3_w=inv100 fp-64_w=inv1086626730498
    *(u32 *)(r10 - 68) = r3
      R3_w=inv100 fp-64_w=inv1086626730498
    ...
    r1 = *(u32 *)(r10 - 68)
      R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
      fp-64=inv1086626730498

To resolve this issue, verifier needs to be extended to track sub-registers
in spilling, or llvm needs to enhanced to prevent sub-register spilling
in register allocation phase. The former will increase verifier complexity
and the latter will need some llvm "hacking".

Let us workaround this issue by declaring the induction variable as "long"
type so spilling will happen at non sub-register level. We can revisit this
later if sub-register spilling causes similar or other verification issues.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20191117214036.1309510-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_seg6_loop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_seg6_loop.c b/tools/testing/selftests/bpf/progs/test_seg6_loop.c
index c4d104428643e..69880c1e7700c 100644
--- a/tools/testing/selftests/bpf/progs/test_seg6_loop.c
+++ b/tools/testing/selftests/bpf/progs/test_seg6_loop.c
@@ -132,8 +132,10 @@ static __always_inline int is_valid_tlv_boundary(struct __sk_buff *skb,
 	*pad_off = 0;
 
 	// we can only go as far as ~10 TLVs due to the BPF max stack size
+	// workaround: define induction variable "i" as "long" instead
+	// of "int" to prevent alu32 sub-register spilling.
 	#pragma clang loop unroll(disable)
-	for (int i = 0; i < 100; i++) {
+	for (long i = 0; i < 100; i++) {
 		struct sr6_tlv_t tlv;
 
 		if (cur_off == *tlv_off)
-- 
2.20.1

