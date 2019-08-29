Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F13A25FB
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfH2SNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbfH2SNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67AC12189D;
        Thu, 29 Aug 2019 18:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102396;
        bh=hkBnbXIj4Ow5ukHzAWFpSqN0IRB8d7dNXP7A+zZpRBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qtxi24umdUcuSRIwdfk7cQXF9cWXQuDwXySud/jP4Yb1VydCYv1vxcTVEmOFlYLix
         DnOO0zrNtbjc7N5iw5smu2WgFVdqBeRRrn/pCf0RADLso02pyRUR40r5wgBvH7oqLr
         NhoRCbGxY4kMc8AcjRPeclf+lUt1g1TI+QBbHrY8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 03/76] libbpf: set BTF FD for prog only when there is supported .BTF.ext data
Date:   Thu, 29 Aug 2019 14:11:58 -0400
Message-Id: <20190829181311.7562-3-sashal@kernel.org>
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

[ Upstream commit 3415ec643e7bd644b03026efbe2f2b36cbe9b34b ]

5d01ab7bac46 ("libbpf: fix erroneous multi-closing of BTF FD")
introduced backwards-compatibility issue, manifesting itself as -E2BIG
error returned on program load due to unknown non-zero btf_fd attribute
value for BPF_PROG_LOAD sys_bpf() sub-command.

This patch fixes bug by ensuring that we only ever associate BTF FD with
program if there is a BTF.ext data that was successfully loaded into
kernel, which automatically means kernel supports func_info/line_info
and associated BTF FD for progs (checked and ensured also by BTF
sanitization code).

Fixes: 5d01ab7bac46 ("libbpf: fix erroneous multi-closing of BTF FD")
Reported-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e308fcf16cdd0..ce579e3654d60 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2066,7 +2066,11 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.license = license;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
-	btf_fd = bpf_object__btf_fd(prog->obj);
+	/* if .BTF.ext was loaded, kernel supports associated BTF for prog */
+	if (prog->obj->btf_ext)
+		btf_fd = bpf_object__btf_fd(prog->obj);
+	else
+		btf_fd = -1;
 	load_attr.prog_btf_fd = btf_fd >= 0 ? btf_fd : 0;
 	load_attr.func_info = prog->func_info;
 	load_attr.func_info_rec_size = prog->func_info_rec_size;
-- 
2.20.1

