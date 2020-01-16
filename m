Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8752713F95C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437603AbgAPTYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729546AbgAPQwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86B8622522;
        Thu, 16 Jan 2020 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193567;
        bh=oVEpUpIzVKUCnt2/4jdogUGDwyi7Ehjqtc97o16UCeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZREzzWsnHLYydb4OlYFa7rBCaondM2Om07Mf9ggfNavhHDyYDQOKdvPFsyzsibyP
         ZeZuqL3il8TuzU1Errx1kJr00YT5GdWGxmtHnyZgmwWGAgUZB38WoYtgFFksi5BMx7
         VxrsXyFseq/uGd3o+eLOQqtk18q+hy8wk4gQDuvM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 111/205] libbpf: Fix memory leak/double free issue
Date:   Thu, 16 Jan 2020 11:41:26 -0500
Message-Id: <20200116164300.6705-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 3dc5e059821376974177cc801d377e3fcdac6712 ]

Coverity scan against Github libbpf code found the issue of not freeing memory and
leaving already freed memory still referenced from bpf_program. Fix it by
re-assigning successfully reallocated memory sooner.

Fixes: 2993e0515bb4 ("tools/bpf: add support to read .BTF.ext sections")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191107020855.3834758-2-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a267cd0c0ce2..d98838c5820c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3220,6 +3220,7 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 			pr_warning("oom in prog realloc\n");
 			return -ENOMEM;
 		}
+		prog->insns = new_insn;
 
 		if (obj->btf_ext) {
 			err = bpf_program_reloc_btf_ext(prog, obj,
@@ -3231,7 +3232,6 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 
 		memcpy(new_insn + prog->insns_cnt, text->insns,
 		       text->insns_cnt * sizeof(*insn));
-		prog->insns = new_insn;
 		prog->main_prog_cnt = prog->insns_cnt;
 		prog->insns_cnt = new_cnt;
 		pr_debug("added %zd insn from %s to prog %s\n",
-- 
2.20.1

