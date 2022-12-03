Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC36F6414EA
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 09:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiLCIMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 03:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLCIMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 03:12:15 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E153115730;
        Sat,  3 Dec 2022 00:12:12 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NPMwp4Gt0z4y0v8;
        Sat,  3 Dec 2022 16:12:10 +0800 (CST)
Received: from szxlzmapp01.zte.com.cn ([10.5.231.85])
        by mse-fl1.zte.com.cn with SMTP id 2B38C3OV026108;
        Sat, 3 Dec 2022 16:12:03 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Sat, 3 Dec 2022 16:12:05 +0800 (CST)
Date:   Sat, 3 Dec 2022 16:12:05 +0800 (CST)
X-Zmail-TransId: 2b04638b04d5ffffffffba98b1a0
X-Mailer: Zmail v1.0
Message-ID: <202212031612057505056@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>
Cc:     <pabeni@redhat.com>, <bigeasy@linutronix.de>,
        <imagedong@tencent.com>, <kuniyu@amazon.com>, <petrm@nvidia.com>,
        <liu3101@purdue.edu>, <wujianguo@chinatelecom.cn>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIG5ldDogcmVjb3JkIHRpbWVzIG9mIG5ldGRldl9idWRnZXQgZXhoYXVzdGVk?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2B38C3OV026108
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 638B04DA.000 by FangMail milter!
X-FangMail-Envelope: 1670055130/4NPMwp4Gt0z4y0v8/638B04DA.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 638B04DA.000/4NPMwp4Gt0z4y0v8
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yang <yang.yang29@zte.com>

A long time ago time_squeeze was used to only record netdev_budget
exhausted[1]. Then we added netdev_budget_usecs to enable softirq
tuning[2]. And when polling elapsed netdev_budget_usecs, it's also
record by time_squeeze.
For tuning netdev_budget and netdev_budget_usecs respectively, we'd
better distinguish netdev_budget exhausted from netdev_budget_usecs
elapsed, so add a new recorder to record netdev_budget exhausted.

[1] commit 1da177e4c3f4("Linux-2.6.12-rc2")
[2] commit 7acf8a1e8a28("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")

Signed-off-by: Yang Yang <yang.yang29@zte.com>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 11 +++++++----
 net/core/net-procfs.c     |  5 +++--
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5aa35c58c342..a77719b956a6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3135,6 +3135,7 @@ struct softnet_data {
 	/* stats */
 	unsigned int		processed;
 	unsigned int		time_squeeze;
+	unsigned int		budget_exhaust;
 #ifdef CONFIG_RPS
 	struct softnet_data	*rps_ipi_list;
 #endif
diff --git a/net/core/dev.c b/net/core/dev.c
index 7627c475d991..42ae2dc62661 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6663,11 +6663,14 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 		budget -= napi_poll(n, &repoll);

 		/* If softirq window is exhausted then punt.
-		 * Allow this to run for 2 jiffies since which will allow
-		 * an average latency of 1.5/HZ.
+		 * The window is controlled by time and packet budget.
+		 * See Documentation/admin-guide/sysctl/net.rst for details.
 		 */
-		if (unlikely(budget <= 0 ||
-			     time_after_eq(jiffies, time_limit))) {
+		if (unlikely(budget <= 0)) {
+			sd->budget_exhaust++;
+			break;
+		}
+		if (unlikely(time_after_eq(jiffies, time_limit))) {
 			sd->time_squeeze++;
 			break;
 		}
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 1ec23bf8b05c..e09e245125f0 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -169,12 +169,13 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	 * mapping the data a specific CPU
 	 */
 	seq_printf(seq,
-		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x\n",
+		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x\n",
 		   sd->processed, sd->dropped, sd->time_squeeze, 0,
 		   0, 0, 0, 0, /* was fastroute */
 		   0,	/* was cpu_collision */
 		   sd->received_rps, flow_limit_count,
-		   softnet_backlog_len(sd), (int)seq->index);
+		   softnet_backlog_len(sd), (int)seq->index
+		   sd->budget_exhaust);
 	return 0;
 }

-- 
2.15.2
