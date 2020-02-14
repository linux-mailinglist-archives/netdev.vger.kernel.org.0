Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B35E15EE62
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389918AbgBNQEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389907AbgBNQEV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB952222C2;
        Fri, 14 Feb 2020 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696261;
        bh=IMCcHLqqHFw5wnRqiar7HehcGSTaDbVtwD0fhhQgh8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEdEKTdE+0rrCOFoo6wRzldpAgafBu9Md9vnIaPR6p1bCb3kKJ6QUmr0beOthCoPN
         Gkpm0G1gvu8awn4JxAU2G/MG+m2hHjSUrsBAeryyr27kXFu/OIwEmBv9OlHZJ0S0wn
         Rwcy8PGWe1iJbPXdIS4oT1HWmil7mKBVGCGTwbRc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin@isovalent.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 114/459] bpftool: Don't crash on missing xlated program instructions
Date:   Fri, 14 Feb 2020 10:56:04 -0500
Message-Id: <20200214160149.11681-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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

[ Upstream commit d95f1e8b462c4372ac409886070bb8719d8a4d3a ]

Turns out the xlated program instructions can also be missing if
kptr_restrict sysctl is set. This means that the previous fix to check the
jited_prog_insns pointer was insufficient; add another check of the
xlated_prog_insns pointer as well.

Fixes: 5b79bcdf0362 ("bpftool: Don't crash on missing jited insns or ksyms")
Fixes: cae73f233923 ("bpftool: use bpf_program__get_prog_info_linear() in prog.c:do_dump()")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20200206102906.112551-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index ea0bcd58bcb9a..2e388421c32f4 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -500,7 +500,7 @@ static int do_dump(int argc, char **argv)
 		buf = (unsigned char *)(info->jited_prog_insns);
 		member_len = info->jited_prog_len;
 	} else {	/* DUMP_XLATED */
-		if (info->xlated_prog_len == 0) {
+		if (info->xlated_prog_len == 0 || !info->xlated_prog_insns) {
 			p_err("error retrieving insn dump: kernel.kptr_restrict set?");
 			goto err_free;
 		}
-- 
2.20.1

