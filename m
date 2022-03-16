Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787444DB2ED
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356443AbiCPOVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356812AbiCPOU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:20:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E90526103;
        Wed, 16 Mar 2022 07:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B1D061382;
        Wed, 16 Mar 2022 14:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DA4C340F0;
        Wed, 16 Mar 2022 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440314;
        bh=+uWzjtPEErYZO9ViCM9wjoTaNDSx+ib+WrOfuAS+bYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yub1VPD4Y/0P8BQGNgniCp8yfAX9Sk/uzD3Sy2vk4fJ6m+cLwI75l0Nb2u1BtU3u4
         YM+ab0bhemswf8oFJraw8rLq8Cs6Zm35I92fjLKjTcZr8u+hXQxNGi/0OjwzYeb7i6
         QdkpJLhlDx61b9jieQhoZ30XEluf/+tWjMgQkwfVVnOPjQ4CjKm3ceGm5miEytPq39
         Pl1CGRFlj9gFMBFaP98nsDOXgPTfxzYplGjgx3TK7/D47TAa/0dJLZkTGLGaTR4hBV
         0jfwjkqwleXy3X6LG2mg+hXjndDm5kdBBiMgZoinuPQN5X9ZIWSxzNTLgNL2zZ0XSW
         hA4pOwQI4vI7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Lueke <kailueke@linux.microsoft.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/6] Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"
Date:   Wed, 16 Mar 2022 10:18:14 -0400
Message-Id: <20220316141817.248621-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141817.248621-1-sashal@kernel.org>
References: <20220316141817.248621-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai Lueke <kailueke@linux.microsoft.com>

[ Upstream commit a3d9001b4e287fc043e5539d03d71a32ab114bcb ]

This reverts commit 68ac0f3810e76a853b5f7b90601a05c3048b8b54 because ID
0 was meant to be used for configuring the policy/state without
matching for a specific interface (e.g., Cilium is affected, see
https://github.com/cilium/cilium/pull/18789 and
https://github.com/cilium/cilium/pull/19019).

Signed-off-by: Kai Lueke <kailueke@linux.microsoft.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8d8f9e778cd4..87932f6ad9d7 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -620,13 +620,8 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 
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
@@ -1332,13 +1327,8 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 
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
@@ -1640,13 +1630,8 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 
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
2.34.1

