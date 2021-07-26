Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27653D6775
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhGZSmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhGZSmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 14:42:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF3B660F6D;
        Mon, 26 Jul 2021 19:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627327364;
        bh=GPp3eOsZSKAJOPnpQxw6ScV5mylXbFIUk8/qVauEq04=;
        h=Date:From:To:Cc:Subject:From;
        b=sRQJKN5+ZZ7b4hR/K333Ba3M6ic9UDQDg2eQV5d6mQmKk3gmhDUR16tZJsYcpchyz
         DEgFHNgFgrItMv6oJm6fa9yciQEgJwxL7/5z9lu75g9YgazCTu8oUp5oVfM1KIcxxd
         WV1ortnk1ktp03LG9/503rtEoFKkLSQHIcZXt8pHbuVwuNtIrMCJ42L49yTFbp2nPY
         JVKlhRvnTlBjDiZrHQ3NZgPzcOH7U3v6E1TXu7lCZ04s3Xw+NEss/RTPjrWPQ4BnSd
         8iM4bHKaKx6ZkWf36Sz0vHEYfP2k45BRtEROXDy5F7WPuccgJormqbmwIUF7S1C9OL
         uuDB4feGyFw+g==
Date:   Mon, 26 Jul 2021 14:25:11 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] flow_dissector: Fix out-of-bounds warnings
Message-ID: <20210726192511.GA23259@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following out-of-bounds warnings:

    net/core/flow_dissector.c: In function '__skb_flow_dissect':
>> net/core/flow_dissector.c:1104:4: warning: 'memcpy' offset [24, 39] from the object at '<unknown>' is out of the bounds of referenced subobject 'saddr' with type 'struct in6_addr' at offset 8 [-Warray-bounds]
     1104 |    memcpy(&key_addrs->v6addrs, &iph->saddr,
          |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     1105 |           sizeof(key_addrs->v6addrs));
          |           ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    In file included from include/linux/ipv6.h:5,
                     from net/core/flow_dissector.c:6:
    include/uapi/linux/ipv6.h:133:18: note: subobject 'saddr' declared here
      133 |  struct in6_addr saddr;
          |                  ^~~~~
>> net/core/flow_dissector.c:1059:4: warning: 'memcpy' offset [16, 19] from the object at '<unknown>' is out of the bounds of referenced subobject 'saddr' with type 'unsigned int' at offset 12 [-Warray-bounds]
     1059 |    memcpy(&key_addrs->v4addrs, &iph->saddr,
          |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     1060 |           sizeof(key_addrs->v4addrs));
          |           ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    In file included from include/linux/ip.h:17,
                     from net/core/flow_dissector.c:5:
    include/uapi/linux/ip.h:103:9: note: subobject 'saddr' declared here
      103 |  __be32 saddr;
          |         ^~~~~

The problem is that the original code is trying to copy data into a
couple of struct members adjacent to each other in a single call to
memcpy().  So, the compiler legitimately complains about it. As these
are just a couple of members, fix this by copying each one of them in
separate calls to memcpy().

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/d5ae2e65-1f18-2577-246f-bada7eee6ccd@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/core/flow_dissector.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2aadbfc5193b..39d7be03e568 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1056,8 +1056,10 @@ bool __skb_flow_dissect(const struct net *net,
 							      FLOW_DISSECTOR_KEY_IPV4_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v4addrs, &iph->saddr,
-			       sizeof(key_addrs->v4addrs));
+			memcpy(&key_addrs->v4addrs.src, &iph->saddr,
+			       sizeof(key_addrs->v4addrs.src));
+			memcpy(&key_addrs->v4addrs.dst, &iph->daddr,
+			       sizeof(key_addrs->v4addrs.dst));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		}
 
@@ -1101,8 +1103,10 @@ bool __skb_flow_dissect(const struct net *net,
 							      FLOW_DISSECTOR_KEY_IPV6_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v6addrs, &iph->saddr,
-			       sizeof(key_addrs->v6addrs));
+			memcpy(&key_addrs->v6addrs.src, &iph->saddr,
+			       sizeof(key_addrs->v6addrs.src));
+			memcpy(&key_addrs->v6addrs.dst, &iph->daddr,
+			       sizeof(key_addrs->v6addrs.dst));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 		}
 
-- 
2.27.0

