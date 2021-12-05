Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEF7468921
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhLEE14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhLEE1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:49 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C932CC061354
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:24:22 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n8so4853605plf.4
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uOGDxUJKSk/sPCLCmeDkNNHP+gUxPNLx3WgXYaYfGGQ=;
        b=Jrd5TmRC8BzWFLvEbhZdU3W/ts6kfuT6pjcUOTxLSyFhmVpQICr/ytwBzZKqYQjBQZ
         qxlP17YEg6TyWeAS5KERG2O7QFD93CQg/TkVFtuPMbAn3Ktn2AnVcOAX5EPhS9a4JbTu
         6dnd0ZJQZ0/jssXZf/DyqboV8O2PDKvIwHlanFOzsuwxZRE8fqdXoVO5te7REfuvTR86
         1SYbHlkWFH3S8xLMCKmjHeabou/B7Llf8yw1M+SifKLfWHQ5iHlYEirx68UgSV6lRLz/
         JmzjwU/KvTM/d9PyPHRQTkG7r513RzE2LAPVoqA+qVjyM4QfImmug7epM5mUS4/ju8U0
         pYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uOGDxUJKSk/sPCLCmeDkNNHP+gUxPNLx3WgXYaYfGGQ=;
        b=aR5F8ayCdpXAIoa9Mm926nfkhCJrAMPyMETsPdW0mc1pvpnL7De+2yYrFmYf+hLCw1
         mAdsp+RaLkungCf3M1KhHveLjF6MIUhcTR88agItJxmp0yskfj89K8Vwg5T+XpcPyWwo
         PP+NCesfoGy9PNT3fMhnPnDjt6pYYC3obgMpELfrtyDUGE8ovXnlKbnOjLhmgo/eX07I
         N57TWjF4QCcShwTlK2Nr4G41pwZ5wA1R8a/qHnT3Bx0UZUUxdblNCe14jExYedCA562G
         YoM/mLY3AeVhctXNKdBk8SE1Iofi+GTOusFRYX8TnnQ+uH6YYkB/6lM5IDDqH6Mg8y8X
         NI0w==
X-Gm-Message-State: AOAM532i1wW6babI6FrZUJPfPcljsCf5Hg7rIY3flYGBLPA8GuxQbvAi
        mD3ZB9o8r8GW9isJfF6XuXQ=
X-Google-Smtp-Source: ABdhPJwTAdi7k6iB+ExZUGmuemv46xyc8tK9mmggW0Iuq9GaI2QPaK9LXQxsaERww9p09jB35QaVXw==
X-Received: by 2002:a17:90a:ba13:: with SMTP id s19mr26796361pjr.62.1638678262405;
        Sat, 04 Dec 2021 20:24:22 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:24:22 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 21/23] net: failover: add net device refcount tracker
Date:   Sat,  4 Dec 2021 20:22:15 -0800
Message-Id: <20211205042217.982127-22-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/failover.h | 1 +
 net/core/failover.c    | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/failover.h b/include/net/failover.h
index bb15438f39c7d98fe7c5637f08c3cfb23e7e79d2..f2b42b4b9cd6c1fb6561e7deca3c549dcf04f20f 100644
--- a/include/net/failover.h
+++ b/include/net/failover.h
@@ -25,6 +25,7 @@ struct failover_ops {
 struct failover {
 	struct list_head list;
 	struct net_device __rcu *failover_dev;
+	netdevice_tracker	dev_tracker;
 	struct failover_ops __rcu *ops;
 };
 
diff --git a/net/core/failover.c b/net/core/failover.c
index b5cd3c727285d7a1738118c246abce8d31dac08f..dcaa92a85ea23c54bc5ea68eb8a0f38fb31ff436 100644
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -252,7 +252,7 @@ struct failover *failover_register(struct net_device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	rcu_assign_pointer(failover->ops, ops);
-	dev_hold(dev);
+	dev_hold_track(dev, &failover->dev_tracker, GFP_KERNEL);
 	dev->priv_flags |= IFF_FAILOVER;
 	rcu_assign_pointer(failover->failover_dev, dev);
 
@@ -285,7 +285,7 @@ void failover_unregister(struct failover *failover)
 		    failover_dev->name);
 
 	failover_dev->priv_flags &= ~IFF_FAILOVER;
-	dev_put(failover_dev);
+	dev_put_track(failover_dev, &failover->dev_tracker);
 
 	spin_lock(&failover_lock);
 	list_del(&failover->list);
-- 
2.34.1.400.ga245620fadb-goog

