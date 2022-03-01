Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC424C8C5B
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiCANQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiCANQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:16:05 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45E7F8A31C
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 05:15:25 -0800 (PST)
Received: from LAPTOP-CHBRPQ78.localdomain (dynamic-089-012-174-087.89.12.pool.telefonica.de [89.12.174.87])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4403D20B7188;
        Tue,  1 Mar 2022 05:15:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4403D20B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646140525;
        bh=qiPALIgSs2SdpVt0gbRq2/9iYIopX3RuiI8hKKfHmnY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MnmFz+0Y0qw4f5DVrrbT4N63OPfliEsMNHVFJNKPZx2YV148hkAoQxXCkB4Hl7l3O
         hsEm1bZnhhjOUhknfuPyQ6w3mTKpoz648oU9kAkfyEEXsjui//Yn+hbEAAiEjERriy
         EiQgg+/l7zYiDLrVXdcLAyJ59mUg8Z2PohMFviP4=
From:   kailueke@linux.microsoft.com
To:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH 2/2] Revert "xfrm: state and policy should fail if XFRMA_IF_ID 0"
Date:   Tue,  1 Mar 2022 14:15:12 +0100
Message-Id: <20220301131512.1303-2-kailueke@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301131512.1303-1-kailueke@linux.microsoft.com>
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
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

This reverts commit 68ac0f3810e76a853b5f7b90601a05c3048b8b54 because it
breaks userspace (e.g., Cilium is affected because it used id 0 for the
dummy state https://github.com/cilium/cilium/pull/18789).

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

