Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3795B2ECD52
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbhAGJwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbhAGJvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:47 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C81C0612FC
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:51:12 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id n26so8850699eju.6
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 01:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UgBhBVpzz6m5FwdjCW5WUOkWO3FR/vyy7c45RHmTols=;
        b=GrWdCYXFw/CxDEhhIsLb/y4hC63LQ5zFthNin1HkzlYR6kET6fnohgx/MwALBxPihF
         6rfBP9MWT9NSJqIkqdOxLmUMgV5wIPvq89t0aEmcsoBICRM12Gz4Iqx3xkbhfhYrx/S0
         OHO+0d60fFr0bB1u+YFSxPEYwA7en6Gs9GP5saAmXSfN4Sho5tX/6ErEzmvg9I8bKcwV
         5yID9czjqiUuKAiePCTJrRKx21ryEzd/QpWWY0b+VeFWaOhPqzPq5he4jv7djy+1YzkQ
         SP4LmvrZjwOiQ26VS6bGKoxLzXpNxaq0z1p7mK11Zre72KJFkZTah1LlWioMy3rImRXE
         o5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UgBhBVpzz6m5FwdjCW5WUOkWO3FR/vyy7c45RHmTols=;
        b=e0X8Jx0zlkivTTwzlVJKmPTCkZf8L7FdXRyi9fjbVCnfPiYTd417lMTeNmlY0TKz2e
         fYlUjtUB04gOQRQXokYmsqlPgYVfDv1gzptNFCWUbs84XMwsqfB9xio3jCYPpHJ1SsZU
         3zZB1eHeYx6/kBipI8MEllsKMkVU1jl7dCtE6c9zwNy7Rj4ITC15XZvDAelb0dcOuPX6
         QmYo1nMKdsqctGmfqMBJef5JHUUYXJUjbv8Ku39N+ZzEx6tptEM53YBQXuD4RRg6JpcU
         ql5E+pUwh7Wq4QEw+bseIk51S0mM1NT15l0h2ogGlZ1mNx7geu5ozfk8HOh+/19okNat
         CWug==
X-Gm-Message-State: AOAM530z0OwVMXHxxC4jQiag/zRklhrq/I10DIW4oAufmp2MQRF56Tr0
        cRF6bRpdM0hLz4LMh5P7EY0=
X-Google-Smtp-Source: ABdhPJx3EDiVZs9u5xtTHQLV9r9T+7dUZo4LQMRe1iWkqpXy8xblsKTvM5Hwlxd0yKn+810KQ2h1xQ==
X-Received: by 2002:a17:906:d146:: with SMTP id br6mr5629615ejb.331.1610013071776;
        Thu, 07 Jan 2021 01:51:11 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k15sm2251571ejc.79.2021.01.07.01.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 01:51:11 -0800 (PST)
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
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 net-next 06/12] parisc/led: reindent the code that gathers device statistics
Date:   Thu,  7 Jan 2021 11:49:45 +0200
Message-Id: <20210107094951.1772183-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107094951.1772183-1-olteanv@gmail.com>
References: <20210107094951.1772183-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The standard in the Linux kernel is to use one tab character per
indentation level.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/parisc/led.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 36c6613f7a36..3cada632a4be 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -359,16 +359,19 @@ static __inline__ int led_get_net_activity(void)
 	/* we are running as a workqueue task, so we can use an RCU lookup */
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
-	    const struct rtnl_link_stats64 *stats;
-	    struct rtnl_link_stats64 temp;
-	    struct in_device *in_dev = __in_dev_get_rcu(dev);
-	    if (!in_dev || !in_dev->ifa_list)
-		continue;
-	    if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
-		continue;
-	    stats = dev_get_stats(dev, &temp);
-	    rx_total += stats->rx_packets;
-	    tx_total += stats->tx_packets;
+		const struct rtnl_link_stats64 *stats;
+		struct rtnl_link_stats64 temp;
+		struct in_device *in_dev = __in_dev_get_rcu(dev);
+
+		if (!in_dev || !in_dev->ifa_list)
+			continue;
+
+		if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
+			continue;
+
+		stats = dev_get_stats(dev, &temp);
+		rx_total += stats->rx_packets;
+		tx_total += stats->tx_packets;
 	}
 	rcu_read_unlock();
 
-- 
2.25.1

