Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F94E280CFF
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 07:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgJBFBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 01:01:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41930 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgJBFB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 01:01:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AC59420534;
        Fri,  2 Oct 2020 07:01:25 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5ZQIO_pkhgkE; Fri,  2 Oct 2020 07:01:25 +0200 (CEST)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A61802019C;
        Fri,  2 Oct 2020 07:01:24 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 2 Oct 2020 07:01:24 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 2 Oct 2020
 07:01:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3F3163180032;
 Fri,  2 Oct 2020 07:01:23 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/7] xfrm: Provide API to register translator module
Date:   Fri, 2 Oct 2020 07:01:07 +0200
Message-ID: <20201002050113.2210-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002050113.2210-1-steffen.klassert@secunet.com>
References: <20201002050113.2210-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

Add a skeleton for xfrm_compat module and provide API to register it in
xfrm_state.ko. struct xfrm_translator will have function pointers to
translate messages received from 32-bit userspace or to be sent to it
from 64-bit kernel.
module_get()/module_put() are used instead of rcu_read_lock() as the
module will vmalloc() memory for translation.
The new API is registered with xfrm_state module, not with xfrm_user as
the former needs translator for user_policy set by setsockopt() and
xfrm_user already uses functions from xfrm_state.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     | 19 +++++++++++++
 net/xfrm/Kconfig       | 10 +++++++
 net/xfrm/Makefile      |  1 +
 net/xfrm/xfrm_compat.c | 29 ++++++++++++++++++++
 net/xfrm/xfrm_state.c  | 60 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 119 insertions(+)
 create mode 100644 net/xfrm/xfrm_compat.c

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2737d24ec244..fe2e3717da14 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2000,6 +2000,25 @@ static inline int xfrm_tunnel_check(struct sk_buff *skb, struct xfrm_state *x,
 	return 0;
 }
 
+struct xfrm_translator {
+	struct module *owner;
+};
+
+#if IS_ENABLED(CONFIG_XFRM_USER_COMPAT)
+extern int xfrm_register_translator(struct xfrm_translator *xtr);
+extern int xfrm_unregister_translator(struct xfrm_translator *xtr);
+extern struct xfrm_translator *xfrm_get_translator(void);
+extern void xfrm_put_translator(struct xfrm_translator *xtr);
+#else
+static inline struct xfrm_translator *xfrm_get_translator(void)
+{
+	return NULL;
+}
+static inline void xfrm_put_translator(struct xfrm_translator *xtr)
+{
+}
+#endif
+
 #if IS_ENABLED(CONFIG_IPV6)
 static inline bool xfrm6_local_dontfrag(const struct sock *sk)
 {
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 5b9a5ab48111..e79b48dab61b 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -28,6 +28,16 @@ config XFRM_USER
 
 	  If unsure, say Y.
 
+config XFRM_USER_COMPAT
+	tristate "Compatible ABI support"
+	depends on XFRM_USER && COMPAT_FOR_U64_ALIGNMENT
+	select WANT_COMPAT_NETLINK_MESSAGES
+	help
+	  Transformation(XFRM) user configuration interface like IPsec
+	  used by compatible Linux applications.
+
+	  If unsure, say N.
+
 config XFRM_INTERFACE
 	tristate "Transformation virtual interface"
 	depends on XFRM && IPV6
diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index 2d4bb4b9f75e..494aa744bfb9 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
 obj-$(CONFIG_XFRM_STATISTICS) += xfrm_proc.o
 obj-$(CONFIG_XFRM_ALGO) += xfrm_algo.o
 obj-$(CONFIG_XFRM_USER) += xfrm_user.o
+obj-$(CONFIG_XFRM_USER_COMPAT) += xfrm_compat.o
 obj-$(CONFIG_XFRM_IPCOMP) += xfrm_ipcomp.o
 obj-$(CONFIG_XFRM_INTERFACE) += xfrm_interface.o
 obj-$(CONFIG_XFRM_ESPINTCP) += espintcp.o
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
new file mode 100644
index 000000000000..f01d9af41c55
--- /dev/null
+++ b/net/xfrm/xfrm_compat.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * XFRM compat layer
+ * Author: Dmitry Safonov <dima@arista.com>
+ * Based on code and translator idea by: Florian Westphal <fw@strlen.de>
+ */
+#include <linux/compat.h>
+#include <linux/xfrm.h>
+#include <net/xfrm.h>
+
+static struct xfrm_translator xfrm_translator = {
+	.owner				= THIS_MODULE,
+};
+
+static int __init xfrm_compat_init(void)
+{
+	return xfrm_register_translator(&xfrm_translator);
+}
+
+static void __exit xfrm_compat_exit(void)
+{
+	xfrm_unregister_translator(&xfrm_translator);
+}
+
+module_init(xfrm_compat_init);
+module_exit(xfrm_compat_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dmitry Safonov");
+MODULE_DESCRIPTION("XFRM 32-bit compatibility layer");
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 69520ad3d83b..cc206ca3df78 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2264,6 +2264,66 @@ static bool km_is_alive(const struct km_event *c)
 	return is_alive;
 }
 
+#if IS_ENABLED(CONFIG_XFRM_USER_COMPAT)
+static DEFINE_SPINLOCK(xfrm_translator_lock);
+static struct xfrm_translator __rcu *xfrm_translator;
+
+struct xfrm_translator *xfrm_get_translator(void)
+{
+	struct xfrm_translator *xtr;
+
+	rcu_read_lock();
+	xtr = rcu_dereference(xfrm_translator);
+	if (unlikely(!xtr))
+		goto out;
+	if (!try_module_get(xtr->owner))
+		xtr = NULL;
+out:
+	rcu_read_unlock();
+	return xtr;
+}
+EXPORT_SYMBOL_GPL(xfrm_get_translator);
+
+void xfrm_put_translator(struct xfrm_translator *xtr)
+{
+	module_put(xtr->owner);
+}
+EXPORT_SYMBOL_GPL(xfrm_put_translator);
+
+int xfrm_register_translator(struct xfrm_translator *xtr)
+{
+	int err = 0;
+
+	spin_lock_bh(&xfrm_translator_lock);
+	if (unlikely(xfrm_translator != NULL))
+		err = -EEXIST;
+	else
+		rcu_assign_pointer(xfrm_translator, xtr);
+	spin_unlock_bh(&xfrm_translator_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(xfrm_register_translator);
+
+int xfrm_unregister_translator(struct xfrm_translator *xtr)
+{
+	int err = 0;
+
+	spin_lock_bh(&xfrm_translator_lock);
+	if (likely(xfrm_translator != NULL)) {
+		if (rcu_access_pointer(xfrm_translator) != xtr)
+			err = -EINVAL;
+		else
+			RCU_INIT_POINTER(xfrm_translator, NULL);
+	}
+	spin_unlock_bh(&xfrm_translator_lock);
+	synchronize_rcu();
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(xfrm_unregister_translator);
+#endif
+
 int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 {
 	int err;
-- 
2.17.1

