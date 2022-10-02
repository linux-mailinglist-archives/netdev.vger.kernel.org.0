Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7810D5F2209
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJBIYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJBIYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:24:03 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFCC41D2E
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:24:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 936682055E;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jaocfdUrcLNf; Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1D40320519;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 0B84380004A;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:23:57 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:23:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 522C03182A48; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 24/24] xfrm: mip6: add extack to mip6_destopt_init_state, mip6_rthdr_init_state
Date:   Sun, 2 Oct 2022 10:17:12 +0200
Message-ID: <20221002081712.757515-25-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
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

From: Sabrina Dubroca <sd@queasysnail.net>

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv6/mip6.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index 3d87ae88ebfd..83d2a8be263f 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -250,12 +250,11 @@ static int mip6_destopt_reject(struct xfrm_state *x, struct sk_buff *skb,
 static int mip6_destopt_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	if (x->id.spi) {
-		pr_info("%s: spi is not 0: %u\n", __func__, x->id.spi);
+		NL_SET_ERR_MSG(extack, "SPI must be 0");
 		return -EINVAL;
 	}
 	if (x->props.mode != XFRM_MODE_ROUTEOPTIMIZATION) {
-		pr_info("%s: state's mode is not %u: %u\n",
-			__func__, XFRM_MODE_ROUTEOPTIMIZATION, x->props.mode);
+		NL_SET_ERR_MSG(extack, "XFRM mode must be XFRM_MODE_ROUTEOPTIMIZATION");
 		return -EINVAL;
 	}
 
@@ -336,12 +335,11 @@ static int mip6_rthdr_output(struct xfrm_state *x, struct sk_buff *skb)
 static int mip6_rthdr_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	if (x->id.spi) {
-		pr_info("%s: spi is not 0: %u\n", __func__, x->id.spi);
+		NL_SET_ERR_MSG(extack, "SPI must be 0");
 		return -EINVAL;
 	}
 	if (x->props.mode != XFRM_MODE_ROUTEOPTIMIZATION) {
-		pr_info("%s: state's mode is not %u: %u\n",
-			__func__, XFRM_MODE_ROUTEOPTIMIZATION, x->props.mode);
+		NL_SET_ERR_MSG(extack, "XFRM mode must be XFRM_MODE_ROUTEOPTIMIZATION");
 		return -EINVAL;
 	}
 
-- 
2.25.1

