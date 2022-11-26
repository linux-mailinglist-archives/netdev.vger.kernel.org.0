Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E97F639597
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 12:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiKZLDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 06:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKZLDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 06:03:12 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25B418B2F
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:03:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9F077204B4;
        Sat, 26 Nov 2022 12:03:08 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FHAU9iQNQY4W; Sat, 26 Nov 2022 12:03:08 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8C9042052E;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 8775E80004A;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 12:03:07 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 12:03:06 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3677D3183C4D; Sat, 26 Nov 2022 12:03:06 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 07/10] xfrm: add extack to xfrm_new_ae and xfrm_replay_verify_len
Date:   Sat, 26 Nov 2022 12:03:00 +0100
Message-ID: <20221126110303.1859238-8-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221126110303.1859238-1-steffen.klassert@secunet.com>
References: <20221126110303.1859238-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
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
 net/xfrm/xfrm_user.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 06a379d35ebb..13607df4f30d 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -515,7 +515,8 @@ static int attach_aead(struct xfrm_state *x, struct nlattr *rta,
 }
 
 static inline int xfrm_replay_verify_len(struct xfrm_replay_state_esn *replay_esn,
-					 struct nlattr *rp)
+					 struct nlattr *rp,
+					 struct netlink_ext_ack *extack)
 {
 	struct xfrm_replay_state_esn *up;
 	unsigned int ulen;
@@ -528,13 +529,25 @@ static inline int xfrm_replay_verify_len(struct xfrm_replay_state_esn *replay_es
 
 	/* Check the overall length and the internal bitmap length to avoid
 	 * potential overflow. */
-	if (nla_len(rp) < (int)ulen ||
-	    xfrm_replay_state_esn_len(replay_esn) != ulen ||
-	    replay_esn->bmp_len != up->bmp_len)
+	if (nla_len(rp) < (int)ulen) {
+		NL_SET_ERR_MSG(extack, "ESN attribute is too short");
 		return -EINVAL;
+	}
 
-	if (up->replay_window > up->bmp_len * sizeof(__u32) * 8)
+	if (xfrm_replay_state_esn_len(replay_esn) != ulen) {
+		NL_SET_ERR_MSG(extack, "New ESN size doesn't match the existing SA's ESN size");
 		return -EINVAL;
+	}
+
+	if (replay_esn->bmp_len != up->bmp_len) {
+		NL_SET_ERR_MSG(extack, "New ESN bitmap size doesn't match the existing SA's ESN bitmap");
+		return -EINVAL;
+	}
+
+	if (up->replay_window > up->bmp_len * sizeof(__u32) * 8) {
+		NL_SET_ERR_MSG(extack, "ESN replay window is longer than the bitmap");
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -2433,12 +2446,16 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *et = attrs[XFRMA_ETIMER_THRESH];
 	struct nlattr *rt = attrs[XFRMA_REPLAY_THRESH];
 
-	if (!lt && !rp && !re && !et && !rt)
+	if (!lt && !rp && !re && !et && !rt) {
+		NL_SET_ERR_MSG(extack, "Missing required attribute for AE");
 		return err;
+	}
 
 	/* pedantic mode - thou shalt sayeth replaceth */
-	if (!(nlh->nlmsg_flags&NLM_F_REPLACE))
+	if (!(nlh->nlmsg_flags & NLM_F_REPLACE)) {
+		NL_SET_ERR_MSG(extack, "NLM_F_REPLACE flag is required");
 		return err;
+	}
 
 	mark = xfrm_mark_get(attrs, &m);
 
@@ -2446,10 +2463,12 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (x == NULL)
 		return -ESRCH;
 
-	if (x->km.state != XFRM_STATE_VALID)
+	if (x->km.state != XFRM_STATE_VALID) {
+		NL_SET_ERR_MSG(extack, "SA must be in VALID state");
 		goto out;
+	}
 
-	err = xfrm_replay_verify_len(x->replay_esn, re);
+	err = xfrm_replay_verify_len(x->replay_esn, re, extack);
 	if (err)
 		goto out;
 
-- 
2.25.1

