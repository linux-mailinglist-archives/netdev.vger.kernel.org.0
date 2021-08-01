Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B1F3DCB37
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhHAKlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhHAKls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:41:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB984C06175F
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 03:41:39 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id z4so17847172wrv.11
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 03:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/1WaO1XF2pP2CJ+ONM55A1kyCoUU1Cdv5L4sGMe68I8=;
        b=iZ3n3Cg2kAjXdU52jnluXOb5Z7HeSXXq9y2iN+VCMSSiRwVGyYL/26v000Ut+pWzlE
         MB9GlJDQlgXGJnMoRS0fLh6Xi5MGj4dxy31WdyGqkSuZe5WnfB7onJOPwo3X+Xwisz2X
         6368oir0YvcRoM1s3SpSgKhtb4Bt/rx4e4w2oqNwsFz+i40RP5WlctvmRHp1C7R3RuAz
         ySEw49nr/ygxturJPCZe0c3NHVzMK/uTIPGiSXL4dNW7hm4w00NNtsIc2pZV1GuYw7SM
         QeYMG6CIdjcnCqwP9nw2TJ9rRzdjWTqYuNiTndZY1u+nii2sfUzlzxDAfqTq9vZj8D9F
         VqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/1WaO1XF2pP2CJ+ONM55A1kyCoUU1Cdv5L4sGMe68I8=;
        b=SPNrOEjq7ih7jZOlWatSIa0EHyZ50q3JGHtywXs7SieEAM37U196dLVHRyy9ONLHSW
         JEaq7L4UISkqRl/itM7OX5BUlqmLDcyBIspC37LSGPG8vyxvgLBv2/je1Sz1uZ5tV1BD
         Ym5vWV12W2Lg6OwqQOgTk97LcLDOQgbWp8HhpBAA6KmXltDIncmVpjK4CgEOacdAL4F8
         Ug/mM5Davcw3EIzk6W29gxG5424oUb9UUoKLQI62VvHorGEuK5aroc6QVJHyUuQvuFJp
         mBTHjXZwa0OAx/TcvbHYrt0z5wcLjz+ke5yfjFmChFXWRSxRFoGE5Rhib/SHOn8TyK6q
         YwdQ==
X-Gm-Message-State: AOAM532tnteTp/XEIyU4GSFkrSUJDvkvH+jHSSK7iUA7sxMN1Klp9XZj
        62OrR4ZNv4v/4Hy/1d+AwQeX2+2S6f6QCQ==
X-Google-Smtp-Source: ABdhPJwsU/aDrYdIHGSQCXoSwt3J1JeYoOBznGcwJKjjNTtu5XVzwBssrGBDG27PR+U6WC1LtC9nLw==
X-Received: by 2002:a5d:4ac5:: with SMTP id y5mr12349353wrs.125.1627814498017;
        Sun, 01 Aug 2021 03:41:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:9d9e:757:f317:c524? (p200300ea8f10c2009d9e0757f317c524.dip0.t-ipconnect.de. [2003:ea:8f10:c200:9d9e:757:f317:c524])
        by smtp.googlemail.com with ESMTPSA id i7sm7969590wre.64.2021.08.01.03.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 03:41:37 -0700 (PDT)
Subject: [PATCH net-next 1/4] ethtool: runtime-resume netdev parent before
 ethtool ioctl ops
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Message-ID: <cb44d295-5267-48a7-b7c7-e4bf5b884e7a@gmail.com>
Date:   Sun, 1 Aug 2021 12:36:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a network device is runtime-suspended then:
- network device may be flagged as detached and all ethtool ops (even if not
  accessing the device) will fail because netif_device_present() returns
  false
- ethtool ops may fail because device is not accessible (e.g. because being
  in D3 in case of a PCI device)

It may not be desirable that userspace can't use even simple ethtool ops
that not access the device if interface or link is down. To be more friendly
to userspace let's ensure that device is runtime-resumed when executing the
respective ethtool op in kernel.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ethtool/ioctl.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index baa5d1004..b7ff9abe7 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -23,6 +23,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/sched/signal.h>
 #include <linux/net.h>
+#include <linux/pm_runtime.h>
 #include <net/devlink.h>
 #include <net/xdp_sock_drv.h>
 #include <net/flow_offload.h>
@@ -2589,7 +2590,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	int rc;
 	netdev_features_t old_features;
 
-	if (!dev || !netif_device_present(dev))
+	if (!dev)
 		return -ENODEV;
 
 	if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
@@ -2645,10 +2646,18 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 			return -EPERM;
 	}
 
+	if (dev->dev.parent)
+		pm_runtime_get_sync(dev->dev.parent);
+
+	if (!netif_device_present(dev)) {
+		rc = -ENODEV;
+		goto out;
+	}
+
 	if (dev->ethtool_ops->begin) {
 		rc = dev->ethtool_ops->begin(dev);
-		if (rc  < 0)
-			return rc;
+		if (rc < 0)
+			goto out;
 	}
 	old_features = dev->features;
 
@@ -2867,6 +2876,9 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 
 	if (old_features != dev->features)
 		netdev_features_change(dev);
+out:
+	if (dev->dev.parent)
+		pm_runtime_put(dev->dev.parent);
 
 	return rc;
 }
-- 
2.32.0


