Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34277F3CDB
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfKHA1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:50 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:56445 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfKHA1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:49 -0500
Received: by mail-pg1-f202.google.com with SMTP id 11so3230375pgm.23
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=s9TDPXVutAEMh1Sam1PuWfdu5YkgA07h1yQq73UtCQo=;
        b=SSOVtoIpd6+Ax4QA1LXyrYBl/5zLpwqKSTQGk15bFOA47HKB/hKyQWeUyrVjBj/9cI
         MBM57cG09qhfwaJtrn5FaddrXL0lTsBU0mdvEK66ecgLBgxHnkFSCLaw3cdpaemD/+fC
         r26TlT23LpiRWUV9ura8SOTSSZek3CPEJtT4kO6lQ4d86HW6z0ULOlTb5KBjqkOtjfJ2
         qYMwCYTN7noHjl3N9H4bzOmECmWsEs5chKKfbKstA46OcuzkIDljCaw80w1H948g38OA
         s1voghju5d4LRd6UfgSB2CVQwFoW8tANrh0Zgu5cx6XB0dHovDWK5tceQq2lv+7Bw5LH
         QPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=s9TDPXVutAEMh1Sam1PuWfdu5YkgA07h1yQq73UtCQo=;
        b=aLfPEfO8Abur0NUib6x1i0F4FkIbSJDmKFiV4i2MkbUSpKN1bL9vlWu3puIj6V64mn
         XPZFaxYkcnfPAydjgMNZOBgjhBt67rFFKCQx/zYpj/6NW4muAdzME//se+4PmP2hdt2V
         CLdLSphcZ1hCU0tFEsV199tZMwlGx2E04kCmjuaYgD6x9oykDjOzuf2yrJNpsMVFyMps
         me3gbmJ8X9K7NB9LUvkVtobRNmvaDgYMpFFF3Y4spA6jMzRykcoHSP/s2vYvJbY0B+R9
         ZWyRdfI65SJm09D+JgA6MIlMpLWCDYejzuU7ky4XkmN/MpkKf9mnPCwirwt/pPl0ch5A
         Qmug==
X-Gm-Message-State: APjAAAXyMYmpVB0FML/g/jYUPbARUF33YAnggXeUHEFhHbu/syx2kCuo
        B9VQlF/cd+l5b9bEbH6YOibLkcuaQn+z8Q==
X-Google-Smtp-Source: APXvYqzaVpeiEW5JrG89aiQNcFlluP2dfmDOZYjxE8wIgNf+CJ1w05stFDbiiDtANvy2ujwvay42kVAVqwJR7g==
X-Received: by 2002:a65:6492:: with SMTP id e18mr3045910pgv.111.1573172868605;
 Thu, 07 Nov 2019 16:27:48 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:19 -0800
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
Message-Id: <20191108002722.129055-7-edumazet@google.com>
Mime-Version: 1.0
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 6/9] net: dummy: use standard dev_lstats_add() and dev_lstats_read()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver can simply use the common infrastructure instead
of duplicating it.

This cleanup will ease u64_stats_t adoption in a single location.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/dummy.c | 36 +++++-------------------------------
 1 file changed, 5 insertions(+), 31 deletions(-)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index 54e4d8b07f0e054b2fb83f4ea05063295a544f5b..3031a5fc54276009269992061f3bd11e02711927 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -51,41 +51,15 @@ static void set_multicast_list(struct net_device *dev)
 {
 }
 
-struct pcpu_dstats {
-	u64			tx_packets;
-	u64			tx_bytes;
-	struct u64_stats_sync	syncp;
-};
-
 static void dummy_get_stats64(struct net_device *dev,
 			      struct rtnl_link_stats64 *stats)
 {
-	int i;
-
-	for_each_possible_cpu(i) {
-		const struct pcpu_dstats *dstats;
-		u64 tbytes, tpackets;
-		unsigned int start;
-
-		dstats = per_cpu_ptr(dev->dstats, i);
-		do {
-			start = u64_stats_fetch_begin_irq(&dstats->syncp);
-			tbytes = dstats->tx_bytes;
-			tpackets = dstats->tx_packets;
-		} while (u64_stats_fetch_retry_irq(&dstats->syncp, start));
-		stats->tx_bytes += tbytes;
-		stats->tx_packets += tpackets;
-	}
+	dev_lstats_read(dev, &stats->tx_packets, &stats->tx_bytes);
 }
 
 static netdev_tx_t dummy_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
-
-	u64_stats_update_begin(&dstats->syncp);
-	dstats->tx_packets++;
-	dstats->tx_bytes += skb->len;
-	u64_stats_update_end(&dstats->syncp);
+	dev_lstats_add(dev, skb->len);
 
 	skb_tx_timestamp(skb);
 	dev_kfree_skb(skb);
@@ -94,8 +68,8 @@ static netdev_tx_t dummy_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static int dummy_dev_init(struct net_device *dev)
 {
-	dev->dstats = netdev_alloc_pcpu_stats(struct pcpu_dstats);
-	if (!dev->dstats)
+	dev->lstats = netdev_alloc_pcpu_stats(struct pcpu_lstats);
+	if (!dev->lstats)
 		return -ENOMEM;
 
 	return 0;
@@ -103,7 +77,7 @@ static int dummy_dev_init(struct net_device *dev)
 
 static void dummy_dev_uninit(struct net_device *dev)
 {
-	free_percpu(dev->dstats);
+	free_percpu(dev->lstats);
 }
 
 static int dummy_change_carrier(struct net_device *dev, bool new_carrier)
-- 
2.24.0.432.g9d3f5f5b63-goog

