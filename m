Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7812E453EF1
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhKQDce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbhKQDcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 22:32:32 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF33C061746
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:34 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so4006678pjc.4
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=88Y73PJpVDIU99CIUpZfsJ0795Fl3wyCkWysDx/vZzw=;
        b=PyXri97wlh3IWXShV7eHRiaeL3EFbbPwxtk2OO+0Gq36b6XUCbICsP8oIfz1vtllb6
         mjJ8A7m5EwmHXdh71yl8JMIT8K8G5qv9EAG3vpraopMjPzucC166gdo524Q7Mns0sXCM
         QZFbmxYH62ZgC+MZ2hmcP8vFoOmBDw/DEiXUkhXab7Pu2+CrAIkouVbuUhRwFznaSK0e
         hxm1GnumAdp1ctdACRQqIgbU4TTVuv1FIH0M+bg5FidMhCDl8ijoxY/zNaR/OPGUpvCT
         gzD7N8dZxA/HJhFfXk1G4JvVh6Gg50m/dD7kGv0szUqiKuLDpvlotwBcjras5+idogWe
         sGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=88Y73PJpVDIU99CIUpZfsJ0795Fl3wyCkWysDx/vZzw=;
        b=GjRWMCPIiVXyfz/ibMUkno+1xARx0ye7ome3fyvwjNQlrMDULs8yXjdFEPG0WL0q63
         GXByuWcbtctNSurW3XNAPAdgfLGDG/EdBhYQd9jQk9PsEWKBPY6tGrNgAlRc0i1WHw1i
         lsYtvhlbNVZoAb5dXMHoy3hjpEmpv7gk2dBg5O3ppIV/5uI3vvkBM259Y9+dvLlJzsAh
         J6nISbDDkXzjm6TY4SHP8ZxMTS/kz/a1M+cozRLtN7SXsy87DBKYdAcOlE/kbHUbEyCr
         j06zqmPPeJCYdMnTArC/DyaVCIlbmCHqH8ZWsIcphMk607NzVCq6PZaoobUivB+zI6Yp
         j5MA==
X-Gm-Message-State: AOAM531bvGSspyroW9rLRE/+kOBXG8c6EMtObnJ42el7nqTQFgQsVL0u
        xmgaVICH/WKXJoyD3UHTAHc=
X-Google-Smtp-Source: ABdhPJxC/N39MJHOpHHSpYkdG4xIi5f48E9xdcvUcGTKl8r3tr/z2B6VGicwA8trAgO8PgbfaSe4iw==
X-Received: by 2002:a17:903:2352:b0:142:76bc:de3b with SMTP id c18-20020a170903235200b0014276bcde3bmr51538206plh.36.1637119773857;
        Tue, 16 Nov 2021 19:29:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bea:143e:3360:c708])
        by smtp.gmail.com with ESMTPSA id mi18sm4042394pjb.13.2021.11.16.19.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 19:29:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/4] net: no longer stop all TX queues in dev_watchdog()
Date:   Tue, 16 Nov 2021 19:29:24 -0800
Message-Id: <20211117032924.1740327-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211117032924.1740327-1-eric.dumazet@gmail.com>
References: <20211117032924.1740327-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

There is no reason for stopping all TX queues from dev_watchdog()

Not only this stops feeding the NIC, it also migrates all qdiscs
to be serviced on the cpu calling netif_tx_unlock(), causing
a potential latency artifact.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_generic.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 389e0d8fc68d12cf092a975511729a8dae1b29fb..d33804d41c5c5a9047c808fd37ba65ae8875fc79 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -500,7 +500,7 @@ static void dev_watchdog(struct timer_list *t)
 {
 	struct net_device *dev = from_timer(dev, t, watchdog_timer);
 
-	netif_tx_lock(dev);
+	spin_lock(&dev->tx_global_lock);
 	if (!qdisc_tx_is_noop(dev)) {
 		if (netif_device_present(dev) &&
 		    netif_running(dev) &&
@@ -523,11 +523,13 @@ static void dev_watchdog(struct timer_list *t)
 				}
 			}
 
-			if (some_queue_timedout) {
+			if (unlikely(some_queue_timedout)) {
 				trace_net_dev_xmit_timeout(dev, i);
 				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
 				       dev->name, netdev_drivername(dev), i);
+				netif_freeze_queues(dev);
 				dev->netdev_ops->ndo_tx_timeout(dev, i);
+				netif_unfreeze_queues(dev);
 			}
 			if (!mod_timer(&dev->watchdog_timer,
 				       round_jiffies(jiffies +
@@ -535,7 +537,7 @@ static void dev_watchdog(struct timer_list *t)
 				dev_hold(dev);
 		}
 	}
-	netif_tx_unlock(dev);
+	spin_unlock(&dev->tx_global_lock);
 
 	dev_put(dev);
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog

