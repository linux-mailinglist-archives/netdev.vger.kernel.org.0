Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4693ED0C4
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhHPI72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:59:28 -0400
Received: from out2.migadu.com ([188.165.223.204]:59102 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235105AbhHPI7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 04:59:09 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629104288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/fHvrj6QnziHGweark6EjJmpxXLuqtNed4j0q6tsVjA=;
        b=XbKeo3zLiRUkEPxdD/A2OqQ8RiMtzkheOHwDWjq/fazPWb9JPRN7K+thsRL4vpQdY/g/7Y
        xJ1eUD0jcjX+8qu3mFOo0ueIbKCTwcE4yHMQjjcX0hsWLJnMA/Dtcjv3EfjjzFDY/czYPk
        rrrlwdANSkZFv0rjdfiuDGvFNGpjX54=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: procfs: add seq_puts() statement for dev_mcast
Date:   Mon, 16 Aug 2021 16:57:57 +0800
Message-Id: <20210816085757.28166-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add seq_puts() statement for dev_mcast, make it more readable.
As also, keep vertical alignment for {dev, ptype, dev_mcast} that
under /proc/net.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/net-procfs.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index d8b9dbabd4a4..eab5fc88a002 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -77,8 +77,8 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
 	struct rtnl_link_stats64 temp;
 	const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
 
-	seq_printf(seq, "%6s: %7llu %7llu %4llu %4llu %4llu %5llu %10llu %9llu "
-		   "%8llu %7llu %4llu %4llu %4llu %5llu %7llu %10llu\n",
+	seq_printf(seq, "%9s: %16llu %12llu %4llu %6llu %4llu %5llu %10llu %9llu "
+		   "%16llu %12llu %4llu %6llu %4llu %5llu %7llu %10llu\n",
 		   dev->name, stats->rx_bytes, stats->rx_packets,
 		   stats->rx_errors,
 		   stats->rx_dropped + stats->rx_missed_errors,
@@ -103,11 +103,11 @@ static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
 static int dev_seq_show(struct seq_file *seq, void *v)
 {
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "Inter-|   Receive                            "
-			      "                    |  Transmit\n"
-			      " face |bytes    packets errs drop fifo frame "
-			      "compressed multicast|bytes    packets errs "
-			      "drop fifo colls carrier compressed\n");
+		seq_puts(seq, "Interface|                            Receive                   "
+			      "                    |                                 Transmit\n"
+			      "         |            bytes      packets errs   drop fifo frame "
+			      "compressed multicast|            bytes      packets errs "
+			      "  drop fifo colls carrier compressed\n");
 	else
 		dev_seq_printf_stats(seq, v);
 	return 0;
@@ -259,14 +259,14 @@ static int ptype_seq_show(struct seq_file *seq, void *v)
 	struct packet_type *pt = v;
 
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "Type Device      Function\n");
+		seq_puts(seq, "Type      Device      Function\n");
 	else if (pt->dev == NULL || dev_net(pt->dev) == seq_file_net(seq)) {
 		if (pt->type == htons(ETH_P_ALL))
 			seq_puts(seq, "ALL ");
 		else
 			seq_printf(seq, "%04x", ntohs(pt->type));
 
-		seq_printf(seq, " %-8s %ps\n",
+		seq_printf(seq, "      %-9s   %ps\n",
 			   pt->dev ? pt->dev->name : "", pt->func);
 	}
 
@@ -327,12 +327,14 @@ static int dev_mc_seq_show(struct seq_file *seq, void *v)
 	struct netdev_hw_addr *ha;
 	struct net_device *dev = v;
 
-	if (v == SEQ_START_TOKEN)
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq, "Ifindex Interface Refcount Global_use Address\n");
 		return 0;
+	}
 
 	netif_addr_lock_bh(dev);
 	netdev_for_each_mc_addr(ha, dev) {
-		seq_printf(seq, "%-4d %-15s %-5d %-5d %*phN\n",
+		seq_printf(seq, "%-7d %-9s %-8d %-10d %*phN\n",
 			   dev->ifindex, dev->name,
 			   ha->refcount, ha->global_use,
 			   (int)dev->addr_len, ha->addr);
-- 
2.32.0

