Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B395829E7
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiG0PpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiG0PpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:45:20 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E285A647C
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 08:45:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B240820538;
        Wed, 27 Jul 2022 17:45:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EcQHw2FgO4Pa; Wed, 27 Jul 2022 17:45:14 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2F86A201AA;
        Wed, 27 Jul 2022 17:45:14 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 2179180004A;
        Wed, 27 Jul 2022 17:45:14 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 27 Jul 2022 17:45:13 +0200
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 27 Jul
 2022 17:45:12 +0200
Date:   Wed, 27 Jul 2022 17:45:02 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     <netdev@vger.kernel.org>, Tobias Brunner <tobias@strongswan.org>,
        "Antony Antony" <antony.antony@secunet.com>
Subject: [PATCH ipsec 1/3] Revert "xfrm: update SA curlft.use_time"
Message-ID: <e66a68873492c0b3e02f8459e88cedabe255e3b6.1658936270.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <3e201e1156639286e1874ebc29233741b8b2ac54.1657260947.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3e201e1156639286e1874ebc29233741b8b2ac54.1657260947.git.antony.antony@secunet.com>
Organization: secunet
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

This reverts commit af734a26a1a95a9fda51f2abb0c22a7efcafd5ca.

The abvoce commit is a regression according RFC 2367. A better fix would be
use x->lastused. Which will be propsed later.

according to RFC 2367 use_time == sadb_lifetime_usetime.

"sadb_lifetime_usetime
                   For CURRENT, the time, in seconds, when association
                   was first used. For HARD and SOFT, the number of
                   seconds after the first use of the association until
                   it expires."

Fixes: af734a26a1a9 ("xfrm: update SA curlft.use_time")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 net/xfrm/xfrm_input.c  | 1 -
 net/xfrm/xfrm_output.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 144238a50f3d..70a8c36f0ba6 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -669,7 +669,6 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		x->curlft.bytes += skb->len;
 		x->curlft.packets++;
-		x->curlft.use_time = ktime_get_real_seconds();
 
 		spin_unlock(&x->lock);
 
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 555ab35cd119..9a5e79a38c67 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -534,7 +534,6 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 
 		x->curlft.bytes += skb->len;
 		x->curlft.packets++;
-		x->curlft.use_time = ktime_get_real_seconds();
 
 		spin_unlock_bh(&x->lock);
 
-- 
2.30.2

