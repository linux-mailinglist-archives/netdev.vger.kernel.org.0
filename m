Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684DC27A978
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgI1IZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:25:05 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48654 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgI1IY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 04:24:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2F84A20501;
        Mon, 28 Sep 2020 10:24:57 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RlKpnF96m7OH; Mon, 28 Sep 2020 10:24:56 +0200 (CEST)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 814E220536;
        Mon, 28 Sep 2020 10:24:56 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 28 Sep 2020 10:24:56 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 28 Sep
 2020 10:24:55 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8F28A318472D;
 Mon, 28 Sep 2020 10:24:54 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 7/8] xfrm: clone whole liftime_cur structure in xfrm_do_migrate
Date:   Mon, 28 Sep 2020 10:24:49 +0200
Message-ID: <20200928082450.29414-8-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928082450.29414-1-steffen.klassert@secunet.com>
References: <20200928082450.29414-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

When we clone state only add_time was cloned. It missed values like
bytes, packets.  Now clone the all members of the structure.

v1->v3:
 - use memcpy to copy the entire structure

Fixes: 80c9abaabf42 ("[XFRM]: Extension for dynamic update of endpoint address(es)")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 5e5ed8108498..5ff392e6f3c1 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1550,7 +1550,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->tfcpad = orig->tfcpad;
 	x->replay_maxdiff = orig->replay_maxdiff;
 	x->replay_maxage = orig->replay_maxage;
-	x->curlft.add_time = orig->curlft.add_time;
+	memcpy(&x->curlft, &orig->curlft, sizeof(x->curlft));
 	x->km.state = orig->km.state;
 	x->km.seq = orig->km.seq;
 	x->replay = orig->replay;
-- 
2.17.1

