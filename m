Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150404DAF64
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355581AbiCPMND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355576AbiCPMNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:13:02 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C9C53B52
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 05:11:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CA58F2063F;
        Wed, 16 Mar 2022 13:11:45 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vyugdn7fXTkv; Wed, 16 Mar 2022 13:11:45 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 475F2205ED;
        Wed, 16 Mar 2022 13:11:45 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 41F5580004A;
        Wed, 16 Mar 2022 13:11:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Wed, 16 Mar 2022 13:11:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 16 Mar
 2022 13:11:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8CA703182E7E; Wed, 16 Mar 2022 13:11:44 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/2] esp6: fix check on ipv6_skip_exthdr's return value
Date:   Wed, 16 Mar 2022 13:11:42 +0100
Message-ID: <20220316121142.3142336-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316121142.3142336-1-steffen.klassert@secunet.com>
References: <20220316121142.3142336-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Commit 5f9c55c8066b ("ipv6: check return value of ipv6_skip_exthdr")
introduced an incorrect check, which leads to all ESP packets over
either TCPv6 or UDPv6 encapsulation being dropped. In this particular
case, offset is negative, since skb->data points to the ESP header in
the following chain of headers, while skb->network_header points to
the IPv6 header:

    IPv6 | ext | ... | ext | UDP | ESP | ...

That doesn't seem to be a problem, especially considering that if we
reach esp6_input_done2, we're guaranteed to have a full set of headers
available (otherwise the packet would have been dropped earlier in the
stack). However, it means that the return value will (intentionally)
be negative. We can make the test more specific, as the expected
return value of ipv6_skip_exthdr will be the (negated) size of either
a UDP header, or a TCP header with possible options.

In the future, we should probably either make ipv6_skip_exthdr
explicitly accept negative offsets (and adjust its return value for
error cases), or make ipv6_skip_exthdr only take non-negative
offsets (and audit all callers).

Fixes: 5f9c55c8066b ("ipv6: check return value of ipv6_skip_exthdr")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/esp6.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index b0ffbcd5432d..55d604c9b3b3 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -812,8 +812,7 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		struct tcphdr *th;
 
 		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
-
-		if (offset < 0) {
+		if (offset == -1) {
 			err = -EINVAL;
 			goto out;
 		}
-- 
2.25.1

