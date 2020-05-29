Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574BA1E7B28
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgE2LET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:04:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39468 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgE2LEP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:04:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BD7D0205DB;
        Fri, 29 May 2020 13:04:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mgnlRWA7UXjH; Fri, 29 May 2020 13:04:13 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 41B4620539;
        Fri, 29 May 2020 13:04:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 13:04:13 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 13:04:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1E4F531802B2;
 Fri, 29 May 2020 13:04:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 04/15] xfrm: remove the xfrm_state_put call becofe going to out_reset
Date:   Fri, 29 May 2020 13:03:57 +0200
Message-ID: <20200529110408.6349-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529110408.6349-1-steffen.klassert@secunet.com>
References: <20200529110408.6349-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

This xfrm_state_put call in esp4/6_gro_receive() will cause
double put for state, as in out_reset path secpath_reset()
will put all states set in skb sec_path.

So fix it by simply remove the xfrm_state_put call.

Fixes: 6ed69184ed9c ("xfrm: Reset secpath in xfrm failure")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 4 +---
 net/ipv6/esp6_offload.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 731022cff600..231edcb84c08 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -63,10 +63,8 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 		sp->olen++;
 
 		xo = xfrm_offload(skb);
-		if (!xo) {
-			xfrm_state_put(x);
+		if (!xo)
 			goto out_reset;
-		}
 	}
 
 	xo->flags |= XFRM_GRO;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index b82850886574..b92372b104ba 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -85,10 +85,8 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 		sp->olen++;
 
 		xo = xfrm_offload(skb);
-		if (!xo) {
-			xfrm_state_put(x);
+		if (!xo)
 			goto out_reset;
-		}
 	}
 
 	xo->flags |= XFRM_GRO;
-- 
2.17.1

