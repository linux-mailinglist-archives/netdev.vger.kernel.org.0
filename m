Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA8D1909A4
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 10:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCXJjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 05:39:54 -0400
Received: from lucky1.263xmail.com ([211.157.147.135]:38112 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgCXJjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 05:39:53 -0400
Received: from localhost (unknown [192.168.167.8])
        by lucky1.263xmail.com (Postfix) with ESMTP id 91F036BAB9;
        Tue, 24 Mar 2020 17:39:39 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-ABS-CHECKED: 0
Received: from localhost.localdomain (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P24779T140190699988736S1585042779131734_;
        Tue, 24 Mar 2020 17:39:40 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <a8ee4db150f5d38a10bd87c08b314e4e>
X-RL-SENDER: david.wu@rock-chips.com
X-SENDER: wdc@rock-chips.com
X-LOGIN-NAME: david.wu@rock-chips.com
X-FST-TO: netdev@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
X-System-Flag: 0
From:   David Wu <david.wu@rock-chips.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, joabreu@synopsys.com,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        linux-kernel@vger.kernel.org, David Wu <david.wu@rock-chips.com>
Subject: [RFC,PATCH 1/2] netdevice: Add netif_tx_lock_q
Date:   Tue, 24 Mar 2020 17:38:27 +0800
Message-Id: <20200324093828.30019-1-david.wu@rock-chips.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is similar to netif_tx_lock, but only locks one queue,
so it seems to be suitable for multiple queues.

If the current queue status is frozen, it will requeue skb,
which will not block the current thread, it improve performance
when tested.

Signed-off-by: David Wu <david.wu@rock-chips.com>
---
 include/linux/netdevice.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b6fedd54cd8e..30054a94210e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4085,6 +4085,16 @@ static inline void netif_tx_lock(struct net_device *dev)
 	}
 }
 
+static inline void netif_tx_lock_q(struct netdev_queue *txq)
+{
+	int cpu;
+
+	cpu = smp_processor_id();
+	__netif_tx_lock(txq, cpu);
+	set_bit(__QUEUE_STATE_FROZEN, &txq->state);
+	__netif_tx_unlock(txq);
+}
+
 static inline void netif_tx_lock_bh(struct net_device *dev)
 {
 	local_bh_disable();
@@ -4108,6 +4118,12 @@ static inline void netif_tx_unlock(struct net_device *dev)
 	spin_unlock(&dev->tx_global_lock);
 }
 
+static inline void netif_tx_unlock_q(struct netdev_queue *txq)
+{
+	clear_bit(__QUEUE_STATE_FROZEN, &txq->state);
+	netif_schedule_queue(txq);
+}
+
 static inline void netif_tx_unlock_bh(struct net_device *dev)
 {
 	netif_tx_unlock(dev);
-- 
2.19.1



