Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156B81917E0
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCXRlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:41:10 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40278 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbgCXRlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:41:09 -0400
Received: by mail-pj1-f67.google.com with SMTP id kx8so1782219pjb.5;
        Tue, 24 Mar 2020 10:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=XNz9FH5HC8ImgQMfIWgmBrFrsXj+TO5qFp24rW1/wJ8=;
        b=RLnajeYDL4s/3YF0VRj3QEi7p2TZ+Lw6UcSsEJp6KKqRMXue1hLbmg/tRSXfwauPlp
         IpGC2xMkXp7LrRg4Ya0sXUrLu2C1bzDmVVyC2TGkUi5YHjUmi9DzGNiI4AcdkdqMev8n
         a6Bq/JS+H85xiieRayxIxy6+YGetphDIGv+U6rH1nkSaduZY1t2pRi7tH2nTy1AO5pou
         e/lqqcIls93uEba3EMgCajzZw2nYgWK/qQ1WRCKi5UWMPbhUSXbpnh8a95k3eRdWZnNU
         M6u2oYCpdAwE8tsm/NKMFcJ3UrxHOto00nB2kWDEkY6MF7q57xxQBB59PB7TyERPV+z4
         Hn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XNz9FH5HC8ImgQMfIWgmBrFrsXj+TO5qFp24rW1/wJ8=;
        b=cYCEb9eGYneN/rHPg3af6uS+kdvT5AXtbZ0lvI5QJER7uPukLucD/uJ9shp8I5CNDj
         g9PmZMon7L7olr3jCW4fA1Tpqn3u1AAt8XTOje/kD0CpclFD+00wQKWzyLZU8MohqXz+
         +OiWKcErG0Gz9sHPMLKb8mxDBeiy0HmTsn5g1KtheIsHyaoBjPejy4b018bLN9v13UFG
         JBnmLmGFn2Nhtl1GeZnB9/Z352IjDZR45XcASkU5y9Qj1LWefky6oYgr5HowoUvgk86h
         y9oP3tzaDxeeoyYozGeo8Eb/tvAS4sjE8hOsxTdDJDicpRFyyF2A82KLZ7cDPWXOLLZd
         1wmg==
X-Gm-Message-State: ANhLgQ2XrpJ8WifNtaZkqbUe9wjWhqc6u2EJuBDNBoktJM2b2EQ56D7X
        GjZCNqANrv10LcKPgsMtwS4=
X-Google-Smtp-Source: ADFU+vueu294sxmVjcNRtnyuHO91+NAfTU5qVEwtBE+gidB2zRBrftiv0fPf/1dPC8KMLXjatsglqQ==
X-Received: by 2002:a17:90a:26e1:: with SMTP id m88mr6814517pje.60.1585071668795;
        Tue, 24 Mar 2020 10:41:08 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id na18sm3055206pjb.31.2020.03.24.10.41.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:41:08 -0700 (PDT)
Subject: [bpf-next PATCH 10/10] bpf: test_verifier,
 add alu32 bounds tracking tests
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:40:55 -0700
Message-ID: <158507165554.15666.6019652542965367828.stgit@john-Precision-5820-Tower>
In-Reply-To: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
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
 2 if r0 < 0xffffffff00000001 goto %l[fail];
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

