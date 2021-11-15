Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8C74509B3
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhKOQfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:35:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhKOQfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 11:35:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DA8E61221;
        Mon, 15 Nov 2021 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636993927;
        bh=UVdD89U3d4cJIOBiSUiD3z9TlIVpRIoLeezxdld3PHQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Z2TSIOm/4NgY5aAKpRxcGfjvvLrfIosAyMH/s+EgMi3IbTkYxvf0VuLy4CoxenbM7
         fVT1GGhlIE4kgTC5GinJBS8NUJLEhPgq1hcb1wEl7J+BT61bAhgAnhbh8M1CCPz0BP
         jlpnCZVzxzrI/J//ZNK3aJD5PeRhBfUDYDUXmB0e59P5AjG6J8UU7O0qBWZOuIjIMx
         xk1PDgk0SRIB7kyTBS1zn1nM00CGFHZI0R1FkkZpB5rjyPt2qp88AxmAvfWcEObFlB
         hso790zVr7m7aAAD9etvOmCDViRwdFXP25Bd+Ls63RTP1CZm+dly2FzHCpyj8HbHJC
         H2S/OePRVgBRA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, hawk@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Subject: [RFC net-next] net: guard drivers against shared skbs
Date:   Mon, 15 Nov 2021 08:32:05 -0800
Message-Id: <20211115163205.1116673-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d8873315065f ("net: add IFF_SKB_TX_SHARED flag to priv_flags")
introduced IFF_SKB_TX_SHARED to protect drivers which are not ready
for getting shared skbs from pktgen sending such frames.

Some drivers dutifully clear the flag but most don't, even though
they modify the skb or call skb helpers which expect private skbs.

syzbot has also discovered more sources of shared skbs than just
pktgen (e.g. llc).

I think defaulting to opt-in is doing more harm than good, those
who care about fast pktgen should inspect their drivers and opt-in.
It's far too risky to enable this flag in ether_setup().

Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/dummy.c | 1 +
 net/core/dev.c      | 4 ++++
 net/ethernet/eth.c  | 1 -
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index f82ad7419508..530eaaee2d25 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -123,6 +123,7 @@ static void dummy_setup(struct net_device *dev)
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_TX_SKB_SHARING;
 	dev->features	|= NETIF_F_SG | NETIF_F_FRAGLIST;
 	dev->features	|= NETIF_F_GSO_SOFTWARE;
 	dev->features	|= NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_LLTX;
diff --git a/net/core/dev.c b/net/core/dev.c
index 15ac064b5562..476a826bb4f0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3661,6 +3661,10 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 	if (unlikely(!skb))
 		goto out_null;
 
+	if (unlikely(skb_shared(skb)) &&
+	    !(dev->priv_flags & IFF_TX_SKB_SHARING))
+		goto out_kfree_skb;
+
 	skb = sk_validate_xmit_skb(skb, dev);
 	if (unlikely(!skb))
 		goto out_null;
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index c7d9e08107cb..a55a39c77211 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -366,7 +366,6 @@ void ether_setup(struct net_device *dev)
 	dev->addr_len		= ETH_ALEN;
 	dev->tx_queue_len	= DEFAULT_TX_QUEUE_LEN;
 	dev->flags		= IFF_BROADCAST|IFF_MULTICAST;
-	dev->priv_flags		|= IFF_TX_SKB_SHARING;
 
 	eth_broadcast_addr(dev->broadcast);
 
-- 
2.31.1

