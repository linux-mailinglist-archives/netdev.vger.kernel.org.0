Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DE33459D7
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhCWIfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:35:43 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62062 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhCWIfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 04:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616488538; x=1648024538;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9lxgTCKRb/dXejM+dtq7XdfnshCfyP/EiqkevaxcJeg=;
  b=la+h9dmkbJRiJYttmM9x2qiqRZqOKWfolWah80JYH8s/3MJz5wPD06Iy
   i6oC0KKJbDL9aPJcfR7seU540GB3gAP0R5ZvT85pAAghKZehS+BwyAqut
   bU1PNPuwLLOX6KBa2W8MKQN/B5vLguAyd6P1G70wML3qEsLBqWvsy3bNV
   oJwkECr1YB5VOFNuGlisnZxwaVU7dvwvT4Js5Mx3/YqRclNszIUQTkolw
   dn3pSGRT/CScV7X9XwYK3hS+SZETL9PCbNrHWDBUYd9D/MlTdacQeqpq8
   jw3uZw+6lV3ZV3lVA9eAE0tMTIj2V7iuKYqJ5LOeeI7tPKujRUybXAW3C
   w==;
IronPort-SDR: 8dyTKFYqqY3KjC9tnK/tpkWhd6yRDjFuKIF+fU34EY1QNDJfhc27pPJpNpK5jhol+KlyVmK3Tr
 N659v615CFxBCEzcxupmwEcyg8pWF76Obfcke9lvKkbEfqwbQ02ZtPmiqB0qenDGNA4RXorOT8
 QrYaeSndgU/n6HTEPM7z8yzxiTKjGN2+CcOry52+NueIE9VWvDZ2dkCp8XGOwJB29e335p6+E4
 SS+PEGWCHS5/4iwByLjQLxHvWVZIOeMhZiF1dPSGhypNbR9s2rz9LvAZMYqTLXK7b9pgIrbZG/
 PxA=
X-IronPort-AV: E=Sophos;i="5.81,271,1610434800"; 
   d="scan'208";a="120052714"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2021 01:35:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 23 Mar 2021 01:35:37 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 23 Mar 2021 01:35:35 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <vladimir.oltean@nxp.com>,
        <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/2] bridge: mrp: Disable roles before deleting the MRP instance
Date:   Tue, 23 Mar 2021 09:33:46 +0100
Message-ID: <20210323083347.1474883-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210323083347.1474883-1-horatiu.vultur@microchip.com>
References: <20210323083347.1474883-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an MRP instance was created, the driver was notified that the
instance is created and then in a different callback about role of the
instance. But when the instance was deleted the driver was notified only
that the MRP instance is deleted and not also that the role is disabled.

This patch make sure that the driver is notified that the role is
changed to disabled before the MRP instance is deleted to have similar
callbacks with the creating of the instance. In this way it would
simplify the logic in the drivers.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index 12487f6fe9b4..cd2b1e424e54 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -411,6 +411,13 @@ static void br_mrp_del_impl(struct net_bridge *br, struct br_mrp *mrp)
 	cancel_delayed_work_sync(&mrp->in_test_work);
 	br_mrp_switchdev_send_in_test(br, mrp, 0, 0, 0);
 
+	/* Disable the roles */
+	br_mrp_switchdev_set_ring_role(br, mrp, BR_MRP_RING_ROLE_DISABLED);
+	p = rtnl_dereference(mrp->i_port);
+	if (p)
+		br_mrp_switchdev_set_in_role(br, mrp, mrp->in_id, mrp->ring_id,
+					     BR_MRP_IN_ROLE_DISABLED);
+
 	br_mrp_switchdev_del(br, mrp);
 
 	/* Reset the ports */
-- 
2.30.1

