Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F645B8DD0
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiINRFR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Sep 2022 13:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiINRE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:04:58 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90B524095
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:04:54 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-YfTaTfSGOQaT7wRQxG6O2A-1; Wed, 14 Sep 2022 13:04:51 -0400
X-MC-Unique: YfTaTfSGOQaT7wRQxG6O2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 150F9294EDDF;
        Wed, 14 Sep 2022 17:04:51 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.195.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2364B1121314;
        Wed, 14 Sep 2022 17:04:49 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 7/7] xfrm: add extack support to xfrm_init_replay
Date:   Wed, 14 Sep 2022 19:04:06 +0200
Message-Id: <d485ae3d7955e9bcae30ee946d31c442967a01b6.1663103634.git.sd@queasysnail.net>
In-Reply-To: <cover.1663103634.git.sd@queasysnail.net>
References: <cover.1663103634.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.37.3

