Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C6BD1327
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbfJIPmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:42:49 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:57735 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729471AbfJIPms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:42:48 -0400
X-Originating-IP: 90.177.210.238
Received: from localhost.localdomain (238.210.broadband10.iol.cz [90.177.210.238])
        (Authenticated sender: i.maximets@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 69C66C000D;
        Wed,  9 Oct 2019 15:42:45 +0000 (UTC)
From:   Ilya Maximets <i.maximets@ovn.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH bpf] libbpf: fix passing uninitialized bytes to setsockopt
Date:   Wed,  9 Oct 2019 17:42:38 +0200
Message-Id: <20191009154238.15410-1-i.maximets@ovn.org>
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

Fixes: 10d30e301732 ("libbpf: add flags to umem config")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 tools/lib/bpf/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a902838f9fcc..26d9db783560 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -139,7 +139,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 			    const struct xsk_umem_config *usr_config)
 {
 	struct xdp_mmap_offsets off;
-	struct xdp_umem_reg mr;
+	struct xdp_umem_reg mr = {};
 	struct xsk_umem *umem;
 	socklen_t optlen;
 	void *map;
-- 
2.17.1

