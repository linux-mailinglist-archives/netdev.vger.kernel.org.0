Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199F069136
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391024AbfGOO10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389203AbfGOO10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:27:26 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DD4A21850;
        Mon, 15 Jul 2019 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200845;
        bh=ZrU0QluTc3U+7nMkklJOhFFAOwwl42KlOSzZBaNtEE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBV2G5iCDOjZC67BeSG68h1Xo2I6iXNGy7GwcNZhgLCRUdcIz57rZbgo5+BPBjQ7R
         JUO/Nozsd5Q2wKUz0oDWYaFYHcdlJ5JU6W7VzlkxzHjvYFG3qfVgZh2GeTaSrev6m5
         IsUHT1JV+pIyqqDLUt2JRalfGyPBNrsyNqL8khHU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+e5be16aa39ad6e755391@syzkaller.appspotmail.com,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 143/158] bonding: validate ip header before check IPPROTO_IGMP
Date:   Mon, 15 Jul 2019 10:17:54 -0400
Message-Id: <20190715141809.8445-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 9d1bc24b52fb8c5d859f9a47084bf1179470e04c ]

bond_xmit_roundrobin() checks for IGMP packets but it parses
the IP header even before checking skb->protocol.

We should validate the IP header with pskb_may_pull() before
using iph->protocol.

Reported-and-tested-by: syzbot+e5be16aa39ad6e755391@syzkaller.appspotmail.com
Fixes: a2fd940f4cff ("bonding: fix broken multicast with round-robin mode")
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 37 ++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7e162fff01ab..be0b785becd0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3852,8 +3852,8 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 					struct net_device *bond_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
-	struct iphdr *iph = ip_hdr(skb);
 	struct slave *slave;
+	int slave_cnt;
 	u32 slave_id;
 
 	/* Start with the curr_active_slave that joined the bond as the
@@ -3862,23 +3862,32 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 	 * send the join/membership reports.  The curr_active_slave found
 	 * will send all of this type of traffic.
 	 */
-	if (iph->protocol == IPPROTO_IGMP && skb->protocol == htons(ETH_P_IP)) {
-		slave = rcu_dereference(bond->curr_active_slave);
-		if (slave)
-			bond_dev_queue_xmit(bond, skb, slave->dev);
-		else
-			bond_xmit_slave_id(bond, skb, 0);
-	} else {
-		int slave_cnt = READ_ONCE(bond->slave_cnt);
+	if (skb->protocol == htons(ETH_P_IP)) {
+		int noff = skb_network_offset(skb);
+		struct iphdr *iph;
 
-		if (likely(slave_cnt)) {
-			slave_id = bond_rr_gen_slave_id(bond);
-			bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
-		} else {
-			bond_tx_drop(bond_dev, skb);
+		if (unlikely(!pskb_may_pull(skb, noff + sizeof(*iph))))
+			goto non_igmp;
+
+		iph = ip_hdr(skb);
+		if (iph->protocol == IPPROTO_IGMP) {
+			slave = rcu_dereference(bond->curr_active_slave);
+			if (slave)
+				bond_dev_queue_xmit(bond, skb, slave->dev);
+			else
+				bond_xmit_slave_id(bond, skb, 0);
+			return NETDEV_TX_OK;
 		}
 	}
 
+non_igmp:
+	slave_cnt = READ_ONCE(bond->slave_cnt);
+	if (likely(slave_cnt)) {
+		slave_id = bond_rr_gen_slave_id(bond);
+		bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
+	} else {
+		bond_tx_drop(bond_dev, skb);
+	}
 	return NETDEV_TX_OK;
 }
 
-- 
2.20.1

