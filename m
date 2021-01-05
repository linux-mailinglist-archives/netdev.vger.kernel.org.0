Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE78A2EADAF
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbhAEOqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:46:47 -0500
Received: from gofer.mess.org ([88.97.38.141]:34493 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbhAEOqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:46:18 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id CA9C5C639B; Tue,  5 Jan 2021 14:45:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1609857934; bh=vNMC+XjILBx6ybTc4yZLUSBL7ZhoWqLqlWehk6Wem00=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QNy4B2Y1H5sUO2bx8i2G2OrKcF4OQHcTYQ/hz1qhHJUfjMHnxlev1dvWPw4rCJVpX
         ZPJN8Xxv8EqEKxXzggLeW5+PfqpZP8AiGBIwugqi/8rVU1df5el1azskZ5sRkBIuWk
         G1lKr+1lp70HUT4jQEXVYmqt8VLwOypufaANYaTWse7gQH3NpZCsMsGAl0psRXN0xe
         pDUq1y85AANV4++JIfzRHtoT7eOJDOpoPPTHox4LMMNp7ghkYnEgP8lrbl1BopDnrR
         0TbZgFOYSb08SUwsVQV1Wf1cjn0ZJXw4FbPCTA4lyBRs9oEfinqwXMCEvtqT5utvYw
         8Gkrslnd/Njxw==
From:   Sean Young <sean@mess.org>
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH v3 2/4] libbpf: add support for ints larger than 128 bits
Date:   Tue,  5 Jan 2021 14:45:32 +0000
Message-Id: <3d3f8d4cc59b61d42e05d5f66d7b29fc7eb20cfa.1609855479.git.sean@mess.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1609855479.git.sean@mess.org>
References: <cover.1609855479.git.sean@mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang supports arbitrary length ints using the _ExtInt extension. This
can be useful to hold very large values, e.g. 256 bit or 512 bit types.

This requires the _ExtInt extension enabled in clang, which is under
review.

Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
Link: https://reviews.llvm.org/D93103

Signed-off-by: Sean Young <sean@mess.org>
---
 tools/lib/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3c3f2bc6c652..a676373f052b 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1722,7 +1722,7 @@ int btf__add_int(struct btf *btf, const char *name, size_t byte_sz, int encoding
 	if (!name || !name[0])
 		return -EINVAL;
 	/* byte_sz must be power of 2 */
-	if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 16)
+	if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 64)
 		return -EINVAL;
 	if (encoding & ~(BTF_INT_SIGNED | BTF_INT_CHAR | BTF_INT_BOOL))
 		return -EINVAL;
-- 
2.29.2

