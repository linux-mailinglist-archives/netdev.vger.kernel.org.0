Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700C2491414
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244441AbiARCUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244313AbiARCT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:19:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F3CC061574;
        Mon, 17 Jan 2022 18:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E75B81239;
        Tue, 18 Jan 2022 02:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F407C36AF6;
        Tue, 18 Jan 2022 02:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472396;
        bh=/VWau8D6YDf8owSqoQpXikxvFAZkjLvobIaoJQ94Rh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H33AGlSRdPRF92EXdrJDhswJzZDR5iPMu++wT1uE2buIFgucwYVuCjE24J0izf4Pb
         OuPcRA4+Hlhk44LsxlFWo7VNePr2AaHTwNfIoK4XPd8efF7pzb0rxRgk+T6GVgfksm
         ahHcdZFi9L5B95YOql7xuqDyh5LxyJWGhb7EnNe1y3gHhlsnodwHdTclo2B/5d0BTZ
         Sjv2Ok/EdpcbNWplTQbkecRPXMEKHCdhVFMwY6mwYjd62bi2DXDhy9Rh5RxFwdzemJ
         Nq6ecvpDZ3pEEMiQCWx/KhdM81ljbrLereDvFRm9N19Z9acbvcg61wpvman8ye0ef8
         V8Hq0rVbnr7YQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 009/217] libbpf: Improve sanity checking during BTF fix up
Date:   Mon, 17 Jan 2022 21:16:12 -0500
Message-Id: <20220118021940.1942199-9-sashal@kernel.org>
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

[ Upstream commit 88918dc12dc357a06d8d722a684617b1c87a4654 ]

If BTF is corrupted DATASEC's variable type ID might be incorrect.
Prevent this easy to detect situation with extra NULL check.
Reported by oss-fuzz project.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211103173213.1376990-3-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b5bf1c074832e..18651e11b9ba3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2752,13 +2752,12 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
 
 	for (i = 0, vsi = btf_var_secinfos(t); i < vars; i++, vsi++) {
 		t_var = btf__type_by_id(btf, vsi->type);
-		var = btf_var(t_var);
-
-		if (!btf_is_var(t_var)) {
+		if (!t_var || !btf_is_var(t_var)) {
 			pr_debug("Non-VAR type seen in section %s\n", name);
 			return -EINVAL;
 		}
 
+		var = btf_var(t_var);
 		if (var->linkage == BTF_VAR_STATIC)
 			continue;
 
-- 
2.34.1

