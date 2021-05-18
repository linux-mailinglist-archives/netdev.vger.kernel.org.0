Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CB03881DC
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 23:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352401AbhERVKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 17:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352364AbhERVKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 17:10:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621372157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V9gVBAPRX5DhRtI6vP4WZYcb3SfeyZ7GrIMEVvYHEpI=;
        b=h1YFYnZy4AMjc2ICdLCn5fhRG8tDFihPcqBKUBnJvXuMl6+X9taSqsN2DG9b6GotBt8buX
        UNd81xyhasZCe1qlI7tZ7bCx64Jlolys+THZ2Gv6vwJypAXeFv8i96uCPVZkh5SqqBwYh9
        QuuKcl39+4m2Nx1eGUcfOt+xe8T8lOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-qN96nNgmPaWsUCsrpB7XZw-1; Tue, 18 May 2021 17:09:15 -0400
X-MC-Unique: qN96nNgmPaWsUCsrpB7XZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1568106BAA6;
        Tue, 18 May 2021 21:09:13 +0000 (UTC)
Received: from f33vm.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A8CC5C1A1;
        Tue, 18 May 2021 21:09:12 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH 2/4] bond_alb: don't rewrite bridged non-local MACs
Date:   Tue, 18 May 2021 17:08:47 -0400
Message-Id: <20210518210849.1673577-3-jarod@redhat.com>
In-Reply-To: <20210518210849.1673577-1-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a virtual machine behind a bridge on top of a bond, outgoing traffic
should retain the VM's source MAC. That works fine most of the time, until
doing a failover, and then the MAC gets rewritten to the bond slave's MAC,
and the return traffic gets dropped. If we don't rewrite the MAC there, we
don't lose any traffic.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_alb.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 3455f2cc13f2..ce8257c7cbea 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1302,6 +1302,26 @@ void bond_alb_deinitialize(struct bonding *bond)
 		rlb_deinitialize(bond);
 }
 
+static bool bond_alb_bridged_mac(struct bonding *bond, struct ethhdr *eth_data)
+{
+	struct list_head *iter;
+	struct slave *slave;
+
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
@@ -1316,7 +1336,8 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
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

