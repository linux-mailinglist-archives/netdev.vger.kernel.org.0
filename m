Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADC738C806
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhEUN3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:29:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235381AbhEUN3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621603694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NNa7qEqodhRAjAVhRpjE3XFrfRWQy/rLFkgFPKFgziA=;
        b=COi8kY0q8cmyQNdQDhyNM3gNAPZ1eQG3rcsROjjDNtIM/YqXCiN3mbBK4KdOrzbDpmalEj
        LKLDp7uQ1ZKFhQUoGFnH3g6j+oVr+XeVPreq/XqejElscUSZ1QWMuhLQFHGptByPiLxe3N
        ENQ+9rNNckkjJjT4/5cuYFFJoeubWT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-ll-jXCJeNT28KBTesX7a7A-1; Fri, 21 May 2021 09:28:11 -0400
X-MC-Unique: ll-jXCJeNT28KBTesX7a7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2450B801B20;
        Fri, 21 May 2021 13:28:10 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B16DB100AE43;
        Fri, 21 May 2021 13:28:08 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/4] bonding/balance-lb: don't rewrite bridged non-local MACs
Date:   Fri, 21 May 2021 09:27:54 -0400
Message-Id: <20210521132756.1811620-3-jarod@redhat.com>
In-Reply-To: <20210521132756.1811620-1-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com>
 <20210521132756.1811620-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a virtual machine behind a bridge that directly incorporates a
balance-alb bond as one of its ports, outgoing traffic should retain the
VM's source MAC. That works fine most of the time, until doing a failover,
and then the MAC gets rewritten to the bond slave's MAC, and the return
traffic gets dropped. If we don't rewrite the MAC there, we don't lose the
traffic.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_alb.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 3455f2cc13f2..c57f62e43328 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1302,6 +1302,23 @@ void bond_alb_deinitialize(struct bonding *bond)
 		rlb_deinitialize(bond);
 }
 
+static bool bond_alb_bridged_mac(struct bonding *bond, struct ethhdr *eth_data)
+{
+	if (BOND_MODE(bond) != BOND_MODE_ALB)
+		return false;
+
+	/* Don't modify source MACs that do not originate locally
+	 * (e.g.,arrive via a bridge).
+	 */
+	if (!netif_is_bridge_port(bond->dev))
+		return false;
+
+	if (bond_slave_has_mac_rx(bond, eth_data->h_source))
+		return false;
+
+	return true;
+}
+
 static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 				    struct slave *tx_slave)
 {
@@ -1316,7 +1333,8 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 	}
 
 	if (tx_slave && bond_slave_can_tx(tx_slave)) {
-		if (tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
+		if (tx_slave != rcu_access_pointer(bond->curr_active_slave) &&
+		    !bond_alb_bridged_mac(bond, eth_data)) {
 			ether_addr_copy(eth_data->h_source,
 					tx_slave->dev->dev_addr);
 		}
-- 
2.30.2

