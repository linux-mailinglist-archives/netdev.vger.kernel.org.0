Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E60DF575EA
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfF0Adp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfF0Ado (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:44 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6958920659;
        Thu, 27 Jun 2019 00:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595623;
        bh=u7QqRGXpxqS0z/U4t34C5o/WpIMl8knMCDPRxkx9ZnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuIhrrDhKrhvBMdUlDwTFrfTuJUtFCbJaT/owYhWBkCRYMWa0Fgn3VjdyJwPwnr1Z
         cMypKIBppnSSf1bD4WH6skh+yId7hiV4yOH7T+OqTnILJSyg6sjNhyd0eGuNicuHER
         sQrguyCOZczAw5D1kxV+mipisuR7J1okc7uTm99I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 58/95] bpf: fix div64 overflow tests to properly detect errors
Date:   Wed, 26 Jun 2019 20:29:43 -0400
Message-Id: <20190627003021.19867-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 3e0682695199bad51dd898fe064d1564637ff77a ]

If the result of the division is LLONG_MIN, current tests do not detect
the error since the return value is truncated to a 32-bit value and ends
up being 0.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/verifier/div_overflow.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/div_overflow.c b/tools/testing/selftests/bpf/verifier/div_overflow.c
index bd3f38dbe796..acab4f00819f 100644
--- a/tools/testing/selftests/bpf/verifier/div_overflow.c
+++ b/tools/testing/selftests/bpf/verifier/div_overflow.c
@@ -29,8 +29,11 @@
 	"DIV64 overflow, check 1",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_1, -1),
-	BPF_LD_IMM64(BPF_REG_0, LLONG_MIN),
-	BPF_ALU64_REG(BPF_DIV, BPF_REG_0, BPF_REG_1),
+	BPF_LD_IMM64(BPF_REG_2, LLONG_MIN),
+	BPF_ALU64_REG(BPF_DIV, BPF_REG_2, BPF_REG_1),
+	BPF_MOV32_IMM(BPF_REG_0, 0),
+	BPF_JMP_REG(BPF_JEQ, BPF_REG_0, BPF_REG_2, 1),
+	BPF_MOV32_IMM(BPF_REG_0, 1),
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
@@ -40,8 +43,11 @@
 {
 	"DIV64 overflow, check 2",
 	.insns = {
-	BPF_LD_IMM64(BPF_REG_0, LLONG_MIN),
-	BPF_ALU64_IMM(BPF_DIV, BPF_REG_0, -1),
+	BPF_LD_IMM64(BPF_REG_1, LLONG_MIN),
+	BPF_ALU64_IMM(BPF_DIV, BPF_REG_1, -1),
+	BPF_MOV32_IMM(BPF_REG_0, 0),
+	BPF_JMP_REG(BPF_JEQ, BPF_REG_0, BPF_REG_1, 1),
+	BPF_MOV32_IMM(BPF_REG_0, 1),
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
-- 
2.20.1

