Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAF798B54
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 08:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbfHVGWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 02:22:48 -0400
Received: from mx56.baidu.com ([61.135.168.56]:19779 "EHLO
        tc-sys-mailedm04.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731098AbfHVGWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 02:22:47 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id E476F236C00B;
        Thu, 22 Aug 2019 14:22:32 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, idosch@mellanox.com
Subject: [PATCH][net-next] net: drop_monitor: change the stats variable to u64 in net_dm_stats_put
Date:   Thu, 22 Aug 2019 14:22:33 +0800
Message-Id: <1566454953-29321-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

only the element drop of struct net_dm_stats is used, so simplify it to u64

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/core/drop_monitor.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index bfc024024aa3..ed10a40cf629 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1329,11 +1329,11 @@ static int net_dm_cmd_config_get(struct sk_buff *skb, struct genl_info *info)
 	return rc;
 }
 
-static void net_dm_stats_read(struct net_dm_stats *stats)
+static void net_dm_stats_read(u64 *stats)
 {
 	int cpu;
 
-	memset(stats, 0, sizeof(*stats));
+	*stats = 0;
 	for_each_possible_cpu(cpu) {
 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
 		struct net_dm_stats *cpu_stats = &data->stats;
@@ -1345,14 +1345,14 @@ static void net_dm_stats_read(struct net_dm_stats *stats)
 			dropped = cpu_stats->dropped;
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
-		stats->dropped += dropped;
+		*stats += dropped;
 	}
 }
 
 static int net_dm_stats_put(struct sk_buff *msg)
 {
-	struct net_dm_stats stats;
 	struct nlattr *attr;
+	u64 stats;
 
 	net_dm_stats_read(&stats);
 
@@ -1361,7 +1361,7 @@ static int net_dm_stats_put(struct sk_buff *msg)
 		return -EMSGSIZE;
 
 	if (nla_put_u64_64bit(msg, NET_DM_ATTR_STATS_DROPPED,
-			      stats.dropped, NET_DM_ATTR_PAD))
+			      stats, NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, attr);
-- 
2.16.2

