Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2155F5B0238
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 12:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIGK61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 06:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIGK60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 06:58:26 -0400
X-Greylist: delayed 1501 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Sep 2022 03:58:21 PDT
Received: from smart-D.hosteam.fr (smart-D.hosteam.fr [91.206.156.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0622979E4;
        Wed,  7 Sep 2022 03:58:20 -0700 (PDT)
Received: from mail.gatewatcher.com (unknown [192.168.3.58])
        by smart-D.hosteam.fr (Postfix) with ESMTPS id C43602A19E0;
        Wed,  7 Sep 2022 12:08:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gatewatcher.com;
        s=hosteamdkim; t=1662545339;
        bh=Gb0O+oTPwGmm0v9ITQNaFqxx7I8R0OzeKRA7GcgCDJE=;
        h=From:To:CC:Subject:Date:From;
        b=fPZSjQFUbQzouMsJACml/zddw5Kj2viDEG0L+JjXZFGoQtSO4rqqWD0VA+iuUNTte
         ySAujw5MrrgdRk4qiaW5x3SMG09GUmpfvhRxGdorNnX95DAoIhszIc7whuodVKQQ8N
         ebkOURJQ9g52MpUNrxdwLaZ+r6YKhOXBOiuKwBYw=
Received: from gatewatcher.com (192.168.145.72) by
 GWCHR-EXCH01B.adexch.gatewatcher.com (192.168.145.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 7 Sep 2022 12:08:59 +0200
From:   <ludovic.cintrat@gatewatcher.com>
To:     <ludovic.cintrat@gatewatcher.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vlad Buslov <vladbu@nvidia.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Tom Herbert <tom@herbertland.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v1] net: core: fix flow symmetric hash
Date:   Wed, 7 Sep 2022 12:08:13 +0200
Message-ID: <20220907100814.1549196-1-ludovic.cintrat@gatewatcher.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.168.145.72]
X-ClientProxiedBy: GWCHR-EXCH01B.adexch.gatewatcher.com (192.168.145.5) To
 GWCHR-EXCH01B.adexch.gatewatcher.com (192.168.145.5)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>

__flow_hash_consistentify() wrongly swaps ipv4 addresses in few cases.
This function is indirectly used by __skb_get_hash_symmetric(), which is
used to fanout packets in AF_PACKET.
Intrusion detection systems may be impacted by this issue.

__flow_hash_consistentify() computes the addresses difference then swaps
them if the difference is negative. In few cases src - dst and dst - src
are both negative.

The following snippet mimics __flow_hash_consistentify():

```
 #include <stdio.h>
 #include <stdint.h>

 int main(int argc, char** argv) {

     int diffs_d, diffd_s;
     uint32_t dst  = 0xb225a8c0; /* 178.37.168.192 --> 192.168.37.178 */
     uint32_t src  = 0x3225a8c0; /*  50.37.168.192 --> 192.168.37.50  */
     uint32_t dst2 = 0x3325a8c0; /*  51.37.168.192 --> 192.168.37.51  */

     diffs_d = src - dst;
     diffd_s = dst - src;

     printf("src:%08x dst:%08x, diff(s-d)=%d(0x%x) diff(d-s)=%d(0x%x)\n",
             src, dst, diffs_d, diffs_d, diffd_s, diffd_s);

     diffs_d = src - dst2;
     diffd_s = dst2 - src;

     printf("src:%08x dst:%08x, diff(s-d)=%d(0x%x) diff(d-s)=%d(0x%x)\n",
             src, dst2, diffs_d, diffs_d, diffd_s, diffd_s);

     return 0;
 }
```

Results:

src:3225a8c0 dst:b225a8c0, \
    diff(s-d)=-2147483648(0x80000000) \
    diff(d-s)=-2147483648(0x80000000)

src:3225a8c0 dst:3325a8c0, \
    diff(s-d)=-16777216(0xff000000) \
    diff(d-s)=16777216(0x1000000)

In the first case the addresses differences are always < 0, therefore
__flow_hash_consistentify() always swaps, thus dst->src and src->dst
packets have differents hashes.

Fixes: c3f8324188fa8 ("net: Add full IPv6 addresses to flow_keys")
Signed-off-by: Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>
---
 net/core/flow_dissector.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 764c4cb3fe8f..5dc3860e9fc7 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1611,9 +1611,8 @@ static inline void __flow_hash_consistentify(struct flow_keys *keys)
 
 	switch (keys->control.addr_type) {
 	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
-		addr_diff = (__force u32)keys->addrs.v4addrs.dst -
-			    (__force u32)keys->addrs.v4addrs.src;
-		if (addr_diff < 0)
+		if ((__force u32)keys->addrs.v4addrs.dst <
+		    (__force u32)keys->addrs.v4addrs.src)
 			swap(keys->addrs.v4addrs.src, keys->addrs.v4addrs.dst);
 
 		if ((__force u16)keys->ports.dst <
-- 
2.30.2

