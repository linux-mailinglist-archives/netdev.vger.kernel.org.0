Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DE7312035
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 22:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhBFVvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 16:51:07 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24552 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhBFVvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 16:51:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612648262; x=1644184262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VfcYpmFuPF4yFqZyhgxuIVPMYyl9jq6z/cTu1Ke0+uI=;
  b=W5y4IjoMbP56Ds2Ujt+xASTG8iKUjj9eIic2fIHNvl1uRuXxtQ17708f
   5KtKz06JUZGfjn7hh6iPIXTeP2rOmPOQ5QRNAhMhIKq95UwyTPavy4S66
   1iq0g+kpaZUOXumC7XiYjn4csyhZtH8TrhYPuZz3fO+Pu+SUUeh4s6Cza
   2p1m47JR8gEtCh5LS+aeJRqZs2FOGVtqEOBQSHrK/4OcDiQKvJlAH3/jQ
   Gba23hFwJTTkwsWtmiCHCMvAV9vfjr/VmnVHP3HgjvsUO51VBfqoSSiHz
   OZ4t6F9wQy4z9a1bHKZoiVkmSIK/iV70he/tZywwAOwQwdLaxWpJ9HT/P
   A==;
IronPort-SDR: /95oW1HPZvA/eV1Z5p+hK5Tgx0yC6UjWmv0f3cYnafdzNz07wPtxNeASFRALQv82EmEOZnxc02
 F9SbDvbBpjqXyw74unz+jAr7PKI9QL+XmK2nR/haAKuLw3LR31LA79K/IXw61cI0PhRT2weJC2
 av4yJ0pN2H/aCo8BCE6yfEenmT2i1LCoMlnScwPJnbR9sJWOQl+5ogrqi3ERWWkHQJM8v9z4Yt
 PDuxI2rx06cdEtmuq+i754MroSdbDWXaISI0ueKQy3cFA6l9HN8Zk7bXDFnX/02JCqEZ3V9hTT
 BKk=
X-IronPort-AV: E=Sophos;i="5.81,158,1610434800"; 
   d="scan'208";a="114093155"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2021 14:49:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 6 Feb 2021 14:49:46 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Sat, 6 Feb 2021 14:49:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 1/2] bridge: mrp: Fix the usage of br_mrp_port_switchdev_set_state
Date:   Sat, 6 Feb 2021 22:47:33 +0100
Message-ID: <20210206214734.1577849-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210206214734.1577849-1-horatiu.vultur@microchip.com>
References: <20210206214734.1577849-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function br_mrp_port_switchdev_set_state was called both with MRP
port state and STP port state, which is an issue because they don't
match exactly.

Therefore, update the function to be used only with STP port state and
use the id SWITCHDEV_ATTR_ID_PORT_STP_STATE.

The choice of using STP over MRP is that the drivers already implement
SWITCHDEV_ATTR_ID_PORT_STP_STATE and already in SW we update the port
STP state.

Fixes: 9a9f26e8f7ea30 ("bridge: mrp: Connect MRP API with the switchdev API")
Fixes: fadd409136f0f2 ("bridge: switchdev: mrp: Implement MRP API for switchdev")
Fixes: 2f1a11ae11d222 ("bridge: mrp: Add MRP interface.")
Reported-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c           | 9 ++++++---
 net/bridge/br_mrp_switchdev.c | 7 +++----
 net/bridge/br_private_mrp.h   | 3 +--
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index cec2c4e4561d..5aeae6ad17b3 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -557,19 +557,22 @@ int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance)
 int br_mrp_set_port_state(struct net_bridge_port *p,
 			  enum br_mrp_port_state_type state)
 {
+	u32 port_state;
+
 	if (!p || !(p->flags & BR_MRP_AWARE))
 		return -EINVAL;
 
 	spin_lock_bh(&p->br->lock);
 
 	if (state == BR_MRP_PORT_STATE_FORWARDING)
-		p->state = BR_STATE_FORWARDING;
+		port_state = BR_STATE_FORWARDING;
 	else
-		p->state = BR_STATE_BLOCKING;
+		port_state = BR_STATE_BLOCKING;
 
+	p->state = port_state;
 	spin_unlock_bh(&p->br->lock);
 
-	br_mrp_port_switchdev_set_state(p, state);
+	br_mrp_port_switchdev_set_state(p, port_state);
 
 	return 0;
 }
diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
index ed547e03ace1..75a7e8d0a268 100644
--- a/net/bridge/br_mrp_switchdev.c
+++ b/net/bridge/br_mrp_switchdev.c
@@ -169,13 +169,12 @@ int br_mrp_switchdev_send_in_test(struct net_bridge *br, struct br_mrp *mrp,
 	return err;
 }
 
-int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
-				    enum br_mrp_port_state_type state)
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p, u32 state)
 {
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
-		.id = SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
-		.u.mrp_port_state = state,
+		.id = SWITCHDEV_ATTR_ID_PORT_STP_STATE,
+		.u.stp_state = state,
 	};
 	int err;
 
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index 32a48e5418da..2514954c1431 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -72,8 +72,7 @@ int br_mrp_switchdev_set_ring_state(struct net_bridge *br, struct br_mrp *mrp,
 int br_mrp_switchdev_send_ring_test(struct net_bridge *br, struct br_mrp *mrp,
 				    u32 interval, u8 max_miss, u32 period,
 				    bool monitor);
-int br_mrp_port_switchdev_set_state(struct net_bridge_port *p,
-				    enum br_mrp_port_state_type state);
+int br_mrp_port_switchdev_set_state(struct net_bridge_port *p, u32 state);
 int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 				   enum br_mrp_port_role_type role);
 int br_mrp_switchdev_set_in_role(struct net_bridge *br, struct br_mrp *mrp,
-- 
2.27.0

