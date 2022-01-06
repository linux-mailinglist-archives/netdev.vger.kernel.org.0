Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05324861E7
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbiAFJOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:14:06 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37806 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237253AbiAFJOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:14:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6CBAC20652;
        Thu,  6 Jan 2022 10:13:59 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id P8ACAbP03nsl; Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4008120654;
        Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 304C480004A;
        Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:13:57 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:13:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6E4D13183024; Thu,  6 Jan 2022 10:13:54 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/7] net: xfrm: drop check of pols[0] for the second time
Date:   Thu, 6 Jan 2022 10:13:46 +0100
Message-ID: <20220106091350.3038869-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106091350.3038869-1-steffen.klassert@secunet.com>
References: <20220106091350.3038869-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

!pols[0] is checked earlier.  If we don't return, pols[0] is always
true.  We should drop the check of pols[0] for the second time and the
binary is also smaller.

Before:
   text	   data	    bss	    dec	    hex	filename
  48395	    957	    240	  49592	   c1b8	net/xfrm/xfrm_policy.o

After:
   text	   data	    bss	    dec	    hex	filename
  48379	    957	    240	  49576	   c1a8	net/xfrm/xfrm_policy.o

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index edc673e78114..9341298b2a70 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2680,7 +2680,7 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 	*num_xfrms = pols[0]->xfrm_nr;
 
 #ifdef CONFIG_XFRM_SUB_POLICY
-	if (pols[0] && pols[0]->action == XFRM_POLICY_ALLOW &&
+	if (pols[0]->action == XFRM_POLICY_ALLOW &&
 	    pols[0]->type != XFRM_POLICY_TYPE_MAIN) {
 		pols[1] = xfrm_policy_lookup_bytype(xp_net(pols[0]),
 						    XFRM_POLICY_TYPE_MAIN,
-- 
2.25.1

