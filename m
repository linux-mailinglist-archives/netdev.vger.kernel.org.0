Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5520D2727C3
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgIUOhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727472AbgIUOhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:37:02 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8FDC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:02 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y15so12981625wmi.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dhNUSjtknGrubyqMNO4t3ojcZsAMiZG6RyzJmu5xnyI=;
        b=V8evf+YVy5bsIUbxj5GEkB5fwKhKzcxhspryAYm/ecH+ZbrAYORwxHXWRBjrolj2+c
         K+3MO3sqYTrHZnZXW75l1nOndcxxI5/w2CaFMU0L0O7SQARTQDGRtuCmLmRjphTShYyd
         n5a7gvgu9qWAekOEnLhweceuLxKHwIsrkIHG3Ben/TDn7GBg4+1dPfiYG35m2IB9vNjt
         cpIgtjUx+08UfT68eR608+/GOKZFD45vO9T1tln5ySxZmRAz/4W0eBB0tCyHiLFVftqy
         jb3ltPsse3cyLME/+I4nZ6MDcSQBqHoFBhbjCF/jBm3G/MVV8VkVmGL3KIbo+tqhDTZj
         APqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dhNUSjtknGrubyqMNO4t3ojcZsAMiZG6RyzJmu5xnyI=;
        b=pDgu80DY9sj5eCNDSSo/z5OLNnG7aTCve2vKuRQFoA0A2AaPdz/6vMhkhWZG+prr75
         3NxMvk6jw8wjAhPw++15t7SV1yaavHNdp9VHQHUfUqoVNyHejcw2p4bxaFlQoju4SZto
         BjuF3jEqdxUKPV8ygyPM7wqNxL7k4vYusVp+T4RR0MEvVioJdPBquAeOyXMZQYVQwD3N
         ebW5O3CMKDlKAWTyvPL8AfJO00WFhdCfHicr6RHeuYxO0vnwUuuAkPQLQqhmwc3uv9OY
         rW5APyuaSAW5UBxIT/36p/yMgfCvjXz/2RqpqFDRZB6p/1ExDkP8QYGksEHKv5M1fvKS
         aV6g==
X-Gm-Message-State: AOAM533HQdutUttozWaMnxUGc3ef3cXmeyzg02bDSetLf6p/em77acKN
        N+1PF0IFyUO1y7/QH9pKcOoW8A==
X-Google-Smtp-Source: ABdhPJyQI9m2xDQhHCH1UZCpg4lsHNPZAPJYz/kcBDk/T+eS9NA8HWfZM+JvKXu7kSHm1+HwJV+0Vg==
X-Received: by 2002:a1c:7f8b:: with SMTP id a133mr144191wmd.155.1600699020848;
        Mon, 21 Sep 2020 07:37:00 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c14sm20370753wrv.12.2020.09.21.07.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 07:37:00 -0700 (PDT)
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
Subject: [PATCH v3 1/7] xfrm: Provide API to register translator module
Date:   Mon, 21 Sep 2020 15:36:51 +0100
Message-Id: <20200921143657.604020-2-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143657.604020-1-dima@arista.com>
References: <20200921143657.604020-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.28.0

