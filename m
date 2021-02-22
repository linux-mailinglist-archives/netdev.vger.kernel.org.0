Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D758322081
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhBVTwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:52:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231326AbhBVTwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:52:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614023454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8HR1V1PEJZUHvsgCjR9y0BSATwd2Ojt2c/7KCE8Moeo=;
        b=EU3pUp54anGKBdinCEbQbu9Uk8u85AM+5/zIB7Koe+pkfy66RAiEts/fHBXOfJkd+gr0sY
        hajFV9mytj9VVG9V7oTTnbllAAraK7Cn2+Hdz86XJXrTBA21vlv21xkCNSoWMOZaTz8Ekm
        7VIaN0hNLfF7cskYaSA56bqDQDdb5H4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-Y57ap3dGOOa8RWp2ZFbkAA-1; Mon, 22 Feb 2021 14:50:50 -0500
X-MC-Unique: Y57ap3dGOOa8RWp2ZFbkAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E654418A0838;
        Mon, 22 Feb 2021 19:50:48 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B33D160C04;
        Mon, 22 Feb 2021 19:50:45 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 6016F30736C73;
        Mon, 22 Feb 2021 20:50:44 +0100 (CET)
Subject: [PATCH RFC net-next] mlx5: fix for crash on net-next
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, saeedm@nvidia.com,
        Tariq Toukan <tariqt@mellanox.com>, eranbe@nvidia.com,
        maximmi@mellanox.com
Date:   Mon, 22 Feb 2021 20:50:44 +0100
Message-ID: <161402344429.1980160.4798557236979159924.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Net-next at commit d310ec03a34e ("Merge tag 'perf-core-2021-02-17')

There is a divide error in drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
where it seems that num_tc_x_num_ch can become zero in a modulo operation:

	if (unlikely(txq_ix >= num_tc_x_num_ch))
		txq_ix %= num_tc_x_num_ch;

I think error were introduced in:
 - 214baf22870c ("net/mlx5e: Support HTB offload")

The modulo operation was introduced in:
 - 145e5637d941 ("net/mlx5e: Add TX PTP port object support")

The crash looks like this:

[   12.112849] divide error: 0000 [#1] PREEMPT SMP PTI
[   12.117727] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 5.11.0-net-next+ #575
[   12.124677] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0a 08/01/2016
[   12.132149] RIP: 0010:mlx5e_select_queue+0xd5/0x1e0 [mlx5_core]
[   12.138110] Code: 85 c0 75 2e 48 83 bb 08 57 00 00 00 75 5b 31 d2 48 89 ee 48 89 df e8 ba 3e 54 e1 0f b7 d0 41 39 d4 0f 8f 6b ff ff ff 89 d0 99 <41> f7 fc e9 60 ff ff ff 8b 96 8c 00 00 00 89 d1 c1 e9 10 39 c1 0f
[   12.156849] RSP: 0018:ffffc900001c0c10 EFLAGS: 00010297
[   12.162065] RAX: 0000000000000004 RBX: ffff88810ff00000 RCX: 0000000000000007
[   12.169188] RDX: 0000000000000000 RSI: ffff888107016400 RDI: ffff8881008dc740
[   12.176313] RBP: ffff888107016400 R08: 0000000000000000 R09: 000000ncing: Fatal exception in interrupt ]---

This is an RFC, because I don't think this is a proper fix, but
at least it allows me to boot with mlx5 driver enabled.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index bdbffe484fce..4dc26c1f2b53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -131,6 +131,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	int ch_ix;
 
 	/* Sync with mlx5e_update_num_tc_x_num_ch - avoid refetching. */
+	// XXX this reading of num_tc_x_num_ch looks strange
 	num_tc_x_num_ch = READ_ONCE(priv->num_tc_x_num_ch);
 	if (unlikely(dev->real_num_tx_queues > num_tc_x_num_ch)) {
 		/* Order maj_id before defcls - pairs with mlx5e_htb_root_add. */
@@ -142,19 +143,21 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 				return txq_ix;
 		}
 
-		if (unlikely(priv->channels.port_ptp))
+		txq_ix = netdev_pick_tx(dev, skb, NULL);
+
+		if (unlikely(priv->channels.port_ptp)) {
 			if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 			    mlx5e_use_ptpsq(skb))
 				return mlx5e_select_ptpsq(dev, skb);
 
-		txq_ix = netdev_pick_tx(dev, skb, NULL);
 		/* Fix netdev_pick_tx() not to choose ptp_channel and HTB txqs.
 		 * If they are selected, switch to regular queues.
 		 * Driver to select these queues only at mlx5e_select_ptpsq()
 		 * and mlx5e_select_htb_queue().
 		 */
-		if (unlikely(txq_ix >= num_tc_x_num_ch))
-			txq_ix %= num_tc_x_num_ch;
+			if (unlikely(txq_ix >= num_tc_x_num_ch))
+				txq_ix %= num_tc_x_num_ch;
+		}
 	} else {
 		txq_ix = netdev_pick_tx(dev, skb, NULL);
 	}


