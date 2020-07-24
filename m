Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C522C189
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgGXI7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 04:59:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57292 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgGXI7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 04:59:16 -0400
Received: from mail-ej1-f69.google.com ([209.85.218.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <andrea.righi@canonical.com>)
        id 1jytXt-0003cT-VD
        for netdev@vger.kernel.org; Fri, 24 Jul 2020 08:59:14 +0000
Received: by mail-ej1-f69.google.com with SMTP id q9so3404635ejr.21
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 01:59:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Hjub13SPe2wEgoDjP8LKlCX8Yl7alX0oGHdU3qzYDPM=;
        b=THum2cfONJxhfwuGW1Kv0OjuYrhD3/5hAUjaiKdBLGwE6kLMoUPSWZWbwG6B59V6Uc
         fRQKZZr9fdyzY9k2BrFfN+oGXsbj2da0XW4PpVUUpPy1Af9B4+VgNCjZBFdqdh4DW5gE
         akipvtydQJppVdYu54Cg2uB+joDX6OxSdqezwcdkGLZcvctqdqbIeQfpKJI29TGNJiZG
         F2E7a6rTkRfz0DfmQ+ZTi2Hf7wY0295lJEIBBh8oHOCiSKkeEw17PEiYtu8ZWbeV4+b5
         nUoMjjb0+RHjDBBcLk4n7dhAk/NCfTIfzhdWQ/avWnEVAXPjSMoFahe+lTs44sqRgJir
         mTiQ==
X-Gm-Message-State: AOAM53160N3EV8PO93Ajkuv08NjVVNpZJcm2Vs7nePS6UX79uQHuJZWk
        l6HQJffJAN1DW0P/hPM/XPoNHgUfSZEhk1/gghdBIWqsMoU74Cp9RYK2U3J50Y4B5Ve65C83v3X
        8wLJ5nX76W0aMXFGIiJyHUvAYCoRRe3n9Kw==
X-Received: by 2002:a17:906:c40d:: with SMTP id u13mr8037438ejz.519.1595581152669;
        Fri, 24 Jul 2020 01:59:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLghkjxyAHSXRSJUM7yxIeHsXsl1Sx8URoFGpqj60bEA7IlZyIWZIUznr715CpupWlbmdO2A==
X-Received: by 2002:a17:906:c40d:: with SMTP id u13mr8037418ejz.519.1595581152278;
        Fri, 24 Jul 2020 01:59:12 -0700 (PDT)
Received: from localhost (host-87-11-131-192.retail.telecomitalia.it. [87.11.131.192])
        by smtp.gmail.com with ESMTPSA id y22sm302547edl.84.2020.07.24.01.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 01:59:11 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:59:10 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] xen-netfront: fix potential deadlock in xennet_remove()
Message-ID: <20200724085910.GA1043801@xps-13>
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
to avoid getting stuck forever in wait_event().

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
Changes in v2:
 - remove all dev_dbg() calls (as suggested by David Miller)

 drivers/net/xen-netfront.c | 64 +++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 482c6c8b0fb7..88280057e032 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -63,6 +63,8 @@ module_param_named(max_queues, xennet_max_queues, uint, 0644);
 MODULE_PARM_DESC(max_queues,
 		 "Maximum number of queues per virtual interface");
 
+#define XENNET_TIMEOUT  (5 * HZ)
+
 static const struct ethtool_ops xennet_ethtool_ops;
 
 struct netfront_cb {
@@ -1334,12 +1336,15 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 
 	netif_carrier_off(netdev);
 
-	xenbus_switch_state(dev, XenbusStateInitialising);
-	wait_event(module_wq,
-		   xenbus_read_driver_state(dev->otherend) !=
-		   XenbusStateClosed &&
-		   xenbus_read_driver_state(dev->otherend) !=
-		   XenbusStateUnknown);
+	do {
+		xenbus_switch_state(dev, XenbusStateInitialising);
+		err = wait_event_timeout(module_wq,
+				 xenbus_read_driver_state(dev->otherend) !=
+				 XenbusStateClosed &&
+				 xenbus_read_driver_state(dev->otherend) !=
+				 XenbusStateUnknown, XENNET_TIMEOUT);
+	} while (!err);
+
 	return netdev;
 
  exit:
@@ -2139,28 +2144,43 @@ static const struct attribute_group xennet_dev_group = {
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
+	} while (!ret);
+
+	if (xenbus_read_driver_state(dev->otherend) == XenbusStateClosed)
+		return;
 
+	do {
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
+	} while (!ret);
+}
+
+static int xennet_remove(struct xenbus_device *dev)
+{
+	struct netfront_info *info = dev_get_drvdata(&dev->dev);
 
+	xennet_bus_close(dev);
 	xennet_disconnect_backend(info);
 
 	if (info->netdev->reg_state == NETREG_REGISTERED)
-- 
2.25.1

