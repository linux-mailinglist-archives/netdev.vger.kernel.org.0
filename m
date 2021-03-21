Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB4B3432D0
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 14:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhCUNtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 09:49:53 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:35954 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhCUNtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 09:49:32 -0400
Received: from tomoyo.flets-east.jp ([153.202.107.157])
        by mwinf5d13 with ME
        id j1oz240023PnFJp031pT0a; Sun, 21 Mar 2021 14:49:30 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sun, 21 Mar 2021 14:49:30 +0100
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
Subject: [PATCH v3 1/1] netdev: add netdev_queue_set_dql_min_limit()
Date:   Sun, 21 Mar 2021 22:48:49 +0900
Message-Id: <20210321134849.463560-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210321134849.463560-1-mailhol.vincent@wanadoo.fr>
References: <20210321134849.463560-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to set the dynamic queue limit minimum value.

Some specific drivers might have legitimate reasons to configure
dql.min_limit to a given value. Typically, this is the case when the
PDU of the protocol is smaller than the packet size to used to
carry those frames to the device.

Concrete example: a CAN (Control Area Network) device with an USB 2.0
interface.  The PDU of classical CAN protocol are roughly 16 bytes but
the USB packet size (which is used to carry the CAN frames to the
device) might be up to 512 bytes.  Wen small traffic burst occurs, BQL
algorithm is not able to immediately adjust and this would result in
having to send many small USB packets (i.e packet of 16 bytes for each
CAN frame). Filling up the USB packet with CAN frames is relatively
fast (small latency issue) but the gain of not having to send several
small USB packets is huge (big throughput increase). In this case,
forcing dql.min_limit to a given value that would allow to stuff the
USB packet is always a win.

This function is to be used by network drivers which are able to prove
through a rationale and through empirical tests on several environment
(with other applications, heavy context switching, virtualization...),
that they constantly reach better performances with a specific
predefined dql.min_limit value with no noticeable latency impact.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/linux/netdevice.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..c3511263b15a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3389,6 +3389,24 @@ netif_xmit_frozen_or_drv_stopped(const struct netdev_queue *dev_queue)
 	return dev_queue->state & QUEUE_STATE_DRV_XOFF_OR_FROZEN;
 }
 
+/**
+ *	netdev_queue_set_dql_min_limit - set dql minimum limit
+ *	@dev_queue: pointer to transmit queue
+ *	@min_limit: dql minimum limit
+ *
+ * Forces xmit_more() to return true until the minimum threshold
+ * defined by @min_limit is reached (or until the tx queue is
+ * empty). Warning: to be use with care, misuse will impact the
+ * latency.
+ */
+static inline void netdev_queue_set_dql_min_limit(struct netdev_queue *dev_queue,
+						  unsigned int min_limit)
+{
+#ifdef CONFIG_BQL
+	dev_queue->dql.min_limit = min_limit;
+#endif
+}
+
 /**
  *	netdev_txq_bql_enqueue_prefetchw - prefetch bql data for write
  *	@dev_queue: pointer to transmit queue
-- 
2.26.2

