Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E5119A28
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfLJVuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbfLJVI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD3924697;
        Tue, 10 Dec 2019 21:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012106;
        bh=ktijTs+YH0kLfd14gHw3DHO+Hfe8ZILGwhwxYVAJBvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/WiWGezgUfEQKQylHJNq0AnGLhlMB6ocznhrYY4xkPrNmzllKoTK3rPsvWokQbah
         sOfPr4+pKMZa74vos42wgwgJYocZHvt/530xv/5HaTr1MK7vM1oe1ftOxPioWtGKFI
         eNH1tESb8hWPwknC7J2CZUHGK1i7rUmS3WE4zndo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 080/350] libbpf: Fix struct end padding in btf_dump
Date:   Tue, 10 Dec 2019 16:03:05 -0500
Message-Id: <20191210210735.9077-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit b4099769f3321a8d258a47a8b4b9d278dad28a73 ]

Fix a case where explicit padding at the end of a struct is necessary
due to non-standart alignment requirements of fields (which BTF doesn't
capture explicitly).

Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
Reported-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20191008231009.2991130-2-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index ede55fec36184..87f27e2664c5d 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -876,7 +876,6 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 	__u16 vlen = btf_vlen(t);
 
 	packed = is_struct ? btf_is_struct_packed(d->btf, id, t) : 0;
-	align = packed ? 1 : btf_align_of(d->btf, id);
 
 	btf_dump_printf(d, "%s%s%s {",
 			is_struct ? "struct" : "union",
@@ -906,6 +905,13 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 		btf_dump_printf(d, ";");
 	}
 
+	/* pad at the end, if necessary */
+	if (is_struct) {
+		align = packed ? 1 : btf_align_of(d->btf, id);
+		btf_dump_emit_bit_padding(d, off, t->size * 8, 0, align,
+					  lvl + 1);
+	}
+
 	if (vlen)
 		btf_dump_printf(d, "\n");
 	btf_dump_printf(d, "%s}", pfx(lvl));
-- 
2.20.1

