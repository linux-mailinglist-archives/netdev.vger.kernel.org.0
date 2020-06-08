Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC801F3019
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbgFIA4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbgFHXJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 817A620B80;
        Mon,  8 Jun 2020 23:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657745;
        bh=eLGvbqasm5wT9Qyyy9tJRN20dYjw6ehaSKc9NufMyLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFAcSbgjNs+965jiLFuV2TERJGezRivtk/hkb7aQtTZ0g0CynvXb7o3u3JKZ9qYnf
         uL9elq8MtaRcyro2jinmJ2n2Jd+DeIfwvGy4JwkgJxKr6SF/b1cGKuXekCI+AEHj3K
         4eXDZu7OHMw6kuOvH1kqMdf50vf6DEau9O75GQJw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        KP Singh <kpsingh@google.com>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 133/274] libbpf: Fix huge memory leak in libbpf_find_vmlinux_btf_id()
Date:   Mon,  8 Jun 2020 19:03:46 -0400
Message-Id: <20200608230607.3361041-133-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 3521ffa2ee9a48c3236c93f54ae11c074490ebce ]

BTF object wasn't freed.

Fixes: a6ed02cac690 ("libbpf: Load btf_vmlinux only once per object.")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: KP Singh <kpsingh@google.com>
Link: https://lore.kernel.org/bpf/20200429012111.277390-9-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 63fc872723fc..cd53204d33f0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6688,6 +6688,7 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 			       enum bpf_attach_type attach_type)
 {
 	struct btf *btf;
+	int err;
 
 	btf = libbpf_find_kernel_btf();
 	if (IS_ERR(btf)) {
@@ -6695,7 +6696,9 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 		return -EINVAL;
 	}
 
-	return __find_vmlinux_btf_id(btf, name, attach_type);
+	err = __find_vmlinux_btf_id(btf, name, attach_type);
+	btf__free(btf);
+	return err;
 }
 
 static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
-- 
2.25.1

