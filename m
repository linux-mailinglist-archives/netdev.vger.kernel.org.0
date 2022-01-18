Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D16491418
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbiARCUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:20:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34802 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244399AbiARCT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:19:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE56CB811FF;
        Tue, 18 Jan 2022 02:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B021BC36AEB;
        Tue, 18 Jan 2022 02:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472394;
        bh=D2F65sZ8+SV9pkPLBU9T9VYQyZJtdJT8brhvmr+qFZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0JMM8HtWyOGSaDPtHkPGvf49tiMZtL8JymoI/Vf74ALq73JbgmvzfaVTRaMSNM6b
         nwZJ1aWyjRYfdaoVwZ5UfBF0Lg+iZckKLJeBpTR8QzPWY8ZnFwGMsTMJgrprXmG9aC
         Xnt0mK9bhLxGPFU5EpiLZBPh4D1bwbDcp7F0RkJ0kMs4icwsTmFpMf+SOShZNc4rA+
         TV1JHYu33wPjhmct4Dn0JEQAmwz8S7dyVLYoEtaR1KNQOeL79yZheRQRp/wxH2M1/u
         FbI32OZtsZSDpsqTIGS+UGlwhM2Dl/WSfgaHKSVSIQ6++tjEmm1hY47UB406QS9Xkx
         EOA++R8E2Ybkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 008/217] libbpf: Detect corrupted ELF symbols section
Date:   Mon, 17 Jan 2022 21:16:11 -0500
Message-Id: <20220118021940.1942199-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 833907876be55205d0ec153dcd819c014404ee16 ]

Prevent divide-by-zero if ELF is corrupted and has zero sh_entsize.
Reported by oss-fuzz project.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211103173213.1376990-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7c74342bb6680..b5bf1c074832e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3555,7 +3555,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 
 	scn = elf_sec_by_idx(obj, obj->efile.symbols_shndx);
 	sh = elf_sec_hdr(obj, scn);
-	if (!sh)
+	if (!sh || sh->sh_entsize != sizeof(Elf64_Sym))
 		return -LIBBPF_ERRNO__FORMAT;
 
 	dummy_var_btf_id = add_dummy_ksym_var(obj->btf);
-- 
2.34.1

