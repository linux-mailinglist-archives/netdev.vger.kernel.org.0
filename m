Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60B85EBD4D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiI0Iaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiI0IaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:30:23 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98187A407D
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:30:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VQr0FBg_1664267413;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VQr0FBg_1664267413)
          by smtp.aliyun-inc.com;
          Tue, 27 Sep 2022 16:30:14 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
Date:   Tue, 27 Sep 2022 16:30:13 +0800
Message-Id: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current processing logic, when xdp_redirect occurs, it transmits
the xdp frame based on napi.

If napi of the peer veth is not ready, the veth will drop the packets.
This doesn't meet our expectations.

In this context, if napi is not ready, we convert the xdp frame to a skb,
and then use veth_xmit() to deliver it to the peer veth.

Like the following case:
Even if veth1's napi cannot be used, the packet redirected from the NIC
will be transmitted to veth1 successfully:

NIC   ->   veth0----veth1
 |                   |
(XDP)             (no XDP)

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/veth.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 466da01..e1f5561 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -469,8 +469,42 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	/* The napi pointer is set if NAPI is enabled, which ensures that
 	 * xdp_ring is initialized on receive side and the peer device is up.
 	 */
-	if (!rcu_access_pointer(rq->napi))
+	if (!rcu_access_pointer(rq->napi)) {
+		for (i = 0; i < n; i++) {
+			struct xdp_frame *xdpf = frames[i];
+			struct netdev_queue *txq = NULL;
+			struct sk_buff *skb;
+			int queue_mapping;
+			u16 mac_len;
+
+			skb = xdp_build_skb_from_frame(xdpf, dev);
+			if (unlikely(!skb)) {
+				ret = nxmit;
+				goto out;
+			}
+
+			/* We need to restore ETH header, because it is pulled
+			 * in eth_type_trans.
+			 */
+			mac_len = skb->data - skb_mac_header(skb);
+			skb_push(skb, mac_len);
+
+			nxmit++;
+
+			queue_mapping = skb_get_queue_mapping(skb);
+			txq = netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, queue_mapping));
+			__netif_tx_lock(txq, smp_processor_id());
+			if (unlikely(veth_xmit(skb, dev) != NETDEV_TX_OK)) {
+				__netif_tx_unlock(txq);
+				ret = nxmit;
+				goto out;
+			}
+			__netif_tx_unlock(txq);
+		}
+
+		ret = nxmit;
 		goto out;
+	}
 
 	max_len = rcv->mtu + rcv->hard_header_len + VLAN_HLEN;
 
-- 
1.8.3.1

