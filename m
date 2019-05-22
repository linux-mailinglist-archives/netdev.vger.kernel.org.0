Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E4426068
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 11:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfEVJXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 05:23:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36152 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbfEVJXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 05:23:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so1024088pgb.3;
        Wed, 22 May 2019 02:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N/1KBPT1+OjeRtVqyUS/9NJB0EJipW28c5JPC8vqkRE=;
        b=S3CERENoilx4F5W4DmH+S/6jVnY0dHoTXovTtyvSi+2cwL1QHW/3WuXgXtykvCSnH8
         02USGmwl2/ZD62kdrc7qiWbS65aR21b8nZ3EWdguG4y2pNJwXzR4hrg7b8XpfiG7VL6F
         7sM4XXaU/AMhAeXMlooiqKyebPUZ7S7I5Bc9guqv/7O9GLpYu4eB4xcSc+gTmfk7EJQy
         88P+FdVwFay5dwsngX4BIS2tEHYid68SdE1iTHsQ/Y7cUWpzQeRUB3SsSe4PN9YBgm9a
         zRtGaxKhNzrOzHxQIdwE4OQ4bP+Dv53yl3BQuaNuY7tOmuXEPEFAVoAddi63ysE7b+bs
         GSnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N/1KBPT1+OjeRtVqyUS/9NJB0EJipW28c5JPC8vqkRE=;
        b=SIfhhSNSorzlvwgW7e9Z3bT7kNHlcDRMpu46T5uHucVwi1yIEMlPY7/Q2rQwMlkSL+
         CkjjYlHYM5BmyPK7w6o3KazRj1JWH2rA7Ebv8BbEtfGMdi+XNM6fLuKCzAqz+IAx77uD
         whm5tLfmkg2wWW1fK4LJj0YIPPym/IyO5u/5IT8olu+by9a0a0DPRjb7gwqwisqkAS3y
         thaAlO0wHIJuAoFf+ogUuf7lxSh6YuH53s+oqpud2mI7fjGXcrGeWdIE8pNJmEuo7waH
         wgGpcK4A4bTZe/9N2y02qqdZ7mo2+dIn66+iLKxJBwQjKvduu/J4jYewrDFpLtpGyF98
         v2Aw==
X-Gm-Message-State: APjAAAXrq1t0Dpa/Yo2omj+GecwXBChc6k6wrCCASghoptUXemm/Jzg7
        a2zk6nte74j94l7bQGpLpgU=
X-Google-Smtp-Source: APXvYqxPQZYenu6bB6IN/w4n7LBSZKAX/2nlTet3oAAr2dQ83jXLXB3Idqwrnax/0PsLo6w7rjgudA==
X-Received: by 2002:a63:c64a:: with SMTP id x10mr88295161pgg.195.1558517018622;
        Wed, 22 May 2019 02:23:38 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (jfdmzpr05-ext.jf.intel.com. [134.134.139.74])
        by smtp.gmail.com with ESMTPSA id z4sm28795200pfa.142.2019.05.22.02.23.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 02:23:38 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org
Subject: [PATCH bpf] selftests: bpf: add zero extend checks for ALU32 and/or/xor
Date:   Wed, 22 May 2019 11:23:23 +0200
Message-Id: <20190522092323.17435-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add three tests to test_verifier/basic_instr that make sure that the
high 32-bits of the destination register is cleared after an ALU32
and/or/xor.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 .../selftests/bpf/verifier/basic_instr.c      | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/basic_instr.c b/tools/testing/selftests/bpf/verifier/basic_instr.c
index ed91a7b9a456..4d844089938e 100644
--- a/tools/testing/selftests/bpf/verifier/basic_instr.c
+++ b/tools/testing/selftests/bpf/verifier/basic_instr.c
@@ -132,3 +132,42 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = ACCEPT,
 },
+{
+	"and32 reg zero extend check",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, -1),
+	BPF_MOV64_IMM(BPF_REG_2, -2),
+	BPF_ALU32_REG(BPF_AND, BPF_REG_0, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"or32 reg zero extend check",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, -1),
+	BPF_MOV64_IMM(BPF_REG_2, -2),
+	BPF_ALU32_REG(BPF_OR, BPF_REG_0, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+	.retval = 0,
+},
+{
+	"xor32 reg zero extend check",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, -1),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_ALU32_REG(BPF_XOR, BPF_REG_0, BPF_REG_2),
+	BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+	.retval = 0,
+},
-- 
2.20.1

