Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3305A1DD
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfF1RHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:07:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36880 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfF1RHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:07:38 -0400
Received: from [5.158.153.52] (helo=mitra.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hguLY-0002PZ-Kq; Fri, 28 Jun 2019 19:07:36 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH 1/1] net: dsa: b53: Disable all ports on setup
Date:   Fri, 28 Jun 2019 18:58:11 +0200
Message-Id: <20190628165811.30964-2-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628165811.30964-1-b.spranger@linutronix.de>
References: <20190628165811.30964-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A b53 device may configured through an external EEPROM like the switch
device on the Lamobo R1 router board. The configuration of a port may
therefore differ from the reset configuration of the switch.

The switch configuration reported by the DSA subsystem is different until
the port is configured by DSA i.e. a port can be active, while the DSA
subsystem reports the port is inactive. Disable all ports and not only
the unused ones to put all ports into a well defined state.

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 drivers/net/dsa/b53/b53_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a47f5bc667bd..5127c2fefba9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -962,13 +962,13 @@ static int b53_setup(struct dsa_switch *ds)
 	if (ret)
 		dev_err(ds->dev, "failed to apply configuration\n");
 
-	/* Configure IMP/CPU port, disable unused ports. Enabled
+	/* Configure IMP/CPU port, disable all other ports. Enabled
 	 * ports will be configured with .port_enable
 	 */
 	for (port = 0; port < dev->num_ports; port++) {
 		if (dsa_is_cpu_port(ds, port))
 			b53_enable_cpu_port(dev, port);
-		else if (dsa_is_unused_port(ds, port))
+		else
 			b53_disable_port(ds, port);
 	}
 
-- 
2.20.1

