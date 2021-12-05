Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB69468920
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhLEE1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbhLEE1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:45 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8715C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:24:18 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so8215622pjb.5
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HdOA4T8Ph2icqtJHYWJuOL0AJpM8uaXoVDv/UEz0z6Q=;
        b=RtEo37Uxi2NIrkWW8UaPetSxLsqLX2+BPEciKvJHXz2NxPblImlVHWMGfu6HbNoqqF
         W0CegyHLZFo/sQ/PstA1DC9B2Ih80X5g0wZVBb47AC7oKwucCcqOUDfl6m0Vy4HPZ1EH
         aMCoRTBLY1MyyDMk3hcy98jR0QkqBAKyjCjIv3943ofp0olfvHJC0AKgGYpgPFONlD5K
         VE3KlcyywVn3ZJWY7mUdXgJMk4gzDuVbWQWtp4SY5GbZwb+Z+Mip7eS7mhYCwpzlgw8H
         kosfwAjHgw+m5++Tln6X8h2MU117c+oLAK5TjdZcMItw7oaA5wuK3HxJX5TSdXuZOA+a
         I3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HdOA4T8Ph2icqtJHYWJuOL0AJpM8uaXoVDv/UEz0z6Q=;
        b=RB4xYlBU5fx5a9pmQMUO3MyFntIDRGwPpK+lgxT8B9ntaoCp+cD1wHKQHLrVU186u8
         MOlCfCscY12WmSE3VJYa8WXdoc+LMXp3S5y9nPPn390L2JP+l4Rv0t3q3N+lZtBw7dsS
         in49svF92p0pJfLcyjAuD8ShycZxw09VtKsA9NmpFkk6zVJKLoXiltZ/0jqZxtAmHur7
         1ZXs2AwA+SyIqxIvCwhQbqpP9hADxQj7BQwOuHtuP6uTN3w1v1uVjGolq87zQaqW7/tt
         yp0dCedv+mZcYRusjD1u+Umd/aRNSFumYQNyDmJYfUVxgFKjsiDL9l97NYLxHA+t+//V
         yxaw==
X-Gm-Message-State: AOAM532nIwWclcB3WvKqGWqMudNqfUq6+tSmsd/3haZFFG9X9k4jp0bU
        fDxuQ4YlmYw0Nzoic5z14l4=
X-Google-Smtp-Source: ABdhPJxBpwGMViLcUqdaLaLtO7OOwUpImzvCOulAV04kRfqDVtUAZkJCyPjJl0Wo9+XJxeSdKRLjUw==
X-Received: by 2002:a17:90a:7e86:: with SMTP id j6mr27297618pjl.25.1638678258216;
        Sat, 04 Dec 2021 20:24:18 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:24:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 20/23] net: linkwatch: add net device refcount tracker
Date:   Sat,  4 Dec 2021 20:22:14 -0800
Message-Id: <20211205042217.982127-21-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Add a netdevice_tracker inside struct net_device, to track
the self reference when a device is in lweventlist.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/link_watch.c     | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index afed3b10491b92da880a8cd13181ff041cc54673..cc17f26cd4ad59a4d1868951fee13f56ab73cd1a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1950,6 +1950,7 @@ enum netdev_ml_priv_type {
  *			keep a list of interfaces to be deleted.
  *
  *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
+ *	linkwatch_dev_tracker:	refcount tracker used by linkwatch.
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
@@ -2280,6 +2281,7 @@ struct net_device {
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
 
 	u8 dev_addr_shadow[MAX_ADDR_LEN];
+	netdevice_tracker	linkwatch_dev_tracker;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 9599afd0862dabfca4560de6ec36606bf3742fd6..d7d089963b1da4142a0863715382aa81241625eb 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -109,7 +109,7 @@ static void linkwatch_add_event(struct net_device *dev)
 	spin_lock_irqsave(&lweventlist_lock, flags);
 	if (list_empty(&dev->link_watch_list)) {
 		list_add_tail(&dev->link_watch_list, &lweventlist);
-		dev_hold(dev);
+		dev_hold_track(dev, &dev->linkwatch_dev_tracker, GFP_ATOMIC);
 	}
 	spin_unlock_irqrestore(&lweventlist_lock, flags);
 }
@@ -166,7 +166,7 @@ static void linkwatch_do_dev(struct net_device *dev)
 
 		netdev_state_change(dev);
 	}
-	dev_put(dev);
+	dev_put_track(dev, &dev->linkwatch_dev_tracker);
 }
 
 static void __linkwatch_run_queue(int urgent_only)
-- 
2.34.1.400.ga245620fadb-goog

