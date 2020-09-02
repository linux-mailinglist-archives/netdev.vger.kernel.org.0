Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935DA25A80F
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 10:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIBIwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 04:52:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:25498 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgIBIwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 04:52:33 -0400
IronPort-SDR: d1jn+xo6H0W2BGzqRojVza0hhO9bmfEDEqQ+qmatN7pOTQ5JchUVo/dWrlQFm58E7KPmJsx0G6
 68JYn5oQZ1UA==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="137399088"
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="137399088"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 01:52:29 -0700
IronPort-SDR: pbZ4nOXstcxy8Vivo63fobNo3PfADY7U9TbS5MmN3hgMDTTg8fOSslj6+Udr+ZflxDHEz2e2rl
 Ecew4I7uFmUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="446456952"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.56.60])
  by orsmga004.jf.intel.com with ESMTP; 02 Sep 2020 01:52:27 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] xsk: fix possible segfault in xsk umem diagnostics
Date:   Wed,  2 Sep 2020 10:52:23 +0200
Message-Id: <1599036743-26454-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix possible segfault in the xsk diagnostics code when dumping
information about the umem. This can happen when a umem has been
created, but the socket has not been bound yet. In this case, the xsk
buffer pool does not exist yet and we cannot dump the information
that was moved from the umem to the buffer pool. Fix this by testing
for the existence of the buffer pool and if not there, do not dump any
of that information.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: syzbot+3f04d36b7336f7868066@syzkaller.appspotmail.com
Fixes: c2d3d6a47462 ("xsk: Move queue_id, dev and need_wakeup to buffer pool")
Fixes: 7361f9c3d719 ("xsk: Move fill and completion rings to buffer pool")
---
 net/xdp/xsk_diag.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
index 5bd8ea9..3cf6435 100644
--- a/net/xdp/xsk_diag.c
+++ b/net/xdp/xsk_diag.c
@@ -59,8 +59,8 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
 	du.num_pages = umem->npgs;
 	du.chunk_size = umem->chunk_size;
 	du.headroom = umem->headroom;
-	du.ifindex = pool->netdev ? pool->netdev->ifindex : 0;
-	du.queue_id = pool->queue_id;
+	du.ifindex = (pool && pool->netdev) ? pool->netdev->ifindex : 0;
+	du.queue_id = pool ? pool->queue_id : 0;
 	du.flags = 0;
 	if (umem->zc)
 		du.flags |= XDP_DU_F_ZEROCOPY;
@@ -68,10 +68,10 @@ static int xsk_diag_put_umem(const struct xdp_sock *xs, struct sk_buff *nlskb)
 
 	err = nla_put(nlskb, XDP_DIAG_UMEM, sizeof(du), &du);
 
-	if (!err && pool->fq)
+	if (!err && pool && pool->fq)
 		err = xsk_diag_put_ring(pool->fq,
 					XDP_DIAG_UMEM_FILL_RING, nlskb);
-	if (!err && pool->cq) {
+	if (!err && pool && pool->cq) {
 		err = xsk_diag_put_ring(pool->cq, XDP_DIAG_UMEM_COMPLETION_RING,
 					nlskb);
 	}
-- 
2.7.4

