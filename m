Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0C02FA591
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406351AbhARQEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:04:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49304 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2406301AbhARQEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:04:32 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maximmi@mellanox.com)
        with SMTP; 18 Jan 2021 18:03:33 +0200
Received: from dev-l-vrt-208.mtl.labs.mlnx (dev-l-vrt-208.mtl.labs.mlnx [10.234.208.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10IG3Xpw025103;
        Mon, 18 Jan 2021 18:03:33 +0200
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: Clear pool even for inactive queues
Date:   Mon, 18 Jan 2021 18:03:33 +0200
Message-Id: <20210118160333.333439-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of queues can change by other means, rather than ethtool. For
example, attaching an mqprio qdisc with num_tc > 1 leads to creating
multiple sets of TX queues, which may be then destroyed when mqprio is
deleted. If an AF_XDP socket is created while mqprio is active,
dev->_tx[queue_id].pool will be filled, but then real_num_tx_queues may
decrease with deletion of mqprio, which will mean that the pool won't be
NULLed, and a further increase of the number of TX queues may expose a
dangling pointer.

To avoid any potential misbehavior, this commit clears pool for RX and
TX queues, regardless of real_num_*_queues, still taking into
consideration num_*_queues to avoid overflows.

Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")
Fixes: a41b4f3c58dd ("xsk: simplify xdp_clear_umem_at_qid implementation")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 net/xdp/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 8037b04a9edd..4a83117507f5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -108,9 +108,9 @@ EXPORT_SYMBOL(xsk_get_pool_from_qid);
 
 void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id)
 {
-	if (queue_id < dev->real_num_rx_queues)
+	if (queue_id < dev->num_rx_queues)
 		dev->_rx[queue_id].pool = NULL;
-	if (queue_id < dev->real_num_tx_queues)
+	if (queue_id < dev->num_tx_queues)
 		dev->_tx[queue_id].pool = NULL;
 }
 
-- 
2.25.1

