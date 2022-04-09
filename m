Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBDC4FAA30
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 20:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243047AbiDISl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 14:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243020AbiDISlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 14:41:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97FB29DDE8;
        Sat,  9 Apr 2022 11:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649529543; x=1681065543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QK6ETVxdtMN8EKUk1u/Qd2UL8bf4DyLxDzflRN7eG9A=;
  b=H0v8Qa/PeBNgDS+wuff7T3U3rHX4dXbxkf2+n4MgG8ldo0asnfBVHMw3
   5Zrr6p6amIlasvcwE9a796WwsfBbmwfkMFtwIBQHuYXxIKNyvounOfPfJ
   WmUb7XBGRD0sfI/auWh7zFPW69KYC7n+kUW1rfIgbVGmJZ7KK5M7PB+D1
   tTbJPOzQwnfdnRUcO6B0CB/YpRX2LedOfh1ns2d36cM/N2juHP5lUVE0x
   S/9V+HbTYNdAvovFQkYbSZUEm/IbO6Eq/lCjBe5PVVJjHvaN927UDGusv
   7/XXbeszGSr6l+N/8R3gRZSqYAfo8EuqvxuI4SIE24bKKX7tX6gxDuQbS
   w==;
X-IronPort-AV: E=Sophos;i="5.90,248,1643698800"; 
   d="scan'208";a="169060533"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Apr 2022 11:39:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 9 Apr 2022 11:39:03 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 9 Apr 2022 11:39:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 3/4] net: lan966x: Fix when a port's upper is changed.
Date:   Sat, 9 Apr 2022 20:41:42 +0200
Message-ID: <20220409184143.1204786-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220409184143.1204786-1-horatiu.vultur@microchip.com>
References: <20220409184143.1204786-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On lan966x it is not allowed to have foreign interfaces under a bridge
which already contains lan966x ports. So when a port leaves the bridge
it would call switchdev_bridge_port_unoffload which eventually will
notify the other ports that bridge left the vlan group but that is not
true because the bridge is still part of the vlan group.

Therefore when a port leaves the bridge, stop generating replays because
already the HW cleared after itself and the other ports don't need to do
anything else.

Fixes: cf2f60897e921e ("net: lan966x: Add support to offload the forwarding.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index e3555c94294d..df2bee678559 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -322,8 +322,7 @@ static int lan966x_port_prechangeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		switchdev_bridge_port_unoffload(port->dev, port,
-						&lan966x_switchdev_nb,
-						&lan966x_switchdev_blocking_nb);
+						NULL, NULL);
 
 	return NOTIFY_DONE;
 }
-- 
2.33.0

