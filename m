Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEE81A74DB
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 09:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406682AbgDNHf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 03:35:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:42346 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406666AbgDNHfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 03:35:25 -0400
IronPort-SDR: k5fNYDTeAspv0i2Bqbsz9BgKcTp6FpfKArqgKsYbeVlrlQ7sda6NcmZMwrVbKye8i4FvzuBM3f
 w/10PyaypzzQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 00:35:24 -0700
IronPort-SDR: DhwHoOx9y9YWQ8eYEuTvIITKwLSX5BCtXGBFP9+IfWvq09A7k5hpWlv7KQ/WZgNcXRKcF+XPfj
 4nywVsLFYcrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="399872086"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.38.13])
  by orsmga004.jf.intel.com with ESMTP; 14 Apr 2020 00:35:21 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     minhquangbui99@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: add missing check on user supplied headroom size
Date:   Tue, 14 Apr 2020 09:35:15 +0200
Message-Id: <1586849715-23490-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a check that the headroom cannot be larger than the available
space in the chunk. In the current code, a malicious user can set the
headroom to a value larger than the chunk size minus the fixed XDP
headroom. That way packets with a length larger than the supported
size in the umem could get accepted and result in an out-of-bounds
write.

Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
Reported-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=207225
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xdp_umem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index fa7bb5e..ed7a606 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -343,7 +343,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
 	unsigned int chunks, chunks_per_page;
 	u64 addr = mr->addr, size = mr->len;
-	int size_chk, err;
+	int err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
 		/* Strictly speaking we could support this, if:
@@ -382,8 +382,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 			return -EINVAL;
 	}
 
-	size_chk = chunk_size - headroom - XDP_PACKET_HEADROOM;
-	if (size_chk < 0)
+	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
 		return -EINVAL;
 
 	umem->address = (unsigned long)addr;
-- 
2.7.4

