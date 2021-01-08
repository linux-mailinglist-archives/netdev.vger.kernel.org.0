Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D332EEA4A
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbhAHAVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729250AbhAHAVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:45 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8211AC0612FB
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:33 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j16so9551963edr.0
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uRun+cwgSl0Uw/asLb1EObRtOH80zeClR0Pwl3YmkHI=;
        b=lQmftUq733BT0lhBJBTNGZ04z1SVnTfncqOVawiUXgMq5HCnOMeja1w3Lh/xu8NRDh
         P3tWqhSGO3kFhX63MMRODItVZHHFIIS1oRCXzKAI3gj5nW3HC6J7lhK4b/u4ZaHgm8k4
         /JhfT3iqb3CN/QIdMDSNN5VRon6gFNJ8nLEaqw4kBvVCz6GmOC9dKUjXOPcatdiSwmSC
         6IX7HhAC+zMH+VlYNOTCebqvFMx8ZNiO9ACWS/xSGi/aukhfwoWzbBtLvzlkxIV8H8c2
         R/R76pcgEZUHYXCT479rd73IpK3tRIpWbfG3PIAxXjtJ8vcTsFFo93rk9DqV3esSu1zM
         zZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uRun+cwgSl0Uw/asLb1EObRtOH80zeClR0Pwl3YmkHI=;
        b=efXnSNTs53ZmycJ6Y0qd44yAeA3wfd5wSNv+Id8DmSdcI2ZevOrIIn6V96w5XoaBWQ
         NJgSameUanwYoWl0Def+ib9yc1DWgJ0XJL0VE6M4b5m2UiAiG85dgynqtbBpxvf9N5Bm
         uT5KUrnpZWN2Iz/PjuJqIL+0wxneClrVadNH/jxCtJoW5UR5KFroCf0a0smIBgDLmX8M
         j5S1OAwbzcuVLJ/qhIvbYyxFcAUdtnZB71NPehYG/OM6ExFHkUOsxo7+d5EhMHLKVv5Y
         bstmGcE8HGxfVAxEWtrZz9VrUW+bzcnigR/nOvxdSmg7NWfRmsCp0eaDmr+X1ox4S9/T
         gwFg==
X-Gm-Message-State: AOAM531VK3rbwoeF1lr+MrdeMti+9bmhDQu7YSRLoE4WGQR/0dh9Bd25
        uAoUWl+BTVJiKV0vykov7Is=
X-Google-Smtp-Source: ABdhPJxfOgTeqlBX+2nY1IT0njzfYir5V+RSDqFWBnvOsNS0q3shbSUZiMbhU4J7+nlq4SKcB/CT+A==
X-Received: by 2002:a05:6402:366:: with SMTP id s6mr3391011edw.44.1610065232171;
        Thu, 07 Jan 2021 16:20:32 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:31 -0800 (PST)
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
Subject: [PATCH v4 net-next 06/18] parisc/led: reindent the code that gathers device statistics
Date:   Fri,  8 Jan 2021 02:19:53 +0200
Message-Id: <20210108002005.3429956-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
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
Changes in v4:
None.

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

