Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBB1523AE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 08:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbfFYGmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 02:42:12 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:41853 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbfFYGmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 02:42:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04391;MF=zhiyuan2048@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0TV90xp4_1561444928;
Received: from localhost(mailfrom:zhiyuan2048@linux.alibaba.com fp:SMTPD_---0TV90xp4_1561444928)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 Jun 2019 14:42:08 +0800
From:   Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
To:     zhiyuan2048@linux.alibaba.com, davem@davemloft.net,
        idosch@mellanox.com, daniel@iogearbox.net, petrm@mellanox.com,
        jiri@mellanox.com, tglx@linutronix.de, linmiaohe@huawei.com
Cc:     zhabin@linux.alibaba.com, caspar@linux.alibaba.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipvlan: forward ingress packet to slave's l2 in l3s mode
Date:   Tue, 25 Jun 2019 14:42:08 +0800
Message-Id: <20190625064208.2256-1-zhiyuan2048@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipvlan l3s mode,  ingress packet is switched to slave interface and
delivers to l4 stack. This may cause two problems:

  1. When slave is in an ns different from master, the behavior of stack
  in slave ns may cause confusion for users. For example, iptables, tc,
  and other l2/l3 functions are not available for ingress packet.

  2. l3s mode is not used for tap device, and cannot support ipvtap. But
  in VM or container based VM cases, tap device is a very common device.

In l3s mode's input nf_hook, this patch calles the skb_forward_dev() to
forward ingress packet to slave and uses nf_conntrack_confirm() to make
conntrack work with new mode.

Signed-off-by: Zha Bin <zhabin@linux.alibaba.com>
Signed-off-by: Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
---
 drivers/net/ipvlan/ipvlan.h     |  9 ++++++++-
 drivers/net/ipvlan/ipvlan_l3s.c | 16 ++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
index 3837c897832e..48c814e24c3f 100644
--- a/drivers/net/ipvlan/ipvlan.h
+++ b/drivers/net/ipvlan/ipvlan.h
@@ -172,6 +172,14 @@ void ipvlan_link_delete(struct net_device *dev, struct list_head *head);
 void ipvlan_link_setup(struct net_device *dev);
 int ipvlan_link_register(struct rtnl_link_ops *ops);
 #ifdef CONFIG_IPVLAN_L3S
+
+#include <net/netfilter/nf_conntrack_core.h>
+
+static inline int ipvlan_confirm_conntrack(struct sk_buff *skb)
+{
+	return nf_conntrack_confirm(skb);
+}
+
 int ipvlan_l3s_register(struct ipvl_port *port);
 void ipvlan_l3s_unregister(struct ipvl_port *port);
 void ipvlan_migrate_l3s_hook(struct net *oldnet, struct net *newnet);
@@ -206,5 +214,4 @@ static inline bool netif_is_ipvlan_port(const struct net_device *dev)
 {
 	return rcu_access_pointer(dev->rx_handler) == ipvlan_handle_frame;
 }
-
 #endif /* __IPVLAN_H */
diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 943d26cbf39f..ed210002f593 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -95,14 +95,26 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 {
 	struct ipvl_addr *addr;
 	unsigned int len;
+	int ret = NF_ACCEPT;
+	bool success;
 
 	addr = ipvlan_skb_to_addr(skb, skb->dev);
 	if (!addr)
 		goto out;
 
-	skb->dev = addr->master->dev;
 	len = skb->len + ETH_HLEN;
-	ipvlan_count_rx(addr->master, len, true, false);
+
+	ret = ipvlan_confirm_conntrack(skb);
+	if (ret != NF_ACCEPT) {
+		ipvlan_count_rx(addr->master, len, false, false);
+		goto out;
+	}
+
+	skb_push_rcsum(skb, ETH_HLEN);
+	success = dev_forward_skb(addr->master->dev, skb) == NET_RX_SUCCESS;
+	ipvlan_count_rx(addr->master, len, success, false);
+	return NF_STOLEN;
+
 out:
 	return NF_ACCEPT;
 }
-- 
2.18.0

