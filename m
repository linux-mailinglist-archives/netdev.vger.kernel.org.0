Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224044917D0
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347822AbiARCnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:43:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57794 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346914AbiARCkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:40:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 377F9612CF;
        Tue, 18 Jan 2022 02:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC99EC36AEB;
        Tue, 18 Jan 2022 02:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473612;
        bh=FWtbtmARrt7YCzY3o9axlqB5+rkW6kVoS11LNDSwnWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ai9Y0sAWJu3rqtMgHU5Mqyc2FQqe5Z4IpBxn8Q7YrTCgg+u8KWcuHRMbihNDCsZEN
         Ua7hkTVY02gkiP2F3eKIFUe35KbHbimhsG1RxYqn78ShieO+BI7yemTAejKF7w30nf
         CLd4sFGZ7+Fymep3Fw/OWow6tmL6xGn1vRJRfDxhMhVuB/QBZehpoQL+vdjYEggY64
         2hDSuyq/+xlw9oDZoaLu9r7N40On5Ns2GOCIsiwaapXBnlGAEHwvkm7f/Q1pfJOV7S
         Y60afBo/pzlzeOaORgI/5Z3xsqn6zDg1hbgvkzfq7qgI3bG8D6PiLyBQTXSS7xTe52
         R5Tq/HDFY2ADw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 003/116] libbpf: Validate that .BTF and .BTF.ext sections contain data
Date:   Mon, 17 Jan 2022 21:38:14 -0500
Message-Id: <20220118024007.1950576-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index b337d6f29098b..e8ad53d31044a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2870,8 +2870,12 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
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

