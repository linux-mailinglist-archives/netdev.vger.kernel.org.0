Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D400235150
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 10:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgHAI7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 04:59:19 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:47861 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbgHAI7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 04:59:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0U4O6FF._1596272349;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0U4O6FF._1596272349)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 01 Aug 2020 16:59:15 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc:     Xunlei Pang <xlpang@linux.alibaba.com>,
        Caspar Zhang <caspar@linux.alibaba.com>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: core: explicitly call linkwatch_fire_event to speed up the startup of network services
Date:   Sat,  1 Aug 2020 16:58:45 +0800
Message-Id: <20200801085845.20153-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The linkwatch_event work queue runs up to one second later.
When the MicroVM starts, it takes 300+ms for the ethX flag
to change from '+UP +LOWER_UP' to '+RUNNING', as follows:
Jul 20 22:00:47.432552 systemd-networkd[210]: eth0: bringing link up
...
Jul 20 22:00:47.446108 systemd-networkd[210]: eth0: flags change: +UP +LOWER_UP
...
Jul 20 22:00:47.781463 systemd-networkd[210]: eth0: flags change: +RUNNING

Let's manually trigger it here to make the network service start faster.

After applying this patch, the time consumption of
systemd-networkd.service was reduced from 366ms to 50ms.

Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/core/link_watch.c | 3 +++
 net/core/rtnetlink.c  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 75431ca..6b9d44b 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -98,6 +98,9 @@ static bool linkwatch_urgent_event(struct net_device *dev)
 	if (netif_is_lag_port(dev) || netif_is_lag_master(dev))
 		return true;
 
+	if ((dev->flags & IFF_UP) && dev->operstate == IF_OPER_DOWN)
+		return true;
+
 	return netif_carrier_ok(dev) &&	qdisc_tx_changing(dev);
 }
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 58c484a..fd0b3b6 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2604,6 +2604,7 @@ static int do_setlink(const struct sk_buff *skb,
 				       extack);
 		if (err < 0)
 			goto errout;
+		linkwatch_fire_event(dev);
 	}
 
 	if (tb[IFLA_MASTER]) {
-- 
1.8.3.1

