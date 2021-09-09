Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0E44057DB
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352855AbhIINmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352669AbhIIMrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:47:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 738D26321B;
        Thu,  9 Sep 2021 11:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188581;
        bh=aPWGOzrcJUYBnY4fOgV8kDgDENBwRy9fv9+g8i3ZX9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGps9I30m1iyGT1yEM5x47hbm745o2DVilx8dCtRQ6Ob4V3QnGZaL3DwRUDBM6qFk
         5I974nxMzWI0k/ARPxNrQd3ask4YmZW4z5+4jVq0i8JCZKsnWdBa3Blv26MawSbukL
         oRKZ6XlW/y8PnKwupiitnqBFxGgd9WRBst6gIZfpijP+Fd9812wOyp9r56x5y1OSdR
         dJeEr5pl4qOfRD0IHMKa+8FkgSNZZLGwrsbQUe82WXgHzKy38svVtKhn8Lvv3XYidt
         l15uZFpadTpEoiVNTgO56suX0dg8gJNF7FlhDNFN+zzwGD1PLoovXyE9U4j41ghKb/
         xpnGy8T5kfngg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 058/109] selftests/bpf: Fix xdp_tx.c prog section name
Date:   Thu,  9 Sep 2021 07:54:15 -0400
Message-Id: <20210909115507.147917-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

[ Upstream commit 95413846cca37f20000dd095cf6d91f8777129d7 ]

The program type cannot be deduced from 'tx' which causes an invalid
argument error when trying to load xdp_tx.o using the skeleton.
Rename the section name to "xdp" so that libbpf can deduce the type.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210731055738.16820-7-joamaki@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/xdp_tx.c   | 2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_tx.c b/tools/testing/selftests/bpf/progs/xdp_tx.c
index 57912e7c94b0..9ed477776eca 100644
--- a/tools/testing/selftests/bpf/progs/xdp_tx.c
+++ b/tools/testing/selftests/bpf/progs/xdp_tx.c
@@ -3,7 +3,7 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
 
-SEC("tx")
+SEC("xdp")
 int xdp_tx(struct xdp_md *xdp)
 {
 	return XDP_TX;
diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
index ba8ffcdaac30..995278e684b6 100755
--- a/tools/testing/selftests/bpf/test_xdp_veth.sh
+++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
@@ -108,7 +108,7 @@ ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
 ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
 
 ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
-ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec tx
+ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec xdp
 ip -n ns3 link set dev veth33 xdp obj xdp_dummy.o sec xdp_dummy
 
 trap cleanup EXIT
-- 
2.30.2

