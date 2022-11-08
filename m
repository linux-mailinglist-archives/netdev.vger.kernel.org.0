Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7FE621233
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiKHNWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbiKHNWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:22:15 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C184D5FA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:22:14 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id a11-20020a05600c2d4b00b003cf6f5fd9f1so9064555wmg.2
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 05:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8EUbX66d2EfCMxsMDh9GSVe9CNcdeFa9ycSaApeQBA8=;
        b=4Si597DNA/U8uJeDZvGw2QlrEQ7FAoyTK0XQXpyxsL2npi6p6Kkd2qId68BwmkmdE2
         6OK+wDSsvyBaj9PNTyOe3QYW0tAtU/6svMWJGbdv+icuXpli6k0VnA+s5AZnPsCsD7P6
         APzyo9suBneXoP7Q66GjlSef+eTpRlvduYCRRwPk8RJIdoBGwvm3AQ4AaLyKvgOESzdR
         3dipHnH1JwATmN2EXlb3XVX/0ViLYo/EhO0tYKs1H+u2621fD86u+kWi8Snh18ZJZVai
         FSxiaxilmWTgqEBccZJR4QAXCiwcCE4A2Rm8egsBj8szZdC7c6q2Rm18yJjGLjedwOr7
         Wl8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8EUbX66d2EfCMxsMDh9GSVe9CNcdeFa9ycSaApeQBA8=;
        b=TLKsLR0AFmA8F++3dluC+LU2TwzBxifL2RkkHN7q1GM+tNuUQFYI4D7hEzScBq4v/w
         y9fvgzsR3RhynMQWwgGCuXZWYvFkhu0Tc6HihFaAaK3VIJQtylBADhyqoxiaq5RMrbQA
         H3V6FZDHE6Jqwcu30PcefQeRkIOqMnAU6359AjUrG9nNcC8zltqbtUOk0zhzLyjfGUgf
         fHmbLbINPwdhJlWk/wF7Ct94eB5u5p8iR05qwAO5wVsp6bimLkYQbFzPz6pIJCalT5Ta
         2jmeAJWX4OCLbdQVoFxKJ/Ur29Lu7OOt+CE2pjd3eP+CoZJxUhS+pIsZZsGlZTyo2b53
         nlKw==
X-Gm-Message-State: ACrzQf2vMWuMgtgG3A0Bx84uMdPnaWb+kdO25yLVgNFpB8/+VPr1aTuh
        lCi+KPgLF5GNmFWieXewugDqzQApFAPNHMLM
X-Google-Smtp-Source: AMsMyM76iAaBtyNl8IdIKg3Wg00al/j3A5JAQxRyv2nST/4dlCvvCIQn8xmpLGdxXBYscYzhFU3KrQ==
X-Received: by 2002:a05:600c:18a3:b0:3cf:8df1:ce6e with SMTP id x35-20020a05600c18a300b003cf8df1ce6emr19704026wmp.5.1667913733246;
        Tue, 08 Nov 2022 05:22:13 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003b4fdbb6319sm15671763wmq.21.2022.11.08.05.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 05:22:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, idosch@idosch.org, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: [patch net-next v2 1/3] net: introduce a helper to move notifier block to different namespace
Date:   Tue,  8 Nov 2022 14:22:06 +0100
Message-Id: <20221108132208.938676-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221108132208.938676-1-jiri@resnulli.us>
References: <20221108132208.938676-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Currently, net_dev() netdev notifier variant follows the netdev with
per-net notifier from namespace to namespace. This is implemented
by move_netdevice_notifiers_dev_net() helper.

For devlink it is needed to re-register per-net notifier during
devlink reload. Introduce a new helper called
move_netdevice_notifier_net() and share the unregister/register code
with existing move_netdevice_notifiers_dev_net() helper.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- made __move_netdevice_notifier_net() static
- remove unnecessary move_netdevice_notifier_net() export
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 22 ++++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d45713a06568..6be93b59cfea 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2828,6 +2828,8 @@ int unregister_netdevice_notifier(struct notifier_block *nb);
 int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb);
 int unregister_netdevice_notifier_net(struct net *net,
 				      struct notifier_block *nb);
+void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
+				 struct notifier_block *nb);
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn);
diff --git a/net/core/dev.c b/net/core/dev.c
index 3bacee3bee78..0078a2734a4c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1876,6 +1876,22 @@ int unregister_netdevice_notifier_net(struct net *net,
 }
 EXPORT_SYMBOL(unregister_netdevice_notifier_net);
 
+static void __move_netdevice_notifier_net(struct net *src_net,
+					  struct net *dst_net,
+					  struct notifier_block *nb)
+{
+	__unregister_netdevice_notifier_net(src_net, nb);
+	__register_netdevice_notifier_net(dst_net, nb, true);
+}
+
+void move_netdevice_notifier_net(struct net *src_net, struct net *dst_net,
+				 struct notifier_block *nb)
+{
+	rtnl_lock();
+	__move_netdevice_notifier_net(src_net, dst_net, nb);
+	rtnl_unlock();
+}
+
 int register_netdevice_notifier_dev_net(struct net_device *dev,
 					struct notifier_block *nb,
 					struct netdev_net_notifier *nn)
@@ -1912,10 +1928,8 @@ static void move_netdevice_notifiers_dev_net(struct net_device *dev,
 {
 	struct netdev_net_notifier *nn;
 
-	list_for_each_entry(nn, &dev->net_notifier_list, list) {
-		__unregister_netdevice_notifier_net(dev_net(dev), nn->nb);
-		__register_netdevice_notifier_net(net, nn->nb, true);
-	}
+	list_for_each_entry(nn, &dev->net_notifier_list, list)
+		__move_netdevice_notifier_net(dev_net(dev), net, nn->nb);
 }
 
 /**
-- 
2.37.3

