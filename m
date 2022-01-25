Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D25449AB7A
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 06:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390977AbiAYE4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 23:56:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54050 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1326904AbiAYEo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 23:44:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30DA5B8164C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 04:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E61C340E0;
        Tue, 25 Jan 2022 04:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643085894;
        bh=xqjqIJVza7BbDTf2MN4vIDD7THJ0hAh1CiKeP/Jz//U=;
        h=From:To:Cc:Subject:Date:From;
        b=fuLc/zJcQ70chklImwEeKeHWs64i/P+FS2u4lQYyZ2i3yw1Zol4Aa4BIeeyIS1vsp
         ZREtbR6UTkuwBmvOSG8q/jJ/G7zAnI4qztegYfrZKxMtoDOs3rcKYcIYtIL+aZ6tiQ
         oB4j/PXycvK119HLl+YSLaa6+xuAHB9eGxdfOqgU1y5NUMY3LIX2pGH0f6Ilz09Ots
         ovtyGZiLgHNLnxx7LPUpKi2bHQofFYr06gmA2RsysgoOYpXPcLKjc6ffRZl0gSIxe9
         wRdgxXgXDqd2/zwxLrA+dtxGt+AEoK/m20bE/E1K6FLZ0f808LA2tTOgq94F8ZsGc8
         +74CtJdqJpZMw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, dsahern@gmail.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2] ipv6: gro: flush instead of assuming different flows on hop_limit mismatch
Date:   Mon, 24 Jan 2022 20:44:44 -0800
Message-Id: <20220125044444.108785-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
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

Eric warns that there may be performance regressions in setups
which do packet spraying across links with similar RTT but different
hop count. To be safe let's target -next and not treat this
as a fix. If the packet spraying is using flow label there should
be no difference in behavior as flow label is checked first.

Note that the code plays an easy to miss trick by upcasting next_hdr
to a u16 pointer and compares next_hdr and hop_limit in one go.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
v2: resend for -next with the sparse false-positive addressed
---
 net/ipv6/ip6_offload.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index b29e9ba5e113..d37a79a8554e 100644
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
@@ -260,7 +260,8 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 				goto not_same_flow;
 		}
 		/* flush if Traffic Class fields are different */
-		NAPI_GRO_CB(p)->flush |= !!(first_word & htonl(0x0FF00000));
+		NAPI_GRO_CB(p)->flush |= !!((first_word & htonl(0x0FF00000)) |
+			(__force __be32)(iph->hop_limit ^ iph2->hop_limit));
 		NAPI_GRO_CB(p)->flush |= flush;
 
 		/* If the previous IP ID value was based on an atomic
-- 
2.34.1

