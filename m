Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2658B3ACE68
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhFRPSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230399AbhFRPSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 11:18:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE3A76127C;
        Fri, 18 Jun 2021 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624029356;
        bh=PYFFcI/UJL7LHsxUc4/EJ9Svbgt9L2slws6LkcdA7PU=;
        h=From:To:Cc:Subject:Date:From;
        b=KSPrXArhY4I3sezClpFdjOD86ENtqpW5f7IGDV3em/CKR4ADZ6FNN1yQ9tECFDgYK
         B87zjCizzjsAZqzhuKMM9CmcTqmXbz6MtHVrcRZ9UezNsx+p+b2Upk8g9d1ZYLMhIk
         VX+jWfsvH6LKh47wqgEcdhYJzL3z8Vf74t94j8KSflIHxqC9jGEUQ3K3YinsnnlK2K
         ln1FoCUL8r3aiFMXDrdOEQ46zj/F+o5VTS7LaBVcnlO5rG/9J+giXFwuQkj+fuzAEK
         GSY/jb5V6oztdKODMBed6UTsRwUObFEgJtySUkNM1qxW4xcialWalFTMY7TvenKVZ6
         I9Mc5Ak+yi99A==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] vrf: do not push non-ND strict packets with a source LLA through packet taps again
Date:   Fri, 18 Jun 2021 17:15:53 +0200
Message-Id: <20210618151553.59456-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Non-ND strict packets with a source LLA go through the packet taps
again, while non-ND strict packets with other source addresses do not,
and we can see a clone of those packets on the vrf interface (we should
not). This is due to a series of changes:

Commit 6f12fa775530[1] made non-ND strict packets not being pushed again
in the packet taps. This changed with commit 205704c618af[2] for those
packets having a source LLA, as they need a lookup with the orig_iif.

The issue now is those packets do not skip the 'vrf_ip6_rcv' function to
the end (as the ones without a source LLA) and go through the check to
call packet taps again. This check was changed by commit 6f12fa775530[1]
and do not exclude non-strict packets anymore. Packets matching
'need_strict && !is_ndisc && is_ll_src' are now being sent through the
packet taps again. This can be seen by dumping packets on the vrf
interface.

Fix this by having the same code path for all non-ND strict packets and
selectively lookup with the orig_iif for those with a source LLA. This
has the effect to revert to the pre-205704c618af[2] condition, which
should also be easier to maintain.

[1] 6f12fa775530 ("vrf: mark skb for multicast or link-local as enslaved to VRF")
[2] 205704c618af ("vrf: packets with lladdr src needs dst at input with orig_iif when needs strict")

Fixes: 205704c618af ("vrf: packets with lladdr src needs dst at input with orig_iif when needs strict")
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/vrf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 28a6c4cfe9b8..414afcb0a23f 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1366,22 +1366,22 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 	int orig_iif = skb->skb_iif;
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
-	bool is_ll_src;
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
-	 * for packets with lladdr src, however, skip so that the dst can be
-	 * determine at input using original ifindex in the case that daddr
-	 * needs strict
+	 * For strict packets with a source LLA, determine the dst using the
+	 * original ifindex.
 	 */
-	is_ll_src = ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL;
-	if (skb->pkt_type == PACKET_LOOPBACK ||
-	    (need_strict && !is_ndisc && !is_ll_src)) {
+	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
+
 		if (skb->pkt_type == PACKET_LOOPBACK)
 			skb->pkt_type = PACKET_HOST;
+		else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)
+			vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
+
 		goto out;
 	}
 
-- 
2.31.1

