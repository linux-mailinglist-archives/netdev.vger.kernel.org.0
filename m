Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322C8634C5
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 13:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfGILLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 07:11:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39374 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfGILLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 07:11:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so2775881wma.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 04:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jGmHTjJZW0kk7n8QDUWDYgDVD45moRikNT/Us3qktnE=;
        b=SESJc/kKCXaEnHHEIfL+I3Ym+s5pRSlaYU95NJ0g3XtXWE9U7c1J7b56bOxsqdNQTR
         qE1oP/QfITnuuspBcKeI8mes+L9U5ICMqValnq0EQhTjZt76AqCcI5jEEAntrFrLfHCx
         sWzWP1s6YSQxYW1iAuvhG0dXywKW21MRtjK6j2s54iYlzy/fqAZvWqB3WskA9h2+QTYV
         cI50N85Hm/iNZ4ht6vAAYPgIGkEVNMjIS6PqrnMD/r32K4qbLeyJLpWG13NurKSs/9Gy
         NQWAOVAkyRU99NfmCwVJiI/PzVUqDRzHepgGE1D2SDNuuDta4VuRk9CIZPuIyHL9nmgN
         /VwA==
X-Gm-Message-State: APjAAAVQfnAt+Xq1m4CxtmKGYnO5X+3PTDaBr/GrZcBUdfG05WPNumjv
        kgYY68PdPoPp4RQrNQ/E3+7Bwif9OiM=
X-Google-Smtp-Source: APXvYqzB1p33l7Nc3w4T72Di5XiH+Y863LiYt2Xo+TDGQ6NeAxdtE31ay/MrqW8AgHsR/2Ckcz8+uA==
X-Received: by 2002:a7b:cbcb:: with SMTP id n11mr21327811wmi.146.1562670687333;
        Tue, 09 Jul 2019 04:11:27 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f12sm21545425wrg.5.2019.07.09.04.11.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 04:11:26 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH] crypto: user - make NETLINK_CRYPTO work inside netns
Date:   Tue,  9 Jul 2019 13:11:24 +0200
Message-Id: <20190709111124.31127-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, NETLINK_CRYPTO works only in the init network namespace. It
doesn't make much sense to cut it out of the other network namespaces,
so do the minor plumbing work necessary to make it work in any network
namespace. Code inspired by net/core/sock_diag.c.

Tested using kcapi-dgst from libkcapi [1]:
Before:
    # unshare -n kcapi-dgst -c sha256 </dev/null | wc -c
    libkcapi - Error: Netlink error: sendmsg failed
    libkcapi - Error: Netlink error: sendmsg failed
    libkcapi - Error: NETLINK_CRYPTO: cannot obtain cipher information for hmac(sha512) (is required crypto_user.c patch missing? see documentation)
    0

After:
    # unshare -n kcapi-dgst -c sha256 </dev/null | wc -c
    32

[1] https://github.com/smuellerDD/libkcapi

Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 crypto/crypto_user_base.c            | 37 +++++++++++++++++++---------
 crypto/crypto_user_stat.c            |  4 ++-
 include/crypto/internal/cryptouser.h |  2 --
 include/net/net_namespace.h          |  3 +++
 4 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user_base.c
index e48da3b75c71..c92d415eaf82 100644
--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -22,9 +22,10 @@
 #include <linux/crypto.h>
 #include <linux/cryptouser.h>
 #include <linux/sched.h>
-#include <net/netlink.h>
 #include <linux/security.h>
+#include <net/netlink.h>
 #include <net/net_namespace.h>
+#include <net/sock.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/rng.h>
 #include <crypto/akcipher.h>
@@ -37,9 +38,6 @@
 
 static DEFINE_MUTEX(crypto_cfg_mutex);
 
-/* The crypto netlink socket */
-struct sock *crypto_nlsk;
-
 struct crypto_dump_info {
 	struct sk_buff *in_skb;
 	struct sk_buff *out_skb;
@@ -195,6 +193,7 @@ out:
 static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 			 struct nlattr **attrs)
 {
+	struct net *net = sock_net(in_skb->sk);
 	struct crypto_user_alg *p = nlmsg_data(in_nlh);
 	struct crypto_alg *alg;
 	struct sk_buff *skb;
@@ -226,7 +225,7 @@ drop_alg:
 	if (err)
 		return err;
 
-	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
+	return nlmsg_unicast(net->crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
 }
 
 static int crypto_dump_report(struct sk_buff *skb, struct netlink_callback *cb)
@@ -429,6 +428,7 @@ static const struct crypto_link {
 static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
+	struct net *net = sock_net(skb->sk);
 	struct nlattr *attrs[CRYPTOCFGA_MAX+1];
 	const struct crypto_link *link;
 	int type, err;
@@ -459,7 +459,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 				.done = link->done,
 				.min_dump_alloc = min(dump_alloc, 65535UL),
 			};
-			err = netlink_dump_start(crypto_nlsk, skb, nlh, &c);
+			err = netlink_dump_start(net->crypto_nlsk, skb, nlh, &c);
 		}
 
 		return err;
@@ -483,22 +483,35 @@ static void crypto_netlink_rcv(struct sk_buff *skb)
 	mutex_unlock(&crypto_cfg_mutex);
 }
 
-static int __init crypto_user_init(void)
+static int __net_init crypto_netlink_init(struct net *net)
 {
 	struct netlink_kernel_cfg cfg = {
 		.input	= crypto_netlink_rcv,
 	};
 
-	crypto_nlsk = netlink_kernel_create(&init_net, NETLINK_CRYPTO, &cfg);
-	if (!crypto_nlsk)
-		return -ENOMEM;
+	net->crypto_nlsk = netlink_kernel_create(net, NETLINK_CRYPTO, &cfg);
+	return net->crypto_nlsk == NULL ? -ENOMEM : 0;
+}
 
-	return 0;
+static void __net_exit crypto_netlink_exit(struct net *net)
+{
+	netlink_kernel_release(net->crypto_nlsk);
+	net->crypto_nlsk = NULL;
+}
+
+static struct pernet_operations crypto_netlink_net_ops = {
+	.init = crypto_netlink_init,
+	.exit = crypto_netlink_exit,
+};
+
+static int __init crypto_user_init(void)
+{
+	return register_pernet_subsys(&crypto_netlink_net_ops);
 }
 
 static void __exit crypto_user_exit(void)
 {
-	netlink_kernel_release(crypto_nlsk);
+	unregister_pernet_subsys(&crypto_netlink_net_ops);
 }
 
 module_init(crypto_user_init);
diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index a03f326a63d3..8bad88413de1 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -10,6 +10,7 @@
 #include <linux/cryptouser.h>
 #include <linux/sched.h>
 #include <net/netlink.h>
+#include <net/sock.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/rng.h>
 #include <crypto/akcipher.h>
@@ -298,6 +299,7 @@ out:
 int crypto_reportstat(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 		      struct nlattr **attrs)
 {
+	struct net *net = sock_net(in_skb->sk);
 	struct crypto_user_alg *p = nlmsg_data(in_nlh);
 	struct crypto_alg *alg;
 	struct sk_buff *skb;
@@ -329,7 +331,7 @@ drop_alg:
 	if (err)
 		return err;
 
-	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
+	return nlmsg_unicast(net->crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/include/crypto/internal/cryptouser.h b/include/crypto/internal/cryptouser.h
index 8c602b187c58..40623f4457df 100644
--- a/include/crypto/internal/cryptouser.h
+++ b/include/crypto/internal/cryptouser.h
@@ -1,8 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <net/netlink.h>
 
-extern struct sock *crypto_nlsk;
-
 struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact);
 
 #ifdef CONFIG_CRYPTO_STATS
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 12689ddfc24c..610e40eaea52 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -165,6 +165,9 @@ struct net {
 #endif
 #ifdef CONFIG_XDP_SOCKETS
 	struct netns_xdp	xdp;
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
+	struct sock		*crypto_nlsk;
 #endif
 	struct sock		*diag_nlsk;
 	atomic_t		fnhe_genid;
-- 
2.21.0

