Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4FD2AB57A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgKIKxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:53:02 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:21438 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbgKIKxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:53:01 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A9AqQMi011444;
        Mon, 9 Nov 2020 02:52:56 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v6 09/12] ch_ktls: don't free skb before sending FIN
Date:   Mon,  9 Nov 2020 16:21:39 +0530
Message-Id: <20201109105142.15398-10-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201109105142.15398-1-rohitm@chelsio.com>
References: <20201109105142.15398-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If its a last packet and fin is set. Make sure FIN is informed
to HW before skb gets freed.

Fixes: 429765a149f1 ("chcr: handle partial end part of a record")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c        | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index bbda71b7f98b..a8062e038ebc 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1932,6 +1932,9 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 						       flags);
 				goto out;
 			}
+
+			if (th->fin)
+				skb_get(skb);
 		}
 
 		if (unlikely(tls_record_is_start_marker(record))) {
@@ -2006,8 +2009,11 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 			__skb_frag_unref(&record->frags[i]);
 		}
 		/* if any failure, come out from the loop. */
-		if (ret)
+		if (ret) {
+			if (th->fin)
+				dev_kfree_skb_any(skb);
 			return NETDEV_TX_OK;
+		}
 
 		/* length should never be less than 0 */
 		WARN_ON(data_len < 0);
@@ -2020,8 +2026,10 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* tcp finish is set, send a separate tcp msg including all the options
 	 * as well.
 	 */
-	if (th->fin)
+	if (th->fin) {
 		chcr_ktls_write_tcp_options(tx_info, skb, q, tx_info->tx_chan);
+		dev_kfree_skb_any(skb);
+	}
 
 	return NETDEV_TX_OK;
 out:
-- 
2.18.1

