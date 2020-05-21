Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD71DD964
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgEUVVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:21:44 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:23104 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1590096102; x=1621632102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=47pxhHidMagDsJh1CuDJK9uMkQt6nuknQvYrfb2Oqjw=;
  b=EYBHVED3+TR7fMwzkl3pcfhrLTOGgAf5DGzOsAyVGTb/K31R4UUFgQEr
   dqh4ot3vH4WeXAKpgXmnNRwDkgpdTCGlEgAK8xC8+vPSwjrSZV2grIZG0
   R9m7hMytvUh4Ant+P1CeFL65AwFGFDH6Rz8arObaUCegWaWFpJEkJsNK8
   UvtyUp0nSbcvaGh+2asVB8/t2mZu03IfS/2aM4Ckx1wA0BnEvc9NBtATG
   +uLhQuqHvsgxoohv74qHy2MuTnLSasRKqMFZPRAK8AXfCnx+eCmpbJ5ZZ
   /7pJLaZKm+JpZ5Z6AvU7e0fDJaB2oRoAYJNvo0OScp7BXFZWZWbinAR7T
   w==;
IronPort-SDR: iCMQPDyRebV5U/K3oKjjLG89gIKihHN5BWkP86pjR+C6a2KYK395LyIjP1NeKX2YoUoCI8XGcN
 IJmPMCE7C9vEU+5/DUh/3bWdQOCXCjC/iTg8sdob69YGJ87ZgcnPVRaULalsoEDWpFosUl5SNU
 /YnqmK02ZEVSz5oU+qJlo+d4Tf4B0txehGAuMH5mLuQ1XMHDOFUFPuANlhbJbxgKAb9z2XsBJJ
 CpGyCRWzWg++7iYOu+Be1dW77qEMUnJve5HHxPeWiI54fDb1srbDeKsy9tA6nZ7BAO64P+G7x9
 P4E=
X-IronPort-AV: E=Sophos;i="5.73,419,1583218800"; 
   d="scan'208";a="80597512"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 May 2020 14:21:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 May 2020 14:21:38 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Thu, 21 May 2020 14:21:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <nikolay@cumulusnetworks.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 3/3] bridge: mrp: Restore port state when deleting MRP instance
Date:   Thu, 21 May 2020 23:19:07 +0000
Message-ID: <20200521231907.3564679-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521231907.3564679-1-horatiu.vultur@microchip.com>
References: <20200521231907.3564679-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a MRP instance is deleted, then restore the port according to the
bridge state. If the bridge is up then the ports will be in forwarding
state otherwise will be in disabled state.

Fixes: 9a9f26e8f7ea ("bridge: mrp: Connect MRP API with the switchdev API")
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index 854e31bf0151e..528d767eb026f 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -223,6 +223,7 @@ static void br_mrp_test_work_expired(struct work_struct *work)
 static void br_mrp_del_impl(struct net_bridge *br, struct br_mrp *mrp)
 {
 	struct net_bridge_port *p;
+	u8 state;
 
 	/* Stop sending MRP_Test frames */
 	cancel_delayed_work_sync(&mrp->test_work);
@@ -234,20 +235,24 @@ static void br_mrp_del_impl(struct net_bridge *br, struct br_mrp *mrp)
 	p = rtnl_dereference(mrp->p_port);
 	if (p) {
 		spin_lock_bh(&br->lock);
-		p->state = BR_STATE_FORWARDING;
+		state = netif_running(br->dev) ?
+				BR_STATE_FORWARDING : BR_STATE_DISABLED;
+		p->state = state;
 		p->flags &= ~BR_MRP_AWARE;
 		spin_unlock_bh(&br->lock);
-		br_mrp_port_switchdev_set_state(p, BR_STATE_FORWARDING);
+		br_mrp_port_switchdev_set_state(p, state);
 		rcu_assign_pointer(mrp->p_port, NULL);
 	}
 
 	p = rtnl_dereference(mrp->s_port);
 	if (p) {
 		spin_lock_bh(&br->lock);
-		p->state = BR_STATE_FORWARDING;
+		state = netif_running(br->dev) ?
+				BR_STATE_FORWARDING : BR_STATE_DISABLED;
+		p->state = state;
 		p->flags &= ~BR_MRP_AWARE;
 		spin_unlock_bh(&br->lock);
-		br_mrp_port_switchdev_set_state(p, BR_STATE_FORWARDING);
+		br_mrp_port_switchdev_set_state(p, state);
 		rcu_assign_pointer(mrp->s_port, NULL);
 	}
 
-- 
2.26.2

