Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A38491BA9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344685AbiARDIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbiARC46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:56:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1276C0613AD;
        Mon, 17 Jan 2022 18:44:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88980B8125F;
        Tue, 18 Jan 2022 02:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79901C36AEB;
        Tue, 18 Jan 2022 02:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473878;
        bh=heTk60CDtiDxyRuaYkCe/Cwdp8eX4YXc3TH7vtDBWIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKyk3GF2avIvEl8R6l8e9ybJWkMHCnHfPQMfka9Upq/MdvrmcSlMAz9x8CvQ/wze1
         4kvm1skQzs3qZpRJhOJ639KVFFclUXfCzK3JyNZUMSkKSwZ6SvyvhUKNcKWTv9MxDV
         /wHmfVeMMUWkPCn02yqrl/QPwASdkqNg8qBD8v0b/ri9BrnE5y+zmchr70pYLE1l1d
         HoxyTMT5VuPj4kgFEYm5E0Aj9oO1se7Yx7sZyML+TDnfF9/Pp+kcssYUWCgBDZe0XC
         g30zlXhQKmCapIHqC5hMcljmd5rTrWMgcedwhjhinXXcoUb2EtfhOh0ca5Yhxvu0aq
         +kPbMVi6pMS+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/73] libbpf: Validate that .BTF and .BTF.ext sections contain data
Date:   Mon, 17 Jan 2022 21:43:22 -0500
Message-Id: <20220118024432.1952028-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index 2a1dbf52fc9a5..54e776886bf1e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1578,8 +1578,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
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
 			if (obj->efile.symbols) {
-- 
2.34.1

