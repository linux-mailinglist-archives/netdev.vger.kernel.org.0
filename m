Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E67405519
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354296AbhIINIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357526AbhIINBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BA3F63282;
        Thu,  9 Sep 2021 11:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188767;
        bh=8yhV7/DVB34fP3mHRMBHlWHXu04xOPpIqQTpTu3Fcpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfswjxXiDwdIGCSyxan9AgsOLLfEt1bHDaCRNSxDygTerUnhYgLlIYMNe43VZUjc1
         EiFgt717cMyTuf5j+ep0UVIy/shZtGrRmZ9JKq0dhOMJhPjv9o8tnn7nYXmfEDbRsU
         zc8v03uX5vTw4KeJptgrn2UF/7VtQNgxTozo99XUnqNUUn3UIBVOD2I3LQLHqiHaox
         lPrzwqn15J5YMqutixLU6oSbup8uB1hLiFJgW8cPPqBjeXya9GXNKFvxfVwWclXAHq
         GtBXTDza9ldh5jUgQiXIm+EPFAPdFcRr0KGTpHA41e00susrvvzpf5WYUZR9SbSME8
         FkcwvqJ9sZi2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 21/59] flow_dissector: Fix out-of-bounds warnings
Date:   Thu,  9 Sep 2021 07:58:22 -0400
Message-Id: <20210909115900.149795-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit 323e0cb473e2a8706ff162b6b4f4fa16023c9ba7 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 071de3013364..b4dddb685fc2 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -514,8 +514,10 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
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
 
@@ -564,8 +566,10 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
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
2.30.2

