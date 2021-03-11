Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FE9336D03
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhCKHXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbhCKHXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 02:23:19 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AF6C061574;
        Wed, 10 Mar 2021 23:23:19 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b23so5256655pfo.8;
        Wed, 10 Mar 2021 23:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bQ+MhgJJeqZ2ppdhkPvqIcV/LFOsRoAQhfX9yedaWFQ=;
        b=rRJwKAV0XQJNWpgy57IHYDrA29NKx01MUeBDc0ROiH4DQn09oY4U4ohqgcGnm03LZI
         7p6NQY2vQ1yQAH/ikjafv18OZCs36VRuqc4x4PZ7GibDqKW4PqWcbzT1rqRVovRQwbDX
         VQqdQuhh3L+GNUToiqf5c7MufjEc3a10lGrbT7f5fcI8N+vIVgBFL5oUn150vgGKI6Hb
         hMpCJ6ojmCox3xcEhS/lftViVQWl8Yiod5XhQMyXMrD4GF5W4MM0F4Qm/O383hhq1mNK
         PIRiu5H++/jODPG7Sw0gxVNHgZgiPg23CERgB83CYAARcLZcXpN5z1p1uYmHlM0GiJsW
         VpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bQ+MhgJJeqZ2ppdhkPvqIcV/LFOsRoAQhfX9yedaWFQ=;
        b=fyfuz3hq+5OGnTNAJYo1ZNhyGYcyCdJmV3AkiyUFfPp3Y2CfqqMsyJKGnPw1i4rDT2
         xod1Es4lpFYnORiVIs8noZlHzNZVXx9t4d8Mv9W4UsSNVj4mxPD77J29/9/J2H3rsr25
         lewKXFe2N91tqP5iHFZqn1oJ+DKFrZSIRyKnTAMUES2kAtTigrO5ng6K9zkea9nTzFZn
         1MAk5u0Wwp26w+QTRLGicQH+0Y0Nn1FCV/SkH3gPMSgWsnqZUi0G+iyRbr+E34gSrYH9
         Ezx+ecSQPdAta4WGM6vXrMNWi/zAuzWjZOJhLn0nHPMbBI1Z1WtFIpEgjjkGIUrf+LhU
         cDsA==
X-Gm-Message-State: AOAM530jzP11Xp38xDZimokX4yBNLS/m/XxSN1RhnQKD0KjRmQOWPIlq
        6O16RQoUGTPG753D3NF50H8DS/bvAVU=
X-Google-Smtp-Source: ABdhPJxeYFCjxIueFXov0trhx3KlrCmnBpnb/cEg7BxLz4lJLip5QKwAHjfhtcrswFPjirHlLVidLQ==
X-Received: by 2002:a62:e708:0:b029:1f8:c092:ff93 with SMTP id s8-20020a62e7080000b02901f8c092ff93mr6165670pfh.21.1615447398981;
        Wed, 10 Mar 2021 23:23:18 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:18d9:c811:37df:1c17])
        by smtp.gmail.com with ESMTPSA id e1sm1439730pfi.175.2021.03.10.23.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 23:23:18 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: lapbether: Prevent racing when checking whether the netif is running
Date:   Wed, 10 Mar 2021 23:23:09 -0800
Message-Id: <20210311072311.2969-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two "netif_running" checks in this driver. One is in
"lapbeth_xmit" and the other is in "lapbeth_rcv". They serve to make
sure that the LAPB APIs called in these functions are called before
"lapb_unregister" is called by the "ndo_stop" function.

However, these "netif_running" checks are unreliable, because it's
possible that immediately after "netif_running" returns true, "ndo_stop"
is called (which causes "lapb_unregister" to be called).

This patch adds locking to make sure "lapbeth_xmit" and "lapbeth_rcv" can
reliably check and ensure the netif is running while doing their work.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index c3372498f4f1..8fda0446ff71 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -51,6 +51,8 @@ struct lapbethdev {
 	struct list_head	node;
 	struct net_device	*ethdev;	/* link to ethernet device */
 	struct net_device	*axdev;		/* lapbeth device (lapb#) */
+	bool			up;
+	spinlock_t		up_lock;	/* Protects "up" */
 };
 
 static LIST_HEAD(lapbeth_devices);
@@ -101,8 +103,9 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 	rcu_read_lock();
 	lapbeth = lapbeth_get_x25_dev(dev);
 	if (!lapbeth)
-		goto drop_unlock;
-	if (!netif_running(lapbeth->axdev))
+		goto drop_unlock_rcu;
+	spin_lock_bh(&lapbeth->up_lock);
+	if (!lapbeth->up)
 		goto drop_unlock;
 
 	len = skb->data[0] + skb->data[1] * 256;
@@ -117,11 +120,14 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 		goto drop_unlock;
 	}
 out:
+	spin_unlock_bh(&lapbeth->up_lock);
 	rcu_read_unlock();
 	return 0;
 drop_unlock:
 	kfree_skb(skb);
 	goto out;
+drop_unlock_rcu:
+	rcu_read_unlock();
 drop:
 	kfree_skb(skb);
 	return 0;
@@ -151,13 +157,11 @@ static int lapbeth_data_indication(struct net_device *dev, struct sk_buff *skb)
 static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
-	/*
-	 * Just to be *really* sure not to send anything if the interface
-	 * is down, the ethernet device may have gone.
-	 */
-	if (!netif_running(dev))
+	spin_lock_bh(&lapbeth->up_lock);
+	if (!lapbeth->up)
 		goto drop;
 
 	/* There should be a pseudo header of 1 byte added by upper layers.
@@ -194,6 +198,7 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 		goto drop;
 	}
 out:
+	spin_unlock_bh(&lapbeth->up_lock);
 	return NETDEV_TX_OK;
 drop:
 	kfree_skb(skb);
@@ -285,6 +290,7 @@ static const struct lapb_register_struct lapbeth_callbacks = {
  */
 static int lapbeth_open(struct net_device *dev)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
 	if ((err = lapb_register(dev, &lapbeth_callbacks)) != LAPB_OK) {
@@ -292,13 +298,22 @@ static int lapbeth_open(struct net_device *dev)
 		return -ENODEV;
 	}
 
+	spin_lock_bh(&lapbeth->up_lock);
+	lapbeth->up = true;
+	spin_unlock_bh(&lapbeth->up_lock);
+
 	return 0;
 }
 
 static int lapbeth_close(struct net_device *dev)
 {
+	struct lapbethdev *lapbeth = netdev_priv(dev);
 	int err;
 
+	spin_lock_bh(&lapbeth->up_lock);
+	lapbeth->up = false;
+	spin_unlock_bh(&lapbeth->up_lock);
+
 	if ((err = lapb_unregister(dev)) != LAPB_OK)
 		pr_err("lapb_unregister error: %d\n", err);
 
@@ -356,6 +371,9 @@ static int lapbeth_new_device(struct net_device *dev)
 	dev_hold(dev);
 	lapbeth->ethdev = dev;
 
+	lapbeth->up = false;
+	spin_lock_init(&lapbeth->up_lock);
+
 	rc = -EIO;
 	if (register_netdevice(ndev))
 		goto fail;
-- 
2.27.0

