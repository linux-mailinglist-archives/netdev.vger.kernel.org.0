Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300504C7858
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiB1Syn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiB1Sym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:54:42 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA713193EA
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 10:54:03 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-014-115-047.89.14.pool.telefonica.de [89.14.115.47])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8E72E20B7178;
        Mon, 28 Feb 2022 10:54:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8E72E20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646074443;
        bh=gehJpN3ClhCjCsPtrKYCkUwdeVE3E+1cEXBAQrLntVw=;
        h=Subject:From:To:References:Cc:Date:In-Reply-To:From;
        b=b0aB6UeAWfyoeAQivOdOZceWxPtZjLfXjHxvkoG1qTtv3vyGu1HoNTEuAed8TOh0k
         DsDpQOVm+KFv5d/+EfLFy4PCWwgkKhMb+v5xI8PUwUnqw+hnP5CrIwQ3txFgW/XCKE
         hBGOD9+mSR6gTZKgfcabZaTawm26ntHRt+qxfAjs=
Subject: [PATCH 2/2] Revert "xfrm: state and policy should fail if XFRMA_IF_ID
 0"
From:   =?UTF-8?B?S2FpIEzDvGtl?= <kailueke@linux.microsoft.com>
To:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>
References: <447cf566-8b6e-80d2-b20d-c20ccd89bdb9@linux.microsoft.com>
Cc:     Kai Lueke <kailueke@linux.microsoft.com>
Message-ID: <924f1394-5fd4-590a-16b4-fb4d60185972@linux.microsoft.com>
Date:   Mon, 28 Feb 2022 19:53:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <447cf566-8b6e-80d2-b20d-c20ccd89bdb9@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
@@ -630,13 +630,8 @@ static struct xfrm_state
*xfrm_state_construct(struct net *net,
 
     xfrm_smark_init(attrs, &x->props.smark);
 
-    if (attrs[XFRMA_IF_ID]) {
+    if (attrs[XFRMA_IF_ID])
         x->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-        if (!x->if_id) {
-            err = -EINVAL;
-            goto error;
-        }
-    }
 
     err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV]);
     if (err)
@@ -1432,13 +1427,8 @@ static int xfrm_alloc_userspi(struct sk_buff
*skb, struct nlmsghdr *nlh,
 
     mark = xfrm_mark_get(attrs, &m);
 
-    if (attrs[XFRMA_IF_ID]) {
+    if (attrs[XFRMA_IF_ID])
         if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-        if (!if_id) {
-            err = -EINVAL;
-            goto out_noput;
-        }
-    }
 
     if (p->info.seq) {
         x = xfrm_find_acq_byseq(net, mark, p->info.seq);
@@ -1751,13 +1741,8 @@ static struct xfrm_policy
*xfrm_policy_construct(struct net *net, struct xfrm_us
 
     xfrm_mark_get(attrs, &xp->mark);
 
-    if (attrs[XFRMA_IF_ID]) {
+    if (attrs[XFRMA_IF_ID])
         xp->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-        if (!xp->if_id) {
-            err = -EINVAL;
-            goto error;
-        }
-    }
 
     return xp;
  error:
-- 
2.35.1

