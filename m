Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E75E345213
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhCVVwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhCVVwG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8077B6191D;
        Mon, 22 Mar 2021 21:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616449926;
        bh=cynxWr4EIlyILN7JP7FRcyb1BaVwBjk2hMRHLfYM1x4=;
        h=From:To:Cc:Subject:Date:From;
        b=knQg1MTNIgrJ8FsQd53FmeWH1omD0zye6GeyRCGMavRNlOUYuAdhq3s7v5aNhcFYa
         LvdmT4vQ0Y4nRUgGlSbX3kT0744onMLv0ciZU9IUhPUAVVLaF2ZCnUXNXp976PNmWO
         /gvnbBAFvR9aQ0qGQKg03Cucq3YIAgOAJERJ1QAjedMGZGTbY7Anoy7syocsubSdwB
         mdMw+0vrLV1xLv8FrB41IFfHnqEliVwvyVt5oxP6gR0iDPmu2dBXheyRnhX1BNju/o
         5fqM/U0RAuMeaYt28HrP9yFoy1rXuInmzhVkHzVq7cshq+ZfxkoSylOYabrZsNPVe8
         1Lijx8ljY7BLA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     KP Singh <kpsingh@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Florent Revest <revest@chromium.org>,
        Brendan Jackman <jackmanb@chromium.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Mikko Ylinen <mikko.ylinen@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: avoid old-style declaration warnings
Date:   Mon, 22 Mar 2021 22:51:51 +0100
Message-Id: <20210322215201.1097281-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc -Wextra wants type modifiers in the normal order:

kernel/bpf/bpf_lsm.c:70:1: error: 'static' is not at beginning of declaration [-Werror=old-style-declaration]
   70 | const static struct bpf_func_proto bpf_bprm_opts_set_proto = {
      | ^~~~~
kernel/bpf/bpf_lsm.c:91:1: error: 'static' is not at beginning of declaration [-Werror=old-style-declaration]
   91 | const static struct bpf_func_proto bpf_ima_inode_hash_proto = {
      | ^~~~~

Fixes: 3f6719c7b62f ("bpf: Add bpf_bprm_opts_set helper")
Fixes: 27672f0d280a ("bpf: Add a BPF helper for getting the IMA hash of an inode")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/bpf/bpf_lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 1622a44d1617..75b1c678d558 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -67,7 +67,7 @@ BPF_CALL_2(bpf_bprm_opts_set, struct linux_binprm *, bprm, u64, flags)
 
 BTF_ID_LIST_SINGLE(bpf_bprm_opts_set_btf_ids, struct, linux_binprm)
 
-const static struct bpf_func_proto bpf_bprm_opts_set_proto = {
+static const struct bpf_func_proto bpf_bprm_opts_set_proto = {
 	.func		= bpf_bprm_opts_set,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
@@ -88,7 +88,7 @@ static bool bpf_ima_inode_hash_allowed(const struct bpf_prog *prog)
 
 BTF_ID_LIST_SINGLE(bpf_ima_inode_hash_btf_ids, struct, inode)
 
-const static struct bpf_func_proto bpf_ima_inode_hash_proto = {
+static const struct bpf_func_proto bpf_ima_inode_hash_proto = {
 	.func		= bpf_ima_inode_hash,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-- 
2.29.2

