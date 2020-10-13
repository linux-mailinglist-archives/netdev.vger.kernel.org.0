Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F211A28CE45
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 14:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgJMMYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 08:24:03 -0400
Received: from aer-iport-4.cisco.com ([173.38.203.54]:56530 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgJMMYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 08:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1210; q=dns/txt; s=iport;
  t=1602591843; x=1603801443;
  h=from:to:cc:subject:date:message-id;
  bh=imvnwR2b/Qb1Zv2bukYGNNj3ZK7ofBjSiQJ1wCM2eU0=;
  b=fT+BGsno5xLBet5drgytlZUkJ9EKs1Jga5ewFqNhZwc0SWP9jqIl8fe0
   kWZMsfysXW52nBQjdnCn8/d5gWfLxhKm027xlVsAB7pjVts1vSvMb0ZJ+
   e5sfz+dpNgsTfB4f0E34JWMLHEw+ZL6z4dwqONaP8pZxTZwQvqzc14MO6
   E=;
X-IronPort-AV: E=Sophos;i="5.77,370,1596499200"; 
   d="scan'208";a="30256835"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 13 Oct 2020 12:24:01 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 09DCO1uJ011822;
        Tue, 13 Oct 2020 12:24:01 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        Georg Kohmann <geokohma@cisco.com>
Subject: [PATCH net V2] netfilter: Drop fragmented ndisc packets assembled in netfilter
Date:   Tue, 13 Oct 2020 14:23:12 +0200
Message-Id: <20201013122312.8761-1-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-1.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fragmented ndisc packets assembled in netfilter not dropped as specified
in RFC 6980, section 5. This behaviour breaks TAHI IPv6 Core Conformance
Tests v6LC.2.1.22/23, V6LC.2.2.26/27 and V6LC.2.3.18.

Setting IP6SKB_FRAGMENTED flag during reassembly.

References: commit b800c3b966bc ("ipv6: drop fragmented ndisc packets by
default (RFC 6980)")
Signed-off-by: Georg Kohmann <geokohma@cisco.com>
---

V2: Fix spelling of IPSKB_FRAGMENTED to IP6SKB_FRAGMENTED in comment

 net/ipv6/netfilter/nf_conntrack_reasm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index fed9666..054d287 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -355,6 +355,7 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	ipv6_hdr(skb)->payload_len = htons(payload_len);
 	ipv6_change_dsfield(ipv6_hdr(skb), 0xff, ecn);
 	IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
+	IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
 
 	/* Yes, and fold redundant checksum back. 8) */
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
-- 
2.10.2

