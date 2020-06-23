Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039612062C2
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393278AbgFWVHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:07:35 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:26193 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391607AbgFWUfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:35:08 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKYucV019545;
        Tue, 23 Jun 2020 13:34:57 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 08/12] cxgb4: remove cast when saving IPv4 partial checksum
Date:   Wed, 24 Jun 2020 01:51:38 +0530
Message-Id: <cb8a57ddf00aa4ac4de71df85346cc9f78d0ee2b.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The checksum field in IPv4 header is in __sum16 and ip_fast_csum()
also returns __sum16. So, no need to cast it to u16.

Fixes following sparse warning:
sge.c:1539:47: warning: cast from restricted __sum16
sge.c:1539:44: warning: incorrect type in assignment (different base types)
sge.c:1539:44:    expected restricted __sum16 [usertype] check
sge.c:1539:44:    got unsigned short [usertype]

Fixes: d0a1299c6bf7 ("cxgb4: add support for vxlan segmentation offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 3c8b4b153ec4..72ff46b16704 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1524,8 +1524,7 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 			if (iph->version == 4) {
 				iph->check = 0;
 				iph->tot_len = 0;
-				iph->check = (u16)(~ip_fast_csum((u8 *)iph,
-								 iph->ihl));
+				iph->check = ~ip_fast_csum((u8 *)iph, iph->ihl);
 			}
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
 				cntrl = hwcsum(adap->params.chip, skb);
-- 
2.24.0

