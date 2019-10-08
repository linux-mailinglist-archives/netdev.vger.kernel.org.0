Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802F6CF835
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbfJHLbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:31:04 -0400
Received: from aer-iport-4.cisco.com ([173.38.203.54]:6372 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730572AbfJHLbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3269; q=dns/txt; s=iport;
  t=1570534263; x=1571743863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=WYkHRKnQ9Vjzb+6rPcA4fQ7x4cAW19V5WvtN4UhYY4s=;
  b=FKm9J+WUSqVRDz7mVkpc2AooxaHLRfZMWDwK1OYa9wCATbIUnwCTaA57
   Z2iQY0GOg91VTDMFQKD2xE8iTQRFOqH3wrBI6+Qu8S5kR+VWvTlHq/1xc
   g8Dn/rTVm24INx1S6IisMNoMfYML589sN2PerYI78LoXZ0O8gOXZdD5vQ
   w=;
X-IronPort-AV: E=Sophos;i="5.67,270,1566864000"; 
   d="scan'208";a="17697351"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Oct 2019 11:23:56 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id x98BNe54031991;
        Tue, 8 Oct 2019 11:23:56 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     Georg Kohmann <geokohma@cisco.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 stable 06/10] ipv6: frags: fix a lockdep false positive
Date:   Tue,  8 Oct 2019 13:23:05 +0200
Message-Id: <20191008112309.9571-7-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
In-Reply-To: <20191008112309.9571-1-geokohma@cisco.com>
References: <20191008112309.9571-1-geokohma@cisco.com>
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 415787d7799f ("ipv6: frags: fix a lockdep false positive")
From: Eric Dumazet <edumazet@google.com> 

lockdep does not know that the locks used by IPv4 defrag
and IPv6 reassembly units are of different classes.

It complains because of following chains :

1) sch_direct_xmit()        (lock txq->_xmit_lock)
    dev_hard_start_xmit()
     xmit_one()
      dev_queue_xmit_nit()
       packet_rcv_fanout()
        ip_check_defrag()
         ip_defrag()
          spin_lock()     (lock frag queue spinlock)

2) ip6_input_finish()
    ipv6_frag_rcv()       (lock frag queue spinlock)
     ip6_frag_queue()
      icmpv6_param_prob() (lock txq->_xmit_lock at some point)

We could add lockdep annotations, but we also can make sure IPv6
calls icmpv6_param_prob() only after the release of the frag queue spinlock,
since this naturally makes frag queue spinlock a leaf in lock hierarchy.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv6/reassembly.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 2842ccf..c708fc5 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -169,7 +169,8 @@ fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif)
 }
 
 static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
-			   struct frag_hdr *fhdr, int nhoff)
+			  struct frag_hdr *fhdr, int nhoff,
+			  u32 *prob_offset)
 {
 	struct sk_buff *prev, *next;
 	struct net_device *dev;
@@ -185,11 +186,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 			((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));
 
 	if ((unsigned int)end > IPV6_MAXPLEN) {
-		IP6_INC_STATS_BH(net, ip6_dst_idev(skb_dst(skb)),
-				 IPSTATS_MIB_INHDRERRORS);
-		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD,
-				  ((u8 *)&fhdr->frag_off -
-				   skb_network_header(skb)));
+		*prob_offset = (u8 *)&fhdr->frag_off - skb_network_header(skb);
 		return -1;
 	}
 
@@ -220,10 +217,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 			/* RFC2460 says always send parameter problem in
 			 * this case. -DaveM
 			 */
-			IP6_INC_STATS_BH(net, ip6_dst_idev(skb_dst(skb)),
-					 IPSTATS_MIB_INHDRERRORS);
-			icmpv6_param_prob(skb, ICMPV6_HDR_FIELD,
-					  offsetof(struct ipv6hdr, payload_len));
+			*prob_offset = offsetof(struct ipv6hdr, payload_len);
 			return -1;
 		}
 		if (end > fq->q.len) {
@@ -524,15 +518,22 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	iif = skb->dev ? skb->dev->ifindex : 0;
 	fq = fq_find(net, fhdr->identification, hdr, iif);
 	if (fq) {
+		u32 prob_offset = 0;
 		int ret;
 
 		spin_lock(&fq->q.lock);
 
 		fq->iif = iif;
-		ret = ip6_frag_queue(fq, skb, fhdr, IP6CB(skb)->nhoff);
+		ret = ip6_frag_queue(fq, skb, fhdr, IP6CB(skb)->nhoff,
+				     &prob_offset);
 
 		spin_unlock(&fq->q.lock);
 		inet_frag_put(&fq->q);
+		if (prob_offset) {
+			IP6_INC_STATS_BH(net, ip6_dst_idev(skb_dst(skb)),
+					IPSTATS_MIB_INHDRERRORS);
+			icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, prob_offset);
+		}
 		return ret;
 	}
 
-- 
2.10.2

