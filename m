Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC58048622F
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbiAFJgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:36:17 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38780 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237449AbiAFJgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:36:15 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8884B201CC;
        Thu,  6 Jan 2022 10:36:14 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lOeXIaIcnTqe; Thu,  6 Jan 2022 10:36:14 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C25CD20646;
        Thu,  6 Jan 2022 10:36:12 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id B3BEB80004A;
        Thu,  6 Jan 2022 10:36:12 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:36:12 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:36:11 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0FCDF3183013; Thu,  6 Jan 2022 10:36:09 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/6] xfrm: fix dflt policy check when there is no policy configured
Date:   Thu, 6 Jan 2022 10:36:02 +0100
Message-ID: <20220106093606.3046771-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106093606.3046771-1-steffen.klassert@secunet.com>
References: <20220106093606.3046771-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

When there is no policy configured on the system, the default policy is
checked in xfrm_route_forward. However, it was done with the wrong
direction (XFRM_POLICY_FWD instead of XFRM_POLICY_OUT).
The default policy for XFRM_POLICY_FWD was checked just before, with a call
to xfrm[46]_policy_check().

CC: stable@vger.kernel.org
Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2308210793a0..55e574511af5 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1162,7 +1162,7 @@ static inline int xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 {
 	struct net *net = dev_net(skb->dev);
 
-	if (xfrm_default_allow(net, XFRM_POLICY_FWD))
+	if (xfrm_default_allow(net, XFRM_POLICY_OUT))
 		return !net->xfrm.policy_count[XFRM_POLICY_OUT] ||
 			(skb_dst(skb)->flags & DST_NOXFRM) ||
 			__xfrm_route_forward(skb, family);
-- 
2.25.1

