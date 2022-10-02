Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D885F2207
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiJBIYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJBIYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:24:05 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F6527DF5
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:24:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1F88320519;
        Sun,  2 Oct 2022 10:24:00 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2eVnQ3rfVhe7; Sun,  2 Oct 2022 10:23:59 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B7EC72053B;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id A9C2280004A;
        Sun,  2 Oct 2022 10:23:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:23:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:23:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 380553182A34; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 18/24] xfrm: add extack support to xfrm_init_replay
Date:   Sun, 2 Oct 2022 10:17:06 +0200
Message-ID: <20221002081712.757515-19-steffen.klassert@secunet.com>
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
 include/net/xfrm.h     |  2 +-
 net/xfrm/xfrm_replay.c | 10 +++++++---
 net/xfrm/xfrm_state.c  |  2 +-
 net/xfrm/xfrm_user.c   |  2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index f427a74d571b..c504d07bcb7c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1580,7 +1580,7 @@ int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_vali
 void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
-int xfrm_init_replay(struct xfrm_state *x);
+int xfrm_init_replay(struct xfrm_state *x, struct netlink_ext_ack *extack);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
 		      struct netlink_ext_ack *extack);
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 9277d81b344c..9f4d42eb090f 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -766,18 +766,22 @@ int xfrm_replay_overflow(struct xfrm_state *x, struct sk_buff *skb)
 }
 #endif
 
-int xfrm_init_replay(struct xfrm_state *x)
+int xfrm_init_replay(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
 
 	if (replay_esn) {
 		if (replay_esn->replay_window >
-		    replay_esn->bmp_len * sizeof(__u32) * 8)
+		    replay_esn->bmp_len * sizeof(__u32) * 8) {
+			NL_SET_ERR_MSG(extack, "ESN replay window is too large for the chosen bitmap size");
 			return -EINVAL;
+		}
 
 		if (x->props.flags & XFRM_STATE_ESN) {
-			if (replay_esn->replay_window == 0)
+			if (replay_esn->replay_window == 0) {
+				NL_SET_ERR_MSG(extack, "ESN replay window must be > 0");
 				return -EINVAL;
+			}
 			x->repl_mode = XFRM_REPLAY_MODE_ESN;
 		} else {
 			x->repl_mode = XFRM_REPLAY_MODE_BMP;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 7470d2474796..0b59ff7985e6 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2686,7 +2686,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
 
 	x->outer_mode = *outer_mode;
 	if (init_replay) {
-		err = xfrm_init_replay(x);
+		err = xfrm_init_replay(x, extack);
 		if (err)
 			goto error;
 	}
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 14e9b84f9dad..e73f9efc54c1 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -741,7 +741,7 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 	/* sysctl_xfrm_aevent_etime is in 100ms units */
 	x->replay_maxage = (net->xfrm.sysctl_aevent_etime*HZ)/XFRM_AE_ETH_M;
 
-	if ((err = xfrm_init_replay(x)))
+	if ((err = xfrm_init_replay(x, extack)))
 		goto error;
 
 	/* override default values from above */
-- 
2.25.1

