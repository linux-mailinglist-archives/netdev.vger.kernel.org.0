Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2381980A2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbgC3QLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:11:42 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:8246 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3QLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:11:42 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02UGBX9p027147;
        Mon, 30 Mar 2020 09:11:34 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     kuba@kernel.org, borisp@mellanox.com, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next] crypto/chcr: fix incorrect ipv6 packet length
Date:   Mon, 30 Mar 2020 21:41:22 +0530
Message-Id: <20200330161122.15314-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 header's payload length field shouldn't include IPv6 header length.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ktls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 00099e793e63..73658b71d4a3 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -981,7 +981,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 		ip->tot_len = htons(pktlen - maclen);
 	} else {
 		ip6 = (struct ipv6hdr *)(buf + maclen);
-		ip6->payload_len = htons(pktlen - maclen);
+		ip6->payload_len = htons(pktlen - maclen - iplen);
 	}
 	/* now take care of the tcp header, if fin is not set then clear push
 	 * bit as well, and if fin is set, it will be sent at the last so we
-- 
2.18.1

