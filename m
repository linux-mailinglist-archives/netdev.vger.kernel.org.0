Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9712606C7
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 00:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgIGWES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 18:04:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:60164 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgIGWES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 18:04:18 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kFPFI-0002ZX-A5; Tue, 08 Sep 2020 00:04:16 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bryce.kahle@datadoghq.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf] bpf: Fix clobbering of r2 in bpf_gen_ld_abs
Date:   Tue,  8 Sep 2020 00:04:10 +0200
Message-Id: <cace836e4d07bb63b1a53e49c5dfb238a040c298.1599512096.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25923/Mon Sep  7 15:37:02 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bryce reported that he saw the following with:

  0:  r6 = r1
  1:  r1 = 12
  2:  r0 = *(u16 *)skb[r1]

The xlated sequence was incorrectly clobbering r2 with pointer
value of r6 ...

  0: (bf) r6 = r1
  1: (b7) r1 = 12
  2: (bf) r1 = r6
  3: (bf) r2 = r1
  4: (85) call bpf_skb_load_helper_16_no_cache#7692160

... and hence call to the load helper never succeeded given the
offset was too high. Fix it by reordering the load of r6 to r1.

Other than that the insn has similar calling convention than BPF
helpers, that is, r0 - r5 are scratch regs, so nothing else
affected after the insn.

Fixes: e0cea7ce988c ("bpf: implement ld_abs/ld_ind in native bpf")
Reported-by: Bryce Kahle <bryce.kahle@datadoghq.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index b2df52086445..2d62c25e0395 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7065,8 +7065,6 @@ static int bpf_gen_ld_abs(const struct bpf_insn *orig,
 	bool indirect = BPF_MODE(orig->code) == BPF_IND;
 	struct bpf_insn *insn = insn_buf;
 
-	/* We're guaranteed here that CTX is in R6. */
-	*insn++ = BPF_MOV64_REG(BPF_REG_1, BPF_REG_CTX);
 	if (!indirect) {
 		*insn++ = BPF_MOV64_IMM(BPF_REG_2, orig->imm);
 	} else {
@@ -7074,6 +7072,8 @@ static int bpf_gen_ld_abs(const struct bpf_insn *orig,
 		if (orig->imm)
 			*insn++ = BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, orig->imm);
 	}
+	/* We're guaranteed here that CTX is in R6. */
+	*insn++ = BPF_MOV64_REG(BPF_REG_1, BPF_REG_CTX);
 
 	switch (BPF_SIZE(orig->code)) {
 	case BPF_B:
-- 
2.21.0

