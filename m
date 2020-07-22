Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2938022914F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgGVGwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:52:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54884 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGVGwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:52:16 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <andrea.righi@canonical.com>)
        id 1jy8bu-0005xY-1t
        for netdev@vger.kernel.org; Wed, 22 Jul 2020 06:52:14 +0000
Received: by mail-wr1-f69.google.com with SMTP id h4so242551wrh.10
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=uhBXqoms6Y2BJ+DRWgv1UXrLfuoV1AP2/YI2uOM0BIc=;
        b=qAcrVhbFoDhTTd8DJvX2xfYhD+TWdafWyUKi/7Ezpn6/NPO/d3JegkEpjkrjFW9OnL
         q76LzfmWNAKrejL++LoGSvdKVRB8Y3IKRGbcE39ZzAlcdSw9WYAVmpWXCnPjN9KpIx0Y
         9vxE+WQg6u4as/zggwsmwmGJ+BFOB/QwTKSMZYHscL8rBUVc7e2P+Lcwj18wEIxTpi5o
         ES11z29oJCXm1GPubHfrkgth8TV7Mlb8MhgphbSwqJ5/FNm7q36ao973e0sooCOeJOzr
         dkRNjsN+BIHzYbdJv7xy1ADPhFM9o8ky79eAvixxk3xzy+5gZk2Du9nLPbFMKMOkbWSk
         BuRw==
X-Gm-Message-State: AOAM530U1sHU+rd1Jsylvm5NWyXuljCSOxBGjjTke1jkHqRQdRK/fd5H
        Dj3L2gXh9YaPEK/EO74ZT9vEvRiI4xoOK9FshK0+0yAaO/rvfmUYa/2xrabhVZgFZj0bxDbv8TY
        N68OqN7AoRHl3wOCrgL6DXOFJ1EshAAuBmw==
X-Received: by 2002:a7b:c05a:: with SMTP id u26mr1897726wmc.73.1595400733684;
        Tue, 21 Jul 2020 23:52:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhC1gnk9TlQyUIEJ3tOszObyW4FaQs/e6/6fGBY61IX5lMt1lAPzd6jSpjxL2aHTCAHJKvaQ==
X-Received: by 2002:a7b:c05a:: with SMTP id u26mr1897700wmc.73.1595400733297;
        Tue, 21 Jul 2020 23:52:13 -0700 (PDT)
Received: from localhost (host-87-11-131-192.retail.telecomitalia.it. [87.11.131.192])
        by smtp.gmail.com with ESMTPSA id g70sm2426599wmg.24.2020.07.21.23.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 23:52:12 -0700 (PDT)
Date:   Wed, 22 Jul 2020 08:52:11 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xen-netfront: fix potential deadlock in xennet_remove()
Message-ID: <20200722065211.GA841369@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a potential race in xennet_remove(); this is what the driver is
doing upon unregistering a network device:

  1. state = read bus state
  2. if state is not "Closed":
  3.    request to set state to "Closing"
  4.    wait for state to be set to "Closing"
  5.    request to set state to "Closed"
  6.    wait for state to be set to "Closed"

If the state changes to "Closed" immediately after step 1 we are stuck
forever in step 4, because the state will never go back from "Closed" to
"Closing".

Make sure to check also for state == "Closed" in step 4 to prevent the
deadlock.

Also add a 5 sec timeout any time we wait for the bus state to change,
to avoid getting stuck forever in wait_event() and add a debug message
to help tracking down potential similar issues.

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 drivers/net/xen-netfront.c | 79 +++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 482c6c8b0fb7..e09caba93dd9 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -63,6 +63,8 @@ module_param_named(max_queues, xennet_max_queues, uint, 0644);
 MODULE_PARM_DESC(max_queues,
 		 "Maximum number of queues per virtual interface");
 
+#define XENNET_TIMEOUT  (5 * HZ)
+
 static const struct ethtool_ops xennet_ethtool_ops;
 
 struct netfront_cb {
@@ -1334,12 +1336,20 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 
 	netif_carrier_off(netdev);
 
-	xenbus_switch_state(dev, XenbusStateInitialising);
-	wait_event(module_wq,
-		   xenbus_read_driver_state(dev->otherend) !=
-		   XenbusStateClosed &&
-		   xenbus_read_driver_state(dev->otherend) !=
-		   XenbusStateUnknown);
+	do {
+		dev_dbg(&dev->dev,
+			"%s: switching to XenbusStateInitialising\n",
+			dev->nodename);
+		xenbus_switch_state(dev, XenbusStateInitialising);
+		err = wait_event_timeout(module_wq,
+				 xenbus_read_driver_state(dev->otherend) !=
+				 XenbusStateClosed &&
+				 xenbus_read_driver_state(dev->otherend) !=
+				 XenbusStateUnknown, XENNET_TIMEOUT);
+		dev_dbg(&dev->dev, "%s: state = %d\n", dev->nodename,
+			xenbus_read_driver_state(dev->otherend));
+	} while (!err);
+
 	return netdev;
 
  exit:
@@ -2139,28 +2149,53 @@ static const struct attribute_group xennet_dev_group = {
 };
 #endif /* CONFIG_SYSFS */
 
-static int xennet_remove(struct xenbus_device *dev)
+static void xennet_bus_close(struct xenbus_device *dev)
 {
-	struct netfront_info *info = dev_get_drvdata(&dev->dev);
-
-	dev_dbg(&dev->dev, "%s\n", dev->nodename);
+	int ret;
 
-	if (xenbus_read_driver_state(dev->otherend) != XenbusStateClosed) {
+	if (xenbus_read_driver_state(dev->otherend) == XenbusStateClosed)
+		return;
+	do {
+		dev_dbg(&dev->dev, "%s: switching to XenbusStateClosing\n",
+			dev->nodename);
 		xenbus_switch_state(dev, XenbusStateClosing);
-		wait_event(module_wq,
-			   xenbus_read_driver_state(dev->otherend) ==
-			   XenbusStateClosing ||
-			   xenbus_read_driver_state(dev->otherend) ==
-			   XenbusStateUnknown);
+		ret = wait_event_timeout(module_wq,
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateClosing ||
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateClosed ||
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateUnknown,
+				   XENNET_TIMEOUT);
+		dev_dbg(&dev->dev, "%s: state = %d\n", dev->nodename,
+			xenbus_read_driver_state(dev->otherend));
+	} while (!ret);
+
+	if (xenbus_read_driver_state(dev->otherend) == XenbusStateClosed)
+		return;
 
+	do {
+		dev_dbg(&dev->dev, "%s: switching to XenbusStateClosed\n",
+			dev->nodename);
 		xenbus_switch_state(dev, XenbusStateClosed);
-		wait_event(module_wq,
-			   xenbus_read_driver_state(dev->otherend) ==
-			   XenbusStateClosed ||
-			   xenbus_read_driver_state(dev->otherend) ==
-			   XenbusStateUnknown);
-	}
+		ret = wait_event_timeout(module_wq,
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateClosed ||
+				   xenbus_read_driver_state(dev->otherend) ==
+				   XenbusStateUnknown,
+				   XENNET_TIMEOUT);
+		dev_dbg(&dev->dev, "%s: state = %d\n", dev->nodename,
+			xenbus_read_driver_state(dev->otherend));
+	} while (!ret);
+}
+
+static int xennet_remove(struct xenbus_device *dev)
+{
+	struct netfront_info *info = dev_get_drvdata(&dev->dev);
+
+	dev_dbg(&dev->dev, "%s\n", dev->nodename);
 
+	xennet_bus_close(dev);
 	xennet_disconnect_backend(info);
 
 	if (info->netdev->reg_state == NETREG_REGISTERED)
-- 
2.25.1

