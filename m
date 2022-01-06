Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43ED485DBB
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 01:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344210AbiAFAzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 19:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344423AbiAFAzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 19:55:08 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E145BC033268
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 16:53:04 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id g130-20020a255288000000b0060ba07af29eso2177997ybb.2
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 16:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LitnmfvbppqQmjzzrwUW7HOvoO5lCmBc9Cwn4Ny3VlQ=;
        b=qj0YUKdlJ7bvF0wC3Ns5yO7a6DkH19iSaJXhKOPwv+wXZT0Wy2q2w6fohmhIa8ocw3
         I1pHOhvE1kncdwoQKerb2qQQYJ2Ptfftrb2XuMkS6IeJ/ELcQ56zGO8WewDCeA/b0ZlU
         Y03rl1ShMX0PIaKPKzdfx2AbzcZ2oM7xtEnLXtu0mOIL1jidBPTnBirfdxNuGh341XLm
         VrBAdSZqliMkrxoqs8sG0yWKkrIhCDhzaa1oZZrU9pLy+ebYyAfanW1/NLTWgcPms4lz
         Ls6PpCM1I33UabA4DR0xUI7LlYnRiScFkfbX0Z+F0AXqmoIlbISAO8m9G9B5wRZa0nz5
         9Elg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LitnmfvbppqQmjzzrwUW7HOvoO5lCmBc9Cwn4Ny3VlQ=;
        b=duQzSaKcxW/2tNkPImxgpWC7lgKb7bC4DEet+Mlkmplh1VGRcfhX/6zwEaJwbtnu6d
         1cpMpWV4NolL8m2W+1wp/YK0TY+5knTBE0IYE7mGGzG3Ofp76QMklE6bMfAs2UucGyE2
         SYmAhwMDJmclJJ9r4JVPuHsSE2ESfAOz24vh0DvEcxk+pjLVfCrjq8VbMIDpix2xu3Zm
         c1I7kEOx1g8kK2Cx3G98re6Q4AV0i/DL/cgrk5ZNhufoboReXk/cG74rb3IxPBGi0xeh
         fu0Xxdeb3wdafugGFnZLuwy9q21kQLfDDtLJ0nYjS6/w4CedtjpMJgRAgl45WSx1N9he
         CBQw==
X-Gm-Message-State: AOAM531mQyBpVsANxHL0M6tf+6wPmQIBqNn0H4TsVi0KCthfpBlBYIVQ
        UAc7NRi7NT8VGu2/LdGUw9xH9/Zl3Ho6qQ==
X-Google-Smtp-Source: ABdhPJzDdq/Dic477xp3N/F8+1vynp3SBeh+SLAY6U0cBGxRNLbRYQp+Ir+6RpXlEWLtSbdEaaU/jLUs+pwy3Q==
X-Received: from evitayan.mtv.corp.google.com ([2620:0:1000:5711:bcd2:c148:e081:25e6])
 (user=evitayan job=sendgmr) by 2002:a25:305:: with SMTP id
 5mr66125750ybd.439.1641430384171; Wed, 05 Jan 2022 16:53:04 -0800 (PST)
Date:   Wed,  5 Jan 2022 16:52:51 -0800
In-Reply-To: <20220106005251.2833941-1-evitayan@google.com>
Message-Id: <20220106005251.2833941-3-evitayan@google.com>
Mime-Version: 1.0
References: <20220106005251.2833941-1-evitayan@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v1 2/2] xfrm: Fix xfrm migrate issues when address family changes
From:   Yan Yan <evitayan@google.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, lorenzo@google.com,
        maze@google.com, nharold@googlel.com, benedictwong@googlel.com,
        Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_migrate cannot handle address family change of an xfrm_state.
The symptons are the xfrm_state will be migrated to a wrong address,
and sending as well as receiving packets wil be broken.

This commit fixes it by breaking the original xfrm_state_clone
method into two steps so as to update the props.family before
running xfrm_init_state. As the result, xfrm_state's inner mode,
outer mode, type and IP header length in xfrm_state_migrate can
be updated with the new address family.

Tested with additions to Android's kernel unit test suite:
https://android-review.googlesource.com/c/kernel/tests/+/1885354

Signed-off-by: Yan Yan <evitayan@google.com>
---
 net/xfrm/xfrm_state.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index f52767685b13..cac212039bf9 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1504,8 +1504,8 @@ static inline int clone_security(struct xfrm_state *x, struct xfrm_sec_ctx *secu
 	return 0;
 }
 
-static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
-					   struct xfrm_encap_tmpl *encap)
+static struct xfrm_state *xfrm_state_clone1(struct xfrm_state *orig,
+					    struct xfrm_encap_tmpl *encap)
 {
 	struct net *net = xs_net(orig);
 	struct xfrm_state *x = xfrm_state_alloc(net);
@@ -1579,8 +1579,20 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	memcpy(&x->mark, &orig->mark, sizeof(x->mark));
 	memcpy(&x->props.smark, &orig->props.smark, sizeof(x->props.smark));
 
-	if (xfrm_init_state(x) < 0)
-		goto error;
+	return x;
+
+ error:
+	xfrm_state_put(x);
+out:
+	return NULL;
+}
+
+static int xfrm_state_clone2(struct xfrm_state *orig, struct xfrm_state *x)
+{
+	int err = xfrm_init_state(x);
+
+	if (err < 0)
+		return err;
 
 	x->props.flags = orig->props.flags;
 	x->props.extra_flags = orig->props.extra_flags;
@@ -1595,12 +1607,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->replay = orig->replay;
 	x->preplay = orig->preplay;
 
-	return x;
-
- error:
-	xfrm_state_put(x);
-out:
-	return NULL;
+	return 0;
 }
 
 struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
@@ -1661,10 +1668,14 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 {
 	struct xfrm_state *xc;
 
-	xc = xfrm_state_clone(x, encap);
+	xc = xfrm_state_clone1(x, encap);
 	if (!xc)
 		return NULL;
 
+	xc->props.family = m->new_family;
+	if (xfrm_state_clone2(x, xc) < 0)
+		goto error;
+
 	memcpy(&xc->id.daddr, &m->new_daddr, sizeof(xc->id.daddr));
 	memcpy(&xc->props.saddr, &m->new_saddr, sizeof(xc->props.saddr));
 
-- 
2.34.1.448.ga2b2bfdf31-goog

