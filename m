Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B8D485D71
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiAFAq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:46:59 -0500
Received: from www62.your-server.de ([213.133.104.62]:34958 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiAFAqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:46:55 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5GvU-000CmX-QD; Thu, 06 Jan 2022 01:46:44 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, laurent.bernaille@datadoghq.com,
        maciej.fijalkowski@intel.com, toshiaki.makita1@gmail.com,
        eric.dumazet@gmail.com, pabeni@redhat.com,
        john.fastabend@gmail.com, willemb@google.com,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next] veth: Do not record rx queue hint in veth_xmit
Date:   Thu,  6 Jan 2022 01:46:06 +0100
Message-Id: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26413/Wed Jan  5 10:23:50 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Laurent reported that they have seen a significant amount of TCP retransmissions
at high throughput from applications residing in network namespaces talking to
the outside world via veths. The drops were seen on the qdisc layer (fq_codel,
as per systemd default) of the phys device such as ena or virtio_net due to all
traffic hitting a _single_ TX queue _despite_ multi-queue device. (Note that the
setup was _not_ using XDP on veths as the issue is generic.)

More specifically, after edbea9220251 ("veth: Store queue_mapping independently
of XDP prog presence") which made it all the way back to v4.19.184+,
skb_record_rx_queue() would set skb->queue_mapping to 1 (given 1 RX and 1 TX
queue by default for veths) instead of leaving at 0.

This is eventually retained and callbacks like ena_select_queue() will also pick
single queue via netdev_core_pick_tx()'s ndo_select_queue() once all the traffic
is forwarded to that device via upper stack or other means. Similarly, for others
not implementing ndo_select_queue() if XPS is disabled, netdev_pick_tx() might
call into the skb_tx_hash() and check for prior skb_rx_queue_recorded() as well.

In general, it is a _bad_ idea for virtual devices like veth to mess around with
queue selection [by default]. Given dev->real_num_tx_queues is by default 1,
the skb->queue_mapping was left untouched, and so prior to edbea9220251 the
netdev_core_pick_tx() could do its job upon __dev_queue_xmit() on the phys device.

Unbreak this and restore prior behavior by removing the skb_record_rx_queue()
from veth_xmit() altogether.

If the veth peer has an XDP program attached, then it would return the first RX
queue index in xdp_md->rx_queue_index (unless configured in non-default manner).
However, this is still better than breaking the generic case.

Fixes: edbea9220251 ("veth: Store queue_mapping independently of XDP prog presence")
Fixes: 638264dc9022 ("veth: Support per queue XDP ring")
Reported-by: Laurent Bernaille <laurent.bernaille@datadoghq.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 drivers/net/veth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d21dd25f429e..354a963075c5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -335,7 +335,6 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 		 */
 		use_napi = rcu_access_pointer(rq->napi) &&
 			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
-		skb_record_rx_queue(skb, rxq);
 	}
 
 	skb_tx_timestamp(skb);
-- 
2.21.0

