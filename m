Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690FACF837
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbfJHLbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:31:06 -0400
Received: from aer-iport-1.cisco.com ([173.38.203.51]:21497 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbfJHLbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3824; q=dns/txt; s=iport;
  t=1570534261; x=1571743861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Ccxp2coW7rlBrv4uxUTfVMSxGQfd+xBYrLzxbdb8ApM=;
  b=GNXddqAQUhl3rpNAmmuLvwwKZFo9yNyD6c7U5B9QwvaET0uNRpRtKnIh
   GXwd+6aZKHkg9vzZEnUlLzqvKiYtZeX/GiXyH1ZYgdqv35WlT+OULqBrC
   ctVZummc3GGbJKb6m35AF4aBwH1vlNHVQk48/i1mDzxZ/St2c8KZIKRsX
   4=;
X-IronPort-AV: E=Sophos;i="5.67,270,1566864000"; 
   d="scan'208";a="17754320"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Oct 2019 11:23:55 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id x98BNe52031991;
        Tue, 8 Oct 2019 11:23:54 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     Georg Kohmann <geokohma@cisco.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 stable 04/10] netfilter: ipv6: nf_defrag: Pass on packets to stack per RFC2460
Date:   Tue,  8 Oct 2019 13:23:03 +0200
Message-Id: <20191008112309.9571-5-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
In-Reply-To: <20191008112309.9571-1-geokohma@cisco.com>
References: <20191008112309.9571-1-geokohma@cisco.com>
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit d65bc9545fd3 ("netfilter: ipv6: nf_defrag: Pass on packets to stack
per RFC2460")
Author: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date:   Fri Jan 12 17:36:27 2018 -0700

[ Upstream commit 83f1999caeb14e15df205e80d210699951733287 ]

ipv6_defrag pulls network headers before fragment header. In case of
an error, the netfilter layer is currently dropping these packets.
This results in failure of some IPv6 standards tests which passed on
older kernels due to the netfilter framework using cloning.

The test case run here is a check for ICMPv6 error message replies
when some invalid IPv6 fragments are sent. This specific test case is
listed in https://www.ipv6ready.org/docs/Core_Conformance_Latest.pdf
in the Extension Header Processing Order section.

A packet with unrecognized option Type 11 is sent and the test expects
an ICMP error in line with RFC2460 section 4.2 -

11 - discard the packet and, only if the packet's Destination
    Address was not a multicast address, send an ICMP Parameter
    Problem, Code 2, message to the packet's Source Address,
    pointing to the unrecognized Option Type.

Since netfilter layer now drops all invalid IPv6 frag packets, we no
longer see the ICMP error message and fail the test case.

To fix this, save the transport header. If defrag is unable to process
the packet due to RFC2460, restore the transport header and allow packet
to be processed by stack. There is no change for other packet
processing paths.

Tested by confirming that stack sends an ICMP error when it receives
these packets. Also tested that fragmented ICMP pings succeed.

v1->v2: Instead of cloning always, save the transport_header and
restore it in case of this specific error. Update the title and
commit message accordingly.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 0a85de9..394aeb1 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -203,7 +203,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 
 	if ((unsigned int)end > IPV6_MAXPLEN) {
 		pr_debug("offset is too large.\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	ecn = ip6_frag_ecn(ipv6_hdr(skb));
@@ -236,7 +236,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 			 * this case. -DaveM
 			 */
 			pr_debug("end of fragment not rounded to 8 bytes.\n");
-			return -1;
+			return -EPROTO;
 		}
 		if (end > fq->q.len) {
 			/* Some bits beyond end -> corruption. */
@@ -330,7 +330,7 @@ found:
 discard_fq:
 	inet_frag_kill(&fq->q);
 err:
-	return -1;
+	return -EINVAL;
 }
 
 /*
@@ -538,6 +538,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 
 int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 {
+	u16 savethdr = skb->transport_header;
 	struct net_device *dev = skb->dev;
 	int fhoff, nhoff, ret;
 	struct frag_hdr *fhdr;
@@ -572,8 +573,12 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 		return -ENOMEM;
 	spin_lock_bh(&fq->q.lock);
 
-	if (nf_ct_frag6_queue(fq, skb, fhdr, nhoff) < 0) {
-		ret = -EINVAL;
+	ret = nf_ct_frag6_queue(fq, skb, fhdr, nhoff);
+	if (ret < 0) {
+		if (ret == -EPROTO) {
+			skb->transport_header = savethdr;
+			ret = 0;
+		}
 		goto out_unlock;
 	}
 
-- 
2.10.2

