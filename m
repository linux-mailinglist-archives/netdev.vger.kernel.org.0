Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CD7A25F9
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfH2SNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfH2SNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35F7C22CF5;
        Thu, 29 Aug 2019 18:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102395;
        bh=qx5FyH+qCOmLk8ayVVq6fVEn6qvhREhtmNVzQ1RfpQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BfqQvxBlOilp5K2g5vfuPX/dhEroln8AUEaIQBbieGHYBWiCoiw77sDD1BUpCiS6
         2KvoFLo8qPO2UPNZDnw4Q43vuwcjDitoHN5vWO4yYN7Cq4Km5Mz9hpPUGm65dLC4pd
         KLGZgP4lLg5SJIFf/w0PCDJan8ndq1ruoGWUoSiM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 02/76] libbpf: fix erroneous multi-closing of BTF FD
Date:   Thu, 29 Aug 2019 14:11:57 -0400
Message-Id: <20190829181311.7562-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 5d01ab7bac467edfc530e6ccf953921def935c62 ]

Libbpf stores associated BTF FD per each instance of bpf_program. When
program is unloaded, that FD is closed. This is wrong, because leads to
a race and possibly closing of unrelated files, if application
simultaneously opens new files while bpf_programs are unloaded.

It's also unnecessary, because struct btf "owns" that FD, and
btf__free(), called from bpf_object__close() will close it. Thus the fix
is to never have per-program BTF FD and fetch it from obj->btf, when
necessary.

Fixes: 2993e0515bb4 ("tools/bpf: add support to read .BTF.ext sections")
Reported-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3865a5d272514..e308fcf16cdd0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -178,7 +178,6 @@ struct bpf_program {
 	bpf_program_clear_priv_t clear_priv;
 
 	enum bpf_attach_type expected_attach_type;
-	int btf_fd;
 	void *func_info;
 	__u32 func_info_rec_size;
 	__u32 func_info_cnt;
@@ -305,7 +304,6 @@ void bpf_program__unload(struct bpf_program *prog)
 	prog->instances.nr = -1;
 	zfree(&prog->instances.fds);
 
-	zclose(prog->btf_fd);
 	zfree(&prog->func_info);
 	zfree(&prog->line_info);
 }
@@ -382,7 +380,6 @@ bpf_program__init(void *data, size_t size, char *section_name, int idx,
 	prog->instances.fds = NULL;
 	prog->instances.nr = -1;
 	prog->type = BPF_PROG_TYPE_UNSPEC;
-	prog->btf_fd = -1;
 
 	return 0;
 errout:
@@ -1883,9 +1880,6 @@ bpf_program_reloc_btf_ext(struct bpf_program *prog, struct bpf_object *obj,
 		prog->line_info_rec_size = btf_ext__line_info_rec_size(obj->btf_ext);
 	}
 
-	if (!insn_offset)
-		prog->btf_fd = btf__fd(obj->btf);
-
 	return 0;
 }
 
@@ -2060,7 +2054,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int log_buf_size = BPF_LOG_BUF_SIZE;
 	char *log_buf;
-	int ret;
+	int btf_fd, ret;
 
 	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
 	load_attr.prog_type = prog->type;
@@ -2072,7 +2066,8 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.license = license;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
-	load_attr.prog_btf_fd = prog->btf_fd >= 0 ? prog->btf_fd : 0;
+	btf_fd = bpf_object__btf_fd(prog->obj);
+	load_attr.prog_btf_fd = btf_fd >= 0 ? btf_fd : 0;
 	load_attr.func_info = prog->func_info;
 	load_attr.func_info_rec_size = prog->func_info_rec_size;
 	load_attr.func_info_cnt = prog->func_info_cnt;
-- 
2.20.1

