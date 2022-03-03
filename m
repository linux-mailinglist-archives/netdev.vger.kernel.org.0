Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8DC4CC06B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbiCCO4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234190AbiCCO4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:56:16 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A7EE18FAE0
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:55:30 -0800 (PST)
Received: from LAPTOP-CHBRPQ78.localdomain (dynamic-077-011-020-034.77.11.pool.telefonica.de [77.11.20.34])
        by linux.microsoft.com (Postfix) with ESMTPSA id B268A20B7178;
        Thu,  3 Mar 2022 06:55:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B268A20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646319329;
        bh=6raFnqFH7gCAGxa8fdvCcfzEBy0HlyjNuBUPg4l7/Ew=;
        h=From:To:Subject:Date:From;
        b=kHjWs+gUdyJy3ThbvyMHxwLspy0DStz1S0nG+UGcXmosrmgwpmCtA0q7mtIO0Yo4M
         JeAK2PbH0f+k6bzI6e/1JXkIJBz0OM9/3AnwEqVSQthWHe4yPsgVCGK80QeKlvqqAE
         LOlj4Xo0uAZIirB85FJmbEiq7WkrMcesIQ8h/Lkc=
From:   kailueke@linux.microsoft.com
To:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH] Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"
Date:   Thu,  3 Mar 2022 15:55:10 +0100
Message-Id: <20220303145510.324-1-kailueke@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai Lueke <kailueke@linux.microsoft.com>

This reverts commit 68ac0f3810e76a853b5f7b90601a05c3048b8b54 because ID
0 was meant to be used for configuring the policy/state without
matching for a specific interface (e.g., Cilium is affected, see
https://github.com/cilium/cilium/pull/18789 and
https://github.com/cilium/cilium/pull/19019).

Signed-off-by: Kai Lueke <kailueke@linux.microsoft.com>
---
 net/xfrm/xfrm_user.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8cd6c8129004..be89a8ac54a4 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -630,13 +630,8 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
 	xfrm_smark_init(attrs, &x->props.smark);
 
-	if (attrs[XFRMA_IF_ID]) {
+	if (attrs[XFRMA_IF_ID])
 		x->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-		if (!x->if_id) {
-			err = -EINVAL;
-			goto error;
-		}
-	}
 
 	err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV]);
 	if (err)
@@ -1432,13 +1427,8 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	mark = xfrm_mark_get(attrs, &m);
 
-	if (attrs[XFRMA_IF_ID]) {
+	if (attrs[XFRMA_IF_ID])
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-		if (!if_id) {
-			err = -EINVAL;
-			goto out_noput;
-		}
-	}
 
 	if (p->info.seq) {
 		x = xfrm_find_acq_byseq(net, mark, p->info.seq);
@@ -1751,13 +1741,8 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
 	xfrm_mark_get(attrs, &xp->mark);
 
-	if (attrs[XFRMA_IF_ID]) {
+	if (attrs[XFRMA_IF_ID])
 		xp->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-		if (!xp->if_id) {
-			err = -EINVAL;
-			goto error;
-		}
-	}
 
 	return xp;
  error:
-- 
2.25.1

