Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821E5127B21
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 13:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLTMfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 07:35:48 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33106 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfLTMfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 07:35:47 -0500
Received: by mail-wm1-f65.google.com with SMTP id d139so9378163wmd.0
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 04:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d7VlaBoIdXBt24VWooO3y7QYc0jT4ds+4gikQ+z3AHo=;
        b=LxE2rgCvTXEYFrY+oyp2ZYfFk6+WdvEjVkF4L3BrAug+9+GiqMG78660V3H1B/yq+i
         RtP+JQD3z7ro8mKd1c8U9S03z2LpQ4Sb7Oc6AtoUDt3/XWtcmY3fb4CDbUbphe4/CcjP
         azqNGuaiQgjEI7MAY8RZQ71Z59TUFBgH8msA3A9dHzlFmbbA3o06WR8sLqVmUn6Jrwbr
         sb5zqsh0xlAE743dN11cOyle8SK2FJA52nOgoHYQ9i1Nhl0uPL0ctyMCVfRuzcn+NejN
         EAN74Y5TTKTt+5IYRqNIdbE2lADwLwdQfalb9qwhiUAecylc68VdNhfQgvgNZNtFzuL5
         dlXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d7VlaBoIdXBt24VWooO3y7QYc0jT4ds+4gikQ+z3AHo=;
        b=jqUhUlpQJ4/zF8RAdh8KP+X8JVMCXHYW6zMhBXOW0ZnPtVvvyXox37cY/NK/YCyeSe
         5+fcutmCdSTe0Cl/aVlHn3GeTu0XPFMetBYznjXW5t8ggVMM7J7vWHXuTjL7r/KlvLSY
         bI1bXURaqFs/SNexnzIvjP6gLqDLEtUmrQ/AO7hVR5p6Af8FIrYlh0OsV3O0kCe2wCuU
         6gGVaD6++TT3qx3XIB6fGs0IkDY/ERTd/oLtUrfB25zvlytLRco4UiOFmSlH1tI7+nW2
         2DFUYi4tvuiixuUNw23Hxrb6q5Va6/rlrbzPsuKxewTnXR+QDz3F6wB5jMhHk/KqZeM/
         VitA==
X-Gm-Message-State: APjAAAWuvE9L+809ESYOelIWAlq1BM8wKjbME9FDp+fMHYYJcjgg+xYs
        cGE/znQmJpY0eriekUtCOvmzDdk3TX0=
X-Google-Smtp-Source: APXvYqyd6vJS+oUjBXZojkBWr4deLdqYga23lv2QqYtyE/vpfq79arIWR6/XxVmzww14jE4Islw7ug==
X-Received: by 2002:a1c:4c5:: with SMTP id 188mr16039045wme.82.1576845345965;
        Fri, 20 Dec 2019 04:35:45 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id j12sm10416228wrw.54.2019.12.20.04.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 04:35:45 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next 2/4] net: push code from net notifier reg/unreg into helpers
Date:   Fri, 20 Dec 2019 13:35:40 +0100
Message-Id: <20191220123542.26315-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220123542.26315-1-jiri@resnulli.us>
References: <20191220123542.26315-1-jiri@resnulli.us>
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
 net/core/dev.c | 60 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2c90722195f8..932ee131c8c9 100644
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
+	raw_notifier_chain_unregister(&netdev_chain, nb);
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

