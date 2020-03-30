Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4541986B1
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgC3Vig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:38:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39389 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgC3Vig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:38:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id g32so3263526pgb.6;
        Mon, 30 Mar 2020 14:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=IOrtFKWmv/Uzt1+LiE+7hXIl699RIo+MD4c9FrDwaiw=;
        b=kOoprM7XT/aqKYWdHEOTr/65yROWA9x+r6vM5WF1U6kEFmZkjoAn6UZdeSkEinonnt
         0IW582PyLMschzIVhgmIAr9tcR30foGg1oLtH4WoKD4Y5bvwSNsqclaldenxiX4LCc0z
         MA800aKGF9oJmFj7VdvIKlPwkxsEyyXxvGp6+OF5CNwXr7DOQDRR6So4CS34Tvthm/wl
         qpWse4Crm92i5LmmxMMQWj9Cglm22LgEbPHgikYfTPqpr75oqAEVTLrKCk0ng+RjL0Hy
         PEK6zcClvxRHd78LYmN+I56wUcMsTkbhP98+V6lgfTvHgmHAGDjylzxqJwEUN82YtIjq
         RICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IOrtFKWmv/Uzt1+LiE+7hXIl699RIo+MD4c9FrDwaiw=;
        b=EBykJGJ6dzolt15eU5i3OwVEaJC6/rIOM7BmSSQB2j7MtHZbWDbvmZQm7hVLSWHwGM
         MpxWV6TuZYQcraXDbnfEI+paK/ZC0j+awpPBwB1Gs3zNlIhTw3AThOQ6jLjSHaFGMUbx
         CXXstgXT81L0CIPSF1lFlBn+2ODNtJS1GslMBS9jmW7LTIh/If+XXC2dsQectGQFNmNm
         z+CtEqHPd9sTGuCpqIDxTcopCJClMNMOsQ33FShtp42PEags6Et03STBmDiXHkNwOsXu
         GJLF28elhLC8e6pWVsSj94c5mXurev5chFX4Rz5rTtzG2B0T4IJiV1Y+mWlTTLM0rkfw
         TUzw==
X-Gm-Message-State: ANhLgQ2OTb4c/Zu+yoW2bAOyChK7qi5gQVrp14uno5hNJbz4p643OOPU
        s9LvdWSBn4f5rAJaxiC16BSsyetDh7s=
X-Google-Smtp-Source: ADFU+vuyEMxW6waGVv2oCOfXnsKPgf/5Qyf/FBVjtOTgCDPXadNlB9k4TIoJnnBZaPUsgj81N2U8Gg==
X-Received: by 2002:a63:4282:: with SMTP id p124mr15200535pga.59.1585604314901;
        Mon, 30 Mar 2020 14:38:34 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o33sm408665pje.19.2020.03.30.14.38.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2020 14:38:34 -0700 (PDT)
Subject: [bpf-next PATCH v2 7/7] bpf: test_verifier,
 add alu32 bounds tracking tests
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 30 Mar 2020 14:38:21 -0700
Message-ID: <158560430155.10843.514209255758200922.stgit@john-Precision-5820-Tower>
In-Reply-To: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
References: <158560409224.10843.3588655801186916301.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Its possible to have divergent ALU32 and ALU64 bounds when using JMP32
instructins and ALU64 arithmatic operations. Sometimes the clang will
even generate this code. Because the case is a bit tricky lets add
a specific test for it.

Here is  pseudocode asm version to illustrate the idea,

 1 r0 = 0xffffffff00000001;
 2 if w0 > 1 goto %l[fail];
 3 r0 += 1
 5 if w0 > 2 goto %l[fail]
 6 exit

The intent here is the verifier will fail the load if the 32bit bounds
are not tracked correctly through ALU64 op. Similarly we can check the
64bit bounds are correctly zero extended after ALU32 ops.

 1 r0 = 0xffffffff00000001;
 2 w0 += 1
 2 if r0 > 3 goto %l[fail];
 6 exit

The above will fail if we do not correctly zero extend 64bit bounds
after 32bit op.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/verifier/bounds.c |   39 +++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index cf72fcc..4d0d095 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -500,3 +500,42 @@
 	.errstr = "map_value pointer and 1000000000000",
 	.result = REJECT
 },
+{
+	"bounds check mixed 32bit and 64bit arithmatic. test1",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_1, -1),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_1, 32),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	/* r1 = 0xffffFFFF00000001 */
+	BPF_JMP32_IMM(BPF_JGT, BPF_REG_1, 1, 3),
+	/* check ALU64 op keeps 32bit bounds */
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	BPF_JMP32_IMM(BPF_JGT, BPF_REG_1, 2, 1),
+	BPF_JMP_A(1),
+	/* invalid ldx if bounds are lost above */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT
+},
+{
+	"bounds check mixed 32bit and 64bit arithmatic. test2",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_1, -1),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_1, 32),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+	/* r1 = 0xffffFFFF00000001 */
+	BPF_MOV64_IMM(BPF_REG_2, 3),
+	/* r1 = 0x2 */
+	BPF_ALU32_IMM(BPF_ADD, BPF_REG_1, 1),
+	/* check ALU32 op zero extends 64bit bounds */
+	BPF_JMP_REG(BPF_JGT, BPF_REG_1, BPF_REG_2, 1),
+	BPF_JMP_A(1),
+	/* invalid ldx if bounds are lost above */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, -1),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT
+},

