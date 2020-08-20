Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567B724C522
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 20:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgHTSPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 14:15:01 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:38796 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgHTSPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 14:15:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BDE862057A;
        Thu, 20 Aug 2020 20:14:58 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RCy1FYCge3ch; Thu, 20 Aug 2020 20:14:57 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 971F020512;
        Thu, 20 Aug 2020 20:14:57 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 20 Aug 2020 20:14:57 +0200
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 20 Aug
 2020 20:14:57 +0200
Date:   Thu, 20 Aug 2020 20:14:52 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
CC:     Antony Antony <antony@phenome.org>
Subject: [PATCH 2/3] xfrm: clone XFRMA_REPLAY_ESN_VAL in xfrm_do_migrate
Message-ID: <20200820181452.GA19740@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20200820181158.GA19658@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRMA_REPLAY_ESN_VAL was not cloned from the old to the new.
Migrate this attribute during XFRMA_MSG_MIGRATE

Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 include/net/xfrm.h    | 16 ++++++----------
 net/xfrm/xfrm_state.c |  2 +-
 2 files changed, 7 insertions(+), 11 deletions(-)

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
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 3a000f289dcd..20a12c67a931 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1522,7 +1522,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->tfcpad = orig->tfcpad;
 	x->replay_maxdiff = orig->replay_maxdiff;
 	x->replay_maxage = orig->replay_maxage;
-	x->curlft.add_time = orig->curlft.add_time;
+	x->curlft = orig->curlft;
 	x->km.state = orig->km.state;
 	x->km.seq = orig->km.seq;
 	x->replay = orig->replay;
-- 
2.20.1

