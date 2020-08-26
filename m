Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC1E252539
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgHZBuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgHZBtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 21:49:55 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC59EC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:54 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c15so145158wrs.11
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hqV9N4PnRzxhj1tk/i32inIsQ5DaM9n+01b3HzAWtM4=;
        b=G5SLKC1ql/dsc2y6ZL6itoWZCs1rqbPxKNYeTKPNOOSKUCymG+f0FM/tTKla3RsWu6
         xbCvKYKcZEor5Dt2866Bqua5wnsNZj5cq/dbBaXYH2oJwt49zIg7Bl0OZK9GHV4vl4yT
         67QKjIdjz4vBGLOirWo1SpfhcdYYIqrJl3z4OpRdqs+nCJbVDhbg1afekUT70kj1qbl7
         kPTM1hhv6XR76pOHqilpvAMPr9yzNaF/MGsy8Gd/qLVb1g0Vk2kKgcDHQbreXkLbFcJQ
         /kv87Gi1w3ECzlIOJqlb9EcqgbMtTDMwjAE9Febr8sGR6xsfZjAejKucfT4O5baTjEOd
         mlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hqV9N4PnRzxhj1tk/i32inIsQ5DaM9n+01b3HzAWtM4=;
        b=AM1y0G7tMsfQRjsPkEM01yj5rqNFzXLHLLF5tmrJyozFO8zf9f81lHLzsO+ffoDZ4S
         K9JPM36FJoCImdqeb75JJlwfK0HXW4W12z//79zFzkT4ru7T5UQGXN86n6Pe5Va8r6HK
         cgjbrYn7U4MjMN+N3/qfKBRTATwFv31v3CFV4kXr2Ey+dyqxcsDtSCqrFODas9akhKDS
         YA/onROCHm3r4RvaC8gwmk+FRTKHk9XdC8LSTPqjxM2nNhpxFGzHA6nq+FeLOZfWM/3r
         peUEGNQ/+3F2wA2pQn4wJ1P7kfZnLXvTWdEtsSVX0xVtl73RK6bfO19I+rKxjqcHScWZ
         ZIzg==
X-Gm-Message-State: AOAM5302uhntYtje7jQeSedtgQak1jU1npwDGv9LvDm/Z51KMfnOwBaf
        81sf/0cZu2k10uCN3N8p3v6GFQ==
X-Google-Smtp-Source: ABdhPJxJDpn1yedpzrMT7hq3tCucb4nRQwekOG5bMmg2xkCEMzc4OBQ/2aS+jcXvbp+swlp0OOvbaw==
X-Received: by 2002:adf:b442:: with SMTP id v2mr4999276wrd.213.1598406593323;
        Tue, 25 Aug 2020 18:49:53 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c10sm1263661wmk.30.2020.08.25.18.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 18:49:52 -0700 (PDT)
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
Subject: [PATCH v2 2/6] xfrm/compat: Attach xfrm dumps to 64=>32 bit translator
Date:   Wed, 26 Aug 2020 02:49:45 +0100
Message-Id: <20200826014949.644441-3-dima@arista.com>
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

Currently nlmsg_unicast() is used by functions that dump structures that
can be different in size for compat tasks, see dump_one_state() and
dump_one_policy().

The following nlmsg_unicast() users exist today in xfrm:

         Function                          |    Message can be different
                                           |       in size on compat
-------------------------------------------|------------------------------
    xfrm_get_spdinfo()                     |               N
    xfrm_get_sadinfo()                     |               N
    xfrm_get_sa()                          |               Y
    xfrm_alloc_userspi()                   |               Y
    xfrm_get_policy()                      |               Y
    xfrm_get_ae()                          |               N

Besides, dump_one_state() and dump_one_policy() can be used by filtered
netlink dump for XFRM_MSG_GETSA, XFRM_MSG_GETPOLICY.

Just as for xfrm multicast, allocate frag_list for compat skb journey
down to recvmsg() which will give user the desired skb according to
syscall bitness.

[1]: https://lkml.kernel.org/r/20180726023144.31066-1-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/xfrm.h     |  6 ++++++
 net/xfrm/xfrm_compat.c | 10 ++++++++--
 net/xfrm/xfrm_user.c   | 20 ++++++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9810b5090338..9febf4f5d2ea 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2002,12 +2002,18 @@ static inline int xfrm_tunnel_check(struct sk_buff *skb, struct xfrm_state *x,
 
 #ifdef CONFIG_XFRM_USER_COMPAT
 extern int xfrm_alloc_compat(struct sk_buff *skb);
+extern int __xfrm_alloc_compat(struct sk_buff *skb, const struct nlmsghdr *nlh);
 extern const int xfrm_msg_min[XFRM_NR_MSGTYPES];
 #else
 static inline int xfrm_alloc_compat(struct sk_buff *skb)
 {
 	return 0;
 }
+static inline int __xfrm_alloc_compat(struct sk_buff *skb,
+				      const struct nlmsghdr *nlh)
+{
+	return 0;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index b9eb65dde0db..b34c8b56a571 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -272,9 +272,8 @@ static int xfrm_xlate64(struct sk_buff *dst, const struct nlmsghdr *nlh_src)
 	return 0;
 }
 
-int xfrm_alloc_compat(struct sk_buff *skb)
+int __xfrm_alloc_compat(struct sk_buff *skb, const struct nlmsghdr *nlh_src)
 {
-	const struct nlmsghdr *nlh_src = nlmsg_hdr(skb);
 	u16 type = nlh_src->nlmsg_type - XFRM_MSG_BASE;
 	struct sk_buff *new = NULL;
 	int err;
@@ -300,3 +299,10 @@ int xfrm_alloc_compat(struct sk_buff *skb)
 
 	return 0;
 }
+
+int xfrm_alloc_compat(struct sk_buff *skb)
+{
+	const struct nlmsghdr *nlh_src = nlmsg_hdr(skb);
+
+	return __xfrm_alloc_compat(skb, nlh_src);
+}
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 90c57d4a0b47..d135c6949336 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -992,6 +992,13 @@ static int dump_one_state(struct xfrm_state *x, int count, void *ptr)
 		return err;
 	}
 	nlmsg_end(skb, nlh);
+
+	err = __xfrm_alloc_compat(skb, nlh);
+	if (err) {
+		nlmsg_cancel(skb, nlh);
+		return err;
+	}
+
 	return 0;
 }
 
@@ -1365,6 +1372,12 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
+	err = xfrm_alloc_compat(skb);
+	if (err) {
+		kfree_skb(resp_skb);
+		goto out;
+	}
+
 	err = nlmsg_unicast(net->xfrm.nlsk, resp_skb, NETLINK_CB(skb).portid);
 
 out:
@@ -1795,6 +1808,13 @@ static int dump_one_policy(struct xfrm_policy *xp, int dir, int count, void *ptr
 		return err;
 	}
 	nlmsg_end(skb, nlh);
+
+	err = __xfrm_alloc_compat(skb, nlh);
+	if (err) {
+		nlmsg_cancel(skb, nlh);
+		return err;
+	}
+
 	return 0;
 }
 
-- 
2.27.0

