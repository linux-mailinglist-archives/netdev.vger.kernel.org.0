Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36174957AC
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 02:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242582AbiAUBT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 20:19:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40432 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242153AbiAUBTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 20:19:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4D9EB81E61
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 01:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D99EC340E0;
        Fri, 21 Jan 2022 01:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642727986;
        bh=7pMKkNjix+KdWNakPdZrJl/EBdEl58US1mH9yPzX1uM=;
        h=From:To:Cc:Subject:Date:From;
        b=qILZYKSJD1v92c5x8Q1Wgnsmw7RP2vnBNmwS6mpLLf/+MNZzSwPOeMTThgTyfM3us
         uS0W0pJpdRa1KhstLiY8WkSIxXNXwI5dbJlOVMeJMP7OXV08pZX09bBBOkgSd+lmJr
         l/m+oZ1/VlJeBknKEFRmHqFoBTxkeUI6Wkx/ea0MzvNNtLUzUxbItjqyD8f41SJ1Lp
         VUwrVqJeboj1o3wHgyXzDyvxuuUCrHMt4jf5XnSNjK3XqZTXKXIPBgDOtc0g4XNje3
         EzHv8/jy5sal4CbLg9Yr6kwgumVI1uNIsC0hjyibl3bR58Og5dKnLV0KDWHnNKhhq8
         8/UWo4UrGj6wg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, edumazet@google.com
Cc:     dsahern@gmail.com, pabeni@redhat.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ipv6: gro: flush instead of assuming different flows on hop_limit mismatch
Date:   Thu, 20 Jan 2022 17:19:41 -0800
Message-Id: <20220121011941.1123392-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 GRO considers packets to belong to different flows when their
hop_limit is different. This seems counter-intuitive, the flow is
the same. hop_limit may vary because of various bugs or hacks but
that doesn't mean it's okay for GRO to reorder packets.

Practical impact of this problem on overall TCP performance
is unclear, but TCP itself detects this reordering and bumps
TCPSACKReorder resulting in user complaints.

Note that the code plays an easy to miss trick by upcasting next_hdr
to a u16 pointer and compares next_hdr and hop_limit in one go.
Coalesce the flush setting to reduce the instruction count a touch.

Fixes: 787e92083601 ("ipv6: Add GRO support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv6/ip6_offload.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index b29e9ba5e113..570071a87e71 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -249,7 +249,7 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 		 if ((first_word & htonl(0xF00FFFFF)) ||
 		     !ipv6_addr_equal(&iph->saddr, &iph2->saddr) ||
 		     !ipv6_addr_equal(&iph->daddr, &iph2->daddr) ||
-		     *(u16 *)&iph->nexthdr != *(u16 *)&iph2->nexthdr) {
+		     iph->nexthdr != iph2->nexthdr) {
 not_same_flow:
 			NAPI_GRO_CB(p)->same_flow = 0;
 			continue;
@@ -260,8 +260,9 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 				goto not_same_flow;
 		}
 		/* flush if Traffic Class fields are different */
-		NAPI_GRO_CB(p)->flush |= !!(first_word & htonl(0x0FF00000));
-		NAPI_GRO_CB(p)->flush |= flush;
+		NAPI_GRO_CB(p)->flush |= flush |
+					 !!((first_word & htonl(0x0FF00000)) |
+					    (iph->hop_limit ^ iph2->hop_limit));
 
 		/* If the previous IP ID value was based on an atomic
 		 * datagram we can overwrite the value and ignore it.
-- 
2.31.1

