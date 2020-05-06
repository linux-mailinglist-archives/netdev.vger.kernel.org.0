Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DAC1C734A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 16:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgEFOsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 10:48:54 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:43439 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgEFOsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 10:48:54 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 046EmaCK024883;
        Wed, 6 May 2020 07:48:37 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        manojmalaviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next] Revert "crypto: chelsio - Inline single pdu only"
Date:   Wed,  6 May 2020 20:17:19 +0530
Message-Id: <20200506144719.3725-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 27c6feb0fb33a665a746346e76714826a5be5d10.

For ipsec offload the chelsio's ethernet driver expects a single mtu
sized packet.

But when ipsec traffic is running using iperf, most of the packets in
that traffic are gso packets(large sized skbs) because GSO is enabled by
default in TCP, due to this commit 0a6b2a1dc2a2 ("tcp: switch to GSO
being always on"), so chcr_ipsec_offload_ok() receives a gso
skb(with gso_size non zero).

Due to the check in chcr_ipsec_offload_ok(), this function returns false
for most of the packet, then ipsec offload is skipped and the skb goes
out taking the coprocessor path which reduces the bandwidth for inline
ipsec.

If this check is removed then for most of the packets(large sized skbs)
the chcr_ipsec_offload_ok() returns true and then as GSO is on, the
segmentation of the packet happens in the kernel and then finally the
driver_xmit is called, which receives a segmented mtu sized packet which
is what the driver expects for ipsec offload. So this case becomes
unnecessary here, therefore removing it.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ipsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 9fd3b9d1ec2f..d25689837b26 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -294,9 +294,6 @@ static bool chcr_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 		if (ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr))
 			return false;
 	}
-	/* Inline single pdu */
-	if (skb_shinfo(skb)->gso_size)
-		return false;
 	return true;
 }
 
-- 
2.26.0.rc1.11.g30e9940

