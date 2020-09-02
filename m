Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E31925A853
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 11:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIBJGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 05:06:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:12124 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgIBJGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 05:06:19 -0400
IronPort-SDR: jXg+rCWMUz3nH82DZB8k+5T+kHhFC75N1ejfN5yoe5mMwRpVkwkS0cAsCFoQ20T8NdOSzldzdY
 JMFJ/WXnsbeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="158347329"
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="158347329"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 02:06:16 -0700
IronPort-SDR: d3r64jTla/qkoN9iDIvSpHT+Ei+WZZCqsq4AK3zjtYOsJtV/E8W7xmSE0wrSwwXwthmXCl1qW9
 yLO/Bjo49/yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="446460095"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.56.60])
  by orsmga004.jf.intel.com with ESMTP; 02 Sep 2020 02:06:12 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] xsk: fix possible segfault at xskmap entry insertion
Date:   Wed,  2 Sep 2020 11:06:09 +0200
Message-Id: <1599037569-26690-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix possible segfault when entry is inserted into xskmap. This can
happen if the socket is in a state where the umem has been set up, the
Rx ring created but it has yet to be bound to a device. In this case
the pool has not yet been created and we cannot reference it for the
existence of the fill ring. Fix this by removing the whole
xsk_is_setup_for_bpf_map function. Once upon a time, it was used to
make sure that the Rx and fill rings where set up before the driver
could call xsk_rcv, since there are no tests for the existence of
these rings in the data path. But these days, we have a state variable
that we test instead. When it is XSK_BOUND, everything has been set up
correctly and the socket has been bound. So no reason to have the
xsk_is_setup_for_bpf_map function anymore.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: syzbot+febe51d44243fbc564ee@syzkaller.appspotmail.com
Fixes: 7361f9c3d719 ("xsk: move fill and completion rings to buffer pool")
---
 net/xdp/xsk.c    | 6 ------
 net/xdp/xsk.h    | 1 -
 net/xdp/xskmap.c | 5 -----
 3 files changed, 12 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5eb6662..07c3227 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -33,12 +33,6 @@
 
 static DEFINE_PER_CPU(struct list_head, xskmap_flush_list);
 
-bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs)
-{
-	return READ_ONCE(xs->rx) &&  READ_ONCE(xs->umem) &&
-		(xs->pool->fq || READ_ONCE(xs->fq_tmp));
-}
-
 void xsk_set_rx_need_wakeup(struct xsk_buff_pool *pool)
 {
 	if (pool->cached_need_wakeup & XDP_WAKEUP_RX)
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index da1f73e..b9e896c 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -39,7 +39,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
 	return (struct xdp_sock *)sk;
 }
 
-bool xsk_is_setup_for_bpf_map(struct xdp_sock *xs);
 void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
 			     struct xdp_sock **map_entry);
 int xsk_map_inc(struct xsk_map *map);
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 2a4fd66..0c5df59 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -185,11 +185,6 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 
 	xs = (struct xdp_sock *)sock->sk;
 
-	if (!xsk_is_setup_for_bpf_map(xs)) {
-		sockfd_put(sock);
-		return -EOPNOTSUPP;
-	}
-
 	map_entry = &m->xsk_map[i];
 	node = xsk_map_node_alloc(m, map_entry);
 	if (IS_ERR(node)) {
-- 
2.7.4

