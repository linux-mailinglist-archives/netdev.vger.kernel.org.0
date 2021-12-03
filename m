Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5985E467047
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378287AbhLCCvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378281AbhLCCvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:50 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63631C061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:27 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id x7so1278157pjn.0
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B7Re4yLZ+fuYk4ANOX5YYpTdXnzZcADisbjZ5HdspLY=;
        b=gC/oHPrEFOVhy88cOw2COweOFlE5lWIUB3rRXGr6h/tJNCQ6BrklX5yAPie4n1Tc4F
         NwOlUse9p1NJKnEW1hO7JYczRuOIG6aQh4gzY+K6RDZthFQ0+l4EnFnVRFdHvFXVngcp
         MU8vH8IxM+X4GZ2vT+Mvd0IwPnBeBWZqJc+prBpIz6PBasTvDGGfqHIsDBOlgmErHnIM
         GcgcckLdGin5nWkGaHJTLM+2HHRtRfa3J9WkPLaxaLhZYb4tiXl/1Vbt2GgSjQG4fqpN
         OOvY0u5GRfw95HkfpGEBh90m/livBwMN0X1NewVUsIqbFLXAHYcVnJFXkN2zfEWqJE2C
         MwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B7Re4yLZ+fuYk4ANOX5YYpTdXnzZcADisbjZ5HdspLY=;
        b=A4aeHsBLaNA+tSeBmaNwzJy21RMePGppV9AbpWvd2VhluTV+P0bmiuedV2kihCAYiB
         9eASZuxrObuVVmUKHfYrEAygd1OSp9qPmvVHlzcFAlYX6EG5Ra7HjOkXBw4lnJz8jo3S
         pJ2KiZAUkr9fs1iJgfFPtnKXaYU4OqgTUoNsN4uZppLmmeJrWqK6rjDwZHCY09MuDzdx
         itTItfi8rYeCw3GBG81lruPpXoQqSMkXF+Emy+PWohDBAG2qqB8jdstFk2l04cRFfFar
         GLrsvBCChVgMjSSbJD1b04ldx+9RIXQxY/zl94ctNUDGhFadO9wJw4HvriX1sEGywEKQ
         ResQ==
X-Gm-Message-State: AOAM531dg0XHePWLBNVt/WnQabwcuTR3SaOvYYjZw21rPba/m5v/8Qo+
        rXtSQVZWWHo3yDsPll87DaY=
X-Google-Smtp-Source: ABdhPJwZJmGphbWw6Pfuk2oiQ9ivB8YgTF/IVdUJ5LzdEpc2gtA9On/GH9BfqsjqDIrB5heu2Gf2kQ==
X-Received: by 2002:a17:90a:590d:: with SMTP id k13mr10486668pji.184.1638499706988;
        Thu, 02 Dec 2021 18:48:26 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:26 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 22/23] ipmr, ip6mr: add net device refcount tracker to struct vif_device
Date:   Thu,  2 Dec 2021 18:46:39 -0800
Message-Id: <20211203024640.1180745-23-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/mroute_base.h | 1 +
 net/ipv4/ipmr.c             | 3 ++-
 net/ipv6/ip6mr.c            | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 8071148f29a6ec6a95df7e74bbfdeab5b5f6a644..91ab497bd3e579b9d78f423d8c28310cf6b07f58 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -26,6 +26,7 @@
  */
 struct vif_device {
 	struct net_device *dev;
+	netdevice_tracker dev_tracker;
 	unsigned long bytes_in, bytes_out;
 	unsigned long pkt_in, pkt_out;
 	unsigned long rate_limit;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2dda856ca260259e5626577e2b2993a6d9967aa6..4c7aca884fa9a35816008a5f3a1a58dd1baf6c06 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -696,7 +696,7 @@ static int vif_delete(struct mr_table *mrt, int vifi, int notify,
 	if (v->flags & (VIFF_TUNNEL | VIFF_REGISTER) && !notify)
 		unregister_netdevice_queue(dev, head);
 
-	dev_put(dev);
+	dev_put_track(dev, &v->dev_tracker);
 	return 0;
 }
 
@@ -896,6 +896,7 @@ static int vif_add(struct net *net, struct mr_table *mrt,
 	/* And finish update writing critical data */
 	write_lock_bh(&mrt_lock);
 	v->dev = dev;
+	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
 	if (v->flags & VIFF_REGISTER)
 		mrt->mroute_reg_vif_num = vifi;
 	if (vifi+1 > mrt->maxvif)
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 36ed9efb88254003720549da52f39b11e9bf911f..a77a15a7f3dcb61c53a86e055b8a1507d9d591f8 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -746,7 +746,7 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 	if ((v->flags & MIFF_REGISTER) && !notify)
 		unregister_netdevice_queue(dev, head);
 
-	dev_put(dev);
+	dev_put_track(dev, &v->dev_tracker);
 	return 0;
 }
 
@@ -919,6 +919,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 	/* And finish update writing critical data */
 	write_lock_bh(&mrt_lock);
 	v->dev = dev;
+	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
 #ifdef CONFIG_IPV6_PIMSM_V2
 	if (v->flags & MIFF_REGISTER)
 		mrt->mroute_reg_vif_num = vifi;
-- 
2.34.1.400.ga245620fadb-goog

