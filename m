Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0262927A975
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgI1IZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:25:01 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48660 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgI1IY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 04:24:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9F5C0204EF;
        Mon, 28 Sep 2020 10:24:57 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nb4Epw5mu8Qc; Mon, 28 Sep 2020 10:24:57 +0200 (CEST)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B714B204FD;
        Mon, 28 Sep 2020 10:24:56 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 28 Sep 2020 10:24:56 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 28 Sep
 2020 10:24:55 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8643B3184721;
 Mon, 28 Sep 2020 10:24:54 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/8] xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate
Date:   Mon, 28 Sep 2020 10:24:47 +0200
Message-ID: <20200928082450.29414-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928082450.29414-1-steffen.klassert@secunet.com>
References: <20200928082450.29414-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

XFRMA_REPLAY_ESN_VAL was not cloned completely from the old to the new.
Migrate this attribute during XFRMA_MSG_MIGRATE

v1->v2:
 - move curleft cloning to a separate patch

Fixes: af2f464e326e ("xfrm: Assign esn pointers when cloning a state")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2737d24ec244..9e806c781025 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1773,21 +1773,17 @@ static inline unsigned int xfrm_replay_state_esn_len(struct xfrm_replay_state_es
 static inline int xfrm_replay_clone(struct xfrm_state *x,
 				     struct xfrm_state *orig)
 {
-	x->replay_esn = kzalloc(xfrm_replay_state_esn_len(orig->replay_esn),
+
+	x->replay_esn = kmemdup(orig->replay_esn,
+				xfrm_replay_state_esn_len(orig->replay_esn),
 				GFP_KERNEL);
 	if (!x->replay_esn)
 		return -ENOMEM;
-
-	x->replay_esn->bmp_len = orig->replay_esn->bmp_len;
-	x->replay_esn->replay_window = orig->replay_esn->replay_window;
-
-	x->preplay_esn = kmemdup(x->replay_esn,
-				 xfrm_replay_state_esn_len(x->replay_esn),
+	x->preplay_esn = kmemdup(orig->preplay_esn,
+				 xfrm_replay_state_esn_len(orig->preplay_esn),
 				 GFP_KERNEL);
-	if (!x->preplay_esn) {
-		kfree(x->replay_esn);
+	if (!x->preplay_esn)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
-- 
2.17.1

