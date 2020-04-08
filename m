Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87211A2845
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 20:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgDHSMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 14:12:55 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46370 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729409AbgDHSMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 14:12:55 -0400
Received: by mail-pg1-f196.google.com with SMTP id k191so3658430pgc.13
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 11:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id;
        bh=E+fjfxRHSsIlS4yIOdyfHZC/ljktt0WCvaJtbmUNwoo=;
        b=Ism6ahYTJhW5k4WOAc7eXKD5UlKcHFqYuDe3MLavAJ8laJI05WhzzBXuq3wURZERbG
         ul6sGaYkLMeDnLYGKyM3tPBIg90jOSNbsNSlyKCGeRshZHc545Qnic2cQONOr4K8jg7e
         u8MZg2nGjhcSxqlULmBlhNu+bhmVu5bQnCBoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E+fjfxRHSsIlS4yIOdyfHZC/ljktt0WCvaJtbmUNwoo=;
        b=e6H/ojfxp0ByBgFqn2j6k39KfINbx08AwiY00x/QS9bpK5u9AiBs4c6nGOFVJyPrMM
         JxrWggQnXWck3WrzIMmhIFzyIGX5zNgxAJrlWY6jAE+8QW9S7Knnrhple1QsGJuIbSBZ
         RnVcgFK2tC+rObKsILGDqi/518C2XMmGMpLS5gaS9XYOdKMBnkGjyagGxzRVcugfe934
         YEQGl6bmDfqkMhX44pMudSlzz3SvWj/ZhodmDaFJvBneoBL4FOa7w4g4HM6Rfo+DNiT+
         v1P5V82+OZOiEjfGDwQ+eUSLWNLL4k/hJjs5iVdTEans4AkWNt0AunpYKXAg08dTfhj4
         Jtqg==
X-Gm-Message-State: AGi0PubK4f9ClXiowMlPlFqysAq3IkKnLCjosew9E42N+qBa8I8pmLsq
        M+FAZAT0TgqvEz+X4Pz4q1L8PQ==
X-Google-Smtp-Source: APiQypKU16iVofstluSj0s0+NWi5Ig6G1hkZ3yqoxw816RcFYad9JRg8OlR8yQQ5aFZjb5WEC2rGtg==
X-Received: by 2002:a63:770d:: with SMTP id s13mr8197474pgc.5.1586369573527;
        Wed, 08 Apr 2020 11:12:53 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id y9sm17706525pfo.135.2020.04.08.11.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 11:12:51 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf] arm: bpf: Fix bugs with ALU64 {RSH, ARSH} BPF_K shift by 0
Date:   Wed,  8 Apr 2020 18:12:29 +0000
Message-Id: <20200408181229.10909-1-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current arm BPF JIT does not correctly compile RSH or ARSH when the
immediate shift amount is 0. This causes the "rsh64 by 0 imm" and "arsh64
by 0 imm" BPF selftests to hang the kernel by reaching an instruction
the verifier determines to be unreachable.

The root cause is in how immediate right shifts are encoded on arm.
For LSR and ASR (logical and arithmetic right shift), a bit-pattern
of 00000 in the immediate encodes a shift amount of 32. When the BPF
immediate is 0, the generated code shifts by 32 instead of the expected
behavior (a no-op).

This patch fixes the bugs by adding an additional check if the BPF
immediate is 0. After the change, the above mentioned BPF selftests pass.

Fixes: 39c13c204bb11 ("arm: eBPF JIT compiler")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/arm/net/bpf_jit_32.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index cc29869d12a3..d124f78e20ac 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -929,7 +929,11 @@ static inline void emit_a32_rsh_i64(const s8 dst[],
 	rd = arm_bpf_get_reg64(dst, tmp, ctx);
 
 	/* Do LSR operation */
-	if (val < 32) {
+	if (val == 0) {
+		/* An immediate value of 0 encodes a shift amount of 32
+		 * for LSR. To shift by 0, don't do anything.
+		 */
+	} else if (val < 32) {
 		emit(ARM_MOV_SI(tmp2[1], rd[1], SRTYPE_LSR, val), ctx);
 		emit(ARM_ORR_SI(rd[1], tmp2[1], rd[0], SRTYPE_ASL, 32 - val), ctx);
 		emit(ARM_MOV_SI(rd[0], rd[0], SRTYPE_LSR, val), ctx);
@@ -955,7 +959,11 @@ static inline void emit_a32_arsh_i64(const s8 dst[],
 	rd = arm_bpf_get_reg64(dst, tmp, ctx);
 
 	/* Do ARSH operation */
-	if (val < 32) {
+	if (val == 0) {
+		/* An immediate value of 0 encodes a shift amount of 32
+		 * for ASR. To shift by 0, don't do anything.
+		 */
+	} else if (val < 32) {
 		emit(ARM_MOV_SI(tmp2[1], rd[1], SRTYPE_LSR, val), ctx);
 		emit(ARM_ORR_SI(rd[1], tmp2[1], rd[0], SRTYPE_ASL, 32 - val), ctx);
 		emit(ARM_MOV_SI(rd[0], rd[0], SRTYPE_ASR, val), ctx);
-- 
2.17.1

