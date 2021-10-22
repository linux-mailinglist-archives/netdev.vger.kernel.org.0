Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB89B437C31
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhJVRo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233538AbhJVRo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:44:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B90161108;
        Fri, 22 Oct 2021 17:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634924558;
        bh=KSTZbTwJED2Trs1mK+SIVPqifn31y3USERdU78twhzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKnDI1O4kcsnLqjWWYFQC4O2pd+NTtFV2+WCsphme2tDGuXIAQA+whXkccrUUcl6c
         OgzR9XyxQPpbc90sDwjcz4LI5I3vnhyJkJ2GYP813U1TkJ+YGM81lnW0NviH2vQh9d
         OUEcxLGgsrn0zIFmZyjxdJtsZ2TEA3XSeEXsMv+L/+CYPTOB5V97PD/ca15LpNWAE2
         EwKv3ikzYzNVUHp79Va+nWQHKRzXpP4PTJeBJ1tuzXhnCgtZEh4EVQzOgRrCFPw/6k
         mJhlfbrKvNEgZWStxcwXKA5TOKWG4sb75igg7v1RHM7Te4+F+voTsor50dKz69nr+Q
         vS2DsEnvISmmw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, Jakub Kicinski <kuba@kernel.org>,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com
Subject: [PATCH net-next 2/2] bluetooth: use dev_addr_set()
Date:   Fri, 22 Oct 2021 10:42:32 -0700
Message-Id: <20211022174232.2510917-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022174232.2510917-1-kuba@kernel.org>
References: <20211022174232.2510917-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

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

