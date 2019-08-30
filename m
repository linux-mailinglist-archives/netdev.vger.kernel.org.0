Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2EDA2EBA
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 07:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfH3FHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 01:07:55 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:23800 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfH3FHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 01:07:54 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E03B5416E7;
        Fri, 30 Aug 2019 13:07:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     sridhar.samudrala@intel.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net-next] net_failover: get rid of the limitaion receive packet from standy dev when primary exist
Date:   Fri, 30 Aug 2019 13:07:48 +0800
Message-Id: <1567141668-12196-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVCQk9CQkJDQ05OTkJLQ1lXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Phg6Fww*Izg*CzIQIg8XDg5W
        KSMaCS5VSlVKTk1MSk9KTU1DQk1MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpCTUk3Bg++
X-HM-Tid: 0a6ce0ec28422086kuqye03b5416e7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

For receive side the standby, primary and failover is the same one,
If the packet receive from standby or primary should can be deliver
to failover dev.

For example: there are VF and virtio device failover together.
When live migration the VF detached and send/recv packet through
virtio device. When VF attached again some ingress traffic may
receive from virtio device for cache reason(TC flower offload in
sw mode).

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/net_failover.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index b16a122..da3beb5 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -362,14 +362,6 @@ static rx_handler_result_t net_failover_handle_frame(struct sk_buff **pskb)
 {
 	struct sk_buff *skb = *pskb;
 	struct net_device *dev = rcu_dereference(skb->dev->rx_handler_data);
-	struct net_failover_info *nfo_info = netdev_priv(dev);
-	struct net_device *primary_dev, *standby_dev;
-
-	primary_dev = rcu_dereference(nfo_info->primary_dev);
-	standby_dev = rcu_dereference(nfo_info->standby_dev);
-
-	if (primary_dev && skb->dev == standby_dev)
-		return RX_HANDLER_EXACT;
 
 	skb->dev = dev;
 
-- 
1.8.3.1

