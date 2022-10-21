Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6876C6078B0
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiJUNmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiJUNmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:42:14 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246BC16655B
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 06:42:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 11F4220571;
        Fri, 21 Oct 2022 15:42:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ftka2Sw_K_Ke; Fri, 21 Oct 2022 15:42:09 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 918572056D;
        Fri, 21 Oct 2022 15:42:09 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 82CD580004A;
        Fri, 21 Oct 2022 15:42:09 +0200 (CEST)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 15:42:09 +0200
Received: from moon.secunet.de (172.18.149.2) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 21 Oct
 2022 15:42:09 +0200
Date:   Fri, 21 Oct 2022 15:42:01 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     <netdev@vger.kernel.org>, Tobias Brunner <tobias@strongswan.org>,
        "Antony Antony" <antony@phenome.org>
Subject: [PATCH ipsec-next v2] xfrm: update x->lastused for every packet
Message-ID: <1c3bdbd480bd3018175525a23ba623911fec74e1.1666359531.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <3e201e1156639286e1874ebc29233741b8b2ac54.1657260947.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3e201e1156639286e1874ebc29233741b8b2ac54.1657260947.git.antony.antony@secunet.com>
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
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
the last time an SA was used. lastused time of in SA can used
to check IPsec path is functional.

Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 v1 -> v2 now ipsec-next has the required patches.

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
2.30.2

