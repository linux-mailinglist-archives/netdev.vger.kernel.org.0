Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC1FFAFA1
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 12:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfKML0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 06:26:20 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49890 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbfKML0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 06:26:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E5E4820538;
        Wed, 13 Nov 2019 12:26:18 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9ug7CHQs1cyW; Wed, 13 Nov 2019 12:26:18 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 80436201AE;
        Wed, 13 Nov 2019 12:26:18 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 12:26:18 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5971C318017F;
 Wed, 13 Nov 2019 12:26:16 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/2] xfrm: Fix memleak on xfrm state destroy
Date:   Wed, 13 Nov 2019 12:26:12 +0100
Message-ID: <20191113112613.2596-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113112613.2596-1-steffen.klassert@secunet.com>
References: <20191113112613.2596-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We leak the page that we use to create skb page fragments
when destroying the xfrm_state. Fix this by dropping a
page reference if a page was assigned to the xfrm_state.

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Reported-by: JD <jdtxs00@gmail.com>
Reported-by: Paul Wouters <paul@nohats.ca>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_state.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index c6f3c4a1bd99..f3423562d933 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -495,6 +495,8 @@ static void ___xfrm_state_destroy(struct xfrm_state *x)
 		x->type->destructor(x);
 		xfrm_put_type(x->type);
 	}
+	if (x->xfrag.page)
+		put_page(x->xfrag.page);
 	xfrm_dev_state_free(x);
 	security_xfrm_state_free(x);
 	xfrm_state_free(x);
-- 
2.17.1

