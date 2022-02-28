Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECBD4C784F
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiB1Stu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiB1Stt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:49:49 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF0D529C86
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 10:49:09 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-014-115-047.89.14.pool.telefonica.de [89.14.115.47])
        by linux.microsoft.com (Postfix) with ESMTPSA id 857DA20B7178;
        Mon, 28 Feb 2022 10:49:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 857DA20B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646074149;
        bh=b04T32vGx4U63rzcT8p4kS4XBc3/lw2LCbKV+frCfAk=;
        h=To:Cc:From:Subject:Date:From;
        b=sd9d6ykGo8U3S9uzoQSq1G8yZHJMDhpN4uUoYk55fRuzTuNVROGMfpDbKmV4bk1Dz
         Y/QXHUBy3TqJreUKWw1WUGzNa/F6eagJRbLzA+/CoZokbbLnTtt/aQPdOp7PeV4Veu
         i2ed4PFnhPIdpv0Oti18+RIqAkLwFBvo9+iZA81Y=
To:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eyal Birger <eyal.birger@gmail.com>
Cc:     Kai Lueke <kailuke@microsoft.com>
From:   =?UTF-8?B?S2FpIEzDvGtl?= <kailueke@linux.microsoft.com>
Subject: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return error"
Message-ID: <8c3bb411-26b4-d604-9c21-a1df510a8e93@linux.microsoft.com>
Date:   Mon, 28 Feb 2022 19:49:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
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
 
-    if (attrs[XFRMA_IF_ID]) {
+    if (attrs[XFRMA_IF_ID])
         x->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-        if (!x->if_id) {
-            err = -EINVAL;
-            goto error;
-        }
-    }
 
     err = __xfrm_init_state(x, false, attrs[XFRMA_OFFLOAD_DEV]);
     if (err)
@@ -1432,13 +1427,8 @@ static int xfrm_alloc_userspi(struct sk_buff
*skb, struct nlmsghdr *nlh,
 
     mark = xfrm_mark_get(attrs, &m);
 
-    if (attrs[XFRMA_IF_ID]) {
+    if (attrs[XFRMA_IF_ID])
         if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-        if (!if_id) {
-            err = -EINVAL;
-            goto out_noput;
-        }
-    }
 
     if (p->info.seq) {
         x = xfrm_find_acq_byseq(net, mark, p->info.seq);
@@ -1751,13 +1741,8 @@ static struct xfrm_policy
*xfrm_policy_construct(struct net *net, struct xfrm_us
 
     xfrm_mark_get(attrs, &xp->mark);
 
-    if (attrs[XFRMA_IF_ID]) {
+    if (attrs[XFRMA_IF_ID])
         xp->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
-        if (!xp->if_id) {
-            err = -EINVAL;
-            goto error;
-        }
-    }
 
     return xp;
  error:
-- 
2.35.1

