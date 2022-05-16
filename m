Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE260527CB5
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbiEPEZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiEPEZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:25:06 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7451E18379
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:05 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pt3-20020a17090b3d0300b001df448c8d79so2091510pjb.5
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zxxIu40tB7xyc4/4mwu0tXbbd4pQ0H0wSYiSFSUKaAg=;
        b=lErUHXRyfN+xmKA70nfUjnw6XiaRPSwszzQz3NC2ec6TgoeBrI4RbsEsBCkUZU3JKP
         YVjRDJwF/OBWFU7QegkP+iQzytfN8j/22wr6H8qDYfHeW2EGo2kMqqCODiWBlYjaFvpr
         o7awtXvZSlV/7+xXgUkZCtXwfxXBVaW6kiL4QGGGka6qjoFFz94aDP+911VeNJjx7J+Q
         nJB8H70NPJttcnXBKKalSRDCkR0jZFHG3wBgBEVP6KBSMozeFKvNUybOwmc8oWs5Q7RO
         tRUxVkMShZs2fryRaRbJBxwnofKNYSRUT3914LnNBZwo7niOPivwaysAeRtIU4euLiEn
         UNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zxxIu40tB7xyc4/4mwu0tXbbd4pQ0H0wSYiSFSUKaAg=;
        b=osmKVhyefSiSt2mOasCf9aH40Jci1LRhv0LaQHwiOKrUHnR2RZ+7XLkQo2kIdIeX95
         Q4jDUNkNRvS7xA/+Hy8RsnhaAgpOpkLy8e8qeCGPYl8ZWfgvNCajPcsCxkE3r9knSxPd
         obel8YOpSBIwhVSIxxQ/Wxp+2G9AJ+hWi41Vc47Q+ZfSMMb444Zjru4ZzQ57QhfmxZcA
         IUch8RsZH4lklGV4vUj+YgfXEIF8vWAyh+dF/GxVTeHGaBoSc1sk8D1ij7ZVDDrgtDEq
         kU7bJThv43n27asqmD1qxCLhhTBPvVgT2/JogpYJmLcb3Kx5jZiyGpxXu0XWVVfhRKnz
         HnLg==
X-Gm-Message-State: AOAM532t7ASMvE5e7ximwmsRpzg3my0lnyeU8oCOKM5bYaTg6NJoXHqf
        EE8bjNysFPKDsNqyqPgPr94=
X-Google-Smtp-Source: ABdhPJyPX/5Qtp+yrJ813PTNCTQ7WUL4UcjoN36TV6T95lpvr3dsbZOKU/BqYs3cvYFmZ/RqKWUDKw==
X-Received: by 2002:a17:902:dac4:b0:15f:2a36:22ad with SMTP id q4-20020a170902dac400b0015f2a3622admr16049842plx.94.1652675105019;
        Sun, 15 May 2022 21:25:05 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:983e:a432:c95c:71c2])
        by smtp.gmail.com with ESMTPSA id w16-20020a634910000000b003f27adead72sm308403pga.90.2022.05.15.21.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 21:25:04 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/4] net: add skb_defer_max sysctl
Date:   Sun, 15 May 2022 21:24:55 -0700
Message-Id: <20220516042456.3014395-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220516042456.3014395-1-eric.dumazet@gmail.com>
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 68822bdf76f1 ("net: generalize skb freeing
deferral to per-cpu lists") added another per-cpu
cache of skbs. It was expected to be small,
and an IPI was forced whenever the list reached 128
skbs.

We might need to be able to control more precisely
queue capacity and added latency.

An IPI is generated whenever queue reaches half capacity.

Default value of the new limit is 64.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 Documentation/admin-guide/sysctl/net.rst |  8 ++++++++
 net/core/dev.c                           |  1 +
 net/core/dev.h                           |  2 +-
 net/core/skbuff.c                        | 15 +++++++++------
 net/core/sysctl_net_core.c               |  8 ++++++++
 5 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index f86b5e1623c6922b070fd7c62e83271ee9aee46c..fa4dcdb283cf8937df8414906b57949cc7a3c2bc 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -322,6 +322,14 @@ a leaked reference faster. A larger value may be useful to prevent false
 warnings on slow/loaded systems.
 Default value is 10, minimum 1, maximum 3600.
 
+skb_defer_max
+-------------
+
+Max size (in skbs) of the per-cpu list of skbs being freed
+by the cpu which allocated them. Used by TCP stack so far.
+
+Default: 64
+
 optmem_max
 ----------
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 35b6d79b0c51412534dc3b3374b8d797d212f2d8..ac22fedfeaf72dc0d46f4793bbd9b2d5dd301730 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4329,6 +4329,7 @@ int netdev_max_backlog __read_mostly = 1000;
 EXPORT_SYMBOL(netdev_max_backlog);
 
 int netdev_tstamp_prequeue __read_mostly = 1;
+unsigned int sysctl_skb_defer_max __read_mostly = 64;
 int netdev_budget __read_mostly = 300;
 /* Must be at least 2 jiffes to guarantee 1 jiffy timeout */
 unsigned int __read_mostly netdev_budget_usecs = 2 * USEC_PER_SEC / HZ;
diff --git a/net/core/dev.h b/net/core/dev.h
index 328b37af90ba9465d83c833dffd18547ddef4028..cbb8a925175a257f8ce2a27eebb02e03041eebb8 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -39,7 +39,7 @@ void dev_addr_check(struct net_device *dev);
 /* sysctls not referred to from outside net/core/ */
 extern int		netdev_budget;
 extern unsigned int	netdev_budget_usecs;
-
+extern unsigned int	sysctl_skb_defer_max;
 extern int		netdev_tstamp_prequeue;
 extern int		netdev_unregister_timeout_secs;
 extern int		weight_p;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1e2180682f2e94c45e3f26059af6d18be2d9f9d3..ecb8fe7045a2f9c080cd0299ff7c0c1ea88d996b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -80,6 +80,7 @@
 #include <linux/user_namespace.h>
 #include <linux/indirect_call_wrapper.h>
 
+#include "dev.h"
 #include "sock_destructor.h"
 
 struct kmem_cache *skbuff_head_cache __ro_after_init;
@@ -6494,16 +6495,21 @@ void skb_attempt_defer_free(struct sk_buff *skb)
 	int cpu = skb->alloc_cpu;
 	struct softnet_data *sd;
 	unsigned long flags;
+	unsigned int defer_max;
 	bool kick;
 
 	if (WARN_ON_ONCE(cpu >= nr_cpu_ids) ||
 	    !cpu_online(cpu) ||
 	    cpu == raw_smp_processor_id()) {
-		__kfree_skb(skb);
+nodefer:	__kfree_skb(skb);
 		return;
 	}
 
 	sd = &per_cpu(softnet_data, cpu);
+	defer_max = READ_ONCE(sysctl_skb_defer_max);
+	if (READ_ONCE(sd->defer_count) >= defer_max)
+		goto nodefer;
+
 	/* We do not send an IPI or any signal.
 	 * Remote cpu will eventually call skb_defer_free_flush()
 	 */
@@ -6513,11 +6519,8 @@ void skb_attempt_defer_free(struct sk_buff *skb)
 	WRITE_ONCE(sd->defer_list, skb);
 	sd->defer_count++;
 
-	/* kick every time queue length reaches 128.
-	 * This condition should hardly be hit under normal conditions,
-	 * unless cpu suddenly stopped to receive NIC interrupts.
-	 */
-	kick = sd->defer_count == 128;
+	/* Send an IPI every time queue reaches half capacity. */
+	kick = sd->defer_count == (defer_max >> 1);
 
 	spin_unlock_irqrestore(&sd->defer_lock, flags);
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 195ca5c2877125bf420128d3c6465ac216f459e5..ca8d38325e1e1d7775d61893fab94ff9499ef5f8 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -578,6 +578,14 @@ static struct ctl_table net_core_table[] = {
 		.extra1		= SYSCTL_ONE,
 		.extra2		= &int_3600,
 	},
+	{
+		.procname	= "skb_defer_max",
+		.data		= &sysctl_skb_defer_max,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
 	{ }
 };
 
-- 
2.36.0.550.gb090851708-goog

