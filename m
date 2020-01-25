Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9BA0149524
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgAYLRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:17:16 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44398 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgAYLRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 06:17:15 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so5148090wrm.11
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 03:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/7VYyQSo6PVi3ys5VLzxKBaK389wAKDc5hKCvmhZ5FI=;
        b=GeMiqrLlNZwlS9HwB44Q9jFo3wdE9me5mqtVWhkdRhY4csjtYy7YZLyN7LFxYnFdV7
         7L4NoPoHXz3AP+113VHc5lLA9moCvzFe7JXhpOugd6g6+h/bdIYJQo+nrDJ5oCKcZMI4
         AwGCgEe2EOiYbWDGr83RyrlobtcoPAtV/1sSEHXXHrAi3CCLfl5M5qkFJ0NpVA2RvZNg
         uwy9BnXCgsrJeo3t6e9zvzh1GAOeVtFSYFi2ZAIr43IL72SbdaUcnse5eNY02PIyfbfL
         EtDYM71shAEq4KlkRLgW6LshV3rrPnOfUed11504AKOUynfTJtA3DKQj3NO27SdnEob1
         9Vtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/7VYyQSo6PVi3ys5VLzxKBaK389wAKDc5hKCvmhZ5FI=;
        b=nRw7MKPrTQnZ/xquom3HUcPgZJhDGREYEjJRo+Vxrsw4mXkGbVT6BNzdbWaM00LOMo
         DsjEb/kOrnRQJn+rBqSDvhQIFGvPgU4INJAgx5OFqLIrNPxcq2RU/BHKJM7M0FuHtkBm
         toczC1oLGrVnRpKYqeaH/rCiL9glpgqKRSj8cqLMYjry5T1PDecM1YzZ4ywSlCBLRBPW
         AF/q9AqZ72EJ4cPNnPuoOK2sDR4dVwD3YaP2G0aBzvrcuqjTe0tEVHldN9SUL535hWWo
         VaH2gTVh6WAaOlTQgoo0jUdZINt5Hi8SSs4PWVuoaxUEyKuqp0caRCTjoknbL+mVRrEM
         jn3w==
X-Gm-Message-State: APjAAAXJQuGrXk65eqisWKC2dHJ0k07BbfRl7nmt3Vy+fEYKLfiynbuW
        a2CVpLSbecPoFuhAt94V/pf2GwLiTwM=
X-Google-Smtp-Source: APXvYqyWZtzsSTKaeNa8idIYxtPVgBT+ErdFQijL5ckCNE75eNahSeu1Dxkwnijm2OEHhS5qx6u+Ag==
X-Received: by 2002:adf:f18b:: with SMTP id h11mr10797065wro.56.1579951033760;
        Sat, 25 Jan 2020 03:17:13 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h2sm12510494wrt.45.2020.01.25.03.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 03:17:13 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com
Subject: [patch net-next v2 2/4] net: push code from net notifier reg/unreg into helpers
Date:   Sat, 25 Jan 2020 12:17:07 +0100
Message-Id: <20200125111709.14566-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200125111709.14566-1-jiri@resnulli.us>
References: <20200125111709.14566-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Push the code which is done under rtnl lock in net notifier register and
unregister function into separate helpers.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- fixed error path of __register_netdevice_notifier_net()
---
 net/core/dev.c | 60 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3cacfb7184e8..7e5aa58ce1ea 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1784,6 +1784,42 @@ int unregister_netdevice_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_netdevice_notifier);
 
+static int __register_netdevice_notifier_net(struct net *net,
+					     struct notifier_block *nb,
+					     bool ignore_call_fail)
+{
+	int err;
+
+	err = raw_notifier_chain_register(&net->netdev_chain, nb);
+	if (err)
+		return err;
+	if (dev_boot_phase)
+		return 0;
+
+	err = call_netdevice_register_net_notifiers(nb, net);
+	if (err && !ignore_call_fail)
+		goto chain_unregister;
+
+	return 0;
+
+chain_unregister:
+	raw_notifier_chain_unregister(&net->netdev_chain, nb);
+	return err;
+}
+
+static int __unregister_netdevice_notifier_net(struct net *net,
+					       struct notifier_block *nb)
+{
+	int err;
+
+	err = raw_notifier_chain_unregister(&net->netdev_chain, nb);
+	if (err)
+		return err;
+
+	call_netdevice_unregister_net_notifiers(nb, net);
+	return 0;
+}
+
 /**
  * register_netdevice_notifier_net - register a per-netns network notifier block
  * @net: network namespace
@@ -1804,23 +1840,9 @@ int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb)
 	int err;
 
 	rtnl_lock();
-	err = raw_notifier_chain_register(&net->netdev_chain, nb);
-	if (err)
-		goto unlock;
-	if (dev_boot_phase)
-		goto unlock;
-
-	err = call_netdevice_register_net_notifiers(nb, net);
-	if (err)
-		goto chain_unregister;
-
-unlock:
+	err = __register_netdevice_notifier_net(net, nb, false);
 	rtnl_unlock();
 	return err;
-
-chain_unregister:
-	raw_notifier_chain_unregister(&netdev_chain, nb);
-	goto unlock;
 }
 EXPORT_SYMBOL(register_netdevice_notifier_net);
 
@@ -1846,13 +1868,7 @@ int unregister_netdevice_notifier_net(struct net *net,
 	int err;
 
 	rtnl_lock();
-	err = raw_notifier_chain_unregister(&net->netdev_chain, nb);
-	if (err)
-		goto unlock;
-
-	call_netdevice_unregister_net_notifiers(nb, net);
-
-unlock:
+	err = __unregister_netdevice_notifier_net(net, nb);
 	rtnl_unlock();
 	return err;
 }
-- 
2.21.0

