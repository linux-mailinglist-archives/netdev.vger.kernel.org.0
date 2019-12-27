Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E723612B858
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfL0Ryy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:54:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbfL0Rm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6107A21744;
        Fri, 27 Dec 2019 17:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468545;
        bh=y5ZUJdBGvEd9wU+ozgECUMyVdZfnmtAjppTvIhvO/fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3fBpGf/2fvLXZ6lFd48wzNgOWP2KFDcOCLe3iFdP2OxblvqmLbtZlm1Mj7cRaQNn
         vSLmJR+SieoMMUa8E7r5x+TQOMaXMVBHKjoQwxIwuYcTAiWrWsam6T1axll6ebGv+h
         0++XeoIjqkJu/FXXX49nfzY1LXe/5CYqfNAnSDZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 073/187] bpftool: Don't crash on missing jited insns or ksyms
Date:   Fri, 27 Dec 2019 12:39:01 -0500
Message-Id: <20191227174055.4923-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 5b79bcdf03628a3a9ee04d9cd5fabcf61a8e20be ]

When the kptr_restrict sysctl is set, the kernel can fail to return
jited_ksyms or jited_prog_insns, but still have positive values in
nr_jited_ksyms and jited_prog_len. This causes bpftool to crash when
trying to dump the program because it only checks the len fields not
the actual pointers to the instructions and ksyms.

Fix this by adding the missing checks.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Fixes: f84192ee00b7 ("tools: bpftool: resolve calls without using imm field")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20191210181412.151226-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c          | 2 +-
 tools/bpf/bpftool/xlated_dumper.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 43fdbbfe41bb..ea0bcd58bcb9 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -493,7 +493,7 @@ static int do_dump(int argc, char **argv)
 
 	info = &info_linear->info;
 	if (mode == DUMP_JITED) {
-		if (info->jited_prog_len == 0) {
+		if (info->jited_prog_len == 0 || !info->jited_prog_insns) {
 			p_info("no instructions returned");
 			goto err_free;
 		}
diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated_dumper.c
index 494d7ae3614d..5b91ee65a080 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -174,7 +174,7 @@ static const char *print_call(void *private_data,
 	struct kernel_sym *sym;
 
 	if (insn->src_reg == BPF_PSEUDO_CALL &&
-	    (__u32) insn->imm < dd->nr_jited_ksyms)
+	    (__u32) insn->imm < dd->nr_jited_ksyms && dd->jited_ksyms)
 		address = dd->jited_ksyms[insn->imm];
 
 	sym = kernel_syms_search(dd, address);
-- 
2.20.1

