Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72CC5899CF
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 11:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbiHDJRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 05:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiHDJRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 05:17:43 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671453A481
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 02:17:42 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3194B201CC;
        Thu,  4 Aug 2022 11:17:40 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DSkcTdpo-02V; Thu,  4 Aug 2022 11:17:39 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3443A20569;
        Thu,  4 Aug 2022 11:17:39 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 2B7C080004A;
        Thu,  4 Aug 2022 11:17:39 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 11:17:38 +0200
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 4 Aug
 2022 11:17:38 +0200
Date:   Thu, 4 Aug 2022 11:17:31 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     <netdev@vger.kernel.org>, Tobias Brunner <tobias@strongswan.org>
Subject: [PATCH ipsec-next] xfrm: update x->lastused for every packet
Message-ID: <a24754505073ab8f832aa34cd38d3ee68d36bc5e.1659603877.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

x->lastused was only updated for outgoing mobile IPv6 packet.
With this fix update it for every, in and out, packet.

This is useful to check if the a SA is still in use, or when was
the last time an SA was used.  lastused time of in SA can used
to check IPsec path is functional.

Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_input.c  | 1 +
 net/xfrm/xfrm_output.c | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 70a8c36f0ba6..7978048df837 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -669,6 +669,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		x->curlft.bytes += skb->len;
 		x->curlft.packets++;
+		x->lastused = ktime_get_real_seconds();
 
 		spin_unlock(&x->lock);
 
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9a5e79a38c67..78cb8d0a6a18 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -209,8 +209,6 @@ static int xfrm6_ro_output(struct xfrm_state *x, struct sk_buff *skb)
 	__skb_pull(skb, hdr_len);
 	memmove(ipv6_hdr(skb), iph, hdr_len);
 
-	x->lastused = ktime_get_real_seconds();
-
 	return 0;
 #else
 	WARN_ON_ONCE(1);
@@ -534,6 +532,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 
 		x->curlft.bytes += skb->len;
 		x->curlft.packets++;
+		x->lastused = ktime_get_real_seconds();
 
 		spin_unlock_bh(&x->lock);
 
-- 
2.30.2

