Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C9047DC51
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 01:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238201AbhLWAqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 19:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238185AbhLWAqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 19:46:05 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDE4C061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 16:46:04 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id t184-20020a2546c1000000b006008b13c80bso7223566yba.1
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 16:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UV3u5/X3O4BC3ts6NgMJUuM/YxD8qW8ba8JPBvbFYD8=;
        b=DfB4UvH8SXB/ifcUPJ4l0BoVVhepA32p0XrIVBv6vr6ayes/FJSPp8/UGJxMrUfai6
         MGQ5giJCi/w7ntLX96qKCBaiIs5rr8RbOiHriv8s7JspoCYM73JH1ss/YiTAxkIjVleY
         bakMe5RHB0Bu8km4PeHkxZk4MlTXTszxoTJ11ljl2ptfWeaFmzQhfZcaicfKVhpUB0vY
         EI/OKz1MvrkFl0YKYuQVr3RaNZqdKfw4wz3YIvl1q0MXC3DoH6RoXW5DJb3eRt0hTJsN
         EmfoXvoq32X0LlBnu0y1XF/pfpFDTrFCkr3OhhAnkJcdrOHkxOYFNshXewBUjXsFVgmU
         L4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UV3u5/X3O4BC3ts6NgMJUuM/YxD8qW8ba8JPBvbFYD8=;
        b=QLPaS2LwaszM8pbIATk1k7xrD+/VazIU6RvCTz8NeVifr/gOVBhYarb0RxKTMrXIUT
         NVzLMHs3hLTeHd0QhG/In2ndbD4qE1hLOBvTTh38lzau8VIE0nFb7fZsmVinJ+gIXi1g
         Wp8oGkF1yCmr4EFa2OEstBU+po1UB7kyOtVmDSl8xIalaIiNj6jeCa10CrQZVlnfWMId
         TSWL86ISgljB6DSLwhSfQEKwqiUAuUYqtvWxciQqiGAVHbhAkbhggdN/b353oldCM1wH
         +VRAVGB0gp+gpa0D5Xtp5lqfCKBDUrmKbyqwHqc8R+HKOi3Be+3wXT0gs4rp+OFSrLj6
         bjxQ==
X-Gm-Message-State: AOAM53022E9DMEcSEtEJwIgXxmVOaz76v4BnlaYHoPS1/H2ieGF5prRx
        Q/zKAJjefW9UnVAhQaQnh/JmMSr8WRw85w==
X-Google-Smtp-Source: ABdhPJxM6pX5w2EOCucE4O6sZqxRwvVpEbz8tHBb5y1zXeMp/IWB9lKN3oCi+WlqK+Kf93LZcmRZYItYulAzAw==
X-Received: from evitayan.mtv.corp.google.com ([2620:0:1000:5711:78f5:9c84:70bc:be20])
 (user=evitayan job=sendgmr) by 2002:a25:ae51:: with SMTP id
 g17mr223801ybe.738.1640220364218; Wed, 22 Dec 2021 16:46:04 -0800 (PST)
Date:   Wed, 22 Dec 2021 16:45:55 -0800
In-Reply-To: <20211223004555.1284666-1-evitayan@google.com>
Message-Id: <20211223004555.1284666-3-evitayan@google.com>
Mime-Version: 1.0
References: <20211223004555.1284666-1-evitayan@google.com>
X-Mailer: git-send-email 2.34.1.307.g9b7440fafd-goog
Subject: [PATCH v1 2/2] xfrm: Fix xfrm migrate issues when address family changes
From:   Yan Yan <evitayan@google.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, nharold@google.com,
        benedictwong@google.com, maze@google.com, lorenzo@google.com,
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
 net/xfrm/xfrm_state.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 74d4283ed282..56a3530f1b67 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1503,7 +1503,7 @@ static inline int clone_security(struct xfrm_state *x, struct xfrm_sec_ctx *secu
 	return 0;
 }
 
-static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
+static struct xfrm_state *xfrm_state_clone1(struct xfrm_state *orig,
 					   struct xfrm_encap_tmpl *encap)
 {
 	struct net *net = xs_net(orig);
@@ -1578,8 +1578,20 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
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
+static int *xfrm_state_clone2(struct xfrm_state *orig,
+			      struct xfrm_state *x)
+{
+	int err = xfrm_init_state(x);
+	if (err < 0)
+		return err;
 
 	x->props.flags = orig->props.flags;
 	x->props.extra_flags = orig->props.extra_flags;
@@ -1594,12 +1606,7 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
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
@@ -1660,10 +1667,14 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
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
2.34.1.307.g9b7440fafd-goog

