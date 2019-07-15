Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED6B669601
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388857AbfGOONW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731050AbfGOONV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:13:21 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F2721530;
        Mon, 15 Jul 2019 14:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200000;
        bh=XlGMvA78OvGLHAOA4r8DdAmpK8qtDo6lj0Fg1/lV9zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQ7Wx9tW5pJBGiqgUCPWrbgVQORlJhhUXoR8FMGHvCf/xh03MsGqwraXesNp9IDI2
         2TcYrKjobmWgdIC3/SYxXA1BTdomN5vgb4p8nKPDQ2UxheSmyTMeXqQ9XkW40QXCn5
         kF/l5ZJ/VqhpawmGD2b59LVZ+ikg13SqQ0YRZYPU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 156/219] bpf: fix BPF_ALU32 | BPF_ARSH on BE arches
Date:   Mon, 15 Jul 2019 10:02:37 -0400
Message-Id: <20190715140341.6443-156-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiong Wang <jiong.wang@netronome.com>

[ Upstream commit 75672dda27bd00109a84cd975c17949ad9c45663 ]

Yauheni reported the following code do not work correctly on BE arches:

       ALU_ARSH_X:
               DST = (u64) (u32) ((*(s32 *) &DST) >> SRC);
               CONT;
       ALU_ARSH_K:
               DST = (u64) (u32) ((*(s32 *) &DST) >> IMM);
               CONT;

and are causing failure of test_verifier test 'arsh32 on imm 2' on BE
arches.

The code is taking address and interpreting memory directly, so is not
endianness neutral. We should instead perform standard C type casting on
the variable. A u64 to s32 conversion will drop the high 32-bit and reserve
the low 32-bit as signed integer, this is all we want.

Fixes: 2dc6b100f928 ("bpf: interpreter support BPF_ALU | BPF_ARSH")
Reported-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 06ba9c5f156b..932fd3fa5a5a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1367,10 +1367,10 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		insn++;
 		CONT;
 	ALU_ARSH_X:
-		DST = (u64) (u32) ((*(s32 *) &DST) >> SRC);
+		DST = (u64) (u32) (((s32) DST) >> SRC);
 		CONT;
 	ALU_ARSH_K:
-		DST = (u64) (u32) ((*(s32 *) &DST) >> IMM);
+		DST = (u64) (u32) (((s32) DST) >> IMM);
 		CONT;
 	ALU64_ARSH_X:
 		(*(s64 *) &DST) >>= SRC;
-- 
2.20.1

