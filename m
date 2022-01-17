Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BB6490906
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 13:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiAQMv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 07:51:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22406 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiAQMv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 07:51:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1642423888; x=1673959888;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i1l6PflMs0l94SJRa8OPWqA85z8skU0zFsppmUcRFmU=;
  b=cqHKwMPrCspQfjOIHAPAwpSrvzSUJHroS8AlPiobFfwexOUfYBY5pFVV
   n95iW78p6W8rjnb4jusCM3GLcvVBHFd+YCVkRxsE26vRcNZjZrDiKO2wJ
   GKLNxdJTpysbw4JGmj9DPstV84Fs2kAObFsol+y6Wb/PTjpQk6j233vKx
   CxzjlgIMGrKCTTRs+y0NfEaLDg04q23eag+8sVP3SBPBHTvCt/V0UfC0O
   CNs/8Jh2R4PMzJk96/N65HA+Ni1pdO3CwmUupqdjxJApd+mRGHy6pDk2H
   c4++91SDn4SDLmuYsMHKXzznHTpv0B05pxNiAU7ig3UGesGoL/BbFOZeI
   g==;
IronPort-SDR: yOYB4IYh7rdLjhOb2MzZPtDnF3AVGOw2EEYGvt65r8YJy29+ET3UlHVK8uStMTY2k07sPo0J48
 l6FzoqHmE827i93CwbNmlpMpTm06g1CHuwwnyZ/aqiKO1klLEbzACoiasQzPYFu6YR+NHascFL
 414lBUyIetrkSHX/KcAeUOnUPZk3Q0siooByKOqTL+JqKT8UJ2oFolxKRQbBZGqFRiz9hdPQCn
 wYEbjC11UpRxfeiH9EVin0UuLYldyh0RIrhugVBbVrf4SNyZKgP8/VzOrGNy6BFCjTlCMVyBHZ
 Tb02FwyhR1f+10KKK/eEkG7e
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="149877801"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2022 05:51:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 17 Jan 2022 05:51:18 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 17 Jan 2022 05:51:16 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: ocelot: Fix the call to switchdev_bridge_port_offload
Date:   Mon, 17 Jan 2022 13:53:00 +0100
Message-ID: <20220117125300.2399394-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the blamed commit, the call to the function
switchdev_bridge_port_offload was passing the wrong argument for
atomic_nb. It was ocelot_netdevice_nb instead of ocelot_swtchdev_nb.
This patch fixes this issue.

Fixes: 4e51bf44a03af6 ("net: bridge: move the switchdev object replay helpers to "push" mode")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 8115c3db252e..e271b6225b72 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1187,7 +1187,7 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	ocelot_port_bridge_join(ocelot, port, bridge);
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, priv,
-					    &ocelot_netdevice_nb,
+					    &ocelot_switchdev_nb,
 					    &ocelot_switchdev_blocking_nb,
 					    false, extack);
 	if (err)
@@ -1201,7 +1201,7 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 
 err_switchdev_sync:
 	switchdev_bridge_port_unoffload(brport_dev, priv,
-					&ocelot_netdevice_nb,
+					&ocelot_switchdev_nb,
 					&ocelot_switchdev_blocking_nb);
 err_switchdev_offload:
 	ocelot_port_bridge_leave(ocelot, port, bridge);
@@ -1214,7 +1214,7 @@ static void ocelot_netdevice_pre_bridge_leave(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 
 	switchdev_bridge_port_unoffload(brport_dev, priv,
-					&ocelot_netdevice_nb,
+					&ocelot_switchdev_nb,
 					&ocelot_switchdev_blocking_nb);
 }
 
-- 
2.33.0

