Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFA7F3CD9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfKHA1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:42 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:39591 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfKHA1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:42 -0500
Received: by mail-pl1-f202.google.com with SMTP id w11so2931819ply.6
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FvxoAlL8TjKq1ayM40mHmaLZLOH2s4XTL50NN/ZCJp8=;
        b=idYM1KqdLtBd8LxbugvQxrUHJMQylsGGUo5y6GckOqzpKYb0Vr1F8WRHj/+mflG2rl
         n7s9muF6uibGCoqpc3ajffn5oY/ycIz6juFYb6KmHaaVGfw9k37q2eoH3B/5XKAMinjM
         53Jnd7gTr7txzqGrvhMWOJmdQxAApWqU7Bq+fkSmVsqaTno8+LWWs5XZWBlKqJTXXiYF
         VCvLlj0LIu6fEIdKMKB0PjPxH3hdDZ545ON0jIbSsPzwTL2Y55nVTf489tRg3l6CGpTo
         y00BYz0zcGyeMD4gb4pVD/Gdda8Xds8axewypoz35kfeKXSQGaw2lMvZFEdUI20DsklB
         qC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FvxoAlL8TjKq1ayM40mHmaLZLOH2s4XTL50NN/ZCJp8=;
        b=phC11Iiq9qfc+e6afBVwcpkG4vG8d18VKvgzwqRxCK0wd10zmS+C5wc7JPVWeK28/0
         vC555xiaCa7igFASReAyYFH5hTDZMkBtAHcr6MfULosI4Z07ZaAlvFNXaYT1jQVJB1JU
         jyH4ASS2lKh8+keP+B2J+n3/7Z9QGetXOpb9Pa9T/AeWfiMJWwK1TUiZPb4P+eVVW4tm
         Eza9I9xIJkdy3eBO7JfP3hdj72n6ZcFsQxjtn9iL3n9DxE9jE0UdKlDFzGphI++SNsRQ
         NzSqZUsXAc7cd9j6IMRdTQ1hoes7M/NipoiCJd4wLlzymO+TyRB+Ee23k24cEK84YvZ8
         wUDA==
X-Gm-Message-State: APjAAAV//ZhYGtEJ8dTMOpuzXGvjBl09s4xOjn5OI24mj19uVomQHeJe
        oeKDcz3ArPJ1/jqlQme45SEAWg8ZkOej7g==
X-Google-Smtp-Source: APXvYqz99+3K5rjEjD3HPKzgoDSHH+ePT2chZJP46Nxu0tEQAzuxd0KqwOMEkBf07WnBOP5TuiNmcX3Jy035lg==
X-Received: by 2002:a63:e444:: with SMTP id i4mr8452701pgk.247.1573172861144;
 Thu, 07 Nov 2019 16:27:41 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:17 -0800
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
Message-Id: <20191108002722.129055-5-edumazet@google.com>
Mime-Version: 1.0
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 4/9] veth: use standard dev_lstats_add() and dev_lstats_read()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This cleanup will ease u64_stats_t adoption in a single location.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/veth.c | 43 +++++++++++--------------------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 9f3c839f9e5f2cda2f103f943f94badc09691a2b..a552df37a347c72fed84909c45188e5dd1201df7 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -260,14 +260,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 	if (likely(veth_forward_skb(rcv, skb, rq, rcv_xdp) == NET_RX_SUCCESS)) {
-		if (!rcv_xdp) {
-			struct pcpu_lstats *stats = this_cpu_ptr(dev->lstats);
-
-			u64_stats_update_begin(&stats->syncp);
-			stats->bytes += length;
-			stats->packets++;
-			u64_stats_update_end(&stats->syncp);
-		}
+		if (!rcv_xdp)
+			dev_lstats_add(dev, length);
 	} else {
 drop:
 		atomic64_inc(&priv->dropped);
@@ -281,26 +275,11 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static u64 veth_stats_tx(struct pcpu_lstats *result, struct net_device *dev)
+static u64 veth_stats_tx(struct net_device *dev, u64 *packets, u64 *bytes)
 {
 	struct veth_priv *priv = netdev_priv(dev);
-	int cpu;
-
-	result->packets = 0;
-	result->bytes = 0;
-	for_each_possible_cpu(cpu) {
-		struct pcpu_lstats *stats = per_cpu_ptr(dev->lstats, cpu);
-		u64 packets, bytes;
-		unsigned int start;
 
-		do {
-			start = u64_stats_fetch_begin_irq(&stats->syncp);
-			packets = stats->packets;
-			bytes = stats->bytes;
-		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
-		result->packets += packets;
-		result->bytes += bytes;
-	}
+	dev_lstats_read(dev, packets, bytes);
 	return atomic64_read(&priv->dropped);
 }
 
@@ -335,11 +314,11 @@ static void veth_get_stats64(struct net_device *dev,
 	struct veth_priv *priv = netdev_priv(dev);
 	struct net_device *peer;
 	struct veth_rq_stats rx;
-	struct pcpu_lstats tx;
+	u64 packets, bytes;
 
-	tot->tx_dropped = veth_stats_tx(&tx, dev);
-	tot->tx_bytes = tx.bytes;
-	tot->tx_packets = tx.packets;
+	tot->tx_dropped = veth_stats_tx(dev, &packets, &bytes);
+	tot->tx_bytes = bytes;
+	tot->tx_packets = packets;
 
 	veth_stats_rx(&rx, dev);
 	tot->rx_dropped = rx.xdp_drops;
@@ -349,9 +328,9 @@ static void veth_get_stats64(struct net_device *dev,
 	rcu_read_lock();
 	peer = rcu_dereference(priv->peer);
 	if (peer) {
-		tot->rx_dropped += veth_stats_tx(&tx, peer);
-		tot->rx_bytes += tx.bytes;
-		tot->rx_packets += tx.packets;
+		tot->rx_dropped += veth_stats_tx(peer, &packets, &bytes);
+		tot->rx_bytes += bytes;
+		tot->rx_packets += packets;
 
 		veth_stats_rx(&rx, peer);
 		tot->tx_bytes += rx.xdp_bytes;
-- 
2.24.0.432.g9d3f5f5b63-goog

