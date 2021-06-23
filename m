Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A823B143C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhFWG5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 02:57:20 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:56132 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhFWG5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 02:57:13 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id A3B9B800058;
        Wed, 23 Jun 2021 08:54:53 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 08:54:53 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 23 Jun
 2021 08:54:52 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6BB273180609; Wed, 23 Jun 2021 08:54:52 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 6/6] xfrm: Fix xfrm offload fallback fail case
Date:   Wed, 23 Jun 2021 08:54:49 +0200
Message-ID: <20210623065449.2143405-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210623065449.2143405-1-steffen.klassert@secunet.com>
References: <20210623065449.2143405-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

In case of xfrm offload, if xdo_dev_state_add() of driver returns
-EOPNOTSUPP, xfrm offload fallback is failed.
In xfrm state_add() both xso->dev and xso->real_dev are initialized to
dev and when err(-EOPNOTSUPP) is returned only xso->dev is set to null.

So in this scenario the condition in func validate_xmit_xfrm(),
if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
                return skb;
returns true, due to which skb is returned without calling esp_xmit()
below which has fallback code. Hence the CRYPTO_FALLBACK is failing.

So fixing this with by keeping x->xso.real_dev as NULL when err is
returned in func xfrm_dev_state_add().

Fixes: bdfd2d1fa79a ("bonding/xfrm: use real_dev instead of slave_dev")
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 6d6917b68856..e843b0d9e2a6 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -268,6 +268,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		xso->num_exthdrs = 0;
 		xso->flags = 0;
 		xso->dev = NULL;
+		xso->real_dev = NULL;
 		dev_put(dev);
 
 		if (err != -EOPNOTSUPP)
-- 
2.25.1

