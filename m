Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01FE46AFD0
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351745AbhLGBfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351623AbhLGBee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:34 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59105C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:05 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 133so12129242pgc.12
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FNVAspSEhGbEehGnStBkln/N3w3kgxxNgeXE1a+3uLA=;
        b=Um+1xewVcHNYQjyn5kbNndAxwMrjFnRc3JmwItJa5k8edFYAdrBlNYNHT1MK47zA5H
         dxQ7Pm4PH1sfzF3YqBxelIfgEhAR/iA37pB5E92mKVe60OT3dGkMsSW14FnorUBbYVtU
         aeMvRFBOZAVU3H3Lnx61HYegqFUXLhG981FRqMSsLRcgZvq0sMm5DRCabfXf3at7Zd6p
         pdq/ZfMfU31Adi6DfpWdWTRVKoyzSUp/LXaP2711rAWvuPI6c8SMk04zRRq3C7RAqUoM
         WqBUpCZ8YShfP1v3K9foWA0M3XaUy15YrZdhcY54W7ariyucS5q7hPbX29ZSi093Etlj
         MHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FNVAspSEhGbEehGnStBkln/N3w3kgxxNgeXE1a+3uLA=;
        b=pVDLPv9hXAG4uM5Wu7Fmt5tMiW0GXbaSx9SfcF2pim/cazPuKj/oUgmKv7oRufNWLT
         zRV4E0hcMHdavseCVCIkT3irY3j0uIqrSbNCOXoVLOGJFRov6UNaBk0LfkSJsKN8oISI
         dJzWPf7yAzl3TrlDi5s9UT2Pz6XpRzT1sEDInjmv4JoprCg6+l5nAyzrFHGtxT9zekgb
         AeNFncM15ZPkh+XDN1QRyS9F3HR6jDItWRfCIs/UyrTrbn1pUsypbJj98oEeuc3QnqXr
         QCEAroH5upOwpTPasYiRuYEma2N3ulahcaCmqPzNbYxy1qUaL+h40XQiN+cDBZ2Q4AVi
         mg7A==
X-Gm-Message-State: AOAM531NqVm+/VKgGtB5hnrtZ0I1WwWn9nCrV3MvioaJoM3sBNi+Mokj
        Ne2g97PO1UPKrhC616FiymQ=
X-Google-Smtp-Source: ABdhPJzMIQPndCltU3Ifko+Gxqp26A6fRqOv5oj3MUNQKdYQWWJ1uy8qQFrJHcEu9v8Mp0mzD34m9w==
X-Received: by 2002:a63:f252:: with SMTP id d18mr20532792pgk.191.1638840664969;
        Mon, 06 Dec 2021 17:31:04 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:04 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 04/13] net: watchdog: add net device refcount tracker
Date:   Mon,  6 Dec 2021 17:30:30 -0800
Message-Id: <20211207013039.1868645-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Add a netdevice_tracker inside struct net_device, to track
the self reference when a device has an active watchdog timer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |  2 ++
 net/sched/sch_generic.c   | 10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 201d8c5be80685f89d7fdba4b61f83194beb9b13..235d5d082f1a446c8d898ffcc5b1983df7c04f35 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1944,6 +1944,7 @@ enum netdev_ml_priv_type {
  *
  *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
  *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
+ *	@watchdog_dev_tracker:	refcount tracker used by watchdog.
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2275,6 +2276,7 @@ struct net_device {
 
 	u8 dev_addr_shadow[MAX_ADDR_LEN];
 	netdevice_tracker	linkwatch_dev_tracker;
+	netdevice_tracker	watchdog_dev_tracker;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 8c8fbf2e385679e46a1b7af47eeac059fb8468cc..b07bd1c7330f54a00c44ecd2e354af76f62b64e8 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -499,6 +499,7 @@ EXPORT_SYMBOL(netif_tx_unlock);
 static void dev_watchdog(struct timer_list *t)
 {
 	struct net_device *dev = from_timer(dev, t, watchdog_timer);
+	bool release = true;
 
 	spin_lock(&dev->tx_global_lock);
 	if (!qdisc_tx_is_noop(dev)) {
@@ -534,12 +535,13 @@ static void dev_watchdog(struct timer_list *t)
 			if (!mod_timer(&dev->watchdog_timer,
 				       round_jiffies(jiffies +
 						     dev->watchdog_timeo)))
-				dev_hold(dev);
+				release = false;
 		}
 	}
 	spin_unlock(&dev->tx_global_lock);
 
-	dev_put(dev);
+	if (release)
+		dev_put_track(dev, &dev->watchdog_dev_tracker);
 }
 
 void __netdev_watchdog_up(struct net_device *dev)
@@ -549,7 +551,7 @@ void __netdev_watchdog_up(struct net_device *dev)
 			dev->watchdog_timeo = 5*HZ;
 		if (!mod_timer(&dev->watchdog_timer,
 			       round_jiffies(jiffies + dev->watchdog_timeo)))
-			dev_hold(dev);
+			dev_hold_track(dev, &dev->watchdog_dev_tracker, GFP_ATOMIC);
 	}
 }
 EXPORT_SYMBOL_GPL(__netdev_watchdog_up);
@@ -563,7 +565,7 @@ static void dev_watchdog_down(struct net_device *dev)
 {
 	netif_tx_lock_bh(dev);
 	if (del_timer(&dev->watchdog_timer))
-		dev_put(dev);
+		dev_put_track(dev, &dev->watchdog_dev_tracker);
 	netif_tx_unlock_bh(dev);
 }
 
-- 
2.34.1.400.ga245620fadb-goog

