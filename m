Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F8135428B
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbhDEOEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:04:35 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:39540 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235903AbhDEOEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 10:04:35 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2021 10:04:34 EDT
Received: from localhost.localdomain (unknown [124.16.141.242])
        by APP-01 (Coremail) with SMTP id qwCowADXd6XiFmtgiWMrAQ--.25216S2;
        Mon, 05 Apr 2021 21:56:01 +0800 (CST)
From:   Jianmin Wang <jianmin@iscas.ac.cn>
To:     stable@vger.kernel.org
Cc:     omosnace@redhat.com, davem@davemloft.net, dzickus@redhat.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, smueller@chronox.de,
        steffen.klassert@secunet.com, Jianmin Wang <jianmin@iscas.ac.cn>
Subject: [PATCH] backports: crypto user - make NETLINK_CRYPTO work inside netns
Date:   Mon,  5 Apr 2021 13:55:15 +0000
Message-Id: <20210405135515.50873-1-jianmin@iscas.ac.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20190709111124.31127-1-omosnace@redhat.com>
References: <20190709111124.31127-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowADXd6XiFmtgiWMrAQ--.25216S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAw18XrWDGw18tw17Cr4rXwb_yoWruw4kpF
        W5A3y3Jr47Jr1kurWxXrsYvr9Ig348ur13CrW8Cw1rAw4qgry8XFWIyrnxAr13CFWvga43
        GFWIkr45Cw4UJ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
        628vn2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
        GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvj
        fUoOJ5UUUUU
X-Originating-IP: [124.16.141.242]
X-CM-SenderInfo: xmld0z1lq6x2xfdvhtffof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is same problem found in linux 4.19.y as upstream commit. The 
changes of crypto_user_* and cryptouser.h files from upstream patch are merged into 
crypto/crypto_user.c for backporting.

Upstream commit:
    commit 91b05a7e7d8033a90a64f5fc0e3808db423e420a
    Author: Ondrej Mosnacek <omosnace@redhat.com>
    Date:   Tue,  9 Jul 2019 13:11:24 +0200

    Currently, NETLINK_CRYPTO works only in the init network namespace. It
    doesn't make much sense to cut it out of the other network namespaces,
    so do the minor plumbing work necessary to make it work in any network
    namespace. Code inspired by net/core/sock_diag.c.

    Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
    Signed-off-by: default avatarHerbert Xu <herbert@gondor.apana.org.au>

Signed-off-by: Jianmin Wang <jianmin@iscas.ac.cn>
---
 crypto/crypto_user.c        | 37 +++++++++++++++++++++++++------------
 include/net/net_namespace.h |  3 +++
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index f847c181a39c..3f9e8e6e96f2 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -22,8 +22,9 @@
 #include <linux/crypto.h>
 #include <linux/cryptouser.h>
 #include <linux/sched.h>
-#include <net/netlink.h>
 #include <linux/security.h>
+#include <net/netlink.h>
+#include <net/sock.h>
 #include <net/net_namespace.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/rng.h>
@@ -36,9 +37,6 @@
 
 static DEFINE_MUTEX(crypto_cfg_mutex);
 
-/* The crypto netlink socket */
-static struct sock *crypto_nlsk;
-
 struct crypto_dump_info {
 	struct sk_buff *in_skb;
 	struct sk_buff *out_skb;
@@ -260,6 +258,7 @@ static int crypto_report_alg(struct crypto_alg *alg,
 static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 			 struct nlattr **attrs)
 {
+	struct net *net = sock_net(in_skb->sk);
 	struct crypto_user_alg *p = nlmsg_data(in_nlh);
 	struct crypto_alg *alg;
 	struct sk_buff *skb;
@@ -293,7 +292,7 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 		return err;
 	}
 
-	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
+	return nlmsg_unicast(net->crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
 }
 
 static int crypto_dump_report(struct sk_buff *skb, struct netlink_callback *cb)
@@ -494,6 +493,7 @@ static const struct crypto_link {
 static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
+	struct net *net = sock_net(skb->sk);
 	struct nlattr *attrs[CRYPTOCFGA_MAX+1];
 	const struct crypto_link *link;
 	int type, err;
@@ -524,7 +524,7 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 				.done = link->done,
 				.min_dump_alloc = min(dump_alloc, 65535UL),
 			};
-			err = netlink_dump_start(crypto_nlsk, skb, nlh, &c);
+			err = netlink_dump_start(net->crypto_nlsk, skb, nlh, &c);
 		}
 
 		return err;
@@ -548,22 +548,35 @@ static void crypto_netlink_rcv(struct sk_buff *skb)
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
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 5007eaba207d..ab5e8fd011f9 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -158,6 +158,9 @@ struct net {
 #endif
 #if IS_ENABLED(CONFIG_CAN)
 	struct netns_can	can;
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
+	struct sock		*crypto_nlsk;
 #endif
 	struct sock		*diag_nlsk;
 	atomic_t		fnhe_genid;
-- 
2.27.0

