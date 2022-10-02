Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AA55F220F
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiJBIeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJBIeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:34:02 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6BB4CA02
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:34:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8C0A92052D;
        Sun,  2 Oct 2022 10:33:59 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nplCbN0l1Ot4; Sun,  2 Oct 2022 10:33:59 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A78232053D;
        Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 9859180004A;
        Sun,  2 Oct 2022 10:33:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:33:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:33:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 21F773182A2A; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 13/24] xfrm: add extack to verify_replay
Date:   Sun, 2 Oct 2022 10:17:01 +0200
Message-ID: <20221002081712.757515-14-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
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
 net/xfrm/xfrm_user.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 4167c189d35b..048c1e150b4e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -121,29 +121,43 @@ static inline int verify_sec_ctx_len(struct nlattr **attrs, struct netlink_ext_a
 }
 
 static inline int verify_replay(struct xfrm_usersa_info *p,
-				struct nlattr **attrs)
+				struct nlattr **attrs,
+				struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_REPLAY_ESN_VAL];
 	struct xfrm_replay_state_esn *rs;
 
-	if (!rt)
-		return (p->flags & XFRM_STATE_ESN) ? -EINVAL : 0;
+	if (!rt) {
+		if (p->flags & XFRM_STATE_ESN) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute for ESN");
+			return -EINVAL;
+		}
+		return 0;
+	}
 
 	rs = nla_data(rt);
 
-	if (rs->bmp_len > XFRMA_REPLAY_ESN_MAX / sizeof(rs->bmp[0]) / 8)
+	if (rs->bmp_len > XFRMA_REPLAY_ESN_MAX / sizeof(rs->bmp[0]) / 8) {
+		NL_SET_ERR_MSG(extack, "ESN bitmap length must be <= 128");
 		return -EINVAL;
+	}
 
 	if (nla_len(rt) < (int)xfrm_replay_state_esn_len(rs) &&
-	    nla_len(rt) != sizeof(*rs))
+	    nla_len(rt) != sizeof(*rs)) {
+		NL_SET_ERR_MSG(extack, "ESN attribute is too short to fit the full bitmap length");
 		return -EINVAL;
+	}
 
 	/* As only ESP and AH support ESN feature. */
-	if ((p->id.proto != IPPROTO_ESP) && (p->id.proto != IPPROTO_AH))
+	if ((p->id.proto != IPPROTO_ESP) && (p->id.proto != IPPROTO_AH)) {
+		NL_SET_ERR_MSG(extack, "ESN only supported for ESP and AH");
 		return -EINVAL;
+	}
 
-	if (p->replay_window != 0)
+	if (p->replay_window != 0) {
+		NL_SET_ERR_MSG(extack, "ESN not compatible with legacy replay_window");
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -311,7 +325,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	if ((err = verify_sec_ctx_len(attrs, extack)))
 		goto out;
-	if ((err = verify_replay(p, attrs)))
+	if ((err = verify_replay(p, attrs, extack)))
 		goto out;
 
 	err = -EINVAL;
-- 
2.25.1

