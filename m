Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88C72EEA56
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbhAHAWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbhAHAWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:22:00 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0CCC0612A4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:49 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id h16so9466447edt.7
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vqdzPZTBNlpBCPv/5gBK6rPPzfiFN2/7bPw7ERtXWLU=;
        b=W9cGUpCqAtazkA+FszH+xaH1GjtT+ixBJkF8qJI5DUGQT2unP4AR151ZdlvVN3/lU4
         DNAn9YEkQh6bF44qkPmC6hNxP2c31h8VTmOrq6NE1dbIWZQe/wW6i8D+yOO8sV817a/t
         8/NnTBzXzuJwlJckMtZTEyT8XGl3q2QE0f1+AcJ0H+OuXTkaxvZ68cXuVvwg37XbQ/p6
         iZ31PfxPBRplwtD9cq43TMfwygJmJIFqID9/4egFK77snIn/Si//G9LJwscPTvkQmYJ3
         CDqHzoXholO3z3c+MJpcs9kxWf5gohJC0oEyRoZIfcPUZT5/oslJT/a8f8pgnu2vt2Rt
         jnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vqdzPZTBNlpBCPv/5gBK6rPPzfiFN2/7bPw7ERtXWLU=;
        b=RwhvRCMA9u9yFHG/miizjedZc2FnCwKYpEkf43qzzAmXuOl+qvjKY23XTE+uuMUCd8
         NT0QOrEOW8Of4rUWDLpVNXo/cCxxQTRlez6BKQQHx+x2VF+LdeqLxxE9datt6NUBt1Ic
         brDLVz5HJNEUQ0SU95ltx6dLdxOOJ+KEhiEAm0sv7pf6ImYbP699SqLFlZMWvK5WmuG8
         Y/IM/hbYurECa7MI3JvrUpen2u1zEpijn8DWY3phI0hCgkf6m5YFLdf0a3KRa3gEErOg
         1b/aVxdxJyY2FR/pfljrcg78gRQ8wdI93+5vgM/RD9PaUIKsklwdQojnktGe6hiEH/zd
         mpfg==
X-Gm-Message-State: AOAM533mgwJMP6fryc/cpiIvkq9Un4Pld6V0hcBGFd0U3b6ao2P7G0HO
        /cvJ8thIey+9cKBh3126Yuk=
X-Google-Smtp-Source: ABdhPJzGU01/ICTOs/J2BVnFsNKA8MBjTFwPdlC3PEjBmLWk4tZaRiEvSvrI5GuYoLAxYa2c9DRRrA==
X-Received: by 2002:a50:eb97:: with SMTP id y23mr3455361edr.29.1610065248402;
        Thu, 07 Jan 2021 16:20:48 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:47 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
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
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 17/18] net: mark ndo_get_stats64 as being able to sleep
Date:   Fri,  8 Jan 2021 02:20:04 +0200
Message-Id: <20210108002005.3429956-18-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
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
index 96ef462932a7..4feda48672cf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10408,6 +10408,8 @@ int dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage)
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err = 0;
 
+	might_sleep();
+
 	if (ops->ndo_get_stats64) {
 		memset(storage, 0, sizeof(*storage));
 		err = ops->ndo_get_stats64(dev, storage);
-- 
2.25.1

