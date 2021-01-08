Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90052EEA48
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbhAHAVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbhAHAVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:09 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA11C0612F8
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:29 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id u19so9539348edx.2
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=26eb1/LcZaXhcXl39clZGBJ6aYdQhRTmvkwoby/pGjk=;
        b=rZpuHuKWL103P/EwZPskXgnc5q8AKuEzhA8HfDSXqZTBubJby6Qa0iIhmFZNXJGwEQ
         s87LNm1lWCm2HL6rh+qa8mm3m11o4Jl7dTfv7f8vyw5x14bDbqOe1zUYJtbq+SyX4QVO
         LVdNcicG8sO/QSpP3iquCULHd1qIjtm1jszYk6zsM6qBLLM1gT5BSzwrA9fw9NZdG4VI
         EclzJ+C2EbkQX3+QlVkn+zqdnvQpF5kO9g2hqGSlfuBM48csl1Sxl6FXNYuW3ciiSoGZ
         B8rewnfhkDzblu9/Bt3ie2Rb6PHuEmstPi8FrYeu8RwGWo7yXfluhb3+MZXufpzxKl9B
         kcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=26eb1/LcZaXhcXl39clZGBJ6aYdQhRTmvkwoby/pGjk=;
        b=EyeFMOtNtoJdL8kgCw9rvldm3du0d4w3gD8pIUKyKGlfck1uP8XgWpulUIaQvfLykJ
         vkMgQxi5KHVZG/KNdt1k/9Rj9hLk5hcQnDsG671TVM9O8zNSCuEIZXbLMUqKoMw4l/TF
         oTTlI5Ctkzv/fdCUIHII/kanQ+d8l5bO5noABa9/Dc7Tm2B8RdTodwvVm+/7zai4YHsi
         0gwcqZ55k1BYgYCvTvPL7edftZdCXAc/GJjSIGsNSZJxYjHO/DsbnJ6jgMCk5U29zx3r
         2nauCzJFc9DDNsb5n/GhSNSWvO//GJP1lahYG0YSAU7VQzGDJOxp9gsIccA+rlVcm0Bz
         vTTA==
X-Gm-Message-State: AOAM531JRSi5ujYO79IFmE9WXv62MrZ8QJfUtfY2u8v4/HFf6Sy/Rept
        /QSm1baKYiypyQ3QuWR7uGs=
X-Google-Smtp-Source: ABdhPJxWFDeDmMzDm7Lj+7nW1SDYW+47mzO8n/gE5HKzkQllgSNvRHyJPNqZQ4ogafrlAtGbxoTgtw==
X-Received: by 2002:a50:e84d:: with SMTP id k13mr3381148edn.154.1610065227732;
        Thu, 07 Jan 2021 16:20:27 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:27 -0800 (PST)
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
Subject: [PATCH v4 net-next 03/18] net: procfs: hold netif_lists_lock when retrieving device statistics
Date:   Fri,  8 Jan 2021 02:19:50 +0200
Message-Id: <20210108002005.3429956-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The /proc/net/dev file uses an RCU read-side critical section to ensure
the integrity of the list of network interfaces, because it iterates
through all net devices in the netns to show their statistics.

To offer the equivalent protection against an interface registering or
deregistering, while also remaining in sleepable context, we can use the
netns mutex for the interface lists.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 net/core/net-procfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index c714e6a9dad4..4784703c1e39 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -21,7 +21,7 @@ static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff
 	unsigned int count = 0, offset = get_offset(*pos);
 
 	h = &net->dev_index_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, h, index_hlist) {
+	hlist_for_each_entry(dev, h, index_hlist) {
 		if (++count == offset)
 			return dev;
 	}
@@ -51,9 +51,11 @@ static inline struct net_device *dev_from_bucket(struct seq_file *seq, loff_t *p
  *	in detail.
  */
 static void *dev_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(RCU)
 {
-	rcu_read_lock();
+	struct net *net = seq_file_net(seq);
+
+	netif_lists_lock(net);
+
 	if (!*pos)
 		return SEQ_START_TOKEN;
 
@@ -70,9 +72,10 @@ static void *dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void dev_seq_stop(struct seq_file *seq, void *v)
-	__releases(RCU)
 {
-	rcu_read_unlock();
+	struct net *net = seq_file_net(seq);
+
+	netif_lists_unlock(net);
 }
 
 static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
-- 
2.25.1

