Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6138CF0E
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 22:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhEUU2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 16:28:49 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:19938 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhEUU2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 16:28:46 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2021 16:28:46 EDT
Received: from us226.sjc.aristanetworks.com (us226.sjc.aristanetworks.com [10.243.208.9])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 45F04400C93;
        Fri, 21 May 2021 13:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1621628475;
        bh=Un99eg4AkNyk1zOKHMfsM0il2mKb8Zw34BMQAtcO5sc=;
        h=Date:To:Subject:From:From;
        b=oOkhvbfMpdv1zQszVDzTBBQGmHVr0/Zz3ioRgMqAOyCJAIgWz3qMQvweIPoxyK9uy
         Y2DQGRMSRlF6oGcC6JxtF+jtObO0hdoVjzoN0wBBFeCHotHdo3zGHxO96mQaSXM287
         OICLeRtqaFTLGtcyTa1Ax0KF9sx9pQz+rtryH6gxUCo88FhfH46H2zCr8SCOG+N5/g
         dU1eQo90imj7hZKjJOK0ohbf6pc09tXgletJq8oTpsmMDZ1g0TwrWygsKC3FTpUw61
         DoTZ5uhLgbPmn4DaiySUUd69fjfprTOFZG/f/HeN0cfbg2IkHYH4oxaqE/EMpMb60l
         Y5qLRPOi3oUVw==
Received: by us226.sjc.aristanetworks.com (Postfix, from userid 10189)
        id 218095EC05F0; Fri, 21 May 2021 13:21:15 -0700 (PDT)
Date:   Fri, 21 May 2021 13:21:14 -0700
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edumazet@google.com, willemb@google.com,
        kuba@kernel.org, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        fruggeri@arista.com
Subject: [PATCH] ipv6: record frag_max_size in atomic fragments in input
 path
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20210521202115.218095EC05F0@us226.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dbd1759e6a9c ("ipv6: on reassembly, record frag_max_size")
filled the frag_max_size field in IP6CB in the input path.
The field should also be filled in case of atomic fragments.

Fixes: dbd1759e6a9c ('ipv6: on reassembly, record frag_max_size')
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 net/ipv6/reassembly.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 47a0dc46cbdb..28e44782c94d 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -343,7 +343,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	hdr = ipv6_hdr(skb);
 	fhdr = (struct frag_hdr *)skb_transport_header(skb);
 
-	if (!(fhdr->frag_off & htons(0xFFF9))) {
+	if (!(fhdr->frag_off & htons(IP6_OFFSET | IP6_MF))) {
 		/* It is not a fragmented frame */
 		skb->transport_header += sizeof(struct frag_hdr);
 		__IP6_INC_STATS(net,
@@ -351,6 +351,8 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 
 		IP6CB(skb)->nhoff = (u8 *)fhdr - skb_network_header(skb);
 		IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
+		IP6CB(skb)->frag_max_size = ntohs(hdr->payload_len) +
+					    sizeof(struct ipv6hdr);
 		return 1;
 	}
 
-- 
2.28.0

