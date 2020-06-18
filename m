Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E161FE5AE
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgFRBQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729582AbgFRBQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6DA121D90;
        Thu, 18 Jun 2020 01:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442988;
        bh=oPsEYan8BzCNcN2rrolhf41sx7V3EaoYnpGBm9uEYJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOQbH3tBuZG1yhlspRf2NDKrSrUHw8O95SORBxX+H+0AMyrZIj7gvvmXYVaur27Af
         Qr2L/nIFnx3oQdpNH+/rEgTeOO9Z/xAMocZtB84UjD3RDPzi/5Im8uoV/xNsjVfK4/
         I6Dod/OahhMPsP7UQTkbp8vVQ8pcidyuU9TSYuzA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 388/388] bpf: Undo internal BPF_PROBE_MEM in BPF insns dump
Date:   Wed, 17 Jun 2020 21:08:05 -0400
Message-Id: <20200618010805.600873-388-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 29fcb05bbf1a7008900bb9bee347bdbfc7171036 ]

BPF_PROBE_MEM is kernel-internal implmementation details. When dumping BPF
instructions to user-space, it needs to be replaced back with BPF_MEM mode.

Fixes: 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200613002115.1632142-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e6dee19a668..5d1d24f56d53 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2923,6 +2923,7 @@ static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog)
 	struct bpf_insn *insns;
 	u32 off, type;
 	u64 imm;
+	u8 code;
 	int i;
 
 	insns = kmemdup(prog->insnsi, bpf_prog_insn_size(prog),
@@ -2931,21 +2932,27 @@ static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog)
 		return insns;
 
 	for (i = 0; i < prog->len; i++) {
-		if (insns[i].code == (BPF_JMP | BPF_TAIL_CALL)) {
+		code = insns[i].code;
+
+		if (code == (BPF_JMP | BPF_TAIL_CALL)) {
 			insns[i].code = BPF_JMP | BPF_CALL;
 			insns[i].imm = BPF_FUNC_tail_call;
 			/* fall-through */
 		}
-		if (insns[i].code == (BPF_JMP | BPF_CALL) ||
-		    insns[i].code == (BPF_JMP | BPF_CALL_ARGS)) {
-			if (insns[i].code == (BPF_JMP | BPF_CALL_ARGS))
+		if (code == (BPF_JMP | BPF_CALL) ||
+		    code == (BPF_JMP | BPF_CALL_ARGS)) {
+			if (code == (BPF_JMP | BPF_CALL_ARGS))
 				insns[i].code = BPF_JMP | BPF_CALL;
 			if (!bpf_dump_raw_ok())
 				insns[i].imm = 0;
 			continue;
 		}
+		if (BPF_CLASS(code) == BPF_LDX && BPF_MODE(code) == BPF_PROBE_MEM) {
+			insns[i].code = BPF_LDX | BPF_SIZE(code) | BPF_MEM;
+			continue;
+		}
 
-		if (insns[i].code != (BPF_LD | BPF_IMM | BPF_DW))
+		if (code != (BPF_LD | BPF_IMM | BPF_DW))
 			continue;
 
 		imm = ((u64)insns[i + 1].imm << 32) | (u32)insns[i].imm;
-- 
2.25.1

