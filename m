Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D4AD9286
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405382AbfJPNdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:33:43 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:36741 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729479AbfJPNdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 09:33:42 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46tYCm31GWz1rD8p;
        Wed, 16 Oct 2019 15:33:39 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46tYCk6zFfz1qqkG;
        Wed, 16 Oct 2019 15:33:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 5G8yBRSIl6nD; Wed, 16 Oct 2019 15:33:37 +0200 (CEST)
X-Auth-Info: E3cMIDfuI8wSQgDXKm31GT9FlWiLchnEw9wRnzsTYSA=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 16 Oct 2019 15:33:37 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH net V3 1/2] net: dsa: microchip: Do not reinit mutexes on KSZ87xx
Date:   Wed, 16 Oct 2019 15:33:23 +0200
Message-Id: <20191016133324.10451-1-marex@denx.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ87xx driver calls mutex_init() on mutexes already inited in
ksz_common.c ksz_switch_register(). Do not do it twice, drop the
reinitialization.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
V2: None
V3: None
---
 drivers/net/dsa/microchip/ksz8795.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index a23d3ffdf0c4..24a5e99f7fd5 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1224,10 +1224,6 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 {
 	int i;
 
-	mutex_init(&dev->stats_mutex);
-	mutex_init(&dev->alu_mutex);
-	mutex_init(&dev->vlan_mutex);
-
 	dev->ds->ops = &ksz8795_switch_ops;
 
 	for (i = 0; i < ARRAY_SIZE(ksz8795_switch_chips); i++) {
-- 
2.23.0

