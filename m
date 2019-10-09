Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E597D147C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731699AbfJIQtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:49:39 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:35825 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731538AbfJIQti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:49:38 -0400
Received: from localhost.localdomain (238.210.broadband10.iol.cz [90.177.210.238])
        (Authenticated sender: i.maximets@ovn.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id BE66E10000F;
        Wed,  9 Oct 2019 16:49:34 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH bpf v2] libbpf: fix passing uninitialized bytes to setsockopt
Date:   Wed,  9 Oct 2019 18:49:29 +0200
Message-Id: <20191009164929.17242-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---

Version 2:
  * Struct initializer replaced with explicit memset(). [Andrii]

 tools/lib/bpf/xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a902838f9fcc..9d5348086203 100644
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
2.17.1

