Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68973404BCD
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241531AbhIILxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:53:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239488AbhIILvB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94C9D61356;
        Thu,  9 Sep 2021 11:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187844;
        bh=35mbzRvU6JfJ7yvh2CXrenvC6BWUwLp9YJcEV3nMwhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AS4ZDyfizY21jcRGsfxXJS2cxu+kD6eGDcvFwtZ6/t/vhpzRNU8x/QZvBrPGzO03S
         EWouS7u576MRYwDIA/gpnpcO3ob+pRp/7WsTL0DxO/UkpSXO7H4dx/w4+Ed+nWGL9a
         X3UGzP3rmsOWXmwsQLiWeSYxKKhd4wHalLEw0Oihy4BgpYonmIH19MhtHOBEkRctrs
         szGJc9UsPBZ7harnVlhLOBhFWUDbnPdYpEor0LbvyAxnnq0JhwoOYbaW0Z0Lf87dX1
         CNWmBSxD2k3M44Apk/1EHIUKcqDVAYCvdIw+p/NTDcamPhc2RSmVmspyRWHDYUjVSu
         B2Q/yl9h+mKFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 137/252] selftests/bpf: Fix xdp_tx.c prog section name
Date:   Thu,  9 Sep 2021 07:39:11 -0400
Message-Id: <20210909114106.141462-137-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index 94e6c2b281cb..5f725c720e00 100644
--- a/tools/testing/selftests/bpf/progs/xdp_tx.c
+++ b/tools/testing/selftests/bpf/progs/xdp_tx.c
@@ -3,7 +3,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
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

