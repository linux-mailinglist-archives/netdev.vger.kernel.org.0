Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED08639594
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 12:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiKZLDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 06:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiKZLDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 06:03:11 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CA8192B1
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:03:09 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6D621204FD;
        Sat, 26 Nov 2022 12:03:08 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4EAm4U7nqGDY; Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 68C392050A;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 63AC880004A;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 12:03:07 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 12:03:06 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2253A3183C40; Sat, 26 Nov 2022 12:03:06 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 02/10] xfrm: update x->lastused for every packet
Date:   Sat, 26 Nov 2022 12:02:55 +0100
Message-ID: <20221126110303.1859238-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221126110303.1859238-1-steffen.klassert@secunet.com>
References: <20221126110303.1859238-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

x->lastused was only updated for outgoing mobile IPv6 packet.
With this fix update it for every, in and out, packet.

This is useful to check if the a SA is still in use, or when was
the last time an SA was used. lastused time of in SA can used
to check IPsec path is functional.

Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_input.c  | 1 +
 net/xfrm/xfrm_output.c | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 97074f6f2bde..c06e54a10540 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -671,6 +671,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
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
2.25.1

