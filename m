Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1BC49141F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244386AbiARCUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:20:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34802 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244343AbiARCT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:19:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F18DB811FF;
        Tue, 18 Jan 2022 02:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8E8C36AE3;
        Tue, 18 Jan 2022 02:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472397;
        bh=xhoC9JEsQkh2x4CVlOItxInWCYdd7RSZiQ/yq62fugw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OV6Gj9A9LcbnoRB8JnFSXZKYD24Dw/lSjKfiZwxoL3gHSg5CFJA26c5vj6uUq1Os4
         /OZNzdh1ygTs1lKv6i7LO0ia752HFQNLTMlYrFrXDOnR++cI2CmNqdP1fZKLkGXUgI
         SE04RRfJUQPubjBxnsRMvDunvcAHrSrx+/KSl30Ukrhb2afQnBxRf3G5CDKO2QvVqS
         oVNS5WAcggVBdumqK+eT1FD35nN1ytHcpK3M5xa4zPed9LMx8xLgtDlWnBS939FkDw
         xGRlKs/3QEesW3WyVdx8x4q2eA5kno3c2SfE2cBNpRW8EaHyBgn3Dkft0gTiH/iBlh
         OWpyDqrzWgLqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 010/217] libbpf: Validate that .BTF and .BTF.ext sections contain data
Date:   Mon, 17 Jan 2022 21:16:13 -0500
Message-Id: <20220118021940.1942199-10-sashal@kernel.org>
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
index 18651e11b9ba3..7d27152dfb3a6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3270,8 +3270,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
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
 		} else if (sh->sh_type == SHT_SYMTAB) {
 			/* already processed during the first pass above */
-- 
2.34.1

