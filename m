Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CD02460E4
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgHQIql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgHQIqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:46:36 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2FEC061388;
        Mon, 17 Aug 2020 01:46:36 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mt12so7478020pjb.4;
        Mon, 17 Aug 2020 01:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JyZDla3GSQu8y9PuecHRmoHloxiXoZbN5kGEO0ZCGqM=;
        b=OtRevU3RHg2HvzTD4tAV5LooqXPgMzAC6RQF9L4fQaUTi9xEo/TaVaZuvndcdGq7Ig
         8YpGbM3rlOMnbdFD2CqXmfR5emUW86UXcJAgXlsb6D+DMxSgtQgcw0YDgamosabDIJOc
         FF3BdqPAy857z+CCGtZ/yKzASg1VXXq4H5YDb1jJ2dRSykSBgw5ydo9FiZ8mUpwXABLO
         NL3oD6+6zoRTw2IddI/HXPwGZh1gLPBs3xBwY8/1Cn/5niq9xVj4CXxl3Q9oKk4oCNG4
         tt+Q3PzHkyyQpEHXpnwj0EZSfdyNYKQ6Q4xrPd76CGRS0KEeytup7o35QNh6YsCsVbIu
         BQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JyZDla3GSQu8y9PuecHRmoHloxiXoZbN5kGEO0ZCGqM=;
        b=PHSQOotT9UzvJ1oa2bMbc/8LzD327YC2AVVYO9p1a9ZpuR5RFlrOvGOsVUu/NfLtc/
         ESefwOZJGeZ9Esj1GXB6aTf292wPUJ3quiK7RG+06jJ2vqBssn/OqjNfA7Rq4sSr5O3o
         mm1fxs1JDEW2BS6HrhKWLZGHC2Htm+vWUre75U1pU1jPlaAb0B8+BkCA7jM8JfFzIuCX
         oT/zApCS5Mi5waSDDd/BS2J69CFoxHpaeIq1+jYb2HbqJp/o6az0PQmJOJ2VE3DDlB8G
         /gx+aeF6Xid3vztpDkCKpFW56RV9kX0QTqewlLQny34mVqLoBCmMORaLBq3lD9Xy1pzw
         OcFQ==
X-Gm-Message-State: AOAM533rkQdciYGB65QzZAWHEDNXXHMfJQcNrTNmSyzUXjXeGewulCZM
        RVYAHq6HKGFy95aLIoE5Hxs=
X-Google-Smtp-Source: ABdhPJwtIy6H1JNlP99tqVKJm7oD/92VbujI1oTFtbXZTJi8go/diz32GKDxkLDAyM4vEgSgRcx7Cw==
X-Received: by 2002:a17:902:b203:: with SMTP id t3mr10076797plr.50.1597653995599;
        Mon, 17 Aug 2020 01:46:35 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:46:35 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 1/9] net: ifb: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:04 +0530
Message-Id: <20200817084614.24263-3-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817084614.24263-1-allen.cryptic@gmail.com>
References: <20200817084614.24263-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ifb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 7fe306e76281..a2d6027362d2 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -59,9 +59,9 @@ static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ifb_open(struct net_device *dev);
 static int ifb_close(struct net_device *dev);
 
-static void ifb_ri_tasklet(unsigned long _txp)
+static void ifb_ri_tasklet(struct tasklet_struct *t)
 {
-	struct ifb_q_private *txp = (struct ifb_q_private *)_txp;
+	struct ifb_q_private *txp = from_tasklet(txp, t, ifb_tasklet);
 	struct netdev_queue *txq;
 	struct sk_buff *skb;
 
@@ -170,8 +170,7 @@ static int ifb_dev_init(struct net_device *dev)
 		__skb_queue_head_init(&txp->tq);
 		u64_stats_init(&txp->rsync);
 		u64_stats_init(&txp->tsync);
-		tasklet_init(&txp->ifb_tasklet, ifb_ri_tasklet,
-			     (unsigned long)txp);
+		tasklet_setup(&txp->ifb_tasklet, ifb_ri_tasklet);
 		netif_tx_start_queue(netdev_get_tx_queue(dev, i));
 	}
 	return 0;
-- 
2.17.1

