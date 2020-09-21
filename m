Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4962727CA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgIUOhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbgIUOhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:37:15 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD2EC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:14 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c18so13033732wrm.9
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rz68B5e7Vh9ActtZeBwvD2DMFaoedLBo1pL0wSDjm9E=;
        b=QqSzzxFM1zAvdLHvwihYi/CvrWN79ah8OytsxkIhNB60tz8wxnjn1G5eB0pSOLviXj
         +xkc0jj+6Rl5PpE+36TSVVM0rxMYUSpl1TfIr6U5QcSE1mLJqUNU6ea4RdAAVBWPOji4
         SDlNj0EZ6o0j2oGNvDFlH8IYozezHkUdbosaD4u7TFrN9Scdons3mmisifsO3YBGgi8P
         TXwc0GQXcvZ1TZDLLYnL37n4pO3YXvvVPd46Ql16ocwsMj38aFOvMiEs39EXrNUegcXs
         cfB6u2GY6L+aPLR4XmQ7YDg9j4qZg53Prrx8kQa1Luyc36cKHpTVXqI9Huf37KVkaf6z
         d1Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rz68B5e7Vh9ActtZeBwvD2DMFaoedLBo1pL0wSDjm9E=;
        b=AIZnKZ9Ys6+/S4ZC5U6uluLQ6eVbiAQHGVBlV8hXxs350UcLUij0BevmRcS00zQsCy
         AlSlzR86pfsvnqmYTooNZ7T8iZXglsxq5i7ggMr3OdxpznBv1U/xdtQZLUKfJCb6YFMh
         CrNODI/T06TBYXb6gfuSnMpW/+8HJHXKMjICJuMVggaABqh+5xGG7PLVyPVbC2frQEOe
         a+8Cjv4IzdNTT28aTMwxY1wWQVgRyqbHZ8V00GBGU9GhXIb3sbIIc4rovpJI765gyCOy
         31jpEF6d7jQH//PzezfbK2j46nqyCYbtAjsrKJ8tYfFXFy9cVqhp1FywytN/RdFRsAHU
         XNnw==
X-Gm-Message-State: AOAM531M8Z37+nkuPoR/RTsCsMqOjMDYFoXq3Aj/uZRnoBGQ0YH7gm5m
        S6b0IeTDz1xdIC35E5eQ/FUHNw==
X-Google-Smtp-Source: ABdhPJyIbHI5FhHnGlB8p7wXHAQLlxIqblVOoMIQ1zEYlHaf1pRWgXg9crqO/S6/PcpXaloRqw9Msg==
X-Received: by 2002:a5d:4f85:: with SMTP id d5mr76026wru.7.1600699033639;
        Mon, 21 Sep 2020 07:37:13 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c14sm20370753wrv.12.2020.09.21.07.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 07:37:13 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH v3 6/7] xfrm/compat: Translate 32-bit user_policy from sockptr
Date:   Mon, 21 Sep 2020 15:36:56 +0100
Message-Id: <20200921143657.604020-7-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143657.604020-1-dima@arista.com>
References: <20200921143657.604020-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide compat_xfrm_userpolicy_info translation for xfrm setsocketopt().
Reallocate buffer and put the missing padding for 64-bit message.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/xfrm.h     |  3 +++
 net/xfrm/xfrm_compat.c | 26 ++++++++++++++++++++++++++
 net/xfrm/xfrm_state.c  | 17 ++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index fa18cb6bb3f7..53618a31634b 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2012,6 +2012,9 @@ struct xfrm_translator {
 			int maxtype, const struct nla_policy *policy,
 			struct netlink_ext_ack *extack);
 
+	/* Translate 32-bit user_policy from sockptr */
+	int (*xlate_user_policy_sockptr)(u8 **pdata32, int optlen);
+
 	struct module *owner;
 };
 
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index b1b5f972538d..e28f0c9ecd6a 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -576,10 +576,36 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 	return h64;
 }
 
+static int xfrm_user_policy_compat(u8 **pdata32, int optlen)
+{
+	struct compat_xfrm_userpolicy_info *p = (void *)*pdata32;
+	u8 *src_templates, *dst_templates;
+	u8 *data64;
+
+	if (optlen < sizeof(*p))
+		return -EINVAL;
+
+	data64 = kmalloc_track_caller(optlen + 4, GFP_USER | __GFP_NOWARN);
+	if (!data64)
+		return -ENOMEM;
+
+	memcpy(data64, *pdata32, sizeof(*p));
+	memset(data64 + sizeof(*p), 0, 4);
+
+	src_templates = *pdata32 + sizeof(*p);
+	dst_templates = data64 + sizeof(*p) + 4;
+	memcpy(dst_templates, src_templates, optlen - sizeof(*p));
+
+	kfree(*pdata32);
+	*pdata32 = data64;
+	return 0;
+}
+
 static struct xfrm_translator xfrm_translator = {
 	.owner				= THIS_MODULE,
 	.alloc_compat			= xfrm_alloc_compat,
 	.rcv_msg_compat			= xfrm_user_rcv_msg_compat,
+	.xlate_user_policy_sockptr	= xfrm_user_policy_compat,
 };
 
 static int __init xfrm_compat_init(void)
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index cc206ca3df78..f9961884500b 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2331,9 +2331,6 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	struct xfrm_mgr *km;
 	struct xfrm_policy *pol = NULL;
 
-	if (in_compat_syscall())
-		return -EOPNOTSUPP;
-
 	if (sockptr_is_null(optval) && !optlen) {
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_IN, NULL);
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_OUT, NULL);
@@ -2348,6 +2345,20 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
+	if (in_compat_syscall()) {
+		struct xfrm_translator *xtr = xfrm_get_translator();
+
+		if (!xtr)
+			return -EOPNOTSUPP;
+
+		err = xtr->xlate_user_policy_sockptr(&data, optlen);
+		xfrm_put_translator(xtr);
+		if (err) {
+			kfree(data);
+			return err;
+		}
+	}
+
 	err = -EINVAL;
 	rcu_read_lock();
 	list_for_each_entry_rcu(km, &xfrm_km_list, list) {
-- 
2.28.0

