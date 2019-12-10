Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56CF119A27
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbfLJVuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbfLJVI2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F17AD2077B;
        Tue, 10 Dec 2019 21:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012107;
        bh=LpanFEyvR+xEw/Esxsx0CMwvEb4jJ3RN9Q+A3sYHxB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6SzZs8LbggStxLlKpVmIAwgtJEi61KoSHoCOkTe+pPIU/ma0gVLjGQkb6vgN5wYT
         GGOagtq7Q9N80or2lG4lBrMfliWxMkHUlAF+o24BRLmbBIM5UkezT9ZvEWW0QswN6H
         84ue1XgjfmHo4q5azsG54x5oXSFojhJGd3k299Ls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 081/350] libbpf: Fix passing uninitialized bytes to setsockopt
Date:   Tue, 10 Dec 2019 16:03:06 -0500
Message-Id: <20191210210735.9077-42-sashal@kernel.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 25bfef430e960e695403b5d9c8dcc11b9f5d62be ]

'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
valgrind complain about passing uninitialized stack memory to the
syscall:

  Syscall param socketcall.setsockopt() points to uninitialised byte(s)
    at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
    by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
  Uninitialised value was created by a stack allocation
    at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)

Padding bytes appeared after introducing of a new 'flags' field.
memset() is required to clear them.

Fixes: 10d30e301732 ("libbpf: add flags to umem config")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20191009164929.17242-1-i.maximets@ovn.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a902838f9fccd..9d53480862030 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -163,6 +163,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 	umem->umem_area = umem_area;
 	xsk_set_umem_config(&umem->config, usr_config);
 
+	memset(&mr, 0, sizeof(mr));
 	mr.addr = (uintptr_t)umem_area;
 	mr.len = size;
 	mr.chunk_size = umem->config.frame_size;
-- 
2.20.1

