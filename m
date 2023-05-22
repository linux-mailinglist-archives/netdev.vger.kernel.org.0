Return-Path: <netdev+bounces-4232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A16DB70BCCF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B4D1280F1F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8F0D30B;
	Mon, 22 May 2023 12:01:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17F4BE74
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:01:13 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201A111A;
	Mon, 22 May 2023 05:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684756861; x=1716292861;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hMOSXMNyvb3N9ByVdDgsFv/uLjADIsqKyzVsX4y12vs=;
  b=vhS3TCLfS0fqh+Rzv7jMmfP3i4bKMpyW8gSb4xVYGOi/nsHMWLkJQ45B
   uhJW1lKi8H4m4Q0THJg3T2jBTAPqDdKLzXfrxGi73gFKE2QydpXv/eSwL
   P7V01nWGC/f/ifs7rKuS0JjU63rqWVH+1lZ/Xnmg9uy38qlzl/Tax+f/S
   KLUrJF+SQWOOpJZlS5IcMpGkUvP1IkCoPKRliDykox3VrBVLiEAZg8Eht
   pXfDQNDPjJuV87QTIAKoOzW/6kiPfVKEcBdKnhBQKQ+/yi2HYFisJ0NWP
   qsmYH09qrmrWI7JDAnQ+zhw1lB0Zbuw+/NJN24cL8BRDIjq/iXl0DUxrT
   w==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="212452990"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 05:01:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 05:00:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Mon, 22 May 2023 05:00:56 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net] lan966x: Fix unloading/loading of the driver
Date: Mon, 22 May 2023 14:00:38 +0200
Message-ID: <20230522120038.3749026-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

It was noticing that after a while when unloading/loading the driver and
sending traffic through the switch, it would stop working. It would stop
forwarding any traffic and the only way to get out of this was to do a
power cycle of the board. The root cause seems to be that the switch
core is initialized twice. Apparently initializing twice the switch core
disturbs the pointers in the queue systems in the HW, so after a while
it would stop sending the traffic.
Unfortunetly, it is not possible to use a reset of the switch here,
because the reset line is connected to multiple devices like MDIO,
SGPIO, FAN, etc. So then all the devices will get reseted when the
network driver will be loaded.
So the fix is to check if the core is initialized already and if that is
the case don't initialize it again.

Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 5f01b21acdd1b..f6931dfb3e68e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -1039,6 +1039,16 @@ static int lan966x_reset_switch(struct lan966x *lan966x)
 
 	reset_control_reset(switch_reset);
 
+	/* Don't reinitialize the switch core, if it is already initialized. In
+	 * case it is initialized twice, some pointers inside the queue system
+	 * in HW will get corrupted and then after a while the queue system gets
+	 * full and no traffic is passing through the switch. The issue is seen
+	 * when loading and unloading the driver and sending traffic through the
+	 * switch.
+	 */
+	if (lan_rd(lan966x, SYS_RESET_CFG) & SYS_RESET_CFG_CORE_ENA)
+		return 0;
+
 	lan_wr(SYS_RESET_CFG_CORE_ENA_SET(0), lan966x, SYS_RESET_CFG);
 	lan_wr(SYS_RAM_INIT_RAM_INIT_SET(1), lan966x, SYS_RAM_INIT);
 	ret = readx_poll_timeout(lan966x_ram_init, lan966x,
-- 
2.38.0


