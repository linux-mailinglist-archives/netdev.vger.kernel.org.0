Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76C3E33A9
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 07:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhHGFoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 01:44:10 -0400
Received: from mx21.baidu.com ([220.181.3.85]:59046 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230377AbhHGFoK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 01:44:10 -0400
Received: from BC-Mail-Ex22.internal.baidu.com (unknown [172.31.51.16])
        by Forcepoint Email with ESMTPS id 163192238BD1E574BF5B;
        Sat,  7 Aug 2021 13:43:49 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex22.internal.baidu.com (172.31.51.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 7 Aug 2021 13:43:48 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.62.11) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 7 Aug 2021 13:43:47 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] net: bonding: bond_alb: Remove the dependency on ipx network layer
Date:   Sat, 7 Aug 2021 13:43:36 +0800
Message-ID: <20210807054336.1684-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.32.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.62.11]
X-ClientProxiedBy: BC-Mail-Ex17.internal.baidu.com (172.31.51.11) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit <47595e32869f> ("<MAINTAINERS: Mark some staging directories>")
indicated the ipx network layer as obsolete in Jan 2018,
updated in the MAINTAINERS file

now, after being exposed for 3 years to refactoring,
so to delete the ipx net layer related code for good.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/bonding/bond_alb.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 22e5632089ac..7d3752cbf761 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -17,7 +17,6 @@
 #include <linux/if_bonding.h>
 #include <linux/if_vlan.h>
 #include <linux/in.h>
-#include <net/ipx.h>
 #include <net/arp.h>
 #include <net/ipv6.h>
 #include <asm/byteorder.h>
@@ -1351,8 +1350,6 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
 		switch (skb->protocol) {
 		case htons(ETH_P_IP):
-		case htons(ETH_P_IPX):
-		    /* In case of IPX, it will falback to L2 hash */
 		case htons(ETH_P_IPV6):
 			hash_index = bond_xmit_hash(bond, skb);
 			if (bond->params.tlb_dynamic_lb) {
@@ -1454,35 +1451,6 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 		hash_size = sizeof(ip6hdr->daddr);
 		break;
 	}
-	case ETH_P_IPX: {
-		const struct ipxhdr *ipxhdr;
-
-		if (pskb_network_may_pull(skb, sizeof(*ipxhdr))) {
-			do_tx_balance = false;
-			break;
-		}
-		ipxhdr = (struct ipxhdr *)skb_network_header(skb);
-
-		if (ipxhdr->ipx_checksum != IPX_NO_CHECKSUM) {
-			/* something is wrong with this packet */
-			do_tx_balance = false;
-			break;
-		}
-
-		if (ipxhdr->ipx_type != IPX_TYPE_NCP) {
-			/* The only protocol worth balancing in
-			 * this family since it has an "ARP" like
-			 * mechanism
-			 */
-			do_tx_balance = false;
-			break;
-		}
-
-		eth_data = eth_hdr(skb);
-		hash_start = (char *)eth_data->h_dest;
-		hash_size = ETH_ALEN;
-		break;
-	}
 	case ETH_P_ARP:
 		do_tx_balance = false;
 		if (bond_info->rlb_enabled)
-- 
2.25.1

