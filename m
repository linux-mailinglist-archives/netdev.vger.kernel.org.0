Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1052EF5E0
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbhAHQeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728410AbhAHQdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:44 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E76C0612AB
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:44 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b2so11821809edm.3
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W3636oXSLwvTxglbe6goTnJNgcJx/+xGzy9J0B9Ns6o=;
        b=TIM4uP1A0WiQkbXTb8uq6m8ugXIaOhxE8JynI5fX7qZvMyChYHd3e/4fmamNqBwTpf
         GunNUY7jFQB2cJsmpvPtWFncHfzK46dceIe1IEwQ7qVhU1klXg8vh6PhvO8u3tLbND5o
         HMAoOryDZjUYDtrpT3jCyehudlHrvK6OCFp8wkijbhtcxX9TMi1Etn2mrzaXvl37lrty
         GPuLOetiA8MPvqYkZjjEB9wsngFGcg5U4BWposuY3cBa7ryGAwjCALorZ7UShe0CvZ6m
         Ddi13mbK4s8hiK8/ekGl5lyPpUsYfHQSvVJEXV2mkmWKzIj2/Cqitu2cMUVCX+o1+nlN
         Deng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W3636oXSLwvTxglbe6goTnJNgcJx/+xGzy9J0B9Ns6o=;
        b=uVUB5NA002BxMk8gKxkJ1uZ5VMp/z2tZSkyv5pGG+00CJLEQm/IX65eXeG2vFEjwpn
         4iEL8Wnxm4pvFUOUY8FwgNAPHvj00KaysmHfO62eWNTjywTTkNfzpCC78iMwL0dTzSQ8
         ZYoLAMMwzf/Ono1679SszkSvyyxri5+oGn2Dy+LvT/cU+yb/sbdGlU8eSw8qmlCq6HDv
         xFfdOlJkjqfabM3FiCUggELxxeceyN2VljIZPebp1GT5ilDqIyAKFMk4R888tAO+Fsob
         JjUlOGBVKDDKWbdQRPn2P3vVFVHMRNNweKx53cLRuy0u2o58WWTnHRlSUH0a7M6YRGqY
         Tm0w==
X-Gm-Message-State: AOAM530wnnwVo5KbWmhP+BzSPJUL8uuEA5g/dqNM18QlVr9Tls+zMaFh
        8lQW8jwYcCCPX4BYVGtLVRM=
X-Google-Smtp-Source: ABdhPJypX/y4cPaUsyCdhKkiPX47xljAHVv1qv2A1t7Z5TtfDYLU17WrZQnEVUkw24Dyz7hC3PTEYg==
X-Received: by 2002:a05:6402:2066:: with SMTP id bd6mr5812719edb.211.1610123563678;
        Fri, 08 Jan 2021 08:32:43 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:43 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v5 net-next 16/16] net: mark ndo_get_stats64 as being able to sleep
Date:   Fri,  8 Jan 2021 18:31:59 +0200
Message-Id: <20210108163159.358043-17-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that all callers have been converted to not use atomic context when
calling dev_get_stats, it is time to update the documentation and put a
notice in the function that it expects process context.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Updated the documentation.

 Documentation/networking/netdevices.rst | 8 ++++++--
 Documentation/networking/statistics.rst | 9 ++++-----
 net/core/dev.c                          | 2 ++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 5a85fcc80c76..944599722c76 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -64,8 +64,12 @@ ndo_do_ioctl:
 	Context: process
 
 ndo_get_stats:
-	Synchronization: dev_base_lock rwlock.
-	Context: nominally process, but don't sleep inside an rwlock
+	Synchronization:
+		none. netif_lists_lock(net) might be held, but not guaranteed.
+		It is illegal to hold rtnl_lock() in this method, since it will
+		cause a lock inversion with netif_lists_lock and a deadlock.
+	Context:
+		process
 
 ndo_start_xmit:
 	Synchronization: __netif_tx_lock spinlock.
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index 234abedc29b2..ad3e353df0dd 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -155,11 +155,10 @@ Drivers must ensure best possible compliance with
 Please note for example that detailed error statistics must be
 added into the general `rx_error` / `tx_error` counters.
 
-The `.ndo_get_stats64` callback can not sleep because of accesses
-via `/proc/net/dev`. If driver may sleep when retrieving the statistics
-from the device it should do so periodically asynchronously and only return
-a recent copy from `.ndo_get_stats64`. Ethtool interrupt coalescing interface
-allows setting the frequency of refreshing statistics, if needed.
+Drivers may sleep when retrieving the statistics from the device, or they might
+read the counters periodically and only return in `.ndo_get_stats64` a recent
+copy collected asynchronously. In the latter case, the ethtool interrupt
+coalescing interface allows setting the frequency of refreshing statistics.
 
 Retrieving ethtool statistics is a multi-syscall process, drivers are advised
 to keep the number of statistics constant to avoid race conditions with
diff --git a/net/core/dev.c b/net/core/dev.c
index 30facac95d5e..afd0e226efd4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10409,6 +10409,8 @@ int __must_check dev_get_stats(struct net_device *dev,
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err = 0;
 
+	might_sleep();
+
 	if (ops->ndo_get_stats64) {
 		memset(storage, 0, sizeof(*storage));
 		err = ops->ndo_get_stats64(dev, storage);
-- 
2.25.1

