Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA593342C3
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhCJQLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:11:39 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:55054 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbhCJQLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:11:24 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d63 with ME
        id egAx2400D3PnFJp03gBFtw; Wed, 10 Mar 2021 17:11:20 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Wed, 10 Mar 2021 17:11:20 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dave Taht <dave.taht@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v2 1/1] netdev: add netdev_queue_set_dql_min_limit()
Date:   Thu, 11 Mar 2021 01:10:51 +0900
Message-Id: <20210310161051.23826-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210310161051.23826-1-mailhol.vincent@wanadoo.fr>
References: <20210310161051.23826-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to set the dynamic queue limit minimum value.

This function is to be used by network drivers which are able to
prove, at least through empirical tests on several environment (with
other applications, heavy context switching, virtualization...), that
they constantly reach better performances with a specific predefined
dql.min_limit value with no noticeable latency impact.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---

 include/linux/netdevice.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..7fceea9a202d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3389,6 +3389,23 @@ netif_xmit_frozen_or_drv_stopped(const struct netdev_queue *dev_queue)
 	return dev_queue->state & QUEUE_STATE_DRV_XOFF_OR_FROZEN;
 }
 
+/**
+ *	netdev_queue_set_dql_min_limit - set dql minimum limit
+ *	@dev_queue: pointer to transmit queue
+ *	@min_limit: dql minimum limit
+ *
+ * Forces xmit_more() to return true until the minimum threshold
+ * defined by @min_limit is reached. Warning: to be use with care,
+ * misuse will impact the latency.
+ */
+static inline void netdev_queue_set_dql_min_limit(struct netdev_queue *q,
+						  unsigned int min_limit)
+{
+#ifdef CONFIG_BQL
+	q->dql.min_limit = min_limit;
+#endif
+}
+
 /**
  *	netdev_txq_bql_enqueue_prefetchw - prefetch bql data for write
  *	@dev_queue: pointer to transmit queue
-- 
2.26.2

