Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5154E43808A
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhJVXVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhJVXU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFBEE6103D;
        Fri, 22 Oct 2021 23:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944720;
        bh=Lq3llxiET9BpfgqKIqAncf4yMxsCJPuJc7SPztLJ4fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBN7ebP2AHmNosQycnQNtawkEIMxLz+Klgxg/YiqnrPY4drI2lPPDgHcxwrzGCALy
         f5df/9JalO9vGylzWHZYQTdK0QXia2Kp+fcvRgLq2RAuxaO9OTtq6Lodt1DQzlZttE
         gmtWR76Yx0tYKeAZTNEDS4MC4x0MO0xf+xG31y2lQSQ3xKbYVqMOQyoqrpr5iUy+pz
         +yGa6O0p8yntZRpc8h8/LVmBJUtkJ0nx7/Qyjbky/YYJYJ1IMg1xA5h8JDJFbY7Ors
         HF0HtCnaldmZufUs/eRDMTGUDoWyzWwTuNKndvasoZNJ9S3/6qBVw/sFV2tyhmYrn7
         qid9zYAVuyriQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, Jakub Kicinski <kuba@kernel.org>,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com
Subject: [PATCH net-next v2 2/2] bluetooth: use dev_addr_set()
Date:   Fri, 22 Oct 2021 16:18:34 -0700
Message-Id: <20211022231834.2710245-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022231834.2710245-1-kuba@kernel.org>
References: <20211022231834.2710245-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
---
CC: marcel@holtmann.org
CC: johan.hedberg@gmail.com
CC: luiz.dentz@gmail.com
CC: linux-bluetooth@vger.kernel.org
---
 net/bluetooth/6lowpan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index fd164a248569..133d7ea063fb 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -663,6 +663,7 @@ static struct l2cap_chan *add_peer_chan(struct l2cap_chan *chan,
 static int setup_netdev(struct l2cap_chan *chan, struct lowpan_btle_dev **dev)
 {
 	struct net_device *netdev;
+	bdaddr_t addr;
 	int err;
 
 	netdev = alloc_netdev(LOWPAN_PRIV_SIZE(sizeof(struct lowpan_btle_dev)),
@@ -672,7 +673,8 @@ static int setup_netdev(struct l2cap_chan *chan, struct lowpan_btle_dev **dev)
 		return -ENOMEM;
 
 	netdev->addr_assign_type = NET_ADDR_PERM;
-	baswap((void *)netdev->dev_addr, &chan->src);
+	baswap(&addr, &chan->src);
+	__dev_addr_set(netdev, &addr, sizeof(addr));
 
 	netdev->netdev_ops = &netdev_ops;
 	SET_NETDEV_DEV(netdev, &chan->conn->hcon->hdev->dev);
-- 
2.31.1

