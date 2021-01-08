Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CFD2EF5CD
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbhAHQdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbhAHQdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:04 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D176CC0612FF
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:23 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ga15so15325490ejb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5DV/tAig4DrT/wfoPlGlgMzygf60SqmYKJ6Vxj08mGU=;
        b=mgPrwqphM2ocsVWdctK5agDoqJfxXS+qUkUfpj1nbl2Y3GmNy0geyPaxbVjUveVrt5
         J4ekRrHHeXL5jnY1igAfb/nU39D5T1SmfJ5Nngp+7kysKlZusH+983MZPdmtKbwF8yvK
         0RvUiXT5T9vQnur0g9/3xwcRkBAK4aI116o3nEj+58hXwY5xUNGhbH3msXCuw5553Aj/
         FJTndMDq9guxChqqU/NlKvgU1OQLmjk58BupG3IO891UD6UXNZfL1wWeJSCPL/M7g7bA
         kNM/lnjQzA+3lflHwqR3XoN1cAc7NIlt0DfHbDs67QyOEFFXTyzNb0e1w9AEgErI9TYd
         JsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5DV/tAig4DrT/wfoPlGlgMzygf60SqmYKJ6Vxj08mGU=;
        b=aPpNT85zpj9RGEx3pTXFte83BS6sfARTsPPiExar0XWWHsCwNHcJLZ1Y0pCd0GigAU
         lAHfPXmso7Eks2hWlFIO7xWWt7gIxUwFSNO9FHElhPzv60Vmzx9L3xGo5w98dG4ySfEY
         Qc+H03ZcTnqK0ytKWFDnLOXlV73tLhcP4qilzaCrjXbHpHqe24vm3w3RGxCb+7EMu8JY
         X/3X+VlLqHn/rPDJ1WZui4gO4ibz2gnMkTXbuiGedeHh9lMlN01+r1ZJruZdaqqeWTsc
         ds4VHOOChZH7wNjyviO1Ogji2LR4tFUhd5IaQNI5EJRRyJA+uYt3HOaCQhtb2WhhlEKO
         2HHQ==
X-Gm-Message-State: AOAM5332R9i/bvU5VgrRW8eAoV2wnN7xy70d1GhFrQiaEIEbmi0mQTA3
        MYzeMMDHK2cdfwoQ7gzElOY=
X-Google-Smtp-Source: ABdhPJwpF+ton2aDuGEDSdEG3K99RFYeNcLKs5T/yLkGVekEGW+XoDqw2bpqJ7Edm6aad+iuc23boA==
X-Received: by 2002:a17:906:1a4e:: with SMTP id j14mr3087065ejf.507.1610123542603;
        Fri, 08 Jan 2021 08:32:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:21 -0800 (PST)
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
Subject: [PATCH v5 net-next 03/16] net: procfs: hold netif_lists_lock when retrieving device statistics
Date:   Fri,  8 Jan 2021 18:31:46 +0200
Message-Id: <20210108163159.358043-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
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
Changes in v5:
None.

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

