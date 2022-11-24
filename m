Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182FE637BA4
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKXOov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiKXOoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:44:46 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2F3EC09E
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:44:45 -0800 (PST)
Received: (Authenticated sender: sd@queasysnail.net)
        by mail.gandi.net (Postfix) with ESMTPSA id 2771CC0016;
        Thu, 24 Nov 2022 14:44:42 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 4/7] xfrm: add extack to xfrm_new_ae and xfrm_replay_verify_len
Date:   Thu, 24 Nov 2022 15:43:41 +0100
Message-Id: <8ecabf67e5a0c791e01bc9dc875aa14517d7f014.1668507420.git.sd@queasysnail.net>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668507420.git.sd@queasysnail.net>
References: <cover.1668507420.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.38.0

