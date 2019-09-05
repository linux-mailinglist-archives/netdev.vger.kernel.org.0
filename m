Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA21AAA8C
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 20:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391127AbfIESG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 14:06:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38370 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfIESG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 14:06:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id o184so4159190wme.3
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 11:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=du8hrenMmR1OpU9VoB6zsRD7zRZu3iWJjdW2a83saTk=;
        b=th25xKhRNt+w+xMvjuZ5DEElWcUH9g8Lzv4DUKcZ1l3k85fDU0s6h2t+/oaSboeYcs
         9lw8mgM0GUFVArOy5JU0iVm4JerdqFr91gBHF1L1Hz4zBAlfSeKlQQcSDjQYkXUCb96V
         lq0SID0LwSRRbbdjXdlI3Xjb0Ip5hO34SuzPbq0rpSLa7dNjV6rDOfkIZ53UB1tsvWjD
         se2MZYcOL/vhuAiN7L1GeYkKxAYoUr+WU3V22EiydeMIwFUaWc/kqCnqJvGr+CEfhqjy
         Eonn3372uan5vGMcvVrhx7Lfw/y2E+noQYONZhbt1ZEgf6zXslOiZnL0cSzh/Rw/uRGB
         nxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=du8hrenMmR1OpU9VoB6zsRD7zRZu3iWJjdW2a83saTk=;
        b=qc7q/95HyfU5YrCnouSxY1Ew2d+Eiigs9NLk+kao58uEq7MXZKGlCoNKrfBSvI+Lfe
         4K753t5zzQhAyudGeJHEek6oYDBer1CopePWee0CzzYWhyqmOQPabIEhA9J7PEO00Al+
         hde6FEXgpkJrS3mmvwRvnsk3wL9Q3zTfL5mTQkRZ6zrbLiiZU2RFmbj0ekeeh7Dra5mb
         wxvlMBIf2ihq21/cldhwloAPyqqcI6CRF+zaLC4PMnlZmKVDDq9+QLkUOnlSXnWBsuJY
         Vc5nGOdXgtD5VDogFX6uV3HhQLJmxGiOWK8TiWE0h0/un45XPOdJbWobgFmvPVa4RQos
         vWjg==
X-Gm-Message-State: APjAAAVdjSbCO1dk8r0aCuXAhr+lJCcYmX0E//W5kDEbHvB9sAG9XoFe
        4UhJcIfzUsPHFMdAhaV3AvE3qa8Lq7A=
X-Google-Smtp-Source: APXvYqyCuDTTVK0oIgljWvDxjQTTqN/WUiR0VyQrSE58esTFeCO0FUn0mqP3R71aHtC+YTqz/JlNfg==
X-Received: by 2002:a1c:9d15:: with SMTP id g21mr4167590wme.96.1567706817408;
        Thu, 05 Sep 2019 11:06:57 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r17sm3504227wrt.68.2019.09.05.11.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 11:06:56 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com
Subject: [patch net-next] net: fib_notifier: move fib_notifier_ops from struct net into per-net struct
Date:   Thu,  5 Sep 2019 20:06:56 +0200
Message-Id: <20190905180656.4756-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

No need for fib_notifier_ops to be in struct net. It is used only by
fib_notifier as a private data. Use net_generic to introduce per-net
fib_notifier struct and move fib_notifier_ops there.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/net_namespace.h |  3 ---
 net/core/fib_notifier.c     | 29 +++++++++++++++++++++++------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index ab40d7afdc54..64bcb589a610 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -103,9 +103,6 @@ struct net {
 	/* core fib_rules */
 	struct list_head	rules_ops;
 
-	struct list_head	fib_notifier_ops;  /* Populated by
-						    * register_pernet_subsys()
-						    */
 	struct net_device       *loopback_dev;          /* The loopback */
 	struct netns_core	core;
 	struct netns_mib	mib;
diff --git a/net/core/fib_notifier.c b/net/core/fib_notifier.c
index 13a40b831d6d..470a606d5e8d 100644
--- a/net/core/fib_notifier.c
+++ b/net/core/fib_notifier.c
@@ -5,8 +5,15 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <net/net_namespace.h>
+#include <net/netns/generic.h>
 #include <net/fib_notifier.h>
 
+static unsigned int fib_notifier_net_id;
+
+struct fib_notifier_net {
+	struct list_head fib_notifier_ops;
+};
+
 static ATOMIC_NOTIFIER_HEAD(fib_chain);
 
 int call_fib_notifier(struct notifier_block *nb, struct net *net,
@@ -34,6 +41,7 @@ EXPORT_SYMBOL(call_fib_notifiers);
 
 static unsigned int fib_seq_sum(void)
 {
+	struct fib_notifier_net *fn_net;
 	struct fib_notifier_ops *ops;
 	unsigned int fib_seq = 0;
 	struct net *net;
@@ -41,8 +49,9 @@ static unsigned int fib_seq_sum(void)
 	rtnl_lock();
 	down_read(&net_rwsem);
 	for_each_net(net) {
+		fn_net = net_generic(net, fib_notifier_net_id);
 		rcu_read_lock();
-		list_for_each_entry_rcu(ops, &net->fib_notifier_ops, list) {
+		list_for_each_entry_rcu(ops, &fn_net->fib_notifier_ops, list) {
 			if (!try_module_get(ops->owner))
 				continue;
 			fib_seq += ops->fib_seq_read(net);
@@ -58,9 +67,10 @@ static unsigned int fib_seq_sum(void)
 
 static int fib_net_dump(struct net *net, struct notifier_block *nb)
 {
+	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
 	struct fib_notifier_ops *ops;
 
-	list_for_each_entry_rcu(ops, &net->fib_notifier_ops, list) {
+	list_for_each_entry_rcu(ops, &fn_net->fib_notifier_ops, list) {
 		int err;
 
 		if (!try_module_get(ops->owner))
@@ -127,12 +137,13 @@ EXPORT_SYMBOL(unregister_fib_notifier);
 static int __fib_notifier_ops_register(struct fib_notifier_ops *ops,
 				       struct net *net)
 {
+	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
 	struct fib_notifier_ops *o;
 
-	list_for_each_entry(o, &net->fib_notifier_ops, list)
+	list_for_each_entry(o, &fn_net->fib_notifier_ops, list)
 		if (ops->family == o->family)
 			return -EEXIST;
-	list_add_tail_rcu(&ops->list, &net->fib_notifier_ops);
+	list_add_tail_rcu(&ops->list, &fn_net->fib_notifier_ops);
 	return 0;
 }
 
@@ -167,18 +178,24 @@ EXPORT_SYMBOL(fib_notifier_ops_unregister);
 
 static int __net_init fib_notifier_net_init(struct net *net)
 {
-	INIT_LIST_HEAD(&net->fib_notifier_ops);
+	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
+
+	INIT_LIST_HEAD(&fn_net->fib_notifier_ops);
 	return 0;
 }
 
 static void __net_exit fib_notifier_net_exit(struct net *net)
 {
-	WARN_ON_ONCE(!list_empty(&net->fib_notifier_ops));
+	struct fib_notifier_net *fn_net = net_generic(net, fib_notifier_net_id);
+
+	WARN_ON_ONCE(!list_empty(&fn_net->fib_notifier_ops));
 }
 
 static struct pernet_operations fib_notifier_net_ops = {
 	.init = fib_notifier_net_init,
 	.exit = fib_notifier_net_exit,
+	.id = &fib_notifier_net_id,
+	.size = sizeof(struct fib_notifier_net),
 };
 
 static int __init fib_notifier_init(void)
-- 
2.21.0

