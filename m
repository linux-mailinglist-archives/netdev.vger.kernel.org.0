Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F0A491788
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344957AbiARCmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48990 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345824AbiARCcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:32:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F2E6114D;
        Tue, 18 Jan 2022 02:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6762C36AE3;
        Tue, 18 Jan 2022 02:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473124;
        bh=Z27vxkKAGPedE5N5tV7UpoZMqJ2PoxPndOeGhXv3ZHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMk6sl8+rA85bvmxUsRiFhl5kv5C9u0gAHMvfcemMrPRPgb28agv8vaf8h/d8DwnL
         ViYDcdN0ilhpKPW0eP32T8oc0mzcqnj2ZQRTsDKpDyqztjEXE3JcbR1gqP6k0rXLRM
         yaeB9kC1XGcRh3/3wgxbXZ9OacNTSKUj3CeMokAqoQvFTTIfy6LVyizcPXbf7xnsal
         mbZjzFMj6Jw23rr32kmbjY/LRAgSBK50xb0mMKJa1QlwvwVVhdDocNuNvCy3wybRVc
         Rkt73vpFn3uLQevqg8QxTUlVZmNzxss7qgGscChdvWhmtfB1SIAbPONpJBS9azFaJv
         VmN2Lj6YwWg0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 006/188] libbpf: Validate that .BTF and .BTF.ext sections contain data
Date:   Mon, 17 Jan 2022 21:28:50 -0500
Message-Id: <20220118023152.1948105-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 62554d52e71797eefa3fc15b54008038837bb2d4 ]

.BTF and .BTF.ext ELF sections should have SHT_PROGBITS type and contain
data. If they are not, ELF is invalid or corrupted, so bail out.
Otherwise this can lead to data->d_buf being NULL and SIGSEGV later on.
Reported by oss-fuzz project.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211103173213.1376990-4-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7145463a4a562..6613f362f35d0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3035,8 +3035,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 		} else if (strcmp(name, MAPS_ELF_SEC) == 0) {
 			obj->efile.btf_maps_shndx = idx;
 		} else if (strcmp(name, BTF_ELF_SEC) == 0) {
+			if (sh->sh_type != SHT_PROGBITS)
+				return -LIBBPF_ERRNO__FORMAT;
 			btf_data = data;
 		} else if (strcmp(name, BTF_EXT_ELF_SEC) == 0) {
+			if (sh->sh_type != SHT_PROGBITS)
+				return -LIBBPF_ERRNO__FORMAT;
 			btf_ext_data = data;
 		} else if (sh.sh_type == SHT_SYMTAB) {
 			/* already processed during the first pass above */
-- 
2.34.1

