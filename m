Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DC625253F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgHZBua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgHZBt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 21:49:59 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD77EC061755
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:58 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t2so210594wma.0
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e4t6U3EUl9NY1eR8G5VN1oS0eO15ITbNrKb6whnIP0g=;
        b=g4EIHMrbDMEUbiscTn3QFuAeClXpg+Vdb+FNk6Q4uS5sZ86p6vBRul2476uezkoV5h
         j+IvsR/puSssc0hh4u38RSkmYglA+VInmGMDkdJYfEInd2iut63+zdbPcfjFILl6ALMI
         4FYSnRWebcAp0PgxR9SsULbkpzUsc5almr+EBMYpnPO60Nev2LSIZt5zM9esUVSIVOSM
         LEdZIbsL712qjKzZtavB1/vgzT9y+bIC8RrOzc1uW6hUPqfJK4XbhdevMqAi++TzUZoM
         YB4hNaBgYD+mkBHZ0ENc8BR8Tb+WB+3embk57Lf9qzt48dNBGBrJhWNMTVzeKPvru1Kr
         7UdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e4t6U3EUl9NY1eR8G5VN1oS0eO15ITbNrKb6whnIP0g=;
        b=QP8zouVfHBAMcBqgtUCFTwDDN4sqbXdzSdxjC5OZBS0jpYTKRotmIvVnun2gcZLbfp
         8nxbn5j96G+lKtJfrvEL+ASNVOby+ifj1+AiIBJwEaRRoSmjiJbtK5ceidAosniuTwUD
         0uuXUR+S7OsT/xeNIFRwHL+KNme7OJbVmbEvxruCQKpxe45ENNcSC2+8naX0UAqFR7BI
         ANz0PutbGTwBRdid5nc6dEGDBtIZBtXZp4q7tgcmae26j6AFeCIW5CBQVVbVcvmPfRoU
         DJwv0opVxdh4NpPX3r1NmHGt7aYdoy0cLw/P5MZ98qH/FACG8nto5rCwJHonz3RQOuWY
         C2tg==
X-Gm-Message-State: AOAM533Slr9UUHpjHsXR3Kark5rXgaANshWNqNtgovhRpgHX5Sg1/37Y
        O4w1bcjnIPwSReRpsqLzBTHvVw==
X-Google-Smtp-Source: ABdhPJz1yjRrZ1vWfn8LOn/OBDGbfLRICmqtUlPKAO+EUwz0H3j1/shTHk9tXPJshoV0Qmmxp/gBOA==
X-Received: by 2002:a7b:c205:: with SMTP id x5mr4801417wmi.161.1598406597357;
        Tue, 25 Aug 2020 18:49:57 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c10sm1263661wmk.30.2020.08.25.18.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 18:49:56 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 5/6] xfrm/compat: Translate 32-bit user_policy from sockptr
Date:   Wed, 26 Aug 2020 02:49:48 +0100
Message-Id: <20200826014949.644441-6-dima@arista.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200826014949.644441-1-dima@arista.com>
References: <20200826014949.644441-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRM is disabled for compatible users because of the UABI difference.
The difference is in structures paddings and in the result the size
of netlink messages differ.

Possibility for compatible application to manage xfrm tunnels was
disabled by: the commmit 19d7df69fdb2 ("xfrm: Refuse to insert 32 bit
userspace socket policies on 64 bit systems") and the commit 74005991b78a
("xfrm: Do not parse 32bits compiled xfrm netlink msg on 64bits host").

This is my second attempt to resolve the xfrm/compat problem by adding
the 64=>32 and 32=>64 bit translators those non-visibly to a user
provide translation between compatible user and kernel.
Previous attempt was to interrupt the message ABI according to a syscall
by xfrm_user, which resulted in over-complicated code [1].

Florian Westphal provided the idea of translator and some draft patches
in the discussion. In these patches, his idea is reused and some of his
initial code is also present.

Provide compat_xfrm_userpolicy_info translation for xfrm setsocketopt().
Reallocate buffer and put the missing padding for 64-bit message.

[1]: https://lkml.kernel.org/r/20180726023144.31066-1-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/xfrm.h     |  5 +++++
 net/xfrm/xfrm_compat.c | 25 +++++++++++++++++++++++++
 net/xfrm/xfrm_state.c  | 11 ++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 242e690674c6..633c210bd2dd 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2009,6 +2009,7 @@ extern const int xfrm_msg_min[XFRM_NR_MSGTYPES];
 extern struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *nlh,
 			int maxtype, const struct nla_policy *policy,
 			struct netlink_ext_ack *extack);
+extern int xfrm_user_policy_compat(u8 **pdata32, int optlen);
 #else
 static inline int xfrm_alloc_compat(struct sk_buff *skb)
 {
@@ -2025,6 +2026,10 @@ static inline struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *n
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
+static inline int xfrm_user_policy_compat(u8 **pdata32, int optlen)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index 79daa7f47d5a..990eecfc4c0e 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -582,3 +582,28 @@ struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 
 	return h64;
 }
+
+int xfrm_user_policy_compat(u8 **pdata32, int optlen)
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
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 69520ad3d83b..053e6fe6ea7a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2271,9 +2271,6 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	struct xfrm_mgr *km;
 	struct xfrm_policy *pol = NULL;
 
-	if (in_compat_syscall())
-		return -EOPNOTSUPP;
-
 	if (sockptr_is_null(optval) && !optlen) {
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_IN, NULL);
 		xfrm_sk_policy_insert(sk, XFRM_POLICY_OUT, NULL);
@@ -2288,6 +2285,14 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
+	if (in_compat_syscall()) {
+		err = xfrm_user_policy_compat(&data, optlen);
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
2.27.0

