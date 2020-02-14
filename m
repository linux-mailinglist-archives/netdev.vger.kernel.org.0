Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F407715F2F4
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgBNPvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730858AbgBNPvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1201624681;
        Fri, 14 Feb 2020 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695507;
        bh=oW9af36Ad6Dfo5IY6x/pAj7mJ6EGZgnbtxwOT8Tddp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G52C9nVqbboZ1vFxUiIfQ/M8N8MwsDbDYuk+g+142uLmCoNFf05i3fKyUNenP6cA0
         h1iD55qPv4Q2l1xe8GBphgZQuh3GlLYHvnN0vSxknSe1VI4/ZElV+kxm1ZTWa3aFuW
         2XRBVtlnJ4AxQNvyI0rZ4HUOVGiG0/1FfJxuoTa0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin@isovalent.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 133/542] bpftool: Don't crash on missing xlated program instructions
Date:   Fri, 14 Feb 2020 10:42:05 -0500
Message-Id: <20200214154854.6746-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
index 2ce9c5ba19347..9288be1d6bf0e 100644
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

