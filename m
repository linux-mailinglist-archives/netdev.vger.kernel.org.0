Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5713A195F63
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgC0T6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:58:35 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:35406 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgC0T6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 15:58:35 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2020 15:58:34 EDT
Received: from zenbar.fritz.box (pD95EF8FC.dip0.t-ipconnect.de [217.94.248.252])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 3D1C829C49F;
        Fri, 27 Mar 2020 19:50:10 +0000 (UTC)
From:   Daniel Mack <daniel@zonque.org>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
Date:   Fri, 27 Mar 2020 20:51:56 +0100
Message-Id: <20200327195156.1728163-1-daniel@zonque.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On hardware with a speed-reduced link to the CPU port, forcing the MAC
settings won't allow any packets to pass. The PHY will negotiate the
maximum possible speed, so let's allow the MAC to work with whatever
is available.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2f993e673ec7..48808c4add4f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2426,7 +2426,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * state to any particular values on physical ports, but force the CPU
 	 * port and all DSA ports to their maximum bandwidth and full duplex.
 	 */
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
+	if (dsa_is_dsa_port(ds, port))
 		err = mv88e6xxx_port_setup_mac(chip, port, LINK_FORCED_UP,
 					       SPEED_MAX, DUPLEX_FULL,
 					       PAUSE_OFF,
-- 
2.25.1

