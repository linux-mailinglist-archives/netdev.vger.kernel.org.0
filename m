Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830B9246025
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgHQIZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgHQIYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:24:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EBEC061388;
        Mon, 17 Aug 2020 01:24:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id i10so2227686pgk.1;
        Mon, 17 Aug 2020 01:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U6kvtvahmst982l1SHnIdlPVTNs/K0Y5vkr0Zrgcbuc=;
        b=sRB8R0mF9f4I67M2vJjyOzq5HGOLhCwIYyJApLgBpnOvMgv9SObv1CuqoerN2lpagu
         3H1IMXBzE+dZbgcDpqRB7MjwtkDlohqJ/sN4S3D//2oLIMlDg9VLkzVibeyVBjC+ncFi
         pfc9AX7nnkE34sGzhXzgCG036rnkXe9hA721AJ6njKPcXQzgWjwCiwG5UTHheZBPt0Cn
         xFADoAgnj5Rk4CLpl9CXmhZi3LSe+fZIt7wNuX6N0TxPc37aXsRaYUpuDr7/y071m/iI
         i0bBC2JcJiy+5QIpzwI5/1j/Hn+pBqI9lf4HiH+UvSifqCWQWzoGH+00Xy5We5cg91OY
         j6Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U6kvtvahmst982l1SHnIdlPVTNs/K0Y5vkr0Zrgcbuc=;
        b=iPyh8NmUZnFRZzhY998hr+ailjSyJd+JOJaC2HL98KTyYKH2Cg85uGC9948eyYWo+1
         QlqFau+B6VZ+ztSZ9R+daJmtDrYJ7RLqd2yEcivyEMNlzivhMFjdN+LwbgQQn5WctZna
         MAnvJ9jT641HpCBpebPBriIZuVU++wK7NnHcyN+BtkJ1zkHFVkY/fM5+F6s2Q84LP5Aa
         rn2QnYIIJyCajeu9p/dWryanh7yN5eU/syCXTO/52NDBxJAqpMnhpINsi9NmARR9DneZ
         b3OJVdmSic3QPaHMxEqQyoQEYH+rT1Q3kAcRnaoaFQ3NdVlTE2NWeBTcEaxejJQysIEN
         y11w==
X-Gm-Message-State: AOAM5316Jpr3tw7ILAjpM22G7CbOC7QSDoMMx8WBx9Kbs2vEF+yBXrlf
        T6YgXpAPDc93GYMo3nS9f2g=
X-Google-Smtp-Source: ABdhPJyeeK7R8O+e+zrG4p84BODgyo/hoS+OJR9A7pYB1XGWzEAoUBeuR9leHrthUrODwRqKFFFWTg==
X-Received: by 2002:a65:63ca:: with SMTP id n10mr9480913pgv.252.1597652695193;
        Mon, 17 Aug 2020 01:24:55 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:24:54 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 01/20] ethernet: alteon: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:14 +0530
Message-Id: <20200817082434.21176-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/alteon/acenic.c | 9 +++++----
 drivers/net/ethernet/alteon/acenic.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index ac86fcae1582..8a4c2319953d 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -1562,10 +1562,11 @@ static void ace_watchdog(struct net_device *data, unsigned int txqueue)
 }
 
 
-static void ace_tasklet(unsigned long arg)
+static void ace_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *) arg;
-	struct ace_private *ap = netdev_priv(dev);
+	struct ace_private *ap = from_tasklet(ap, t, ace_tasklet);
+	struct net_device *dev = (struct net_device *)((char *)ap -
+				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	int cur_size;
 
 	cur_size = atomic_read(&ap->cur_rx_bufs);
@@ -2269,7 +2270,7 @@ static int ace_open(struct net_device *dev)
 	/*
 	 * Setup the bottom half rx ring refill handler
 	 */
-	tasklet_init(&ap->ace_tasklet, ace_tasklet, (unsigned long)dev);
+	tasklet_setup(&ap->ace_tasklet, ace_tasklet);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/alteon/acenic.h b/drivers/net/ethernet/alteon/acenic.h
index c670067b1541..4b02c705859c 100644
--- a/drivers/net/ethernet/alteon/acenic.h
+++ b/drivers/net/ethernet/alteon/acenic.h
@@ -776,7 +776,7 @@ static int ace_open(struct net_device *dev);
 static netdev_tx_t ace_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev);
 static int ace_close(struct net_device *dev);
-static void ace_tasklet(unsigned long dev);
+static void ace_tasklet(struct tasklet_struct *t);
 static void ace_dump_trace(struct ace_private *ap);
 static void ace_set_multicast_list(struct net_device *dev);
 static int ace_change_mtu(struct net_device *dev, int new_mtu);
-- 
2.17.1

