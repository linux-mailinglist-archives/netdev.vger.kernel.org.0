Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D528E5B8DD1
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiINRFP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Sep 2022 13:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiINRE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:04:58 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DD11EEDB
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:04:53 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-RJpvPigqN9CBEMln_zKNNQ-1; Wed, 14 Sep 2022 13:04:50 -0400
X-MC-Unique: RJpvPigqN9CBEMln_zKNNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B843438149AE;
        Wed, 14 Sep 2022 17:04:49 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.195.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADBE11121314;
        Wed, 14 Sep 2022 17:04:48 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 6/7] xfrm: add extack to __xfrm_init_state
Date:   Wed, 14 Sep 2022 19:04:05 +0200
Message-Id: <63fb83113f0e33cfd356c41ab2e65b0436672571.1663103634.git.sd@queasysnail.net>
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
 include/net/xfrm.h    |  3 ++-
 net/xfrm/xfrm_state.c | 26 +++++++++++++++++++-------
 net/xfrm/xfrm_user.c  |  2 +-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9c1cccf85f12..f427a74d571b 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1582,7 +1582,8 @@ void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
-int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
+int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
+		      struct netlink_ext_ack *extack);
 int xfrm_init_state(struct xfrm_state *x);
 int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type);
 int xfrm_input_resume(struct sk_buff *skb, int nexthdr);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 52e60e607f8a..7470d2474796 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2610,7 +2610,8 @@ u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 }
 EXPORT_SYMBOL_GPL(xfrm_state_mtu);
 
-int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
+int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
+		      struct netlink_ext_ack *extack)
 {
 	const struct xfrm_mode *inner_mode;
 	const struct xfrm_mode *outer_mode;
@@ -2625,12 +2626,16 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 
 	if (x->sel.family != AF_UNSPEC) {
 		inner_mode = xfrm_get_mode(x->props.mode, x->sel.family);
-		if (inner_mode == NULL)
+		if (inner_mode == NULL) {
+			NL_SET_ERR_MSG(extack, "Requested mode not found");
 			goto error;
+		}
 
 		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL) &&
-		    family != x->sel.family)
+		    family != x->sel.family) {
+			NL_SET_ERR_MSG(extack, "Only tunnel modes can accommodate a change of family");
 			goto error;
+		}
 
 		x->inner_mode = *inner_mode;
 	} else {
@@ -2638,11 +2643,15 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		int iafamily = AF_INET;
 
 		inner_mode = xfrm_get_mode(x->props.mode, x->props.family);
-		if (inner_mode == NULL)
+		if (inner_mode == NULL) {
+			NL_SET_ERR_MSG(extack, "Requested mode not found");
 			goto error;
+		}
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL))
+		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL)) {
+			NL_SET_ERR_MSG(extack, "Only tunnel modes can accommodate an AF_UNSPEC selector");
 			goto error;
+		}
 
 		x->inner_mode = *inner_mode;
 
@@ -2657,8 +2666,10 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 	}
 
 	x->type = xfrm_get_type(x->id.proto, family);
-	if (x->type == NULL)
+	if (x->type == NULL) {
+		NL_SET_ERR_MSG(extack, "Requested type not found");
 		goto error;
+	}
 
 	x->type_offload = xfrm_get_type_offload(x->id.proto, family, offload);
 
@@ -2668,6 +2679,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 
 	outer_mode = xfrm_get_mode(x->props.mode, family);
 	if (!outer_mode) {
+		NL_SET_ERR_MSG(extack, "Requested mode not found");
 		err = -EPROTONOSUPPORT;
 		goto error;
 	}
@@ -2689,7 +2701,7 @@ int xfrm_init_state(struct xfrm_state *x)
 {
 	int err;
 
-	err = __xfrm_init_state(x, true, false);
+	err = __xfrm_init_state(x, true, false, NULL);
 	if (!err)
 		x->km.state = XFRM_STATE_VALID;
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 2cf5956b562e..14e9b84f9dad 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -721,7 +721,7 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 	if (attrs[XFRMA_IF_ID])
 		x->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
-	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV]);
+	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV], extack);
 	if (err)
 		goto error;
 
-- 
2.37.3

