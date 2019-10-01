Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C13BC3D87
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbfJARAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbfJAQkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B87E21A4A;
        Tue,  1 Oct 2019 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948047;
        bh=AFahc8G12K7WvzeCEERC3mW1Z1th2gs47ouNqmHB0wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPiOLtLZtsPXzedIqFHTNWvPncwW1qkdB2L/UDaCacxr8FARikNWCww+ScfXlMmFx
         5xmqvDN9tqzhuMtNZof0iPCZ+ThMvAmEvzqKg8foM331tDWXPdY/7hDYYfaCjtDuEy
         a0+NqT8cMq9t1THTZeViQYVnl9z4XA4k3dLNXZBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 52/71] libbpf: fix false uninitialized variable warning
Date:   Tue,  1 Oct 2019 12:39:02 -0400
Message-Id: <20191001163922.14735-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit aef70a1f44c0b570e6345c02c2d240471859f0a4 ]

Some compilers emit warning for potential uninitialized next_id usage.
The code is correct, but control flow is too complicated for some
compilers to figure this out. Re-initialize next_id to satisfy
compiler.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 7065bb5b27525..e1357dbb16c24 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1213,6 +1213,7 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 				return;
 			}
 
+			next_id = decls->ids[decls->cnt - 1];
 			next_t = btf__type_by_id(d->btf, next_id);
 			multidim = btf_kind_of(next_t) == BTF_KIND_ARRAY;
 			/* we need space if we have named non-pointer */
-- 
2.20.1

